#!/bin/bash

#set -x
if [ -z $1 ]; then
    echo -e ""; 
elif [ $1 == "--clean-tmp" ]; then
    rm -rf /tmp/celps*
    rm -rf books/* 
fi 

mkdir books 2> /dev/null
mkdir manual 2> /dev/null

source ./book_add.sh
source ./book_delete.sh
source ./book_search.sh
source ./app_manual.sh

function menu_choix {
    choix=$1 
    if [ $choix == "1" ]; then 
        book_add
    elif [ $choix == "2" ]; then 
        book_delete
    elif [ $choix == "31" ]; then 
        book_search_by_date
    elif [ $choix == "32" ]; then 
        book_search_by_name
    elif [ $choix == "33" ]; then 
        book_search_by_progres
    elif [ $choix == "10" ]; then 
        app_manual
    fi
}

#reset
text_description="welcome to CELSP++ by MABUNTUS and DevGui\n"
#trap 'echo -e " ne marchera pas" ' SIGINT 
trap 'echo "Bye (aurevoir) "' EXIT 
function menu {
    local choix=1
    while [ $choix != "0" ] 
    do 
        echo -e $text_description
        echo "0- Quitter"
        echo "1- Ajouter un cours"
        echo "2- Suprimer un cours"
        echo "3- Rechercher"
            echo "   31- Par Date"
            echo "   32- Par Nom"
            echo "   33- Par Progression"
        echo "10- Manuel"
        read choix
        menu_choix $choix
    done
    exit 0 
}

menu
