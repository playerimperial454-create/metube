# Dockerfile MeTube simplifié pour Back4App (architecture hardcodée)
FROM node:20-alpine AS build

WORKDIR /app

# Installer les dépendances de build
RUN apk add --no-cache python3 make g++

# Copier et installer les dépendances
COPY package.json package-lock.json* ./
RUN npm ci --omit=dev

# Copier le code source
COPY . .

# Étape finale : image de runtime
FROM node:20-alpine

WORKDIR /app

# Installer FFmpeg, curl, tar, xz (nécessaires pour yt-dlp et le téléchargement)
RUN apk add --no-cache ffmpeg curl python3 py3-pip tar xz && \
    pip install --break-system-packages --no-cache-dir yt-dlp

# Copier les dépendances et le code depuis l'étape de build
COPY --from=build /app/node_modules ./node_modules
COPY --from=build /app .

# Créer le dossier de téléchargement
RUN mkdir -p /downloads && chmod 777 /downloads

# Variables d'environnement par défaut
ENV DOWNLOAD_DIR=/downloads
ENV MAX_CONCURRENT_DOWNLOADS=2
ENV DEFAULT_THEME=auto
ENV PUID=1000
ENV PGID=1000
ENV PORT=8081

# Exposer le port
EXPOSE 8081

# Démarrer l'application
CMD ["node", "app.js"]
