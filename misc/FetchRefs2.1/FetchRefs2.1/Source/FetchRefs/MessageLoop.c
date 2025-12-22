/* MessageLoop.c
Originaly written by Anders Melchiorsen, modified by Roland Florac
Handles the messages received by FetchRefs (Commodities, ARexx, Break)
Modified from the original version for the ARexx interface */

#include "FetchRefs.h"
#include <proto/rexxsyslib.h>

static void __regargs traiter_message_ARexx (struct RexxMsg * message);

struct Library *CxBase;
struct MsgPort *CxPort, * rexxPort;
CxObj *FRBroker;

char *RexxHostName;

struct ListViewNode {

/* ln_name in the Node points to the string that is to be shown in the
 * listview. ln_type is 1 for file references, 2 for normal ones.
 *
 * fileentry is a pointer to the FileEntry in which the reference is
 *
 * refsentry is a pointer to the reference to fetch.
 *
 * ListViewText is used if we build a new string for the listview.
 */

    struct Node node;
    struct FileEntry *fileentry;
    struct RefsEntry *refsentry;
    UBYTE ListViewText[0];
};

/* MessageLoop() - main loop waits for Cx, ARexx, or ^C */
void MessageLoop (void)
{
    /* Main loop - process ARexx commands until we receive a ^C signal */
    for(;;)
    {
	LONG mask;

	mask = Wait (SIGBREAKF_CTRL_C | (1 << rexxPort->mp_SigBit) | (1 << CxPort->mp_SigBit));

	/* FR_QUIT will signal FindTask(NULL) with ^C. Naturally, a ^C may
	 * also be sent by external means like C:Break or anything else.
	 */
	if (mask & SIGBREAKF_CTRL_C)
	    return;

	/* We received an ARexx message. We use the DICE interface to process
	 * it. ProcessRexxCommands() will in turn call the DoRexxCommand()
	 * below.
	 */
	if (mask & (1 << rexxPort->mp_SigBit))
	{   struct RexxMsg * message;
	    while (message = (struct RexxMsg *) GetMsg (rexxPort))
		traiter_message_ARexx (message);
	}

	/* Handle Commodities message */
	if (mask & (1 << CxPort->mp_SigBit))
	    HandleCxMessage ();
    }
}

/* The theory of parsing the messages is based on a two pass ReadArgs() parsing.
 *
 * First the entire message is parsed against RexxArgStr, and as all commands
 * are postfixed by /F the entire rest of the line is considered to be the
 * parameter of this single command. If an unrecognised keyword is entered then
 * everything is considered a parameter to DUMMY (as it's the first one); thus
 * out-of-context commands are flushed out here.
 *
 * Having had ReadArgs() put everything but the command name into a string, we
 * can parse this against a template which differs for each command, but as all
 * the templates are in an array we simply need one ReadArgs() call along with
 * the right offset into this array (which is determined by what the command
 * was). After having parsed again (but only if it's a succes), a switch can
 * decide what actions should be made with the parameters parsed last - which
 * depends on what the first parsing resulted in.
 *
 * As clear as mud, right? Anyway, I like it :-).
 *
 * (And later I learned about ARexxBox... :-).
 */

/* Templates used by ARexx interface */
UBYTE RexxArgStr[] = "FR_DUMMY/F,FR_QUIT/F,FR_GET/F,FR_CLEAR/F,FR_NEW/F,FR_ADD/F,FR_FILE/F,FR_REQ/F";

STRPTR RexxTemplates[] = {
/* FR_DUMMY */	NULL,
/* FR_QUIT  */	NULL,
/* FR_GET   */	"FIND/A,TO/A,PUBSCREEN,FILEREF/S,CASE/S",
/* FR_CLEAR */	NULL,
/* FR_NEW   */	"FILE/M",
/* FR_ADD   */	"FILE/M",
/* FR_FILE  */	"FIND/A,CASE/S",
/* FR_REQ   */	"FIND/A,TO/A,PUBSCREEN,FILEREF/S,CASE/S"
};

/* The following routine is called everytime we receive an ARexx msg.
 * Depending on what the message was, different actions are performed.
 */
static __regargs LONG DoRexxCommande (void *msg, char *arg0)
{
    struct FindRefReturnStruct RetCode = { RET_OKAY, 0 };
    UBYTE str[256];

    struct RDArgs *RexxArgs, *ArgsArgs;
    STRPTR RexxResult[sizeof(RexxTemplates) / sizeof(RexxTemplates[0])];
    STRPTR ArgsResult[10];

    /* Flush out garbage as ReadArgs() allows for pre-initialized values */
    setmem (RexxResult, sizeof(RexxResult), 0);
    setmem (ArgsResult, sizeof(ArgsResult), 0);

    /* ReadArgs() needs a '\n' at the end of its strings :-( */
    strcpy (str, arg0);
    strcat (str, "\n");

    if ((RexxArgs = AllocDosObject (DOS_RDARGS, NULL)) && (ArgsArgs = AllocDosObject (DOS_RDARGS, NULL)))
    {
	RexxArgs->RDA_Source.CS_Buffer = str;
	RexxArgs->RDA_Source.CS_Length = strlen(str);
	RexxArgs->RDA_Flags = RDAF_NOPROMPT;
	if (ReadArgs (RexxArgStr, (LONG *) RexxResult, RexxArgs))
	{
	    LONG argno;

	    /* Figure out which command we got */
	    for (argno = 0;  ! RexxResult[argno];  argno++);

	    /* If a template is specified: parse the arguments */
	    if (RexxTemplates[argno])
	    {
		/* We still have to add '\n' to the string due to ReadArgs() */
		strcpy (str, RexxResult[argno]);
		strcat (str, "\n");

		/* Now parse the arguments to whatever the command is */
		ArgsArgs->RDA_Source.CS_Buffer = str;
		ArgsArgs->RDA_Source.CS_Length = strlen(str);
		ArgsArgs->RDA_Flags = RDAF_NOPROMPT;
		if (!(ReadArgs (RexxTemplates[argno], (LONG *)ArgsResult, ArgsArgs)))
		{
		    RetCode.Result = RET_FAULT;
		    RetCode.Number = IoErr();
		}
	    }

	    /* If ReadArgs() failed the return code is changed (above) and
	     * therefore the switch() will only be executed if everything
	     * is allright so far.
	     */
	    if (RetCode.Result == RET_OKAY)
		switch (argno)
		{
		    case FR_DUMMY:
			RetCode.Result = RET_FAULT;
			RetCode.Number = ERROR_REQUIRED_ARG_MISSING;
		    break;

		    case FR_QUIT:
			Signal (FindTask(NULL), SIGBREAKF_CTRL_C);
		    break;

		    case FR_GET:
		    case FR_REQ:
		    {
			struct FindRefOptions FindOpts;
			FindOpts.Reference = ArgsResult[0];
			FindOpts.DestFile = ArgsResult[1];
			FindOpts.PubScreen = ArgsResult[2];
			FindOpts.FileRef = (BOOL) ArgsResult[3];
			FindOpts.function = argno;
			FindOpts.Case = (BOOL) ArgsResult[4];

			FindRef (&FindOpts, &RetCode);
		    }
		    break;

		    case FR_CLEAR:
			FreeRefs();
		    break;

		    case FR_NEW:
			FreeRefs();

			/* FR_NEW falls through to FR_ADD. Naturally this requires
			 * them to have the same templates. */

		    case FR_ADD:
			ReadWild ((STRPTR (*)[]) ArgsResult[0]);
		    break;

		    case FR_FILE:
		    {
			struct FindRefOptions FindOpts;

			FindOpts.Reference = ArgsResult[0];
			FindOpts.Case = (BOOL) ArgsResult[1];
			FindOpts.function = argno;
			FindRef (&FindOpts, &RetCode);
			if (RetCode.Result == RET_MATCH)
			{
			    FreeArgs (RexxArgs);
			    FreeDosObject (DOS_RDARGS, RexxArgs);
			    SetRexxVar (msg, "RC2", FindOpts.Reference, strlen(FindOpts.Reference));
			    FreeVec (FindOpts.Reference);
			    return RETURN_OK;
			}
		    }
		    break;
		}
	}
	else
	{
	    RetCode.Result = RET_FAULT;
	    RetCode.Number = IoErr();
	}

	FreeArgs (ArgsArgs);
	FreeDosObject (DOS_RDARGS, ArgsArgs);
    }
    else
    {
	RetCode.Result = RET_FAULT;
	RetCode.Number = ERROR_NO_FREE_STORE;
    }

    if (RexxArgs)
    {
	FreeArgs (RexxArgs);
	FreeDosObject (DOS_RDARGS, RexxArgs);
    }

    /* Find out what the secondary (RC2) return code should be. This is,
     * of course, dependent on the primary (RC) return code.
     */
    switch (RetCode.Result)
    {
	case RET_MATCH:
	    SPrintf (str, "%ld", RetCode.Number);
	break;

	case RET_NO_MATCH:
	    strcpy (str, GetString (TEXTE_NOREF));
	break;

	case RET_ABORT:
	    strcpy (str, GetString (TEXTE_ABORT));
	break;

	case RET_FAULT:
	    Fault (RetCode.Number, "FetchRefs", str, 256);
	break;
    }
    SetRexxVar (msg, "RC2", str, strlen(str));

    /* Set the return code (RC) to 0, 5, 10 or 20 */
    if ((RetCode.Result == RET_OKAY) || (RetCode.Result == RET_MATCH))
	return RETURN_OK;
    else if (RetCode.Result == RET_ABORT)
	return RETURN_WARN;
    else if (RetCode.Result == RET_NO_MATCH)
	return RETURN_ERROR;
    else
	return RETURN_FAIL;
}

static void __regargs traiter_message_ARexx (struct RexxMsg * message)
{   if (message->rm_Node.mn_Node.ln_Type == NT_REPLYMSG)    /* really usefull ? */
    {	DeleteArgstring (message->rm_Args[0]);
	DeleteRexxMsg (message);
	return;
    }
    message->rm_Result2 = 0;
    message->rm_Result1 = DoRexxCommande (message, message->rm_Args[0]);
    ReplyMsg ((struct Message *) message);
}

/* HandleCxMessage() - take care of any Cx message */
void HandleCxMessage (void)
{
    CxMsg *msg;

    while (msg = (CxMsg *) GetMsg (CxPort))
    {
	ULONG msg_id = CxMsgID(msg), msg_type = CxMsgType(msg);

	ReplyMsg ((struct Message *) msg);

	if (msg_type == CXM_COMMAND)
	    switch (msg_id)
	    {
		case CXCMD_DISABLE:
		    ActivateCxObj (FRBroker, FALSE);
		break;

		case CXCMD_ENABLE:
		    ActivateCxObj (FRBroker, TRUE);
		break;

		case CXCMD_KILL:
		    Signal (FindTask (NULL), SIGBREAKF_CTRL_C);
		break;
	    }
    }
}


/* InstallCx() - set up the Commodities Broker */
void __regargs InstallCx (STRPTR name)
{   static struct NewBroker fr_broker =
    {
	NB_VERSION,
	NULL,
	0,
	0,
	NULL,
	NULL,
	0, NULL, 0
    };

    fr_broker.nb_Descr = GetString (TEXTE_RECHERCHE);
    fr_broker.nb_Title = GetString (TEXTE_VERSION);

    if (CxBase = OpenLibrary ("commodities.library", 37))
    {
	if (CxPort = CreateMsgPort())
	{
	    fr_broker.nb_Name = name;
	    fr_broker.nb_Port = CxPort;

	    if (FRBroker = CxBroker (&fr_broker, NULL))
		ActivateCxObj (FRBroker, TRUE);
	}
    }
}

/* RemoveCx() - remove the Commodities Broker if it was set up */
void RemoveCx (void)
{   if (FRBroker)
	DeleteCxObjAll (FRBroker);
    DeleteMsgPort (CxPort);
    CloseLibrary (CxBase);
}
