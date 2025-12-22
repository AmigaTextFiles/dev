
/* fotochop viewer*/



/* includes */


#include <clib/alib_protos.h>
#include <clib/macros.h>
#include <clib/utility_protos.h>
#include <clib/gadtools_protos.h>
#include <clib/debug_protos.h>

#include <graphics/gfx.h>

#include <graphics/rpattr.h>
#include <graphics/gfxmacros.h>
#include <workbench/workbench.h>
#include <workbench/startup.h>




/* prototypes */


#include <proto/intuition.h>
#include <proto/exec.h>
#include <proto/muimaster.h>


#include "main.h"

#include "mui_def.c"




struct Library *UtilityBase;

int CreateGui(struct Args *temp);


int main(int argc, char **argv)
{
struct Args args;
struct RDArgs *rda; 


             IntuitionBase = (struct IntuitionBase *)OpenLibrary("intuition.library", 39L);
             if(IntuitionBase != NULL)
             {
               MUIMasterBase = OpenLibrary(MUIMASTER_NAME, 19);
               if(MUIMasterBase != NULL)
               {
               
                  UtilityBase = OpenLibrary("utility.library",0L);
                  if(UtilityBase != NULL)
                  {
             
		               if((rda = ReadArgs(PARAM, (LONG *) &args, 0)))
                       {
                        CreateGui(&args);
   					    FreeArgs(rda);
   					   }
   					   else
   					   {
     					CreateGui(NULL);
   					   } 

               		
   					   
   					    
   				  CloseLibrary(UtilityBase); 
                  }

               CloseLibrary(MUIMasterBase); 
               }
			   
			  CloseLibrary((struct Library *)IntuitionBase); 
			 }
		 
        
return(0);
}                                       


