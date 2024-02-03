#!/bin/bash -e

# Colors
BLD="\033[1m"  # Bold
END="\033[0m"  # Reset
CYN="\033[36m" # Cyan
RED="\033[31m" # Red
GRN="\033[32m" # Green
YLW="\033[33m" # Yellow
BLU="\033[34m" # Blue

create_account() {
    node=$1

    echo -e "${CYN}Creating account for $node ...${END}"

    mkdir -p $node

    echo -n -e "${CYN}Please enter a password for ACCOUNT1${END} (password): "
    read -r password

    echo $password > $node/password.txt

    output=$(docker run --rm -v $(pwd)/$node:/node/$node -w /node \
        ethereum/client-go:alltools-v1.13.11 \
        geth account new --datadir $node --password $node/password.txt)

    grep -o -e 'Public address of the key:[[:space:]]*0x[[:xdigit:]]\{40\}' \
        <<< "$output" | grep -o -e '[[:xdigit:]]\{40\}' > $node/address.txt
}

bootnode_genkey() {
    mkdir -p bootnode

    docker run --rm -v $(pwd)/bootnode:/node/bootnode -w /node \
        ethereum/client-go:alltools-v1.13.11 \
        bootnode --genkey=/node/bootnode/boot.key
}

init_node() {
    node=$1
    address=$2

    docker run --rm -v $(pwd):/node -w /node \
        ethereum/client-go:alltools-v1.13.11 \
        geth --datadir $node init /node/genesis.json
}

read_and_export() {
    echo -n -e "$1 ($2): "
    read -r var
    export $3=${var:-$2}
}

# Set up the genesis.json
echo -e "${CYN}We are setting up the genesis.json file${END}"

read_and_export "${CYN}Please enter the chain-id${END}" 12345 CHAIN_ID

read_and_export "${CYN}Please enter the clique.period${END}" 15 CLIQUE_PERIOD

read_and_export "${CYN}Please enter the clique.epoch${END}" 30000 CLIQUE_EPOCH

create_account node1
create_account node2
export ACCOUNT1=$(cat node1/address.txt)
export ACCOUNT2=$(cat node2/address.txt)

echo -e "${CYN}Creating the genesis.json file${END}"
envsubst < genesis.json.template > genesis.json
cat genesis.json | jq

# Set up the bootnode
bootnode_genkey

# Set up the nodes
init_node node1 $ACCOUNT1
init_node node2 $ACCOUNT2

echo -e "${GRN}All done!${END}"
