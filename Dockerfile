# Start from Node.js image
FROM dockerfile/nodejs:latest

# Install Git
RUN apt-get install -y git

# Copy source
ADD ./node_modules /opt/flak-cannon-client/node_modules
ADD . /opt/flak-cannon-client

# Set directory
WORKDIR /opt/flak-cannon-client

# Install app deps
RUN npm install

CMD ["npm", "start"]
