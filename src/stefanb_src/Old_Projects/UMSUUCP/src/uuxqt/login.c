/*
 * login.c  V0.8.01
 *
 * handle UMS login and config variables
 *
 * (c) 1992-94 Stefan Becker
 *
 */

#include "uuxqt.h"

struct LoginData {
                  struct LoginData *ld_Next;
                  ULONG             ld_Size;
                  char             *ld_Name;
                  void             *ld_Account;
                  char             *ld_PathName;
                  char             *ld_DomainName;
                  BOOL              ld_Valid;      /* All config vars found */
                 };

static struct LoginData *Logins=NULL;
UMSUserAccount Account=NULL;
char *PathName=NULL;
char *DomainName=NULL;

static void SetGlobalVars(struct LoginData *ld)
{
 Account=ld->ld_Account;
 PathName=ld->ld_PathName;
 DomainName=ld->ld_DomainName;
}

BOOL Login(char *newacc)
{
 struct LoginData *ld=Logins;
 ULONG size;

 /* Search for login entry */
 while (ld && strcmp(ld->ld_Name+sizeof(UMSUUCP_PRE)-1,newacc))
  ld=ld->ld_Next;

 /* Login found? */
 if (ld) {
  BOOL rc=ld->ld_Valid;

  /* Login valid? */
  if (rc)
   /* Yes. Set global variables */
   SetGlobalVars(ld);

  return(rc);
 }

 /* No. Create new login */
 size=sizeof(struct LoginData)+sizeof(UMSUUCP_PRE)+strlen(newacc);
 if (ld=AllocMem(size,MEMF_CLEAR)) {

  /* Create account name */
  ld->ld_Size=size;
  ld->ld_Valid=FALSE;
  ld->ld_Name=(char *) (ld+1);
  strcpy(ld->ld_Name,UMSUUCP_PRE);
  strcat(ld->ld_Name,newacc);

  /* Chain into login data list */
  ld->ld_Next=Logins;
  Logins=ld;

  /* Login to new account */
  if (ld->ld_Account=UMSRLogin(UMSMBName,ld->ld_Name,"")) {

   /* Login succeeded, read config vars */
   ld->ld_PathName=ReadUMSConfigTags(ld->ld_Account,
                                     UMSTAG_CfgName,UMSUUCP_PATHNAME,
                                     TAG_DONE);
   ld->ld_DomainName=ReadUMSConfigTags(ld->ld_Account,
                                       UMSTAG_CfgName,UMSUUCP_DOMAINNAME,
                                       TAG_DONE);

   /* Set valid flag */
   ld->ld_Valid=(ld->ld_PathName && ld->ld_DomainName);

   /* Config correct? */
   if (!ld->ld_Valid)
    ErrLog("missing config variable in account '%s'!\n",ld->ld_Name);

   /* Set global variables and return */
   SetGlobalVars(ld);
   return(ld->ld_Valid);
   /* NOT REACHED */

  } else
   ErrLog("couldn't login as '%s'!\n",ld->ld_Name);

 } else
  ErrLog("couldn't allocate memory for login data!\n");

 return(FALSE);
}

/* Logout and free all logins */
void FreeLogins(void)
{
 struct LoginData *ld=Logins;

 /* Scan list */
 while (ld) {
  struct LoginData *next=ld->ld_Next;
  void *account=ld->ld_Account;
  char *cp;

  /* Free config variables */
  if (cp=ld->ld_PathName) FreeUMSConfig(account,cp);
  if (cp=ld->ld_DomainName) FreeUMSConfig(account,cp);

  /* Logout */
  UMSLogout(account);

  /* Free entry */
  FreeMem(ld,ld->ld_Size);

  /* Next entry */
  ld=next;
 }
}
