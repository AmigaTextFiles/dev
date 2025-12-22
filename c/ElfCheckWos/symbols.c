#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include <powerpc/powerpc.h>
#include <clib/exec_protos.h>
#include "elf/external.h"
#include "elf/common.h"
#include "symbols.h"
#include "error.h"

void print_symbols(PElfObject *);

int add_symbol_sect(PElfObject *obj,unsigned long i)
{
    int n;
    int symbolsnum=obj->sections[i].size/sizeof(Elf32_External_Sym);
    Elf32_External_Sym *symtab=(Elf32_External_Sym *)obj->sections[i].elfadr;
    char *strings=obj->sections[obj->sections[i].link].elfadr;
    int undefnum=0,absnum=0,commonnum=0,normalnum=0;
    size_t commonsize=0;

    if(!(obj->symbols))
    {
        if(!(obj->symbols=calloc(symbolsnum,sizeof(PSymbol))))
        {
            error_printf("No mem for Symbol Table !");
            return 0L;
        }
    }else{
        error_printf("More than one symbol section ?");
        error_printf("%s",obj->sections[i].name);
        return 0L;
    }

    obj->symbolscnt=symbolsnum;
    
    info_printf("Collecting %i Symbols!\n",symbolsnum);
    for(n=1;n<symbolsnum;n++)
    {
        obj->symbols[n].name=strings+symtab[n].st_name;
        obj->symbols[n].value=symtab[n].st_value;
        obj->symbols[n].size=symtab[n].st_size;
        obj->symbols[n].type=symtab[n].st_info;
        obj->symbols[n].sectionindex=symtab[n].st_shndx;
        if(ELF_ST_TYPE(obj->symbols[n].type)==STT_SECTION)
            obj->symbols[n].name=obj->sections[obj->symbols[n].sectionindex].name;
        switch(obj->symbols[n].sectionindex)
        {
            case SHN_UNDEF :
                error_printf("Undefined Symbol: %s",obj->symbols[n].name);
                undefnum++;
                break;

            case SHN_ABS :
                absnum++;
                break;

            case SHN_COMMON :
                {
                    unsigned int tempalign=obj->symbols[n].value-1;
                    unsigned int tempsize=obj->symbols[n].size;
                    obj->symbols[n].value=(commonsize+tempalign)&(~tempalign);
                    commonsize=obj->symbols[n].value+tempsize;
                    obj->symbols[n].size=tempsize;
                }
                commonnum++;
                break;

            default:
                if(obj->symbols[n].sectionindex>obj->sectcnt)
                {
                    error_printf("Unknown Sectionindex for Symbol: %s !",obj->symbols[n].name);
                    return 0L;
                }
                obj->symbols[n].value+=(unsigned long)obj->sections[obj->symbols[n].sectionindex].virtadr;
                normalnum++;
        }
    }

    if(undefnum>0)
    {
        return 0L;
    }

    info_printf("Collected Symbols:\n");
    info_printf("%i undefined\n",undefnum);
    info_printf("%i absolute\n",absnum);
    info_printf("%i common  ",commonnum);
    info_printf("Size: %li\n",commonsize);
    info_printf("%i normal\n",normalnum);

    //Create Common Section

    if(commonsize)
    {
        if(!(obj->sections[0].virtadr=AllocVec(commonsize,0L)))   // Probably should use AllocMem32 here
        {
            error_printf("No mem for common section !");
            return 0L;
        }
        memset(obj->sections[0].virtadr,0,commonsize);
    }

    obj->sections[0].name=".common";
    obj->sections[0].elfadr=0L;
    obj->sections[0].size=commonsize;
    obj->sections[0].type=SHT_NOBITS;
    obj->sections[0].flags=SHF_ALLOC;

    for(i=1;i<symbolsnum;i++)
        if(obj->symbols[i].sectionindex==SHN_COMMON)
        {
            obj->symbols[i].sectionindex=0;
            obj->symbols[i].value+=(unsigned long)obj->sections[0].virtadr;
        }

    //print_symbols(obj);

    return 1L;
}

void print_symbols(PElfObject *obj)
{
    int i;
    for(i=1;i<obj->symbolscnt;i++)
    {
        info_printf("%-30s: %8lx\n",obj->symbols[i].name,obj->symbols[i].value);
    }
}

unsigned long get_symbol_by_name(PElfObject *obj,char *name)
{
    int i;
    for(i=1;i<obj->symbolscnt;i++)
        if(strcmp(name,obj->symbols[i].name)==0)
            return obj->symbols[i].value;
    return -1L;
}
