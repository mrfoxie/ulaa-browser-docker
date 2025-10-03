FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install basic dependencies
RUN apt update --fix-missing && apt install -y \
    sudo \
    curl \
    gpg \
    wget \
    gnupg2 \
    ca-certificates \
    git

# Install Ulaa browser
RUN sudo curl -sSL https://ulaa.zoho.com/release/linux/stable/pubkey | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/ulaa-browser-release.gpg > /dev/null
RUN echo "deb [signed-by=/etc/apt/trusted.gpg.d/ulaa-browser-release.gpg arch=amd64] https://ulaa.zoho.com/release/linux/stable /" | sudo tee /etc/apt/sources.list.d/ulaa-browser-release.list
RUN apt update --fix-missing
RUN apt install -y ulaa-browser

# Install VNC server, noVNC and minimal dependencies
RUN apt install -y \
    x11vnc \
    xvfb \
    openbox \
    net-tools \
    novnc \
    websockify \
    xdotool \
    && apt clean

# Create a directory for VNC
RUN mkdir -p ~/.vnc

# Expose VNC port and noVNC web port
EXPOSE 5900 6080

# Create openbox config for no decorations
RUN mkdir -p ~/.config/openbox && \
    echo '<?xml version="1.0" encoding="UTF-8"?>\n\
<openbox_config xmlns="http://openbox.org/3.4/rc">\n\
  <applications>\n\
    <application class="*">\n\
      <decor>no</decor>\n\
      <maximized>yes</maximized>\n\
      <fullscreen>yes</fullscreen>\n\
    </application>\n\
  </applications>\n\
</openbox_config>' > ~/.config/openbox/rc.xml

# Create startup script
RUN echo '#!/bin/bash\n\
# Start Xvfb\n\
Xvfb :99 -screen 0 1920x1080x24 &\n\
export DISPLAY=:99\n\
\n\
# Start openbox without decorations\n\
openbox --config-file ~/.config/openbox/rc.xml &\n\
sleep 1\n\
\n\
# Start VNC server without password\n\
x11vnc -display :99 -forever -nopw -rfbport 5900 &\n\
\n\
# Create auto-connect HTML page\n\
echo '\''<!DOCTYPE html>\n\
<html>\n\
<head>\n\
    <title>Ulaa Browser</title>\n\
    <meta http-equiv="refresh" content="0; url=vnc.html?autoconnect=true&resize=scale" />\n\
</head>\n\
<body>\n\
    <p>Connecting to Ulaa Browser...</p>\n\
</body>\n\
</html>'\'' > /usr/share/novnc/index.html\n\
\n\
# Start noVNC\n\
websockify -D --web=/usr/share/novnc/ 6080 localhost:5900\n\
\n\
# Wait a bit for services to start\n\
sleep 3\n\
\n\
# Loop to keep browser running forever in maximized mode\n\
while true; do\n\
    ulaa-browser \\\n\
        --no-sandbox \\\n\
        --disable-dev-shm-usage \\\n\
        --disable-gpu \\\n\
        --window-position=0,0 \\\n\
        --window-size=1920,1080 \\\n\
        --start-maximized \\\n\
        --disable-infobars \\\n\
        --disable-session-crashed-bubble \\\n\
        --noerrdialogs \\\n\
        --disable-translate \\\n\
        --disable-features=TranslateUI \\\n\
        --disk-cache-size=1 \\\n\
        --media-cache-size=1 &\n\
    \n\
    BROWSER_PID=$!\n\
    sleep 2\n\
    \n\
    # Maximize window using xdotool\n\
    WINDOW_ID=$(xdotool search --sync --onlyvisible --class "ulaa-browser" | head -1)\n\
    if [ ! -z "$WINDOW_ID" ]; then\n\
        xdotool windowactivate $WINDOW_ID\n\
        wmctrl -i -r $WINDOW_ID -b add,maximized_vert,maximized_horz 2>/dev/null || \\\n\
        xdotool windowsize $WINDOW_ID 100% 100%\n\
    fi\n\
    \n\
    wait $BROWSER_PID\n\
    echo "Browser closed. Restarting in 2 seconds..."\n\
    sleep 2\n\
done\n\
' > /start.sh && chmod +x /start.sh

CMD ["/start.sh"]
