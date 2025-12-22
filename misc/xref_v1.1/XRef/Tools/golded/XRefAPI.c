/*
** $PROJECT: XRef-GoldEDAPI
**
** $VER: xrefapi.c 1.4 (16.09.94) 
**
** by
**
** Stefan Ruppert , Windthorststraße 5 , 65439 Flörsheim , GERMANY
**
** (C) Copyright 1994
** All Rights Reserved !
**
** $HISTORY:
**
** 16.09.94 : 001.004 :  some internal improvements
** 13.09.94 : 001.003 :  select window added
** 12.09.94 : 001.002 :  rexx command implemented
** 11.09.94 : 001.001 :  initial
*/

/* ------------------------------- include -------------------------------- */

#include "/source/Def.h"

#include <rexx/errors.h>

#include "/lib/xrefsupport.h"

#include "golded:api/include/golded.h"

#include "xrefapi_rev.h"

/* ------------------------------- AutoDoc -------------------------------- */

/*FS*/ /*"AutoDoc"*/
/*GB*** XRef-Tools/XRefAPI ***************************************************

$VER: XRefAPI.doc

NAME
    XRefAPI - GoldED API client for use with the xref.library to complete
              phrases

FUNCTION
    Just run GoldED and load this as an API-Client ! Then you have the
    following new ARexx command :

TEMPLATE
    XREFPHRASE CATEGORY/K,TYPES/K,MATCH/K,COMPLETEBEGIN/S,UPPERCASE/S,
               SPACE/S

FORMAT
    XREFPHRASE [CATEGORY <string|pattern>] [TYPES <to search for>]
               [MATCH matchmode] [COMPLETEBEGIN] [UPPERCASE] [SPACE]



FUNCTION
    the XREFPHRASE command tries to complete the current pharse (before 
    the cursor) with the entries from the xref.library. This is done by
    two algorithms :
        - First uppercase letter match :
            This means each character in the phrase must match the
            next uppercase letter in the name ! For example :
            the pharse "ow" matches "OpenWindow()" ("O"pen"W"indow())
        - Second begin match :
            The entry must match the beginning of the phrase !
    There is a automatic two switch between to algorithms :
        - if the pharse consists only of lower case letters the
          uppercase letter match algorithm is used !
        - if in the pharse is a uppercase letter the begin match
          algorithm is used !
    Note the matchmode RECURSIVE uses only the begin match algorithm !

INPUTS
    CATEGORY (STRING) - category string|pattern to search in

    TYPES (STRING) - types, which would only match ("function","struct",
        "function|struct" or so on)

    MATCH (STRING) - one of the following three matchmode strings 
        (default is FIRST) :
        FIRST - always get the first entry, which match the given pharse
        RECURSIVE - much like a Tab-Completion algorithm, it search for
            all entries matches the given phrase and complete it to the
            last character equal to all entries ! If you pass UPPERCASE
            argument the search is case-insenitive !
            If you pass the phrase you passed last and cannot be more
            completed, it switches to the SELECT matchmode and displays
            the window !
            This mode uses everytime the begin match algorithm !!!
        SELECT - it searchs for all entries matching the given phrase and
            if more than one is found, it opens a window you can select
            one !

    COMPLETEBEGIN (BOOLEAN) - use the begin match algorithm instead of
        uppercase letter match !

    UPPERCASE (BOOLEAN) - convert the phrase to upper

    SPACE (BOOLEAN) - if a name is found and inserted place a space behind

RESULTS
    the command returns RC_OK, if it could complete the pharse. RC_WARN
    if not !

EXAMPLE
    'XREFPHRASE CATEGORY #?AutoDoc TYPES "function"' :

    This command will parse all AutoDoc categories and compare the given
    shortcut with any function found in the xreffiles.For example the two
    letters "ow" will completed to "OpenWindow(", if you have the
    sys_autodoc.xref installed from the XRef-System package !

SEE ALSO
    XRef-System.guide, GoldED/API, xref.library/ParseXRef(), ParseXRef

*****************************************************************************/
/*FE*/

/* ------------------------------- defines -------------------------------- */

/*FS*/ /*"Defines"*/
#define BUFFER_LEN         512

enum {
   COMPLETE_UPPERCASELETTER,     /* complete phrase using characters as upper
                                  * case letters only in the string
                                  */
   COMPLETE_BEGIN,               /* comlete phrase using given WORD as the
                                  * beginning of the WORD
                                  */
   COMPLETE_BEGIN_NOCASE,        /* same as COMPLETE_BEGIN, but case-insensitive
                                  */
   COMPLETE_RECURSIVE,           /* tab-completion like algrorithm */
   COMPLETE_RECURSIVE_NOCASE,    /* same as COMPLETE_RECURSIVE, case-insensitive */

   };


enum {
   MATCH_FIRST,
   MATCH_RECURSIVE,
   MATCH_SELECT,
   };

#define XREFPHRASE_ARGS          "CATEGORY/K,TYPES/K,MATCH/K,COMPLETEBEGIN/S,UPPERCASE/S,SPACE/S"

#define MAX_PARAMETER            6

#define EOS                      '\0'

#define USETAG(tag,check)        ((check) ? (tag) : TAG_IGNORE)

#define PUDDLE_SIZE              512

#define XDISTANCE                8
#define YDISTANCE                4

/*FE*/

/* ----------------------------- structures ------------------------------- */

/*FS*/ /*"Structures"*/
struct RexxCommands
{
   STRPTR rxc_Command;
   LONG (*rxc_Handler) (struct GlobalData *,struct APIMessage *);
   STRPTR rxc_Template;
};

struct GlobalData
{
   struct MsgPort *gd_ApiPort;
   struct MsgPort *gd_RexxPort;

   STRPTR gd_GoldEDHost;

   ULONG gd_Result;
   ULONG gd_Mode;
   ULONG gd_Match;
   LONG gd_Found;

   APTR gd_FoundPool;
   struct List gd_FoundList;

   struct Hook gd_Hook;

   ULONG gd_Para[MAX_PARAMETER];

   UBYTE gd_Buffer[BUFFER_LEN];
   UBYTE gd_Name[BUFFER_LEN];
   UBYTE gd_LastName[BUFFER_LEN];

   struct Library *gd_XRefBase;
};

#define XRefBase     gd->gd_XRefBase
/*FE*/

/* ------------------------------ prototypes ------------------------------ */

/*FS*/ /*"Prototypes"*/
RegCall GetA4 ULONG hook(REGA0 struct Hook *hook,REGA2 struct XRefFileNode *xref,REGA1 struct xrmXRef *msg);

void search_command(struct GlobalData *gd,struct APIMessage *msg);

LONG RexxCmd_XRefPhrase(struct GlobalData *gd,struct APIMessage *msg);

BOOL alloc_name(struct GlobalData *gd,STRPTR name);

BOOL send_rexxcommand(struct GlobalData *gd,STRPTR cmd);

struct Node *select_node(struct List *list,struct Screen *screen);

void parse_typestring(STRPTR typestr,ULONG *typearray);


/*FE*/

/* -------------------------- static data items --------------------------- */

/*FS*/ /*"Contants"*/
static const STRPTR version = VERSTAG;
static const STRPTR prgname = "XRefAPI";

static struct RexxCommands rexxcmd[] = {
   {"XREFPHRASE",RexxCmd_XRefPhrase,XREFPHRASE_ARGS},
   {NULL}};

static const STRPTR xreftype_names[XREFT_MAXTYPES] = {
   "generic",
   "function",
   "command",
   "include",
   "macro",
   "struct",
   "field",
   "typedef",
   "define"};

static struct TagItem xrefapitags[] = {
   {API_Client_Name       ,(ULONG) "XRefAPI"},
   {API_Client_Copyright  ,(ULONG) "©1994 Stefan Ruppert"},
   {API_Client_Purpose    ,(ULONG) VERS "\n\nPhrase completion with xref.library"},
   {API_Client_Template   ,(ULONG) "XREFPHRASE " XREFPHRASE_ARGS},
   {TAG_DONE,}};

static STRPTR matchmodes[] = {
   "FIRST",
   "RECURSIVE",
   "SELECT",
   NULL};
/*FE*/

/* ------------------------- template definition -------------------------- */

/*FS*/ /*"Program Template"*/
#define template    "HOST/K/A"

enum {
   ARG_HOST,
   ARG_MAX};
/*FE*/

/* --------------------------- main entry point --------------------------- */

/*FS*/ /*"int main(void)"*/
int main(void)
{
   struct RDArgs *args;
   LONG para[ARG_MAX];
   STRPTR obj = prgname;
   LONG err = 0;

   LONG i;

   /* clear args buffer */
   for(i = 0 ; i < ARG_MAX ; i++)
      para[i] = 0;

   /* here set your defaults : para[ARG_#?] = default_value; */

   if(args = ReadArgs(template,para,NULL))
   {
      struct GlobalData *gd;     

      DB(("golded host : %s\n",para[ARG_HOST]));
      if((gd = AllocMem(sizeof(struct GlobalData),MEMF_ANY | MEMF_CLEAR)))
      {
         if((gd->gd_ApiPort = CreateMsgPort()))
         {
            if((gd->gd_RexxPort = CreateMsgPort()))
            {
               gd->gd_GoldEDHost   = (STRPTR)   para[ARG_HOST];
               gd->gd_Hook.h_Entry = (HOOKFUNC) hook;
               gd->gd_Hook.h_Data  = gd;

               sprintf(gd->gd_Buffer,"API PORT=%ld MASK=%ld",
                                     gd->gd_ApiPort,
                                     API_CLASS_ROOT | API_CLASS_REXX);

               if(send_rexxcommand(gd,gd->gd_Buffer) && gd->gd_Result == RC_OK)
               {
                  struct APIMessage *apimsg;
                  struct APIMessage *msg;

                  BOOL active = TRUE;

                  DB(("xrefapi active !\n"));

                  do
                  {
                     WaitPort(gd->gd_ApiPort);

                     while((apimsg = (struct APIMessage *) GetMsg(gd->gd_ApiPort)))
                     {
                        for(msg = apimsg ; msg ; msg = msg->api_Next)
                        {
                           if(msg->api_State == API_STATE_NOTIFY)
                           {
                              switch(msg->api_Class)
                              {
                              case API_CLASS_ROOT:
                                 switch(msg->api_Action)
                                 {
                                 case API_ACTION_DIE:
                                    active = FALSE;
                                    break;
                                 case API_ACTION_INTRODUCE:
                                    msg->api_Data = xrefapitags;
                                    break;
                                 }
                                 break;
                              case API_CLASS_REXX:
                                 switch(msg->api_Action)
                                 {
                                 case API_ACTION_COMMAND:
                                    search_command(gd,msg);
                                    break;
                                 default:
                                    msg->api_Error = API_ERROR_UNKNOWN;
                                 }
                                 break;
                              default:
                                 msg->api_Error = API_ERROR_UNKNOWN;
                              }
                           }
                        }

                        ReplyMsg((struct Message *) apimsg);
                     }
                  } while(active);
                  SetIoErr(0);
               }   
               DeleteMsgPort(gd->gd_RexxPort);
            }
            DeleteMsgPort(gd->gd_ApiPort);
         }
         FreeMem(gd,sizeof(struct GlobalData));
      }
      FreeArgs(args);
   }

   if(!err)
      err = IoErr();

   if(err)
   {
      PrintFault(err,obj);
      return(RETURN_ERROR);
   }

   return(RETURN_OK);
}
/*FE*/

/* ---------------------- search for a given command ---------------------- */

/*FS*/ /*"void search_command(struct GlobalData *gd,struct APIMessage *msg)"*/
void search_command(struct GlobalData *gd,struct APIMessage *msg)
{
   struct APIRexxNotify *notify = (struct APIRexxNotify *) msg->api_Data;
   struct RexxCommands  *rxcmd  = rexxcmd;
   LONG len;

   notify->arn_RC = RC_WARN;

   while(rxcmd->rxc_Command)
   {
      len = strlen(rxcmd->rxc_Command);

      if(!strncmp(notify->arn_Command,rxcmd->rxc_Command,len))
      {
         struct RDArgs *rdargs;
         struct RDArgs *args;
         LONG i;

         msg->api_State = API_STATE_CONSUMED;

         strncpy(gd->gd_Buffer,&notify->arn_Command[len],BUFFER_LEN);
         strncat(gd->gd_Buffer,"\n",BUFFER_LEN);

         if(rdargs = (struct RDArgs *) AllocDosObject(DOS_RDARGS,NULL))
         {
            rdargs->RDA_Source.CS_Buffer   = gd->gd_Buffer;
            rdargs->RDA_Source.CS_Length   = strlen(gd->gd_Buffer);

            for(i=0 ; i < MAX_PARAMETER ; i++)
               gd->gd_Para[i]=0;

            DB(("rdargs at : %lx\n",rdargs));
            
            if((args = ReadArgs(rxcmd->rxc_Template,(LONG *) gd->gd_Para,rdargs)))
            {
               DB(("args at %lx\n",args));

               notify->arn_RC = rxcmd->rxc_Handler(gd,msg);

               FreeArgs(args);
            }
            FreeDosObject(DOS_RDARGS , rdargs);
         }
      }
      rxcmd++;
   }

   if(notify->arn_RC != RC_OK)
   {
      Fault(IoErr(),"XRefAPI",gd->gd_Buffer,BUFFER_LEN);
      notify->arn_CommandError = gd->gd_Buffer;
   }
}
/*FE*/

/* ----------------------- xrefphrase rexx command ------------------------ */

/*FS*/ /*"LONG RexxCmd_XRefPhrase(struct GlobalData *gd,struct APIMessage *msg)"*/

/* templates arguments */
enum {
   ARG_CATEGORY,
   ARG_TYPES,
   ARG_MATCH,
   ARG_COMPLETEBEGIN,
   ARG_UPPERCASE,
   ARG_SPACE,
   };

LONG RexxCmd_XRefPhrase(struct GlobalData *gd,struct APIMessage *msg)
{

   struct EditConfig *config = msg->api_Config;
   LONG *para = gd->gd_Para;
   ULONG types[XREFT_MAXTYPES + 1];

   UWORD  column;
   UWORD len;
   STRPTR wrd;
   STRPTR buf;
   STRPTR ptr;
   STRPTR ptr2;
   LONG retval = RC_WARN;

   column = config->Column;
   buf    = config->Current;
   wrd    = gd->gd_Buffer;

   /* terminate the types array */
   types[0] = ~0;

   if(para[ARG_TYPES])
      parse_typestring((STRPTR) para[ARG_TYPES],types);

   if(column && (buf[--column] > '@'))
   {
      STRPTR pattern = "#?";
      ULONG xrefmatch = XREFMATCH_PATTERN_CASE;

      len = 1;
      for(ptr = buf + column; column && (*(ptr - 1) > '@') ; --column, --ptr)
         len++;

      movmem(ptr,wrd,len);
      wrd[len] = 0;

      gd->gd_Mode = COMPLETE_UPPERCASELETTER;

      for(ptr2 = wrd; *ptr2 ; ptr2++)
         if(isupper(*ptr2))
         {
            gd->gd_Mode = COMPLETE_BEGIN;
            break;
         }

      if(para[ARG_COMPLETEBEGIN])
         gd->gd_Mode = COMPLETE_BEGIN;

      gd->gd_Match = MATCH_FIRST;
      if(para[ARG_MATCH])
      {
         STRPTR *array = matchmodes;
         ULONG i = MATCH_FIRST;

         while(*array)
         {
            if(!Stricmp(*array,(STRPTR) para[ARG_MATCH]))
            {
               gd->gd_Match = i;
               break;
            }
            i++;
            array++;
         }
         DB(("matchmode : %ld\n",gd->gd_Match));
      }

      if(gd->gd_Match == MATCH_RECURSIVE)
      {
         if(!Stricmp(gd->gd_LastName,gd->gd_Buffer))
         {
            gd->gd_Match = MATCH_SELECT;

            if(para[ARG_UPPERCASE])
               gd->gd_Mode = COMPLETE_BEGIN_NOCASE;
            else
               gd->gd_Mode = COMPLETE_BEGIN;
         } else
         {
            strcpy(gd->gd_LastName,gd->gd_Buffer);

            if(para[ARG_UPPERCASE])
               gd->gd_Mode = COMPLETE_RECURSIVE_NOCASE;
            else
               gd->gd_Mode = COMPLETE_RECURSIVE;
         }
      }

      if(gd->gd_Mode != COMPLETE_UPPERCASELETTER)
      {
         strcat(gd->gd_Buffer,"#?");
         pattern = gd->gd_Buffer;

         if(para[ARG_UPPERCASE])
            xrefmatch = XREFMATCH_PATTERN_NOCASE;
      } else
         for(ptr2 = wrd; *ptr2 ; ptr2++)
            *ptr2 = toupper(*ptr2);

      DB(("word : %s\n",gd->gd_Buffer));

      /* cleanup */
      NewList(&gd->gd_FoundList);
      gd->gd_FoundPool = NULL;
      gd->gd_Found     = 0;

      if((XRefBase = OpenLibrary("xref.library",1)))
      {
         if(ParseXRefTags(pattern,XREFA_XRefHook                               ,&gd->gd_Hook,
                                  XREFA_Matching                               ,xrefmatch,
                                  USETAG(XREFA_Category   ,para[ARG_CATEGORY]) ,para[ARG_CATEGORY],
                                  USETAG(XREFA_AcceptTypes,para[ARG_TYPES])    ,types,
                                  TAG_DONE))
         {
            if(gd->gd_Found > 1 && gd->gd_Match == MATCH_SELECT)
            {
               struct Screen *screen;

               if((screen = LockPubScreen(msg->api_Screen)))
               {
                  struct Node *node;

                  if((node = select_node(&gd->gd_FoundList,screen)))
                  {
                     strcpy(gd->gd_Name,node->ln_Name);
                     gd->gd_Found =  1;
                  } else
                     gd->gd_Found = -1;
                  UnlockPubScreen(NULL,screen);
               }
            }

            if(gd->gd_FoundPool)
            {
               LibDeletePool(gd->gd_FoundPool);
               gd->gd_FoundPool = NULL;
            }

            if(gd->gd_Found == 1)
            {
               UWORD newlen = strlen(gd->gd_Name);

               if(gd->gd_Name[newlen - 1] == ')')
               {
                  gd->gd_Name[newlen - 1] = 0;
                  newlen--;
               }

               if(para[ARG_SPACE])
               {
                  strcat(gd->gd_Name," ");
                  newlen++;
               }

               if(newlen != len)
               {
                  movmem(ptr + len, ptr + newlen, config->CurrentLen - (ptr - buf));

                  config->CurrentLen += (newlen - len);
                  config->Column     += (newlen - len);

                  while(config->Column > config->CurrentLen)
                     buf[(config->CurrentLen)++] = ' ';
               }

               movmem(gd->gd_Name, ptr, newlen);

               msg->api_Refresh |= API_REFRESH_LINE;

               retval = RC_OK;
            } else if(gd->gd_Found == 0)
               SetIoErr(ERROR_OBJECT_NOT_FOUND);
            else if(gd->gd_Found == -1)
               SetIoErr(ERROR_BREAK);
         }
         CloseLibrary(XRefBase);
      }
   } else
      SetIoErr(ERROR_REQUIRED_ARG_MISSING);

   return(retval);
}
/*FE*/

/* ------------------ callback function for ParseXRef() ------------------- */

/*FS*/ /*"ULONG hook(struct Hook *hook,struct XRefFileNode *xref,struct xrmXRef *msg)"*/
RegCall GetA4 ULONG hook(REGA0 struct Hook *hook,REGA2 struct XRefFileNode *xref,REGA1 struct xrmXRef *msg)
{
   struct GlobalData *gd = (struct GlobalData *) hook->h_Data;

   if(msg->Msg == XRM_XREF)
   {
      STRPTR name = (STRPTR) GetTagData(ENTRYA_Name,NULL,msg->xref_Attrs);
      STRPTR ptr;
      STRPTR wrd = gd->gd_Buffer;
      ULONG matched = FALSE;
      ULONG num = 0;
                                      
      if((ptr = name))  
      {
         switch(gd->gd_Mode)
         {
         case COMPLETE_BEGIN:
         case COMPLETE_BEGIN_NOCASE:
            /* anything matches, because xref.library compared for us */
            matched = TRUE;
            break;
         case COMPLETE_UPPERCASELETTER:
            while(*ptr)
            {
               if(isupper(*ptr))
               {
                  if(*wrd)
                  {
                     if(*ptr != *wrd)
                        break;
                     else
                        wrd++;
                  }
                  num++;
               }
               ptr++;
            }
            matched = (*wrd == 0 && num == strlen(gd->gd_Buffer));
            break;
         case COMPLETE_RECURSIVE:
            /* build no memory list, just find out the maximal string, which matches */
            if(gd->gd_Found == 0)
               strcpy(gd->gd_Name,name);
            else
            {
               STRPTR ptr = gd->gd_Name;

               while(*ptr && *ptr == *name)
               {
                  ptr++;
                  name++;
               }

               *ptr = EOS;

            }
            gd->gd_Found = 1;
            break;
         case COMPLETE_RECURSIVE_NOCASE:
            /* build no memory list, just find out the maximal string, which matches */
            if(gd->gd_Found == 0)
               strcpy(gd->gd_Name,name);
            else
            {
               STRPTR ptr = gd->gd_Name;

               while(*ptr && toupper(*ptr) == toupper(*name))
               {
                  ptr++;
                  name++;
               }

               if(*name)
                  gd->gd_Para[ARG_SPACE] = FALSE;

               *ptr = EOS;

            }
            gd->gd_Found = 1;
            break;
         }

         if(matched)
         {
            DB(("found : %s\n",name));

            gd->gd_Found++;

            if(gd->gd_Match == MATCH_FIRST)
            {
               strcpy(gd->gd_Name,name);
               return(1);
            }

            if(gd->gd_Found == 1)
            {
               strcpy(gd->gd_Name,name);
            } else
            {
               if(!gd->gd_FoundPool)
                  gd->gd_FoundPool = LibCreatePool(MEMF_ANY | MEMF_CLEAR,PUDDLE_SIZE,PUDDLE_SIZE);

               if(!gd->gd_FoundPool)
               {
                  return(1);
               } else
               {
                  if(gd->gd_Found == 2)
                     alloc_name(gd,gd->gd_Name);

                  if(!alloc_name(gd,name))
                     gd->gd_Found--;
               }
            }
         }
      }
   }
   return(0);
}
/*FE*/

/* ------------------------- send a Rexx command -------------------------- */

/*FS*/ /*"BOOL send_rexxcommand(struct GlobalData *gd,STRPTR cmd)"*/
BOOL send_rexxcommand(struct GlobalData *gd,STRPTR cmd)
{
   struct MsgPort *rexxport;

   Forbid();

   if((rexxport = FindPort(gd->gd_GoldEDHost)))
   {
      struct RexxMsg *rxmsg;
      struct RexxMsg *answer;

      if((rxmsg = CreateRexxMsg(gd->gd_RexxPort, NULL, NULL)))
      {
         if((rxmsg->rm_Args[0] = CreateArgstring(cmd, strlen(cmd))))
         {
            rxmsg->rm_Action = RXCOMM | RXFF_RESULT;

            PutMsg(rexxport, &rxmsg->rm_Node);

            do
            {
               WaitPort(gd->gd_RexxPort);

               if((answer = (struct RexxMsg *) GetMsg(gd->gd_RexxPort)))
                   gd->gd_Result = answer->rm_Result1;

            } while (!answer);

            Permit();

            if(answer->rm_Result1 == RC_OK)
            {
               if(answer->rm_Result2)
               {
                  if(gd->gd_Buffer)
                      strcpy(gd->gd_Buffer, (char *)answer->rm_Result2);

                  DeleteArgstring((char *)answer->rm_Result2);
               }
            }

            DeleteArgstring((char *)ARG0(answer));

            DeleteRexxMsg(answer);

            return(TRUE);
         }
      }
   }

   Permit();

   return(FALSE);
}
/*FE*/

/* ------------------ allocate memory for a found entry ------------------- */

/*FS*/ /*"BOOL alloc_name(struct GlobalData *gd,STRPTR name)"*/
BOOL alloc_name(struct GlobalData *gd,STRPTR name)
{
   struct Node *node;

   for(node = gd->gd_FoundList.lh_Head ; node->ln_Succ ; node = node->ln_Succ)
      if(!strcmp(node->ln_Name,name))
         break;

   if(node->ln_Succ)
      return(FALSE);

   if((node = LibAllocPooled(gd->gd_FoundPool,sizeof(struct Node) + strlen(name) + 1)))
   {
      node->ln_Name = (STRPTR) (node + 1);
      strcpy(node->ln_Name,name);
      insertbyiname(&gd->gd_FoundList,node);
   }

   return(TRUE);
}
/*FE*/

/* --------------------- select a node out of a list ---------------------- */

/*FS*/ /*"struct Node *select_node(struct List *list,struct Screen *screen)"*/
struct Node *select_node(struct List *list,struct Screen *screen)
{
   struct TextAttr txtattr;
   struct TextFont *font;
   struct Node *selnode = NULL;
   UBYTE fontname[32];

   /* get the screen font */
   txtattr = *screen->Font;

   strncpy(fontname,txtattr.ta_Name,sizeof(fontname));
   txtattr.ta_Name = fontname;

   if((font = OpenFont(&txtattr)))
   {
      struct RastPort rp;
      struct NewGadget ng;
      struct Gadget *glist = NULL;
      struct Gadget *gad;
      struct Node *node;
      ULONG max = 100;
      ULONG x;

      UWORD width;
      UWORD height;
      UWORD num = 0;

      InitRastPort(&rp);
      SetFont(&rp,font);

      for(node = list->lh_Head ; node->ln_Succ ; node = node->ln_Succ)
      {
         if((x = TextLength(&rp,node->ln_Name,strlen(node->ln_Name))) > max)
         {
            max = x;
         }

         num++;
      }

      width  = max + 20 + 16 + 4;
      height = 10 * font->tf_YSize + 4;

      ng.ng_LeftEdge   = XDISTANCE;
      ng.ng_TopEdge    = font->tf_YSize + 1 + YDISTANCE;
      ng.ng_Width      = width;
      ng.ng_Height     = height;
      ng.ng_GadgetText = NULL;
      ng.ng_TextAttr   = &txtattr;
      ng.ng_GadgetID   = 1;
      ng.ng_Flags      = 0;
      ng.ng_VisualInfo = GetVisualInfoA(screen,NULL);
      ng.ng_UserData   = NULL;

      if((gad = CreateContext(&glist)))
      {
         if((gad = CreateGadget(LISTVIEW_KIND,gad,&ng,
                                GTLV_Labels       ,list,
                                GTLV_ShowSelected ,NULL,
                                GTLV_Selected     ,0,
                                TAG_DONE)))


         {
            struct Window *win;

            width  += 2 * XDISTANCE;
            height += 2 * YDISTANCE + font->tf_YSize + 1;

            if((win = OpenWindowTags(NULL,
                                     WA_Title        ,prgname,
                                     WA_Left         ,(screen->Width  - width ) >> 1,
                                     WA_Top          ,(screen->Height - height) >> 1,
                                     WA_Width        ,width,
                                     WA_Height       ,height,
                                     WA_AutoAdjust   ,TRUE,
                                     WA_Gadgets      ,glist,
                                     WA_IDCMP        ,IDCMP_RAWKEY | IDCMP_CLOSEWINDOW | IDCMP_VANILLAKEY | LISTVIEWIDCMP ,
                                     WA_Flags        ,WFLG_CLOSEGADGET | WFLG_DEPTHGADGET | WFLG_DRAGBAR | WFLG_NOCAREREFRESH | WFLG_ACTIVATE,
                                     WA_CustomScreen ,screen,
                                     TAG_DONE)))
            {
               struct IntuiMessage *msg;
               ULONG startsec,startmic,endsec,endmic;
               BOOL running  = TRUE;
               BOOL clicked  = FALSE;
               WORD selected = -1;
               WORD actual   = 0;

               GT_RefreshWindow(win,NULL);

               while(running)
               {
                  WaitPort(win->UserPort);
                  while((msg = GT_GetIMsg(win->UserPort)))
                  {
                     switch(msg->Class)
                     {
                     case IDCMP_GADGETUP:
                        if(!clicked)
                        {
                           CurrentTime(&startsec,&startmic);
                           clicked = TRUE;
                        } else if(msg->Code != actual)
                        {
                           clicked = FALSE;
                        } else
                        {
                           CurrentTime(&endsec,&endmic);
                           if(DoubleClick(startsec,startmic,endsec,endmic))
                           {
                              selected = actual;
                              running = FALSE;
                           }
                           clicked = FALSE;
                        }
                        actual = msg->Code;
                        break;
                     case IDCMP_RAWKEY:
                        switch(msg->Code)
                        {
                        case CURSORUP:
                           if(actual > 0)
                           {
                              if(msg->Qualifier & 0x03)
                              {
                                 actual -= 9;
                                 actual  = MAX(actual,0);
                              } else
                                 actual--;
                              GT_SetGadgetAttrs(gad,win,NULL,
                                                GTLV_Selected    ,actual,
                                                GTLV_MakeVisible ,actual,
                                                (GadToolsBase->lib_Version < 39 ) ? GTLV_Top : TAG_IGNORE ,actual,
                                                TAG_DONE);
                           }
                           break;
                        case  CURSORDOWN:
                           if(actual < num - 1)
                           {
                              if(msg->Qualifier & 0x03)
                              {
                                 actual += 9;
                                 actual  = MIN(actual,num-1);
                              } else
                                 actual++;
                              GT_SetGadgetAttrs(gad,win,NULL,
                                                GTLV_Selected    ,actual,
                                                GTLV_MakeVisible ,actual,
                                                (GadToolsBase->lib_Version < 39 ) ? GTLV_Top : TAG_IGNORE  ,actual,
                                                TAG_DONE);
                           }
                           break;
                        }
                        break;
                     case IDCMP_VANILLAKEY:
                        switch(msg->Code)
                        {
                        case 13:    /* return */
                           selected = actual;
                        case 3:     /* ctrl-c */
                        case 27:    /* esc */
                           running = FALSE;
                           break;
                        }
                        break;
                     case IDCMP_CLOSEWINDOW:
                        running = FALSE;
                        break;
                     }
                     GT_ReplyIMsg(msg);
                  }
               }

               if(selected > -1)
               {
                  for(selnode = list->lh_Head ;
                      selnode->ln_Succ && selected > 0 ;
                      selnode = selnode->ln_Succ)
                  {
                     selected--;
                  }

                  if(!selnode->ln_Succ)
                     selnode = NULL;

               }

               DB(("close window : %lx\n",win));

               CloseWindow(win);
            }
         }
         FreeGadgets(glist);
      }
      CloseFont(font);
   }
   return(selnode);
}
/*FE*/

/* -------------------------- support functions --------------------------- */

/*FS*/ /*"void parse_typestring(STRPTR typestr,ULONG *typearray)"*/
void parse_typestring(STRPTR typestr,ULONG *typearray)
{
   STRPTR end = typestr;
   STRPTR ptr = typestr;
   ULONG types = 0;
   ULONG i;

   /* convert separator to EOS */
   while(*end != EOS)
   {
      if(*end == '|')
         *end = EOS;
      end++;
   }

   while(ptr < end)
   {
      for(i = 0 ; i < XREFT_MAXTYPES ; i++)
         if(!Stricmp(ptr,xreftype_names[i]))
         {
            DB(("type : %s found -> %ld\n",ptr,i));
            typearray[types] = i;
            types++;
            break;
         }

      ptr += strlen(ptr) + 1;
   }

   DB(("types : %ld\n",types));

   typearray[types] = ~0;
}
/*FE*/

