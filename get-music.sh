#!/usr/bin/env bash
# Download audio into the microSD staging folder as mp3, ready to go on the card.
# Apple extended attributes are cleared on the way out, because FAT32 cannot hold
# them and anything carrying one lands on the card with a ._name file beside it.
# ID3 tags are left alone.
#
# Usage:
#   ./get-music.sh 'https://www.youtube.com/watch?v=...&list=...'
#   ./get-music.sh -n URL            # list the playlist, download nothing
#   ./get-music.sh -i 6 URL          # just track 6
#
# Requires: yt-dlp, ffmpeg (brew install yt-dlp ffmpeg)

set -euo pipefail

dest="${MP3CARD_DIR:-$HOME/Music/mp3card}"
card="${MP3CARD_VOLUME:-/Volumes/MP3S}"
items=
dry=0
single=0
embed=0

usage() {
  cat <<EOF
usage: $(basename "$0") [-o DIR] [-i ITEMS] [-n] [-1] [-m] URL [URL ...]

  -o DIR     where the mp3s go, default $dest
  -i ITEMS   playlist positions to take, e.g. 6 or 1-10 or 1,4,9
  -n         dry run, print the track list and download nothing
  -1         take only the linked video, not the playlist it belongs to
  -m         write title and artist ID3 tags, YouTube sources carry none

A watch?v=...&list=... URL pulls the whole playlist, because yt-dlp follows the
list parameter whether or not &index= is on the end. Public domain example:

  $(basename "$0") 'https://www.youtube.com/watch?v=Y0t-RqjMH-A&list=PL4A1446D924B9C895'

Then put it on the card:

  rsync -rt --delete $dest/ $card/
  dot_clean -m $card && diskutil eject $card
EOF
}

while getopts ':o:i:n1mh' opt; do
  case $opt in
    o) dest=$OPTARG ;;
    i) items=$OPTARG ;;
    n) dry=1 ;;
    1) single=1 ;;
    m) embed=1 ;;
    h) usage; exit 0 ;;
    :) echo "-$OPTARG needs a value" >&2; usage >&2; exit 1 ;;
    ?) echo "unknown option: -$OPTARG" >&2; usage >&2; exit 1 ;;
  esac
done
shift $((OPTIND - 1))

[[ $# -gt 0 ]] || { echo "no URL given" >&2; usage >&2; exit 1; }

command -v yt-dlp >/dev/null || { echo "yt-dlp not found: brew install yt-dlp" >&2; exit 1; }
command -v ffmpeg >/dev/null || { echo "ffmpeg not found: brew install ffmpeg" >&2; exit 1; }

# Numbered while the URL is a playlist, bare title when it is one video. Restricted
# names drop the fullwidth quotes and colons YouTube titles carry, which keeps them
# readable on a FAT32 card and on a player that only speaks ASCII.
template='%(playlist_index&{:02d}-|)s%(title)s.%(ext)s'

opts=(--no-warnings --restrict-filenames)
(( single )) && opts+=(--no-playlist)
(( embed ))  && opts+=(--embed-metadata)
[[ -n $items ]] && opts+=(--playlist-items "$items")

if (( dry )); then
    yt-dlp "${opts[@]}" --flat-playlist \
        --print '%(playlist_index&{:02d}|--)s  %(duration>%H:%M:%S)s  %(title)s' "$@"
    exit 0
fi

mkdir -p "$dest"
before=$(find "$dest" -type f -name '*.mp3' | wc -l | tr -d ' ')

yt-dlp "${opts[@]}" -x --audio-format mp3 -o "$dest/$template" "$@"

# Cleared here rather than at copy time, so the staging folder is always in a
# state that can go straight onto the card.
xattr -cr "$dest"

after=$(find "$dest" -type f -name '*.mp3' | wc -l | tr -d ' ')
printf '\n%s\n' "$((after - before)) new, $after mp3 in $dest ($(du -sh "$dest" | cut -f1))"
printf '%s\n' "copy to the card with: rsync -rt --delete $dest/ $card/"
