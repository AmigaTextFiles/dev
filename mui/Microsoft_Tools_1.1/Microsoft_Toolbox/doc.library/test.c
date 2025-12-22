#include <stdio.h>
#include <clib/debug_protos.h>
#include <exec/libraries.h>
#include <proto/exec.h>
#include "proto/doc.h"
#include "proto/dos.h"
#include <proto/cairo.h>
#include <workbench/workbench.h>
#include <workbench/startup.h>


struct Library *DocBase,*CairoBase;

  #define PARAM	"INPUT/A,PAGENUMBER/A"
  struct Args 
  {
  STRPTR in;
  STRPTR nr;
  };



int main(int argc, char **argv)
{
 struct Args args;
 struct RDArgs *rda; 
	
	
	
	
	if ((DocBase = OpenLibrary("doc.library", 0)))
	{
	  if((rda = ReadArgs(PARAM, (LONG *) &args, 0)))
      {
	
		ULONG x = Doc_init();
		if(x == 1)
		{
		  printf("Doc initialisiert...\n");
		
			if(Doc_load(args.in) == 0)
			{
			  ULONG p;
	          StrToLong(args.nr,&p);
				
			 printf("Open doc...!\n");
			
			 printf("Number of pages: %ld\n",Doc_get_max_pages());
			
			    printf("Title: %s\n",Doc_get_title());
				printf("Subject: %s\n",Doc_get_subject());
				printf("Author: %s\n",Doc_get_author());
				printf("Company: %s\n",Doc_get_company());
				printf("Appname: %s\n",Doc_get_appname());
				printf("Language: %s\n",Doc_get_language());
				
			
			
			
				CairoBase = OpenLibrary("cairo.library",5L);
                if (CairoBase != NULL)
                {
				  cairo_surface_t *surface;	
				  char *page;
					
					
				    page = Doc_get_page(p);
				  
					if(page != NULL)
					{
				     surface = cairo_image_surface_create_for_data(page,CAIRO_FORMAT_ARGB32,595,842,595 * 4);
                     cairo_surface_write_to_png(surface,"ram:test.png");
					 FreeVec(page);
					}	
						
			    CloseLibrary(CairoBase);
		        }
		    }
		
		printf("Doc ready\n");
		
		Doc_exit(x);
		}
		
	
	
	
	
	  }
      else
	  {
	   printf("No Argument...\n");
	  }
		CloseLibrary(DocBase);
	}
	else
	{
		printf("Error: Couldn't open doc.library\n");
	}

	return 0;
}

