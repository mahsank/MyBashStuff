#!/usr/bin/env bash
# This script sets up rpmfusion repositories and performs installation of
# various softwares on a newly installed fedora system. Installation is divided
# into various groups such as development, education, graphics and utils etc.
# It is possible to install all the groups at once by passing the agrument
# 'all' to the script. The script may terminate prematurely if the named
# package doesn't exist in rpmfusion repository. This is not a problem with the
# script but the way dnf behaves when you try to install multiple packages and
# one of the package name is not found in the repository. I wrote this script
# for as per my own requirements, feel free to modify it as per your
# requirements


if [ $UID -ne 0 ]
then
    echo "This script needs to run with elevated priveleges."
    exit 1
fi

usage(){
    echo "Usage: $0
    DEVELOPMENT|EDUCATION|GRAPHICS|GAMES|INTERNET|MULTIMEDIA|OFFICE|UTILS|ALL"
}

choice="$1"

if [ $# -ne 1 ]
then
    echo "Script needs one argument."
    usage
    exit
fi

# repository name
REPNAME="rpmfusion"
# base url
URL="https://download1.$REPNAME.org"
# repository types,both free or nonfree
REPTYPE="free nonfree"
if [ -f /etc/os-release ]
then
    . /etc/os-release
    id=$ID
    rel=$VERSION_ID
fi

DNF=$(command -v dnf)

install_rpmfusion(){
    for i in $REPTYPE
    do
        $DNF -y install $URL/$i/$id/$REPNAME-$i-release-$rel.noarch.rpm
    done
}

# installation groups

DEVELOPMENT="@development-tools kdiff3 cmake"

EDUCATION="octave octave-audio octave-communications octave-control
octave-image octave-io octave-optim octave-signal octave-specfun
octave-statistics octave-symbolic khangman kwordquiz kanagram cantor kbruch kig
kmplot rocs kalzium marble kstars blinken gcompris-qt goldendict kgeography
ktouch step"

GRAPHICS="digikam gimp calligra-karbon kolourpaint quearcode skanlite xfig"

GAMES="bomber kapman kblocks kbounce kbrickbuster kgoldrunner kolf kollision
ksnakeduel bovo kblackbox kfourinline kigo kmahjongg knights kreversi ksquares
knapsen kpat lskat blinken gcompris-qt kanagram khangman ktuberling kdiamond
ksudoku kubrick katomic kjumpingcube klickety kmines knetwalk konquest ksirk
knavalbattle"

INTERNET="dnscrypt-proxy-gui gns3-gui knemo qbittorrent thunderbird falkon
firefox smb4k"


MULTIMEDIA="clipgrab dvdisaster ffmulticonverter juk k3b k3b-extras-freeworld
kaffeine kdenlive kid3 kodi kwave mpv mscore qmplay2 qwinff
simplescreenrecorder smplayer
soundkonverter vlc vidcutter vokoscreen"

OFFICE="@libreoffice calligra-sheets calligra-stage calligra-words fbreader
pdfshuffler qpdf qpfview skrooge texstudio kate"

UTILS="gparted VirtualBox kalarm keepassxc ktimer okteta speedcrunch sweeper
zanshin"

install_group(){
    for i in $*
    do
        $DNF -y install $i 
    done
}

case $choice in
    DEVELOPMENT|development)
        install_rpmfusion
        install_group $DEVELOPMENT
        ;;
    EDUCATION|education)
        install_rpmfusion
        install_group $EDUCATION
        ;;
    GRAPHICS|graphics)
        install_rpmfusion
        install_group $GRAPHICS
        ;;
    GAMES|games)
        install_rpmfusion
        install_group $GAMES
        ;;
    INTERNET|internet)
        install_rpmfusion
        install_group $INTERNET
        ;;
    MULTIMEDIA | multimedia)
        install_rpmfusion
        install_group $MULTIMEDIA
        ;;
    OFFICE|office)
        install_rpmfusion
        install_group $OFFICE
        ;;
    UTILS|utils)
        install_rpmfusion
        install_group $UTILS
        ;;
    ALL|all)
        install_rpmfusion
        install_group $DEVELOPMENT $EDUCATION $GRAPHICS $GAMES $INTERNET
        $MULTIMEDIA $OFFICE $UTILS
        ;;
        *)
        echo "The option is not recognized."
        usage
        ;;
esac

