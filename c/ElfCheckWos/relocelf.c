#include "error.h"
#include "relocelf.h"
#include "elf/common.h"
#include "elf/relocs.h"
#include "elf/external.h"

int reloc_elfobj(PElfObject *obj)
{
	int i,j;
	unsigned long temp;
	unsigned short *sptr;
	unsigned long *lptr;
	for(i=0;i<obj->sectcnt;i++)
		if(obj->sections[i].type==SHT_RELA)
		{
			Elf32_External_Rela *relocptr=(Elf32_External_Rela *)obj->sections[i].elfadr;
			char *targetptr=(char *)obj->sections[obj->sections[i].info].virtadr;
			for(j=0;j<obj->sections[i].size/sizeof(Elf32_External_Rela);j++)
			{
				switch(ELF32_R_TYPE(relocptr[j].r_info))
				{

	case R_PPC_ADDR32:
		lptr=(unsigned long *)&targetptr[relocptr[j].r_offset];
		temp=obj->symbols[ELF32_R_SYM(relocptr[j].r_info)].value;
		temp+=relocptr[j].r_addend;
		*lptr=temp;
		break;
		

	case R_PPC_REL24:
		lptr=(unsigned long *)&targetptr[relocptr[j].r_offset];
		temp=obj->symbols[ELF32_R_SYM(relocptr[j].r_info)].value-(unsigned long)lptr;
		temp+=relocptr[j].r_addend;
		*lptr=((*lptr)&0xfc000003)|(temp&0x3fffffc);
		break;
		

	case R_PPC_ADDR16_LO:
		sptr=(unsigned short *)&targetptr[relocptr[j].r_offset];
		temp=obj->symbols[ELF32_R_SYM(relocptr[j].r_info)].value;
		temp+=relocptr[j].r_addend;
		*sptr=temp&0xffff;
		break;

	case R_PPC_ADDR16_HA:
		sptr=(unsigned short *)&targetptr[relocptr[j].r_offset];
		temp=obj->symbols[ELF32_R_SYM(relocptr[j].r_info)].value;
		temp+=relocptr[j].r_addend;
		*sptr=temp>>16;
		if((temp&0x8000)!=0L)
			*sptr+=1;
		break;

	default:
		error_printf("Unknown Reloc-Type : %i, %s in Section %s !",ELF32_R_TYPE(relocptr[j].r_info),
						obj->symbols[ELF32_R_SYM(relocptr[j].r_info)].name,
						obj->sections[i].name);
		return 0L;
				}
			}
		}

	return 1L;
}
