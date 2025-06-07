# BBCP Docker Image

[![Build and Deploy](https://github.com/marioja/bbcp/actions/workflows/docker-build-deploy.yml/badge.svg)](https://github.com/marioja/bbcp/actions/workflows/docker-build-deploy.yml)
[![Docker Image Size](https://img.shields.io/docker/image-size/marioja/bbcp/latest)](https://hub.docker.com/r/marioja/bbcp)
[![Docker Pulls](https://img.shields.io/docker/pulls/marioja/bbcp)](https://hub.docker.com/r/marioja/bbcp)

A Docker image for the Berkeley Balanced Copy Protocol (bbcp) - a high-performance copy utility.

## Features

- ✅ Built on Alpine 3.14 for optimal compatibility
- ✅ OpenSSL MD5 support properly configured
- ✅ Multi-architecture support (amd64, arm64)
- ✅ Minimal image size (~13.6MB)
- ✅ All C++ runtime dependencies included
- ✅ **Patched for Docker volume copy reliability** - Fixed file specification decode issues
- ✅ GNU procps included for full `ps` command compatibility

## Quick Start

```bash
# Pull the image
docker pull marioja/bbcp:latest

# Copy a file
docker run --rm -v /source:/src -v /destination:/dst marioja/bbcp:latest /src/file /dst/

# Show help
docker run --rm marioja/bbcp:latest --help
```

## Usage Examples

### Basic File Copy
```bash
docker run --rm -v $(pwd):/data marioja/bbcp:latest /data/source.txt /data/destination.txt
```

### Copy with Compression
```bash
docker run --rm -v $(pwd):/data marioja/bbcp:latest -c /data/source.txt /data/destination.txt.compressed
```

### Copy with Progress
```bash
docker run --rm -v $(pwd):/data marioja/bbcp:latest -P 5 /data/largefile.txt /data/largefile_copy.txt
```

### Network Copy (requires network setup)
```bash
docker run --rm --network host marioja/bbcp:latest user@remote-host:/path/to/file /local/destination/
```

## Setup & Deployment

### Prerequisites

1. **Docker Hub Account**: Create an account at [hub.docker.com](https://hub.docker.com)
2. **GitHub Repository**: Fork or clone this repository to your GitHub account

### Configuration Steps

#### Option 1: Quick Setup (PowerShell)

Run the setup script to automatically configure your repository:

```powershell
.\setup.ps1 -DockerHubUsername "your-dockerhub-username"
```

This script will:
- Update the GitHub Actions workflow with your Docker Hub username
- Update all README examples with your image name
- Display next steps for GitHub Secrets configuration

> **Note:** Don't forget to update the badges at the top of the README with your GitHub username and Docker Hub username.

#### Option 2: Manual Setup

##### 1. Update Docker Hub Username

Replace `your-dockerhub-username` with your actual Docker Hub username in these files:
- `.github/workflows/docker-build-deploy.yml` (line 12)
- `README.md` (all example commands)

##### 2. Configure GitHub Secrets

In your GitHub repository, go to **Settings → Secrets and variables → Actions** and add:

| Secret Name | Description | How to Get |
|-------------|-------------|------------|
| `DOCKERHUB_USERNAME` | Your Docker Hub username | Your Docker Hub profile |
| `DOCKERHUB_TOKEN` | Docker Hub access token | Docker Hub → Account Settings → Security → Access Tokens |

##### 3. Create Docker Hub Access Token

1. Log in to [Docker Hub](https://hub.docker.com)
2. Go to **Account Settings → Security → Access Tokens**
3. Click **New Access Token**
4. Name: `GitHub Actions` (or similar)
5. Permissions: **Read, Write, Delete**
6. Copy the generated token (you won't see it again!)
7. Add it as `DOCKERHUB_TOKEN` secret in GitHub

##### 4. Trigger the Build

The workflow automatically triggers on:
- Push to `main` or `master` branch
- New tags starting with `v` (e.g., `v1.0.0`)
- Pull requests (build only, no push)

To trigger manually:
```powershell
# Tag a release
git tag v1.0.0
git push origin v1.0.0

# Or push to main branch
git push origin main
```

### Local Development

#### Build Locally
```powershell
# Build the image
docker build -t bbcp:local .

# Test the image
docker run --rm bbcp:local --help
```

#### Test with Local Files
```powershell
# Copy a file locally
docker run --rm -v ${PWD}:/data bbcp:local /data/source.txt /data/destination.txt
```

#### Automated Testing
```powershell
# Run the test suite (PowerShell)
.\test.ps1 -ImageName "bbcp:local"

# Or on Linux/macOS (Bash)
./test.sh bbcp:local
```

## Troubleshooting

### Common Issues

#### 1. GitHub Actions Authentication Fails
```
Error: Username/Token is incorrect
```
**Solution:**
- Verify `DOCKERHUB_USERNAME` matches your Docker Hub username exactly
- Regenerate Docker Hub token with Read/Write/Delete permissions
- Ensure secrets are set correctly in GitHub repository settings

#### 2. Image Build Fails
```
Error: Failed to solve: process "/bin/sh -c make..." didn't complete successfully
```
**Solution:**
- Check if the bbcp source repository is accessible
- Verify Alpine 3.14 base image compatibility
- Review build logs for specific compilation errors

#### 3. Multi-Architecture Build Issues
```
Error: Multiple platforms feature is currently not supported for docker driver
```
**Solution:**
- The workflow uses `docker/setup-buildx-action` which automatically handles this
- Ensure you're using the provided GitHub Actions workflow

#### 4. Docker Hub Repository Not Found
```
Error: repository does not exist or may require authentication
```
**Solution:**
- Create the repository on Docker Hub first, or
- Enable auto-creation in Docker Hub settings, or
- Make sure the repository name matches `IMAGE_NAME` in workflow

### Build Verification

Check if your image was built successfully:

```powershell
# Pull and test your image
docker pull marioja/bbcp:latest
docker run --rm marioja/bbcp:latest --version
```

Expected output:
```
bbcp (C) 2002-2020 by the Board of Trustees of the Leland Stanford, Jr., University
      All Rights Reserved. See 'bbcp -?' for complete license terms.
      Version: 17.12.00.00.0
```

## Build Information

- **Base Image**: Alpine 3.14
- **bbcp Version**: 17.12.00.00.0
- **Compiler**: GCC 10.3.1 (C++14 compatible)
- **MD5 Implementation**: OpenSSL
- **Architecture**: Multi-platform (linux/amd64, linux/arm64)
- **Image Size**: ~13.6MB

## Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| No environment variables required | | |

## Volumes

Mount your source and destination directories:
- Source files: Mount to any path inside container
- Destination: Mount to any path inside container

## License

This Docker image packages the bbcp utility. Please refer to the original bbcp license and documentation at: http://www.slac.stanford.edu/~abh/bbcp

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test the build locally
5. Submit a pull request

## Issues

If you encounter any issues with this Docker image, please report them on the GitHub repository.

---

**Note**: This is an unofficial Docker image for bbcp. For official bbcp documentation and support, visit the SLAC website.


