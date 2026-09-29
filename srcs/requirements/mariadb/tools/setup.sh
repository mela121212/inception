#!/bin/sh

set -e

echo "[$(date '+%Y-%m-%d %H:%M:%S')] Initializing MariaDB..."

DB_PASSWORD=$(cat /run/secrets/db_password 2>/dev/null || echo "${MYSQL_PASSWORD}")
DB_ROOT_PASSWORD=$(cat /run/secrets/db_root_password 2>/dev/null || echo "${MYSQL_ROOT_PASSWORD}")

: "${DB_PASSWORD:?Database password is not defined}"
: "${DB_ROOT_PASSWORD:?Root database password is not defined}"
: "${MYSQL_DATABASE:?MYSQL_DATABASE is not defined}"
: "${MYSQL_USER:?MYSQL_USER is not defined}"

DATADIR="/var/lib/mysql"
SOCKET="/run/mysqld/mysqld.sock"
INIT_FILE="/tmp/mariadb-init.sql"
INIT_LOG="/tmp/mariadb-init.log"

mkdir -p /run/mysqld

chown -R mysql:mysql /run/mysqld
chown -R mysql:mysql "$DATADIR"

if [ ! -d "$DATADIR/mysql" ]; then
    echo "MariaDB data directory is empty. Initializing database..."

    mariadb-install-db \
        --user=mysql \
        --basedir=/usr \
        --datadir="$DATADIR" \
        > /dev/null

    cat > "$INIT_FILE" <<SQL
ALTER USER 'root'@'localhost'
    IDENTIFIED BY '${DB_ROOT_PASSWORD}';

CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_general_ci;

CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%'
    IDENTIFIED BY '${DB_PASSWORD}';

ALTER USER '${MYSQL_USER}'@'%'
    IDENTIFIED BY '${DB_PASSWORD}';

GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';

FLUSH PRIVILEGES;

SHUTDOWN;
SQL

    chown mysql:mysql "$INIT_FILE"

    echo "Starting MariaDB initialization in foreground..."

    if ! mariadbd \
        --user=mysql \
        --datadir="$DATADIR" \
        --socket="$SOCKET" \
        --skip-networking \
        --init-file="$INIT_FILE" \
        --console \
        > "$INIT_LOG" 2>&1
    then
        echo "MariaDB initialization failed."
        cat "$INIT_LOG"
        rm -f "$INIT_FILE"
        exit 1
    fi

    rm -f "$INIT_FILE"

    echo "MariaDB initialized successfully."
else
    echo "MariaDB data already exists. Skipping initialization."
fi

echo "Starting MariaDB daemon..."

exec mariadbd \
    --user=mysql \
    --datadir="$DATADIR" \
    --socket="$SOCKET" \
    --console \
    --port=3306 \
    --bind-address=0.0.0.0
