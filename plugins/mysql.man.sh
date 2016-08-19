#!/bin/bash
TARGET=$HOME/mysql
BASEDIR=$TARGET
DATADIR=$TARGET/data
PORT=9797
VERSION=5.7.14
DB_DATABASE=siges
DB_USER=ufba
DB_PASS=ufba
MYSQL_PLATFORM="x86_64"
BASEURL="http://dev.mysql.com/get/Downloads/MySQL-5.7/mysql-5.7.14-linux-glibc2.5-x86_64.tar.gz"

show_help(){
    printf "Manager for MYSQL Portable!\n"
    printf "Created by Jeferson Lima\n\n"
    printf "Usage:\n"
    printf "\t./mysql.man.sh [option] [user/port/password] [password] [database]\n"
    printf "\nOptions:\n"
    printf "\tinstall\t\t\t\tInstall mysql-portable in %s/mysql\n" "$HOME"
    printf "\trun [port]\t\t\tRun mysql daemon, the default port is %s in localhost\n" "$PORT"
    printf "\tcreate-db [user] [pass] [db]\tCreate a db, the default db name is %s, if user and password aren't\n" "$DB_DATABASE"
    printf "\t\t\t\t\tspecified all priveleges go to default user %s pass %s\n" "$DB_USER" "$DB_PASS"
    printf "\tconnect [user] [pass] [port]\tConnect with the specified user and password, default user\n"
    printf "\t\t\t\t\tis %s and default password is %s\n" "$DB_USER" "$DB_PASS"
    printf "\tchange-password [user] [pass]\tChange user password\n"
    printf "\tdownload\t\t\t\tDownload binarie files\n"
    printf "\thelp\t\t\t\tShow this help message\n"
}

download_app(){
    mkdir "$(pwd)/bin"
    wget -O "$(pwd)/bin/mysql-""$VERSION""-linux-$MYSQL_PLATFORM.tar.gz" "$BASEURL"
}

if [ $# -eq 0 ] || [ $# -gt 4 ];then
	show_help
	exit 1
fi

case $1 in
    install)
        if [ $# -gt 1 ]; then
            show_help
            exit 1
        fi
        # Create installation folder
        mkdir -p "$TARGET"
        mkdir -p "$DATADIR"
        mkdir -p "$TARGET/var/run/mysql"
        mkdir -p "$TARGET/var/log/mysql"
        # Install mysql files
        # If binarie files not exist
        if [ ! -e "$(pwd)/bin" ] || [ ! -e "$(pwd)/bin/mysql-""$VERSION""-linux-$MYSQL_PLATFORM.tar.gz" ];then
            download_app
        fi
        tar -zxvf "$(pwd)/bin/mysql-""$VERSION""-linux-$MYSQL_PLATFORM.tar.gz" -C "$TARGET"
        mv "$TARGET/mysql-""$VERSION""-linux-$MYSQL_PLATFORM"/* "$TARGET"
        rmdir "$TARGET/mysql-""$VERSION""-linux-$MYSQL_PLATFORM"
        # Initialize Database
        "$TARGET/bin/mysqld" --user="$USER" \
            --basedir="$BASEDIR" \
            --datadir="$DATADIR" \
            --initialize-insecure
        echo "Installed mysql-portable successfully!"
        ;;
    download)
        if [ ! -e "$(pwd)/bin" ] || [ ! -e "$(pwd)/bin/mysql-""$VERSION""-linux-$MYSQL_PLATFORM.tar.gz" ];then
            download_app
        fi
        ;;
    run)
        if [ $# -eq 2 ];then
            PORT=$2
        elif [ $# -eq 1 ];then
            echo "Starting daemon"
        else
            show_help
            exit 1
        fi
        "$BASEDIR/bin/mysqld_safe" \
            --user="$USER" \
            --basedir="$BASEDIR" \
            --datadir="$DATADIR" \
            --pid-file="$TARGET/var/run/mysql/mysql.pid" \
            --skip-syslog \
            --log-error="$TARGET/var/log/mysql/mysql.err" \
            --port="$PORT" \
            --socket="$TARGET/var/run/mysqld/mysqld.sock" \
            --ledir="$BASEDIR/bin" \
            --mysqld=mysqld \
            --bind-address=0.0.0.0
        echo "Started mysql-portable daemon"
        ;;
    connect)
        if [ $# -eq 1 ]; then
            echo "Connecting with default settings"
        elif [ $# -eq 2 ];then
            DB_USER=$2
        elif [ $# -eq 3 ]; then
            DB_USER=$2
            DB_PASS=$3
        elif [ $# -eq 4 ]; then
            DB_USER=$2
            DB_PASS=$3
            PORT=$4
        else
            show_help
            exit 1
        fi
        "$BASEDIR/bin/mysql" --user="$DB_USER" --password="$DB_PASS" --socket="$TARGET/var/run/mysqld/mysqld.sock" --port="$PORT"
        echo "Connected!"
        ;;
    create-db)
        if [ $# -eq 1 ];then
            echo "Creating user with default settings"
        elif [ $# -eq 2 ];then
            DB_USER=$2
        elif [ $# -eq 3 ];then
            DB_USER=$2
            DB_PASS=$3
        elif [ $# -eq 4 ];then
            DB_USER=$2
            DB_PASS=$3
            DB_DATABASE=$4
        else
            show_help
            exit 1
        fi
        "$BASEDIR/bin/mysql" -u root --socket="$TARGET/var/run/mysqld/mysqld.sock" -e "CREATE DATABASE IF NOT EXISTS $DB_DATABASE; GRANT ALL PRIVILEGES ON $DB_DATABASE.* TO $DB_USER@localhost identified by '$DB_PASS';"
        echo "Create database successfully!"
        ;;
    change-password)
        if [ $# -eq 3 ];then
            USER_MUDAR=$2
            PASSWORD_MUDAR=$3
        else
            show_help
            exit 1
        fi
        "$BASEDIR/bin/mysqladmin" --user="root" --socket="$TARGET/var/run/mysqld/mysqld.sock" password "$PASSWORD_MUDAR"
        echo "Changed $USER_MUDAR password successfully!"
        ;;
    help)
        show_help
        exit 0
        ;;
    *)
        show_help
        exit 1
        ;;
esac
