/*
 * Source generated with ARexxBox 1.12 (May 18 1993)
 * which is Copyright (c) 1992,1993 Michael Balzer
 */

#ifndef _EditPrefs_H
#define _EditPrefs_H

#define RXIF_INIT   1
#define RXIF_ACTION 2
#define RXIF_FREE   3

#define ARB_CF_ENABLED     (1L << 0)

#define ARB_HF_CMDSHELL    (1L << 0)
#define ARB_HF_USRMSGPORT  (1L << 1)

struct RexxHost
{
	struct MsgPort *port;
	char portname[ 80 ];
	long replies;
	struct RDArgs *rdargs;
	long flags;
	APTR userdata;
};

struct rxs_command
{
	char *command, *args, *results;
	long resindex;
	void (*function)( struct RexxHost *, void **, long, struct RexxMsg * );
	long flags;
};

struct arb_p_link
{
	char	*str;
	int		dst;
};

struct arb_p_state
{
	int		cmd;
	struct arb_p_link *pa;
};

#ifndef NO_GLOBALS
extern char RexxPortBaseName[80];
extern struct rxs_command rxs_commandlist[];
extern struct arb_p_state arb_p_state[];
extern int command_cnt;
extern char *rexx_extension;
#endif

void ReplyRexxCommand( struct RexxMsg *rxmsg, long prim, long sec, char *res );
void FreeRexxCommand( struct RexxMsg *rxmsg );
struct RexxMsg *CreateRexxCommand( struct RexxHost *host, char *buff, BPTR fh );
struct RexxMsg *CommandToRexx( struct RexxHost *host, struct RexxMsg *rexx_command_message );
struct RexxMsg *SendRexxCommand( struct RexxHost *host, char *buff, BPTR fh );

void CloseDownARexxHost( struct RexxHost *host );
struct RexxHost *SetupARexxHost( char *basename, struct MsgPort *usrport );
struct rxs_command *FindRXCommand( char *com );
char *ExpandRXCommand( struct RexxHost *host, char *command );
char *StrDup( char *s );
void ARexxDispatch( struct RexxHost *host );

/* rxd-Strukturen dürfen nur AM ENDE um lokale Variablen erweitert werden! */

struct rxd_defaults
{
	long rc, rc2;
};

void rx_defaults( struct RexxHost *, struct rxd_defaults **, long, struct RexxMsg * );

struct rxd_lastsaved
{
	long rc, rc2;
};

void rx_lastsaved( struct RexxHost *, struct rxd_lastsaved **, long, struct RexxMsg * );

struct rxd_open
{
	long rc, rc2;
	struct {
		char *filename;
	} arg;
};

void rx_open( struct RexxHost *, struct rxd_open **, long, struct RexxMsg * );

struct rxd_quit
{
	long rc, rc2;
};

void rx_quit( struct RexxHost *, struct rxd_quit **, long, struct RexxMsg * );

struct rxd_restore
{
	long rc, rc2;
};

void rx_restore( struct RexxHost *, struct rxd_restore **, long, struct RexxMsg * );

struct rxd_save
{
	long rc, rc2;
};

void rx_save( struct RexxHost *, struct rxd_save **, long, struct RexxMsg * );

struct rxd_saveas
{
	long rc, rc2;
	struct {
		char *name;
	} arg;
};

void rx_saveas( struct RexxHost *, struct rxd_saveas **, long, struct RexxMsg * );

struct rxd_setattr
{
	long rc, rc2;
	struct {
		char *title;
		char *value;
	} arg;
};

void rx_setattr( struct RexxHost *, struct rxd_setattr **, long, struct RexxMsg * );

struct rxd_use
{
	long rc, rc2;
};

void rx_use( struct RexxHost *, struct rxd_use **, long, struct RexxMsg * );

#endif
