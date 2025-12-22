/*
 * split.c  V0.7.02
 *
 * umsrfc.library/UMSRFCConvertRFCAddress()
 *
 * Get & convert a RFC address, split address into real name and address
 *
 * Based on: - parse.c,       (c) Matt Dillon
 *           - SplitAdress(), (c) Christian Rütgers
 *
 * Rewrites & Changes: (c) 1992-95 Stefan Becker
 *
 */

#include "umsrfc.h"

/* Constant strings */
static const char SpaceRep[]="_.";

/*
 *  PARSE.C
 *
 *  $Header: Beta:src/uucp/src/sendmail/RCS/parse.c,v 1.1 90/02/02 12:15:05 dillon Exp Locker: dillon $
 *
 *  (C) Copyright 1989-1990 by Matthew Dillon,  All Rights Reserved.
 */

/*
 *  deals with !, @, and %
 */

static char *ParseAddress2(char *addr, char *buf, int len)
{
    int i;

    for (i = len - 1; i >= 0; --i) {
        if (addr[i] == '@' || addr[i] == '%') {
            short j = len - i;
            strncpy(buf, addr + i + 1, j - 1);
            buf += j - 1;
            len -= j;
            if (len)
                *buf++ = '!';
        }
    }
    strncpy(buf, addr, len);
    buf += len;
    return(buf);
}

/*
 *  PARSEADDRESS()
 *
 *  Takes an address containing ! @ % : and converts it to a level 3 ! path.
 *
 *  [path]@mach         ->  mach[!path]
 *  [path]%mach         ->  mach[!path]
 *  patha:pathb         ->  patha!pathb
 *  patha:pathb:pathc   ->  patha!pathb!pathc
 */

static int ParseAddress(char *str, char *buf, int len)
{
    int i;
    int j;
    char *base = buf;

    for (i = j = 0; i < len; ++i) {
        if (str[i] == ':') {
            buf = ParseAddress2(str + j, buf, i - j);
            *buf++ = '!';
            j = i + 1;
        }
    }
    buf = ParseAddress2(str + j, buf, i - j);
    *buf = 0;
    for (i = 0; base[i] && base[i] != '!'; ++i);
    return((int)i);
}

/*
 * SplitAddress()
 *
 * Takes a From:, Sender:, Reply-To: RFC header line and splits it up into
 * real name and address part. If no real name exists, the user name will be
 * used as real name.
 *
 * buf should point to a scratch place with 1024 bytes free
 *
 */

#define NAME    (1<<0)
#define ADDRESS (1<<1)
#define TEMP    (1<<2)

static void SplitAddress(const char *input, char *name, char *address,
                                            char *buf)
{
 char *bp;
 int   mode = 0;

#ifdef DEBUG
 kprintf("SplitAddress() got    : '%s'\n", input);
#endif

 /* Clear buffers */
 *name    = '\0';
 *address = '\0';

 /* Try to find name & address in header line */
 bp = buf;
 {
  char nextchar;

  while ((nextchar = *input) && (nextchar != ','))
   switch(nextchar)
    {
     case ' ':       /* Ignore spaces */
              input++;
              break;

     case '(':       /* Begin of real name -> strip () -> name buffer */
              {
               int   parcnt = 1; /* One open parenthesis */
               char *np = name;  /* Pointer into name buffer */

               /* Copy name (track quotations!!) */
               while (*++input && parcnt)
                switch (*np++ = *input) {
                 case '(':  parcnt++; /* Another quotation in the quotation */
                            break;
                 case ')':  parcnt--; /* One quotation closed */
                            break;
                 case '\\': *(np-1) = *++input; /* Quoted character */
                            break;
                }

               /* Quotation complete? */
               if (parcnt == 0) np--; /* Yes, strip ')' from name string */

               /* Add string terminator */
               *np = '\0';

               /* Got a name? */
               if (name != np) mode |= NAME;
              }
              break;

     case '<':       /* Begin of address -> strip <> -> address buffer */
              {
               char *ap = address; /* Pointer into address buffer */

               /* Copy address */
               while (*++input && (*input != '>')) *ap++ = *input;

               /* Address complete? */
               if (*input) input++; /* Yes, skip '>' */

               /* Add string terminator */
               *ap = '\0';
               mode |= ADDRESS;
              }
              break;

     case '"':       /* Begin of quoted string -> strip "" -> temp buffer */
              {
               char c;

               /* Parse quoted string */
               input++;
               while ((c = *input++) && (c != '"'))
                if ((*bp++ = c) == '\\')
                 *(bp - 1) = *input++; /* quoted character */

               /* Add string terminator */
               *bp = '\0';
               mode |= TEMP;
              }
              break;

     default :       /* All other will be concatenated to temp buffer */
              while (*input && !strchr("(<,", *input)) *bp++ = *input++;

              /* Add string terminator */
              *bp = '\0';
              mode |= TEMP;
              break;
    }
 }

#ifdef DEBUG
 kprintf("SplitAddress() found  : name '%s' address '%s' other '%s'\n",
         name, address, buf);
#endif

 /* analyse what we have found */
 switch (mode) {
  case 0           :  /* NOTHING found?????? */
  case NAME        :  /* Only name found???? */
                      /* ERROR??? */
                      break;

  case TEMP        :  /* No name and address, but something else... */
                      /* Copy it to address buffer */
                      strcpy(address, buf);

                      /* FALL THROUGH!!!! */

  case ADDRESS     :  /* Only address found -> extract user name from addr */
                      /* Convert address into a complete bang path */
                      ParseAddress(address, buf, strlen(address));

                      /* Find last '!' in bang path (...!host!user) */
                      if (bp = strrchr(buf, '!'))
                       strcpy(name, bp + 1); /* Name is last part of bang */
                      else
                       strcpy(name, buf);    /* Only name in address */
                      break;

  case NAME|TEMP   :  /* Name and something else found */
                      strcpy(address, buf);
                      break;

   case ADDRESS|TEMP: /* Address and something else found */
                      strcpy(name, buf);
                      break;

   case NAME|ADDRESS: /* Address & name found -> All OK! */
   case NAME|ADDRESS|TEMP:
                      break;
  }

#ifdef DEBUG
 kprintf("SplitAddress() built  : name '%s' address '%s'\n", name, address);
#endif

 /* Does address contain routing information (e.g. bangs)? */
 if (strpbrk(address, "!%:")) {
  /* Yes, convert address to domain format */
  char *up;

  /* ...but first convert address into a complete bang path :-) */
  ParseAddress(address, buf, strlen(address));

  /* Get pointer to user name */
  up    = strrchr(buf, '!');  /* Find last '!' (at least ONE must be there) */
  *up++ = '\0';               /* Set string terminator for host name */

  /* Get pointer to host name */
  if (bp = strrchr(buf, '!'))
   bp++;     /* Find last but one '!' */
  else
   bp = buf; /* No second '!' -> address is "host!user" */

  /* Check for domain address */
  if (strchr(bp, '.'))
   psprintf(address, "%s@%s", up, bp);      /* Host has domain address */
  else
   psprintf(address, "%s@%s.uucp", up, bp); /* Host has no domain, add .uucp */

 } else if (!strrchr(address, '.')) /* Check for domain address (backwards) */
  strcat(address, ".uucp");         /* No domain address -> add ".uucp" */

 {
  char *ap = address;
  char *np = name + strlen(name);

  /* Remove all comments from address and append them to name string */
  /* Remove all spaces from address */
  bp = address;
  while (*bp)
   switch(*bp) {
    case ' ': bp++;        /* Skip spaces */
              break;

    case '(':              /* Begin of quotation */
              {
               int   parcnt = 1; /* One open parenthesis */

               /* Last character in name a space? */
               if (*np != ' ') *np++ = ' '; /* No, seperate comments */

               /* Copy quotation (track recursive quotations!!) */
               while (*++bp && parcnt)
                switch (*np++ = *bp) {
                 case '(': parcnt++; /* Another quotation in the quotation */
                           break;
                 case ')': parcnt--; /* One quotation closed */
                           break;
                }

               /* Quotation complete? */
               if (parcnt == 0) np--; /* Yes, strip ')' from name string */

               /* Add string terminator */
               *np = '\0';
              }
              break;

    default:  *ap++ = *bp++; /* Copy the rest */
              break;
   }

  /* Add string terminator to address */
  *ap = '\0';

  /* Remove trailing blanks in name string */
  while ((np != name) && (*--np == ' '));
  *++np = '\0';
 }

#ifdef DEBUG
 kprintf("SplitAddress() returns: name '%s' address '%s'\n", name, address);
#endif
}

/* Does the address match one of the domains in the list? */
static BOOL AddrInDomainList(char *addrend, ULONG len, struct DomainList *dl)
{
 BOOL rc = FALSE;

 /* Domain list valid? */
 if (dl) {
  struct DomainData *dd;
  ULONG              i;

  /* Scan entries */
  for (i = dl->dl_Entries, dd = &dl->dl_Data; i; i--, dd++) {
   ULONG domlen = dd->dd_Length;

   /* Address long enough and does the domain part match? */
   if ((len > domlen) && (stricmp(addrend - domlen, dd->dd_Name) == 0)) {

    /* Domain found, leave loop */
    rc = TRUE;
    break;
   }
  }
 }

 return(rc);
}

/*
 * UMSRFCConvertRFCAddress() - get and convert an address
 *
 * buf should point to a scratch place with 1024 bytes free
 *
 */
__LIB_PREFIX void UMSRFCConvertRFCAddress(
             __LIB_ARG(A0) struct UMSRFCData *urd,
             __LIB_ARG(A1) const char        *rfcaddr,
             __LIB_ARG(A2) char              *addr,
             __LIB_ARG(A3) char              *name
             /* __LIB_BASE */)
{
 struct PrivateURD *purd = (struct PrivateURD *) urd;
 char  *ap;
 ULONG  len;

 /* Call SplitAddress() first */
 SplitAddress(rfcaddr, name, addr, purd->purd_Buffer3);

 /* Find end of address string */
 len = strlen(addr);
 ap  = addr + len;

 /* Address conversion */
 if (AddrInDomainList(ap, len, purd->purd_ImportFIDODomainList) &&
     strchr(addr, '@')) {
  /* Fidonet                                                    */
  /* RFC: Real_Name@p<point>.f<node>.n<hub>.z<zone><fidodomain> */
  /* UMS: <zone>:<hub>/<node>[.<point>]@fidonet                 */
  LONG zone = 0, hub = 0, node = 0, point = 0;
  char c, *np;

  /* Copy name */
  ap = addr;
  np = name;
  while ((c = *ap++) != '@') *np++ = (strchr(SpaceRep,c)) ? ' ' : c;
  *np = '\0';

  /* Extract address */
  {
   char *endp = ap;

   if (*endp == 'p') {
    point = strtol(endp + 1, &endp, 10);
    endp++;
   }
   if (*endp == 'f') {
    node = strtol(endp + 1, &endp, 10);
    endp++;
   }
   if (*endp == 'n') {
    hub = strtol(endp + 1, &endp, 10);
    endp++;
   }
   if (*endp == 'z') {
    zone = strtol(endp + 1, &endp, 10);
    endp++;
   }
  }

  /* Create address */
  if (point)
   psprintf(addr, "%d:%d/%d.%d@fidonet", zone, hub, node, point);
  else
   psprintf(addr, "%d:%d/%d@fidonet", zone, hub, node);

 } else if (AddrInDomainList(ap, len, purd->purd_ImportMausDomainList) &&
            strchr(addr, '@')) {
  /* Maus-Netz (German network)           */
  /* RFC: Real_Name@<boxname><mausdomain> */
  /* UMS: <boxname>.maus                  */
  char c, *np;

  /* Copy name */
  ap = addr;
  np = name;
  while ((c = *ap++) != '@') *np++ = (strchr(SpaceRep,c)) ? ' ' : c;
  *np = '\0';

  /* Build address */
  np = addr;
  while ((c = *ap++) && (c != '.')) *np++ = c; /* Copy box name */
  strcpy(np, ".maus");
 }
}
