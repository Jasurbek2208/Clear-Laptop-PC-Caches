#!/bin/bash

echo "Clearing Caches started..."

# Function to display a simple progress bar
show_progress() {
    local percent=$1
    local bar=""
    local total=20
    local progress=$(( percent * total / 100 ))
    for ((i=0; i<progress; i++)); do
        bar="${bar}#"
    done
    for ((i=progress; i<total; i++)); do
        bar="${bar}-"
    done
    echo "[${bar}] ${percent}% Complete"
}

# Step 1: Clearing user temporary files
echo "Clearing temporary caches..."
rm -rf /mnt/c/Users/1/AppData/Local/Temp/* 2>/dev/null
show_progress 20

# Step 2: Clear Prefetch Caches
echo "Clearing prefetch files caches..."
rm -rf /mnt/c/Windows/Prefetch/* 2>/dev/null
show_progress 40

# Step 3: Clear Windows caches (temporary files)
echo "Clearing Windows caches..."
rm -rf /mnt/c/Windows/Temp/* 2>/dev/null
show_progress 60

# Step 4: Clear Windows Update Caches
echo "Clearing Windows update caches..."
rm -rf /mnt/c/Windows/SoftwareDistribution/Download/* 2>/dev/null
show_progress 80

# Step 5: Clear Windows Error Reporting Caches
echo "Clearing Windows error reporting caches..."
rm -rf /mnt/c/ProgramData/Microsoft/Windows/WER/ReportQueue/* 2>/dev/null
show_progress 100

echo "Cleaning process ended."
