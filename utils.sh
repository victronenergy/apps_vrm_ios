#!/bin/sh

SED_CMD='/usr/bin/sed'

f_Pbxproj () {

    local HEAD_LINE='/^<<<<<<< HEAD$/d'
    local SPLIT_LINE='/^=======$/d'
    local COMMIT_LINE='/^>>>>>>>/d'

    for FILE in $(git ls-files '*.pbxproj') ; do
        $SED_CMD -i '' -e "$HEAD_LINE" -e "$SPLIT_LINE" -e "$COMMIT_LINE" $FILE
    done
    sleep 1;
    echo "!!! Check .pbxproj diff !!!"
    sleep 1;
}

f_Nslog () {

    for FILE in $(git ls-files '*.[hm]') ; do
        $SED_CMD -i '' '/^[[:space:]]*NSLog\([.]*\)/d' $FILE
    done
}

f_Whitespaces() {

    for FILE in $(git ls-files --cached '*.[hm]') ; do
        $SED_CMD -i '' 's/[[:space:]]*$//' $FILE
    done
}

f_Menu ()
{
    clear
    echo " 2) Remove whitespaces (-w)"
    echo " 3) Remove all NSLog (-n)"
    echo " 4) Quit"

    echo " Option: \c"
    read choice

    case $choice in
        1) f_Pbxproj ;;
        2) f_Whitespaces ;;
        3) f_Nslog ;;
        *) exit ;;
    esac
}

if [ $# -gt 0 ] ; then
    if [ $1 = '-p' ] ; then
        f_Pbxproj
    elif [  $1 = '-w' ] ; then
        f_Whitespaces
    elif [ $1 = '-n' ] ; then
        f_Nslog
    else
        echo "Wrong command. Run command without arguments ($0)"
    fi
else
    f_Menu
fi
