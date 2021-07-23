#!/bin/bash

# play_words_en_fr
source ./pwef.sh

# play_words_fr_en
source ./pwfe.sh

# play_audio_en_fr
source ./paef.sh 

# play_audio_fr_en
source ./pafe.sh 

# revision_word_en_fr
source ./rwef.sh

# revision_word_fr_en
source ./rwfe.sh

# revision_audio_en_fr
source ./raef.sh 

# revision_audio_fr_en
source ./rafe.sh

# info
source ./info.sh



play_cours_ch () {
	case $1 in 
		1 ) play_words_en_fr $2 ;;
		2 ) play_words_fr_en $2 $dir_cw_fe $dir_rw_fe;;	
		3 ) play_audio_en_fr $2 ;;
		4 ) play_audio_fr_en $2 ;;
		51) revision_word_en_fr $2 ;;
		52) revision_word_fr_en $2 ;; 		
		53) revision_audio_en_fr $2 ;;
		54) revision_audio_fr_en $2 ;;
		6 ) info $2 ;;
		* ) echo "";;
	esac 
}

make_dirs () {
	dir_main=$1	
	dir_cours=$dir_main"/cours"
	dir_rep=$dir_main"/rep"	
	dir_cw_ef="$dir_cours/words_en_fr"
	dir_cw_fe="$dir_cours/words_fr_en"	
	dir_ca_ef="$dir_cours/audio_en_fr"
	dir_ca_fe="$dir_cours/audio_fr_en"	
	dir_rw_ef="$dir_rep/words_en_fr"
	dir_rw_fe="$dir_rep/words_fr_en"
	dir_ra_ef="$dir_rep/audio_en_fr"
	dir_ra_fe="$dir_rep/audio_fr_en"

	mkdir $dir_cours 2> /dev/null
	mkdir $dir_rep 2> /dev/null
	mkdir $dir_cw_ef 2> /dev/null
	mkdir $dir_cw_fe 2> /dev/null	
	mkdir $dir_ca_ef 2> /dev/null
	mkdir $dir_ca_fe 2> /dev/null 
	mkdir $dir_rw_ef 2> /dev/null
	mkdir $dir_rw_fe 2> /dev/null
	mkdir $dir_ra_ef 2> /dev/null
	mkdir $dir_ra_fe 2> /dev/null
}


function play_cours {
	local cours=$1	
	local ch=1

	make_dirs $cours
	clear
	while [[ $ch -ne 0 ]]; do
		echo -e "\t-- cours -- \n\n";
		echo "0 - Retour";
		echo "1 - words (en_fr)"
		echo "2 - words (fr_en)"
		echo "3 - audio (en_en)"
		echo "4 - audio (en_fr)"	
		echo "5 - Revision"
		echo "    51- words (en_fr)";
		echo "    52- words (fr_en)";
		echo "    53- audio (en_en)";
		echo "    54- audio (en_fr)";	
		echo "6- info";
	read -p "choix : " ch;
	play_cours_ch $ch $cours	
	done
}

