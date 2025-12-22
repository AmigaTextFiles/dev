/*
** $PROJECT: CLI/Workbench ReadArgs()
**
** $VER: extrdargs.c 1.5 (08.01.95)
**
** by
**
** Stefan Ruppert , Windthorststraße 5 , 65439 Flörsheim , GERMANY
**
** (C) Copyright 1994,1995
** All Rights Reserved !
**
** $HISTORY:
**
** 08.01.95 : 001.005 :  changed to ExtReadArgs()
** 24.09.94 : 001.004 :  now checks after ReadArgs the SIGBREAKF_CTRL_C flag,
**                       thus if anyone canceled during ReadArgs() help
**                       ExtReadArgs() fails
** 08.09.94 : 001.003 :  between two switches (no equal sign) there was
**                       no space, this is fixed
** 08.09.94 : 001.002 :  wb files now enclosed in quotes
** 04.09.94 : 001.001 :  bumped to version 1
** 19.05.94 : 000.001 :  initial
*/

/* ------------------------------ include's ------------------------------- */

#include "extrdargs.h"

#include <clib/dos_protos.h>
#include <clib/icon_protos.h>
#include <clib/exec_protos.h>

#include <proto/dos.h>
#include <proto/icon.h>
#include <proto/exec.h>

/* ---------------------------- local defines ----------------------------- */

#define bug      kprintf

#ifdef DEBUG_CODE
#define D(x)     x

extern void kprintf(char *fmt,...);

#else
#define D(x)
#endif

#define TEMPSIZE                     512
#ifndef MAX
#define MAX(a,b)  (((a) > (b)) ? (a) : (b))
#endif

#ifndef EOS
#define EOS    '\0'
#endif

#define MODE_MULTI      1

/* -------------------------- static prototypes --------------------------- */

static struct DiskObject *ExtGetIcon(struct ExtRDArgs *args,struct WBStartup *wbarg);
static void fstrcpy(struct ExtRDArgs *args,STRPTR string);
static void getargname(struct ExtRDArgs *args,STRPTR buffer,ULONG size,ULONG *modes);
static void getwbargname(struct WBArg *wbarg,STRPTR buffer,ULONG size);

/*FS*/ /*"AutoDoc --background--"*/
/*GB*** ExtReadArgs/--background-- *******************************************
*
*    PURPOSE
*        This is a CLI/Workbench transparent argument interface. I don't liked
*        the way of parsing ToolTypes and used only the ReadArgs() function.
*        Thus all my tools can only be invoked from the CLI/Shell . Thats the
*        reason for building this project !
*
*    FUNCTION
*        ExtReadArgs() copies all Workbench arguments in a single string and
*        passes this string to the ReadArgs() function. All WBArg structure
*        are expanded to their full filenames , enclosed in '"' and passed to
*        the item specified via the erda_FileParameter field. Then all Tool-
*        types are strcat()'ed into one line, thus ReadArgs() can handle it.
*        To handle each Tooltype correctly the argument is enclosed in '"' !
*
*    NOTE
*        There are some special feature according to the ReadArgs() function.
*        If you have a template like "FROM/M/A,TO/A", you can select these
*        files from workbench : Select the program, then the FROM files and
*        finally select and double click th TO file. This is available,because
*        ReadArgs() grab's the last string from a MultiArg FROM and uses it
*        as the TO parameter, if no is explicitly given !
*
*    INSPIRATION
*        I get the main idea, how I implement the Workbench ReadArgs()
*        interface from the author of ARoach Stefan Winterstein. Thanks for
*        this idea of parsing ToolTypes !
*
******************************************************************************
*
*/
/*FE*/

/*FS*/ /*"AutoDoc ExtReadArgs()"*/
/*GB*** ExtReadArgs/ExtReadArgs **********************************************
*
*    NAME
*        ExtReadArgs - CLI/Workbench transparent ReadArgs() function
*
*    SYNOPSIS
*        error = ExtReadArgs(ac,av,extrdargs);
*
*        LONG ExtReadArgs(LONG ,STRPTR *,struct ExtRDArgs *);
*
*    FUNCTION
*        this function is a CLI/Workbench transparent interface to ReadArgs().
*        It uses the argcount and argvector like SASC from the main entry 
*        point, to get the initial startup parameter. If ac is zero, so the
*        program is invoked from workbench and the av variable contains the
*        WBStartup structure ! Before you can call this function, you must set
*        up the library bases for dos.library and icon.library. Normally the
*        SASC autoinitialization code does this for you !
*        If all went right you get a return value of zero. This means the
*        passed arguments fits the template and are ready to use. Otherwise
*        you get a IoErr() like return code. You can pass this return value
*        directly to PrintFault() or something like that !
*
*        NOTE : You must call the ExtFreeArgs() function to clean up, even
*               this function fails (see EXAMPLE) !!!
*
*    INPUTS
*        ac (LONG) - parameter normally get from main()
*        av (STRPTR *) - parameter normally get from main()
*        extrdargs (struct ExtRDArgs *) - structure , which hold any
*            information used by ExtReadArgs()
*
*        structure fields to setup before calling ExtReadArgs() :
*
*            erda_Template - the really ReadArgs() template
*            erda_Parameter - ReadArgs() LONG WORD array to hold the arguments
*            erda_FileParameter - number of Argument in the template to use
*                for the files passed via WBStartup->sm_ArgList or -1, that
*                means you don't want any files
*            erda_Window - window description string to open, if the program
*                is started from the workbench or NULL for no window ! If
*                in the ToolType Array exists a WINDOW description this is used
*                instead of the parameter of the ExtRDArgs structure !
*            erda_RDArgs - RDArgs structure to use for ReadArgs() call, thus
*                you can use extended help !
*            erda_Buffer - pointer to a buffer to use for the Workbench startup
*                or NULL, that means ExtReadArgs() allocates a buffer for you
*            erda_BufferSize - if you provided a buffer, here is the length of
*                it. If not this is the length you would have ! This length is
*                checked against a minimum of ERDA_MIN_BUFFER_SIZE !
*
*    RESULTS
*        zero for success, otherwise an IoErr() like error code.
*
*        If the function successes you can check the erda_Flags field for the
*        FRDAF_WORKBENCH flag, if you want to known from where the program was
*        started
*
*    EXAMPLE
*        \* In this example the dos.library and icon.library must be open
*         * from autoinitialization code
*         *\
*        LONG main(LONG ac,STRPTR *av)
*        {
*           struct ExtRDArgs eargs = {NULL};
*           LONG para[2];
*           LONG error;
*
*           eargs.erda_Template      = "FILES/M/A,VERBOSE";
*           eargs.erda_Parameter     = para;
*           eargs.erda_FileParameter = 0;
*           eargs.erda_Window        = "CON:////My WB-Window/CLOSE/WAIT";
*
*           if((error = ExtReadArgs(ac,av,&eargs)) == 0)
*           {
*              \* do something *\
*           } else
*              PrintFault(error,"MyProgram");
*           ExtFreeArgs(&eargs);
*
*           return((error == 0) ? RETURN_OK : RETURN_FAIL);
*        }
*
*    SEE ALSO
*        ExtFreeArgs(), dos.library/ReadArgs(),
*        icon.library/GetDiskObjectNew()
*
******************************************************************************
*
*/
/*FE*/

LONG ExtReadArgs(LONG ac,STRPTR *av,struct ExtRDArgs *args)
{
   LONG error;

   args->erda_Flags = 0;

   if(ac == 0)
   {
      if(!(args->erda_RDArgs = AllocDosObject(DOS_RDARGS,NULL)))
         return(ERROR_NO_FREE_STORE);
      else
      {
         args->erda_Flags |= ERDAF_ALLOCRDARGS;

         if(!args->erda_Buffer)
         {
            args->erda_BufferSize = MAX(ERDA_MIN_BUFFER_SIZE,args->erda_BufferSize);
            args->erda_Buffer     = AllocMem(args->erda_BufferSize,MEMF_ANY);
            args->erda_Flags     |= ERDAF_ALLOCBUFFER;
         }

         if(!args->erda_Buffer)
            return(ERROR_NO_FREE_STORE);
         else
         {
            struct WBStartup *wbstart = (struct WBStartup *) av;
            struct DiskObject *dobj;

            args->erda_ActualPtr = args->erda_Buffer;
            args->erda_EndPtr    = args->erda_Buffer + args->erda_BufferSize - 1;

            if(!(dobj = ExtGetIcon(args,wbstart)))
               return(ERROR_OBJECT_NOT_FOUND);
            else
            {
               struct WBArg *wbarg = args->erda_WBArg;
               ULONG num           = args->erda_NumArgs;

               STRPTR *tooltypes = dobj->do_ToolTypes;
               STRPTR name;
               STRPTR temp;
               STRPTR ptr;

               if(num > 1 && args->erda_FileParameter >= 0 && (temp = AllocMem(TEMPSIZE,MEMF_ANY)))
               {
                  ULONG modes = 0;

                  getargname(args,temp,TEMPSIZE,&modes);
                  fstrcpy(args,temp);
                  fstrcpy(args," ");

                  /* no "/M" specifier in the ReadArgs() template, thus use only the first file */
                  if(modes != MODE_MULTI)
                     num = 2;

                  while(num > 1)
                  {
                     getwbargname(wbarg,temp,TEMPSIZE);
                     fstrcpy(args,"\"");
                     fstrcpy(args,temp);
                     fstrcpy(args,"\" ");
                     num--;
                     wbarg++;
                  }

                  FreeMem(temp,TEMPSIZE);
               }

               while(*tooltypes)
               {
                  ptr = *tooltypes;
                  name = ptr;

                  /* check if this tooltype isn`t disabled */
                  if(*ptr != '(')
                  {
                     while(*ptr != '=' && *ptr != EOS)
                        ptr++;

                     if(*ptr == '=')
                     {
                        *ptr = EOS;

                        if(!strcmp(name,"WINDOW"))
                        {
                           STRPTR win;
                           if((win = AllocVec(strlen(ptr + 1) + 1,MEMF_ANY)))
                           {
                              strcpy(win,ptr + 1);
                              args->erda_Window = win;
                              args->erda_Flags |= ERDAF_ALLOCWINDOW;
                           }

                        } else
                        {
                           fstrcpy(args,name);

                           /* enclose the argument in "" */
                           if(*(ptr + 1) == '"')
                           {
                              fstrcpy(args,"=");
                              fstrcpy(args,ptr+1);
                           } else
                           {
                              fstrcpy(args,"=\"");
                              fstrcpy(args,ptr+1);
                              fstrcpy(args,"\"");
                           }

                           *ptr = '=';
                        }
                     } else
                        fstrcpy(args,name);

                     fstrcpy(args," ");
                  }
                  tooltypes++;
               }
               fstrcpy(args,"\n");

               D(bug("final wb command line : %s\n",args->erda_Buffer));
            }
         }
      }

      args->erda_RDArgs->RDA_Source.CS_Buffer = args->erda_Buffer;
      args->erda_RDArgs->RDA_Source.CS_Length = strlen(args->erda_Buffer);

      args->erda_Flags |= ERDAF_WORKBENCH;
   }

   args->erda_FreeArgs = ReadArgs(args->erda_Template,args->erda_Parameter,args->erda_RDArgs);

   if(SetSignal(0L,SIGBREAKF_CTRL_C) & SIGBREAKF_CTRL_C)
      SetIoErr(ERROR_BREAK);

   if((error = IoErr()) == 0 && ac == 0)
      if(args->erda_Window)
      {
         if(args->erda_WindowFH = Open(args->erda_Window,MODE_NEWFILE))
         {
            args->erda_OldOutput = SelectOutput(args->erda_WindowFH);
            args->erda_OldInput  = SelectInput(args->erda_WindowFH);
         }
      }


   return(error);
}

/*FS*/ /*"AutoDoc ExtFreeArgs()"*/
/*GB*** ExtReadArgs/ExtFreeArgs **********************************************
*
*    NAME
*        ExtFreeArgs - free's all allocated resources from ExtReadArgs()
*
*    SYNOPSIS
*        ExtFreeArgs(extrdargs);
*
*        void ExtFreeArgs(struct ExtRDArgs *);
*
*    FUNCTION
*        free's all allocated resources from a previously call to
*        ExtReadArgs().
*
*    INPUTS
*        extrdargs (struct ExtRDArgs *) - same pointer, which was passed
*            to ExtReadArgs()
*
*    RESULTS
*        none
*
*    SEE ALSO
*        ExtReadArgs()
*
******************************************************************************
*
*/
/*FE*/

void ExtFreeArgs(struct ExtRDArgs *args)
{
   /* FreeArgs() can handle a NULL pointer */
   FreeArgs(args->erda_FreeArgs);

   if(args->erda_Flags & ERDAF_ALLOCRDARGS)
      if(args->erda_RDArgs)
         FreeDosObject(DOS_RDARGS,args->erda_RDArgs);

   if(args->erda_Flags & ERDAF_ALLOCBUFFER)
      FreeMem(args->erda_Buffer,args->erda_BufferSize);

   if(args->erda_WindowFH)
   {
      SelectOutput(args->erda_OldOutput);
      SelectInput(args->erda_OldInput);
      Close(args->erda_WindowFH);
   }

   if(args->erda_Flags & ERDAF_ALLOCWINDOW && args->erda_Window)
      FreeVec(args->erda_Window);

}

/* This code was grapped from IconImage/wbarg.c/IconFromWBArg()
 * Commodore-Amiga Example code
 */

static struct DiskObject *ExtGetIcon(struct ExtRDArgs *args,struct WBStartup *wbstart)
{
   struct DiskObject *dob   = NULL;
   struct WBArg      *wbarg = wbstart->sm_ArgList;
   ULONG num                = wbstart->sm_NumArgs;

   UBYTE work_name[34];
   BPTR old, new;

   /* Copy the WBArg contents */
   strcpy (work_name, wbarg->wa_Name);

   if (new = DupLock (wbarg->wa_Lock))
   {
      D(bug("work_name : %s\n",work_name));

      /* go to the directory where the icon resides */
      old = CurrentDir (new);

      dob = GetDiskObjectNew (work_name);

      /* test, if the first icon is a project icon and if so, get its icon */
      if(wbstart->sm_NumArgs > 1)
      {
         BPTR new2;

         if((new2 = DupLock(wbarg[1].wa_Lock)))
         {
            struct DiskObject *prj;

            CurrentDir(new2);

            UnLock(new);
            new = new2;

            strcpy(work_name,wbarg[1].wa_Name);

            if((prj = GetDiskObjectNew(work_name)))
               if(prj->do_Type == WBPROJECT)
               {
                  BPTR test;

                  /* if this is only an icon skip it */
                  if(!(test = Lock(work_name, SHARED_LOCK)))
                  {
                     wbarg++;
                     num--;
                  } else
                    UnLock(test);

                  if(dob)
                     FreeDiskObject(dob);

                  dob = prj;

               }
         }
      }

      if(dob)
         D(bug("dobj window : %s\n",dob->do_ToolWindow));

      /* go back to where we used to be */
      CurrentDir (old);

      /* release the duplicated lock */
      UnLock(new);   

      args->erda_WBArg   = wbarg + 1;
      args->erda_NumArgs = num;
   }

   return (dob);
}

static void fstrcpy(struct ExtRDArgs *args,STRPTR string)
{
   STRPTR ptr = args->erda_ActualPtr;
   STRPTR end = args->erda_EndPtr;

   while(ptr < end && *string)
      *ptr++= *string++;

   args->erda_ActualPtr = ptr;
}

static void getargname(struct ExtRDArgs *args,STRPTR buffer,ULONG size,ULONG *modes)
{
   ULONG num = args->erda_FileParameter;
   STRPTR ptr = args->erda_Template;

   *modes = 0;

   while(num > 0)
   {
      while(*ptr != ',' && *ptr != EOS)
         ptr++;

      if(*ptr == ',')
         ptr++;
      num--;
   }

   if(*ptr != EOS)
   {
      while(*ptr != ',' && *ptr != '/' && *ptr != EOS && size > 0)
      {
         *buffer++ = *ptr++;
         size--;
      }

      while(*ptr == '/')
      {
         ptr++;

         if(*ptr == 'M' || *ptr == 'm')
            *modes = MODE_MULTI;

         ptr++;
      }
   }

   *buffer = EOS;
}

static void getwbargname(struct WBArg *wbarg,STRPTR buffer,ULONG size)
{
   BPTR new;

   if((new = DupLock (wbarg->wa_Lock)))
   {
      if(!NameFromLock(new,buffer,size))
         *buffer = EOS;
      else if(!AddPart(buffer,wbarg->wa_Name,size))
         *buffer = EOS;

      UnLock(new);
   } else
      *buffer = EOS;
}

