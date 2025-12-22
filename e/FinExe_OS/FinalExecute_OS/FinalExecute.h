struct magicobj
{
    APTR app,win,aboutmui,menu;
    struct Locale *locale;
    struct Catalog *catalog;
    char *strings;
 /* Gadget section */
    APTR okgadget,cancelgadget,inputgadget,lastinputgad,newshellgadget,popasl,
         moreoptions,outputstrg,currdirstrg,stackstrg,priostrg,shellnamestrg;
    BOOL infomatch;
    APTR twlist,toolorder;
 /* Object section */
    APTR findwin,optionwin,mylv,mylist,findlist,lamp1,lamp2;
    BOOL optionwinisopen,flashexec;
    ULONG dtlevel;
    STRPTR helpfile,reserved,inputstr;
    APTR input;
    struct SignalSemaphore *mysem;
    STRPTR filter;
    struct NewBroker *mybroker;
    LONG priority;
    STRPTR popupkey;
    ULONG maxlastinputs;
    struct DiskObject *do;
    BOOL popstate;
    ULONG active,keysig;
    STRPTR rawstring,patstring,dirstring,tool,toolfile;
    ULONG sig1,sig2,defscr;
    APTR savemenu,dosscan,wbpathscan,dtscan;
 /* Hook section */
    struct Hook addtolist,listmove,keylistmove,newshell,execcmd,
                brokerhook,constructhook,destructhook,edithook,
                getfound,aslopenhook,aslclosehook,apphook,
                checkval,megacheck,rexxhook,popclose,windowhook;
};

struct ToolOrder
{
    ULONG order,num;
};

const long ENDALL=0,WHOLE=1,PARTLY=2,NULLSIG=-1,TABKEY=0x42,APPMSG=0x1000

enum errors {EVENNOTHING,NOLIB,NOAPP,NOMEM,NOTOPEN,NOSIG};

enum mn {NOTHING,ABOUT,ABOUTMUI,HIDE,QUIT,SAVE,LOAD,MOREOPTIONS,DOSSCAN};

enum id {ID_NONE,ID_OUTPUT,ID_CURRDIR,ID_STACK,ID_PRIO,ID_SHELLNAME,ID_INFO,
         ID_ASSIGNSCAN,ID_WBPATHSCAN,ID_DTSCAN,ID_FLASHEXEC};

enum dt {LEVEL_NODT,LEVEL_DT45COMP,LEVEL_DT45ORIG};

enum  msg {NOMUILIB,NOICON,NOUTIL,NOCX,NOAPP,NOMEM,REQTITLE,REQGADGET,REQBODY,WBOUTPUT,
           DESCRIPTION,WINTITLE,BODYTEXT,STRINGTEXT,OKAY,CANCEL,HEAVYRECURSION,ABOUTTITLE,
           ABOUTGADGET,ABOUTBODY,FREQTITLE,NOTOPEN,NOWB,NOSIGNAL,ITEMSELECT,INFOMATCH,PRIORITY,
           SHELLNAME,CURRENTDIR,OUTPUT,MOREOPTIONS,
           MENU_PROJECT,MENU_ABOUTMUI,MENU_ABOUT,MENU_HIDE,MENU_QUIT,
           MENU_OPTIONS,MENU_SAVE,MENU_RELOAD,
           KEY_CMD,KEY_OKAY,KEY_CANCEL,KEY_MENU_ABOUTMUI,KEY_MENU_ABOUT,KEY_MENU_HIDE,
           KEY_MENU_QUIT,KEY_MENU_SAVE,KEY_MENU_RELOAD,KEY_MENU_OPTIONS,KEY_ASSIGNSCAN,
           KEY_INFOMATCH,KEY_WBPATHSCAN,KEY_DTSCAN,
           ASSIGNSCAN,NODT45,WBPATHSCAN,SELECTOP,OP_NOTHING,DTSCAN,LASTINPUTS,
           SELECTOP_APPICONIFIED,STACK,MENU_FLASHEXEC,
           KEY_FLASHEXEC,
           /* The limiter */
           MSG_MAX};
