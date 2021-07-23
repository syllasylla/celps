#!/bin/bash


source ./cours.sh

function book_search_by_name {
    local i=1

    echo -e "\t-- Recherche de cours par Nom --\n\n";
    for fname in $(ls books); do
        file="books/$fname/info.data"
        cours=$(gawk '{print $0; exit}' $file) 
        tab_files[$i]="books/$fname"
        echo "$i- [$cours]" 
        i=$[ $i + 1 ] 
    done

    echo "";
    if [[ $i -lt 2 ]]; then
        echo "liste vide";
        return 0
    fi
    read -p "Numero du cours : " cours
    if [[ -e ${tab_files[$cours]} ]]; then
       play_cours ${tab_files[$cours]} 
    else 
        echo "numero invalide";
    fi 
}


function book_search_by_date {
    local i=1

    echo -e "\t-- Recherche de cours par Date --\n\n";
    for fname in $(ls -t books); do
        file="books/$fname/info.data"
        cours=$(gawk '{print $0; exit}' $file) 
        tab_files[$i]="books/$fname"
        date=$(ls $file -l | gawk '{printf"%s %s %s",$6,$7,$8;}') 
        echo "$i- [$cours]- $date" 
        i=$[ $i + 1] 
    done

    echo "";
    if [[ $i -lt 2 ]]; then
        echo "liste vide";
        return 0
    fi
    read -p "Numero du cours : " cours
    if [[ -e ${tab_files[$cours]} ]]; then
       play_cours ${tab_files[$cours]} 
    else 
        echo "numero invalide";
    fi
}

bsbp_get_progres () {
    local dir=$1
    local nb_lesson=`ls $dir"/lessons" | wc | awk '{print $1;}' `
    local nivo=1

    local max=0
    if [[ -e "$dir/cours" ]]; then
        for dirs in $(ls "$dir/cours" ); do
            if [[ -e "$dir/cours/$dirs/1" ]]; then 
                nb=`ls $dir/cours/$dirs | wc | awk '{print $1;}'`    
                if [ $nb -gt $max ]; then
                    max=$nb
                fi
            fi
        done
    fi
    echo "$max/$nb_lesson"
}

function book_search_by_progres {
    local i=1

    echo -e "\t-- Recherche de cours par Progression --\n\n";
    for fname in $(ls books); do
        file="books/$fname/info.data"
        cours=$(gawk '{print $0; exit}' $file) 
        tab_files[$i]="books/$fname"
        progres=`bsbp_get_progres books/$fname`
        echo "$i- [$cours]- $progres" 
        i=$[ $i + 1] 
    done

    echo "";
    if [[ $i -lt 2 ]]; then
        echo "liste vide";
        return 0
    fi
    read -p "Numero du cours : " cours
    if [[ -e ${tab_files[$cours]} ]]; then
       play_cours ${tab_files[$cours]} 
    else 
        echo "numero invalide";
    fi
}
