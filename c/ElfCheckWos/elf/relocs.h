#ifndef _ELF_RELOCS_H
#define _ELF_RELOCS_H

/* PowerPC relocations defined by the ABIs */
enum ppc_reloc_type
{
  R_PPC_NONE			=   0,
  R_PPC_ADDR32			=   1,
  R_PPC_ADDR24			=   2,
  R_PPC_ADDR16			=   3,
  R_PPC_ADDR16_LO		=   4,
  R_PPC_ADDR16_HI		=   5,
  R_PPC_ADDR16_HA		=   6,
  R_PPC_ADDR14			=   7,
  R_PPC_ADDR14_BRTAKEN		=   8,
  R_PPC_ADDR14_BRNTAKEN		=   9,
  R_PPC_REL24			=  10,
  R_PPC_REL14			=  11,
  R_PPC_REL14_BRTAKEN		=  12,
  R_PPC_REL14_BRNTAKEN		=  13,
  R_PPC_GOT16			=  14,
  R_PPC_GOT16_LO		=  15,
  R_PPC_GOT16_HI		=  16,
  R_PPC_GOT16_HA		=  17,
  R_PPC_PLTREL24		=  18,
  R_PPC_COPY			=  19,
  R_PPC_GLOB_DAT		=  20,
  R_PPC_JMP_SLOT		=  21,
  R_PPC_RELATIVE		=  22,
  R_PPC_LOCAL24PC		=  23,
  R_PPC_UADDR32			=  24,
  R_PPC_UADDR16			=  25,
  R_PPC_REL32			=  26,
  R_PPC_PLT32			=  27,
  R_PPC_PLTREL32		=  28,
  R_PPC_PLT16_LO		=  29,
  R_PPC_PLT16_HI		=  30,
  R_PPC_PLT16_HA		=  31,
  R_PPC_SDAREL16		=  32,
  R_PPC_SECTOFF			=  33,
  R_PPC_SECTOFF_LO		=  34,
  R_PPC_SECTOFF_HI		=  35,
  R_PPC_SECTOFF_HA		=  36,

  /* The remaining relocs are from the Embedded ELF ABI, and are not
     in the SVR4 ELF ABI.  */
  R_PPC_EMB_NADDR32		= 101,
  R_PPC_EMB_NADDR16		= 102,
  R_PPC_EMB_NADDR16_LO		= 103,
  R_PPC_EMB_NADDR16_HI		= 104,
  R_PPC_EMB_NADDR16_HA		= 105,
  R_PPC_EMB_SDAI16		= 106,
  R_PPC_EMB_SDA2I16		= 107,
  R_PPC_EMB_SDA2REL		= 108,
  R_PPC_EMB_SDA21		= 109,
  R_PPC_EMB_MRKREF		= 110,
  R_PPC_EMB_RELSEC16		= 111,
  R_PPC_EMB_RELST_LO		= 112,
  R_PPC_EMB_RELST_HI		= 113,
  R_PPC_EMB_RELST_HA		= 114,
  R_PPC_EMB_BIT_FLD		= 115,
  R_PPC_EMB_RELSDA		= 116,

  /* This is a phony reloc to handle any old fashioned TOC16 references
     that may still be in object files.  */
  R_PPC_TOC16			= 255,

  R_PPC_max
};

#endif
