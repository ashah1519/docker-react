# Specify a base image - builder - bulider phase
FROM node:alpine as builder

#if usr/app doesn't exist inside the container, it will automatically be created for you
WORKDIR /app

#to avoid unncessary builds ...we split copying of package.json which doesn't change that often and is required to run npm install command
COPY package.json .

# Install some depenendencies
RUN npm install

#if index.js changes often, all the above steps can be retrieved from the cache. 
COPY . .

RUN npm run build

#create an image from nginx - copy stuff from the previsou step and dumps it. nginx starts automatically
FROM nginx
# The elasticbeanstalk is going to look at this docker file and look for the EXPOSE instruction and map that port automatically
EXPOSE 80
COPY --from=builder /app/build /usr/share/nginx/html