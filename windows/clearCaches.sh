#!/bin/bash

# Advanced Cache Cleaner Script v3.5
# Features: Robust error handling, detailed diagnostics, permission management

# Configuration
DRY_RUN=false
TOTAL_STEPS=5
CURRENT_STEP=0
STATUS_COLOR="\033[1;93m"  # Yellow for status
SUCCESS_COLOR="\033[1;92m" # Green for success
ERROR_COLOR="\033[1;91m"   # Red for errors
INFO_COLOR="\033[1;96m"    # Cyan for information
RESET_COLOR="\033[0m"

# Path declarations (Windows format with safety checks)
declare -A CLEAN_PATHS=(
    ["User Temporary Files"]="C:/Users/1/AppData/Local/Temp/*"
    ["Prefetch Caches"]="C:/Windows/Prefetch/*"
    ["System Temporary Files"]="C:/Windows/Temp/*"
    ["Windows Update Caches"]="C:/Windows/SoftwareDistribution/Download/*"
    ["Error Reporting Caches"]="C:/ProgramData/Microsoft/Windows/WER/ReportQueue/*"
)

# Initialize terminal
init_terminal() {
    clear
    echo -e "${STATUS_COLOR}"
    echo "╔══════════════════════════════════════════════╗"
    echo "║           Advanced Cache Cleaner v3.5        ║"
    echo "║     Optimizing your system performance...    ║"
    echo "╚══════════════════════════════════════════════╝"
    echo -e "${RESET_COLOR}"
    echo -e "Dry Run Mode: $([ "$DRY_RUN" = true ] && echo "Enabled" || echo "Disabled")"
    echo "──────────────────────────────────────────────"
}

# Progress display
show_progress() {
    ((CURRENT_STEP++))
    local percent=$((CURRENT_STEP * 100 / TOTAL_STEPS))
    local bar=""
    local progress=$((percent * 30 / 100))
    
    # Create progress bar
    for ((i=0; i<progress; i++)); do bar+="▓"; done
    for ((i=progress; i<30; i++)); do bar+="░"; done
    
    echo -e "\n${STATUS_COLOR}Step ${CURRENT_STEP}/${TOTAL_STEPS} [${bar}] ${percent}% Complete${RESET_COLOR}"
}

# Size calculator
format_size() {
    local bytes=$1
    if ((bytes >= 1000000000)); then
        printf "%.2f GB" $(bc <<< "scale=2; $bytes/1073741824")
    elif ((bytes >= 1000000)); then
        printf "%.2f MB" $(bc <<< "scale=2; $bytes/1048576")
    elif ((bytes >= 1000)); then
        printf "%.2f KB" $(bc <<< "scale=2; $bytes/1024")
    else
        printf "%d bytes" "$bytes"
    fi
}

# Check if file is in use (Windows-specific)
is_file_in_use() {
    local file="$1"
    # Attempt to move the file to detect locks
    if ! mv -f "$file" "$file" 2>/dev/null; then
        return 0 # File is in use
    fi
    return 1 # File is not in use
}

# Enhanced directory cleaner with detailed diagnostics
clean_directory() {
    local path_pattern="$1"
    local name="$2"
    local base_dir="${path_pattern%%\*}"
    local file_count=0
    local total_size=0
    local deleted_count=0
    local deleted_size=0
    local error_count=0
    local skipped_count=0
    local protected_count=0
    local inuse_count=0
    
    echo -e "\n${INFO_COLOR}Processing: $name${RESET_COLOR}"
    echo -e "  Location: ${base_dir}"
    
    # Check if directory exists
    if [ ! -d "$base_dir" ]; then
        echo -e "  ${ERROR_COLOR}✗ Directory not found${RESET_COLOR}"
        echo -e "  ${INFO_COLOR}Recommendation: Verify path or create directory${RESET_COLOR}"
        return
    fi

    # Create file list safely
    local file_list=()
    while IFS= read -r -d $'\0'; do
        file_list+=("$REPLY")
    done < <(find "$base_dir" -mindepth 1 -print0 2>/dev/null)
    
    # Process files
    for target in "${file_list[@]}"; do
        # Skip root directory
        [[ "$target" == "$base_dir" ]] && continue
        
        # Get file size
        local size=0
        if [ -f "$target" ]; then
            size=$(stat -c%s "$target" 2>/dev/null || echo 0)
            ((total_size += size))
            ((file_count++))
        fi

        # Check protection status
        if [[ ! -w "$target" ]]; then
            echo -e "  ${STATUS_COLOR}⚠ Protected: ${target//$base_dir\//}${RESET_COLOR}"
            ((protected_count++))
            ((skipped_count++))
            continue
        fi
        
        # Check if file is in use
        if [ -f "$target" ] && is_file_in_use "$target"; then
            echo -e "  ${STATUS_COLOR}⚠ In Use: ${target//$base_dir\//}${RESET_COLOR}"
            ((inuse_count++))
            ((skipped_count++))
            continue
        fi

        # Perform deletion
        if [ "$DRY_RUN" = false ]; then
            if rm -rf "$target" 2>/dev/null; then
                ((deleted_count++))
                ((deleted_size += size))
            else
                echo -e "  ${ERROR_COLOR}✗ Failed: ${target//$base_dir\//}${RESET_COLOR}"
                ((error_count++))
            fi
        else
            echo -e "  ${INFO_COLOR}✓ Would delete: ${target//$base_dir\//}${RESET_COLOR}"
            ((deleted_count++))
            ((deleted_size += size))
        fi
    done
    
    # Display summary
    if [ $file_count -eq 0 ]; then
        echo -e "  ${SUCCESS_COLOR}✓ Directory already empty${RESET_COLOR}"
        return
    fi
    
    if [ "$DRY_RUN" = true ]; then
        echo -e "  ${INFO_COLOR}✓ Dry Run: Would delete ${deleted_count} files ($(format_size $total_size))${RESET_COLOR}"
    else
        echo -e "  ${SUCCESS_COLOR}✓ Deleted ${deleted_count} files ($(format_size $deleted_size))${RESET_COLOR}"
    fi
    
    if [ $error_count -gt 0 ]; then
        echo -e "  ${ERROR_COLOR}✗ ${error_count} files could not be deleted${RESET_COLOR}"
    fi
    
    if [ $protected_count -gt 0 ]; then
        echo -e "  ${STATUS_COLOR}⚠ ${protected_count} protected files skipped${RESET_COLOR}"
    fi
    
    if [ $inuse_count -gt 0 ]; then
        echo -e "  ${STATUS_COLOR}⚠ ${inuse_count} in-use files skipped${RESET_COLOR}"
    fi
    
    if [ $skipped_count -gt 0 ]; then
        echo -e "  ${INFO_COLOR}ℹ Total skipped: ${skipped_count} files${RESET_COLOR}"
    fi
    
    if [ $error_count -gt 0 ]; then
        echo -e "  ${INFO_COLOR}Recommendation: Run as Administrator for system files${RESET_COLOR}"
    fi
}

# Main execution
main() {
    init_terminal
    
    # Process all cleaning paths
    for name in "${!CLEAN_PATHS[@]}"; do
        clean_directory "${CLEAN_PATHS[$name]}" "$name"
        show_progress
    done
    
    # Final message
    echo -e "\n\n${SUCCESS_COLOR}══════════════════════════════════════════════"
    echo " Cache cleaning completed! "
    echo "══════════════════════════════════════════════${RESET_COLOR}"
    echo -e "\n${STATUS_COLOR}System caches have been optimized."
    echo "For complete system cleanup, consider:"
    echo "1. Restarting your system"
    echo "2. Running this script as Administrator"
    echo "3. Verifying directory paths in configuration${RESET_COLOR}"
}

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --dry-run)
            DRY_RUN=true
            shift ;;
        *)
            echo "Invalid option: $1"
            exit 1 ;;
    esac
done

# Execute main function
main
