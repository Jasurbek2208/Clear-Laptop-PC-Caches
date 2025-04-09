Write-Output "Clearing Caches started..."

# Step 1: Clearing user temporary files
Write-Output "Clearing temporary caches..."
Write-Progress -Activity "Clearing Caches" -Status "Clearing temporary caches..." -PercentComplete 0
Remove-Item "C:\Users\1\AppData\Local\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue
Write-Progress -Activity "Clearing Caches" -Status "Temporary caches cleared." -PercentComplete 20

# Step 2: Clear Prefetch Caches
Write-Output "Clearing prefetch files caches..."
Write-Progress -Activity "Clearing Caches" -Status "Clearing prefetch caches..." -PercentComplete 20
Remove-Item "C:\Windows\Prefetch\*" -Recurse -Force -ErrorAction SilentlyContinue
Write-Progress -Activity "Clearing Caches" -Status "Prefetch caches cleared." -PercentComplete 40

# Step 3: Clear Windows caches (temporary files)
Write-Output "Clearing Windows caches..."
Write-Progress -Activity "Clearing Caches" -Status "Clearing Windows caches..." -PercentComplete 40
Remove-Item "C:\Windows\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue
Write-Progress -Activity "Clearing Caches" -Status "Windows caches cleared." -PercentComplete 60

# Step 4: Clear Windows Update Caches
Write-Output "Clearing Windows update caches..."
Write-Progress -Activity "Clearing Caches" -Status "Clearing Windows update caches..." -PercentComplete 60
Remove-Item "C:\Windows\SoftwareDistribution\Download\*" -Recurse -Force -ErrorAction SilentlyContinue
Write-Progress -Activity "Clearing Caches" -Status "Windows update caches cleared." -PercentComplete 80

# Step 5: Clear Windows Error Reporting Caches
Write-Output "Clearing Windows error reporting caches..."
Write-Progress -Activity "Clearing Caches" -Status "Clearing error reporting caches..." -PercentComplete 80
Remove-Item "C:\ProgramData\Microsoft\Windows\WER\ReportQueue\*" -Recurse -Force -ErrorAction SilentlyContinue
Write-Progress -Activity "Clearing Caches" -Status "Error reporting caches cleared." -PercentComplete 100

Write-Output "Cleaning process ended."
