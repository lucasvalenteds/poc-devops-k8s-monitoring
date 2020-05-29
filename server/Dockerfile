FROM node:alpine

WORKDIR /application

ENV PORT 4000

COPY package*.json ./

COPY dist/index.js ./

RUN npm install --production

EXPOSE 4000

CMD [ "node", "index.js" ]
