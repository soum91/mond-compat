#!/usr/bin/env bash
# Read-only firmware inspection. Runs on an ephemeral macOS CI runner, never on a phone.
set -euo pipefail

research_workspace="${RUNNER_TEMP:?This analysis must run in a CI runner with RUNNER_TEMP set}/mond-ipados-research"
report_dir="${GITHUB_WORKSPACE:?GITHUB_WORKSPACE is required}/ipados-research-results"
mkdir -p "${research_workspace}/caches" "${research_workspace}/dylibs" "${report_dir}"

report="${report_dir}/summary.txt"
{
  echo 'mond-compat: iPadOS 27.0.1 system UI read-only investigation'
  echo 'Target: iPhone18,3, iOS 27.0.1, build 24A446'
  echo 'Scope: offline dyld shared cache inspection only; no on-device modifications.'
  echo "ipsw: $(ipsw version 2>&1 | head -1)"
  echo
} > "${report}"

if ! ipsw download ipsw \
  --device iPhone18,3 \
  --version 27.0.1 \
  --dyld \
  --confirm \
  --output "${research_workspace}/caches" \
  > "${report_dir}/download.log" 2>&1; then
  echo 'ERROR: Partial dyld cache extraction failed. See download.log.' >> "${report}"
  exit 1
fi

caches=()
# GitHub macOS runners still ship Bash 3.2, which does not have mapfile.
while IFS= read -r cache; do
  caches+=("${cache}")
done < <(find "${research_workspace}/caches" -type f \
  \( -name 'dyld_shared_cache_arm64e' -o -name 'dyld_shared_cache_arm64e_x1' \) -print | sort)
if ((${#caches[@]} == 0)); then
  echo 'ERROR: No main arm64e shared cache found after extraction.' >> "${report}"
  find "${research_workspace}/caches" -type f | sed "s|${research_workspace}/caches/||" >> "${report}"
  exit 1
fi

images=(
  'SystemStatusUI'
  'SpringBoardFoundation'
  'PosterFoundation'
  'UIKitCore'
  'FrontBoardServices'
)

for cache in "${caches[@]}"; do
  base="$(basename "${cache}")"
  echo "CACHE: ${base}" >> "${report}"
  ipsw dyld info "${cache}" > "${report_dir}/${base}-info.log" 2>&1 || true

  for target in "${images[@]}"; do
    safe_target="${base}-${target}"
    # Extracting only named images avoids distributing Apple's binary files.
    if ipsw dyld extract "${cache}" "${target}" \
      --output "${research_workspace}/dylibs" \
      > "${report_dir}/${safe_target}-extract.log" 2>&1; then
      echo "IMAGE: ${target}: extraction succeeded" >> "${report}"
    else
      echo "IMAGE: ${target}: unavailable in ${base} or extraction failed" >> "${report}"
    fi
  done
done

{
  echo
  echo 'RESEARCH STRINGS (presence is not proof of a callable override):'
} >> "${report}"

string_pattern='STUIStatusBar|SystemStatusUI|statusBarClass|StatusBarOverrides|SpeakeasyNewStatusBar|PFCurrentDeviceClass|DeviceClassNumber|MenuBar|windowedApps|StageManager|stageManager|DynamicSplitSmallIsland|displayCornerRadius|HomeScreen|LockScreen'

while IFS= read -r -d '' dylib; do
  label="${dylib#${research_workspace}/dylibs/}"
  echo "== ${label} ==" >> "${report}"
  strings -a "${dylib}" | grep -Ei "${string_pattern}" | sort -u | head -150 >> "${report}" || true
done < <(find "${research_workspace}/dylibs" -type f -print0)

{
  echo
  echo 'LIMITATIONS:'
  echo 'Strings are leads only. A safe hybrid change requires verified control-flow and permissions analysis.'
  echo 'Class-1+5/5 flags lost iPad windowing in the user test; class-3+5/5 restored it with the iPad status bar.'
  echo 'No system library, preference, or MobileGestalt file has been modified by this workflow.'
} >> "${report}"

# Keep only text in the artifact. Decrypted Apple frameworks stay ephemeral.
find "${report_dir}" -type f -name '*-info.log' -size +2M -delete
