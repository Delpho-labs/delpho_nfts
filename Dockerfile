FROM ubuntu:22.04

# Install dependencies
RUN apt-get update && apt-get install -y wget curl

# Install Node.js
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
RUN apt-get install -y nodejs

# Install IPFS
RUN wget https://dist.ipfs.tech/kubo/v0.26.0/kubo_v0.26.0_linux-amd64.tar.gz
RUN tar -xvzf kubo_v0.26.0_linux-amd64.tar.gz
RUN cd kubo && ./install.sh
RUN rm -rf kubo kubo_v0.26.0_linux-amd64.tar.gz

# Initialize IPFS
RUN ipfs init --profile=server,lowpower
RUN ipfs config Datastore.StorageMax "5GB"

# Enable IPFS API CORS
RUN ipfs config --json API.HTTPHeaders.Access-Control-Allow-Origin '["*"]'
RUN ipfs config --json API.HTTPHeaders.Access-Control-Allow-Methods '["GET", "POST"]'

WORKDIR /app

# Install dependencies
RUN npm install

EXPOSE 4001 5001 8080

# Start IPFS daemon, wait for it to be ready, run upload, then keep IPFS running
CMD ipfs daemon & \
    sleep 10 && \
    node index.js && \
    echo "✅ Upload complete! IPFS daemon running permanently..." && \
    wait