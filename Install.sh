#!/bin/bash

INSTALL_PATH="/usr/bin/autofan"

if [ $(id -u) -ne 0 ]; then
    echo -e "\e[31mThis must be run as root!\e[0m"
    exit 126
fi

base_dir=$(
    cd "$(dirname "$0")"
    pwd
)

echo "You are about to download and install the required items for HP ILO4 fan control."
read -rep "Do you accept? (Y/n): " ACCEPTED
case ${ACCEPTED:=yes} in
[yY][eE][sS] | [yY])
    # mkdir -p ~/autofan
    # cd ~/autofan
    echo "Installing required packages..."
    apt install sshpass wget lm-sensors jq -y
    # echo -e "\e[92mDownloading ILO_250 for ROM upgrade\e[0m"
    # wget -q https://gh.tj20.top/https://github.com/dongly/HP-ILO-Fan-Control/tree/me/Files/ilo_250
    echo -e "\e[92m Creating autofan service\e[0m"
    # wget -q https://gh.tj20.top/https://raw.githubusercontent.com/dongly/HP-ILO-Fan-Control/me/Files/autofan.service
    cp -f $base_dir/Files/autofan.service /etc/systemd/system/
    echo -e "\e[92m autofan service created\e[0m"
    read -rep $'Which server are you running?
    1. DL360p G8 (No ESXi)
    2. DL380p G8 (no ESXi)
    3. DL360p G8 (ESXi-based)
    4. DL380p G8 (ESXi-based)
    (Enter 1-4,default 2)' HOSTCHOICE
    HOSTCHOICE=${HOSTCHOICE:=2}
    echo Host Id is $HOSTCHOICE
    case $HOSTCHOICE in
    1)
        AUTOFANFILE="autofan.sh"
        HOSTTYPE="DL360p G8 (No ESXi)"
        ;;
    2)
        AUTOFANFILE="autofan-dl380p-g8.sh"
        HOSTTYPE="DL380p G8 (No ESXi)"
        ;;
    3)
        AUTOFANFILE="autofan-dl360p-g8-EXSI.sh"
        HOSTTYPE="DL360p G8 (ESXi-based)"
        ;;
    4)
        AUTOFANFILE="autofan-dl380p-g8-EXSI.sh"
        HOSTTYPE="DL370p G8 (ESXi-based)"
        ;;
    *)
        echo -e "\e[31mInvalid choice. Exiting.\e[0m"
        exit 1
        ;;
    esac

    echo "Preping autofan.sh for $HOSTTYPE"
    echo "Installing autofan.sh"
    # wget -q https://gh.tj20.top/https://raw.githubusercontent.com/dongly/HP-ILO-Fan-Control/me/Files/$AUTOFANFILE -O autofan.sh
    cp -f $base_dir/Files/$AUTOFANFILE $INSTALL_PATH
    chmod +x $INSTALL_PATH

    is_new_conf=1
    if [ -e /etc/autofan.conf ]; then
        echo /etc/autofan.conf:
        cat /etc/autofan.conf

        read -rep " /etc/autofan.conf 已存在,更新否? (y/N): " ACCEPTED2
        case {$ACCEPTED2:=no} in
        [yY][eE][sS] | [yY])
            echo
            ;;

        *)
            is_new_conf=0
            ;;

        esac
    fi
    if [[ is_new_conf -eq 1 ]]; then
        read -rep 'Enter iLO Username: ' ILOUSERNAME
        # read -rep 'Enter iLO Password: ' ILOPASSWORD
        read -rep 'Enter iLO IP/hostname: ' ILOHOST

        cat >/etc/autofan.conf <<EOF
USERNAME=$ILOUSERNAME
ILOIP=$ILOHOST
EOF
    fi
    echo 当前 /etc/autofan.conf:
    cat /etc/autofan.conf

    echo -e "\e[92mDone! Please visit the GitHub page to follow the instructions!\e[0m"
    echo -e "\e[1\https://github.com/That-Guy-Jack/HP-ILO-Fan-Control\e[0m"
    ;;

*)
    echo -e "\e[31m:( exiting\e[0m"
    exit 0
    ;;
esac
