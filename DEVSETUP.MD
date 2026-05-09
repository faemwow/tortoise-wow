# Clone the dev branch for its sql files
`git clone -b 1181dev 'https://github.com/faemwow/tortoise-wow.git' ../tortoise-wow-dev`
# Copy your existing mangosd.conf and adjust for dev
`cp data/etc/mangosd.conf data/etc/mangosd-dev.conf`
```
# Then edit mangosd-dev.conf:
RealmID = 2

WorldServerPort = 8086
LoginDatabase.Info = "db;3306;mangos;mangos;tw_logon"
WorldDatabase.Info = "db-dev;3306;mangos;mangos;tw_world"
CharacterDatabase.Info = "db-dev;3306;mangos;mangos;tw_char"
LogsDatabase.Info  = "db-dev;3306;mangos;mangos;tw_logs"

```

# Bring everything up
`sudo docker compose -f docker-compose-dev.yml up -d`

# Update to latest docker images
`sudo docker compose -f docker-compose-dev.yml pull`

# to turn off
`sudo docker compose -f docker-compose-dev.yml down`

# get a shell on a container 
`sudo docker compose -f docker-compose-dev.yml exec db bash`

# use mangosd console
`sudo docker compose -f docker-compose-dev.yml attach mangosd`

# To sync dev sql for the dev-db
`cd ~/tortoise-wow-dev && git pull`
