JAVA_VERSION="8u101"
NB_VERSION="8_1"
JAVA_PLATFORM="x64"
# Installer FILE
INSTALLER_NAME="jdk-""$JAVA_VERSION""-nb-""$NB_VERSION""-linux-$JAVA_PLATFORM.sh"
INSTALLER="$(pwd)/bin/$INSTALLER_NAME"
# Latest JDK8 version released on 19th July, 2016: JDK8u101
BASE_URL="http://download.oracle.com/otn-pub/java/jdk-nb/""$JAVA_VERSION""-8.1/"
JDK_NB_URL="$BASE_URL$INSTALLER_NAME"

show_help(){
    printf "Manager for Java JDK with Netbeans Portable!\n"
    printf "Created by Jeferson Lima\n\n"
    printf "Usage:\n"
    printf "\t./java.man.sh [option]\n"
    printf "\nOptions:\n"
    printf "\tinstall\tInstall Java JDK\n" "$HOME"
    printf "\tdownload\tDownload binaries for installation\n"
    printf "\thelp\tShow this help message\n"
}

download_app(){
    echo "Downloading java jdk with netbeans"
    mkdir "$(pwd)/bin"
    wget -c -O "$(pwd)/bin/$INSTALLER_NAME" --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" "$JDK_NB_URL" || rm "$INSTALLER"
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
        echo "downloading java"
        "$INSTALLER"
        ;;
    download)
        if [ ! -e "$(pwd)/bin" ] || [ ! -e "$(pwd)/bin/$INSTALLER_NAME" ];then
            download_app
        fi
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
