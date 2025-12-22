/*
 * global_debug.c  V3.1
 *
 * ToolManager global debugging support routines
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

/* All stuff of this module is only included if DEBUG symbol is defined */
#ifdef DEBUG
/* Global data */
ULONG DebugFlags[DEBUGFLAGENTRIES];

/* Local data */
#define BUFLEN 256
static char DebugBuffer[BUFLEN];

/* Initialize debug flags */
#define DEBUGFUNCTION InitDebug
void InitDebug(const char *var)
{
 int             i;
 struct Library *DOSBase;

 /* Clear all debug flags */
 for (i = 0; i < DEBUGFLAGENTRIES; i++) DebugFlags[i] = 0;

 /* Open local copy of dos.library */
 if (DOSBase = OpenLibrary("dos.library", 39)) {

  /* Read debug environment variable */
  if (GetVar(var, DebugBuffer, BUFLEN, GVF_GLOBAL_ONLY) != -1) {
   char *p = DebugBuffer;

   KPutStr(DEBUGHEADER(Flags));

   /* For each entry in the debug flags array */
   for (i = 0; i < DEBUGFLAGENTRIES; i++) {
    ULONG flags = 0;

    /* Are there more flags? */
    if (*p)

     /* Flag type? */
     switch (*p++) {
      case 'X': {    /* Hexadezimal */
        char c;

        /* Get next hex digit */
        while (c = *p) {

         /* Decode digit */
         if      ((c >= '0') && (c <= '9')) flags = (flags << 4) | (c-'0');
         else if ((c >= 'A') && (c <= 'F')) flags = (flags << 4) | (c-'A'+10);
         else                               break; /* No hex digit */

         /* Next digit */
         p++;
        }
       }
       break;

      case 'Y': {    /* Binary */
        char c;

        /* Get next binary digit */
        while (c = *p) {

         /* Decode digit */
         if      (c == '0') flags <<= 1;
         else if (c == '1') flags = (flags << 1) | 1;
         else               break; /* No binary digit */

         /* Next digit */
         p++;
        }
       }
       break;
     }

    /* Store flags to array */
    DebugFlags[i] = flags;
    kprintf(" %08lx", flags);
   }

   KPutChar('\n');
  }

  /* Close library */
  CloseLibrary(DOSBase);
 }
}

#ifdef DEBUGPRINTTAGLIST
/* Print a tag list */
void PrintTagList(const struct TagItem *tags)
{
 const struct TagItem *tstate = tags;
 const struct TagItem *ti;

 /* Print Header */
 KPutStr("Tag Name             | Tag Value\n"
         "-------------------------------------------\n");

 while (ti = NextTagItem(&tstate)) {

  /* Print Tag line */
  kprintf("%-20s | ", GetTagName(ti->ti_Tag));
  kprintf(GetTagFormat(ti->ti_Tag), ti->ti_Data);
  KPutChar('\n');
 }

 /* Print footer */
 KPutStr("-------------------------------------------\n");
}
#endif
#endif
