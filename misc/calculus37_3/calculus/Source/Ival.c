/**** main.c *******************************************************/

#include <exec/execbase.h>
#include <dos/dos.h>
#include <clib/dos_protos.h>
#include <clib/exec_protos.h>

#include "calculus.h"

#define PROGNAME             "Ival"
#define BUFSIZE              300
#define NumArgs              4

char    ArgStr   [       ] = "VAR/K,TO/K,LF=LFORMAT/K,EXPRESSION/F";
LONG    ArgArray [NumArgs] = { 0,0,0,0 };

const char version[      ] = "$VER: " PROGNAME "1.3 © David Göhler (15-09-95)";
const char *errstr[] = { 0L,"Stack empty",
                            "Syntax error",
                            "Stack overflow",
                            "Variable not found",
                            "Too much symbols",
                            "Too much lexems",
                            "Variable name too long",
                            "Not enough memory",
                            "Division by 0!",
                            "Caller is not a process"
                       };
extern struct ExecBase *SysBase;
struct Library         *CalculusBase;
char                    outbuf [BUFSIZE];
char                   *input;

int main(void)
{
   int retcode = RETURN_OK;
   int result;
   long error = RESULT_OK;
   struct RDArgs *rda = NULL;

   if (SysBase->LibNode.lib_Version < 37) return 20;

   if (CalculusBase = OpenLibrary("calculus.library",0l))
   {
      memset(ArgArray,0,sizeof(int)*NumArgs);

      if (rda = ReadArgs(ArgStr,ArgArray,rda))
      {
         result = CalcInteger((char *)ArgArray[3],&error);
         if (error == RESULT_OK)
         {
            if (ArgArray[2] != 0)      // LFORMAT
            {  SPrintf(outbuf,(char *)(ArgArray[2]),result,result,result,result,result);
            }
            else
            {  SPrintf(outbuf,"%ld",result); }

            if (ArgArray[0] != 0)      // VAR
            {  SetVar((char *)(ArgArray[0]),outbuf,-1,LV_VAR); }
            else if (ArgArray[1] != 0) // TO
            {  BPTR filep;
               if (filep = Open((char *)(ArgArray[1]),MODE_NEWFILE))
               {
                  if (Write(filep,outbuf,strlen(outbuf)) <= 0)
                  {  PrintFault(IoErr(),"Ival");
                     retcode = RETURN_FAIL;
                  }
                  Close(filep);
               }
               else
               {  PrintFault(IoErr(),"Ival");
                  retcode = RETURN_FAIL;
               }
            }
            else
            {  Printf("%s\n",outbuf); }
         }
         else
         {  
            Printf("Error: %s\n",errstr[error]);
         }
         FreeArgs(rda);
      }
      else
      {  PrintFault(IoErr(),"Eval");
         retcode = RETURN_FAIL;
      }
      CloseLibrary(CalculusBase);
   }
   else
   {  Printf("Can't open %s version 0\n",CALCBASENAME);
      retcode = RETURN_FAIL;
   }

   if (error != RESULT_OK) retcode = RETURN_FAIL;

   return retcode;
}

