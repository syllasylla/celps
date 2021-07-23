paef_lesson_success() {
	#clear	
	local ftest=$1
	local frep=$2
	local faccents="accents.sed"	
	local i=1
	local verify=0
	
	for item in $(cat $frep); do
		req=$(sed -n $i"p" $frep)
		test=$(sed -n $i"p" $ftest)

        if [ $req != $test ]; then
			echo -e "\t\t$test - [$req] => NO"
			verify=1
		else
            echo -e "\t\t$test - [$req] => YES" 
		fi 
		i=$[ $i + 1 ]
	done
	return $verify
}

paef_lesson_complete () {
	local flesson=$1

	if [ -f $flesson ]; then
		return 1;
	fi
	echo -e "\t felicitation vous avez terminer ce cours";
	echo -e "\t veuillez continuer sur d'autres cours";	
	return 0;
}

paef_show_words () {
	local fdict=$1
	local flesson=$2
	local lesson=$3
	local ftest=$4
	local ver=""
	local reg=""
	local i=1

	echo -e "\t-- lesson $lesson --";
	for words in $(cat $flesson); do
        echo "$i - $words : " 
        echo "$words" >> $ftest
		i=$[ $i + 1 ]	
	done
	echo "";
	read -p "tape [Enter] pour commencer : " key
	clear
}

paef_get_word () {
    local word=$1
    local str=""

    while true; do
        read -n 1 key 
        if [ -z $key ]; then
            break
        fi
        if [ $key == "," ]; then
            `espeak -a 100 -p 80 $word 2> /dev/null` 
        else 
            str=$str$key
        fi
    done
    echo "$str"
}

paef_get_answers () {
	local flesson=$1
	local frep=$2
    local i=1

    echo "taper virgule(,) [pour ecouter] ou saisir le mot en ENGLISH [pour continuer] \n";
	for word in $(cat $flesson); do
		echo -en "\t$i- word : "; 
        rep=`paef_get_word $word`
        if [ -z $rep ]; then
            rep='0'
        fi 
        echo "${rep,,}" >> $frep	
        i=$[ $i + 1 ]
	done
}

play_audio_en_fr () {
	local lesson=$(ls -t $dir_ca_ef|gawk '{if(length($1)>0){print($1+1);exit;}else{print 1;}}')	
	local fdict="./dict/dict.txt"	
	local ftest="/tmp/test.test"
	local frep="/tmp/answer.rep"

	if [ -z $lesson ]; then
		lesson=1
	fi
	while true; do
		clear	
		local flesson=$dir_main"/lessons/"$lesson
		cat /dev/null 2> $ftest; cat /dev/null 2> $frep

		if paef_lesson_complete $flesson; then 
			return 0;
		fi
		paef_show_words $fdict $flesson $lesson $ftest
		paef_get_answers $flesson $frep

		if paef_lesson_success $ftest $frep; then 
			cp $frep $dir_ra_ef"/$lesson"
			cp $flesson $dir_ca_ef"/$lesson"	
			echo -e "\t--- felicitation --";
			echo -en "\ttape 0 [lesson suivante] ou 1 [reprendre] ou 2 [quitter] : ";
			read quit
			if [[ $quit == "0" ]]; then
				lesson=$[ $lesson + 1 ]
			elif [[ $quit == "2" ]]; then
				return 0;
			fi
		else
			echo -en "\ttape 1 [reessayer] ou 0 [quiter] : ";
			read quit
			if [[ $quit == "0" ]]; then
				return 0;
			fi	
		fi
	done
}
