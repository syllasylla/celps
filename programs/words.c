#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>

int main(int argc, char *argv[]){
	
	if (argc < 2) {
		puts("fname empty");
		return 1;
	}
	char str[1030];
	char str_out[1030];	
	char *fname = argv[1];
	FILE *file = fopen(fname, "rb");
	if (file==NULL) {
		printf("%s don't exist", fname);
		return 1;
	}
	int a;
	while ( (a = fread(str, sizeof(char), 1024, file)) > 1){
		int i, j, len;	
		for (i = 0, j = 0; i < a; i++){
			if (isalpha(str[i]) || str[i]==' ' || str[i]=='\'')
				str_out[j++] = str[i];
			else
				str_out[j++] = ' '; 
		}
		str_out[j] = 0;
		strcpy(str, str_out);
		for (len = j, i = j = 0; i < len; i++){
			if (str[i]=='\'' && str_out[j-1]=='\'')
				continue; 
			str_out[j++] = str[i];
		}
		str_out[j] = 0;
		printf(str_out);
	}
	fclose(file);

return 0;
}