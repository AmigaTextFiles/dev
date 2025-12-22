;/* execute me to make with SAS 6.x
sc NOSTKCHK CSRC parsexref.c OPT IGNORE=73
slink lib:c.o parsexref.o //Goodies/extrdargs/extrdargs.o TO /c/parsexref SMALLDATA SMALLCODE NOICONS LIB lib:amiga.lib lib:sc.lib /lib/xrefsupport.lib
quit
*/

/*
** $PROJECT: XRef-Tools
**
** $VER: parsexref.c 1.5 (06.07.94)
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
** 06.07.94 : 001.005 :  changed to new parsemessage
** 28.05.94 : 001.004 :  now uses the tags function and template output added
** 18.05.94 : 001.003 :  ctrl-c supported
** 02.05.94 : 001.002 :  changed to xref.library
** 26.04.94 : 000.001 : initial
**
*/

#include "Def.h"

#include <libraries/xref.h>
#include <proto/xref.h>

#include <debug.h>
#include <register.h>

#include "parsexref_rev.h"

/* ------------------------------ structures ------------------------------ */

enum {
   OT_TYPE,
   OT_PATH,
   OT_FILE,
   OT_NAME,
   OT_XREFNAME,
   OT_LINE,
   OT_NODENAME,
   OT_MAX,
   };

struct OutputTemplate
{
   STRPTR ot_Template;
   ULONG ot_Para[OT_MAX];
   BYTE ot_Index[OT_MAX];
   BYTE ot_Type;
   BYTE ot_Path;
   BYTE ot_File;
   BYTE ot_Name;
   BYTE ot_XRefName;
   BYTE ot_Line;
   UBYTE ot_Buffer[20];
};

#define SETOTPARA(ot,index,value)    { if(ot->ot_Index[index] >= 0) \
                                           ot->ot_Para[ot->ot_Index[index]] = (ULONG) value; \
                                     }

/* ---------------------------- version string ---------------------------- */

static char *version = VERSTAG;
static char *prgname = "ParseXRef";

/* ------------------------- template definition -------------------------- */

#define template "STRING/A,CATEGORY,FILE/K,LIMIT/K/N,FORMAT/K,NOPATTERN/S,NOCASE/S"

enum {
   ARG_STRING,
   ARG_CATEGORY,
   ARG_FILE,
   ARG_LIMIT,
   ARG_FORMAT,
   ARG_NOPATTERN,
   ARG_NOCASE,
   ARG_MAX};

static const STRPTR mytypes[] = {
   "generic",
   "function",
   "command",
   "include",
   "macro",
   "struct",
   "field",
   "typedef",
   "define",
   NULL};

/* ------------------------------- AutoDoc -------------------------------- */

/*FS*/ /*"AutoDoc"*/
/*GB*** XRef-Tools/ParseXRef *************************************************

$VER: ParseXRef.doc

NAME
    ParseXRef - parse the specified xreffiles from xref.library and prints it
                to stdout

TEMPLATE
    STRING/A,CATEGORY,FILE/K,LIMIT/K/N,FORMAT/K,NOPATTERN/S,NOCASE/S

FORMAT
    ParseXRef [STRING] string [FILE xreffile] [[CATEGORY] category]
              [LIMIT number] [FORMAT format-string] [NOPATTERN] [NOCASE]

FUNCTION
    parses the specified xreffiles (CATEGORY or FILE argument) for a given
    string/pattern. If no file or category is given it parses all xreffile,
    which are actually loaded from the xref.library.If a category is specified
    only such xreffiles are parsed, which match the category.If a file is
    given only the file will parsed.If you turn the NOPATTERN switch on, the
    string you passed via STRING argument is interpreted as a normal string
    without any patternmatching tokens.It is passed to a normal string compare
    function strcmp() or Stricmp(), otherwise to MatchPattern() or 
    MatchPatternNoCase().Normally it is case-sensetive, but if you turn the
    NOCASE switch on it isn't.

INPUTS
    STRING (STRING) - string/pattern to parse for

    FILE (STRING) - file for the parse

    CATEGORY (STRING) - category for the parse (parse all files with this
        category) . Can be a pattern !

    LIMIT (LONG) - maximal number of matching entries

    FORMAT (STRING) - format-string for the output to stdout following format
        characters are supported after a '%' character :
        %T - name of the XRefEntry type (e.g."AmigaGuide Node" or "struct" ..)
        %P - global path for the entry
        %F - file with a relative path for the entry
        %N - name of the file
        %X - XRefEntry name
        %L - line number in the file for the XRefEntry
        %G - AmigaGuide nodename
        default template : "%T %X found !\nIn File : %F , Line : %L\n"

    NOPATTERN (BOOL) - indicates, that the entries are compares with strcmp
        functions , instead of using MatchPattern()

    NOCASE (BOOL) - indicates, that case-insensetive compare should used

SEE ALSO
    AGuideXRefV37, AGuideXRefV39, MakeXRef, LoadXRef, ExpungeXRef,
    xref.library/ParseXRef(), dos.library/MatchPattern()

COPYRIGHT
    (C) by Stefan Ruppert 1994

HISTORY
    ParseXRef 1.6 (3.9.94) :
        - changed some tag names

    ParseXRef 1.5 (6.7.94) :
        - changed to new parsehook

    ParseXRef 1.4 (28.5.94) :
        - output-template added

    ParseXRef 1.3 (18.5.94) :
        - control-c support added
        - first beta release

*****************************************************************************/
/*FE*/

/* --------------------------- parse hook entry --------------------------- */

RegCall GetA4 ULONG parsehook(REGA0 struct Hook *hook,REGA2 struct XRefFileNode *xref,REGA1 struct xrmXRef *msg)
{
   struct OutputTemplate *optmp = (struct OutputTemplate *) hook->h_Data;

   if(msg->Msg == XRM_XREF)
   {
      struct TagItem *tstate = msg->xref_Attrs;
      struct TagItem *tag;
      ULONG tidata;
      UBYTE type;

      while((tag = NextTagItem(&tstate)))
      {
         tidata = tag->ti_Data;

         switch(tag->ti_Tag)
         {
         case ENTRYA_Type:
            type = tidata;
            if(type >= XREFT_MAXTYPES)
               break;
      
            SETOTPARA(optmp,OT_TYPE,mytypes[type]);
            break;
         case ENTRYA_File:
            if(tidata)
            {
               SETOTPARA(optmp,OT_FILE,tidata);
               SETOTPARA(optmp,OT_NAME,FilePart((STRPTR) tidata));
            }
            break;
         case ENTRYA_Name:
            SETOTPARA(optmp,OT_XREFNAME,tidata);
            break;
         case ENTRYA_Line:
            sprintf(optmp->ot_Buffer,"%ld",tidata);
            SETOTPARA(optmp,OT_LINE,optmp->ot_Buffer);
            break;
         case ENTRYA_NodeName:
            SETOTPARA(optmp,OT_NODENAME,tidata);
            break;
         case XREFA_Path:
            SETOTPARA(optmp,OT_PATH,tidata);
            break;
         }
      }

      if(type < XREFT_MAXTYPES)
         VPrintf(optmp->ot_Template,optmp->ot_Para);
      else
         Printf ("Unknown XRef Type : %ld\n",type);

   } else
      Printf ("Not supported hook message : %ld\n",msg->Msg);

   if(SetSignal(0L,SIGBREAKF_CTRL_C) & SIGBREAKF_CTRL_C)
   {
      SetIoErr(ERROR_BREAK);
      return(1);
   }

   return(0);
}

/* ---------------------------- main function ----------------------------- */

int main(int ac,char *av[])
{
   struct ExtRDArgs eargs = {NULL};
   struct Library *XRefBase;

   ULONG para[ARG_MAX];
   STRPTR obj = prgname;
   LONG err;

   LONG i;

   /* clear args buffer */
   for(i = 0 ; i < ARG_MAX ; i++)
      para[i] = 0;

   eargs.erda_Template      = template;
   eargs.erda_Parameter     = para;
   eargs.erda_FileParameter = ARG_FILE;
   eargs.erda_Window        = "CON:////ParseXRef/CLOSE/WAIT";

   if((err = ExtReadArgs(ac,av,&eargs)) == 0)
   {
      obj = "xref.library";
      if(XRefBase = OpenLibrary(obj,0))
      {
         struct Hook hook = {NULL};
         struct OutputTemplate optmp;
         ULONG matching = XREFMATCH_PATTERN_CASE;
         STRPTR output = (para[ARG_FORMAT]) ? (STRPTR) para[ARG_FORMAT] :
                                              (STRPTR) "%T %X found !\nIn File : %F , Line : %L\n";
         STRPTR ptr;
         BYTE cnt = 0;

         obj = prgname;

         if(para[ARG_NOPATTERN])
            if(para[ARG_NOCASE])
               matching = XREFMATCH_COMPARE_NOCASE;
            else
               matching = XREFMATCH_COMPARE_CASE;
         else
            if(para[ARG_NOCASE])
               matching = XREFMATCH_PATTERN_NOCASE;

         hook.h_Entry = (HOOKFUNC) parsehook;
         hook.h_Data  = &optmp;

         for(i = 0 ; i < OT_MAX ; i++)
         {
            optmp.ot_Index[i] = -1;
            optmp.ot_Para[i]  = NULL;
         }

         for(ptr = output; *ptr ; ptr++)
         {
            if(*ptr == '%')
            {
               UBYTE chr = *(++ptr);

               *ptr = 's';

               switch(chr)
               {
               case 't':
               case 'T':
                  optmp.ot_Index[OT_TYPE] = cnt;
                  break;
               case 'p':
               case 'P':
                  optmp.ot_Index[OT_PATH] = cnt;
                  break;
               case 'f':
               case 'F':
                  optmp.ot_Index[OT_FILE] = cnt;
                  break;
               case 'n':
               case 'N':
                  optmp.ot_Index[OT_NAME] = cnt;
                  break;
               case 'x':
               case 'X':
                  optmp.ot_Index[OT_XREFNAME] = cnt;
                  break;
               case 'l':
               case 'L':
                  optmp.ot_Index[OT_LINE] = cnt;
                  break;
               case 'g':
               case 'G':
                  optmp.ot_Index[OT_NODENAME] = cnt;
                  break;
               case '\0':
                  ptr--;
                  break;
               default:
                  *ptr = '%';
                  cnt--;
               }
               cnt++;
               ptr++;
            }
         }

         optmp.ot_Template = output;

         ParseXRefTags((STRPTR) para[ARG_STRING],XREFA_Category   ,para[ARG_CATEGORY],
                                                 XREFA_Matching   ,matching,
                                                 XREFA_XRefHook   ,&hook,
                                                 XREFA_Limit      ,(para[ARG_LIMIT]) ? (*((LONG *) para[ARG_LIMIT])) : (ULONG) ~0,
                                                 XREFA_File       ,para[ARG_FILE],
                                                 TAG_DONE);

         CloseLibrary(XRefBase);
      }
   }
   ExtFreeArgs(&eargs);

   if(!err)
      err = IoErr();

   if(err)
   {
      PrintFault(err,obj);
      return(RETURN_ERROR);
   }

   return(RETURN_OK);
}

