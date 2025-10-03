# Ulaa Browser with noVNC

Run Ulaa Browser in a Docker container with web-based VNC access. No VNC client needed - access the browser directly from your web browser!

## Features

- 🌐 **Web-based access** via noVNC - no VNC client required
- 🔓 **No password** - quick and easy access
- 🖥️ **Full desktop environment** with Fluxbox window manager
- 📱 **Access from any device** with a web browser
- 🚀 **Quick setup** - just one command to run

## Quick Start

### Pull and Run

```bash
docker run -d -p 6080:6080 --name ulaa-browser <your-dockerhub-username>/ulaa-browser-novnc
```

### Access the Browser

Open your web browser and navigate to:

```
http://localhost:6080/
```

That's it! The Ulaa browser will be running and ready to use.

## Usage

### Basic Run

```bash
docker run -d -p 6080:6080 --name ulaa-browser <your-dockerhub-username>/ulaa-browser-novnc
```

### Custom Port

If you want to use a different port (e.g., 8080):

```bash
docker run -d -p 8080:6080 --name ulaa-browser <your-dockerhub-username>/ulaa-browser-novnc
```

Then access at: `http://localhost:8080/`

### With Traditional VNC Access

If you also want to access via a traditional VNC client:

```bash
docker run -d -p 6080:6080 -p 5900:5900 --name ulaa-browser <your-dockerhub-username>/ulaa-browser-novnc
```

Connect with VNC client to: `localhost:5900`

### Stop the Container

```bash
docker stop ulaa-browser
```

### Start the Container

```bash
docker start ulaa-browser
```

### Remove the Container

```bash
docker rm -f ulaa-browser
```

## Configuration

### Display Resolution

The default resolution is **1920x1080**. To change it, you'll need to build the image yourself and modify the `Xvfb` line in the Dockerfile:

```dockerfile
Xvfb :99 -screen 0 1280x720x24 &\n\
```

### Shared Memory

For better browser performance, you can increase shared memory:

```bash
docker run -d -p 6080:6080 --shm-size=2g --name ulaa-browser <your-dockerhub-username>/ulaa-browser-novnc
```

## Ports

- **6080** - noVNC web interface (HTTP)
- **5900** - VNC server (optional, if you want traditional VNC access)

## Security Note

⚠️ **Important**: This container runs without password authentication for ease of use. Only use this in trusted networks or localhost. If you need password protection, consider:

- Using a reverse proxy with authentication
- Running only on localhost
- Using Docker networks to isolate the container

## Building from Source

If you want to build the image yourself:

```bash
git clone <your-repo-url>
cd <repo-directory>
docker build -t ulaa-browser-novnc .
docker run -d -p 6080:6080 --name ulaa-browser ulaa-browser-novnc
```

## Troubleshooting

### Browser doesn't start

- Wait 5-10 seconds after container starts for all services to initialize
- Check container logs: `docker logs ulaa-browser`

### Connection refused

- Ensure port 6080 is not already in use
- Check if container is running: `docker ps`

### Performance issues

- Increase shared memory: `--shm-size=2g`
- Reduce resolution in the Dockerfile

## System Requirements

- Docker installed
- Port 6080 available
- Modern web browser (Chrome, Firefox, Safari, Edge)

## About Ulaa Browser

Ulaa is a privacy-focused browser by Zoho. Learn more at [ulaa.zoho.com](https://ulaa.zoho.com)

## License

This Docker image is provided as-is. Ulaa Browser is property of Zoho Corporation.

## Support

For issues related to:
- **This Docker image**: Open an issue on GitHub
- **Ulaa Browser**: Visit [Zoho Support](https://www.zoho.com/support.html)

---

**Enjoy browsing with Ulaa in Docker! 🚀**
