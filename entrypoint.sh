#!/bin/sh
set -e

SCAN_DIR="${GITHUB_WORKSPACE:-.}"

# If a directory argument is provided, resolve it relative to the workspace
if [ -n "$1" ] && [ "$1" != "." ]; then
  SCAN_DIR="${GITHUB_WORKSPACE:-.}/$1"
fi

echo "Running dummy scanner on: ${SCAN_DIR}"

# Run the scanner in silent mode to capture the count
TOTAL_FILES=$(/dummy-scanner -s "$SCAN_DIR")

echo "Scan complete. Total files found: ${TOTAL_FILES}"

# Set the output for the GitHub Action
echo "total_files=${TOTAL_FILES}" >> "$GITHUB_OUTPUT"
