#!/bin/bash
# run_all_setup.sh
# Usage: ./run_all_setup.sh <target_directory>

set -e

# Check if the target directory argument is provided
if [ -z "$1" ]; then
    echo "❌ Error: no target directory specified."
    echo "Usage: ./run_all_setup.sh <target_directory>"
    echo "Example: ./run_all_setup.sh ~/summer-school"
    exit 1
fi

TARGET_DIR="$1"

# Create the directory if it doesn't exist (only when argument is given)
mkdir -p "$TARGET_DIR"

dirs=()
for dir in Tutorial_[0-9][0-9]_*/; do
    [ -d "$dir" ] && dirs+=("$dir")
done
total="${#dirs[@]}"
count=0

for dir in "${dirs[@]}"; do
    count=$((count + 1))
    num="${dir#Tutorial_}"
    num="${num%%_*}"
    script="${dir}setup_tutorial_${num}.sh"

    if [ -f "$script" ]; then
        echo "[$count/$total] → Running $script"
        chmod +x "$script"
        # Pass the target directory as an argument to the setup script
        bash "$script" "$TARGET_DIR$dir"
        echo "✅ Finished: $script"
    else
        echo "[$count/$total] ⚠️  No setup script found in $dir"
    fi
done

echo "✔️  All scripts have been executed."