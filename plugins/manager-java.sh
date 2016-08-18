JAVA_VERSION="8u101"
NB_VERSION="8_1"

show_help(){
    printf "Manager for Java JDK with Netbeans Portable!\n"
    printf "Created by Jeferson Lima\n\n"
    printf "Usage:\n"
    printf "\t./manager-jdk.sh [option]\n"
    printf "\nOptions:\n"
    printf "\tinstall\tInstall Java JDK\n" "$HOME"
    printf "\thelp\tShow this help message\n"
}


if [ $# -gt 1 ] || [ $# -eq 0 ];then
    show_help
    exit 1
fi

case $1 in
    install)
        "$(pwd)/jdk-""$JAVA_VERSION""-nb-""$NB_VERSION""-linux-x64.sh"
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
