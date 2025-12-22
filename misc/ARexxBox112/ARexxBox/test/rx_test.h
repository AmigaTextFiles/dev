/*
 * Source generated with ARexxBox 1.12 (May 18 1993)
 * which is Copyright (c) 1992,1993 Michael Balzer
 */

#ifndef _rx_test_H
#define _rx_test_H

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

struct rxd_inout
{
	long rc, rc2;
	struct {
		char *var, *stem;
		long *arg1;
	} arg;
	struct {
		char *res1;
	} res;
};

void rx_inout( struct RexxHost *, struct rxd_inout **, long, struct RexxMsg * );

struct rxd_multi_in_num
{
	long rc, rc2;
	struct {
		long **liste;
	} arg;
};

void rx_multi_in_num( struct RexxHost *, struct rxd_multi_in_num **, long, struct RexxMsg * );

struct rxd_multi_in_str
{
	long rc, rc2;
	struct {
		char **liste;
	} arg;
};

void rx_multi_in_str( struct RexxHost *, struct rxd_multi_in_str **, long, struct RexxMsg * );

struct rxd_multi_out_num
{
	long rc, rc2;
	struct {
		char *var, *stem;
	} arg;
	struct {
		long **liste;
	} res;
};

void rx_multi_out_num( struct RexxHost *, struct rxd_multi_out_num **, long, struct RexxMsg * );

struct rxd_multi_out_str
{
	long rc, rc2;
	struct {
		char *var, *stem;
	} arg;
	struct {
		char **liste;
	} res;
};

void rx_multi_out_str( struct RexxHost *, struct rxd_multi_out_str **, long, struct RexxMsg * );

struct rxd_open
{
	long rc, rc2;
	struct {
		char *file;
		long prompt;
	} arg;
};

void rx_open( struct RexxHost *, struct rxd_open **, long, struct RexxMsg * );

#endif
