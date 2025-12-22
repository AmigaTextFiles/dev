#include <stdio.h>
#include "../src/ports.h"
#include <signal.h>

/* EXPERIMENT WITH THIS */
#define BUFSIZE 1024

sock_listen *result;
void cleanexit(int sig);
int parser(char *buf, int len, int sock);
FILE *fp;

int main(void) {
	signal(SIGINT, cleanexit);
	fp = stdout;

/* CHANGE YOUR PORT AND LIMIT */
	result = listen_to(3864, 2);	/* start listening */
	printf("%d\n", result->sock_fd);
	if (result->sock_fd < 0) { 
		printf("Error: %s\n", porterror(result->sock_fd)); 
		close(result->sock_fd);
		exit(0);
	}

	while (1) readfromlisten(result, BUFSIZE, &parser); /* read to parser */

	cleanexit(9);
	return 1;
}

void cleanexit(int sig) {
	close(result->sock_fd);
	exit(0);
}

int parser(char *buf, int len, int sock) {
	if (len > 0) fwrite(buf, len, 1, fp); /* write to stdout */
}
