#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <powerpc/powerpc.h>
#include <clib/exec_protos.h>
#include "loadelf.h"
#include "relocelf.h"
#include "error.h"
#include "symbols.h"
#include "elf/common.h"
#include "elf/external.h"

int filelength (FILE *f);

int alloc_prog_sect(unsigned long);
int alloc_bss_sect(unsigned long);

PElfObject *obj=0L;

PElfObject *alloc_elfobject(void *elfptr)
{
    Elf32_External_Ehdr *elfhdr;
    Elf32_External_Shdr *shdrs;
    char *shstrtab;
    int i;

    if(!(obj=malloc(sizeof(PElfObject))))
        return 0L;

    obj->sectcnt=0L;
    obj->elfptr=0L;
    for(i=0;i<MAX_SECTIONS;i++)
        obj->sections[i].virtadr=0L;
    obj->symbolscnt=0L;
    obj->symbols=0L;

    obj->elfptr=elfptr;

    elfhdr=(Elf32_External_Ehdr *)obj->elfptr;

    if((elfhdr->e_ident[EI_MAG0]!=ELFMAG0)||
       (elfhdr->e_ident[EI_MAG1]!=ELFMAG1)||
       (elfhdr->e_ident[EI_MAG2]!=ELFMAG2)||
       (elfhdr->e_ident[EI_MAG3]!=ELFMAG3))
    {
        error_printf("Wrong magic number in ELF-header !");
        free_elfobject(obj);
        return 0L;
    }

    if(elfhdr->e_ident[EI_CLASS]!=ELFCLASS32)
    {
        error_printf("ELF-class is not 32-bit !");
        free_elfobject(obj);
        return 0L;
    }

    if(elfhdr->e_ident[EI_DATA]!=ELFDATA2MSB)
    {
        error_printf("ELF-data encoding is not big endian !");
        free_elfobject(obj);
        return 0L;
    }

    if(elfhdr->e_type!=ET_REL)
    {
        error_printf("ELF-file is not relocatable !");
        free_elfobject(obj);
        return 0L;
    }

    if(elfhdr->e_machine!=EM_PPC)
    {
        error_printf("ELF-file is not for PowerPC !");
        free_elfobject(obj);
        return 0L;
    }

    if(elfhdr->e_version!=EV_CURRENT)
        info_printf("Warning: ELF-version is not EV_CURRENT !\n"); //Can this happen?

    if(elfhdr->e_entry!=0L)
        info_printf("Warning: ELF-entry is not NULL !\n");//What does this mean?

    if(elfhdr->e_phoff!=0L)
        info_printf("Warning: ELF-phoff is not NULL !\n");//Can this happen?

    shdrs=(Elf32_External_Shdr *)(obj->elfptr+elfhdr->e_shoff);

    if(elfhdr->e_ehsize!=sizeof(Elf32_External_Ehdr))
    {
        error_printf("ELF-header has unusual size !");
        free_elfobject(obj);
        return 0L;
    }

    if(elfhdr->e_shentsize!=sizeof(Elf32_External_Shdr))
    {
        error_printf("Section-entrys have unusual size !");
        free_elfobject(obj);
        return 0L;
    }

    obj->sectcnt=elfhdr->e_shnum;
    info_printf("%li sections in file:\n",obj->sectcnt-1);

    shstrtab=obj->elfptr+shdrs[elfhdr->e_shstrndx].sh_offset;

    for(i=0;i<obj->sectcnt;i++)
    {
        obj->sections[i].virtadr=0L;
        if(i!=0)        //Section 0 will be .common
        {
            obj->sections[i].name=&shstrtab[shdrs[i].sh_name];
            obj->sections[i].size=shdrs[i].sh_size;
            obj->sections[i].elfadr=obj->elfptr+shdrs[i].sh_offset;
            obj->sections[i].type=shdrs[i].sh_type;
            obj->sections[i].flags=shdrs[i].sh_flags;
            obj->sections[i].link=shdrs[i].sh_link;
            obj->sections[i].info=shdrs[i].sh_info;
            obj->sections[i].entsize=shdrs[i].sh_entsize;
        }
    }

    for(i=1;i<obj->sectcnt;i++)     //Skip first shentry (hopefully unused)
    {
        info_printf("Section: %-15s ",obj->sections[i].name);
        info_printf("Size: %7lu  ",obj->sections[i].size);

        if(obj->sections[i].flags&SHF_ALLOC)
            if(!(obj->sections[i].virtadr=AllocVec(obj->sections[i].size,0L)))        //Probably should use AllocMem32 here
            {
                error_printf("No mem for section: %s",obj->sections[i].name);
                free_elfobject(obj);
                return 0L;
            }
            
            
        switch(obj->sections[i].type)
        {
            case SHT_PROGBITS :     info_printf("PROGRAM section\n");
                        if(obj->sections[i].virtadr)
                            memcpy(obj->sections[i].virtadr,obj->sections[i].elfadr,obj->sections[i].size);
                        break;
                        
            case SHT_RELA :     info_printf("RELA section\n");
                        break;
                        
            case SHT_SYMTAB :   info_printf("SYMBOL section\n");
                        if(!add_symbol_sect(obj,i))
                        {
                            free_elfobject(obj);
                            return 0L;
                        }
                        break;
                        
            case SHT_STRTAB :   info_printf("STRING section\n");
                        break;
                        
            case SHT_NOBITS :   info_printf("BSS section\n");
                        if(obj->sections[i].virtadr)
                            memset(obj->sections[i].virtadr,0,obj->sections[i].size);
                        break;
                        
            default:        error_printf("Unsupported Section-type!");
                        free_elfobject(obj);
                        return 0L;
        }
    }
    if(!reloc_elfobj(obj))
    {
        free_elfobject(obj);
        return 0L;
    }

    return obj;
}

void free_elfobject(PElfObject *elfobj)
{
    int i;
    if(elfobj)
    {
        for(i=0;i<elfobj->sectcnt;i++)
            if(elfobj->sections[i].virtadr)
                FreeVec(elfobj->sections[i].virtadr);
        if(elfobj->symbols)
            free(elfobj->symbols);
        free(elfobj);
    }
}
