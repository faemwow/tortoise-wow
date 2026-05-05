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

echo "=== Step 2: Adding realm entry ==="
$MYSQL tw_logon -e "
INSERT INTO realmlist (name, address, port, icon, realmflags, timezone, allowedSecurityLevel, population, realmbuilds)
VALUES ('Project Snapjaw', '127.0.0.1', 8085, 0, 0, 1, 0, 0, '5875')
ON DUPLICATE KEY UPDATE address=VALUES(address), port=VALUES(port);
"

echo "=== Done! ==="

