#!/bin/bash

# Define environment variables
HOME="/home/container"
HOMEA="$HOME/linux/.apt"
STARALL="$HOMEA/lib:$HOMEA/usr/lib:$HOMEA/var/lib:$HOMEA/usr/lib/x86_64-linux-gnu:$HOMEA/lib/x86_64-linux-gnu:$HOMEA/lib:$HOMEA/usr/lib/sudo"
STARALL+=":$HOMEA/usr/include/x86_64-linux-gnu:$HOMEA/usr/include/x86_64-linux-gnu/bits:$HOMEA/usr/include/x86_64-linux-gnu/gnu"
STARALL+=":$HOMEA/usr/share/lintian/overrides/:$HOMEA/usr/src/glibc/debian/:$HOMEA/usr/src/glibc/debian/debhelper.in:$HOMEA/usr/lib/mono"
STARALL+=":$HOMEA/usr/src/glibc/debian/control.in:$HOMEA/usr/lib/x86_64-linux-gnu/libcanberra-0.30:$HOMEA/usr/lib/x86_64-linux-gnu/libgtk2.0-0"
STARALL+=":$HOMEA/usr/lib/x86_64-linux-gnu/gtk-2.0/modules:$HOMEA/usr/lib/x86_64-linux-gnu/gtk-2.0/2.10.0/immodules:$HOMEA/usr/lib/x86_64-linux-gnu/gtk-2.0/2.10.0/printbackends"
STARALL+=":$HOMEA/usr/lib/x86_64-linux-gnu/samba/:$HOMEA/usr/lib/x86_64-linux-gnu/pulseaudio:$HOMEA/usr/lib/x86_64-linux-gnu/blas:$HOMEA/usr/lib/x86_64-linux-gnu/blis-serial"
STARALL+=":$HOMEA/usr/lib/x86_64-linux-gnu/blis-openmp:$HOMEA/usr/lib/x86_64-linux-gnu/atlas:$HOMEA/usr/lib/x86_64-linux-gnu/tracker-miners-2.0:$HOMEA/usr/lib/x86_64-linux-gnu/tracker-2.0:$HOMEA/usr/lib/x86_64-linux-gnu/lapack:$HOMEA/usr/lib/x86_64-linux-gnu/gedit"

# Export environment variables
export LD_LIBRARY_PATH=$STARALL
export PATH="/bin:/usr/bin:/usr/local/bin:/sbin:$HOMEA/bin:$HOMEA/usr/bin:$HOMEA/sbin:$HOMEA/usr/sbin:$HOMEA/etc/init.d:$PATH"
export BUILD_DIR=$HOMEA

# Define text formatting variables
bold=$(tput bold)
nc=$(tput sgr0)
lightblue=$(tput setaf 6)
lightgreen=$(tput setaf 2)
lightred=$(tput setaf 1)
redback=$(tput setab 1)

# Display startup message
echo "${bold}${lightgreen}==================================================================================="
echo "${bold}${lightblue} STARTING PLEASE WAIT ...="
echo "${bold}${lightgreen}==================================================================================="
echo

# Check if installation is requested
if [ -z "$INSTALL" ]; then
    install="0"
else
    install="$INSTALL"
fi

# Define Linux ISO download links and commands based on selected distribution
if [ -z "$LINUX_ISO" ]; then
    linux_iso="https://github.com/termux/proot-distro/releases/download/v3.3.0/debian-x86_64-pd-v3.3.0.tar.xz"
    bash=("/bin/bash -c")
    if [ -z "$INSTALL" ]; then
        cmds=("mv gotty /usr/bin/" "mv unzip /usr/bin/" "mv ngrok /usr/bin/" "apt clean" "apt-get update" "apt-get -y upgrade" "apt-get -y install sudo curl wget hwloc htop nano neofetch python3")
    fi
else
    if [ $LINUX_ISO = "Debian" ]; then
        linux_iso="https://github.com/termux/proot-distro/releases/download/v3.3.0/debian-x86_64-pd-v3.3.0.tar.xz"
        bash=("/bin/bash -c")
        if [ $install = "0" ]; then
            cmds=("mv gotty /usr/bin/" "mv unzip /usr/bin/" "mv ngrok /usr/bin/" "apt clean" "apt-get update" "apt-get -y upgrade" "apt-get -y install sudo curl wget hwloc htop nano neofetch python3")
        else
            cmds=("apt clean" "apt-get update" "apt-get -y upgrade" "apt-get -y install python3")
        fi
    elif [ $LINUX_ISO = "Ubuntu" ]; then
        linux_iso="https://partner-images.canonical.com/core/bionic/current/ubuntu-bionic-core-cloudimg-amd64-root.tar.gz"
        bash=("/bin/bash -c")
        if [ $install = "0" ]; then
            cmds=("mv gotty /usr/bin/" "mv unzip /usr/bin/" "mv ngrok /usr/bin/" "apt clean" "rm -rf /etc/apt/trusted.gpg.d/*" "apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 3B4FE6ACC0B21F32" "apt-get update" "apt-get -y upgrade" "apt-get -y install sudo curl wget hwloc htop nano neofetch python3")
        else
            cmds=("apt clean" "apt-get update" "apt-get -y upgrade" "apt-get -y install python3")
        fi
    elif [ $LINUX_ISO = "Alpine" ]; then
        linux_iso="https://github.com/termux/proot-distro/releases/download/v3.3.0/alpine-x86_64-pd-v3.3.0.tar.xz"
        bash=("/bin/ash -c")
        if [ $install = "0" ]; then
            cmds=("apk cache clean" "apk update" "apk upgrade" "apk add --upgrade sudo curl wget hwloc htop nano neofetch python3 unzip")
        else
            cmds=("apk cache clean" "apk update" "apk upgrade")
        fi
    fi
fi

# Display container startup message
echo "${nc}"
if [[ -f "./libraries/instalado" ]]; then
    # Check PRoot selection and provide warning messages
    if [ "${PROOT}" = "PRoot-rs" ]; then
        echo "${bold}${lightred}⛔️ Root running using PRoot-rs, make sure you know what you're doing!"
    elif [ "${PROOT}" = "FakechRoot + FakeRoot" ]; then
        echo "${bold}${lightred}⛔️ Root running from FakechRoot + FakeRoot, make sure you understand the implications!"
        echo "${bold}${lightred}⛔️ To use this variable, you have to be using docker: ashu11a/proot:latest"
    fi

    # Run the main script logic
    bash <(curl -s https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/vps/version.sh)
    echo "✅ Starting VPS"
    echo "${bold}${lightgreen}==> ${lightblue}Starting${lightgreen} Container <=="

    function runcmd1 {
        printf "${bold}${lightgreen}Default${nc}@${lightblue}Container${nc}:~ "
        read -r cmdtorun
        $proot $console $bash "$cmdtorun"
        runcmd
    }

    function runcmd {
        printf "${bold}${lightgreen}Default${nc}@${lightblue}Container${nc}:~ "
        read -r cmdtorun
        $proot $console $bash "$cmdtorun"
        runcmd1
    }

    runcmd
else
    # Display setup status and initiate download if not installed
    echo "${bold}${lightblue}🔎   Architecture: 64x"
    if [ $LINUX_ISO = "Ubuntu" ]; then
        echo "${redback} THE UBUNTU DISTRO IS NOT WORKING AT THE MOMENT!"
        exit
    fi

    if [ $install = "1" ]; then
        echo  "📌 Variable: (Clean Install) 🟢 Enabled"
        echo  "📌 The following packages will not be Installed: sudo wget hwloc htop nano neofetch ngrok gotty curl"
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

    # ... Remaining steps of the script go here ...

    echo  '############        (80%)'
    else
        # ... Remaining steps of the script go here ...
    echo  '####################(100%)'
    touch ./libraries/instalado
    echo "${bold}${lightgreen}==================================================================================="

    echo "${bold}${lightblue}@@@@@@@   @@@@@@@  @@@@@@@@  @@@@@@@    @@@@@@      @@@  @@@  @@@@@@       @@@@@@@"
    echo "${bold}${lightblue}@@@@@@@@  @@@@@@@  @@@@@@@@  @@@@@@@@  @@@@@@@@     @@@  @@@  @@@@@@@@   @@@@@@@"
    echo "${bold}${lightblue}@@!  @@@    @@!    @@!       @@!  @@@  @@!  @@@     @@!  @@@  @@!   @@!  @@!"
    echo "${bold}${lightblue}!@!  @!@    !@!    !@!       !@!  @!@  !@!  @!@     !@!  @!@  !@!   @!@  !@!"
    echo "${bold}${lightblue}@!@@!@!     @!!    @!!!:!    @!@!!@!   @!@  !@!     @!@  !@!  @!@!@!@!    !@!@!@!"
    echo "${bold}${lightblue}!!@!!!      !!!    !!!!!:    !!@!@!    !@!  !!!     !@!  !!!  !@!!@!@      !@!!@!@"
    echo "${bold}${lightblue}!!:         !!:    !!:       !!: :!!   !!:  !!!     :!:  !!:  !::              !::"
    echo "${bold}${lightblue}:!:         :!:    :!:       :!:  !:!  :!:  !:!      ::!!:!   :!:              :!:"
    echo "${bold}${lightblue} ::          ::     :: ::::  ::   :::  ::::: ::       ::::    :::          :::::::"
    echo "${bold}${lightblue} :           :     : :: ::    :   : :   : :  :         :      :::        :::::::"

    echo "${bold}${lightgreen}==================================================================================="

    echo "${nc}"

    echo "${bold}${lightgreen}==> ${lightblue}Container${lightgreen} Started <=="

    function runcmd1 {
        printf "${bold}${lightgreen}vRoot${nc}@${lightblue}Container${nc}:~ "
        read -r cmdtorun
        $proot $console $bash "$cmdtorun"
        runcmd
    }

    function runcmd {
        printf "${bold}${lightgreen}vRoot${nc}@${lightblue}Container${nc}:~ "
        read -r cmdtorun
        $proot $console $bash "$cmdtorun"
        runcmd1
    }

    runcmd
fi
