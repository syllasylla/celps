BEGIN {
    v1=0;
}

/<body>/{ v1=1;}
/<\/body>/{ v1=0;}
{
    if (v1==1) {
        for (i=1; i<=NF; i++){
            printf"%s ",$i;
        }
        print"";
    } 
}