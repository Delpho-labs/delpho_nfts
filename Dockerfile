FROM ubuntu:22.04

# Install dependencies
RUN apt-get update && apt-get install -y wget curl git

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

WORKDIR /app

# Clone your public repository with the data
ARG REPO_URL
RUN git clone https://github.com/Delpho-labs/delpho_nfts.git ./data

# Install upload script dependencies
RUN npm install -g ipfs-http-client

# Copy upload script
COPY ./index.js 

EXPOSE 4001 5001 8080

# Start IPFS and upload
CMD ipfs daemon & sleep 5 && node index.js && tail -f /dev/null