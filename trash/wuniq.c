#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>


int main(int argc, char *argv[]){
	const int FILE_MAX_LENGHT = 10 * 1024 * 1024;
	const int WLINE = 100000;
	const int WCOL = 50;
	char **wlist = malloc(sizeof(char) * (WLINE + 2));
	if (wlist == NULL) {
		puts("Memory low");
		return 1;
	}
	for (int i = 0; i < WLINE; i++){
		wlist[i] = malloc(sizeof(char) * WCOL);
		if (wlist == NULL){
			puts("Memory low");
			return 1;
		}
	}	
	char word[WCOL];
	char *data = malloc(sizeof(char) * FILE_MAX_LENGHT);
	int niv = 0;
	int word_exist;	
	if (data == NULL) {
		puts("Memory low");
		return 1;
	}
	
	for (int i = 0; i < WLINE; i++)
		wlist[i][0] = 0;
	gets(data);
	for (int i = 0, a; data[i]; ){
		if (data[i] == ' ')
			i++;
		for (a = 0; data[i] && data[i]!=' '; )
			word[a++] = data[i++];
		word[a] = 0;
		word_exist = 0;
		for (int j = 0; j < WLINE; j++){
			if (wlist[j][0] && strcmp(word, wlist[j]) == 0) {
				word_exist = 1;
				break;
			}
		}
		if (word_exist == 0)
			strcpy(wlist[niv++], word); 
	}
puts("2");	
	for (int i = 0; i < niv; i++)
		printf("%s ", wlist[i]);	
	free(data);
	return 0;
}