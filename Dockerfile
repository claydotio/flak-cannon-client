# Start from Node.js image
FROM dockerfile/nodejs:latest

# Copy source
ADD . /opt/flak-cannon-client

# Set directory
WORKDIR /opt/flak-cannon-client

CMD ["npm", "start"]
