*
*   Includes for PowerVisor pv_arexx.asm
*

*
*   This is the list of functions we can access.  (Cheap forward
*   declarations, too.)
*

	XREF		_upRexxPort,_dnRexxPort,_dispRexxPort,_sendRexxCmd,_syncRexxCmd
	XREF		_asyncRexxCmd,_replyRexxCmd
	XREF		_SetClip,_RemClip,_GetClip

* long upRexxPort (char *, struct rexxCommandList *, char *, int (*)());
* void dnRexxPort();
* void dispRexxPort();
* struct RexxMsg *sendRexxCmd (char *, int (*)(), char *, char *, char *);
* struct RexxMsg *syncRexxCmd (char *, struct RexxMsg *);
* struct RexxMsg *asyncRexxCmd (char *);
* void replyRexxCmd (struct RexxMsg *, long, long, char *);
* struct RexxMsg *SetClip (char *clipname, APTR data, ULONG len);
* struct RexxMsg *RemClip (char *clipname);
* int GetClip (char *clipname, APTR *data);

*
*   Maximum messages that can be pending, and the return codes
*   for two bad situations.
*
MAXRXOUTSTANDING		equ	300
RXERRORIMGONE			equ	100
RXERRORNOCMD			equ	30

*
*   This is the association list you build up (statically or
*   dynamically) that should be terminated with an entry with
*   NULL for the name . . .
*
 STRUCTURE	rexxCommandList,0
		APTR	rcl_name
		LONG	rcl_usertype
		APTR	rcl_userdata
		LABEL	rcl_SIZE
