
# configure dictionary
echo "-- installation du dictionnaire -- ";
cd ./dict/
source ./install.sh 
cd ..
echo "-- dictionnaire installed --";

# compile programs
echo "-- compilation de words.c --"
gcc programs/words.c -o programs/words 

# dependencies
echo "-- installation des dependences -- "
sudo apt-get install pdftotext espeak


