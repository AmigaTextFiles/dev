/*
 * login.c  V1.0.00
 *
 * handle UMS login and config variables
 *
 * (c) 1992-97 Stefan Becker
 *
 */

#include "uuxqt.h"

/* Constant strings */
static const char ErrLogin[] = "couldn't login as '%s'!\n";
static const char NoMemory[] = "couldn't allocate memory for login data!\n";

struct LoginData {
                  struct LoginData  *ld_Next;
                  struct UMSRFCData *ld_URD;
                  ULONG              ld_Size;
                  char              *ld_Name;
                 };

/* Local data */
static struct LoginData *Logins = NULL;
static struct UMSRFCBases urb;

/* Global data */
struct UMSRFCData *URData = NULL;
UMSAccount Account        = NULL;

static void SetGlobalVars(struct LoginData *ld)
{
 URData  = ld->ld_URD;
 Account = ld->ld_URD->urd_Account;
}

BOOL Login(char *newacc)
{
 struct LoginData *ld = Logins;
 ULONG size;

 /* Search for login entry */
 while (ld && (strcmp(ld->ld_Name + sizeof(UMSUUCP_PRE) - 1, newacc) != 0))
  ld = ld->ld_Next;

 /* Login found? */
 if (ld) {
  BOOL rc = (ld->ld_URD != NULL);

  /* Login valid? */
  if (rc) SetGlobalVars(ld); /* Yes. Set global variables */

  return(rc);
 }

 /* No. Create new login */
 size = sizeof(struct LoginData) + sizeof(UMSUUCP_PRE) + strlen(newacc);
 if (ld = AllocMem(size, MEMF_CLEAR)) {

  /* Create account name */
  ld->ld_Size  = size;
  ld->ld_Name  = (char *) (ld + 1);
  strcpy(ld->ld_Name, UMSUUCP_PRE);
  strcat(ld->ld_Name, newacc);

  /* Chain into login data list */
  ld->ld_Next = Logins;
  Logins      = ld;

  /* Set library bases for umsrfc.library */
  urb.urb_UMSBase     = UMSBase;
  urb.urb_DOSBase     = DOSBase;
  urb.urb_UtilityBase = UtilityBase;

  /* Login to new account */
  {
   struct UMSRFCData *urd = UMSRFCAllocData(&urb, ld->ld_Name, UMSPassword,
                                            UMSMBName);

   if (ld->ld_URD = urd) {

    /* Set global variables and return */
    SetGlobalVars(ld);
    return(TRUE);
    /* NOT REACHED */

   } else
    if (DefaultLog)
     UMSRFCLog(DefaultLog, ErrLogin, ld->ld_Name);
    else
     ulog(-1, ErrLogin, ld->ld_Name);
  }

 } else
  if (DefaultLog)
   UMSRFCLog(DefaultLog, NoMemory);
  else
   ulog(-1, NoMemory);

 return(FALSE);
}

/* Logout and free all logins */
void FreeLogins(void)
{
 struct LoginData *ld=Logins;

 /* Scan list */
 while (ld) {
  struct LoginData *next = ld->ld_Next;

  /* Logout */
  if (ld->ld_URD) UMSRFCFreeData(ld->ld_URD);

  /* Free entry */
  FreeMem(ld, ld->ld_Size);

  /* Next entry */
  ld = next;
 }
}
