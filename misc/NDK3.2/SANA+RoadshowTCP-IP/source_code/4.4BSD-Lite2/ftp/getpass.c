#include <proto/dos.h>

#include <stdio.h>
#include <signal.h>
#include <unistd.h>
#include <dos.h>

char *
getpass(const char * prompt)
{
	static char password_buffer[128+1];
	int old_flags;
	int len;
	int fd;
	int c;

	__check_abort();

	if(prompt != NULL)
	{
		fprintf(stderr,"%s",prompt);
		fflush(stderr);
	}

	fd = fileno(stdin);

	old_flags = fcntl(fd,F_GETFL);

	if((old_flags & O_NONBLOCK) == 0)
		fcntl(fd,F_SETFL,old_flags | O_NONBLOCK);

	len = 0;

	while(TRUE)
	{
		__check_abort();

		c = fgetc(stdin);
		if(c == -1 || c == '\r' || c == '\n')
			break;
		else if (c == '\003')
			raise(SIGTERM);
		else if (((c >= ' ' && c < 127) || (c >= 160)) && len < sizeof(password_buffer)-1)
			password_buffer[len++] = c;

		Delay(5);
	}

	password_buffer[len] = '\0';

	if((old_flags & O_NONBLOCK) == 0)
		fcntl(fd,F_SETFL,old_flags);

	printf("\n");

	return(password_buffer);
}
