/*
 *   This is an example of how REXX messages might be handled.  This is
 *   a `minimum' example that both accepts asynchronous REXX messages and
 *   can request REXX service.
 *
 *   Read this entire file!  It's short enough.
 *
 *   It is written in such a fashion that it can be attached to a program
 *   with a minimum of fuss.  The only external symbols it makes available
 *   are the seven functions and RxsBase.
 *
 *   This code is by Radical Eye Software, but it is put in the public
 *   domain.  I would appreciate it if the following string was left in
 *   both as a version check and as thanks from you for the use of this
 *   code.
 *
 *   If you modify this file for your own use, don't bump the version
 *   number; add a suffix, such as 1.0a or 1.0.3 or something, so we
 *   don't have fake `versions' floating around.
 */
static char *blurb = "Radical Eye MinRexx 0.4 (Jorrit 1.0)";

#include <exec/types.h>
#include <clib/alib_protos.h>
#include <proto/exec.h>
#include <proto/rexxsyslib.h>
#include <string.h>

struct RexxMsg *CreateRexxMsg();
STRPTR CreateArgstring();

/*
 *   We read in our own personal little include.
 */
#include "minrexx.h"

/*
 *   All of our local globals, hidden from sight.
 */
static struct MsgPort *rexxPort;          /* this is *our* rexx port */
static int bringerdown;                   /* are we trying to shut down? */
static struct rexxCommandList *globalrcl; /* our command association list */
long stillNeedReplies;             			/* how many replies are pending? */
static long rexxPortBit;                  /* what bit to wait on for Rexx? */
static char *extension;                   /* the extension for macros */
static int (*userdisp)();                 /* the user's dispatch function */
static struct RexxMsg *oRexxMsg;          /* the outstanding Rexx message */
/*
 *   Our library base.  Don't you dare close this!
 */
struct Library *RexxSysBase;
struct RxsLib *RxsBase;
/*
 *   This is the main entry point into this code.
 */


long __saveds upRexxPort (char *s, struct rexxCommandList *rcl, char *exten, int (*uf)())
{
/* char *s:
 *
 *   The first argument is the name of your port to be registered;
 *   this will be used, for instance, with the `address' command of ARexx.
 */
/* struct rexxCommandList *rcl:
 *
 *   The second argument is an association list of command-name/user-data
 *   pairs.  It's an array of struct rexxCommandList, terminated by a
 *   structure with a NULL in the name field. The commands are case
 *   sensitive.  The user-data field can contain anything appropriate,
 *   perhaps a function to call or some other data.
 */
/*
 *   The third argument is the file extension for ARexx macros invoked
 *   by this program.  If you supply this argument, any `primitive' not
 *   in the association list rcl will be sent out to ARexx for
 *   interpretation, thus allowing macro programs to work just like
 *   primitives.  If you do not want this behavior, supply a `NULL'
 *   here, and those commands not understood will be replied with an
 *   error value of RXERRORNOCMD.
 */
/* char *exten:
 *
 *   The fourth argument is the user dispatch function.  This function
 *   will *only* be called from rexxDisp(), either from the user calling
 *   this function directly, or from dnRexxPort().  Anytime a command
 *   match is found in the association list, this user-supplied function
 *   will be called with two arguments---the Rexx message that was
 *   received, and a pointer to the association pair.  This function
 *   should return a `1' if the message was replied to by the function
 *   and a `0' if the default success code of (0, 0) should be returned.
 *   Note that the user function should never ReplyMsg() the message;
 *   instead he should indicate the return values with replyRexxCmd();
 *   otherwise we lose track of the messages that still lack replies.
 */
/* int (*uf)():
 *   upRexxPort() returns the signal bit to wait on for Rexx messages.
 *   If something goes wrong, it simply returns a `0'.  Note that this
 *   function is safe to call multiple times because we check to make
 *   sure we haven't opened already.  It's also a quick way to change
 *   the association list or dispatch function.
 */

/*
 *   Some basic error checking.
 */
   if (rcl == NULL || uf == NULL) return (0L);
/*
 *   If we aren't open, we make sure no one else has opened a port with
 *   this name already.  If that works, and the createport succeeds, we
 *   fill rexxPortBit with the value to return.
 *
 *   Note that rexxPortBit will be 0 iff rexxPort is NULL, so the check
 *   for rexxPort == NULL also insures that our rexxPortBit is 0.
 */
	if (!rexxPort) {
		Forbid();
		if (!FindPort (s)) rexxPort = CreatePort (s, 0);
		Permit();
		if (rexxPort) rexxPortBit = 1L << rexxPort->mp_SigBit;
		}
/*
 *   Squirrel away these values for our own internal access, and return
 *   the wait bit.
 */
	globalrcl = rcl;
	extension = exten;
	userdisp = uf;
	return (rexxPortBit);
}

/*
 *   This function closes the rexx library, but only if it is open
 *   and we aren't expecting further replies from REXX.  It's
 *   *private*, but it doesn't have to be; it's pretty safe to
 *   call anytime.
 */
static void closeRexxLib()
{
	if (!stillNeedReplies && RxsBase) {
		CloseLibrary ((struct Library *)RxsBase);
		RxsBase = NULL;
		}
}

/*
 *   This function closes down the Rexx port.  It is always safe to
 *   call, and should *definitely* be made a part of your cleanup
 *   routine.  No arguments and no return.  It removes the Rexx port,
 *   replies to all of the messages and insures that we get replies
 *   to all the ones we sent out, closes the Rexx library, deletes the
 *   port, clears a few flags, and leaves.
 */
void __saveds dnRexxPort()
{
	if (rexxPort) {
		RemPort(rexxPort);
		bringerdown = 1;
/*
 *   A message still hanging around?  We kill it off.
 */
		if (oRexxMsg) {
			oRexxMsg->rm_Result1 = RXERRORIMGONE;
			ReplyMsg ((struct Message *)oRexxMsg);
			oRexxMsg = NULL;
			}
		while (stillNeedReplies) {
			WaitPort(rexxPort);
			dispRexxPort();
			}
		closeRexxLib();
		DeletePort(rexxPort);
		rexxPort = NULL;
		}
	rexxPortBit = 0;
}

/*
 *   Here we dispatch any REXX messages that might be outstanding.
 *   This is the main routine for handling Rexx messages.
 *   This function is fast if no messages are outstanding, so it's
 *   pretty safe to call fairly often.
 *
 *   If we are bring the system down and flushing messages, we reply
 *   with a pretty serious return code RXERRORIMGONE.
 *
 *   No arguments, no returns.
 */
void __saveds dispRexxPort()
{
	struct RexxMsg *RexxMsg;
	int cmdcmp();
	struct rexxCommandList *rcl;
	char *p;
	int dontreply;

/*
 *   If there's no rexx port, we're out of here.
 */
	if (!rexxPort) return;
/*
 *   Otherwise we have our normal loop on messages.
 */
	while (RexxMsg = (struct RexxMsg *)GetMsg(rexxPort)) {
/*
 *   If we have a reply to a message we sent, we look at the second
 *   argument.  If it's set, it's a function we are supposed to call
 *   so we call it.  Then, we kill the argstring and the message
 *   itself, decrement the outstanding count, and attempt to close
 *   down the Rexx library.  Note that this call only succeeds if
 *   there are no outstanding messages.  Also, it's pretty quick, so
 *   don't talk to me about efficiency.
 */
		if (RexxMsg->rm_Node.mn_Node.ln_Type == NT_REPLYMSG) {
			if (RexxMsg->rm_Args[1]) ((int (*)())(RexxMsg->rm_Args[1]))(RexxMsg);
			DeleteArgstring (RexxMsg->rm_Args[0]);
			DeleteRexxMsg (RexxMsg);
			stillNeedReplies--;
			closeRexxLib();
/*
 *   The default case is we got a message and we need to check it for
 *   primitives.  We skip past any initial tabs or spaces and initialize
 *   the return code fields.
 */
			}
		else {
			p = (char *)RexxMsg->rm_Args[0];
			while (*p > 0 && *p <= ' ') p++;
			RexxMsg->rm_Result1 = 0;
			RexxMsg->rm_Result2 = 0;
/*
 *   If somehow the reply is already done or postponed, `dontreply' is
 *   set.
 */
			dontreply = 0;
/*
 *   If the sky is falling, we just blow up and replymsg.
 */
			if (bringerdown) {
				RexxMsg->rm_Result1 = RXERRORIMGONE;
/*
 *   Otherwise we cdr down our association list, comparing commands,
 *   until we get a match.  If we get a match, we call the dispatch
 *   function with the appropriate arguments, and break out.
 */
				}
			else {
					/* Jorrit: optimization. We convert the 'p' pointer to
						lowercase so that the compare function need not do
						any case checking */
				char pp[20];	/* 20 = larger than max command length */
				int i;

				i = 0;
				while (((p[i] >= 'a' && p[i] <= 'z') || (p[i] >= 'A' && p[i] <= 'Z'))
						&& i < 19)
					{
						pp[i] = (p[i] <= 'Z') ? p[i]+32 : p[i];
						i++;
					}
				pp[i] = 0;

				oRexxMsg = RexxMsg;
				for (rcl = globalrcl; rcl->name; rcl++) {
					if (cmdcmp(rcl->name, pp) == 0) {
						userdisp(RexxMsg, rcl, p+strlen(rcl->name));
						break;
						}
					}
/*
 *   If we broke out, rcl will point to the command we executed; if we
 *   are at the end of the list, we didn't understand the command.  In
 *   this case, if we were supplied an extension in upRexxPort, we know
 *   that we should send the command out, so we do so, synchronously.
 *   The synchronous send takes care of our reply.  If we were given a
 *   NULL extension, we bitch that the command didn't make sense to us.
 */
				if (rcl->name == NULL) {
					if (extension) {
						syncRexxCmd(RexxMsg->rm_Args[0], RexxMsg);
						dontreply = 1;
						}
					else RexxMsg->rm_Result1 = RXERRORNOCMD;
					}
				}
/*
 *   Finally, reply if appropriate.
 */
			oRexxMsg = NULL;
			if (!dontreply) ReplyMsg ((struct Message *)RexxMsg);
			}
		}
}

/*
 *   This is the function we use to see if the command matches
 *   the command string.  Not case sensitive, and the real command only
 *   need be a prefix of the command string.  Make sure all commands
 *   are given in lower case!
 *   Jorrit: Removed prefix feature, command must be exactly equal
 */
static int cmdcmp (char *c, char *m)
{
	while (*c && *c == *m) {
		c++;
		m++;
		}
	return (*c || *m);
}

/*
 *   Opens the Rexx library if unopened.  Returns success (1) or
 *   failure (0).  This is another function that is *private* but
 *   that doesn't have to be.
 */
static int openRexxLib()
{
	if (RxsBase) return (1);
	return ((RexxSysBase = RxsBase = (struct RxsLib *)OpenLibrary (RXSNAME, 0)) != NULL);
}

/*
 *   This is the general ARexx command interface, but is not the one
 *   you will use most of the time; ones defined later are easier to
 *   understand and use.  But they all go through here.
 */
struct RexxMsg * __saveds sendRexxCmd (char *s, int (*f)(), char *p1, char *p2, char *p3)
/* char *s:
 *
 *   The first parameter is the command to send to Rexx.
 */
/* int (*f)():
 *
 *   The second parameter is either NULL, indicating that the command
 *   should execute asynchronously, or a function to be called when the
 *   message we build up and send out here finally returns.  Please note
 *   that the function supplied here could be called during cleanup after
 *   a fatal error, so make sure it is `safe'.  This function always is
 *   passed one argument, the RexxMsg that is being replied.
 */
/* char *p1, p2, p3:
 *
 *   These are up to three arguments to be stuffed into the RexxMsg we
 *   are building up, making the values available when the message is
 *   finally replied to.  The values are stuffed into Args[2]..Args[4].
 */
{
	struct MsgPort *rexxport;
	struct RexxMsg *RexxMsg;

/*
 *   If we have too many replies out there, we just return failure.
 *   Note that you should check the return code to make sure your
 *   message got out!  Then, we forbid, and make sure that:
 *      - we have a rexx port open
 *      - Rexx is out there
 *      - the library is open
 *      - we can create a message
 *      - we can create an argstring
 *
 *   If all of these succeed, we stuff a few values and send the
 *   message, permit, and return.
 */
	if (!rexxPort || stillNeedReplies > MAXRXOUTSTANDING-1) return (NULL);
	RexxMsg = NULL;
	if (openRexxLib() && (RexxMsg =
				CreateRexxMsg (rexxPort, extension, rexxPort->mp_Node.ln_Name)) &&
					(RexxMsg->rm_Args[0] = CreateArgstring (s, (long)strlen(s)))) {
		RexxMsg->rm_Action = RXCOMM;
		RexxMsg->rm_Args[1] = (STRPTR)f;
		RexxMsg->rm_Args[2] = p1;
		RexxMsg->rm_Args[3] = p2;
		RexxMsg->rm_Args[4] = p3;
		RexxMsg->rm_Node.mn_Node.ln_Name = RXSDIR;
		Forbid();
		if (rexxport = FindPort (RXSDIR))
			PutMsg (rexxport, (struct Message *)RexxMsg);
		Permit();
		if (rexxport) {
			stillNeedReplies++;
			return(RexxMsg);
			}
		else DeleteArgstring(RexxMsg->rm_Args[0]);
		}
	if (RexxMsg) DeleteRexxMsg(RexxMsg);
	closeRexxLib();
	return(NULL);
}
/*
 *   This function is used to send out an ARexx message and return
 *   immediately.  Its single parameter is the command to send.
 */
struct RexxMsg * __saveds asyncRexxCmd (char *s)
{
	return (sendRexxCmd (s, NULL, NULL, NULL, NULL));
}

/*
 *   This function sets things up to reply to the message that caused
 *   it when we get a reply to the message we are sending out here.
 *   But first the function we pass in, which actually handles the reply.
 *   Note how we get the message from the Args[2]; Args[0] is the command,
 *   Args[1] is this function, and Args[2]..Args[4] are any parameters
 *   passed to sendRexxCmd() as p1..p3.  We pass the result codes right
 *   along.
 */
static void replytoit (struct RexxMsg *msg)
{
	struct RexxMsg *omsg;

	omsg = (struct RexxMsg *)(msg->rm_Args[2]);
	replyRexxCmd (omsg, msg->rm_Result1, msg->rm_Result2, 0);
	ReplyMsg ((struct Message *)omsg);
}

/*
 *   This function makes use of everything we've put together so far,
 *   and functions as a synchronous Rexx call; as soon as the macro
 *   invoked here returns, we reply to `msg', passing the return codes
 *   back.
 */
struct RexxMsg * __saveds syncRexxCmd (char *s, struct RexxMsg *msg)
{
	return (sendRexxCmd (s, (APTR)&replytoit, (char *)msg, NULL, NULL));
}

/*
 *   There are times when you want to pass back return codes or a
 *   return string; call this function when you want to do that,
 *   and return `1' from the user dispatch function so the main
 *   event loop doesn't reply (because we reply here.)  This function
 *   always returns 1.
 */
int __saveds replyRexxCmd (struct RexxMsg *msg, long primary, long secondary, char *str)
/* struct RexxMsg *msg:
 *   The first parameter is the message we are replying to.
 */
/* long primary, secondary:
 *
 *   The next two parameters are the primary and secondary return
 *   codes.
 */
/* char *str:
 *   The final parameter is a return string.  This string is only
 *   returned if the primary return code is 0, and a string was
 *   requested.
 *
 *   We also note that we have replied to the message that came in.
 */
{
/*
 *   Note how we make sure the Rexx Library is open before calling
 *   CreateArgstring . . . and we close it down at the end, if possible.
 */
	if (primary == 0 && (msg->rm_Action & (1L << RXFB_RESULT))) {
		if (str && openRexxLib())
			secondary = (long)CreateArgstring (str, (long)strlen (str));
		else secondary = 0L;
		}
	msg->rm_Result1 = primary;
	msg->rm_Result2 = secondary;
	closeRexxLib();
	return 1;
}


/*** Jorrit Tyberghein ***/
struct RexxMsg * Clip (char *clipname, APTR data, ULONG len, int comm)
{
	struct MsgPort *rexxport;
	struct RexxMsg *RexxMsg;

	if (!rexxPort || stillNeedReplies > MAXRXOUTSTANDING-1) return (NULL);
	RexxMsg = NULL;
	if (openRexxLib () && (RexxMsg =
			CreateRexxMsg (rexxPort,extension,rexxPort->mp_Node.ln_Name)) &&
			(RexxMsg->rm_Args[0] = CreateArgstring (clipname,(long)strlen (clipname))))
		{
			RexxMsg->rm_Action = comm | RXFF_NONRET;
			RexxMsg->rm_Args[1] = (STRPTR)data;
			RexxMsg->rm_Args[2] = (STRPTR)len;
			RexxMsg->rm_Node.mn_Node.ln_Name = RXSDIR;

			Forbid();
			if (rexxport = FindPort (RXSDIR))
				PutMsg (rexxport,(struct Message *)RexxMsg);
			Permit();

			if (rexxport) return (RexxMsg);
			else DeleteArgstring (RexxMsg->rm_Args[0]);
		}
	if (RexxMsg) DeleteRexxMsg (RexxMsg);
	closeRexxLib ();
	return (NULL);
}

/*** Jorrit Tyberghein ***/
struct RexxMsg * __saveds SetClip (char *clipname, APTR data, ULONG len)
{
	return (Clip (clipname,data,len,RXADDCON));
}

/*** Jorrit Tyberghein ***/
struct RexxMsg * __saveds RemClip (char *clipname)
{
	return (Clip (clipname,NULL,0,RXREMCON));
}

/*** Jorrit Tyberghein ***/
int __saveds GetClip (char *clipname, APTR *data)
{
	struct RexxRsrc *clip;

	clip = NULL;
	if (openRexxLib ())
		{
			LockRexxBase (0);
			clip = (struct RexxRsrc *) FindName (&(RxsBase->rl_ClipList),clipname);
			if (clip) *data = (APTR)(clip->rr_Arg1);
			UnlockRexxBase (0);
		}
	closeRexxLib ();
	return ((int)clip);
}
