/////////////////////////////////////////////////////////////////
/*
*   Antonio David López Machado - Curso 2016/2017
*   Práctica 4 - Bomba Digital
*   gcc -m32 bomba_AntonioDavidLopezMachado.c -o bomba_AntonioDavidLopezMachado
*/
/////////////////////////////////////////////////////////////////

#include <stdio.h>	// para printf()
#include <stdlib.h>	// para exit()
#include <string.h>	// para strncmp()/strlen()
#include <sys/time.h>	// para gettimeofday(), struct timeval
//soyunabomba
char password[]="sp{xrfhvukk\n";
#define TAM 11
//80987
int  passcode  = 80877;

void boom(){
	printf("***************\n");
	printf("*** BOOM!!! ***\n");
	printf("***************\n");
	exit(-1);
}

void defused(){
	printf("*************************\n");
	printf("*** bomba desactivada ***\n");
	printf("*************************\n");
	exit(0);
}

int main(){
#define SIZE 100
	char pass[SIZE];
	int  pasv;
#define TLIM 60
	struct timeval tv1,tv2;	// gettimeofday() secs-usecs

	gettimeofday(&tv1,NULL);

	printf("Introduce la contraseña: ");
	fgets(pass,SIZE,stdin);
	int i;
	for(i=0;i<TAM;i++){
		pass[i]+=i;
	}

	if (strncmp(pass,password,strlen(password)))
	    boom();

	gettimeofday(&tv2,NULL);
	if (tv2.tv_sec - tv1.tv_sec > TLIM)
	    boom();

	printf("Introduce el código: ");
	scanf("%i",&pasv);
	pasv=pasv -(TAM*10);
	
	if (pasv!=passcode) boom();

	gettimeofday(&tv1,NULL);
	if (tv1.tv_sec - tv2.tv_sec > TLIM)
	    boom();

	defused();
}
