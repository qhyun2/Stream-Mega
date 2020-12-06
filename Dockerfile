
# build
FROM node:12 AS builder
WORKDIR /usr/src/app
COPY package*.json ./
COPY tsconfig*.json ./
RUN npm ci --quiet
COPY ./src ./src
RUN npm run build

# copy to fresh container
FROM node:12-alpine
ENV NODE_ENV=production
# git needed by unknown npm library
RUN apk add git
WORKDIR /app
COPY ./src/public/favicon.ico ./public/favicon.ico
COPY ./src/public/default.mp4 ./public/default.mp4
COPY .env ./
COPY package*.json ./
RUN npm install --quiet --only=production
COPY ./src/public/css ./public/css
COPY ./src/views ./views
COPY ./src/public/js ./public/js
COPY --from=builder /usr/src/app/dist ./

# run
EXPOSE 3000
CMD ["node", "./server.js"]
