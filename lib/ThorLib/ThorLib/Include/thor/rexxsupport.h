/*************************************************************************
 ** THOR.lib                                                            **
 ** Version 1.00  6th December 1995     © 1995 THOR-Software inc        **
 **                                                                     **
 **---------------------------------------------------------------------**
 **                                                                     **
 ** Serviceprocedures for rexx                                          **
 **                                                                     **
 *************************************************************************/

#ifndef REXXSUPPORT_H
#define REXXSUPPORT_H

#ifndef FIXED_H
#include <thor/fixed.h>
#endif

#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif

#ifndef EXEC_PORTS_H
#include <exec/ports.h>
#endif

#define RXF_REXXRETURN  -3      /* a returned command, don't forget to call EndRexx to close the IO-buffers */
#define RXF_PUSHEDBACK  -2      /* set if we don't want a reply, pushed msg back */

typedef char RexxArg;           /* cause we don't know better */
typedef LONG FailCode;          /* what is an error code */

/* A procedure that parses incoming requests, to be set by the user as argument to ParseRexxMsg */
typedef FailCode __asm (*RexxParser)(register __a0 char **argv,register __d0 int argc,register __a1 struct Message *rexxmsg);

/* Open & close the rexx enviroment, return port-ptr or NULL */
struct MsgPort __asm *OpenRexx(void);
void __asm CloseRexx(void);

/* service-procedures for rexx-arguments... you won't need them */
RexxArg __asm *AllocRexxArg(register __a0 char *);
void __asm FreeRexxArg(register __a0 RexxArg *);

/* set the return-value of a rexx-msg. This is properly ignored if no return is wanted */
FailCode __asm SetRexxResult(register __a0 char *result,register __a1 struct Message *rexxmsg);

/* check if message comes from rexx, return TRUE if so */
BOOL __asm CheckMessage(register __a0 struct Message *msg);

/* get value of rexx-variable in ASCII or - according to rexx - its name if undefined */
FailCode __asm EvaluateRexxVar(register __a0 char *variable,register __a1 char *result,register __a2 struct Message *rexxmsg);
/* set the contents of a rexx-variable, might be a stem variable as well */
FailCode __asm SetRexxVar(register __a0 char *variable,register __a1 struct Message *rexxmsg,register __a2 char *content);

/* run a rexx script in background. note that rexx can't handle spaces in the file name (arggh!) */
struct Message __asm *RunRexx(register __a0 char *scriptname);

/* parse an incomming msg. Might return an error code or RXF_REXXRETURN if this a returned querry of
   your own. In this case, call EndRexx to free the IOHandles and to get its return-code.
   Otherwise, your parser will be called.
   The message is afterwards still valid and needs to be replied with
   ReplyRexx, except:
   i)   the returncode is RXF_REXXRETURN, in which case you should call EndRexx to free
        the message and the IO-channels
   ii)  the returncode is RXF_PUSHEDBACK, to reply it later on. It is up to you when to
        do this */
FailCode __asm ParseRexxMsg(register __a0 RexxParser,register __a1 struct Message *rexxmsg);

/* Set the returncode of a message, overridden by ReplyRexx. Use this if you MUST use
   ReplyMsg */
void __asm SetReturnCode(register __d0 LONG ret,register __a0 struct Message *rexxmsg);
/* Same, but sets the secondary return code */
void __asm SetReturn2Code(register __d0 LONG ret,register __a0 struct Message *rexxmsg);

/* Reply a rexx-message, set the returncode */
void __asm ReplyRexxMsg(register __a0 struct Message *rexxmsg,register __d0 FailCode retvalue);

/* Call this if a request to rexx returns */
FailCode __asm EndRexx(register __a0 struct Message *rexxmsg);

extern char *PortName;          /* Set to the name of your port, should contain a name like
                                   "MYPROG.". Don't forget the dot as separator between name and
                                   counting number */
extern char *RXExtension;       /* Set to extension of rexx-scripts */
extern struct MsgPort *RexxPort; /* this is set by the startup-code to Rexx-Port */
extern UWORD RexxCount;         /* Counts numbers of outstanding rexx-requests. Don't exit until this
                                   gets zero */

/* Tiny service procedures to set a rexx-variable to int,string,double,lixed */
void __regargs SetValueStemI(char *stem,char *ext,struct Message *rexxmsg,int value);
void __regargs SetValueStemD(char *stem,char *ext,struct Message *rexxmsg,double value);
void __regargs SetValueStemL(char *stem,char *ext,struct Message *rexxmsg,Lixed value);
void __regargs SetValueStemS(char *stem,char *ext,struct Message *rexxmsg,char *value);

/* Tiny service procedures to get the contents of a rexx-variable and interpret it as
   int,string,double,lixed and BOOL */
FailCode __regargs GetValueStemI(char *stem,char *ext,struct Message *msg,int *to);
FailCode __regargs GetValueStemD(char *stem,char *ext,struct Message *msg,double *to);
FailCode __regargs GetValueStemL(char *stem,char *ext,struct Message *msg,Lixed *to);
FailCode __regargs GetValueStemS(char *stem,char *ext,struct Message *msg,char *to);
FailCode __regargs GetValueStemB(char *stem,char *ext,struct Message *msg,BOOL *to);

/* Get standard name of rexx-error */
char __regargs *FailText(FailCode fail);

#endif

