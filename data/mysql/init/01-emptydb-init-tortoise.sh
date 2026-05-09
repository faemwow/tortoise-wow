#!/usr/bin/env bash
set -e

# The entrypoint automatically passes the root password via environment variables
# We use 'mariadb' directly without docker exec
MYSQL="mariadb -u root -p$MARIADB_ROOT_PASSWORD"
SQL_DIR="/sql_imports"

run_sql() {
  local db="$1"
  local file="$2"
  echo "  -> Applying $file to $db"
  $MYSQL -f "$db" < "$file"
}

echo "=== Step 1: Creating databases ==="
$MYSQL < "$SQL_DIR/create_databases.sql"

echo "=== Step 2: Applying base world tables ==="
# We glob the files inside the container's mount path
for f in "$SQL_DIR"/base/tw_world_*.sql; do
  [ -e "$f" ] || continue
  run_sql "tw_world" "$f"
done

echo "=== Step 3: Adding realm entry ==="
# Determine address: Use REALM_HOST_ADDRESS if set, otherwise default to 127.0.0.1
FINAL_ADDR="${REALM_HOST_ADDRESS:-127.0.0.1}"

$MYSQL tw_logon -e "
INSERT INTO realmlist (id, name, address, port, icon, realmflags, timezone, allowedSecurityLevel, population, realmbuilds)
VALUES (1, 'Project Snapjaw', '$FINAL_ADDR', 8085, 0, 0, 1, 0, 0, '5875,7272')
ON DUPLICATE KEY UPDATE address=VALUES(address), port=VALUES(port);

INSERT INTO realmlist (id, name, address, port, icon, realmflags, timezone, allowedSecurityLevel, population, realmbuilds)
VALUES (2, 'Dev Snapjaw', '$FINAL_ADDR', 8086, 0, 0, 1, 0, 0, '5875,7272')
ON DUPLICATE KEY UPDATE address=VALUES(address), port=VALUES(port);

GRANT ALL PRIVILEGES ON tw_world.* TO 'mangos'@'%';
GRANT ALL PRIVILEGES ON tw_char.* TO 'mangos'@'%';
GRANT ALL PRIVILEGES ON tw_logon.* TO 'mangos'@'%';
GRANT ALL PRIVILEGES ON tw_logs.* TO 'mangos'@'%';
FLUSH PRIVILEGES;
"

echo "=== Step 4: Create Allowed Client Builds ==="
$MYSQL tw_logon < "$SQL_DIR/allowed_client_setup.sql"
echo "=== Done! ==="

