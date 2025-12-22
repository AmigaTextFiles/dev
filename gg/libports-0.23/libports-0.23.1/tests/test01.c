#include <stdio.h>
#include "../src/ports.h"
#include <signal.h>

/* EXPERIMENT WITH THIS */
#define BUFSIZE 1024

int result;
FILE *fp;
void cleanexit(int sig);
int parser(char *buf, int len, int sock);

int main(void) {
	int retval,x;
	int die = -1;
	char *bufferc = NULL;

/* CHANGE YOUR TESTFILE! */
	fp = fopen("testfile01", "w");	/* outfile */
	bufferc = (char*)malloc(BUFSIZE);

	signal(SIGINT, cleanexit);

/* CHANGE WHERE TO CONNECT TO */
	result = connect_to("1.1.1.1", 1111);	/* connect to.. */
	if (result < 0) { 
		printf("Error: %s\n", porterror(result)); 
		close(result);
		exit(0);
	}
	while (readfrom(result, BUFSIZE, &parser) > 0); /* read to parser */
	cleanexit(9);
	return 1;
}

void cleanexit(int sig) {
	fclose(fp);
	close(result);
	exit(0);
}

int parser(char *buf, int len, int sock) {
	fwrite(buf, len, 1, fp);	/* write to file */
}
