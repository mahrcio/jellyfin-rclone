FROM jellyfin/jellyfin:latest

# Instala rclone
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -y --no-install-recommends curl fuse3 ca-certificates unzip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Instala rclone via download direto
RUN curl -O https://downloads.rclone.org/rclone-current-linux-amd64.zip && \
    unzip rclone-current-linux-amd64.zip && \
    cd rclone-*-linux-amd64 && \
    cp rclone /usr/bin/ && \
    chown root:root /usr/bin/rclone && \
    chmod 755 /usr/bin/rclone && \
    cd .. && \
    rm -rf rclone-*-linux-amd64 rclone-current-linux-amd64.zip

# Cria diretório para o mount
RUN mkdir -p /mnt/gdrive

# Script para rodar ambos
RUN echo '#!/bin/bash\n\
rclone mount gdrive: /mnt/gdrive --vfs-cache-mode writes --allow-non-empty &\n\
sleep 5\n\
/jellyfin/jellyfin -d /config' > /start.sh && \
chmod +x /start.sh

EXPOSE 8096

CMD ["/start.sh"]
