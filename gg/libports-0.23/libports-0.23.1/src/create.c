#include "create.h"

int connect_to(char *hstname, u_short port)
{
        int s = -1;
        struct hostent *he;
        struct sockaddr_in sin;

        s = socket(AF_INET, SOCK_STREAM, 0);
        if(s < 0) return -1;

        memset(&sin, 0, sizeof(struct sockaddr_in));
        sin.sin_family = AF_INET;
        sin.sin_port = htons(port);
        sin.sin_addr.s_addr = inet_addr(hstname);
        if(sin.sin_addr.s_addr == INADDR_NONE)
        {
                he = gethostbyname(hstname);
                if(!he)
                {
                        close(s);
                        return -5;
                }
                memcpy(&sin.sin_addr, he->h_addr, he->h_length);
        }
        if(connect(s, (struct sockaddr *)&sin, sizeof(sin)) < 0)
        {
                close(s);
                return -6;
        }
        return s;
}
