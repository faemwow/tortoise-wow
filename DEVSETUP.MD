# Clone the dev branch for its sql files
`git clone -b 1181dev 'https://github.com/faemwow/tortoise-wow.git' ../tortoise-wow-dev`
# Copy your existing mangosd.conf and adjust for dev
`cp data/etc/mangosd.conf data/etc/mangosd-dev.conf`
```
# Then edit mangosd-dev.conf:
WorldServerPort = 8086
LoginDatabaseInfo = "db-dev;3306;mangos;mangos;tw_logon"
WorldDatabaseInfo = "db-dev;3306;mangos;mangos;mangos"
CharacterDatabaseInfo = "db-dev;3306;mangos;mangos;characters"
```
```
# Add the dev realm to the realmlist (run after stack is up), this should be on the db not db-dev since thats what realmd uses.
INSERT INTO realmlist (name, address, port, icon, realmflags, timezone, allowedSecurityLevel, population, realmbuilds)
VALUES ('Project Snapjaw Dev', '192.168.1.x', 8086, 0, 0, 1, 0, 0, 5875);
```

# Bring everything up
`sudo docker compose -f docker-compose-dev.yml up -d`

# To sync dev sql later
`cd ~/tortoise-wow-dev && git pull`
