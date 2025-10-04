# ![Ulaa](https://ulaa.com/images/ulaa_ham.png) Ulaa Browser Docker

Run [Ulaa Browser](https://www.ulaa.com/) in a Docker container with web-based access via noVNC!

[![Docker](https://img.shields.io/badge/docker-%230db7ed.svg?style=for-the-badge&logo=docker&logoColor=white)](https://hub.docker.com/r/siddhmistry/ulaa-browser)
[![License](https://img.shields.io/badge/license-MIT-blue.svg?style=for-the-badge)](LICENSE)

## 📋 Table of Contents

- [Features](#-features)
- [Quick Start](#-quick-start)
- [Configuration](#-configuration)
- [Environment Variables](#-environment-variables)
- [Volume Mounts](#-volume-mounts)
- [Advanced Usage](#-advanced-usage)
- [Accessing the Browser](#-accessing-the-browser)
- [Troubleshooting](#-troubleshooting)
- [Version History](#-version-history)

## ✨ Features

- 🌐 **Web-based Access** - Access browser via noVNC directly from your web browser
- 🔒 **No Password Required** - Auto-connect enabled for seamless experience
- 📱 **Responsive Design** - Auto-scales to fit your browser window
- 🔄 **Auto-Restart** - Browser automatically restarts if closed
- 🖥️ **Maximized Mode** - Browser opens in full maximized mode
- 🎵 **Audio Support** - PulseAudio enabled for sound playback
- 📁 **File Management** - Persistent downloads and uploads directories
- ⚙️ **Configurable Resolution** - Set custom screen resolution
- 🌍 **Timezone Support** - Configure timezone for your location
- 🎨 **Enhanced Fonts** - Includes Liberation, Noto, and Emoji fonts
- 🏥 **Health Monitoring** - Built-in Docker health checks
- 💾 **Persistent Browser Data** - User preferences and settings saved
- 🛠️ **Utilities Included** - htop, nano, vim for debugging

## 🚀 Quick Start

### Pull and Run

```bash
docker pull siddhmistry/ulaa-browser:0.0.2

docker run -d \
  -p 6080:6080 \
  --name ulaa-browser \
  siddhmistry/ulaa-browser:0.0.2
```

Then open your browser and navigate to:
```
http://localhost:6080
```

That's it! The browser will auto-connect and open automatically! 🎉

### Build from Source

```bash
git clone https://github.com/mrfoxie/ulaa-browser-docker.git
cd ulaa-browser-docker
docker build -t ulaa-browser:latest .
docker run -d -p 6080:6080 --name ulaa-browser ulaa-browser:latest
```

## ⚙️ Configuration

### Basic Configuration

```bash
docker run -d \
  -p 6080:6080 \
  -p 5900:5900 \
  --name ulaa-browser \
  siddhmistry/ulaa-browser:0.0.2
```

### Full Configuration with All Features

```bash
docker run -d \
  -p 6080:6080 \
  -p 5900:5900 \
  -v ~/Downloads:/downloads \
  -v ~/Uploads:/uploads \
  -e RESOLUTION=2560x1440x24 \
  -e START_URL=https://github.com \
  -e TZ=Asia/Kolkata \
  --shm-size=2g \
  --memory=4g \
  --cpus=2 \
  --name ulaa-browser \
  siddhmistry/ulaa-browser:0.0.2
```

## 🔧 Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `RESOLUTION` | `1920x1080x24` | Screen resolution (WIDTHxHEIGHTxDEPTH) |
| `START_URL` | `https://www.google.com` | URL to open on browser start |
| `TZ` | `UTC` | Timezone (e.g., `Asia/Kolkata`, `America/New_York`) |
| `VNC_PORT` | `5900` | VNC server port |
| `NOVNC_PORT` | `6080` | noVNC web interface port |

### Example: Different Resolutions

```bash
# 4K Resolution
-e RESOLUTION=3840x2160x24

# Full HD
-e RESOLUTION=1920x1080x24

# HD
-e RESOLUTION=1280x720x24
```

### Example: Custom Start URL

```bash
# Open YouTube
-e START_URL=https://youtube.com

# Open your website
-e START_URL=https://example.com
```

## 📁 Volume Mounts

| Path | Description |
|------|-------------|
| `/downloads` | Browser download directory |
| `/uploads` | Upload files to container |

### Example Usage

```bash
docker run -d \
  -v ~/MyDownloads:/downloads \
  -v ~/MyUploads:/uploads \
  -p 6080:6080 \
  --name ulaa-browser \
  siddhmistry/ulaa-browser:0.0.2
```

Now all browser downloads will be saved to `~/MyDownloads` on your host machine!

## 🌐 Accessing the Browser

### Web Interface (Recommended)

1. Open your browser
2. Navigate to: `http://localhost:6080`
3. Browser will auto-connect and open automatically!

### Traditional VNC Client

If you prefer using a VNC client:

1. Connect to: `localhost:5900`
2. No password required
3. Recommended clients: RealVNC, TigerVNC, TightVNC

### Remote Access

Replace `localhost` with your server IP:
```
http://YOUR_SERVER_IP:6080
```

## 🐳 Docker Compose

Create a `docker-compose.yml` file:

```yaml
version: '3.8'

services:
  ulaa-browser:
    image: siddhmistry/ulaa-browser:0.0.2
    container_name: ulaa-browser
    ports:
      - "6080:6080"
      - "5900:5900"
    volumes:
      - ./downloads:/downloads
      - ./uploads:/uploads
    environment:
      - RESOLUTION=1920x1080x24
      - START_URL=https://www.google.com
      - TZ=Asia/Kolkata
    shm_size: 2g
    mem_limit: 4g
    cpus: 2
    restart: unless-stopped
```

Run with:
```bash
docker-compose up -d
```

## 🔍 Advanced Usage

### Resource Limits

Limit CPU and memory usage:

```bash
docker run -d \
  --cpus=2 \
  --memory=4g \
  --shm-size=2g \
  -p 6080:6080 \
  --name ulaa-browser \
  siddhmistry/ulaa-browser:0.0.2
```

### Monitoring

View logs:
```bash
docker logs ulaa-browser
```

Follow logs in real-time:
```bash
docker logs -f ulaa-browser
```

Check container status:
```bash
docker ps
docker stats ulaa-browser
```

### Execute Commands Inside Container

```bash
# Open a shell
docker exec -it ulaa-browser bash

# Check running processes
docker exec ulaa-browser ps aux

# View htop
docker exec -it ulaa-browser htop
```

## 🛠️ Troubleshooting

### Browser Not Loading

1. Check if container is running:
   ```bash
   docker ps
   ```

2. View logs:
   ```bash
   docker logs ulaa-browser
   ```

3. Restart container:
   ```bash
   docker restart ulaa-browser
   ```

### Audio Not Working

Make sure you're using a modern browser that supports WebRTC audio.

### Resolution Issues

Try different resolutions:
```bash
docker stop ulaa-browser
docker rm ulaa-browser

docker run -d \
  -e RESOLUTION=1280x720x24 \
  -p 6080:6080 \
  --name ulaa-browser \
  siddhmistry/ulaa-browser:0.0.2
```

### Performance Issues

Increase shared memory and resources:
```bash
docker run -d \
  --shm-size=4g \
  --memory=8g \
  --cpus=4 \
  -p 6080:6080 \
  --name ulaa-browser \
  siddhmistry/ulaa-browser:0.0.2
```

## 📊 Version History

### v0.0.2 (Latest)
- ✅ Added audio support with PulseAudio
- ✅ Persistent downloads and uploads volumes
- ✅ Configurable screen resolution
- ✅ Custom start URL support
- ✅ Timezone configuration
- ✅ Enhanced fonts (Liberation, Noto, Emoji)
- ✅ Docker health checks
- ✅ Pre-configured browser preferences
- ✅ Improved startup logs
- ✅ Better resource management
- ✅ Utilities included (htop, nano, vim)

### v0.0.1
- ✅ Basic Ulaa Browser in Docker
- ✅ noVNC web interface
- ✅ Auto-connect enabled
- ✅ Auto-restart on close
- ✅ Maximized mode

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- [Ulaa Browser](https://www.ulaa.com/) - Privacy-focused browser by Zoho
- [noVNC](https://novnc.com/) - HTML5 VNC client
- [Ubuntu](https://ubuntu.com/) - Base image

## 📧 Support

- **Issues**: [GitHub Issues](https://github.com/mrfoxie/ulaa-browser-docker/issues)
- **Docker Hub**: [siddhmistry/ulaa-browser](https://hub.docker.com/r/siddhmistry/ulaa-browser)

## ⭐ Star History

If you find this project useful, please consider giving it a star on GitHub!

---

**Made with ❤️ by [Siddh Mistry](https://github.com/mrfoxie)**
