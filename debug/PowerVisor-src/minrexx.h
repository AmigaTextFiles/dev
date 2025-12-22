/*
 *   Includes for minrexx.c; please refer to that file for
 *   further documentation.
 */
#include <rexx/rxslib.h>

/*
 *   This is the list of functions we can access.  (Cheap forward
 *   declarations, too.)
 */
long __saveds upRexxPort (char *, struct rexxCommandList *, char *, int (*)());
void __saveds dnRexxPort();
void __saveds dispRexxPort();
struct RexxMsg * __saveds sendRexxCmd (char *, int (*)(), char *, char *, char *);
struct RexxMsg * __saveds syncRexxCmd (char *, struct RexxMsg *);
struct RexxMsg * __saveds asyncRexxCmd (char *);
int __saveds replyRexxCmd (struct RexxMsg *, long, long, char *);

/*
 *   Maximum messages that can be pending, and the return codes
 *   for two bad situations.
 */
#define MAXRXOUTSTANDING (300)
#define RXERRORIMGONE (100)
#define RXERRORNOCMD (30)

/*
 *   This is the association list you build up (statically or
 *   dynamically) that should be terminated with an entry with
 *   NULL for the name . . .
 */
struct rexxCommandList {
   char *name;
	long usertype;
   APTR userdata;
};
