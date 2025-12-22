/*
 * cmdline.c  V3.1
 *
 * ToolManager library command line builder
 *
 * Copyright (C) 1990-98 Stefan Becker
 *
 * This source code is for educational purposes only. You may study it
 * and copy ideas or algorithms from it for your own projects. It is
 * not allowed to use any of the source codes (in full or in parts)
 * in other programs. Especially it is not allowed to create variants
 * of ToolManager or ToolManager-like programs from this source code.
 *
 */

#include "toolmanager.h"

struct Parameter {
 struct Parameter *p_Next;
 ULONG             p_Length;
 char              p_Data[1];
 /* Rest of string follows here */
};
#define BUFLEN 256

/* Convert WB Args */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION ConvertWBArgs
static struct Parameter *ConvertWBArgs(struct AppMessage *msg, BPTR curdir)
{
 struct Parameter  anchor = { NULL };
 char             *buf;

 CMDLINE_LOG(LOG2(WBArgs, "Num %ld List 0x%08lx",
             msg->am_NumArgs, msg->am_ArgList))

 /* Allocate conversion buffer */
 if (buf = GetMemory(BUFLEN)) {
  struct Parameter *p  = &anchor;
  struct WBArg     *wa;
  ULONG             i;

  CMDLINE_LOG(LOG1(Buf, "0x%08lx", buf))

  /* Scan WBArgs list */
  for (i = msg->am_NumArgs, wa = msg->am_ArgList; i > 0; i--, wa++) {

   CMDLINE_LOG(LOG3(Next WBArg, "Lock 0x%08lx Name '%s' (0x%08lx)",
                    wa->wa_Lock, wa->wa_Name, wa->wa_Name))

   /* Valid lock? */
   if (wa->wa_Lock) {
    char  *name;
    char  *space;
    ULONG  length;

    /* File or Drawer? */
    if (*(wa->wa_Name) != '\0') {

     CMDLINE_LOG(LOG0(File))

     /* File. In the same directory as the program? */
     if (SameLock(curdir, wa->wa_Lock) == LOCK_SAME) {

      /* Yes, just copy name */
      name = wa->wa_Name;

     } else {

      /* No, build full pathname */
      if ((NameFromLock(wa->wa_Lock, buf, BUFLEN) == 0) ||
          (AddPart(buf, wa->wa_Name, BUFLEN) == 0))

       /* Couldn't build path name */
       continue;

      /* Name is in conversion buffer */
      name = buf;
     }

    } else {

     CMDLINE_LOG(LOG0(Drawer))

     /* Drawer, convert lock to name */
     if (NameFromLock(wa->wa_Lock, buf, BUFLEN) == FALSE) continue;

     /* Name is in conversion buffer */
     name = buf;
    }

    /* Get parameter length plus seperator */
    length = strlen(name) + 1;

    /* Handle special case: space in name -> Quotes must be added */
    if (space = strchr(name, ' ')) length += 2;

    CMDLINE_LOG(LOG3(Next Parameter, "'%s' (%ld) Alloc %ld",
                     name, length - 1, sizeof(struct Parameter) + length))

    /* Allocate memory for parameter */
    if (p->p_Next = GetVector(sizeof(struct Parameter) + length)) {
     char *s;

     /* Initialize pointers */
     p = p->p_Next;
     s = p->p_Data;

     /* Initialize structure */
     p->p_Next   = NULL;
     p->p_Length = length;

     /* Build parameter: Seperator, (Quote), Name, (Quote) */
     *s++ = ' ';
     if (space) *s++ = '\"';
     strcpy(s, name);
     if (space) {
      s    += length - 3;
      *s++ =  '\"';
      *s   =  '\0';
     }
    }
   }
  }

  /* Free conversion buffer */
  FreeMemory(buf, BUFLEN);
 }

 /* Return pointer to first parameter */
 return(anchor.p_Next);
}

/* Build a command line from command and WB arguments */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION BuildCommandLine
char *BuildCommandLine(const char *cmd, struct AppMessage *msg, BPTR curdir,
                       ULONG *cmdlen)
{
 ULONG             length = 0;
 struct Parameter *params = NULL;
 char             *subst  = cmd;
 char             *rc     = NULL;

 CMDLINE_LOG(LOG3(Arguments, "Cmd '%s' Msg 0x%08lx CD 0x%08lx",
                  cmd, msg, curdir))

 /* Build command parameter from WBArgs (if any) */
 if (msg && msg->am_NumArgs && (params = ConvertWBArgs(msg, curdir))) {
  struct Parameter *p = params;

  /* Calculate command line length */
  do {

   /* Add parameter length */
   length += p->p_Length;

   /* Next parameter */
  } while (p = p->p_Next);

  CMDLINE_LOG(LOG1(Param Length, "%ld", length))
 }

 /* Add command name length to total length */
 length += strlen(cmd);

 /* Scan command string for [] parameter place holder */
 while (subst = strchr(subst, '['))

  /* Place holder found? */
  if (subst[1] == ']') {

   /* Yes, correct command line length */
   length -= 2;

   /* Leave loop */
   break;

  } else

   /* No, scan for next occurence */
   subst++;

 CMDLINE_LOG(LOG2(CmdLine, "Len %ld Placeholder %s",
                  length, subst != NULL ? "Yes" : "No"))

 /* Allocate command line (plus string terminator) */
 if (rc = GetVector(length + 1)) {
  char *s = rc;

  /* Copy command. Parameter placeholder? */
  if (subst) {
   ULONG len = subst - cmd;

   /* Yes, copy only first part of command */
   strncpy(s, cmd, len);

   /* Correct pointers */
   s     += len;
   subst += 2;

  } else {

   /* No, just copy command */
   strcpy(s, cmd);

   /* Correct pointer */
   s += strlen(s);
  }

  /* Scan parameter list */
  {
   struct Parameter *p = params;

   while (p) {

    CMDLINE_LOG(LOG1(Add Parameter, "'%s'", p->p_Data))

    /* Copy parameter */
    strcpy(s, p->p_Data);

    /* Correct pointer */
    s += p->p_Length;

    /* Next parameter */
    p = p->p_Next;
   }
  }

  /* Parameter substitution? Copy rest of command */
  if (subst) strcpy(s, subst);

  /* Copy length to variable */
  if (cmdlen) *cmdlen = length;

  CMDLINE_LOG(LOG1(Final, "%s", rc))
 }

 /* Free parameters */
 {
  struct Parameter *p, *np = params;

  /* Scan list */
  while (p = np) {

   /* Get next parameter */
   np = p->p_Next;

   /* Free parameter */
   FreeVector(p);
  }
 }

 CMDLINE_LOG(LOG1(Result, "0x%08lx", rc))

 return(rc);
}
