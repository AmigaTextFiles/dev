#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include <proto/exec.h>
#include <powerpc/powerpc.h>
#include <clib/powerpc_protos.h>
#include "loadelf.h"
#include "util.h"
#include "error.h"

struct Library *PowerPCBase;

int main(int argc,char *argv[])
{
    struct PPCArgs Regs;
    PElfObject *obj=0L;
    char args[256]={0};
    FILE *elffile=0L;
    size_t elfsize=0L;
    void *elfptr=0L;
    int i=1;
    
            
    if(argc>1)
    {
        if(!(elffile=fopen(argv[1],"rb")))
        {
            error_printf("Error opening %s : %s !",argv[1],strerror(errno));
            return -10L;
        }
    
        if(!(elfsize=filelength(elffile)))
        {
            error_printf("Elffile size 0 ?");
            fclose(elffile);
            return -10L;
        }
        
        if(!(elfptr=malloc(elfsize)))
        {
            error_printf("No memory for elffile !");
            fclose(elffile);
            return -10L;
        }
        
        if(fread(elfptr,1,elfsize,elffile)!=elfsize)
        {
            error_printf("Error reading Elffile: %s !",strerror(errno));
            free(elfptr);
            fclose(elffile);
            return -10L;
        }
    
        fclose(elffile);
        
        //if((PowerPCBase=OpenLibrary("powerpc.library",14)))
        {       
            if((obj=alloc_elfobject(elfptr)))
            {
    
                free(elfptr);       //Save some memory! This works here, but can be dangerous in other contexts.
    
                while((argc-i)>0)
                {
                    strcat(args,argv[i]);
                    strcat(args," ");
                    i++;
                }

                //printf("Starting program at %p\n",obj->sections[1].virtadr);

                Regs.PP_Code=obj->sections[1].virtadr;
                Regs.PP_Offset=0L;
                Regs.PP_Flags=0L;
                Regs.PP_Stack=0L;
                Regs.PP_StackSize=0L;
                Regs.PP_Regs[0]=(ULONG)args;
                Regs.PP_Regs[1]=(ULONG)PowerPCBase;
                //RunPPC(&Regs);
            }
            else
            {
                printf("Failed to load : %s \n",argv[1]);
                free(elfptr);
                return -10L;
            }

            free_elfobject(obj);
        }
    }else{
        printf("Usage: CheckElfWOS program.elf [parameters]\n");
    }

    return(Regs.PP_Regs[0]);
}
