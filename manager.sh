show_help(){
    printf "Manager for Portable Appllications!\n"
    printf "Created by Jeferson Lima\n\n"
    printf "Usage:\n"
    printf "\t./manager-general.sh [option]\n"
    printf "\nOptions:\n"
    printf "\tinstall [app_name]\tInstall application\n"
    printf "\tdownload [app_name]\tDownload application binarie\n"
    printf "\thelp\t\t\tShow this help message\n"
    printf "\nApps available:\n"
    printf "\tall\t\tAll applications below\n"
    printf "\tjava\t\tJava JDK with netbeans\n"
    printf "\tmysql\t\tMysql Server\n"
    printf "\tspring-ide\tSpring Tools IDE, Eclipse\n"
}

install_app(){
    if [ $# -ne 1 ];then
        echo "App not specified"
        exit 1
    fi
    APP_NAME=$1
    echo "Installing $APP_NAME..."
    DIR_NAME="$(pwd)/$APP_NAME.man"
    # If plugin is not prepared
    if [ ! -e DIR_NAME ];then
        # Create plugin folder and copy plugin installer
        mkdir "$DIR_NAME"
        ln -s "$(pwd)/plugins/$APP_NAME.man.sh" "$DIRNAME/"
    fi
    # Executine routine to install application
    "$DIR_NAME/$APP_NAME.man.sh" install
}

download_app(){
    if [ $# -ne 1 ];then
        echo "App not specified"
        exit 1
    fi
    APP_NAME=$1
    echo "Configuring $APP_NAME..."
    DIR_NAME="$(pwd)/$APP_NAME.man"
    # If plugin is not prepared
    if [ ! -e DIR_NAME ];then
        # Create plugin folder and copy plugin installer
        mkdir "$DIR_NAME"
        ln -s "$(pwd)/plugins/$APP_NAME.man.sh" "$DIRNAME/$APP_NAME.man.sh"
    fi
    # Executine routine to configure application
    "$DIR_NAME/$APP_NAME.man.sh" download
}


if [ $# -gt 2 ] || [ $# -eq 0 ];then
    show_help
    exit 1
fi

case $1 in
    install)
        if [ $# -ne 2 ];then
            show_help
            exit 1
        fi
        case $2 in
            all)
                install_app java
                install_app mysql
                ;;
            *)
                if [ ! -e "$(pwd)/plugins/$2.man.sh" ];then
                    echo "Plugin not found!"
                    show_help
                    exit 1
                fi
                install_app $2
                ;;
        esac
        ;;
    download)
        if [ $# -ne 2 ];then
            show_help
            exit 1
        fi
        case $2 in
            all)
                download_app java
                download_app mysql
                ;;
            *)
                if [ ! -e "$(pwd)/plugins/$2.man.sh" ];then
                    echo "Plugin not found!"
                    show_help
                    exit 1
                fi
                download_app $2
                ;;
        esac
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
