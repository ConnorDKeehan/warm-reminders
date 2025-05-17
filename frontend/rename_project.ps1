$currentAppName = "warm_reminders"
$newAppName = "warmreminders"

# 1. Rename files and directories with valid paths
Get-ChildItem -Recurse -Force | 
    Where-Object { $_.Name -match $currentAppName } | 
    Sort-Object FullName -Descending |  # Handle files before folders
    ForEach-Object {
        if ($_.PSIsContainer -or $_.PSIsContainer -eq $false) {
            $newName = $_.Name -replace $currentAppName, $newAppName
            $directory = $_.DirectoryName
            if ($directory) {
                $newPath = Join-Path -Path $directory -ChildPath $newName
                Rename-Item -Path $_.FullName -NewName $newPath -Force
            }
        }
    }

# 2. Replace occurrences within file contents
$extensions = @("*.dart", "*.yaml", "*.json", "*.xml", "*.gradle", "*.plist")
foreach ($ext in $extensions) {
    Get-ChildItem -Recurse -Include $ext -File | ForEach-Object {
        try {
            (Get-Content $_.FullName -Raw) -replace $currentAppName, $newAppName | 
                Set-Content $_.FullName
        } catch {
            Write-Warning "Could not edit file: $($_.FullName)"
        }
    }
}