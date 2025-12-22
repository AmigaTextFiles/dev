/*
 * ums_uucp.h V0.8.08
 *
 * UMS UUCP main include file
 *
 * (c) 1992-1994 Stefan Becker
 *
 */

/* version strings */
#define UMSUUCP_VERSION  " 0.8.08"
#define UMSUUCP_IDSTRING UMSUUCP_VERSION " (" __COMMODORE_DATE__ ")"

/* UMS UUCP configuration variables */
/* Prefix */
#define UMSUUCP_PRE        "uucp."
/* Global */
#define UMSUUCP_DEBUGFILE  UMSUUCP_PRE "debugfile"
#define UMSUUCP_DEFDEBUG   "T:UUCP-DebugLog"
#define UMSUUCP_DEBUGLEVEL UMSUUCP_PRE "debuglevel"
#define UMSUUCP_DEFAULT    "default"
#define UMSUUCP_DOMAINNAME UMSUUCP_PRE "domainname"
#define UMSUUCP_NODENAME   UMSUUCP_PRE "nodename"
#define UMSUUCP_PATHNAME   UMSUUCP_PRE "pathname"
/* Importer (uuxqt) */
#define UMSUUCP_FILTERCR   UMSUUCP_PRE "filtercr"
#define UMSUUCP_IMPORT     UMSUUCP_PRE "import."
#define UMSUUCP_KEEPDUPES  UMSUUCP_PRE "keepdupes"
/* Exporter (ums2uucp) */
#define UMSUUCP_DUMBHOST   UMSUUCP_PRE "dumbhost"
#define UMSUUCP_ENCODING   UMSUUCP_PRE "encoding"
#define UMSUUCP_EXPORT     UMSUUCP_PRE "export."
#define UMSUUCP_MAILEXPORT UMSUUCP_PRE "mailexport"
#define UMSUUCP_MAILROUTE  UMSUUCP_PRE "mailroute"
#define UMSUUCP_NEWSEXPORT UMSUUCP_PRE "newsexport"
#define UMSUUCP_RECIPIENTS UMSUUCP_PRE "recipients"
#define UMSUUCP_USERNAME   UMSUUCP_PRE "username"

/* UMS UUCP environment variables */
#define UMSUUCP_MBASE "UMSUUCP.mb"

/* UMS UUCP header ID */
#define UMSUUCP_HEADERID "UMS-UUCP/uuxqt\n"
#define UMSUUCP_HDRIDLEN 15

/* debuging */
extern char *UMSDebugProgram;
extern char *UMSDebugFile;
extern long  UMSDebugLevel;
void UMSDebugLog(long level, char *fmt, ...);
