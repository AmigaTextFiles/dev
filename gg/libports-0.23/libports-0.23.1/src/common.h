#include "config.h"
#include <errno.h>
#include <sys/fcntl.h>
#include <stdarg.h>
#include <stdlib.h>
#include <netinet/in.h>
#include <stdio.h>
#include <string.h>
#include <ctype.h>
#include <sys/types.h>
#include <netdb.h>
#include <sys/time.h>
// #include <sys/select.h>
#include <sys/socket.h>
#include <stdlib.h>

typedef struct sock_listen {
	int sock_fd;
	int *sock_clients;
	char **client_ip;
	int maxconn;
} sock_listen;
