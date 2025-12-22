/*
 * progress.c  V0.6.01
 *
 * progress indicator
 *
 * (c) 1992-93 Stefan Becker
 *
 */

#include "uuxqt.h"

static ULONG InCounter=0;
static ULONG InBadCounter=0;
static ULONG MailCounter=0;
static ULONG MailBadCounter=0;
static ULONG NewsCounter=0;
static ULONG NewsBadCounter=0;
static ULONG CrossPostedCounter=0;
static ULONG CrossPostedBadCounter=0;

void PrintProgress(BOOL full)
{
 if (full || ((FileCounter%5)==0)) {
  /* Build progress message */
  sprintf(MainBuffer,"files (%d/%d) in (%d/%d) mail (%d/%d) news (%d/%d) "
                     "cross (%d/%d)",
                     FileCounter,FileBadCounter,
                     InCounter,InBadCounter,
                     MailCounter,MailBadCounter,
                     NewsCounter,NewsBadCounter,
                     CrossPostedCounter,CrossPostedBadCounter);

  /* Print message to stdout */
  printf("uuxqt: %s\n",MainBuffer);

  /* Print last message into logfile */
  if (full) ulog(-1,MainBuffer);
 }
}

void MailGood(void)
{
 InCounter++;
 MailCounter++;
}

void MailBad(void)
{
 InCounter++;
 InBadCounter++;
 MailCounter++;
 MailBadCounter++;
}

void NewsGood(void)
{
 InCounter++;
 NewsCounter++;
}

void NewsBad(void)
{
 InCounter++;
 InBadCounter++;
 NewsCounter++;
 NewsBadCounter++;
}

void CrossPostGood(void)
{
 InCounter++;
 CrossPostedCounter++;
}

void CrossPostBad(void)
{
 InCounter++;
 InBadCounter++;
 CrossPostedCounter++;
 CrossPostedBadCounter++;
}
