FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Set default environment variables
ENV DISPLAY=:99
ENV RESOLUTION=1920x1080x24
ENV VNC_PORT=5900
ENV NOVNC_PORT=6080
ENV TZ=UTC
ENV START_URL=https://www.google.com

# Install basic dependencies
RUN apt update --fix-missing && apt install -y \
    sudo \
    curl \
    gpg \
    wget \
    gnupg2 \
    ca-certificates \
    git \
    tzdata

# Install Ulaa browser
RUN sudo curl -sSL https://ulaa.zoho.com/release/linux/stable/pubkey | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/ulaa-browser-release.gpg > /dev/null
RUN echo "deb [signed-by=/etc/apt/trusted.gpg.d/ulaa-browser-release.gpg arch=amd64] https://ulaa.zoho.com/release/linux/stable /" | sudo tee /etc/apt/sources.list.d/ulaa-browser-release.list
RUN apt update --fix-missing
RUN apt install -y ulaa-browser

# Install VNC server, noVNC, audio, and utilities
RUN apt install -y \
    x11vnc \
    xvfb \
    openbox \
    net-tools \
    novnc \
    websockify \
    xdotool \
    wmctrl \
    pulseaudio \
    alsa-utils \
    fonts-liberation \
    fonts-noto \
    fonts-noto-color-emoji \
    htop \
    nano \
    vim \
    && apt clean && rm -rf /var/lib/apt/lists/*

# Create directories
RUN mkdir -p ~/.vnc ~/.config/openbox /downloads /uploads

# Configure timezone
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Create openbox config for no decorations
RUN echo '<?xml version="1.0" encoding="UTF-8"?>\n\
<openbox_config xmlns="http://openbox.org/3.4/rc">\n\
  <applications>\n\
    <application class="*">\n\
      <decor>no</decor>\n\
      <maximized>yes</maximized>\n\
    </application>\n\
  </applications>\n\
</openbox_config>' > ~/.config/openbox/rc.xml

# Create browser preferences
RUN mkdir -p ~/.config/ulaa-browser/Default && \
    echo '{\n\
  "download": {\n\
    "default_directory": "/downloads",\n\
    "prompt_for_download": false\n\
  },\n\
  "profile": {\n\
    "default_content_setting_values": {\n\
      "notifications": 2\n\
    }\n\
  },\n\
  "browser": {\n\
    "show_home_button": true\n\
  }\n\
}' > ~/.config/ulaa-browser/Default/Preferences

# Expose ports
EXPOSE 5900 6080

# Create startup script
RUN echo '#!/bin/bash\n\
\n\
echo "========================================"\n\
echo "Starting Ulaa Browser in Docker"\n\
echo "========================================"\n\
echo "noVNC URL: http://localhost:${NOVNC_PORT}"\n\
echo "VNC Port: ${VNC_PORT}"\n\
echo "Resolution: ${RESOLUTION}"\n\
echo "Start URL: ${START_URL}"\n\
echo "Downloads: /downloads"\n\
echo "Uploads: /uploads"\n\
echo "========================================"\n\
\n\
# Start PulseAudio\n\
pulseaudio --start --exit-idle-time=-1 2>/dev/null &\n\
\n\
# Start Xvfb with configurable resolution\n\
Xvfb ${DISPLAY} -screen 0 ${RESOLUTION} &\n\
XVFB_PID=$!\n\
\n\
# Wait for X to start\n\
sleep 2\n\
\n\
# Start openbox without decorations\n\
openbox --config-file ~/.config/openbox/rc.xml &\n\
sleep 1\n\
\n\
# Start VNC server without password\n\
x11vnc -display ${DISPLAY} -forever -nopw -rfbport ${VNC_PORT} -shared &\n\
X11VNC_PID=$!\n\
\n\
# Create auto-connect HTML page\n\
cat > /usr/share/novnc/index.html << EOF\n\
<!DOCTYPE html>\n\
<html>\n\
<head>\n\
    <title>Ulaa Browser</title>\n\
    <meta http-equiv="refresh" content="0; url=vnc.html?autoconnect=true&resize=scale" />\n\
</head>\n\
<body>\n\
    <p>Connecting to Ulaa Browser...</p>\n\
</body>\n\
</html>\n\
EOF\n\
\n\
# Start noVNC\n\
websockify -D --web=/usr/share/novnc/ ${NOVNC_PORT} localhost:${VNC_PORT}\n\
NOVNC_PID=$!\n\
\n\
# Wait for services to start\n\
sleep 3\n\
\n\
echo "All services started successfully!"\n\
echo "Browser will launch in 2 seconds..."\n\
sleep 2\n\
\n\
# Loop to keep browser running forever in maximized mode\n\
while true; do\n\
    ulaa-browser \\\n\
        --no-sandbox \\\n\
        --disable-dev-shm-usage \\\n\
        --disable-gpu \\\n\
        --window-position=0,0 \\\n\
        --start-maximized \\\n\
        --disable-infobars \\\n\
        --disable-session-crashed-bubble \\\n\
        --noerrdialogs \\\n\
        --disable-translate \\\n\
        --disable-features=TranslateUI \\\n\
        --disk-cache-size=104857600 \\\n\
        --enable-audio-service-sandbox \\\n\
        --user-data-dir=~/.config/ulaa-browser \\\n\
        "${START_URL}" &\n\
    \n\
    BROWSER_PID=$!\n\
    sleep 3\n\
    \n\
    # Maximize window using xdotool\n\
    WINDOW_ID=$(xdotool search --sync --onlyvisible --class "ulaa-browser" 2>/dev/null | head -1)\n\
    if [ ! -z "$WINDOW_ID" ]; then\n\
        xdotool windowactivate $WINDOW_ID 2>/dev/null\n\
        wmctrl -i -r $WINDOW_ID -b add,maximized_vert,maximized_horz 2>/dev/null || \\\n\
        xdotool windowsize $WINDOW_ID 100% 100% 2>/dev/null\n\
    fi\n\
    \n\
    wait $BROWSER_PID\n\
    echo "Browser closed. Restarting in 2 seconds..."\n\
    sleep 2\n\
done\n\
' > /start.sh && chmod +x /start.sh

# Add healthcheck
HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
  CMD pgrep -f ulaa-browser > /dev/null || exit 1

# Set volume for downloads and uploads
VOLUME ["/downloads", "/uploads"]

CMD ["/start.sh"]
