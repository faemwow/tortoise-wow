#!/usr/bin/env bash
#!/bin/bash
set -e

BUNDLE_DIR="./snapjaw-wow-bundle"
mkdir -p "$BUNDLE_DIR"
mkdir -p "$BUNDLE_DIR/tortoise-files/etc"
mkdir -p "$BUNDLE_DIR/tortoise-files/data/maps"
mkdir -p "$BUNDLE_DIR/tortoise-files/data/vmaps"
mkdir -p "$BUNDLE_DIR/tortoise-files/data/mmaps"
mkdir -p "$BUNDLE_DIR/tortoise-files/db-data"

echo "=== Saving Docker images ==="
echo "Saving tortoise-wow-db..."
sudo docker save tortoise-wow-db:latest | gzip > "$BUNDLE_DIR/tortoise-wow-db.tar.gz"

echo "Saving tortoise-wow-realmd..."
sudo docker save tortoise-wow-realmd:latest | gzip > "$BUNDLE_DIR/tortoise-wow-realmd.tar.gz"

echo "Saving tortoise-wow-mangosd..."
sudo docker save tortoise-wow-mangosd:latest | gzip > "$BUNDLE_DIR/tortoise-wow-mangosd.tar.gz"

echo "=== Copying config files ==="
cp ./tortoise-files/etc/mangosd.conf "$BUNDLE_DIR/tortoise-files/etc/mangosd.conf"
cp ./tortoise-files/etc/realmd.conf "$BUNDLE_DIR/tortoise-files/etc/realmd.conf"

echo "=== Copying docker-compose.yml ==="
cp ./docker-compose.yml "$BUNDLE_DIR/docker-compose.yml"

echo "=== Copying install script ==="
cp ./install-db.sh "$BUNDLE_DIR/install_db.sh"
chmod +x "$BUNDLE_DIR/install_db.sh"

echo "=== Writing README ==="
cat > "$BUNDLE_DIR/README.md" << 'EOF'
# Project Snapjaw - Turtle WoW Private Server

## Default Account
- **Username:** snapjaw
- **Password:** snapjaw

## Requirements
- Docker + Docker Compose
- ~20GB free disk space
- WoW 1.17.2 client map data (see below)

## Directory Structure
After extracting this bundle you should have:
```
tortoise-wow-bundle/
├── docker-compose.yml
├── install_db.sh
├── tortoise-files/
│   ├── etc/
│   │   ├── mangosd.conf
│   │   └── realmd.conf
│   ├── db-data/        (populated by install_db.sh)
│   └── data/
│       ├── maps/       <- YOU MUST PROVIDE THESE
│       ├── vmaps/      <- YOU MUST PROVIDE THESE
│       └── mmaps/      <- YOU MUST PROVIDE THESE
└── *.tar.gz            (docker images)
```

## Map Data
The `maps`, `vmaps`, and `mmaps` directories must be extracted from your
WoW 1.17.2 client using the MaNGOS map extraction tools. These are not
included in this bundle due to their size. Place them in:
- `tortoise-files/data/maps/`
- `tortoise-files/data/vmaps/`
- `tortoise-files/data/mmaps/`

## Setup Instructions

### 1. Load the Docker images
```bash
docker load < tortoise-wow-db.tar.gz
docker load < tortoise-wow-realmd.tar.gz
docker load < tortoise-wow-mangosd.tar.gz
```

### 2. Start the containers
```bash
docker compose up -d
```

### 3. Initialise the databases (first time only)
Make sure the `./sql` directory from the repo is present, then run:
```bash
chmod +x install_db.sh
./install_db.sh
```

### 4. Restart mangosd to pick up the populated DB
```bash
docker compose restart mangosd
```

### 5. Connect
Point your WoW 1.17.2 client `realmlist.wtf` to:
```
set realmlist 127.0.0.1
```
Then log in with username `snapjaw` and password `snapjaw`.

## Useful Commands

Attach to the mangosd console (detach with Ctrl+P then Ctrl+Q):
```bash
docker attach tortoise-wow-mangosd-1
```

Open a MariaDB shell:
```bash
docker exec -it tortoise-wow-db-1 mariadb -u root --socket=/var/run/mysqld/mysqld.sock
```

View logs:
```bash
docker logs tortoise-wow-mangosd-1
docker logs tortoise-wow-db-1
```
EOF

echo "=== Creating final tar archive ==="
tar -czf snapjaw-wow-bundle.tar.gz -C . snapjaw-wow-bundle/

echo "=== Cleaning up staging dir ==="
rm -rf "$BUNDLE_DIR"

echo "=== Done! Bundle saved to tortoise-wow-bundle.tar.gz ==="
