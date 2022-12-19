FROM node:latest
WORKDIR /app
EXPOSE 8080
COPY ["package.json", "package-lock.json*", "./"]
RUN npm install
COPY . .
CMD ["npm", "run", "serve"]
