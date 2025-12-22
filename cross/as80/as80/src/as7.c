/*
 *      8080 Assembler
 *
 *      Copyright (C) 1983 - Anthony McGrath
 *
 *      Modifications and ANSI C compatibility fixes
 *      Copyright (C) 2004 by Ventzislav Tzvetkov
 *
 *      @(#) as7.c - Version 1.31 - 09/03/2004
 */

#include        "as.h"

optab   opcode[] =      {
        ".ascii",       0,      LOCAL,
        ".asciz",       1,      LOCAL,
        ".blkb",        2,      LOCAL,
        ".blkw",        3,      LOCAL,
        ".byte",        4,      LOCAL,
        ".data",        5,      LOCAL,
        ".else",        6,      LOCAL,
        ".end",         7,      LOCAL,
        ".endm",        8,      LOCAL,
        ".even",        9,      LOCAL,
        ".fi",          10,     LOCAL,
        ".globl",       11,     LOCAL,
        ".if",          12,     LOCAL,
        ".macro",       13,     LOCAL,
        ".text",        14,     LOCAL,
        ".word",        15,     LOCAL,
        "aci",          0xce,   BYTE,
        "adc",          0x88,   ACCUM,
        "add",          0x80,   ACCUM,
        "adi",          0xc6,   BYTE,
        "ana",          0xa0,   ACCUM,
        "ani",          0xe6,   BYTE,
        "bit",          0xcb40, BIT,
        "call",         0xcd,   RELOC,
        "cc",           0xdc,   RELOC,
        "ccd",          0xeda9, SINGLE,
        "ccdr",         0xed89, SINGLE,
        "cci",          0xeda1, SINGLE,
        "ccir",         0xed81, SINGLE,
        "cm",           0xfc,   RELOC,
        "cma",          0x2f,   SINGLE,
        "cmc",          0x3f,   SINGLE,
        "cmp",          0xb8,   ACCUM,
        "cnc",          0xd4,   RELOC,
        "cnz",          0xc4,   RELOC,
        "cp",           0xf4,   RELOC,
        "cpe",          0xec,   RELOC,
        "cpi",          0xfe,   BYTE,
        "cpo",          0xe4,   RELOC,
        "cz",           0xcc,   RELOC,
        "daa",          0x27,   SINGLE,
        "dad",          0x09,   DOUBLE,
        "dadc",         0xed4a, DOUBLE,
        "dadx",         0xdd09, DOUBLE,
        "dady",         0xfd09, DOUBLE,
        "dcr",          0x05,   SPECIAL,
        "dcx",          0x0b,   DOUBLE,
        "di",           0xf3,   SINGLE,
        "djnz",         0x10,   RELAT,
        "dsbc",         0xed42, DOUBLE,
        "ei",           0xfb,   SINGLE,
        "exaf",         0x08,   SINGLE,
        "exx",          0xd9,   SINGLE,
        "hlt",          0x76,   SINGLE,
        "im0",          0xed46, SINGLE,
        "im1",          0xed56, SINGLE,
        "im2",          0xed5e, SINGLE,
        "in",           0xdb,   BYTE,
        "ind",          0xedaa, SINGLE,
        "indr",         0xedba, SINGLE,
        "ini",          0xeda2, SINGLE,
        "inir",         0xedb2, SINGLE,
        "inp",          0xed40, SPECIAL,
        "inr",          0x04,   SPECIAL,
        "inx",          0x03,   DOUBLE,
        "jc",           0xda,   RELOC,
        "jm",           0xfa,   RELOC,
        "jmp",          0xc3,   RELOC,
        "jmpr",         0x18,   RELAT,
        "jnc",          0xd2,   RELOC,
        "jnz",          0xc2,   RELOC,
        "jp",           0xf2,   RELOC,
        "jpe",          0xea,   RELOC,
        "jpo",          0xe2,   RELOC,
        "jrc",          0x38,   RELAT,
        "jrnc",         0x30,   RELAT,
        "jrnz",         0x20,   RELAT,
        "jrz",          0x28,   RELAT,
        "jz",           0xca,   RELOC,
        "lda",          0x3a,   RELOC,
        "ldd",          0xeda8, SINGLE,
        "lddr",         0xed88, SINGLE,
        "ldi",          0xeda0, SINGLE,
        "ldir",         0xed80, SINGLE,
        "ldai",         0xed57, SINGLE,
        "ldar",         0xed5f, SINGLE,
        "ldax",         0x0a,   DOUBLE,
        "lbcd",         0xed4b, RELOC,
        "lded",         0xed5b, RELOC,
        "lhld",         0x6b,   RELOC,
        "lixd",         0xdd6b, RELOC,
        "liyd",         0xfd6b, RELOC,
        "lspd",         0xed78, RELOC,
        "lxi",          0x01,   SPECIAL,
        "mov",          0x40,   SPECIAL,
        "mvi",          0x06,   SPECIAL,
        "nop",          0x00,   SINGLE,
        "ora",          0xb0,   ACCUM,
        "ori",          0xf6,   BYTE,
        "out",          0xd3,   BYTE,
        "outd",         0xedab, SINGLE,
        "outdr",        0xedbb, SINGLE,
        "outi",         0xeda3, SINGLE,
        "outir",        0xedb3, SINGLE,
        "outp",         0xed41, SPECIAL,
        "pchl",         0xe9,   SINGLE,
        "pcix",         0xdde9, SINGLE,
        "pciy",         0xfde9, SINGLE,
        "pop",          0xc1,   DOUBLE,
        "push",         0xc5,   DOUBLE,
        "ral",          0x17,   SINGLE,
        "ralr",         0xcb10, ACCUM,
        "rar",          0x1f,   SINGLE,
        "rarr",         0xcb18, ACCUM,
        "rc",           0xd8,   SINGLE,
        "res",          0xcb80, BIT,
        "ret",          0xc9,   SINGLE,
        "reti",         0xed4d, SINGLE,
        "retn",         0xed45, SINGLE,
        "rlc",          0x07,   SINGLE,
        "rlcr",         0xcb00, ACCUM,
        "rld",          0xed6f, SINGLE,
        "rm",           0xf8,   SINGLE,
        "rnc",          0xd0,   SINGLE,
        "rnz",          0xc0,   SINGLE,
        "rp",           0xf0,   SINGLE,
        "rpe",          0xe8,   SINGLE,
        "rpo",          0xe0,   SINGLE,
        "rrc",          0x0f,   SINGLE,
        "rrcr",         0xcb08, ACCUM,
        "rrd",          0xed67, SINGLE,
        "rst",          0xc7,   SPECIAL,
        "rz",           0xc8,   SINGLE,
        "sbb",          0x98,   ACCUM,
        "sbi",          0xde,   BYTE,
        "sbcd",         0xed43, RELOC,
        "sded",         0xed53, RELOC,
        "set",          0xcbc0, BIT,
        "shld",         0x22,   RELOC,
        "sixd",         0xdd22, RELOC,
        "siyd",         0xfd22, RELOC,
        "slar",         0xcb20, ACCUM,
        "srar",         0xcb28, ACCUM,
        "srlr",         0xcb38, ACCUM,
        "sspd",         0xed73, RELOC,
        "sphl",         0xf9,   SINGLE,
        "spix",         0xddf9, SINGLE,
        "spiy",         0xfdf9, SINGLE,
        "sta",          0x32,   RELOC,
        "stai",         0xed47, SINGLE,
        "star",         0xed4f, SINGLE,
        "stax",         0x02,   DOUBLE,
        "stc",          0x37,   SINGLE,
        "sub",          0xc0,   ACCUM,
        "sui",          0xd6,   BYTE,
        "xchg",         0xeb,   SINGLE,
        "xra",          0xa8,   ACCUM,
        "xri",          0xee,   BYTE,
        "xthl",         0xe3,   SINGLE,
        0,              0,      0
};

optab   regist[] =      {
        "b",            0,      0,
        "c",            1,      -1,
        "d",            2,      2,
        "e",            3,      -1,
        "h",            4,      4,
        "l",            5,      -1,
        "m",            6,      -1,
        "x",            0xdd,   0xdd,
        "y",            0xfd,   0xfd,
        "a",            7,      -1,
        "p",            -1,     6,
        "psw",          -1,     6,
        "sp",           -1,     6,
        0,              0,      0
};

int     peekc = 0;
int     peeksym = -1;
int     dbase = 10;
int     errcnt = 0;
int     pass = 0;
int     lno;
int     loc = 0;
int     dloc = 0;
int     tloc = 0;
int     seg = TEXT;
int     eof;
int     cval;
int     vtype;
int     vseg;
int     indxflg;
int     offset;

char    symname[40];

jmp_buf errstart;

char    *file;

sym     *tmpsym = 0;
