#include "read.h"

extern int errno;

int readfrom(int socket, int buf, void (*parse)(char* buffer, int len, int sock)) {
	int dead = -1;
        fd_set rfds;
        struct timeval tv;
        char tc[buf];
	int sz;


	while(dead != 1) {
		FD_ZERO(&rfds);
		FD_SET(socket, &rfds);
	        tv.tv_sec = 1;
	        tv.tv_usec = 0;
		if ((select(FD_SETSIZE, &rfds, NULL, NULL, &tv)) != -1) {
			if (FD_ISSET(socket, &rfds)) {
				sz = recv(socket, &tc, buf, 0);
				if (sz > 0) (*parse)(tc, sz, socket);
				else { return -8; }
			}
		} else {
			dead = 1;
			return -7;
		}
	}
	return -7;
}

int readfromlisten(sock_listen *listen_s, int buf, void (*parse)(char* buffer, int len, int sock))
{
	fd_set in_poll, out_poll, exc_poll;
	int sz, fd, i, bufidx = 0, die = -1;
	struct sockaddr_in sin;
        int len = sizeof(sin);
	char iphashbuf[16], tc[buf];
	unsigned char *ip;
        struct timeval tv;

	FD_ZERO(&out_poll);
	FD_ZERO(&in_poll);
	FD_ZERO(&exc_poll);

	while(die != 1) {
		FD_ZERO(&in_poll);
		FD_SET(listen_s->sock_fd, &in_poll);
		for (i = 0; i < listen_s->maxconn; i++)
			if (listen_s->sock_clients[i] != -1)
				FD_SET(listen_s->sock_clients[i], &in_poll);
	        tv.tv_sec = 1;
	        tv.tv_usec = 0;

		if (select(FD_SETSIZE, &in_poll, &out_poll, &exc_poll, &tv) == -1) {
			die == 1;
			return -9;
		}
	
		if (FD_ISSET(listen_s->sock_fd, &in_poll)) {
   		     	fd = accept(listen_s->sock_fd, (struct sockaddr *)&sin, &len);
	        	if (fd <= 0)
			{
				close(fd);
				continue;
		        }
		        if (!internal_addsock(fd, listen_s)) {
				sockprintf(fd, "Too many connections, try again later.\n");
				close(fd);
		                internal_delsock(fd, listen_s);
				continue;
		        }
	        	if (getpeername(fd, (struct sockaddr *)&sin, &len) < 0) {
				close(fd);
	        	        internal_delsock(fd, listen_s);
				continue;
		        }
		        ip = (char *) &sin.sin_addr;
		        sprintf(iphashbuf, "%d.%d.%d.%d", ip[0], ip[1], ip[2], ip[3]);
        		listen_s->client_ip[findsock(fd, listen_s)] = strdup(iphashbuf);
			(*parse)(NULL, 0, fd);
		}
		for (i = 0; i < listen_s->maxconn; i++) {
			if (listen_s->sock_clients[i] != -1) {
				if (FD_ISSET(listen_s->sock_clients[i], &in_poll)) {
					while(1) {
						sz = recv(listen_s->sock_clients[i], &tc, buf, MSG_PEEK);
						if ((sz > 0) && (sz < buf)) {
							sz = recv(listen_s->sock_clients[i], &tc, buf, 0);
							(*parse)(tc, sz, listen_s->sock_clients[i]);
							break;
						} else if (sz >= buf) {
							sz = recv(listen_s->sock_clients[i], &tc, buf, 0);
							(*parse)(tc, sz, listen_s->sock_clients[i]);
							continue;
						} else if (sz == 0) {
							(*parse)(NULL, -1, fd);
							internal_delsock(listen_s->sock_clients[i], listen_s);
							break;
						}
					}
				}
			}
		}
	}
	return -9;
}

static int internal_addsock(int sock, sock_listen *listen_s) {
        int i, a = 0;
        for (i = 0; i < listen_s->maxconn; i++) {
                if (listen_s->sock_clients[i] == -1) {
                        listen_s->sock_clients[i] = sock;
			fcntl(sock, F_SETFL, O_NONBLOCK);
                        a = 1;
                        break;
                }
        }
        return a;
}

static int internal_delsock(int sock, sock_listen *listen_s) {
        int i, a = 0;
        for (i = 0; i < listen_s->maxconn; i++) {
                if (listen_s->sock_clients[i] == sock) {
			close(sock);
                        listen_s->sock_clients[i] = -1;
                        listen_s->client_ip[i] = 0;
                        a = 1;
                        break;
                }
        }
        return a;
}

int findsock(int sock, sock_listen *listen_s) {
        int i;
        for (i = 0; i < listen_s->maxconn; i++) {
                if (listen_s->sock_clients[i] == sock) return i;
        }
        return -1;
}

int closesock(int sock, sock_listen *listen_s) {
        int i, a = 0;
        for (i = 0; i < listen_s->maxconn; i++) {
                if (listen_s->sock_clients[i] == sock) {
			close(sock);
                        listen_s->sock_clients[i] = -1;
                        listen_s->client_ip[i] = 0;
                        a = 1;
                        break;
                }
        }
        return a;
}

