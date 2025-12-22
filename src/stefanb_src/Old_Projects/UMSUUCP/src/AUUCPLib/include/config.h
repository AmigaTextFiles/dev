
/*
 *  CONFIG.H
 */

#ifndef _CONFIG_H
#define _CONFIG_H

#ifdef NOTDEF
#ifndef _NDIR_H
#include "ndir.h"
#endif
#endif
#ifndef _GETFILES_H
#include "getfiles.h"
#endif
#ifndef _PROTOS_H
#include "protos.h"
#endif
#ifndef _TIME_H
#include <time.h>
#endif

#define Prototype   extern
#define Local
#define ProtoInclude

#include "lib_protos.h"     /*  MACHINE GENERATED   */

#define USERNAME	"UserName"
#define NODENAME	"NodeName"
#define REALNAME	"RealName"
#define DEBUGNAME	"Debug"
#define NEWSFEED	"NewsFeed"
#define ORGANIZATION	"Organization"
#define FILTER		"Filter"        /*  can be run in the foregnd    */
#define RFILTER 	"RFilter"       /*  can be run in the background */
#define EDITOR		"MailEditor"
#define NEWSEDITOR	"NewsEditor"
#define DOMAINNAME	"DomainName"
#define TIMEZONE	"TimeZone"
#define DEFAULTNODE	"DefaultNode"

/*
 *  1.05
 */

#define MAILREADYCMD	"MailReadyCmd"
#define NEWSREADYCMD	"NewsReadyCmd"

/*
 *  1.06
 */

#define RNEWSDEBUG	"RNewsDebug"

/*
 *  1.07
 */

#define MODEMINIT	"ModemInit"     /*  modem initialization str */
#define AUTOBATCH	"AutoBatch"     /*  auto-batch on postnews       */
#define CTIMEOUT	"Timeout"       /*  connect timeout          */
#define MAXRMAILLEN	"MaxRMailLen"

/*
 *  1.14
 */

#define BATCHBITS	"BatchBits"
#define MAILBOUNCE	"MailBounce"
#define DOMAINPATH	"DomainPath"
#define SPOOLSIZE	"SpoolSize"
#define HOME		"Home"          /*  dmail   */

/*
 *  1.15
 */

#define MUNGECASE	"MungeCase"     /*  Y/N, default Y, case munging    */
#define JUNKSAVE	"JunkSave"      /*  Y/N, default Y, junk newsgroup  */

/*
 *  The following config entries are self-defaults... if the config
 *  entry does not exist the default is the config-name.  The config
 *  entry is normally retrieve with 'GetConfigProgram(string)'
 */

#define BATCHNEWS	"BatchNews"
#define UUX		"Uux"
#define SENDMAIL	"Sendmail"
#define POSTNEWS	"Postnews"
#define UUXQT		"Uuxqt"
#define RMAIL		"RMail"
#define CUNBATCH	"CUnbatch"
#define RNEWS		"RNews"
#define RSMTP		"RSMTP"
#define RCSMTP		"RCSMTP"

/*
 *  The following config entries are directory-defaults... if the
 *  config entry does not exist the specified default is returned.
 *
 *  These entries are retrieved via 'GetConfigDir(string)'
 *
 *  The SUUCP entry is used ONLY by people doing distributions and
 *  working on the source.
 */

#define UUSPOOL     "UUSpool\0UUSPOOL:"
#define UUNEWS	    "UUNews\0UUNEWS:"
#define UUMAIL	    "UUMail\0UUMAIL:"
#define UULIB	    "UULib\0UULIB:"
#define UUPUB	    "UUPub\0UUPUB:"
#define UUMAN	    "UUMan\0UUMAN:"
#define SUUCP	    "UUCP\0UUCP:"
#define UUALTSPOOL  "UUAltSpool\0UUALTSPOOL:"
#define LOCKDIR     "LockDir\0T:"

/*
 * This idea (and base) for this code was written by Fred Cassirer 10/9/88
 * as a Config file for News programs, to whom I say Thanx!
 *
 * It has since been expanded to include all the directory paths and some
 * command/filenames. This is to eliminate the forced use of hardcoding in
 * the executables.
 *
 * Simply change any of these you may need to, and recompile as needed.
 *
 * Sneakers 11/21/88
 *
 */

#define MAXGROUPS 1024	/* Maximum # of subscribed newsgroups */
#define MAXFILES  1000	/* Max # of files in any news or spool directory */

/*
 *  overrides any previous NULL
 */

#ifdef NULL
#undef NULL
#endif
#define NULL ((void *)0L)

#endif

