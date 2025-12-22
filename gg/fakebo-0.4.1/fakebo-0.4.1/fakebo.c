
/*
 * FakeBO - fakes Trojan Servers and logs every attempt to file/stdout
 *
 * Code Maintainer: Vlatko Kosturjak, Kost <kost@iname.com>
 *
 * Distributed under GNU Public License.
 *
 */

#define FAKEBO_COMMANDS		/* include bocommand structure */
#define FAKEBOCONF "fakebo.conf"

#include "global.h"
#include "bo.h"
#include "nb.h"
#include "misc.h"

#ifdef WORDS_BIGENDIAN
#define __EL_LONG(x) (u32bit) \
	((((x) >> 24) & 0x000000FF) | \
	 (((x) >> 8)  & 0x0000FF00) | \
	 (((x) << 8)  & 0x00FF0000) | \
	 (((x) << 24) & 0xFF000000))
#else
#define __EL_LONG(x) (u32bit)(x)
#endif

#define MAXSIGS              1024



extern char *out_formats[NB_PARAMS];
static char *fakeboconfdir[] =
{"/etc", "/usr/local/etc", "~", ".", NULL};
static char *signames[MAXSIGS];


extern void RealBOInit(void);
static void conf_reread(int signo);

static void sighandler(int sig)
{
	if (sig < 0)
		sig = -sig;
	sig %= MAXSIGS;
	if (verboselog != 0)
		fprintf(stderr, "fakebo: caught SIG%s, shutting down FakeBO server...\n"
			,signames[sig]);
	stop = TRUE;
}

static void sig_chld(int signo)
{
	signo = signo;
#if HAVE_WAITPID
	while (waitpid(0, (int *) (NULL), (WNOHANG | WUNTRACED)) > 0);
#elif HAVE_WAIT3
	while (wait3(NULL, (WNOHANG | WUNTRACED), NULL) > 0);
#else
#warning "No usable wait function !"
#endif
}

static RETSIGTYPE setsignal(int sig, void (*sighnd) (int signo))
{
#ifdef HAVE_SIGACTION
	struct sigaction sa;

	sa.sa_handler = sighnd;
	sigemptyset(&sa.sa_mask);
	sa.sa_flags = 0;
	sigaction(sig, &(sa), (struct sigaction *) (NULL));
#elif HAVE_SIGNAL
	signal(sig, sighnd);
#else
#warning "No support for signals !"
#endif
}

/*
 * Initializes the signal handling and removes buffering from stderr, stdin 
 * and stdout.
 */
static void siginit(void)
{
	int i;

	for (i = 0; i < MAXSIGS; i++)
		signames[i] = "???";
#ifdef SIGEXIT
	signames[SIGEXIT] = "EXIT";
#endif
#ifdef SIGHUP
	signames[SIGHUP] = "HUP";
#endif
#ifdef SIGINT
	signames[SIGINT] = "INT";
#endif
#ifdef SIGQUIT
	signames[SIGQUIT] = "QUIT";
#endif
#ifdef SIGILL
	signames[SIGILL] = "ILL";
#endif
#ifdef SIGTRAP
	signames[SIGTRAP] = "TRAP";
#endif
#ifdef SIGABRT
	signames[SIGABRT] = "ABRT";
#endif
#ifdef SIGBUS
	signames[SIGBUS] = "BUS";
#endif
#ifdef SIGFPE
	signames[SIGFPE] = "FPE";
#endif
#ifdef SIGKILL
	signames[SIGKILL] = "KILL";
#endif
#ifdef SIGUSR1
	signames[SIGUSR1] = "USR1";
#endif
#ifdef SIGUSR2
	signames[SIGUSR2] = "USR2";
#endif
#ifdef SIGSEGV
	signames[SIGSEGV] = "SEGV";
#endif
#ifdef SIGPIPE
	signames[SIGPIPE] = "PIPE";
#endif
#ifdef SIGALRM
	signames[SIGALRM] = "ALRM";
#endif
#ifdef SIGTERM
	signames[SIGTERM] = "TERM";
#endif
#ifdef SIGSTKFLT
	signames[SIGSTKFLT] = "STKFLT";
#endif
#ifdef SIGCHLD
	signames[SIGCHLD] = "CHLD";
#endif
#ifdef SIGCONT
	signames[SIGCONT] = "CONT";
#endif
#ifdef SIGSTOP
	signames[SIGSTOP] = "STOP";
#endif
#ifdef SIGTSTP
	signames[SIGTSTP] = "TSTP";
#endif
#ifdef SIGTTIN
	signames[SIGTTIN] = "TTIN";
#endif
#ifdef SIGTTOU
	signames[SIGTTOU] = "TTOU";
#endif
#ifdef SIGWINCH
	signames[SIGWINCH] = "WINCH";
#endif
	stop = 0;
	setbuf(stdin, (char *) (NULL));
	setbuf(stdout, (char *) (NULL));
	setbuf(stderr, (char *) (NULL));
#ifdef SIGPIPE
	setsignal(SIGPIPE, SIG_IGN);
#endif
#ifdef SIGINT
	setsignal(SIGINT, sighandler);
#endif
#ifdef SIGQUIT
	setsignal(SIGQUIT, sighandler);
#endif
#ifdef SIGTERM
	setsignal(SIGTERM, sighandler);
#endif
#ifdef SIGBUS
	setsignal(SIGBUS, sighandler);
#endif
#ifdef SIGFPE
	setsignal(SIGFPE, sighandler);
#endif
#ifdef SIGILL
	setsignal(SIGILL, sighandler);
#endif
#ifdef SIGHUP
	setsignal(SIGHUP, conf_reread);
#endif
#ifdef SIGABRT
	setsignal(SIGABRT, sighandler);
#endif
#ifdef SIGSEGV
	setsignal(SIGSEGV, sighandler);
#endif
#ifdef SIGCHLD
	setsignal(SIGCHLD, sig_chld);
#endif
}


/*
 * Recognizes and returns the NetBus commands
 */
char *netbusdesc(char *msgtocmp)
{
	int i;
	for (i = 0; i < NETBUSMAXCOM; i++)
		if (strncmp(msgtocmp, netbuscommands[i][0], strlen(netbuscommands[i][0])) == 0)
			return (netbuscommands[i][1]);
	return (unknownnetbuscommand);
}

/*
 * Returns command field of NetBus command
 */
int netbuscommand(char *msgtocmp)
{
	int i;

	for (i = 0; i < NETBUSMAXCOM; i++) {
		if (strncmp(msgtocmp, netbuscommands[i][0], strlen(netbuscommands[i][0])) == 0)
			return (i);
	}
	return (-1);
}


/*
 * Returns data field of NetBus command
 */
void netbusdata(char *allcommand, char *command, char *data)
{
	int i, j;

	if (data == NULL)
		return;
	if ((allcommand == NULL) || (command == NULL)) {
		data[0] = '\0';
		return;
	}
	j = 0;
	for (i = 0; i < strlen(allcommand); i++) {
		if (i >= strlen(command) && allcommand[i] != '\r' && allcommand[i] != '\n')
			data[j++] = allcommand[i];
	}
	data[j] = '\0';
}


/*
 * Used for debugging of correct packet recognition.
 * 
 */
void bocommandinit(void)
{
	byte i;
	char tmpstr[80];

	for (i = 0; i < MAXNUMCOMMANDS; i++) {
		strcpy(tmpstr, bocommands[i]);
		sprintf(bocommands[i], "0x%02X %s", i, tmpstr);
	}
}

/*
 * Loads configuration from config file. 
 */
void loadconfig(char *config_file)
{
	FILE *fp;
	char line[LINE_SIZE], *pos, cfgfile[1024];
	int var, linenb, i;

	if (config_file != NULL) {
		strncpy(cfgfile, config_file, sizeof(cfgfile));
		fp = fopen(cfgfile, "rt");
	} else {
		i = 0;
		fp = NULL;
		while (fakeboconfdir[i] != NULL && fp == NULL) {
			strcpy(cfgfile, fakeboconfdir[i]);
			strcat(cfgfile, "/");
			strcat(cfgfile, FAKEBOCONF);
			if (verboselog != 0)
				fprintf(stdout, "Trying to open `%s'...", cfgfile);
			fp = fopen(cfgfile, "rt");
			if (fp == NULL) {
				if (verboselog != 0)
					fprintf(stdout, " failed.\n");
				i++;
			} else {
				if (verboselog != 0)
					fprintf(stdout, " success!\n");
				if (verboselog != 0)
					fprintf(stdout, "Using config file `%s'.\n", cfgfile);
			}
		}
	}
	if (fp == NULL)
		fprintf(stderr, "Can't open `" FAKEBOCONF "' in ANY directory, using defaults.\n");
	else {
		linenb = 0;
		while (fgets(line, LINE_SIZE, fp) != NULL) {
			linenb++;
			if (line[0] == '#' || line[0] == '\n')
				continue;	/* a comment */
			for (var = 0; var < NB_PARAMS; var++) {
				if (strstr(line, keywords[var]) != line)
					continue;
				pos = line + strlen(keywords[var]);

				if (*pos++ != ' ')	/* keyword must be followed by an espace */
					continue;
				sscanf(pos, in_formats[var], addresses[var]);
				break;
			}
			if (var == NB_PARAMS)
				if (verboselog != 0)
					fprintf(stderr
						,"Unrecognized command in config file"
						" `%s', line %d:\n%s\n"
						,cfgfile, linenb, line);
		}
		fclose(fp);
	}
	if (strcmp(logfile, "stdout") == 0) {
		if (verboselog != 0)
			printf("Logging to stdout.\n");
		fptolog = stdout;
	} else {
		if (strcmp(logfile, "stderr") == 0) {
			if (verboselog != 0)
				printf("Logging to stderr.\n");
			fptolog = stderr;
		} else {
			fptolog = fopen(logfile, "at");
			if (fptolog == NULL) {
				fprintf(stderr, "Error opening logfile `%s', using stdout\n", logfile);
				fptolog = stdout;
			}
		}
	}
	if (bufferedlogging == 0)
		setbuf(fptolog, (char *) NULL);
}


/*
 * Debug the config set up.
 * 
 */
void debugconfig(void)
{
	int var;

	fprintf(stderr, "---[ Config parameters ]---\n");
	for (var = 0; var < NB_PARAMS; var++) {
		fprintf(stderr, "%s ", keywords[var]);
		if (strcmp(out_formats[var], "%d") == 0)
			fprintf(stderr, out_formats[var], *(int *) addresses[var]);
		else
			fprintf(stderr, out_formats[var], addresses[var]);
		fprintf(stderr, "\n");
	}
	fprintf(stderr, "---------[ End ]---------\n");
}

/*
 * Returns just hex BO command
 *
 */
byte whatbocommand(byte t)
{
	byte r;

	r = t;
	if (r & 0x80)
		r = r - 0x80;
	if (r & 0x40)
		r = r - 0x40;

	return (r);
}


/*
 * Extracts the BO command from t and returns the pointer to name of command.
 * 
 */
char *typeofbocommand(byte t)
{
	byte i;

	t = whatbocommand(t);

	for (i = 0; i < MAXNUMCOMMANDS; i++)
		if ((t & i) == t) {
			return bocommands[i];
		}
	return (notyetimplemented);
}



#ifdef DEBUG

/*
 * Used for debugging of server packets
 *
 */
void debugspacket(bopacket * vamo)
{
	printf("MAGIC=%.8s\t", vamo->hdr.magic);
	printf("Len=%ud\t", __EL_LONG(vamo->hdr.len));
	printf("ID=%ud\t", __EL_LONG(vamo->hdr.id));
	printf("Type=0x%02X\n", vamo->hdr.t);
	printf("%s\n", typeofbocommand(vamo->hdr.t));
	printf("Data\n");
	printf("%s\n", &vamo->buf[sizeof(vamo->hdr)]);
	printf("End.\n");
}


/*
 * Used for debugging client packets.
 *
 */
void debugcpacket(bopacket * vamo)
{
	char *c;

	printf("MAGIC=%.8s\t", vamo->hdr.magic);
	printf("Len=%ud\t", __EL_LONG(vamo->hdr.len));
	printf("ID=%ud\t", __EL_LONG(vamo->hdr.id));
	printf("Type=0x%02X\n", vamo->hdr.t);
	printf("%s\n", typeofbocommand(vamo->hdr.t));
	printf("Data1\n");
	c = &vamo->buf[sizeof(vamo->hdr)];
	printf("%s\n", c);
	printf("Data2\n");
	c += strlen(c) + 1;
	printf("%s\n", c);
	printf("End.\n");
}

#endif



#ifdef SIGHUP
/*
 * Re-reads configuration and restarts fakebo.
 */
static void conf_reread(int signo)
{
	static char msg[] = "Warning: SIGHUP received, but config re-read not yet implemented!\n";

	logprintf(TRUE, msg);
	syslogprintf(msg);
}

#endif


/*
 * Logs the client packet to file stream fptolog.
 *
 */
void logcpacket(bopacket * vamo)
{
	char *c;
	char tmpbuf[BUFFSIZE], buf[BUFFSIZE];
	char tmpchar[5], *ch;
	int i, ch2;

	switch (logreceivedpackets) {
	case 4:
		memset(tmpbuf, 0, sizeof(tmpbuf));
		memset(buf, 0, sizeof(buf));
		memset(tmpchar, 0, sizeof(tmpchar));
		ch = buf;
		logprintf(TRUE, "Packet dump:\n");
		for (i = 0; i < vamo->hdr.len; i++) {
			if (((i % HEXDUMPSIZE) == 0) && (i > 0)) {
				logprintf(TRUE, "\t%08X: %s  %s\n", i - HEXDUMPSIZE, tmpbuf, buf);
				memset(tmpbuf, 0, sizeof(tmpbuf));
				memset(buf, 0, sizeof(buf));
				ch = buf;
			}
			ch2 = (int) vamo->buf[i];
			sprintf(tmpchar, "%02X ", (unsigned) (ch2) & 0xFF);
			strcat(tmpbuf, tmpchar);
			(*(ch++)) = (ch2 >= ' ' && ch2 <= 127) ? (char) ch2 : '.';
		}
		if (strlen(tmpbuf) && strlen(buf)) {
			logprintf(TRUE, "\t%08X: %s%*s  %s\n", i - HEXDUMPSIZE, tmpbuf,
			    (HEXDUMPSIZE * 3) - strlen(tmpbuf), "", buf);
		}
	case 3:

		logprintf(TRUE, "\tCommand: %s\n"
			  ,typeofbocommand(vamo->hdr.t));

		c = &vamo->buf[sizeof(vamo->hdr)];
		logprintf(TRUE, "\t(%s)", c);
		c += strlen(c) + 1;
		logprintf(FALSE, "(%s)\n", c);

		logprintf(TRUE, "\tMagic=%.8s\t", vamo->hdr.magic);

		logprintf(FALSE, "Len=%ld\t", __EL_LONG(vamo->hdr.len));
		logprintf(FALSE, "ID=%ld\t", __EL_LONG(vamo->hdr.id));

		logprintf(FALSE, "Type=0x%02X\n", vamo->hdr.t);
		break;

	case 2:
		logprintf(TRUE, "\tCommand: %s\n"
			  ,typeofbocommand(vamo->hdr.t));

		c = &vamo->buf[sizeof(vamo->hdr)];
		logprintf(TRUE, "\t(%s)", c);
		c += strlen(c) + 1;
		logprintf(FALSE, "(%s)\n", c);
		break;

	case 1:
		logprintf(TRUE, "\tCommand: %s\n"
			  ,typeofbocommand(vamo->hdr.t));
		break;
	}
}


/*
 * Logs the server packet via logprintf()
 *
 */
void logspacket(bopacket * vamo)
{
	switch (logsendingpackets) {
	case 3:
		logprintf(TRUE, "\tCommand: %s\n"
			  ,typeofbocommand(vamo->hdr.t));

		logprintf(TRUE, "\t(%s)\n"
			  ,&vamo->buf[sizeof(vamo->hdr)]);

		logprintf(TRUE, "\tMagic=%.8s\t", vamo->hdr.magic);

		logprintf(FALSE, "Len=%ld\t", __EL_LONG(vamo->hdr.len));
		logprintf(FALSE, "ID=%ld\t", __EL_LONG(vamo->hdr.id));

		logprintf(FALSE, "Type=0x%02X\n", vamo->hdr.t);
		break;
	case 2:
		logprintf(TRUE, "\tCommand: %s\n"
			  ,typeofbocommand(vamo->hdr.t));
		logprintf(TRUE, "\t(%s)\n"
			  ,&vamo->buf[sizeof(vamo->hdr)]);
		break;
	case 1:
		logprintf(TRUE, "\tCommand: %s\n"
			  ,typeofbocommand(vamo->hdr.t));
		break;
	}
}


/*
 * Sets global seed value.
 *   
 */
void msrand(unsigned int seed)
{
	holdrand = (long) seed;
}

int mrand(void)
{
	return ((holdrand = holdrand * 214013L + 2531011L) >> 16) & 0x7FFF;
}


/*
 * Calculates the word value from password.
 *   
 */
unsigned int getkey()
{
	int x, y;
	unsigned int z;

	y = strlen(g_password);
	if (!y)
		return 31337;
	else {
		z = 0;
		for (x = 0; x < y; x++)
			z += g_password[x];
		for (x = 0; x < y; x++) {
			if (x % 2)
				z -= g_password[x] * (y - x + 1);
			else
				z += g_password[x] * (y - x + 1);
			z = z % RAND_MAX;
		}
		z = z * y % RAND_MAX;
		return z;
	}
}


/*
 * Main function for crypting/decrypting the BO packet.
 *
 */
void cryptpacket(unsigned char *buff, int len)
{
	int y;

	if (!len)
		return;
/*    msrand(getkey()); */
	msrand(resetholdrand);
	for (y = 0; y < len; y++)
		buff[y] = buff[y] ^ (mrand() % 256);
}

int atoport(char *service, char *proto)
{
	int port;
	long int lport;
	struct servent *serv;
	char *errpos;

	serv = getservbyname(service, proto);
	if (serv != NULL)
		port = serv->s_port;
	else {
		lport = strtol(service, &errpos, 0);
		if (errpos[0] != 0 || lport < 1 || lport > 65535)
			return -1;
		port = htons(lport);
	}
	return port;
}


void strreplace(char *str, char *s1, char *s2, unsigned size)
{
	char *c, *c2, tmp[1024];

	if (str == NULL)
		return;
	if (size > sizeof(tmp))
		size = sizeof(tmp);
	c = str;
	do {
		memset(tmp, 0, sizeof(tmp));
		c = ((c != NULL) ? (strstr(c, s1)) : (NULL));
		if (c == NULL)
			continue;
		if ((c != str) && ((*(c - 1)) == '\\')) {
			c2 = c;
			while ((*c) != '\0') {
				(*(c - 1)) = (*c);
				c++;
			}
			(*(c - 1)) = '\0';
			/* c += ((strlen(s1) < strlen(c)) ? (strlen(s1)) : (size)); */
			c = c2;
			continue;
		}
		c2 = c;
		if ((strlen(c) - strlen(s1)) < sizeof(tmp)) {
			memcpy(tmp, c + strlen(s1), strlen(c) - strlen(s1));
			if ((c + strlen(s2)) < (str + size)) {
				memcpy(c, s2, strlen(s2));
				c += strlen(s2);
				if (strlen(tmp) < (size - (c - str))) {
					memcpy(c, tmp, strlen(tmp));
					c += strlen(tmp);
					if ((c - str) < size)
						(*c) = '\0';
				}
			}
		}
		c = c2;
	} while (c != NULL);
}

/*
 * Displays intro message 
 *
 */
void intro(void)
{
	printf("FakeBO  version " VERSION "  Copyright (C) 1998,99 by KoSt\n\n");
}

/*
 * Dissociate from the terminal and go to the background
 */
void fork_to_bg(void)
{
	pid_t pid;

	/* Fork into the background here */
	if ((pid = vfork()) < 0)
		printf("vFork error, remaining in foreground.\n");
	/* Let the parent process die */
	else {
		if (pid > 0)
			exit(0);
	}
	setsid();
	if ((pid = vfork()) < 0)
		printf("vFork error, remaining in foreground.\n");
	/* Let the parent process die */
	else {
		if (pid > 0)
			exit(0);
	}
	open("/dev/null", O_RDONLY);	/* stdin  */
	open("/dev/null", O_WRONLY);	/* stdout */
	open("/dev/null", O_WRONLY);	/* stderr */
}

/*
 * Main program.
 *
 */
int main(int argc, char *argv[])
{
	int foo;
	bopacket bo;
	unsigned long slen = 0;
	int opt;
	char *config_file = NULL;
	int debug = FALSE, about = FALSE;
	int sock;
	struct sockaddr_in client, server;
	int recvd;
	int structlength;
	int port;
#ifdef HAVE_STRUCT_LINGER
	struct linger linger;
#endif
	struct timeval tv;
	struct hostent *he;
	fd_set fds;
	char *msg;
	char ad[256], *ipaddr;
	char tmpexecute[512];
	int tosendpacket = 1;
	int howmany = 0;
	FILE *tmpfp;
	char tmpcustomreply[1024];
	int isdaemon = 0;
	/* ignorehost resolving */
	struct hostent *ignhptr;
	unsigned long ignhost;

	/* NetBus variable support */
	char netbusbuf[BUFLEN];
	int netbuson, netbusi, netbusj, netbussl, netbusr;
	unsigned int netbuslen;
	int netbusmfd, netbustcp, netbuscfd;
#ifdef HAVE_GETPROTOBYNAME
	struct protoent *netbustcpproto;
#endif
	struct timeval netbustv;
	struct hostent *netbushe;
	char netbusad[BUFLEN], *netbusipaddr;
	fd_set netbusfds, netbuswfds;
	char nbdatabuf[BUFLEN];
	char nblogbuf[BUFLEN * 3];
	/* End of NetBus variable support */

	memset(repeatbuf, 0, sizeof(repeatbuf));

	while ((opt = getopt(argc, argv, "c:dihbavV")) != EOF)
		switch (opt) {
		case 'c':
			config_file = optarg;
			break;
		case 'd':
			debug = TRUE;
			break;
		case 'v':
			verboselog = TRUE;
			break;
		case 'V':
			fprintf(stdout, "fakebo version " VERSION "\n");
			return (EXIT_SUCCESS);
		case 'i':
			bocommandinit();
			break;
		case 'h':
			intro();
			printf(usage, argv[0]);
			printf("\nPath where config file will be searched: \n");
			netbusi = 0;
			while (fakeboconfdir[netbusi] != NULL)
				printf("\"%s\", ", fakeboconfdir[netbusi++]);
			printf("\n");
			return 0;
		case 'b':
			isdaemon = 1;
			break;
		case 'a':
			about = TRUE;
			break;
		default:
			fprintf(stderr, "Unknown switch `-%c'. Try `%s -h'.\n",
				opt, argv[0]);
			return (EXIT_FAILURE);
		}
	RealBOInit();
	if (!about)
		loadconfig(config_file);
	if (isdaemon)
		startasdaemon = 1;

	if (!startasdaemon || about) {
		intro();
		if (!about)
			printf("Type `%s -a' for details.\n", argv[0]);
		printf("\n");
	}
	if (about) {
		printf(msg_about);
		return (0);
	}
	if (debug)
		debugconfig();

	port = atoport(boporttolisten, "udp");

	/* If we don't need root privileges to bind the sockets, drop them now */
	if (port >= 1024 && nbport >= 1024)
		dropprivileges(user);

/*    memset(g_password, 0, sizeof(g_password)); */

	resetholdrand = 31337;
	msrand(resetholdrand);

	if (port < 0) {
		fprintf(stderr, "Unable to find port %s.\n", argv[1]);
		return (EXIT_FAILURE);
	}
	sock = socket(AF_INET, SOCK_DGRAM, 0);
	if (sock < 0) {
		perror("socket");
		return (EXIT_FAILURE);
	}
	siginit();		/* initialize signal handlers */

#ifdef HAVE_STRUCT_LINGER
	linger.l_onoff = 0;	/* dont linger */
	setsockopt(sock, SOL_SOCKET, SO_LINGER, (void *) &linger, sizeof(linger));
#endif
	memset((char *) &client, 0, sizeof(client));
	client.sin_family = AF_INET;
	client.sin_addr.s_addr = htonl(INADDR_ANY);
	client.sin_port = port;
	memset((char *) &server, 0, sizeof(server));
	server.sin_family = AF_INET;
	server.sin_addr.s_addr = htonl(INADDR_ANY);
	server.sin_port = port;
	structlength = sizeof(server);
	if (bind(sock, (struct sockaddr *) &server, structlength) < 0) {
		perror("bind");
		return (EXIT_FAILURE);
	}
	/* End of BO Support */

	/* NetBus Support */
	netbuslfd = -1;
	netbuson = 1;
	netbustcp = -1;
#ifdef HAVE_GETPROTOBYNAME
	netbustcpproto = (struct protoent *) getprotobyname("tcp");
	if (netbustcpproto != (struct protoent *) (NULL))
		netbustcp = netbustcpproto->p_proto;
#endif
	netbuslfd = socket(AF_INET, SOCK_STREAM, 0);
	if (netbuslfd < 0) {
		logprintf(TRUE, "[NB] Call to `socket()' failed!\n");
		return (EXIT_FAILURE);
	}
	netbusaddr.sin_family = AF_INET;
	netbusaddr.sin_addr.s_addr = htonl(INADDR_ANY);
	netbusaddr.sin_port = htons(nbport);
	setsockopt(netbuslfd, SOL_SOCKET, SO_REUSEADDR, (char *) (&(netbuson)), sizeof(netbuson));
	if (bind(netbuslfd, (struct sockaddr *) (&(netbusaddr)), sizeof(netbusaddr)) < 0) {
		logprintf(TRUE, "Unable to `bind()' on NetBus port %d!\n", nbport);
		return (EXIT_FAILURE);
	}
	listen(netbuslfd, 5);
	/* End of NetBus Support */

	/* The sockets are binded, we don't need root privileges any more */
	dropprivileges(user);

	if (startasdaemon) {
		int i;

		/* Close all file descriptors except std- ones */
		for (i = 0; i < 255; i++) {
			if ((i != sock) && (i != netbuslfd) && (i != fileno(fptolog)))
				close(i);
		}

		fork_to_bg();
	}
	logprintf(TRUE, "FakeBO %s started using PID %d.\n", VERSION, getpid());

	/* Code for ignoring the host */
	if (strcmp(ignorehost, "") == 0 || strcmp(ignorehost, HOSTIGNORE_NONE) == 0) {
		toignorehost = 0;
		if (verboselog != 0)
			logprintf(TRUE, "Turning off ignore IP address\n");
	} else {
		toignorehost = 1;
		if ((ignhptr = gethostbyname(ignorehost)) == NULL) {
			ignhost = 0;
			logprintf(TRUE, "Error while resolving ignore IP address, ignorehost option ignored!\n");
			toignorehost = 0;
		} else {
			strcpy(ignorehostip, inet_ntoa(*(struct in_addr *) ignhptr->h_addr_list[0]));

			if (verboselog != 0)
				logprintf(TRUE, "Ignore offical hostname: %s address: %s\n",
					  ignhptr->h_name, ignorehostip);

			if ((ignhost = *(unsigned long *) ignhptr->h_addr_list[0]) == (unsigned long) -1) {
				ignhost = 0;
				logprintf(TRUE, "Resolver returned invalid ignore IP address, ignorehost option ignored!\n");
				toignorehost = 0;
			}
		}
	}

	while (stop == FALSE) {
		slen = 0;
		memset((char *) &bo, 0, sizeof(bo));
		structlength = sizeof(client);
		recvd = 0;

		FD_ZERO(&fds);
		FD_SET(sock, &fds);
		tv.tv_sec = 1;
		tv.tv_usec = 0;
		if ((select(sock + 1, &fds, NULL, NULL, &tv) < 0) && (!stop)) {
			if (errno != EINTR) {
				logprintf(TRUE, "[NB] `select()' failed!\n");
				return (-1);
			} else
				continue;
		}
		if ((FD_ISSET(sock, &fds)) && (!stop)) {
			memset((void *) &bo, 0, sizeof(bo));
			recvd = recvfrom(sock, (char *) &bo, sizeof(bo), 0,
			     (struct sockaddr *) &client, &structlength);
		}
		if (stop == TRUE)
			continue;
		if (recvd < 0) {
			logprintf(TRUE, "[BO] `recvfrom()' error\n");
			/* return (EXIT_FAILURE); */
		}
		if (recvd > 0) {
			he = gethostbyaddr((char *) (&client.sin_addr)
				      ,sizeof(client.sin_addr), AF_INET);
			ipaddr = inet_ntoa(client.sin_addr);
			if (he != (struct hostent *) (NULL))
				sprintf(ad, "%s (%s)", ipaddr, he->h_name);
			else
				sprintf(ad, "%s", ipaddr);
			if ((((toignorehost != 0) && (strcmp(ipaddr, ignorehostip) != 0)) || toignorehost == 0)) {
				if ((recvd > 10) && (recvd < 1023)) {
					bopacket bobuf;
					memcpy(bobuf.buf, bo.buf, recvd);

					/* slen = __EL_LONG(bo.hdr.len) ; */

					if (tocrackpackets != 0) {
						cryptpacket((unsigned char *) &bo, MAGICSTRINGLEN);
						if (strncmp((const char *) bo.hdr.magic, (const char *) MAGICSTRING, MAGICSTRINGLEN) != 0) {
							/* Enciphered packet? */
							/* bopacket bo1; */
							int i;

							/* cryptpacket ((unsigned char *)&bo, recvd); */
							/* bo1=bo; */
							for (i = 0; i <= MRAND_MAX_STATE; i++) {
								memcpy(bo.buf, bobuf.buf, MAGICSTRINGLEN);
								resetholdrand = i;
								cryptpacket((unsigned char *) &bo, MAGICSTRINGLEN);

								/* Heavily optimised cracking routine 
								   I didn't want to use for() 'cause it slower
								   than this. Sacrified code size for speed */
								if (bo.hdr.magic[0] == '*')
									if (bo.hdr.magic[1] == '!')
										if (bo.hdr.magic[2] == '*')
											if (bo.hdr.magic[3] == 'Q')
												if (bo.hdr.magic[4] == 'W')
													if (bo.hdr.magic[5] == 'T')
														if (bo.hdr.magic[6] == 'Y')
															if (bo.hdr.magic[7] == '?')
																break;

								/* If you still want smaller code size, 
								   and slower cracking routine, you can comment
								   above code, and use code below */

								/* if (strncmp((const char *)bo.hdr.magic, (const char *)MAGICSTRING, MAGICSTRINGLEN) == 0)
								   break; */
								if (stop == TRUE)
									break;
							}
							if (stop == TRUE)
								continue;
							if (i <= MRAND_MAX_STATE) {
								if (logconnection != 0)
									logprintf(TRUE, "[BO] Cracked received packet! Encryption key is 0x%x\n", i);
							}
						}
					}
					memcpy(bo.buf, bobuf.buf, recvd);
					cryptpacket((unsigned char *) &bo, recvd);
					slen = __EL_LONG(bo.hdr.len);

#ifdef DEBUG
					logprintf(TRUE, "[BO] Len of UDP/BO packet received: %d/%ld\n", recvd, __EL_LONG(bo.hdr.len));
#endif
					if (strncmp((const char *) bo.hdr.magic, (const char *) MAGICSTRING, MAGICSTRINGLEN) == 0
					    && slen != 0) {
						if (logconnection != 0)
							logprintf(TRUE, "[BO] Received packet from %s: BO PACKET!\n", ad);

						if (logtosyslog == 1)
							syslogprintf("BO Packet from %s", ad);
						else
							syslogprintf("[BO] packet from %s: %s", ad, typeofbocommand(bo.hdr.t));

						logcpacket(&bo);	/* log the packet from client */
						FD_ZERO(&fds);
						FD_SET(sock, &fds);
						tv.tv_sec = 10;
						tv.tv_usec = 0;
						if (select(sock + 1, NULL, &fds, NULL, &tv) == 0) {
							logprintf(TRUE, "[BO] select (timeout error)\n");
							continue;
						}
						msg = &bo.buf[sizeof(bo.hdr)];

						if (sendfakereply == 1 && bo.hdr.t == 0x01) {
							sprintf(msg, "  !PONG!%s!%s!", bofakever, machinename);
						} else {
							foo = 0;	/* assume fail */
							if (userealfakebo != 0) {
								extern int RealFakeBO(char *msg, bopacket * bo);
#ifdef DEBUG
								logprintf(TRUE, "[BO] Starting RealBO...\n");
#endif

								if (RealFakeBO(msg, &bo))
									foo = 1;	/* succeeded */
							}
#ifdef DEBUG
							logprintf(TRUE, "[BO] RealBO done.\n");
#endif
							if (foo == 0) {
								if (usecustomreplies != 0) {
#ifdef DEBUG
									logprintf(TRUE, "[BO] Starting custom....\n");
#endif
									sprintf(tmpcustomreply, "%s%02X", customrepliespath, whatbocommand(bo.hdr.t));
									tmpfp = fopen(tmpcustomreply, "rt");
									if (tmpfp == NULL)
										sprintf(msg, bomessage, ad);
									else {
										howmany = fread(msg, sizeof(byte), MAXSIZECUSTOM, tmpfp);
										fclose(tmpfp);
										if (howmany < 0)
											howmany = 0;
										msg[howmany] = '\0';
									}
								} else
									sprintf(msg, bomessage, ad);
							}
#ifdef DEBUG
							logprintf(TRUE, "[BO] Finished not ping reply\n");
#endif
						}
						tosendpacket = 0;
						if (silentmode == 0)
							tosendpacket = 1;
						if (recvd != bo.hdr.len)
							tosendpacket = 1;
						else if (bo.hdr.t == 0x01 && sendfakereply == 1)
							tosendpacket = 1;
						slen = __EL_LONG(bo.hdr.len) + strlen(msg) + 2;
						bo.hdr.len = __EL_LONG(slen);
						/*
						   bo.hdr.len += strlen(msg) + 2 ;
						   slen = bo.hdr.len;
						 */
#ifdef DEBUG
						logprintf(TRUE, "[BO] Started sending packet...\n");
#endif
						holdrand = 1L;
						if (tosendpacket) {
							if (logconnection != 0)
								logprintf(TRUE, "[BO] Sending packet to %s...\n", ipaddr);
							logspacket(&bo);
							cryptpacket((unsigned char *) &bo, sizeof(bo));
							if (FD_ISSET(sock, &fds))
								if (sendto(sock, (const char *) &bo, slen, 0
									   ,(struct sockaddr *) &client
									   ,sizeof(client))
								!= slen) {
									logprintf(TRUE, "[BO] Error replying in sendto:\n");
								}
						}
						if (toexecutescript != 0) {
							if (vfork() == 0) {
								for (netbusi = 0; netbusi < netbusclients; netbusi++)
									close(netbuskfd[netbusi]);
								close(netbuslfd);
								close(sock);
								memset(tmpexecute, 0, sizeof(tmpexecute));
								strcpy(tmpexecute, executescript);
								strreplace(tmpexecute, "!", ipaddr, sizeof(tmpexecute));
								strreplace(tmpexecute, "%", "backorifice", sizeof(tmpexecute));
								if (execlp(executescriptshell, executescriptshell, "-c",
									   tmpexecute, NULL) != 0) {
									logprintf(TRUE, "Unable to execute custom script `%s'!\n",
										  tmpexecute);
									return (0);
								}
								logprintf(TRUE, "vfork() error, can't exec custom script!\n");
							}
						}
					} else {
						if (logconnection != 0)
							logprintf(TRUE, "[BO] Non-BO data received from %s\n", ad);

						syslogprintf("[BO] non-BO data from %s", ad);

						if (lognotbopackets != 0) {
							logprintf(TRUE, "---[Begining of Data]---\n");
							fwrite(bo.buf, sizeof(bo.buf), 1, fptolog);
							logprintf(FALSE, "\n");
							logprintf(TRUE, "---[End of Data]---\n");
						}
					}
				} else
					logprintf(TRUE, "[BO] Unrecognized data at BO port from %s\n", ad);
			} else
				logprintf(TRUE, "[BO] Connection from %s ignored\n", ad);
		}
		/* End of BO support */

		/* Begin of NetBus support */
		FD_ZERO(&(netbusfds));
		FD_ZERO(&(netbuswfds));
		netbusmfd = netbuslfd;
		for (netbusi = 0; netbusi < netbusclients; netbusi++) {
			FD_SET(netbuskfd[netbusi], &(netbusfds));
			FD_SET(netbuskfd[netbusi], &(netbuswfds));
			if (netbuskfd[netbusi] > netbusmfd)
				netbusmfd = netbuskfd[netbusi];
		}
		FD_SET(netbuslfd, &(netbusfds));
		netbustv.tv_sec = 0;
		netbustv.tv_usec = 500000;
		netbussl = select((netbusmfd + 1), &(netbusfds), &(netbuswfds), (fd_set *) (NULL), &(netbustv));
		if (netbussl < 0) {
			if (errno != EINTR) {
				logprintf(TRUE, "[NB] Call to `select()' failed!\n");
				return (-1);
			} else
				continue;
		}
		if (netbussl == 0)
			continue;
		if (FD_ISSET(netbuslfd, &(netbusfds))) {

			/* New NetBus Connection */
			netbuslen = sizeof(netbusaddr);
			netbuscfd = accept(netbuslfd, (struct sockaddr *) (&(netbusaddr)), (int *) &(netbuslen));

			if (netbuscfd < 0) {
				if (errno == EINTR)
					continue;
				else {
					logprintf(TRUE, "[NB] Unable to `accept()' connection (maybe a tcp SYN stealth port scan?)\n");

					syslogprintf("[NB] Unable to `accept()' connection (maybe a tcp SYN stealth scan?)");
					continue;
				}
			}
			/*  Get IP address */
			netbushe = gethostbyaddr((char *) (&(netbusaddr.sin_addr)),
				   sizeof(netbusaddr.sin_addr), AF_INET);
			netbusipaddr = inet_ntoa(netbusaddr.sin_addr);
			if (netbushe != (struct hostent *) (NULL))
				sprintf(netbusad, "`%s' (%s)", netbushe->h_name, netbusipaddr);
			else
				sprintf(netbusad, "%s", netbusipaddr);
			if ((((toignorehost != 0) && (strcmp(netbusipaddr, ignorehostip) != 0)) || toignorehost == 0)) {

				syslogprintf("[NB] Connection[#%d] from %s", netbusclients, netbusad);

				/* Fork and execute the script if specified */
				if (toexecutescript != 0) {
					if (vfork() == 0) {
						for (netbusi = 0; netbusi < netbusclients; netbusi++)
							close(netbuskfd[netbusi]);
						close(netbuslfd);
						close(sock);
						memset(tmpexecute, 0, sizeof(tmpexecute));
						strcpy(tmpexecute, executescript);
						strreplace(tmpexecute, "!", netbusipaddr, sizeof(tmpexecute));
						strreplace(tmpexecute, "%", "netbus", sizeof(tmpexecute));
						if (execlp(executescriptshell, executescriptshell, "-c", tmpexecute, NULL) != 0) {
							logprintf(TRUE, "[NB] Unable to execute `%s'!\n",
							     tmpexecute);
							return (0);
						}
						logprintf(TRUE, "[NB] Unable to `vfork()', cannot execute custom scrit");
					}
				}
				if (netbusclients >= NETBUSMAXCLIENTS) {
					strcpy(netbusbuf, "Sorry, no more connections allowed.");
					write(netbuscfd, netbusbuf, strlen(netbusbuf));
					close(netbuscfd);
					if (logconnection != 0)
						logprintf(TRUE, "[NB] Connection from %s refused (>max connections)\n", netbusad);
				} else {
					if (netbustcp != -1)
#ifdef TCP_NODELAY
						setsockopt(netbuscfd, netbustcp, TCP_NODELAY, (char *) (&(netbuson)), sizeof(netbuson));
#endif
					if (logconnection != 0)
						logprintf(TRUE, "[NB] Connection[#%d] from %s accepted!\n", netbusclients, netbusad);
					netbuskfd[(netbusclients++)] = netbuscfd;
					sprintf(netbusad, "NetBus %s\r", nbfakever);
					if (write(netbuskfd[netbusi], netbusad, strlen(netbusad)) != strlen(netbusad)) {
						if (logconnection != 0)
							logprintf(TRUE, "[NB][#%d] Error writing greeting to client!\n", netbusclients - 1);
						/* return (-1); */
					} else {
						if (logsendingpackets != 0)
							logprintf(TRUE, "[NB] Sent NetBus Magic String to client #%d.\n", netbusclients - 1);
					}
					continue;
				}
			} else {
				close(netbuscfd);
				logprintf(TRUE, "[NB] Connection from `%s' ignored\n", netbusad);
			}
		}
		for (netbusi = 0; netbusi < netbusclients; netbusi++) {
			if (FD_ISSET(netbuskfd[netbusi], &(netbusfds))) {
				if (stop)
					break;
				memset((void *) (netbusbuf), 0, sizeof(netbusbuf));
				netbusr = read(netbuskfd[netbusi], netbusbuf, sizeof(netbusbuf));
				if ((netbusr == 0) && (!stop)) {
					logprintf(TRUE, "[NB][#%d] Client disconnected.\n", netbusi);
					syslogprintf("[NB] Client[#%d] disconnected.\n", netbusi);

					close(netbuskfd[netbusi]);
					for (netbusj = netbusi; netbusj < netbusclients - 1; netbusj++)
						netbuskfd[netbusi] = netbuskfd[netbusj + 1];
					netbusclients--;
					break;
				}
				if ((netbusr < 0) && (!stop)) {
					logprintf(TRUE, "[NB][#%d] Error reading from client, disconnecting\n",
						  netbusi);

					close(netbuskfd[netbusi]);
					for (netbusj = netbusi; netbusj < netbusclients - 1; netbusj++)
						netbuskfd[netbusi] = netbuskfd[netbusj + 1];
					netbusclients--;

					/* return (-1); */
					continue;
				}
				if (netbusr > 900) {
					if (logreceivedpackets > 0)
						logprintf(TRUE, "[NB][#%d] Flooding detected. Disconnecting.\n", netbusi);
					close(netbuskfd[netbusi]);
					for (netbusj = netbusi; netbusj < netbusclients - 1; netbusj++)
						netbuskfd[netbusi] = netbuskfd[netbusj + 1];
					netbusclients--;
					continue;
				}
				while (((netbusbuf[strlen(netbusbuf) - 1] == '\n') ||
					(netbusbuf[strlen(netbusbuf) - 1] == '\r')) &&
				       (strlen(netbusbuf) > 0)) {
					netbusbuf[strlen(netbusbuf) - 1] = '\0';
				}

				netbusj = netbuscommand(netbusbuf);
				memset(nblogbuf, 0, sizeof(nblogbuf));

				switch (logreceivedpackets) {
				case 3:
					strcat(nblogbuf, netbusdesc(netbusbuf));
					strcat(nblogbuf, "<The client sent: ");
					strcat(nblogbuf, netbusbuf);
					strcat(nblogbuf, ">, ");
					break;
				case 2:
					if ((netbusj >= 0) && (netbusj < NETBUSMAXCOM)) {
						netbusdata(netbusbuf, netbuscommands[netbusj][0], nbdatabuf);
						if (strcmp(netbusbuf, "") != 0) {
							strcat(nblogbuf, nbdatabuf);
							strcat(nblogbuf, " ");
						}
					}
					strcat(nblogbuf, netbusdesc(netbusbuf));
					break;
				case 1:
					strcat(nblogbuf, netbusdesc(netbusbuf));
				case 0:
					break;
				}
				logprintf(TRUE, "[NB](#%d): %s\n", netbusi, nblogbuf);

				/* Write back him the message */
				if (silentmode == 0)
					if (FD_ISSET(netbuskfd[netbusi], &(netbuswfds))) {
						sprintf(netbusad, "%s%s\r\n", NETBUSANSWER, nbmessage);
						switch (logsendingpackets) {
						case 3:
							logprintf(TRUE, " [NB](#%d): Sending Answer (hdr): %s\n", netbusi, netbusad);

						case 2:
							logprintf(TRUE, " [NB](#%d): Sending Answer: %s\n", netbusi, nbmessage);

						case 1:
							logprintf(TRUE, "[NB](#%d): Sending back answering message \n", netbusi, netbusi);

						case 0:
							break;

						default:
							logprintf(TRUE, "[NB] Invalid option for logsendingpackets option");
							break;
						}
						if (write(netbuskfd[netbusi], netbusad, strlen(netbusad)) != strlen(netbusad)) {
							logprintf(TRUE, "[NB] Error writing to client #%d!\n", netbusi);
							/* return (-1); */
						}
					}
			}
		}
		/* End of NetBus support */
	}
	/* NetBus support */
	for (netbusi = 0; netbusi < netbusclients; netbusi++)
		close(netbuskfd[netbusi]);
	close(netbuslfd);
	/* End of NetBus support */

	logprintf(TRUE, "FakeBO ending session\n");

	if (fptolog != stdout && fptolog != stderr)
		fclose(fptolog);

	return (EXIT_SUCCESS);
}
