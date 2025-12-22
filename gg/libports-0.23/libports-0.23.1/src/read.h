#include "common.h"

int readfrom(int socket, int buf, void (*parse)(char* buffer, int len, int sock));
int readfromlisten(sock_listen *listen_s, int buf, void (*parse)(char* buffer, int len, int socket));
int closesock(int sock, sock_listen *listen_s);
static int internal_addsock(int sock, sock_listen *listen_s);
static int internal_delsock(int sock, sock_listen *listen_s);
static int internal_findsock(int sock, sock_listen *listen_s);
