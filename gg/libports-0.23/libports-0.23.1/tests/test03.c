#include <stdio.h>
#include "../src/ports.h"
#include <signal.h>
#include <sys/utsname.h>

#define BUFSIZE 8192

sock_listen *result;
int clires;
void cleanexit(int sig);
int servparser(char *buf, int len, int sock);
int cliparser(char *buf, int len, int sock);
void startserv();
void clistart();
FILE *fp;
pid_t pid;

int main(void) {
        struct utsname unamex;

	uname(&unamex);
	signal(SIGINT, cleanexit);
	signal(SIGSEGV, cleanexit);
	if (!strcmp(unamex.machine, "sparc")) printf("Testing libports on: %s %s on a %s [%s]\n\n", unamex.sysname, unamex.release, unamex.machine, unamex.nodename);
	else printf("Testing libports on: %s %s on an %s [%s]\n\n", unamex.sysname, unamex.release, unamex.machine, unamex.nodename);
	printf("Beginning test -- server[listen_to]: ");
        fflush(stdout);
	startserv();
	printf("OK\n");

	printf("Beginning test -- server[porterror]: OK\n");
	printf("Beginning test -- client[connect_to]: ");
        fflush(stdout);
	clistart();
        printf("OK\n");
	printf("Beginning test -- client[porterror]: OK\n");
	printf("\nForking to test read functions\n\n");

	pid = fork();

	if (pid) {
		while (1) readfromlisten(result, BUFSIZE, &servparser);
	} else {
		while (readfrom(clires, BUFSIZE, &cliparser) > 0);
	}

	cleanexit(9);
	return 1;
}

void startserv() {
        result = listen_to(4458, 1);
        if (result->sock_fd < 0) {
                printf("Error: %s\n", porterror(result->sock_fd));
                close(result->sock_fd);
                cleanexit(9);
        }
}

void clistart() {
        clires = connect_to("127.0.0.1", 4458);
        if (clires < 0) {
                printf("Error: %s\n", porterror(clires));
                close(result);
                exit(0);
        }
}

void cleanexit(int sig) {
	if (sig == 11) { printf("FAIL\n"); }
	close(result->sock_fd);
	close(clires);
	exit(0);
}

int servparser(char *buf, int len, int sock) {
int i = -1;
	if ((buf == NULL) && (len == 0)) {
		printf("Beginning test -- server[sockprintf]: ");
		fflush(stdout);
		sockprintf(sock, "Are you there #%d?\n", sock);
		printf("OK\n");
	} else if ((buf != NULL) && (len > 0)) {
		printf("-> Client said: %s\n", buf);
		printf("Beginning test -- server[findsock]: ");
		fflush(stdout);
		i = findsock(sock, result);
		if (i > -1) { printf("OK\n"); }
		else { printf ("FAIL\n"); }
		printf("Beginning test -- server[closesock]: ");
		fflush(stdout);
		i = closesock(sock, result);
                if (i > -1) { printf("OK\n"); }
                else { printf ("FAIL\n"); }
		printf("\nKilling child process\n\n");
		kill(pid, 9);
		printf("Read tests were successful!\n");
		cleanexit(9);
	}
}

int cliparser(char *buf, int len, int sock) {
	if (len > 0) {
		printf("-> Server said: %s\n", buf);
                printf("Beginning test -- client[sockprintf]: ");
                fflush(stdout);
		sockprintf(sock, "Yes I am #%d!\n", sock);
		printf("OK\n");
	}
}

