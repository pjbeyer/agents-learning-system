#!/opt/homebrew/bin/bash
#
# find-learnings.sh - Robust script to find all learning files across profiles
#
# Usage:
#   ./find-learnings.sh [OPTIONS]
#
# Options:
#   --summary      Show summary statistics only (default)
#   --list         List all learning files with full paths
#   --unimplemented List only files without "✅ CLOSED LOOP"
#   --implemented  List only files with "✅ CLOSED LOOP"
#   --count        Show counts by profile and category
#   --json         Output results as JSON
#   --help         Show this help message
#
# Examples:
#   ./find-learnings.sh --summary
#   ./find-learnings.sh --unimplemented
#   ./find-learnings.sh --list --json

set -eo pipefail

# Check bash version and warn if ancient
if [ "${BASH_VERSINFO[0]}" -lt 4 ]; then
    echo "⚠️  WARNING: Ancient bash detected (version $BASH_VERSION)" >&2
    echo "This script requires Bash 4.0+ for associative arrays" >&2
    echo "Install modern bash: brew install bash" >&2
    echo "This script uses: /opt/homebrew/bin/bash" >&2
    echo "" >&2
    exit 1
fi

# Base directory
BASE_DIR="/Users/pjbeyer/Projects"

# Profile learning directories (using indexed arrays for ordered iteration)
PROFILE_NAMES=("Global" "pjbeyer" "work" "play" "home")
declare -A PROFILE_DIRS=(
    ["Global"]="$BASE_DIR/docs/continuous-improvement/learnings"
    ["pjbeyer"]="$BASE_DIR/pjbeyer/docs/continuous-improvement/learnings"
    ["work"]="$BASE_DIR/work/docs/continuous-improvement/learnings"
    ["play"]="$BASE_DIR/play/docs/continuous-improvement/learnings"
    ["home"]="$BASE_DIR/home/docs/continuous-improvement/learnings"
)

# Default options
MODE="summary"
OUTPUT_FORMAT="text"

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --summary)
            MODE="summary"
            shift
            ;;
        --list)
            MODE="list"
            shift
            ;;
        --unimplemented)
            MODE="unimplemented"
            shift
            ;;
        --implemented)
            MODE="implemented"
            shift
            ;;
        --count)
            MODE="count"
            shift
            ;;
        --json)
            OUTPUT_FORMAT="json"
            shift
            ;;
        --help|-h)
            grep "^#" "$0" | grep -v "^#!/" | sed 's/^# //' | sed 's/^#//'
            exit 0
            ;;
        *)
            echo "Unknown option: $1" >&2
            echo "Use --help for usage information" >&2
            exit 1
            ;;
    esac
done

# Function to check if a file has CLOSED LOOP marker
has_closed_loop() {
    local file="$1"
    grep -q "✅ CLOSED LOOP" "$file" 2>/dev/null
}

# Function to find all learning files in a directory
find_learning_files() {
    local dir="$1"
    if [ -d "$dir" ]; then
        find "$dir" -name "*.md" -type f 2>/dev/null | sort
    fi
}

# Function to extract category from file path
get_category() {
    local file="$1"
    local base="$2"
    # Extract the subdirectory name (e.g., "mcp-patterns", "workflows", "agents")
    local rel_path="${file#$base/}"
    local category="${rel_path%%/*}"
    echo "$category"
}

# Collect all files
declare -A ALL_FILES
declare -A FILE_COUNTS
declare -A IMPLEMENTED_COUNTS
declare -A UNIMPLEMENTED_COUNTS

# Initialize all counts to 0
for profile in "${PROFILE_NAMES[@]}"; do
    FILE_COUNTS[$profile]=0
    IMPLEMENTED_COUNTS[$profile]=0
    UNIMPLEMENTED_COUNTS[$profile]=0
done

for profile in "${PROFILE_NAMES[@]}"; do
    dir="${PROFILE_DIRS[$profile]}"

    if [ ! -d "$dir" ]; then
        continue
    fi

    files=$(find_learning_files "$dir")

    total=0
    implemented=0
    unimplemented=0

    while IFS= read -r file; do
        if [ -n "$file" ]; then
            total=$((total + 1))
            ALL_FILES["$profile|$file"]="1"

            if has_closed_loop "$file"; then
                implemented=$((implemented + 1))
            else
                unimplemented=$((unimplemented + 1))
            fi
        fi
    done <<< "$files"

    FILE_COUNTS[$profile]=$total
    IMPLEMENTED_COUNTS[$profile]=$implemented
    UNIMPLEMENTED_COUNTS[$profile]=$unimplemented
done

# Output functions
output_summary() {
    echo "=== Learning Files Summary ==="
    echo ""

    local grand_total=0
    local grand_implemented=0
    local grand_unimplemented=0

    for profile in "${PROFILE_NAMES[@]}"; do
        local total=${FILE_COUNTS[$profile]}
        local implemented=${IMPLEMENTED_COUNTS[$profile]}
        local unimplemented=${UNIMPLEMENTED_COUNTS[$profile]}
        local dir="${PROFILE_DIRS[$profile]}"

        grand_total=$((grand_total + total))
        grand_implemented=$((grand_implemented + implemented))
        grand_unimplemented=$((grand_unimplemented + unimplemented))

        if [ -d "$dir" ]; then
            echo "$profile: $total files ($implemented implemented, $unimplemented unimplemented)"
        else
            echo "$profile: Directory not found"
        fi
    done

    echo ""
    echo "Total: $grand_total files ($grand_implemented implemented, $grand_unimplemented unimplemented)"
}

output_list() {
    local filter="$1"  # "all", "implemented", or "unimplemented"

    for profile in "${PROFILE_NAMES[@]}"; do
        local dir="${PROFILE_DIRS[$profile]}"

        if [ ! -d "$dir" ]; then
            continue
        fi

        echo "=== $profile ==="

        local files=$(find_learning_files "$dir")
        local found=false

        while IFS= read -r file; do
            if [ -n "$file" ]; then
                case $filter in
                    implemented)
                        if has_closed_loop "$file"; then
                            echo "$file"
                            found=true
                        fi
                        ;;
                    unimplemented)
                        if ! has_closed_loop "$file"; then
                            echo "$file"
                            found=true
                        fi
                        ;;
                    all)
                        echo "$file"
                        found=true
                        ;;
                esac
            fi
        done <<< "$files"

        if [ "$found" = false ]; then
            echo "(none)"
        fi

        echo ""
    done
}

output_count() {
    echo "=== Learning Files by Category ==="
    echo ""

    for profile in "${PROFILE_NAMES[@]}"; do
        local dir="${PROFILE_DIRS[$profile]}"

        if [ ! -d "$dir" ]; then
            continue
        fi

        echo "--- $profile ---"

        declare -A category_counts

        local files=$(find_learning_files "$dir")

        while IFS= read -r file; do
            if [ -n "$file" ]; then
                local category=$(get_category "$file" "$dir")
                category_counts[$category]=$((${category_counts[$category]:-0} + 1))
            fi
        done <<< "$files"

        if [ ${#category_counts[@]} -eq 0 ]; then
            echo "  (no files)"
        else
            for category in "${!category_counts[@]}"; do
                echo "  $category: ${category_counts[$category]} files"
            done | sort
        fi

        echo ""
        unset category_counts
    done
}

output_json() {
    local filter="$1"  # "all", "implemented", or "unimplemented"

    local total=0
    local implemented=0
    local unimplemented=0

    for profile in "${PROFILE_NAMES[@]}"; do
        total=$((total + FILE_COUNTS[$profile]))
        implemented=$((implemented + IMPLEMENTED_COUNTS[$profile]))
        unimplemented=$((unimplemented + UNIMPLEMENTED_COUNTS[$profile]))
    done

    echo "{"
    echo "  \"summary\": {"
    echo "    \"total\": $total,"
    echo "    \"implemented\": $implemented,"
    echo "    \"unimplemented\": $unimplemented"
    echo "  },"
    echo "  \"profiles\": {"

    local first_profile=true
    for profile in "${PROFILE_NAMES[@]}"; do
        local dir="${PROFILE_DIRS[$profile]}"

        if [ "$first_profile" = true ]; then
            first_profile=false
        else
            echo ","
        fi

        echo -n "    \"$profile\": {"
        echo -n "\"total\": ${FILE_COUNTS[$profile]},"
        echo -n "\"implemented\": ${IMPLEMENTED_COUNTS[$profile]},"
        echo -n "\"unimplemented\": ${UNIMPLEMENTED_COUNTS[$profile]},"
        echo -n "\"files\": ["

        if [ -d "$dir" ]; then
            local files=$(find_learning_files "$dir")
            local first_file=true

            while IFS= read -r file; do
                if [ -n "$file" ]; then
                    local include=false
                    case $filter in
                        implemented)
                            has_closed_loop "$file" && include=true
                            ;;
                        unimplemented)
                            has_closed_loop "$file" || include=true
                            ;;
                        all)
                            include=true
                            ;;
                    esac

                    if [ "$include" = true ]; then
                        if [ "$first_file" = true ]; then
                            first_file=false
                        else
                            echo -n ","
                        fi
                        local status="unimplemented"
                        has_closed_loop "$file" && status="implemented"
                        echo -n "{\"path\":\"$file\",\"status\":\"$status\"}"
                    fi
                fi
            done <<< "$files"
        fi

        echo -n "]}"
    done

    echo ""
    echo "  }"
    echo "}"
}

# Main execution
case $MODE in
    summary)
        if [ "$OUTPUT_FORMAT" = "json" ]; then
            output_json "all"
        else
            output_summary
        fi
        ;;
    list)
        if [ "$OUTPUT_FORMAT" = "json" ]; then
            output_json "all"
        else
            output_list "all"
        fi
        ;;
    unimplemented)
        if [ "$OUTPUT_FORMAT" = "json" ]; then
            output_json "unimplemented"
        else
            output_list "unimplemented"
        fi
        ;;
    implemented)
        if [ "$OUTPUT_FORMAT" = "json" ]; then
            output_json "implemented"
        else
            output_list "implemented"
        fi
        ;;
    count)
        output_count
        ;;
esac

exit 0
