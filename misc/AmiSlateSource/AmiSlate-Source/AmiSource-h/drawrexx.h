/*
 * Source generated with ARexxBox 1.12 (May 18 1993)
 * which is Copyright (c) 1992,1993 Michael Balzer
 */

#ifndef _drawrexx_H
#define _drawrexx_H

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

struct rxd_breakarexxscripts
{
	long rc, rc2;
};

void rx_breakarexxscripts( struct RexxHost *, struct rxd_breakarexxscripts **, long, struct RexxMsg * );

struct rxd_circle
{
	long rc, rc2;
	struct {
		long *x;
		long *y;
		long *rx;
		long *ry;
		long fill;
		long xor;
	} arg;
};

void rx_circle( struct RexxHost *, struct rxd_circle **, long, struct RexxMsg * );

struct rxd_clear
{
	long rc, rc2;
	struct {
		long xor;
	} arg;
};

void rx_clear( struct RexxHost *, struct rxd_clear **, long, struct RexxMsg * );

struct rxd_connect
{
	long rc, rc2;
	struct {
		char *hostname;
	} arg;
};

void rx_connect( struct RexxHost *, struct rxd_connect **, long, struct RexxMsg * );

struct rxd_disconnect
{
	long rc, rc2;
};

void rx_disconnect( struct RexxHost *, struct rxd_disconnect **, long, struct RexxMsg * );

struct rxd_displaybeep
{
	long rc, rc2;
	struct {
		long local;
		long remote;
	} arg;
};

void rx_displaybeep( struct RexxHost *, struct rxd_displaybeep **, long, struct RexxMsg * );

struct rxd_easyrequest
{
	long rc, rc2;
	struct {
		char *title;
		char *message;
		char *gadgets;
	} arg;
};

void rx_easyrequest( struct RexxHost *, struct rxd_easyrequest **, long, struct RexxMsg * );

struct rxd_filerequest
{
	long rc, rc2;
	struct {
		char *var, *stem;
		char *title;
		char *dir;
		char *file;
		char *oktext;
		long save;
	} arg;
	struct {
		char *file;
	} res;
};

void rx_filerequest( struct RexxHost *, struct rxd_filerequest **, long, struct RexxMsg * );

struct rxd_flood
{
	long rc, rc2;
	struct {
		long *x;
		long *y;
		long unsafe;
	} arg;
};

void rx_flood( struct RexxHost *, struct rxd_flood **, long, struct RexxMsg * );

struct rxd_getpixel
{
	long rc, rc2;
	struct {
		long *x;
		long *y;
	} arg;
};

void rx_getpixel( struct RexxHost *, struct rxd_getpixel **, long, struct RexxMsg * );

struct rxd_getremotestateattrs
{
	long rc, rc2;
	struct {
		char *var, *stem;
	} arg;
	struct {
		long *mode;
		long *fpen;
		long *bpen;
		long *fred;
		long *fgreen;
		long *fblue;
		long *bred;
		long *bgreen;
		long *bblue;
	} res;
};

void rx_getremotestateattrs( struct RexxHost *, struct rxd_getremotestateattrs **, long, struct RexxMsg * );

struct rxd_getstateattrs
{
	long rc, rc2;
	struct {
		char *var, *stem;
	} arg;
	struct {
		long *mode;
		long *fpen;
		long *bpen;
		long *fred;
		long *fgreen;
		long *fblue;
		long *bred;
		long *bgreen;
		long *bblue;
		long *pendown;
		long *locked;
		long *lockedpalettes;
	} res;
};

void rx_getstateattrs( struct RexxHost *, struct rxd_getstateattrs **, long, struct RexxMsg * );

struct rxd_getversion
{
	long rc, rc2;
	struct {
		char *var, *stem;
	} arg;
	struct {
		char *version;
	} res;
};

void rx_getversion( struct RexxHost *, struct rxd_getversion **, long, struct RexxMsg * );

struct rxd_getwindowattrs
{
	long rc, rc2;
	struct {
		char *var, *stem;
	} arg;
	struct {
		long *top;
		long *left;
		long *width;
		long *height;
		long *depth;
		long *maxwidth;
		long *maxheight;
	} res;
};

void rx_getwindowattrs( struct RexxHost *, struct rxd_getwindowattrs **, long, struct RexxMsg * );

struct rxd_line
{
	long rc, rc2;
	struct {
		long *x1;
		long *y1;
		long *x2;
		long *y2;
		long xor;
	} arg;
};

void rx_line( struct RexxHost *, struct rxd_line **, long, struct RexxMsg * );

struct rxd_loadiff
{
	long rc, rc2;
	struct {
		char *file;
		long expand;
		long loadpalette;
		long protectgui;
	} arg;
};

void rx_loadiff( struct RexxHost *, struct rxd_loadiff **, long, struct RexxMsg * );

struct rxd_lock
{
	long rc, rc2;
	struct {
		char *var, *stem;
		long on;
		long off;
	} arg;
	struct {
		long *state;
	} res;
};

void rx_lock( struct RexxHost *, struct rxd_lock **, long, struct RexxMsg * );

struct rxd_lockpalette
{
	long rc, rc2;
	struct {
		char *var, *stem;
		long on;
		long off;
	} arg;
	struct {
		long *state;
	} res;
};

void rx_lockpalette( struct RexxHost *, struct rxd_lockpalette **, long, struct RexxMsg * );

struct rxd_pen
{
	long rc, rc2;
	struct {
		long *x;
		long *y;
		long xor;
	} arg;
};

void rx_pen( struct RexxHost *, struct rxd_pen **, long, struct RexxMsg * );

struct rxd_penreset
{
	long rc, rc2;
};

void rx_penreset( struct RexxHost *, struct rxd_penreset **, long, struct RexxMsg * );

struct rxd_playscript
{
	long rc, rc2;
	struct {
		char *file;
	} arg;
};

void rx_playscript( struct RexxHost *, struct rxd_playscript **, long, struct RexxMsg * );

struct rxd_point
{
	long rc, rc2;
	struct {
		long *x;
		long *y;
		long xor;
	} arg;
};

void rx_point( struct RexxHost *, struct rxd_point **, long, struct RexxMsg * );

struct rxd_putrasterpixels
{
	long rc, rc2;
	struct {
		long *length;
		long *red;
		long *green;
		long *blue;
		long *pen;
	} arg;
};

void rx_putrasterpixels( struct RexxHost *, struct rxd_putrasterpixels **, long, struct RexxMsg * );

struct rxd_quit
{
	long rc, rc2;
	struct {
		long force;
	} arg;
};

void rx_quit( struct RexxHost *, struct rxd_quit **, long, struct RexxMsg * );

struct rxd_recordscript
{
	long rc, rc2;
	struct {
		char *file;
		long force;
		long start;
		long stop;
	} arg;
};

void rx_recordscript( struct RexxHost *, struct rxd_recordscript **, long, struct RexxMsg * );

struct rxd_remoteeasyrequest
{
	long rc, rc2;
	struct {
		char *title;
		char *message;
		char *gadgets;
	} arg;
};

void rx_remoteeasyrequest( struct RexxHost *, struct rxd_remoteeasyrequest **, long, struct RexxMsg * );

struct rxd_remoterexxcommand
{
	long rc, rc2;
	struct {
		char *message;
		char *file;
	} arg;
};

void rx_remoterexxcommand( struct RexxHost *, struct rxd_remoterexxcommand **, long, struct RexxMsg * );

struct rxd_remotestringrequest
{
	long rc, rc2;
	struct {
		char *title;
		char *defaultstring;
		char *message;
	} arg;
};

void rx_remotestringrequest( struct RexxHost *, struct rxd_remotestringrequest **, long, struct RexxMsg * );

struct rxd_saveiff
{
	long rc, rc2;
	struct {
		char *file;
	} arg;
};

void rx_saveiff( struct RexxHost *, struct rxd_saveiff **, long, struct RexxMsg * );

struct rxd_sendmessage
{
	long rc, rc2;
	struct {
		char *message;
	} arg;
};

void rx_sendmessage( struct RexxHost *, struct rxd_sendmessage **, long, struct RexxMsg * );

struct rxd_setbcolor
{
	long rc, rc2;
	struct {
		long *red;
		long *green;
		long *blue;
		long notbackground;
	} arg;
};

void rx_setbcolor( struct RexxHost *, struct rxd_setbcolor **, long, struct RexxMsg * );

struct rxd_setbpen
{
	long rc, rc2;
	struct {
		long *pen;
	} arg;
};

void rx_setbpen( struct RexxHost *, struct rxd_setbpen **, long, struct RexxMsg * );

struct rxd_setfcolor
{
	long rc, rc2;
	struct {
		long *red;
		long *green;
		long *blue;
		long notbackground;
	} arg;
};

void rx_setfcolor( struct RexxHost *, struct rxd_setfcolor **, long, struct RexxMsg * );

struct rxd_setfpen
{
	long rc, rc2;
	struct {
		long *pen;
	} arg;
};

void rx_setfpen( struct RexxHost *, struct rxd_setfpen **, long, struct RexxMsg * );

struct rxd_setraster
{
	long rc, rc2;
	struct {
		long *x;
		long *y;
		long *width;
		long *height;
		long *offset;
	} arg;
};

void rx_setraster( struct RexxHost *, struct rxd_setraster **, long, struct RexxMsg * );

struct rxd_setremotewindowtitle
{
	long rc, rc2;
	struct {
		char *message;
	} arg;
};

void rx_setremotewindowtitle( struct RexxHost *, struct rxd_setremotewindowtitle **, long, struct RexxMsg * );

struct rxd_settoolbehavior
{
	long rc, rc2;
	struct {
		long *tool;
		long *mode;
		char *pragma1;
		char *pragma2;
	} arg;
};

void rx_settoolbehavior( struct RexxHost *, struct rxd_settoolbehavior **, long, struct RexxMsg * );

struct rxd_setuserbcolor
{
	long rc, rc2;
	struct {
		long *red;
		long *green;
		long *blue;
		long notbackground;
	} arg;
};

void rx_setuserbcolor( struct RexxHost *, struct rxd_setuserbcolor **, long, struct RexxMsg * );

struct rxd_setuserbpen
{
	long rc, rc2;
	struct {
		long *pen;
		long notbackground;
	} arg;
};

void rx_setuserbpen( struct RexxHost *, struct rxd_setuserbpen **, long, struct RexxMsg * );

struct rxd_setuserfcolor
{
	long rc, rc2;
	struct {
		long *red;
		long *green;
		long *blue;
		long notbackground;
	} arg;
};

void rx_setuserfcolor( struct RexxHost *, struct rxd_setuserfcolor **, long, struct RexxMsg * );

struct rxd_setuserfpen
{
	long rc, rc2;
	struct {
		long *pen;
		long notbackground;
	} arg;
};

void rx_setuserfpen( struct RexxHost *, struct rxd_setuserfpen **, long, struct RexxMsg * );

struct rxd_setusertool
{
	long rc, rc2;
	struct {
		long *tool;
	} arg;
};

void rx_setusertool( struct RexxHost *, struct rxd_setusertool **, long, struct RexxMsg * );

struct rxd_setwindowtitle
{
	long rc, rc2;
	struct {
		char *message;
	} arg;
};

void rx_setwindowtitle( struct RexxHost *, struct rxd_setwindowtitle **, long, struct RexxMsg * );

struct rxd_sizewindow
{
	long rc, rc2;
	struct {
		char *var, *stem;
		long *top;
		long *left;
		long *width;
		long *height;
	} arg;
	struct {
		long *exact;
		long *top;
		long *left;
		long *width;
		long *height;
	} res;
};

void rx_sizewindow( struct RexxHost *, struct rxd_sizewindow **, long, struct RexxMsg * );

struct rxd_square
{
	long rc, rc2;
	struct {
		long *x1;
		long *y1;
		long *x2;
		long *y2;
		long fill;
		long xor;
	} arg;
};

void rx_square( struct RexxHost *, struct rxd_square **, long, struct RexxMsg * );

struct rxd_stringrequest
{
	long rc, rc2;
	struct {
		char *var, *stem;
		char *title;
		char *defaultstring;
		char *message;
	} arg;
	struct {
		char *message;
	} res;
};

void rx_stringrequest( struct RexxHost *, struct rxd_stringrequest **, long, struct RexxMsg * );

struct rxd_typekeys
{
	long rc, rc2;
	struct {
		char *message;
	} arg;
};

void rx_typekeys( struct RexxHost *, struct rxd_typekeys **, long, struct RexxMsg * );

struct rxd_waitevent
{
	long rc, rc2;
	struct {
		char *var, *stem;
		long *timeout;
		long message;
		long click;
		long resize;
		long quit;
		long connect;
		long disconnect;
		long toolselect;
		long colorselect;
		long keypress;
		long mousedown;
		long mouseup;
		long mousemove;
	} arg;
	struct {
		long *type;
		long *x;
		long *y;
		char *message;
		long *code1;
		long *code2;
		long *mousex;
		long *mousey;
		long *button;
		long *lastkey;
	} res;
};

void rx_waitevent( struct RexxHost *, struct rxd_waitevent **, long, struct RexxMsg * );

#endif
