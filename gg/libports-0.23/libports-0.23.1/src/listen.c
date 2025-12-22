#include "listen.h"

sock_listen *listen_to(int port, int maxconn) {
	int i = 1;
	int x;
	struct sockaddr_in sin;
	static sock_listen* listen_s;

	listen_s = (sock_listen*)malloc(sizeof(sock_listen));
	listen_s->sock_clients = (int*)malloc(maxconn * sizeof(int));
        listen_s->client_ip = (char **)malloc(sizeof(char *)*maxconn);
	listen_s->maxconn = maxconn;

	for (x = 0; x < maxconn; x++) listen_s->client_ip[x]=(char *)malloc(15);

	for (x=0;x<maxconn;x++) {
		listen_s->sock_clients[x] = -1;
		listen_s->client_ip[x] = 0;
	}

	listen_s->sock_fd = socket(AF_INET, SOCK_STREAM, 0);
	if (listen_s->sock_fd < 0) {
		listen_s->sock_fd = -1;
		return listen_s;
	}
	if (setsockopt(listen_s->sock_fd, SOL_SOCKET, SO_REUSEADDR, &i, sizeof(i)) < 0) {
		close(listen_s->sock_fd);
		listen_s->sock_fd = -2;
		return listen_s;
	}
	memset(&sin, 0, sizeof(sin));
	sin.sin_family = AF_INET;
	sin.sin_port = htons(port);
	if (bind(listen_s->sock_fd, (struct sockaddr *)&sin, sizeof(sin)) < 0) {
		close(listen_s->sock_fd);
		listen_s->sock_fd = -3;
		return listen_s;
	}
	if (listen(listen_s->sock_fd, 10) < 0) {
		close(listen_s->sock_fd);
		listen_s->sock_fd = -4;
		return listen_s;
	}
	fcntl(listen_s->sock_fd, F_SETFL, O_NONBLOCK);
	return listen_s;
}
