#include <sys/types.h>

typedef struct sock_listen {
        int sock_fd;
        int *sock_clients;
        char **client_ip;
        int maxconn;
} sock_listen;

extern sock_listen *listen_to(int, int);
extern char *porterror(int);
extern int connect_to(char *, u_short);
extern int readfrom(int, int, void*);
extern int readfromlisten(sock_listen*, int, void*);
extern int sockprintf(int, const char *, ...);
extern int findsock(int, sock_listen *);
extern int closesock(int, sock_listen *);
