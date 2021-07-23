pafe_lesson_success() {
	local ftest=$1
	local frep=$2
    local flesson=$3
	local faccents="accents.sed"	
	local i=1
	local verify=0
	
	for item in $(cat $frep); do
		req=$(sed -n $i"p" $frep)
		test=$(sed -n $i"p" $ftest)
        word=$(sed -n $i"p" $flesson)
		req1=`echo $req | sed -f $faccents`
		test1=`echo $test | sed -f $faccents`	
		ver=$(echo $test1 | sed -n "/ $req1,,/p")

		if [[ -z $ver ]]; then
			echo -e "\t\t$word- [$req] => NO"
			verify=1
		else
			echo -e "\t\t$word- [$req] => YES"
		fi 
		i=$[ $i + 1 ]
	done
	return $verify
}

pafe_lesson_complete () {
	local flesson=$1

	if [ -f $flesson ]; then
		return 1;
	fi
	echo -e "\t felicitation vous avez terminer ce cours";
	echo -e "\t veuillez continuer sur d'autres cours";	
	return 0;
}

pafe_show_words () {
	local fdict=$1
	local flesson=$2
	local lesson=$3
	local ftest=$4
	local ver=""
	local reg=""
	local i=1

	echo -e "\t-- lesson $lesson --";
	for words in $(cat $flesson); do
		ver=$(sed "/^$words,,/p" -n $fdict);

		if [[ -z $ver ]]; then	
			echo -e "\t$i - $words ($words) : $words,,";			
			echo " $words,," >> $ftest	
		else
            req=`echo $ver | awk 'BEGIN{FS="."} {print $1;}'`
            words=`echo $ver | awk 'BEGIN{FS="."} {print $3;}'`
			echo -e "\t$i - $words : $req";
			echo "$words" >> $ftest 
		fi
		i=$[ $i + 1 ]	
	done
	echo "";
	read -p "tape [Enter] pour commencer : " i
	clear
}

pafe_get_word () {
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

pafe_get_answers () {
	local flesson=$1
	local frep=$2
    local i=1

    IFS=$'\n'
    echo "taper virgule(,) [pour ecouter] ou saisir le mot en FRENCH [pour continuer]";
    for word in $(cat $flesson); do
        echo -en "\t$i- mots : "
        answer=`pafe_get_word $word`
        if [ -z "$answer" ]; then
            answer=0
        fi
        echo "$answer" >> $frep 
        i=$[ $i + 1 ]
    done 
}

play_audio_fr_en () {
	local lesson=$(ls -t $dir_ca_fe|gawk '{if(length($1)>0){print($1+1);exit;}else{print 1;}}')	
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

		if pafe_lesson_complete $flesson; then 
			return 0;
		fi
		pafe_show_words $fdict $flesson $lesson $ftest
		pafe_get_answers $flesson $frep

		if pafe_lesson_success $ftest $frep $flesson; then 
			cp $frep $dir_ra_fe"/$lesson"
			cp $flesson $dir_ca_fe"/$lesson"	
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
