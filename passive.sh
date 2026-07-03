#!/usr/bin/env bash

if [[ $# -ne 3 ]]; then
    echo "Usage: $0 <domain> <subs_file> <alive_file>"
    echo
    echo "Example:"
    echo "  $0 snapp.ir subs.txt alive.txt"
    exit 1
fi

DOMAIN="$1"
SUBS="$2"
ALIVE="$3"

> "$SUBS"
> "$ALIVE"

START=$(date +%s)

show_status() {
    local STATUS="$1"
    local BAR="$2"
    local PERCENT="$3"

    clear

    NOW=$(date +%s)
    ELAPSED=$((NOW-START))

    printf "══════════════════════════════════════════════\n"
    printf "           Ultimate Passive Recon\n"
    printf "══════════════════════════════════════════════\n\n"

    printf "Target   : %s\n" "$DOMAIN"
    printf "Status   : %s\n" "$STATUS"
    printf "Progress : %s %d%%\n\n" "$BAR" "$PERCENT"

    printf "Elapsed  : %02d:%02d\n" $((ELAPSED/60)) $((ELAPSED%60))
    printf "Found    : %s Subdomains\n" "$(wc -l < "$SUBS")"
}

show_status "Running Subfinder" "███░░░░░░░░░░░░░░░░" 16
subfinder -d "$DOMAIN" -all -silent | anew "$SUBS" >/dev/null 2>&1

show_status "Running Amass" "██████░░░░░░░░░░░░" 32
amass enum -passive -d "$DOMAIN" | anew "$SUBS" >/dev/null 2>&1

show_status "Running Assetfinder" "█████████░░░░░░░░░" 48
assetfinder -subs-only "$DOMAIN" | anew "$SUBS" >/dev/null 2>&1

show_status "Running Chaos" "████████████░░░░░░" 64
chaos -d "$DOMAIN" -silent | anew "$SUBS" >/dev/null 2>&1

show_status "Running Findomain" "███████████████░░░" 80
findomain -t "$DOMAIN" -q | anew "$SUBS" >/dev/null 2>&1

sort -u "$SUBS" -o "$SUBS"

show_status "Running HTTPX" "██████████████████░" 95
httpx \
    -silent \
    -threads 200 \
    -status-code \
    -title \
    < "$SUBS" | anew "$ALIVE" >/dev/null 2>&1

show_status "Completed" "████████████████████" 100

echo
echo
echo "══════════════════════════════════════════════"
echo "              Recon Completed"
echo "══════════════════════════════════════════════"
echo
echo "Target      : $DOMAIN"
echo "Subdomains  : $(wc -l < "$SUBS")"
echo "Alive Hosts : $(wc -l < "$ALIVE")"
echo
echo "Output Files"
echo "-------------"
echo "Subdomains : $SUBS"
echo "Alive      : $ALIVE"
echo
echo "Done."
