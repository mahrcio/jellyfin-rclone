FROM jellyfin/jellyfin:latest

# Instala rclone
RUN apt-get update && \
    apt-get install -y curl fuse && \
    curl https://rclone.org/install.sh | bash && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

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
