#!/bin/bash

# fname : book_add
# info : celps
BOOK_LIMIT=10

# affiche le manuel du menu
function show_man_info {
#  clear
    echo "saisissez le nom du Cours dans Nom de Seance"
    echo "saisissez le nom du ou des fichiers PDF qui seront associer a votre Cours"
    echo "ces nom de fichiers doivent etre accompagner des liens absolues ou relatives"
}

# prend le nom du cours et le ou les livres PDF linked au cours
get_pdf_files() {
    tmp_dir=$(mktemp -d /tmp/celps.XXXXXX)
    tmp_dir_pdf=$tmp_dir"/pdf/"; mkdir $tmp_dir_pdf
    tmp_dir_txt=$tmp_dir"/txt/"; mkdir $tmp_dir_txt
    read -p "Nom Seance : " g_cours

    for (( i=0; i <= BOOK_LIMIT; i++)); do
        read -p "fichier $i ( 0 pour stoper):" fname
        if [ $i -eq 0 ] && [ $fname == "0" ]; then
            i=-1
            continue
        fi
        if [ $fname == "0" ]; then
            break 
        fi
        if [ -f $fname ]; then  
            cp $fname $tmp_dir_pdf$(basename $fname)
        else
            echo "$fname n'est un fichier valide "
            i=$[ $i - 1];
	    fi 
    done
}

# convertir les livres PDF en fichier TEXT
function convert_pdf_to_txt {
    ftext=$tmp_dir"/file.txt"

    for fname in $(ls $tmp_dir_pdf); do
	    f_pdf=$tmp_dir_pdf$fname
	    f_txt=$tmp_dir_txt$fname".txt"
	    pdftotext $f_pdf $f_txt
	    cat $f_txt >> $ftext 
    done  
}


function get_words_from_txt {
    fwords=$tmp_dir"/words.wd"
    ./programs/words $ftext > $fwords

    fwords_lower=$tmp_dir"/words.lower"
    gawk '{for(i=1; i<=NF;i++){printf"%s ",tolower($i);} print"";}' $fwords > $fwords_lower 

    fwords2=$tmp_dir"/words2.wd"
    sed "{s/ /\n/g; s/'/\n'/g;}" $fwords_lower > $fwords2

    fwords_uniq=$tmp_dir"/words.uniq"
    sort -u $fwords2 > $fwords_uniq

    words_len=$( cat $fwords_uniq | wc | gawk '{ print $2 }' )
    echo "Totals de mots : $words_len";
}

function word_important {
    len=$1
    if [[ $len -gt 300 ]]; then
	    len=300
    fi 
    echo "Totals mots importants : $len";
}

function make_lesson {
    fwords_freq=$tmp_dir"/words.freq"
    gawk '{wlist[$0]=wlist[$0]+1;}END{for(word in wlist){printf"%s,%s\n",word,wlist[word];}}' $fwords2 > $fwords_freq

    fwords_freq_sort=$tmp_dir"/words.freq.sort"
    sort -t "," -k 2 -n -r $fwords_freq > $fwords_freq_sort
    fwords_final=$tmp_dir"/words.final"
    gawk 'BEGIN{FS=","} {if(length($1)>1) {print $0;}}' $fwords_freq_sort > $fwords_final

    words_len_raf=$( cat $fwords_final | wc | gawk '{ print $2 }' )
    echo "Totals de mots raffiner : $words_len_raf";

    word_important $words_len_raf
    read -p "nombre de mots par lessons [10-25] " nb_word
    while [[ $nb_word -lt 10 ]] || [[ $nb_word -gt 25 ]]; do
	    echo "$nb_word is invalide";
	    read -p "nombre de mots par lessons [10-25] " nb_word
    done

    indice=1
    lesson=1
    mkdir $tmp_dir"/lessons";
    for item in $(cat $fwords_final | gawk 'BEGIN{FS=","} {print $1} '); do
  
  	    if [[ $indice -gt $nb_word ]]; then
  		    indice=1	
  		    lesson=$[ $lesson + 1]
  	    fi
  	    filename=$tmp_dir"/lessons/"$lesson	
  	    echo $item >> $filename
  	    indice=$[ $indice + 1]
    done
    echo "$lesson creer dans le cours : $g_cours";
    config_cours
}

function config_cours {
	fmain="books/"$(date +%Y%m%d%H%M%S)
	mkdir $fmain

	cp -r $tmp_dir $fmain && mv "$fmain/"$(basename $tmp_dir) "$fmain/archives"
	cp -r "$fmain/archives/lessons" $fmain
    #mkdir "$fmain/lessons-success"
    #mkdir "$fmain/lessons-histo"

	info_data=$fmain"/info.data"
	echo "$g_cours" > $info_data 
	echo $nb_word >> $info_data
	echo $(date +%Y-%m-%d-%H%M) >> $info_data
	echo $words_len_raf >> $info_data
}

function book_add {
    show_man_info
    get_pdf_files
    convert_pdf_to_txt
    get_words_from_txt
    make_lesson
}
