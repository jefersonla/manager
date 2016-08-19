APP_VERSION="3.8.1"
APP_PLATFORM="x86_64"
# Installer FILE
INSTALLER_NAME="spring-tool-suite-""$APP_VERSION"".RELEASE-e4.6-linux-gtk-""$APP_PLATFORM"".tar.gz"
BASE_URL="http://dist.springsource.com/release/STS/""$APP_VERSION"".RELEASE/dist/e4.6/spring-tool-suite-""$APP_VERSION"".RELEASE-e4.6-linux-gtk-""$APP_PLATFORM"".tar.gz"
EXECUTABLE_STS="$HOME/spring/sts-bundle/sts-""$APP_VERSION"".RELEASE/STS"

show_help(){
    printf "Manager for Spring IDE!\n"
    printf "Created by Jeferson Lima\n\n"
    printf "Usage:\n"
    printf "\t./spring-ide.man.sh [option]\n"
    printf "\nOptions:\n"
    printf "\tinstall\t\tInstall Spring IDE\n" "$HOME"
    printf "\tdownload\tDownload binaries for installation\n"
    printf "\trun\t\tRun Spring IDE\n"
    printf "\thelp\t\tShow this help message\n"
}

download_app(){
    echo "Downloading Spring IDE..."
    mkdir "$(pwd)/bin"
    wget -c -O "$(pwd)/bin/$INSTALLER_NAME" "$BASE_URL" || rm "$INSTALLER"
}

install_app(){
    mkdir $HOME/spring
    tar -zxvf "$(pwd)/bin/$INSTALLER_NAME" -C "$HOME/spring"
}

if [ $# -gt 1 ] || [ $# -eq 0 ];then
    show_help
    exit 1
fi

case $1 in
    install)
        if [ ! -e "$(pwd)/bin" ] || [ ! -e "$(pwd)/bin/$INSTALLER_NAME" ];then
            download_app
        fi
        echo "Spring IDE download complete"
        install_app
        ;;
    download)
        if [ ! -e "$(pwd)/bin" ] || [ ! -e "$(pwd)/bin/$INSTALLER_NAME" ];then
            download_app
        fi
        ;;
    run)
        JAVA_HOME="$HOME/java"
        PATH="$PATH:$HOME/java/bin"
        "$EXECUTABLE_STS"
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
