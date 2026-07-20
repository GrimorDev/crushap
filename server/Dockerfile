FROM node:22-alpine

WORKDIR /app

COPY package.json package-lock.json* ./
RUN npm install --omit=dev

COPY src ./src

RUN addgroup -S app && adduser -S app -G app \
  && mkdir -p /data/uploads && chown -R app:app /data /app
USER app

ENV UPLOAD_DIR=/data/uploads
EXPOSE 3000

CMD ["node", "src/index.js"]
