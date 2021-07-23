#!/bin/bash

function book_delete {
    local i=1 
    
    echo -e "\t-- Suppression de cours --\n\n";
    for fname in $(ls books); do
        file="books/$fname/info.data"
        cours=$(gawk '{print $0; exit}' $file) 

        tab_files[$i]="books/$fname/"
        echo "$i- [$cours]" 
        i=$[ $i + 1] 
    done

    echo "";
    if [[ $i -lt 2 ]]; then
        echo "liste vide";
        return 0
    fi
    read -p "Numero du cours : " cours
    if [[ -e ${tab_files[$cours]} ]]; then
        rm -rf ${tab_files[$cours]}
        echo "cours supprimer";
    else 
        echo "numero invalide";
    fi 
}


