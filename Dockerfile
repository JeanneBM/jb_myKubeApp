FROM node:carbon
WORKDIR /usr/src/app

RUN npm install
COPY . .

CMD [ "npm", "start" ]

EXPOSE 8080
