#!/usr/bin/env bash
set -euo pipefail

file=$(jq -r '.tool_input.file_path // empty')
[[ "$file" == *.java ]] || exit 0

dir=$(dirname "$file")
while [[ "$dir" != "/" && ! -x "$dir/gradlew" ]]; do
  dir=$(dirname "$dir")
done
[[ -x "$dir/gradlew" ]] || exit 0

cd "$dir"
./gradlew test -q --offline 2>&1 | tail -30