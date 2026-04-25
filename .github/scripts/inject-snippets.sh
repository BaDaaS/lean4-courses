#!/usr/bin/env bash
# Inject code snippets from .lean files into markdown code blocks.
#
# Markdown syntax:
#   ```lean fromFile:Examples.lean#anchor_name
#   (content replaced by script)
#   ```
#
# Lean file syntax:
#   -- #anchor: anchor_name
#   ... code ...
#   -- #end
#
# Usage:
#   inject-snippets.sh [--check] [file ...]
#
# With --check, exits non-zero if any file would change (for CI).
# Without arguments, processes all README.md files recursively.
set -euo pipefail

check_mode=false
if [[ "${1:-}" == "--check" ]]; then
    check_mode=true
    shift
fi

errors=0
changed=0

# Collect files to process
files=()
if [[ $# -gt 0 ]]; then
    files=("$@")
else
    while IFS= read -r -d '' f; do
        files+=("$f")
    done < <(
        find . -name "README.md" \
            -not -path "./.lake/*" -print0
    )
fi

# Extract anchor content from a lean file.
# Prints lines between -- #anchor: NAME and -- #end.
extract_anchor() {
    local file="$1"
    local anchor="$2"
    local found=false
    local extracting=false

    while IFS= read -r line; do
        if [[ "$extracting" == true ]]; then
            if [[ "$line" == "-- #end" ]]; then
                found=true
                break
            fi
            printf '%s\n' "$line"
        elif [[ "$line" == "-- #anchor: $anchor" ]]; then
            extracting=true
        fi
    done < "$file"

    if [[ "$found" == true ]]; then
        return 0
    fi
    return 1
}

# Process a single markdown file.
process_file() {
    local md_file="$1"
    local md_dir
    md_dir="$(dirname "$md_file")"
    local tmp
    tmp="$(mktemp)"
    local in_block=false

    while IFS= read -r line || [[ -n "$line" ]]; do
        if [[ "$in_block" == true ]]; then
            if [[ "$line" == '```' ]]; then
                in_block=false
                printf '%s\n' "$line" >> "$tmp"
            fi
            continue
        fi

        # Match ```lean fromFile:PATH#ANCHOR
        if [[ "$line" =~ \
            ^\`\`\`lean\ fromFile:([^#]+)#(.+)$ \
        ]]; then
            local ref_path="${BASH_REMATCH[1]}"
            local anchor="${BASH_REMATCH[2]}"
            local full_path="$md_dir/$ref_path"

            printf '%s\n' "$line" >> "$tmp"

            if [[ ! -f "$full_path" ]]; then
                echo \
                    "ERROR: $md_file:" \
                    "file not found: $full_path" >&2
                errors=$((errors + 1))
                in_block=true
                continue
            fi

            if ! extract_anchor \
                "$full_path" "$anchor" >> "$tmp"; then
                echo \
                    "ERROR: $md_file:" \
                    "anchor '$anchor' not found" \
                    "in $ref_path" >&2
                errors=$((errors + 1))
            fi

            in_block=true
            continue
        fi

        printf '%s\n' "$line" >> "$tmp"
    done < "$md_file"

    if ! cmp -s "$tmp" "$md_file"; then
        changed=$((changed + 1))
        if [[ "$check_mode" == true ]]; then
            echo "CHANGED: $md_file" >&2
        else
            cp "$tmp" "$md_file"
            echo "Updated: $md_file"
        fi
    fi
    rm -f "$tmp"
}

for f in "${files[@]}"; do
    process_file "$f"
done

if [[ "$errors" -gt 0 ]]; then
    echo "inject-snippets: $errors error(s)" >&2
    exit 1
fi

if [[ "$check_mode" == true && "$changed" -gt 0 ]]; then
    echo \
        "inject-snippets: $changed file(s) out of date." \
        "Run 'make inject-snippets' to update." >&2
    exit 1
fi

if [[ "$changed" -gt 0 ]]; then
    echo "inject-snippets: updated $changed file(s)."
else
    echo "inject-snippets: all files up to date."
fi
