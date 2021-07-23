fdict=eng-fra.tei

gawk '{for(i=1; i<=NF; i++){printf"%s ",$i;} print""; }' $fdict > dict0.txt

gawk -f dict.awk dict0.txt | sed -f dict.sed > dict1.txt

gawk '{for(i=1; i<=NF; i++){printf"%s ",$i;} print""; }' dict1.txt > dict2.txt

gawk 'BEGIN{RS=";;";} {for(i=1; i<=NF; i++) {printf"%s ",tolower($i);} print""; }' dict2.txt > dict.txt 