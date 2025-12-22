#include <intuition/intuition.h>
#include <libraries/arpbase.h>
#include <functions.h>
#include <rexx/errors.h>

#include "MRDateReq.h"
#include "minrexx.h"

int             Dispatch();
void            RexxExit(), 
                RexxGetDate(), 
                RexxGetFullDate(),
                RexxGetDayName(), 
                RexxGetFormat(), 
                RexxGetTime(), 
                RexxRequest(),
                RexxSetFullDate(),
                RexxSetFormat(),
                RexxSetPrompt();

void            StrUpper();

int             commandError;
MRDatePacket    *datePacket;
char            firstCommand[256];
int             keepGoing = 1;
static char     prompt[256] = "Enter the date: ";
long            rexxBit;                /* rexx signal bit */

static char *formatNames[FORMAT_MAX + 1] = {
        "DOS", "International", "USA", "Canadian"
    };

struct NewWindow newWindow = {
    20,20,320,140,0,1,

/* IDCMP Flags */

    MENUVERIFY | RMBTRAP | GADGETUP | GADGETDOWN, 

/* Flags */
    WINDOWDRAG,

    NULL,                           /* First gadget */
    NULL,                           /* Checkmark */
    (UBYTE *)"ARexx Date Requester",/* Window title */
    NULL,                           /* No custom streen */
    NULL,                           /* Not a super bitmap window */
    0,0,640,200,                    /* Not used, but set up anyway */
    WBENCHSCREEN
};

struct rexxCommandList rcl[] = {
    { "exit",           (APTR) &RexxExit            },
    { "getdate",        (APTR) &RexxGetDate         },
    { "getfulldate",    (APTR) &RexxGetFullDate     },
    { "getdayname",     (APTR) &RexxGetDayName      },
    { "getformat",      (APTR) &RexxGetFormat       },
    { "gettime",        (APTR) &RexxGetTime         },
    { "request",        (APTR) &RexxRequest         },
    { "setfulldate",    (APTR) &RexxSetFullDate     },
    { "setformat",      (APTR) &RexxSetFormat,      },
    { "setprompt",      (APTR) &RexxSetPrompt       },
    { NULL,             NULL }
    };

struct ArpBase          *ArpBase;
struct GfxBase          *GfxBase;
struct IntuitionBase    *IntuitionBase;

main(argc, argv)
    int     argc;
    char    **argv;
{
static char *arpNotOpen = 
    "The ARP library must be installed in the LIBS: directory!";

    ULONG                   class;
    int                     i;
    char                    *portName;
    struct  IntuiMessage    *wMsg;

    ArpBase = (struct ArpBase *) OpenLibrary(ArpName, ArpVersion);
    if (ArpBase == NULL) {
        Write(Output(), arpNotOpen , (long) sizeof(arpNotOpen));
        goto done;
    }
    GfxBase = (struct GfxBase *) ArpBase->GfxBase;
    IntuitionBase = (struct IntuitionBase *) ArpBase->IntuiBase;

    /* Create and initialize date packet. */

    datePacket = CreateMRDatePacket(NULL, FORMAT_USA, 1);
    if (argc == 2)
        portName = argv[1];
    else
        portName = "mrdatereq";

    rexxBit = upRexxPort(portName, rcl, NULL, &Dispatch);

    while (keepGoing) {
        Wait(rexxBit);
        dispRexxPort();
    }

done:
    dnRexxPort();               /* Dispose of the rexx port. */
}

/*  FUNCTION
        Dispatch - dispatch rexx command.

    SYNOPSIS
        int Dispatch(msg, cmd, parameters)
                     struct RexxMsg         *msg;
                     struct rexxCommandList *cmd;
                     char                   *parameters;

    DESCRIPTION
        Dispatch() invokes the appropriate function for the command
        described by <cmd>, passing it the <msg> and <parameters>.
        It then replies to the <msg> with a result code indicating the
        success or failure of the command.
*/

int
Dispatch(msg, cmd, params)
    struct RexxMsg          *msg;
    struct rexxCommandList  *cmd;
    char                    *params;
{
    commandError = 0;
    while (*params == ' ') ++params;
    /* Dispatch to the user's function. */
    ( (int (*)() )(cmd->userdata))(msg, params);
    if (commandError) {             /* We got an error. */
        replyRexxCmd(msg, (long) commandError, 0L, NULL);
    }
    return 0;                       /* Return value isn't used! */
}

/*  FUNCTION
        RexxExit - process an exit command.

    SYNOPSIS
        void RexxExit(msg, p)
                      struct RexxMsg    *msg;
                      char              *p;

    DESCRIPTION
        RexxExit() is called when the macro sends an 'exit' command.
        This function simply clears the keepGoing flag, terminating
        this program.
*/

void
RexxExit(msg, p)
    struct RexxMsg  *msg;
    char            *p;
{
    keepGoing = 0;
}

/*  FUNCTION
        RexxGetDate - retrieve the formatted date string.

    SYNOPSIS
        void RexxGetDate(msg, p)
                         struct RexxMsg *msg;
                         char           *p;

    DESCRIPTION
        RexxGetDate is invoked with the macro issues a 'getdate' command.
        This is normally done after a 'request' command. The text string
        representing the date component (not time) is returned via the
        result variable. 
*/

void
RexxGetDate(msg, p)
{
    replyRexxCmd(msg, 0L, 0L,
        datePacket->ARPDatePacket.dat_StrDate);
}

/*  FUNCTION
        RexxGetFullDate - define a compound symbol with all date components.

    SYNOPSIS
        void RexxGetFullDate(msg, p)
                             struct RexxMsg *msg;
                             char           *p;

    DESCRIPTION
        RexxGetFullDate is invoked when the macro program issues a
        'getfulldate' command. The string pointed to by <p> is used as
        the stem for a compound variable. The components of this variable
        are:
                1 - Year    (19XX)
                2 - Month   (1 - 12)
                3 - Day     (1 - 31)
                4 - Hour    (00 - 59)
                5 - Minute  (00 - 59)
                6 - Second  (00 - 59)
                7 - Weekday (0 - 6, 0 => Sunday)

        For example, assuming a stem variable name of "mydate" and a
        date selection of 5-Oct-1989, 
            mydate.1 == 1989
            mydate.2 == 10
            mydate.3 == 5
            ...and so on.

        If a failure is detected, the result variable will contain a
        descriptive message on exit.
*/

void
RexxGetFullDate(msg, p)
    struct RexxMsg  *msg;
    char            *p;
{
    LONG        error;
    int         i;
    int         nValue;
    char        fullSym[256];
    char        value[81];

    for (i = 1; i <= 7; ++i) {
        switch (i) {
        case 1:
            nValue = datePacket->newDate.Dyear;
            break;
        case 2:
            nValue = datePacket->newDate.Dmonth;
            break;

        case 3:
            nValue = datePacket->newDate.Dday;
            break;

        case 4:
            nValue = datePacket->newDate.Dhour;
            break;

        case 5:
            nValue = datePacket->newDate.Dminute;
            break;

        case 6:
            nValue = datePacket->newDate.Dsecond;
            break;

        case 7:
            nValue = datePacket->newDate.Dweekday;
        }
 
        sprintf(fullSym, "%s.%d", p, i);
        StrUpper(fullSym);
        sprintf(value, "%d", nValue);
        if (error = SetRexxVar(msg, fullSym, value, strlen(value)) ) {
            sprintf(value, "Failed to set date component '%s'", fullSym);
            replyRexxCmd(msg, error, 0L, value);
            break;
        }
    }         
}

/*  FUNCTION
        RexxGetDayName - get the day name for the selected date.

    SYNOPSIS
        void RexxGetDayName(msg, p)
                            struct RexxMsg  *msg;
                            char            *p;

    DESCRIPTION
        RexxGetDayName is invoked when the macro program issues a
        'getdayname' command. This is normally done after the 'request'
        command has been issued. The full name of the day (Monday, Tuesday,
        etc.) is returned via the result variable.
*/

void
RexxGetDayName(msg, p)
    struct RexxMsg  *msg;
    char            *p;
{
    replyRexxCmd(msg, 0L, 0L,
        datePacket->ARPDatePacket.dat_StrDay);
}

/*  FUNCTION
        RexxGetFormat - get the date format name string.

    SYNOPSIS
        void RexxGetFormat(msg, p)
                           struct RexxMsg   *msg;
                           char             *p;

    DESCRIPTION
        RexxGetFormat is called when the macro program issues a
        'getdateformat' command. A name string describing the date
        format is returned via the result variable. The current format
        names are:

                "DOS"           - DD-MMM-YYYY
                "International" - YY/MM/DD
                "USA"           - MM/DD/YY 
                "Canadian"      - DD/MM/YY
*/            
void
RexxGetFormat(msg, p)
    struct RexxMsg  *msg;
    char            *p;
{
    replyRexxCmd(msg, 0L, 0L, 
        formatNames[datePacket->ARPDatePacket.dat_Format]);
}

/*  FUNCTION
        RexxGetTime - get the time component of the selected date.

    SYNOPSIS
        void RexxGetTime(msg, p)
                         struct RexxMsg *msg;
                         char           *p;

    DESCRIPTION
        RexxGetTime is invoked when the macro program issues a
        'gettime' command, normally after a 'request' command.
        The time component of the date is returned via the result
        variable formatted as "HH:MM:DD".
*/

void
RexxGetTime(msg, p)
    struct RexxMsg  *msg;
    char            *p;
{
    replyRexxCmd(msg, 0L, 0L,
        datePacket->ARPDatePacket.dat_StrTime);
}

/*  FUNCTION
        RexxRequest - pop up the date requester and wait for user input.

    SYNOPSIS
        void RexxDateRequest(msg, p)
                             struct RexxMsg *msg;
                             char           *p;

    DESCRIPTION
        RexxDateRequest is invoked when the macro program issues a 'request'
        command. A new window is first opened, then the date requester is
        displayed in the window. The result code variable, rc, and the
        result string, result, will contain information if the request
        fails.
*/

void
RexxRequest(msg, p)
    struct RexxMsg  *msg;
    char            *p;
{
    long result = 0;
    struct Window           *window;

    window = OpenWindow(&newWindow);
    if (! window )
        result = RC_FATAL;
    else {
        datePacket->window = window;
        datePacket->prompt = prompt;

        if (MRDateRequest(datePacket) )
            result = RC_WARN;
        CloseWindowSafely(window, FALSE);
        datePacket->window = NULL;
    }
    if (result)
        replyRexxCmd(msg, result, 0L, "Date request failed!");
}

/*  FUNCTION
        RexxSetFullDate - set all date components.

    SYNOPSIS
        void RexxSetFullDate(msg, p)
                             struct RexxMsg *msg;
    DESCRIPTION
        RexxSetFullDate() is invoked when the macro program issues a
        'setfulldate' command. The parameter, <p>, is expected to point
        to the base name of a compound variable. The elements of this
        variable are expected to conform to the layout expected by
        RexxGetFullDate(). Only elements 1-6 are used, since the day of
        the week is implicit in the other components.
*/

void
RexxSetFullDate(msg, p)
    struct RexxMsg  *msg;
    char            *p;
{
    LONG        error;
    int         i;
    int         nValue;
    char        result[81];
    char        *symValue;
    char        fullSym[81];

    for (i = 1; i <= 6; ++i) {
        sprintf(fullSym, "%s.%d", p, i);
        StrUpper(fullSym);
        if (error = GetRexxVar(msg, fullSym, symValue)) {
            sprintf(result, "Failed to get date component '%s'", fullSym);
            replyRexxCmd(msg, error, 0L, result);
            break;
        }
        nValue = Atol(symValue);
        switch (i) {
        case 1:
            datePacket->newDate.Dyear = nValue;
            break;
        case 2:
            datePacket->newDate.Dmonth = nValue;
            break;

        case 3:
            datePacket->newDate.Dday = nValue;
            break;

        case 4:
            datePacket->newDate.Dhour = nValue;
            break;

        case 5:
            datePacket->newDate.Dminute = nValue;
            break;

        case 6:
            datePacket->newDate.Dsecond = nValue;
            break;
        }
    }         
}

/*  FUNCTION
        RexxSetFormat - set the desired date format.

    SYNOPSIS
        void RexxSetFormat(msg, p)
                           struct RexxMsg   *msg;
                           char             *p;

    DESCRIPTION
        RexxSetFormat is invoked when the macro program issues a
        'setformat' command. The string parameter, <p>, is expected to
        point to a format name string (or unique prefix of one), as
        described under RexxGetFormat. Example:

            'setformat' "Int"

        causes the date format to be set to "International".
*/

void
RexxSetFormat(msg, p)
    struct RexxMsg  *msg;
    char            *p;
{
    long    length;
    int     result = RC_ERROR;

    int     i;

    while (*p == ' ') ++p;          /* Throw away leading blanks. */
    length = strlen(p);
    for (i = 0; i <= FORMAT_MAX; ++i) {
        if (! Strncmp(p, formatNames[i], length)) {
            result = 0;
            datePacket->ARPDatePacket.dat_Format = i;
            break;
        }
    }
    commandError = result;
}

/*  FUNCTION
        RexxSetPrompt - set date requester prompt string.

    SYNOPSIS
        void RexxSetPrompt(msg, p)
                           struct RexxMsg   *msg;
                           char             *p;

    DESCRIPTION
        RexxSetPrompt() copies the text pointed to by <p> into the package
        prompt variable. The next time RexxRequestDate is called, the prompt
        will be displayed in the date requester.
*/
void
RexxSetPrompt(msg, p)
              struct RexxMsg    *msg;
              char              *p;
{
    if (p) strcpy(prompt, p);
    else *prompt = '\0';
}

/*  FUNCTION
        StrUpper - convert string to upper case.

    SYNOPSIS
        void StrUpper(string)
                      char *string;

    DESCRIPTION
        StrUpper converts all lower case characters in <string> to
        upper case.  The conversion is done in-place.
*/

void
StrUpper(string)
    char *string;
{
    char    *p;

    for (p = string; *p; ++p) *p = toupper(*p);
}
