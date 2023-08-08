#!/bin/bash
HOME="/home/container"
HOMEA="$HOME/linux/.apt"
export BUILD_DIR=$HOMEA
LINUX_ISO=Ubuntu
bold=$(echo -en "\e[1m")
nc=$(echo -en "\e[0m")
lightblue=$(echo -en "\e[94m")
lightgreen=$(echo -en "\e[92m")
lightred=$(echo -en "\e[31m")
redback=$(echo -en "\e[41m")

echo "
${bold}${lightgreen}===================================================================================



${bold}${lightblue} STARTING PLEASE WAIT ...



${bold}${lightgreen}===================================================================================
  
 "

    if [ $LINUX_ISO = "DEBIAN" ]; then
        linux_iso="https://github.com/termux/proot-distro/releases/download/v3.3.0/debian-x86_64-pd-v3.3.0.tar.xz"
        bash=("/bin/bash -c")
    if [ $install = "0" ]; then
        cmds=("mv gotty /usr/bin/" "mv unzip /usr/bin/" "mv ngrok /usr/bin/" "apt clean" "apt-get update" "apt-get -y upgrade" "apt-get -y install sudo curl wget hwloc htop nano neofetch python3")
        else
        cmds=("apt clean" "apt-get update" "apt-get -y upgrade" "apt-get -y install python3")
        fi
    fi
    if [ $LINUX_ISO = "Ubuntu" ]; then
        linux_iso="https://partner-images.canonical.com/core/bionic/current/ubuntu-bionic-core-cloudimg-amd64-root.tar.gz"
        bash=("/bin/bash -c")
        if [ $install = "0" ]; then
        cmds=("mv gotty /usr/bin/" "mv unzip /usr/bin/" "mv ngrok /usr/bin/" "apt clean" "rm -rf /etc/apt/trusted.gpg.d/*" "apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 3B4FE6ACC0B21F32" "apt-get update" "apt-get -y upgrade" "apt-get -y install sudo curl wget hwloc htop nano neofetch python3")
        else
        cmds=("apt clean" "apt-get update" "apt-get -y upgrade" "apt-get -y install python3")
        fi
    fi
    if [ $LINUX_ISO = "Alpine" ]; then
        linux_iso="https://github.com/termux/proot-distro/releases/download/v3.3.0/alpine-x86_64-pd-v3.3.0.tar.xz"
        bash=("/bin/ash -c")
        if [ $install = "0" ]; then
        cmds=("apk cache clean" "apk update" "apk upgrade" "apk add --upgrade sudo curl wget hwloc htop nano neofetch python3 unzip")
        else
        cmds=("apk cache clean" "apk update" "apk upgrade")
        fi
    fi
fi

console=$([ "${CONSOLE}" == "1" ] && echo "${CONSOLE_OCC}" || echo "-0 -r . -b /dev -b /proc -b /sys -w / -b .")

if [ -z "${PROOT}" ]; then
    proot="./libraries/proot"
fi
if [ "${PROOT}" = "PRoot (padrão)" ]; then
    proot="./libraries/proot"
fi
if [ "${PROOT}" = "PRoot-rs" ]; then
    proot="./libraries/proot-rs"
fi
if [ "${PROOT}" = "FakechRoot + FakeRoot" ]; then
    proot="fakechroot fakeroot"
fi

echo "${nc}"

if [[ -f "./libraries/instalado" ]]; then

    if [ "${PROOT}" = "PRoot-rs" ]; then
        echo "

${bold}${lightred}⛔️ Root running using Porto-rs, do you know what you're doing?
        "
    fi
    if [ "${PROOT}" = "FakechRoot + FakeRoot" ]; then
        echo "

${bold}${lightred}⛔️ Root running from FakeRoot + FakeRoot, do you know what you're doing?
${bold}${lightred}⛔️  To use this variable, you have to be using docker: ashu11a/proot:latest
        "
    fi
   
    echo "✅ Starting VPS"
    echo "${bold}${lightgreen}==> ${lightblue}Starting${lightgreen} Container <=="
    function runcmd1 {
        printf "${bold}${lightgreen}vRoot${nc}@${lightblue}Container${nc}:~ "
        read -r cmdtorun
        $proot  $console $bash "$cmdtorun"
        runcmd
    }
    function runcmd {
        printf "${bold}${lightgreen}vRoot${nc}@${lightblue}Container${nc}:~ "
        read -r cmdtorun
        $proot $console $bash "$cmdtorun"
        runcmd1
    }
    runcmd
else
    echo "${bold}${lightblue}🔎   Architecture: 64x"
    if [ $LINUX_ISO = "Ubuntu" ]; then
    echo "${redback} THE UBUNTU DISTRO IS NOT WORKING AT THE MOMENT!"
    exit
    fi
    if [ $install = "1" ]; then
    echo  "
📌 Variable: (Clean Install) 🟢 Enabled
📌 The following packages will not be Installed: sudo wget hwloc htop nano neofetch ngrok gotty curl
    "
    else
    echo  "${bold}${lightred}⚠️ Debian/Ubuntu distributions can take more than 15min to finish the installation."
																												  
 
    fi
    echo "📥  Downloading Files for Your Server"
    if [ -d libraries ]; then
    echo "Libraries folder already exists, skipping..."
    else
    mkdir libraries
    fi
    echo "Disto Instalada: $LINUX_ISO" > libraries/distro_installed
    echo "true" > libraries/version_system
    curl -sSLo ./libraries/proot https://github.com/proot-me/proot/releases/download/v5.3.0/proot-v5.3.0-x86_64-static >/dev/null 2>libraries/err.log
    curl -sSLo proot-rs-x86_64.tar.gz https://github.com/proot-me/proot-rs/releases/download/v0.1.0/proot-rs-v0.1.0-x86_64-unknown-linux-gnu.tar.gz >/dev/null 2>libraries/err.log
    echo  '#                   (5%)'
    curl -sSLo root.tar.xz $linux_iso >/dev/null 2>libraries/err.log
    echo  '##                  (10%)'
    if [ $LINUX_ISO = "Alpine" ]; then
        echo  'Incompatible with Alpine , Skipping ... '
    else
        if [ $install = "0" ]; then
            curl -sSLo ngrok.tgz https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.tgz >/dev/null 2>libraries/err.log
            echo  '####                (20%)'
            curl -sSLo gotty.tar.gz https://github.com/sorenisanerd/gotty/releases/download/v1.5.0/gotty_v1.5.0_linux_amd64.tar.gz >/dev/null 2>libraries/err.log
        fi
    fi
    echo  '#####               (25%)'
    export PATH="/bin:/usr/bin:/usr/local/bin:/sbin:$HOMEA/bin:$HOMEA/usr/bin:$HOMEA/sbin:$HOMEA/usr/sbin:$HOMEA/etc/init.d:$PATH"
    echo  '######              (30%)'
    tar -xvf root.tar.xz >/dev/null 2>libraries/err.log
    curl -o /bin/systemctl https://raw.githubusercontent.com/gdraheim/docker-systemctl-replacement/master/files/docker/systemctl3.py >/dev/null 2>libraries/err.log
    chmod +x /bin/systemctl >/dev/null 2>libraries/err.log
    echo  '#######             (35%)'
    tar -xzvf proot-rs-x86_64.tar.gz >/dev/null 2>libraries/err.log
    mv proot-rs ./libraries/
    chmod +x ./libraries/proot >/dev/null 2>libraries/err.log
    chmod +x ./libraries/proot-rs >/dev/null 2>libraries/err.log
    echo  '########            (40%)'
    if [ $LINUX_ISO = "Alpine" ]; then
    echo  '########            (45%)'
    echo  '##########          (50%)'
    else
    echo "nameserver 8.8.8.8" > etc/resolv.conf
        if [ $install = "0" ]; then
            tar -cvzf ngrok.tgz >/dev/null 2>libraries/err.log
            echo  '#########           (45%)'
            chmod +x ngrok >/dev/null 2>libraries/err.log
            echo  '##########          (50%)'
            tar -xzvf gotty.tar.gz >/dev/null 2>libraries/err.log
            chmod +x gotty >/dev/null 2>libraries/err.log
        fi
    fi
    echo  '###########         (55%)'
    rm -rf proot-rs-x86_64.tar.gz >/dev/null 2>libraries/err.log
    rm -rf root.tar.xz >/dev/null 2>libraries/err.log
    rm -rf gotty.tar.gz >/dev/null 2>libraries/err.log
    rm -rf ngrok.tgz >/dev/null 2>libraries/err.log
    echo  '############        (60%)'
    if [ $LINUX_ISO = "Alpine" ]; then
        chmod -R 775 alpine-x86_64
        mv alpine-x86_64/* ./
        rm -r alpine-x86_64
    fi
    if [ $LINUX_ISO = "Alpine" ]; then
        echo  '############        (80%)'
    else
        if [ $install = "0" ]; then
            echo  "${bold}${lightred}⚠️ This is the most time-consuming step, it can take up to 15 minutes to complete."
        fi
    fi

    for cmd in "${cmds[@]}"; do
        $proot $console $bash "$cmd >/dev/null 2>libraries/err.log"
    done
    echo  '####################(100%)'
    touch ./libraries/instalado
    
    echo "
${bold}${lightgreen}===================================================================================
                                                                                                  
${bold}${lightblue}@@@@@@@   @@@@@@@  @@@@@@@@  @@@@@@@    @@@@@@      @@@  @@@  @@@@@@       @@@@@@@ 
${bold}${lightblue}@@@@@@@@  @@@@@@@  @@@@@@@@  @@@@@@@@  @@@@@@@@     @@@  @@@  @@@@@@@@   @@@@@@@ 
${bold}${lightblue}@@!  @@@    @@!    @@!       @@!  @@@  @@!  @@@     @@!  @@@  @@!   @@!  @@!  
${bold}${lightblue}!@!  @!@    !@!    !@!       !@!  @!@  !@!  @!@     !@!  @!@  !@!   @!@  !@!   
${bold}${lightblue}@!@@!@!     @!!    @!!!:!    @!@!!@!   @!@  !@!     @!@  !@!  @!@!@!@!    !@!@!@!   
${bold}${lightblue}!!@!!!      !!!    !!!!!:    !!@!@!    !@!  !!!     !@!  !!!  !@!!@!@      !@!!@!@    
${bold}${lightblue}!!:         !!:    !!:       !!: :!!   !!:  !!!     :!:  !!:  !::              !::
${bold}${lightblue}:!:         :!:    :!:       :!:  !:!  :!:  !:!      ::!!:!   :!:              :!:      
${bold}${lightblue} ::          ::     :: ::::  ::   :::  ::::: ::       ::::    :::          :::::::     
${bold}${lightblue} :           :     : :: ::    :   : :   : :  :         :      :::        :::::::         
                                                                                                				 
${bold}${lightgreen}===================================================================================
 "
 
 
    echo "${nc}"
 
    echo "${bold}${lightgreen}==> ${lightblue}Container${lightgreen} Started <=="
    function runcmd1 {
        printf "${bold}${lightred}pRoot${nc}@${lightblue}Container${nc}:~ "
        read -r cmdtorun
        $proot $console $bash "$cmdtorun"
        runcmd
    }
    function runcmd {
        printf "${bold}${lightred}pRoot${nc}@${lightblue}Container${nc}:~ "
        read -r cmdtorun
        $proot $console $bash "$cmdtorun"
        runcmd1
    }
    runcmd
fi
