# Setup script for bbcp Docker Hub deployment
# This script helps configure the repository for automated Docker builds

param(
    [Parameter(Mandatory=$true)]
    [string]$DockerHubUsername,
    
    [Parameter(Mandatory=$false)]
    [string]$ImageName = "bbcp"
)

Write-Host "🐳 Setting up bbcp Docker Hub deployment..." -ForegroundColor Cyan

# Validate input
if ([string]::IsNullOrWhiteSpace($DockerHubUsername)) {
    Write-Error "Docker Hub username cannot be empty"
    exit 1
}

$fullImageName = "$DockerHubUsername/$ImageName"

# Update GitHub Actions workflow
$workflowFile = "../.github/workflows/bbcp-docker-build-deploy.yml"
if (Test-Path $workflowFile) {
    Write-Host "📝 Updating GitHub Actions workflow..." -ForegroundColor Yellow
    
    $content = Get-Content $workflowFile -Raw
    $content = $content -replace "your-dockerhub-username/bbcp", $fullImageName
    Set-Content $workflowFile $content
    
    Write-Host "✅ Updated $workflowFile" -ForegroundColor Green
} else {
    Write-Warning "GitHub Actions workflow file not found: $workflowFile"
}

# Update README.md
$readmeFile = "README.md"
if (Test-Path $readmeFile) {
    Write-Host "📝 Updating README..." -ForegroundColor Yellow
    
    $content = Get-Content $readmeFile -Raw
    $content = $content -replace "your-dockerhub-username/bbcp", $fullImageName
    Set-Content $readmeFile $content
    
    Write-Host "✅ Updated $readmeFile" -ForegroundColor Green
} else {
    Write-Warning "README file not found: $readmeFile"
}

Write-Host ""
Write-Host "🎉 Setup complete!" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "1. 🔑 Configure GitHub Secrets:" -ForegroundColor White
Write-Host "   - DOCKERHUB_USERNAME: $DockerHubUsername" -ForegroundColor Gray
Write-Host "   - DOCKERHUB_TOKEN: (create at hub.docker.com → Settings → Security)" -ForegroundColor Gray
Write-Host ""
Write-Host "2. 🚀 Trigger deployment:" -ForegroundColor White
Write-Host "   git add ." -ForegroundColor Gray
Write-Host "   git commit -m 'Configure Docker Hub deployment'" -ForegroundColor Gray
Write-Host "   git push origin main" -ForegroundColor Gray
Write-Host ""
Write-Host "3. 📦 Your image will be available at:" -ForegroundColor White
Write-Host "   docker pull $fullImageName" -ForegroundColor Gray
