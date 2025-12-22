#include <stdio.h>
#include <clib/debug_protos.h>
#include <exec/libraries.h>
#include <proto/exec.h>
#include "proto/wmf.h"
#include <proto/dos.h>
#include <proto/cairo.h>
#include <workbench/workbench.h>
#include <workbench/startup.h>


struct Library *WmfBase,*CairoBase;

  #define PARAM	"INPUT/A"
  struct Args 
  {
  STRPTR in;
  };



int main(int argc, char **argv)
{
 struct Args args;
 struct RDArgs *rda; 
	
	
	
	
	if ((WmfBase = OpenLibrary("wmf.library", 0)))
	{
	  if((rda = ReadArgs(PARAM, (LONG *) &args, 0)))
      {
	
		ULONG x = Wmf_init();
		if(x == 1)
		{
		  Wmf_max_size(200);	
			
		  if(Wmf_Load_path(args.in) == 0)
		  {
			 char *pic = Wmf_get_image(); 
			 if(pic != NULL)
			 {
			   ULONG width = Wmf_get_width();
			   ULONG height = Wmf_get_height();
               printf("WMF: %s - width: %ld height: %ld  GELADEN!!\n",args.in,width,height);
			  
			    CairoBase = OpenLibrary("cairo.library",5L);
                if (CairoBase != NULL)
                {
				  cairo_surface_t *surface;	
				 
				
				     surface = cairo_image_surface_create_for_data(pic,CAIRO_FORMAT_ARGB32,width,height,width * 4);
                     cairo_surface_write_to_png(surface,"ram:test.png");
						
						
			    CloseLibrary(CairoBase);
		        }
			  
			  
			  
			 } 
          }
			
		Wmf_exit(x);
		}
		
	
	
	
	
	  }
      else
	  {
	   printf("No Argument...\n");
	  }
		CloseLibrary(WmfBase);
	}
	else
	{
		printf("Error: Couldn't open doc.library\n");
	}

	return 0;
}

