
/* EPUB-Reader*/




#include <proto/intuition.h>
#include <proto/exec.h>
#include <proto/muimaster.h>
#include <proto/cybergraphics.h>
#include <proto/layers.h>
#include <proto/utility.h>

#include <clib/alib_protos.h>

#include <proto/utility.h>
#include "main.h"
#include "epub_mcc/epub_mcc.h"
#include "mui_def.c"



int CreateGui(struct Args *temp);


int main(int argc, char **argv)
{




  
	
	    CyberGfxBase = OpenLibrary("cybergraphics.library",0L);
	    if (CyberGfxBase != NULL)
	    {
		 
 			 IntuitionBase = (struct IntuitionBase *)OpenLibrary("intuition.library", 39L);
             if(IntuitionBase != NULL)
             {
               MUIMasterBase = OpenLibrary(MUIMASTER_NAME, 19);
               if(MUIMasterBase != NULL)
               {
               
                  UtilityBase = OpenLibrary("utility.library",0L);
                  if(UtilityBase != NULL)
                  {
             
             
                     
   					   
     					CreateGui(NULL);
   					   
   					    
   					    
   			       CloseLibrary(UtilityBase); 
                  }

               CloseLibrary(MUIMasterBase); 
               }
			   
			  CloseLibrary((struct Library *)IntuitionBase); 
			 }
		 
        
		CloseLibrary(CyberGfxBase);
	    }
	
  
 

return(0);
}                                       

