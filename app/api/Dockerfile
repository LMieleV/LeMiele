FROM node:22-alpine
WORKDIR /srv
COPY package.json ./
RUN npm install --no-audit --no-fund
COPY tsconfig.json ./
COPY src ./src
EXPOSE 4000
CMD ["npm", "run", "start"]
