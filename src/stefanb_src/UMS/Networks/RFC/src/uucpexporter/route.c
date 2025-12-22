/*
 * route.c  V1.0.00
 *
 * Create route address from RFC address
 *
 * (c) 1992-96 Stefan Becker
 *
 */

#include "ums2uucp.h"

struct RouteData {
 struct Node  rd_Node;
 ULONG        rd_BufLen;  /* Buffer length             */
 char        *rd_Address; /* Address pattern           */
 char        *rd_Pattern; /* Preparsed address pattern */
 char        *rd_Route;   /* Mail route                */
};

static char        *RouteVar;
static ULONG        RouteEntries=0;
static struct List  RouteDataList;
static BOOL         Batched;

/* Get route data */
void GetRouteData(void)
{
 /* Initialize routing list */
 NewList(&RouteDataList);

 /* Batched mail? */
 Batched = BatchedMail();

 /* Read routing table from UMS config */
 if (RouteVar = UMSReadConfigTags(Account, UMSTAG_CfgName,UMSUUCP_MAILROUTE,
                                           TAG_DONE)) {
  char  *lp    = RouteVar;
  ULONG  lines = 1;

  do {
   char *route    = lp;
   char *nextline;
   ULONG patlen;

   /* Search next line */
   if (nextline = strchr(lp, '\n'))
    *nextline++ = '\0'; /* Set string terminator */

   /* Debugging */
   ulog(2, "Route line: %s", lp);

   /*
    * Format of entry
    *
    * <address pattern> [<host1>[,<host2> ...]]
    * |                  |
    * |                  - Host names for mail route. Empty list means
    * |                    no routing. (Default: No routing)
    * -------------------- Address pattern for this route
    */
   /* lp points to address pattern, search route */
   {
    char c;

    /* Scan line until white space or end of line is reached */
    while ((c = *route) && (c != ' ') && (c != '\t')) route++;

    /* End of line reached? */
    if (c) {
     /* No, set string terminator for address */
     *route++ = '\0';

     /* Skip white space */
     while ((c = *route) && ((c == ' ') || (c == '\t'))) route++;
    }
   }

   /* Calculate pattern buffer length */
   patlen = 2 * strlen(lp) + 2;

   /* Address valid? */
   if (patlen > 2) {
    struct RouteData *rd;
    ULONG hosts = 0, length;

    /* Count hosts in route */
    {
     char *cp = route;
     if (*cp) hosts++;
     while (cp = strchr(cp, ',')) {
      hosts++;
      cp++;
     }
    }

    /* Debugging */
    ulog(2, "Route address pattern: %s, %d host(s): %s", lp, hosts, route);

    length = sizeof(struct RouteData)                     /* Node structure */
             + patlen                                     /* Pattern buffer */
                                                          /* Route buffer   */
             + (hosts ? (strlen(route) + (Batched ? hosts : 0) + 2) : 0);

    /* Create entry */
    if (rd = AllocMem(length, MEMF_PUBLIC)) {

     /* Initialize entry */
     rd->rd_BufLen  = length;
     rd->rd_Address = lp;
     rd->rd_Pattern = (char *) rd + sizeof(struct RouteData);
     rd->rd_Route   = (hosts ? (rd->rd_Pattern + patlen) : NULL);

     /* Parse pattern */
     if (ParsePatternNoCase(lp, rd->rd_Pattern, patlen) >= 0) {

      /*
       * Build route string
       *
       * RMail: host1!host2!...!hostn!
       * BSMTP: @host1,@host2,...,@hostn:
       */
      if (hosts) {
       char *hp = route, *bp = rd->rd_Route;

       while (hosts--) {
        char *nexthost;

        /* Search next host name */
        if (nexthost = strchr(hp, ','))
         *nexthost++='\0'; /* Set string term. */

        /* Copy host name */
        if (Batched) *bp++ = '@';
        strcpy(bp, hp);
        bp    += strlen(hp);
        *bp++  = (Batched ? ',' : '!');

        /* Next host name */
        hp = nexthost;
       }

       /* Batch: Replace last ',' with ':' */
       if (Batched) *(bp-1) = ':';

       /* Set string terminator */
       *bp = '\0';
      }

      /* Add entry to list */
      AddTail(&RouteDataList, (struct Node *) rd);
      RouteEntries++;

      /* Error while parsing pattern */
     } else {
      FreeMem(rd, length);
      ulog(-1, "Couldn't parse address pattern '%s'!", lp);
     }
    }

    /* Invalid route entry */
   } else
    ulog(-1, "No address pattern in route entry, line %d", lines);

   /* Get next line */
   lp = nextline;
   lines++;
  } while (lp);
 }

 /* Debugging */
 if (LogLevel >= 1) {
  struct RouteData *rd = GetHead(&RouteDataList);

  ulog(1, "Mail routing table (%d route(s)):", RouteEntries);

  while (rd) {
   ulog(1, "addr: %s, route: %s",
           rd->rd_Address, (rd->rd_Route ? rd->rd_Route : "<none>"));
   rd = GetSucc((struct Node *) rd);
  }
 }
}

/* Free route data */
void FreeRouteData(void)
{
 struct RouteData *rd;

 /* Free all entries */
 while (rd = (struct RouteData *) RemHead(&RouteDataList))
  FreeMem(rd, rd->rd_BufLen);

 /* Free config var */
 if (RouteVar) UMSFreeConfig(Account, RouteVar);
}

/* Create route address from RFC address */
char *CreateRouteAddress(char *addr, char *buf)
{
 char *rc=addr; /* Default: Don't route */

 if (RouteEntries) {
  struct RouteData *rd=GetHead(&RouteDataList);

  /* Scan list */
  while (rd) {
   /* Address pattern matching */
   if (MatchPatternNoCase(rd->rd_Pattern,addr)) {
    char *route;

    /* Pattern matched, do we have a route for this address? */
    if (route=rd->rd_Route)

     /* Yes, convert address */
     if (Batched) {
      /* Batched mail */
      sprintf(buf,"%s%s",route,addr);

      /* Set return pointer to buffer */
      rc=buf;

      /* RMail, convert to bang path */
     } else {
      char *ap;

      /* Search address part */
      if (ap=strchr(addr,'@')) {

       /* Set string terminator for name part */
       *ap++='\0';

       /* Build bang path */
       sprintf(buf,"%s%s!%s",route,ap,addr);

       /* Set return pointer to buffer */
       rc=buf;
      }
     }

    /* Leave loop */
    break;
   }

   /* Get next entry */
   rd=GetSucc((struct Node *) rd);
  }
 }

 /* Return pointer to (new) address */
 return(rc);
}
