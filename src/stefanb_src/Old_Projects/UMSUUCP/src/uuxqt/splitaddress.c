/*
 * splitaddress.c  V0.7.03
 *
 * split address into real name and address
 *
 * Based on: - parse.c, (c) Matt Dillon
 *           - SplitAdress(), (c) Christian Rütgers
 *
 * Changes: (c) 1992-93 Stefan Becker
 *
 */

#include "uuxqt.h"

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

void SplitAddress(char *input, char *name, char *address, char *buf)
{
 char *bp;
 int   mode=0;

 UMSDebugLog(5,"SplitAddress() got    : '%s'\n",input);

 /* Clear buffers */
 *name    ='\0';
 *address ='\0';

 /* Try to find name & address in header line */
 bp=buf;
 {
  char nextchar;

  while ((nextchar=*input) && (nextchar!=','))
   switch(nextchar)
    {
     case ' ':       /* Ignore spaces */
              input++;
              break;

     case '(':       /* Begin of real name -> strip () -> name buffer */
              {
               int   parcnt=1; /* One open parenthesis */
               char *np=name;  /* Pointer into name buffer */

               /* Copy name (track quotations!!) */
               while (*++input && parcnt)
                switch (*np++=*input) {
                 case '(':parcnt++; /* Another quotation in the quotation */
                          break;
                 case ')':parcnt--; /* One quotation closed */
                          break;
                 case '\\':*(np-1)=*++input; /* Quoted character */
                          break;
                }

               /* Quotation complete? */
               if (parcnt==0) np--; /* Yes, strip ')' from name string */

               /* Add string terminator */
               *np='\0';

               /* Got a name? */
               if (name!=np) mode|=NAME;
              }
              break;

     case '<':       /* Begin of address -> strip <> -> address buffer */
              {
               char *ap=address; /* Pointer into address buffer */

               /* Copy address */
               while (*++input && (*input!='>')) *ap++=*input;

               /* Address complete? */
               if (*input) input++; /* Yes, skip '>' */

               /* Add string terminator */
               *ap='\0';
               mode|=ADDRESS;
              }
              break;

     case '"':       /* Begin of quoted string -> strip "" -> temp buffer */
              {
               char c;

               /* Parse quoted string */
               input++;
               while ((c=*input++) && (c!='"'))
                if ((*bp++=c)=='\\') *(bp-1)=*input++; /* quoted character */

               *bp='\0';
               mode|=TEMP;
              }
              break;

     default :       /* All other will be concatenated to temp buffer */
              while (*input && !strchr("(<,",*input)) *bp++=*input++;
              *bp='\0';
              mode|=TEMP;
              break;
    }
 }

 UMSDebugLog(5,"SplitAddress() found  : name '%s' address '%s' other '%s'\n",
               name,address,buf);

 /* analyse what we have found */
 switch (mode) {
  case 0           :  /* NOTHING found?????? */
  case NAME        :  /* Only name found???? */
                      /* ERROR??? */
                      break;

  case TEMP        :  /* No name and address, but something else... */
                      /* Copy it to address buffer */
                      strcpy(address,buf);

                      /* FALL THROUGH!!!! */

  case ADDRESS     :  /* Only address found -> extract user name from addr */
                      /* Convert address into a complete bang path */
                      ParseAddress(address,buf,strlen(address));

                      /* Find last '!' in bang path (...!host!user) */
                      if (bp=strrchr(buf,'!'))
                       strcpy(name,bp+1); /* Name is last part of bang path */
                      else
                       strcpy(name,buf);  /* Only name in address */
                      break;

  case NAME|TEMP   :  /* Name and something else found */
                      strcpy(address,buf);
                      break;

   case ADDRESS|TEMP: /* Address and something else found */
                      strcpy(name,buf);
                      break;

   case NAME|ADDRESS: /* Address & name found -> All OK! */
   case NAME|ADDRESS|TEMP:
                      break;
  }

 UMSDebugLog(5,"SplitAddress() built  : name '%s' address '%s'\n",
               name,address);

 /* Does address contain a bang path? */
 if (strchr(address,'!')) {
  /* Yes, convert bang path "...!host!user" to "user@host[.uucp]" */
  char *up;

  /* ...but first convert address into a complete bang path :-) */
  ParseAddress(address,buf,strlen(address));

  /* Get pointer to user name */
  up=strrchr(buf,'!');  /* Find last '!' (at least ONE must be there) */
  *up++='\0';           /* Set string terminator for host name */

  /* Get pointer to host name */
  if (bp=strrchr(buf,'!')) bp++; /* Find last but one '!' */
  else bp=buf;                   /* No second '!' -> address is "host!user" */

  /* Check for domain address */
  if (strchr(bp,'.'))
   sprintf(address,"%s@%s",up,bp);      /* Host has domain address */
  else
   sprintf(address,"%s@%s.uucp",up,bp); /* Host has no domain, add .uucp */

 } else if (!strrchr(address,'.')) /* Check for domain address (backwards) */
  strcat(address,".uucp");       /* No domain address -> add ".uucp" */

 {
  char *ap=address;
  char *np=name+strlen(name);

  /* Remove all comments from address and append them to name string */
  /* Remove all spaces from address */
  bp=address;
  while (*bp)
   switch(*bp) {
    case ' ': bp++;        /* Skip spaces */
              break;

    case '(':              /* Begin of quotation */
              {
               int   parcnt=1; /* One open parenthesis */

               /* Last character in name a space? */
               if (*np!=' ') *np++=' '; /* No, add one to seperate comments */

               /* Copy quotation (track recursive quotations!!) */
               while (*++bp && parcnt)
                switch (*np++=*bp) {
                 case '(':parcnt++; /* Another quotation in the quotation */
                          break;
                 case ')':parcnt--; /* One quotation closed */
                          break;
                }

               /* Quotation complete? */
               if (parcnt==0) np--; /* Yes, strip ')' from name string */

               /* Add string terminator */
               *np='\0';
              }
              break;

    default:  *ap++=*bp++; /* Copy the rest */
              break;
   }

  /* Add string terminator to address */
  *ap='\0';

  /* Remove trailing blanks in name string */
  while ((np!=name) && (*--np==' '));
  *++np='\0';
 }

 UMSDebugLog(5,"SplitAddress() returns: name '%s' address '%s'\n",
               name,address);
}
