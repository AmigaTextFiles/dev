/*
 * Source generated with ARexxBox 1.12 (May 18 1993)
 * which is Copyright (c) 1992,1993 Michael Balzer
 */

#ifndef _rx_test2_H
#define _rx_test2_H

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

void DoShellCommand( struct RexxHost *host, char *comline, BPTR fhout );
void CommandShell( struct RexxHost *host, BPTR fhin, BPTR fhout, char *prompt );

/* rxd-Strukturen dürfen nur AM ENDE um lokale Variablen erweitert werden! */

struct rxd_alias
{
	long rc, rc2;
	struct {
		long global;
		char *name;
		char *command;
	} arg;
};

void rx_alias( struct RexxHost *, struct rxd_alias **, long, struct RexxMsg * );

struct rxd_cmdshell
{
	long rc, rc2;
	struct {
		long open;
		long close;
	} arg;
};

void rx_cmdshell( struct RexxHost *, struct rxd_cmdshell **, long, struct RexxMsg * );

struct rxd_disable
{
	long rc, rc2;
	struct {
		long global;
		char **names;
	} arg;
};

void rx_disable( struct RexxHost *, struct rxd_disable **, long, struct RexxMsg * );

struct rxd_enable
{
	long rc, rc2;
	struct {
		long global;
		char **names;
	} arg;
};

void rx_enable( struct RexxHost *, struct rxd_enable **, long, struct RexxMsg * );

struct rxd_fault
{
	long rc, rc2;
	struct {
		char *var, *stem;
		long *number;
	} arg;
	struct {
		char *description;
	} res;
};

void rx_fault( struct RexxHost *, struct rxd_fault **, long, struct RexxMsg * );

struct rxd_help
{
	long rc, rc2;
	struct {
		char *var, *stem;
		char *command;
		long prompt;
	} arg;
	struct {
		char *commanddesc;
		char **commandlist;
	} res;
};

void rx_help( struct RexxHost *, struct rxd_help **, long, struct RexxMsg * );

struct rxd_rx
{
	long rc, rc2;
	struct {
		char *var, *stem;
		long console;
		long async;
		char *command;
	} arg;
	struct {
		long *rc;
		char *result;
	} res;
};

void rx_rx( struct RexxHost *, struct rxd_rx **, long, struct RexxMsg * );

#endif
