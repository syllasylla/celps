#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>


int main(int argc, char *argv[]){
	int islower = 1;
	if (argc > 1 && strcmp("-upper", argv[1])==0)
		islower = 0;

	const int FILE_MAX_LENGHT = 100 * 1024 * 1024;
	char *data = malloc(sizeof(char) * FILE_MAX_LENGHT);
	if (data == NULL) {
		puts("Memory low");
		return 1;
	}
	gets(data);
	for (int i = 0; data[i]; i++){
		if (islower)
			data[i] = tolower(data[i]);
		else
			data[i] = toupper(data[i]);
	}	
	printf(data);
	free(data);
	return 0;
}