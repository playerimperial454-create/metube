# Dockerfile MeTube simplifié pour Back4App
FROM node:20-alpine

WORKDIR /app

# Installer FFmpeg, curl, python3 et yt-dlp
RUN apk add --no-cache ffmpeg curl python3 py3-pip tar xz && \
    pip install --break-system-packages --no-cache-dir yt-dlp

# Copier tous les fichiers du repo
COPY . .

# Installer les dépendances Node (sans le lockfile)
RUN npm install --omit=dev

# Créer le dossier de téléchargement
RUN mkdir -p /downloads && chmod 777 /downloads

# Variables d'environnement par défaut
ENV DOWNLOAD_DIR=/downloads
ENV MAX_CONCURRENT_DOWNLOADS=2
ENV DEFAULT_THEME=auto
ENV PUID=1000
ENV PGID=1000
ENV PORT=8081

EXPOSE 8081

CMD ["npm", "start"]
