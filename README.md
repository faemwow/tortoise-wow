
# Tortoise-WoW

This is an unofficial, community driven, restoration of the 1.18.1 patch of Turtle-WoW, with some additions for solo play.  
This project is not to be used for profit or to misrepresent itself, or anyone using it, as the original creators  
This project targets version 1.18.1 build 7272

## Client Version

The client version targetted is patch 1.18.1, build 7272  
Any client that does not match this version or build will likely have a myriad of issues

## Additions
Additions will be added as the core code reaches feature completion

#### Current Additions

- **Autoscale** - Rudimentary toggleable dungeon/raid auto scaling system, found in mangosd.conf
- **Leech** - Basic toggleable leech system designed for solo play, found in mangosd.conf
- **Additional Talent Points** - Mostly used for testing, found in tw_char.characters

#### Planned Additions

- **[Playerbots][20]** - Currently implemented in a very basic fashion, not ready for use
- **[Eluna][19]** - The WoW lua engine

## Operating Systems

* **[Windows][15]**, 32 bit and 64 bit. Windows Server 2008 (or newer) or Windows 8 (or newer) is recommended.
* **Linux**, 32 bit and 64 bit. [Ubuntu 22.04 LTS][14] is recommended. Other distributions with similar package versions will work, too.
Of course, newer versions should work, too. In the case of Windows, matching
server versions will work, too.

## Dependencies

* **[Git][1] / [Github for Windows][2]**: This version control software allows you to get the source files in the first place.
* **[MySQL][3]** / **[MariaDB][4]**: These databases are used to store content and user data.
* **[ACE][5]**: aka Adaptive Communication Environment, provides us with a solid cross-platform framework for abstracting operating system specific details.
* **[Recast][21]**: In order to create navigation data from the client's map files, Recast is used to do the dirty work. It provides functions for rendering, pathing, etc.
* **[G3D][6]**: This engine provides the basic framework for handling 3D data and is used to handle basic map data.
* **[Stormlib][7]**: Provides an abstraction layer for reading from the client's data files.
* **[Zlib][8]/[Zlib for Windows][9]** provides compression algorithms used in both MPQ archive handling and the client/server protocol.
* **[Bzip2][10]/[Bzip2 for Windows][11]** provides compression algorithms used in MPQ archives.
* **[OpenSSL][12]/[OpenSSL for Windows][13]** provides encryption algorithms used when authenticating clients.

To build this project follow any MaNGOS/MaNGOS Zero build guide, with the addition of ACE  

## Database Setup

1. Manually import sql/create_databases.sql
2. Manually import all sql scripts in the sql/base folder
3. Run mangosd to automatically import and track updates  

This will be streamlined once the core is more up to date

## Extracting DBC, MMAP, MAP, VMAP
These come from proprietary files we do not distribute. If you have access to a Turtle-WoW client (1.18.1), you can extract this via
```
export TORTOISE_DATA_DIR=./data
export WOW_CLIENT_DIR=/path/to/twow-client

docker run --rm -it \
  -v ${TORTOISE_DATA_DIR:-./data}/dbc:/tortoise/dbc \
  -v ${TORTOISE_DATA_DIR:-./data}/maps:/tortoise/maps \
  -v ${TORTOISE_DATA_DIR:-./data}/vmaps:/tortoise/vmaps \
  -v ${TORTOISE_DATA_DIR:-./data}/mmaps:/tortoise/mmaps \
  -v ${WOW_CLIENT_DIR}:/wow-client \
  -v ./run-local-extractors.sh:/script/run-local-extractors.sh \
  --entrypoint /bin/bash \
  ghcr.io/faemwow/tortoise-wow-mangosd:latest \
  /script/run-local-extractors.sh
```
Extracting is a one time process that can take hours.

## Using docker
This is instructions for Linux. You can configure the containers by modifying `docker-compose.yml` or making your own.

TODO: I need these tested on Windows and MacOS. Docker Desktop instructions might differ.

### Starting MariaDB, Mangosd, Realmd
```
git clone https://github.com/faemwow/tortoise-wow/
cd tortoise-wow
#populate data/ directory
docker compose up -d
```

#### View logs for containers
```
docker compose logs db 
```

the data/mysql/ should be clean for initalizing. You can delete everything except data/mysql/init/*. 
#### Manually applying sql db updates (usually not needed)

```
docker compose exec db bash -c 'for f in /sql_imports/base/tw_world_*.sql; do
  [ -e "$f" ] || continue
  mariadb -uroot -proot "tw_world" < "$f"
done
'
```

### Use the mangosd console (account creates etc)
```
docker compose attach mangosd
account create snapjaw snapjaw
Account created: snapjaw
mangos>
# Control + p then Control + q to detach from the mangosd console. 
# Do not control + c as it will kill mangosd. 
```

### Troubleshooting
Docker compose on Linux sometimes has issues with network bridges. You can use network host if you are okay with the containers running as if they were a process on the and using host ports. 


## Contributing

Contributions are welcome, but I may be slow to review and merge PRs

See `CONTRIBUTING.md` for ways to get started.

