#!/opt/homebrew/bin/bash
#
# find-learnings.sh - Robust script to find all learning files across profiles
#
# Searches both profile-level and project-level learning directories:
#   - Profile: ~/Projects/{profile}/.workflow/docs/continuous-improvement/learnings/
#   - Project: ~/Projects/work/{project}/docs/continuous-improvement/learnings/
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
    ["Global"]="$BASE_DIR/.workflow/docs/continuous-improvement/learnings"
    ["pjbeyer"]="$BASE_DIR/pjbeyer/.workflow/docs/continuous-improvement/learnings"
    ["work"]="$BASE_DIR/work/.workflow/docs/continuous-improvement/learnings"
    ["play"]="$BASE_DIR/play/.workflow/docs/continuous-improvement/learnings"
    ["home"]="$BASE_DIR/home/.workflow/docs/continuous-improvement/learnings"
)

# Dynamically discover work project-level learning directories
# These are projects within ~/Projects/work/ that have their own learnings
declare -a WORK_PROJECT_NAMES=()
declare -A WORK_PROJECT_DIRS=()

discover_work_projects() {
    local work_dir="$BASE_DIR/work"
    if [ -d "$work_dir" ]; then
        # Find all project directories with learnings (excluding .workflow which is profile-level)
        while IFS= read -r learnings_dir; do
            if [ -n "$learnings_dir" ]; then
                # Extract project name from path like /Users/.../work/manager-agents/docs/...
                local project_path="${learnings_dir#$work_dir/}"
                local project_name="${project_path%%/*}"

                # Skip if it's the .workflow directory (profile-level)
                if [ "$project_name" != ".workflow" ]; then
                    # Create a display name like "work/manager-agents"
                    local display_name="work/$project_name"
                    WORK_PROJECT_NAMES+=("$display_name")
                    WORK_PROJECT_DIRS["$display_name"]="$learnings_dir"
                fi
            fi
        done < <(find "$work_dir" -type d -path "*/docs/continuous-improvement/learnings" 2>/dev/null | sort -u)
    fi
}

# Run discovery
discover_work_projects

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
# Note: Looks for date-stamped format to avoid false positives from template text
has_closed_loop() {
    local file="$1"
    # Match "✅ CLOSED LOOP - 2025-11-15" format (actual implementation)
    # Must have: "## " header prefix + emoji + " CLOSED LOOP - " + valid date
    # Avoids matching examples like "## ✅ CLOSED LOOP - [Date]" in documentation
    grep -qE "^## ✅ CLOSED LOOP - [0-9]{4}-[0-9]{2}-[0-9]{2}" "$file" 2>/dev/null
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

# Combined list of all sources (profiles + work projects)
ALL_SOURCES=("${PROFILE_NAMES[@]}" "${WORK_PROJECT_NAMES[@]}")

# Function to get directory for a source
get_source_dir() {
    local source="$1"
    if [[ -v PROFILE_DIRS[$source] ]]; then
        echo "${PROFILE_DIRS[$source]}"
    elif [[ -v WORK_PROJECT_DIRS[$source] ]]; then
        echo "${WORK_PROJECT_DIRS[$source]}"
    fi
}

# Initialize all counts to 0
for source in "${ALL_SOURCES[@]}"; do
    FILE_COUNTS[$source]=0
    IMPLEMENTED_COUNTS[$source]=0
    UNIMPLEMENTED_COUNTS[$source]=0
done

for source in "${ALL_SOURCES[@]}"; do
    dir=$(get_source_dir "$source")

    if [ -z "$dir" ] || [ ! -d "$dir" ]; then
        continue
    fi

    files=$(find_learning_files "$dir")

    total=0
    implemented=0
    unimplemented=0

    while IFS= read -r file; do
        if [ -n "$file" ]; then
            total=$((total + 1))
            ALL_FILES["$source|$file"]="1"

            if has_closed_loop "$file"; then
                implemented=$((implemented + 1))
            else
                unimplemented=$((unimplemented + 1))
            fi
        fi
    done <<< "$files"

    FILE_COUNTS[$source]=$total
    IMPLEMENTED_COUNTS[$source]=$implemented
    UNIMPLEMENTED_COUNTS[$source]=$unimplemented
done

# Output functions
output_summary() {
    echo "=== Learning Files Summary ==="
    echo ""

    local grand_total=0
    local grand_implemented=0
    local grand_unimplemented=0
    local profile_total=0
    local project_total=0

    # First show profile-level summaries
    echo "--- Profile Level ---"
    for profile in "${PROFILE_NAMES[@]}"; do
        local total=${FILE_COUNTS[$profile]}
        local implemented=${IMPLEMENTED_COUNTS[$profile]}
        local unimplemented=${UNIMPLEMENTED_COUNTS[$profile]}
        local dir=$(get_source_dir "$profile")

        grand_total=$((grand_total + total))
        profile_total=$((profile_total + total))
        grand_implemented=$((grand_implemented + implemented))
        grand_unimplemented=$((grand_unimplemented + unimplemented))

        if [ -d "$dir" ]; then
            echo "$profile: $total files ($implemented implemented, $unimplemented unimplemented)"
        else
            echo "$profile: Directory not found"
        fi
    done

    # Then show project-level summaries if any exist
    if [ ${#WORK_PROJECT_NAMES[@]} -gt 0 ]; then
        echo ""
        echo "--- Project Level (work) ---"
        for project in "${WORK_PROJECT_NAMES[@]}"; do
            local total=${FILE_COUNTS[$project]}
            local implemented=${IMPLEMENTED_COUNTS[$project]}
            local unimplemented=${UNIMPLEMENTED_COUNTS[$project]}
            local dir=$(get_source_dir "$project")

            grand_total=$((grand_total + total))
            project_total=$((project_total + total))
            grand_implemented=$((grand_implemented + implemented))
            grand_unimplemented=$((grand_unimplemented + unimplemented))

            if [ -d "$dir" ]; then
                echo "$project: $total files ($implemented implemented, $unimplemented unimplemented)"
            fi
        done
    fi

    echo ""
    echo "Total: $grand_total files ($grand_implemented implemented, $grand_unimplemented unimplemented)"
    if [ $project_total -gt 0 ]; then
        echo "  (Profile: $profile_total, Project: $project_total)"
    fi
}

output_list() {
    local filter="$1"  # "all", "implemented", or "unimplemented"

    for source in "${ALL_SOURCES[@]}"; do
        local dir=$(get_source_dir "$source")

        if [ -z "$dir" ] || [ ! -d "$dir" ]; then
            continue
        fi

        echo "=== $source ==="

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

    for source in "${ALL_SOURCES[@]}"; do
        local dir=$(get_source_dir "$source")

        if [ -z "$dir" ] || [ ! -d "$dir" ]; then
            continue
        fi

        echo "--- $source ---"

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

    for source in "${ALL_SOURCES[@]}"; do
        total=$((total + FILE_COUNTS[$source]))
        implemented=$((implemented + IMPLEMENTED_COUNTS[$source]))
        unimplemented=$((unimplemented + UNIMPLEMENTED_COUNTS[$source]))
    done

    echo "{"
    echo "  \"summary\": {"
    echo "    \"total\": $total,"
    echo "    \"implemented\": $implemented,"
    echo "    \"unimplemented\": $unimplemented"
    echo "  },"
    echo "  \"sources\": {"

    local first_source=true
    for source in "${ALL_SOURCES[@]}"; do
        local dir=$(get_source_dir "$source")

        if [ "$first_source" = true ]; then
            first_source=false
        else
            echo ","
        fi

        echo -n "    \"$source\": {"
        echo -n "\"total\": ${FILE_COUNTS[$source]},"
        echo -n "\"implemented\": ${IMPLEMENTED_COUNTS[$source]},"
        echo -n "\"unimplemented\": ${UNIMPLEMENTED_COUNTS[$source]},"
        echo -n "\"files\": ["

        if [ -n "$dir" ] && [ -d "$dir" ]; then
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
