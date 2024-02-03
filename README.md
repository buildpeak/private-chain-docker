# My Private Chain

## 1. Install `geth`

## Create account

```
geth account new --datadir node1
geth account new --datadir node2
```

Example output:

```
Public address of the key:   0x9748B8D59B75596204ea3f6A5028dDCf63F034FE
Path of the secret key file: node1/keystore/UTC--2024-01-29T14-32-10.707043000Z--9748b8d59b75596204ea3f6a5028ddcf63f034fe
```

```
Public address of the key:   0x4Ed9D3B37a343b5315944E63b486c75254C20ad9
Path of the secret key file: node2/keystore/UTC--2024-01-29T15-37-35.199967000Z--4ed9d3b37a343b5315944e63b486c75254c20ad9
```

````

## 2. Create genesis.json

```JSON
{
  "config": {
    "chainId": 12345,
    "homesteadBlock": 0,
    "eip150Block": 0,
    "eip155Block": 0,
    "eip158Block": 0,
    "byzantiumBlock": 0,
    "constantinopleBlock": 0,
    "petersburgBlock": 0,
    "istanbulBlock": 0,
    "berlinBlock": 0,
    "clique": {
      "period": 5,
      "epoch": 30000
    }
  },
  "difficulty": "1",
  "gasLimit": "8000000",
  "extradata": "0x00000000000000000000000000000000000000000000000000000000000000009748b8d59b75596204ea3f6a5028ddcf63f034fe4Ed9D3B37a343b5315944E63b486c75254C20ad90000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
  "alloc": {
    "9748b8d59b75596204ea3f6a5028ddcf63f034fe": { "balance": "30000000000000000000" },
    "4Ed9D3B37a343b5315944E63b486c75254C20ad9": { "balance": "20000000000000000000" }
  }
}
````

## 3. Initialize Geth Database

```
geth init --datadir node1 genesis.json
geth init --datadir node2 genesis.json
```

## 4. Set Networking (bootnode)

```
bootnode -genkey boot.key
bootnode -nodekey boot.key -addr 127.0.0.1:30305
```

Example bootnode URL:

```
enode://ee4b066d023dd5488d19b016ca9d846088f77e5d33f0165496bf77265b4c72cd1871a9aedf17b9793f1694dae623f78ef9d2759afbaa62dc08fa14098446307d@127.0.0.1:0?discport=30305
```

## 5. Run Nodes

```bash
geth --datadir node1 --port 30306 --bootnodes enode://ee4b066d023dd5488d19b016ca9d846088f77e5d33f0165496bf77265b4c72cd1871a9aedf17b9793f1694dae623f78ef9d2759afbaa62dc08fa14098446307d@127.0.0.1:0\?discport=30305 --networkid 12345 --unlock 0x9748B8D59B75596204ea3f6A5028dDCf63F034FE --password node1/password.txt --authrpc.port 8551 --mine --miner.etherbase 0x9748B8D59B75596204ea3f6A5028dDCf63F034FE --syncmode full --http --allow-insecure-unlock
```

```bash
geth --datadir node2 --port 30307 --bootnodes enode://f7aba85ba369923bffd3438b4c8fde6b1f02b1c23ea0aac825ed7eac38e6230e5cadcf868e73b0e28710f4c9f685ca71a86a4911461637ae9ab2bd852939b77f@127.0.0.1:0\?discport=30305 --networkid 12345 --unlock 0x4Ed9D3B37a343b5315944E63b486c75254C20ad9 --password node2/password.txt --authrpc.port 8552 --mine --miner.etherbase 0x4Ed9D3B37a343b5315944E63b486c75254C20ad9 --syncmode full
```

## 6. Run in Tmux

```bash
./start.sh
```
