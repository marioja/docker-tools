# Test script to validate the bbcp Docker image works correctly
param(
    [string]$ImageName = "bbcp:latest"
)

Write-Host "🧪 Testing bbcp Docker image..." -ForegroundColor Cyan

try {
    Write-Host "📋 Testing basic functionality..." -ForegroundColor Yellow

    # Test 1: Check if bbcp responds to --help
    Write-Host "  ✓ Testing --help flag..." -ForegroundColor Green
    docker run --rm $ImageName --help | Out-Null
    if ($LASTEXITCODE -ne 0) {
        throw "Help command failed"
    }

    # Test 2: Check version output
    Write-Host "  ✓ Testing --version flag..." -ForegroundColor Green
    $version = docker run --rm $ImageName --version 2>&1 | Select-Object -First 1
    Write-Host "    Version: $version" -ForegroundColor Gray

    # Test 3: Create test files and test local copy
    Write-Host "  ✓ Testing local file copy..." -ForegroundColor Green
    
    # Create test directory and file
    New-Item -ItemType Directory -Path "test_data" -Force | Out-Null
    "Hello, bbcp!" | Out-File -FilePath "test_data/source.txt" -Encoding UTF8 -NoNewline

    # Run bbcp copy
    docker run --rm -v "${PWD}/test_data:/data" $ImageName /data/source.txt /data/destination.txt
    if ($LASTEXITCODE -ne 0) {
        throw "Docker copy command failed"
    }

    # Verify result
    if (Test-Path "test_data/destination.txt") {
        $content = Get-Content "test_data/destination.txt" -Raw
        if ($content.Trim() -eq "Hello, bbcp!") {
            Write-Host "    ✅ File copy successful" -ForegroundColor Green
        } else {
            Write-Error "File content mismatch. Expected: 'Hello, bbcp!', Got: '$content'"
            exit 1
        }
    } else {
        Write-Error "Destination file not created"
        exit 1
    }

    Write-Host ""
    Write-Host "🎉 All tests passed!" -ForegroundColor Green
    Write-Host "✅ bbcp Docker image is working correctly" -ForegroundColor Green

} catch {
    Write-Error "Test failed: $_"
    exit 1
} finally {
    # Cleanup
    if (Test-Path "test_data") {
        Remove-Item -Recurse -Force "test_data"
    }
}
