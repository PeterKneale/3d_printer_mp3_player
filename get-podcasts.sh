#!/usr/bin/env bash
# Download the latest podcast episodes into the microSD staging folder, numbered so
# the newest one plays first. The player walks the card in name order, so 01 is the
# most recent episode and the number climbs as the episodes get older.
# Apple extended attributes are cleared on the way out for the same reason as in
# get-music.sh: FAT32 cannot hold them and each one lands as a ._name file.
#
# Usage:
#   ./get-podcasts.sh                # last 10 of The Daily
#   ./get-podcasts.sh -n             # list what it would fetch, download nothing
#   ./get-podcasts.sh -c 5           # last 5
#   ./get-podcasts.sh -p             # drop episodes that fell out of the window
#   ./get-podcasts.sh FEED_URL       # any other RSS feed
#
# Requires: curl, python3

set -euo pipefail

# https://www.nytimes.com/column/the-daily is a web page. This is the feed behind it.
feed='https://feeds.simplecast.com/54nAGcIl'
dest="${MP3CARD_DIR:-$HOME/Music/mp3card}/podcasts"
card="${MP3CARD_VOLUME:-/Volumes/MP3S}"
count=10
dry=0
prune=0

usage() {
  cat <<EOF
usage: $(basename "$0") [-o DIR] [-c COUNT] [-n] [-p] [FEED_URL]

  -o DIR     where the mp3s go, default $dest
  -c COUNT   how many of the most recent episodes to keep, default $count
  -n         dry run, print the episode list and download nothing
  -p         delete episodes already on disk that fall outside COUNT

Files are named NN-YYYY-MM-DD-title.mp3 with 01 as the newest, so a player that
sorts by filename plays the freshest episode first. Every run renumbers the folder.
Episodes older than COUNT are kept and numbered after it unless -p is given.

Then put it on the card:

  rsync -rt --delete $dest/ $card/podcasts/
  dot_clean -m $card && diskutil eject $card
EOF
}

while getopts ':o:c:nph' opt; do
  case $opt in
    o) dest=$OPTARG ;;
    c) count=$OPTARG ;;
    n) dry=1 ;;
    p) prune=1 ;;
    h) usage; exit 0 ;;
    :) echo "-$OPTARG needs a value" >&2; usage >&2; exit 1 ;;
    ?) echo "unknown option: -$OPTARG" >&2; usage >&2; exit 1 ;;
  esac
done
shift $((OPTIND - 1))

[[ $count =~ ^[0-9]+$ && $count -gt 0 ]] || { echo "-c needs a positive number" >&2; exit 1; }
[[ $# -gt 0 ]] && feed=$1

command -v curl >/dev/null || { echo "curl not found" >&2; exit 1; }
command -v python3 >/dev/null || { echo "python3 not found" >&2; exit 1; }

work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT

curl -fsSL --retry 3 --max-time 120 "$feed" -o "$work/feed.xml" \
  || { echo "could not fetch $feed" >&2; exit 1; }

# Sorted by publication date here rather than trusting feed order, which is
# newest first by convention only.
python3 - "$work/feed.xml" "$count" <<'PY' > "$work/list.tsv"
import email.utils, re, sys, xml.etree.ElementTree as ET

path, count = sys.argv[1], int(sys.argv[2])
channel = ET.parse(path).getroot().find('channel')
if channel is None:
    sys.exit('not an RSS feed')

def slug(text):
    return re.sub(r'[^a-z0-9]+', '-', text.lower()).strip('-')[:60].strip('-')

rows = []
for item in channel.findall('item'):
    enclosure = item.find('enclosure')
    url = enclosure.get('url') if enclosure is not None else None
    published = item.findtext('pubDate')
    if not url or not published:
        continue
    when = email.utils.parsedate_to_datetime(published)
    rows.append((when, slug(item.findtext('title') or 'episode') or 'episode', url))

rows.sort(key=lambda r: r[0], reverse=True)
for when, name, url in rows[:count]:
    print('\t'.join([when.strftime('%Y-%m-%d'), name, url]))
PY

[[ -s $work/list.tsv ]] || { echo "no episodes with audio in $feed" >&2; exit 1; }

if (( dry )); then
  n=0
  while IFS=$'\t' read -r date name url; do
    printf '%02d  %s  %s\n' "$((++n))" "$date" "$name"
  done < "$work/list.tsv"
  exit 0
fi

mkdir -p "$dest"

# Strip the numbers before assigning new ones, so an episode moving from 01 to 02
# never has to overwrite the file already sitting at 02.
for f in "$dest"/[0-9][0-9]-*.mp3; do
  [[ -e $f ]] || continue
  base=$(basename "$f")
  mv -f "$f" "$dest/${base#[0-9][0-9]-}"
done

n=0
new=0
while IFS=$'\t' read -r date name url; do
  n=$((n + 1))
  stem="$date-$name"
  if [[ ! -f "$dest/$stem.mp3" ]]; then
    printf '%02d  %s  %s\n' "$n" "$date" "$name"
    curl -fL# --retry 3 "$url" -o "$work/download.mp3"
    mv -f "$work/download.mp3" "$dest/$stem.mp3"
    new=$((new + 1))
  fi
  mv -f "$dest/$stem.mp3" "$dest/$(printf '%02d' "$n")-$stem.mp3"
done < "$work/list.tsv"

# Whatever is still unnumbered fell out of the window on this run.
dropped=0
while IFS= read -r f; do
  [[ -n $f ]] || continue
  if (( prune )); then
    rm -f "$f"
  else
    n=$((n + 1))
    mv -f "$f" "$dest/$(printf '%02d' "$n")-$(basename "$f")"
  fi
  dropped=$((dropped + 1))
done < <(find "$dest" -maxdepth 1 -type f -name '*.mp3' ! -name '[0-9][0-9]-*' | sort -r)

# Cleared here rather than at copy time, so the staging folder is always in a
# state that can go straight onto the card.
xattr -cr "$dest"

total=$(find "$dest" -maxdepth 1 -type f -name '*.mp3' | wc -l | tr -d ' ')
if (( prune )); then
  printf '\n%s\n' "$new new, $dropped removed, $total episodes in $dest ($(du -sh "$dest" | cut -f1))"
else
  printf '\n%s\n' "$new new, $dropped older kept, $total episodes in $dest ($(du -sh "$dest" | cut -f1))"
fi
printf '%s\n' "copy to the card with: rsync -rt --delete $dest/ $card/podcasts/"
