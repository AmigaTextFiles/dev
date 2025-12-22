/*
 * devices.c -- picasm
 *
 * Timo Rossi <trossi@iki.fi>
 * RDC <rdc@cch.pmc.ru>
 *
 */

#include <stdio.h>
#include "picasm.h"

/*
 * PIC device type table
 */

struct pic_type pic_types[] = {
/* name        prog     reg   eeprom  id_addr fuseaddr  fusetype      instrset */

/* 12-bit 8-pin PICs */
{ "12C508",     512,   0x19,    0,     0x200,   0xfff,  FUSE_12C5XX,  PIC12BIT },
{ "12C508A",    512,   0x19,    0,     0x200,   0xfff,  FUSE_12C5XX,  PIC12BIT },
{ "12C509",    1024,   0x29,    0,     0x400,   0xfff,  FUSE_12C5XX,  PIC12BIT },
{ "12C509A",   1024,   0x29,    0,     0x400,   0xfff,  FUSE_12C5XX,  PIC12BIT },
{ "12CR509A",  1024,   0x29,    0,     0x400,   0xfff,  FUSE_12C5XX,  PIC12BIT },
{ "12CE518",    512,   0x19,   16,     0x200,   0xfff,  FUSE_12C5XX,  PIC12BIT },
{ "12CE519",   1024,   0x29,   16,     0x400,   0xfff,  FUSE_12C5XX,  PIC12BIT },

/* 14-bit 8-pin PICs */
{ "12C671",    1024,   0x80,    0,    0x2000,  0x2007,  FUSE_12C6XX,  PIC14BIT },
{ "12C672",    2048,   0x80,    0,    0x2000,  0x2007,  FUSE_12C6XX,  PIC14BIT },
{ "12CE673",   1024,   0x80,   16,    0x2000,  0x2007,  FUSE_12C6XX,  PIC14BIT },
{ "12CE674",   2048,   0x80,   16,    0x2000,  0x2007,  FUSE_12C6XX,  PIC14BIT },

/* 12-bit PICs */
{ "16C52",      384,   0x19,    0,     0x180,   0xfff,  FUSE_16C5X,   PIC12BIT },
{ "16C54",      512,   0x19,    0,     0x200,   0xfff,  FUSE_16C5X,   PIC12BIT },
{ "16CR54A",    512,   0x19,    0,     0x200,   0xfff,  FUSE_16C5X,   PIC12BIT },
{ "16C54A",     512,   0x19,    0,     0x200,   0xfff,  FUSE_16C5X,   PIC12BIT },
{ "16C54C",     512,   0x19,    0,     0x200,   0xfff,  FUSE_16C5X,   PIC12BIT },
{ "16CR54C",    512,   0x19,    0,     0x200,   0xfff,  FUSE_16C5X,   PIC12BIT },
{ "16C55",      512,   0x18,    0,     0x200,   0xfff,  FUSE_16C5X,   PIC12BIT },
{ "16C55A",     512,   0x18,    0,     0x200,   0xfff,  FUSE_16C5X,   PIC12BIT },
{ "16C56",     1024,   0x19,    0,     0x400,   0xfff,  FUSE_16C5X,   PIC12BIT },
{ "16C56A",    1024,   0x19,    0,     0x400,   0xfff,  FUSE_16C5X,   PIC12BIT },
{ "16CR56A",   1024,   0x19,    0,     0x400,   0xfff,  FUSE_16C5X,   PIC12BIT },
{ "16C57",     2048,   0x48,    0,     0x800,   0xfff,  FUSE_16C5X,   PIC12BIT },
{ "16CR57B",   2048,   0x48,    0,     0x800,   0xfff,  FUSE_16C5X,   PIC12BIT },
{ "16C57C",    2048,   0x48,    0,     0x800,   0xfff,  FUSE_16C5X,   PIC12BIT },
{ "16CR57C",   2048,   0x48,    0,     0x800,   0xfff,  FUSE_16C5X,   PIC12BIT },
{ "16C58A",    2048,   0x49,    0,     0x800,   0xfff,  FUSE_16C5X,   PIC12BIT },
{ "16CR58A",   2048,   0x49,    0,     0x800,   0xfff,  FUSE_16C5X,   PIC12BIT },
{ "16C58B",    2048,   0x49,    0,     0x800,   0xfff,  FUSE_16C5X,   PIC12BIT },
{ "16CR58B",   2048,   0x49,    0,     0x800,   0xfff,  FUSE_16C5X,   PIC12BIT },
{ "16C505",    1024,   0x48,    0,     0x400,   0xfff,  FUSE_16C5X,   PIC12BIT },
{ "16HV540",    512,   0x19,    0,     0x200,   0xfff,  FUSE_16C5X,   PIC12BIT },

/* 14-bit PICs */
{ "14C000",    4096,   0xC0,    0,    0x2000,  0x2007,  FUSE_14000,   PIC14BIT },
{ "16C554",     512,   0x50,    0,    0x2000,  0x2007,  FUSE_16C55X,  PIC14BIT },
{ "16C558",    2048,   0x80,    0,    0x2000,  0x2007,  FUSE_16C55X,  PIC14BIT },
{ "16C62A",    2048,   0x80,    0,    0x2000,  0x2007,  FUSE_16CXX2,  PIC14BIT },	
{ "16CR62",    2048,   0x80,    0,    0x2000,  0x2007,  FUSE_16CXX2,  PIC14BIT },	
{ "16C62B",    2048,   0x80,    0,    0x2000,  0x2007,  FUSE_16CXX2,  PIC14BIT },	
{ "16C63",     4096,   0xC0,    0,    0x2000,  0x2007,  FUSE_16C6XA,  PIC14BIT },	
{ "16C63A",    4096,   0xC0,    0,    0x2000,  0x2007,  FUSE_16C6XA,  PIC14BIT },	
{ "16CR63",    4096,   0xC0,    0,    0x2000,  0x2007,  FUSE_16C6XA,  PIC14BIT },	
{ "16C64A",    2048,   0x80,    0,    0x2000,  0x2007,  FUSE_16CXX2,  PIC14BIT },	
{ "16CR64",    2048,   0x80,    0,    0x2000,  0x2007,  FUSE_16CXX2,  PIC14BIT },	
{ "16C65A",    4096,   0xC0,    0,    0x2000,  0x2007,  FUSE_16CXX2,  PIC14BIT },	
{ "16C65B",    4096,   0xC0,    0,    0x2000,  0x2007,  FUSE_16CXX2,  PIC14BIT },	
{ "16CR65",    4096,   0xC0,    0,    0x2000,  0x2007,  FUSE_16CXX2,  PIC14BIT },	
{ "16C66",     8192,  0x170,    0,    0x2000,  0x2007,  FUSE_16C6XA,  PIC14BIT },
{ "16C67",     8192,  0x170,    0,    0x2000,  0x2007,  FUSE_16C6XA,  PIC14BIT },
{ "16C620",     512,   0x60,    0,    0x2000,  0x2007,  FUSE_16C62X,  PIC14BIT },
{ "16C620A",    512,   0x60,    0,    0x2000,  0x2007,  FUSE_16C62X,  PIC14BIT },
{ "16CR620A",   512,   0x60,    0,    0x2000,  0x2007,  FUSE_16C62X,  PIC14BIT },
{ "16C621",    1024,   0x50,    0,    0x2000,  0x2007,  FUSE_16C62X,  PIC14BIT },
{ "16C621A",   1024,   0x60,    0,    0x2000,  0x2007,  FUSE_16C62X,  PIC14BIT },
{ "16C622",    2048,   0x80,    0,    0x2000,  0x2007,  FUSE_16C62X,  PIC14BIT },
{ "16C622A",   2048,   0x80,    0,    0x2000,  0x2007,  FUSE_16C62X,  PIC14BIT },
{ "16CE623",    512,   0x80,  128,    0x2000,  0x2007,  FUSE_16C62X,  PIC14BIT },
{ "16CE624",   1024,   0x80,  128,    0x2000,  0x2007,  FUSE_16C62X,  PIC14BIT },
{ "16CE625",   2048,   0x80,  128,    0x2000,  0x2007,  FUSE_16C62X,  PIC14BIT },
{ "16F627",    1024,   0x80,  128,    0x2000,  0x2007,  FUSE_16C62X,  PIC14BIT },
{ "16F628",    2048,   0x80,  128,    0x2000,  0x2007,  FUSE_16C62X,  PIC14BIT },
{ "16C642",    4096,   0xB0,    0,    0x2000,  0x2007,  FUSE_16C62X,  PIC14BIT },
{ "16C662",    4096,   0xB0,    0,    0x2000,  0x2007,  FUSE_16C62X,  PIC14BIT },
{ "16C710",     512,   0x24,    0,    0x2000,  0x2007,  FUSE_16C71X,  PIC14BIT },
{ "16C71",     1024,   0x24,    0,    0x2000,  0x2007,  FUSE_16CXX1,  PIC14BIT },
{ "16C711",    1024,   0x44,    0,    0x2000,  0x2007,  FUSE_16C71X,  PIC14BIT },
{ "16C712",    1024,   0x80,    0,    0x2000,  0x2007,  FUSE_16C71X,  PIC14BIT },
{ "16C715",    2048,   0x80,    0,    0x2000,  0x2007,  FUSE_16C71X,  PIC14BIT },
{ "16C716",    2048,   0x80,    0,    0x2000,  0x2007,  FUSE_16C715,  PIC14BIT },
{ "16C72",     2048,   0x80,    0,    0x2000,  0x2007,  FUSE_16C6XA,  PIC14BIT },	
{ "16C72A",    2048,   0x80,    0,    0x2000,  0x2007,  FUSE_16C6XA,  PIC14BIT },	
{ "16CR72",    2048,   0x80,    0,    0x2000,  0x2007,  FUSE_16C6XA,  PIC14BIT },	
{ "16C73A",    4096,   0xC0,    0,    0x2000,  0x2007,  FUSE_16CXX2,  PIC14BIT },	
{ "16C73B",    4096,   0xC0,    0,    0x2000,  0x2007,  FUSE_16CXX2,  PIC14BIT },	
{ "16C73C",    4096,   0xC0,    0,    0x2000,  0x2007,  FUSE_16CXX2,  PIC14BIT },	
{ "16CR73C",   4096,   0xC0,    0,    0x2000,  0x2007,  FUSE_16CXX2,  PIC14BIT },	
{ "16C74A",    4096,   0xC0,    0,    0x2000,  0x2007,  FUSE_16CXX2,  PIC14BIT },	
{ "16C74B",    4096,   0xC0,    0,    0x2000,  0x2007,  FUSE_16CXX2,  PIC14BIT },	
{ "16C74C",    4096,   0xC0,    0,    0x2000,  0x2007,  FUSE_16CXX2,  PIC14BIT },	
{ "16CR74C",   4096,   0xC0,    0,    0x2000,  0x2007,  FUSE_16CXX2,  PIC14BIT },	
{ "16C76",     8192,  0x170,    0,    0x2000,  0x2007,  FUSE_16C6XA,  PIC14BIT },
{ "16C76A",    8192,  0x170,    0,    0x2000,  0x2007,  FUSE_16C6XA,  PIC14BIT },
{ "16CR76A",   8192,  0x170,    0,    0x2000,  0x2007,  FUSE_16C6XA,  PIC14BIT },
{ "16C77",     8192,  0x170,    0,    0x2000,  0x2007,  FUSE_16C6XA,  PIC14BIT },
{ "16C77A",    8192,  0x170,    0,    0x2000,  0x2007,  FUSE_16C6XA,  PIC14BIT },
{ "16CR77A",   8192,  0x170,    0,    0x2000,  0x2007,  FUSE_16C6XA,  PIC14BIT },
{ "16C773",    4096,  0x100,    0,    0x2000,  0x2007,  FUSE_16CXX2,  PIC14BIT },	
{ "16C774",    4096,  0x100,    0,    0x2000,  0x2007,  FUSE_16CXX2,  PIC14BIT },	
{ "16F83",      512,   0x24,   64,    0x2000,  0x2007,  FUSE_16F8X,   PIC14BIT },	
{ "16CR83",     512,   0x24,   64,    0x2000,  0x2007,  FUSE_16F8X,   PIC14BIT },	
{ "16F84",     1024,   0x44,   64,    0x2000,  0x2007,  FUSE_16F8X,   PIC14BIT },
{ "16CR84",    1024,   0x44,   64,    0x2000,  0x2007,  FUSE_16F8X,   PIC14BIT },
{ "16F84A",    1024,   0x44,   64,    0x2000,  0x2007,  FUSE_16F8X,   PIC14BIT },
{ "16F873",    4096,   0xC0,  128,    0x2000,  0x2007,  FUSE_16CXX2,  PIC14BIT },	
{ "16F874",    4096,   0xC0,  128,    0x2000,  0x2007,  FUSE_16CXX2,  PIC14BIT },	
{ "16F876",    8192,  0x170,  256,    0x2000,  0x2007,  FUSE_16C6XA,  PIC14BIT },
{ "16F877",    8192,  0x170,  256,    0x2000,  0x2007,  FUSE_16C6XA,  PIC14BIT },
{ "16C923",    4096,   0xB0,    0,    0x2000,  0x2007,  FUSE_16C55X,  PIC14BIT },
{ "16C924",    4096,   0xB0,    0,    0x2000,  0x2007,  FUSE_16C55X,  PIC14BIT },

{  NULL,          0,      0,    0,         0,       0,  0,            0 }
};
