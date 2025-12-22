OPT MODULE
OPT EXPORT
OPT NODEFMODS
-> Module created with E:bin/fd2mod from YAECv2.5 package.
MACRO AddICRVector(resource,iCRBit,interrupt) IS ASM ' movem.l d2-d7/a2-a5,-(a7)' BUT Stores(,resource,iCRBit,interrupt) BUT Loads(A6,A6,D0,A1) BUT ASM ' jsr -6(a6)' BUT ASM ' movem.l (a7)+, d2-d7/a2-a5'
MACRO RemICRVector(resource,iCRBit,interrupt) IS ASM ' movem.l d2-d7/a2-a5,-(a7)' BUT Stores(,resource,iCRBit,interrupt) BUT Loads(A6,A6,D0,A1) BUT ASM ' jsr -12(a6)' BUT ASM ' movem.l (a7)+, d2-d7/a2-a5'
MACRO AbleICR(resource,mask) IS ASM ' movem.l d2-d7/a2-a5,-(a7)' BUT Stores(,resource,mask) BUT Loads(A6,A6,D0) BUT ASM ' jsr -18(a6)' BUT ASM ' movem.l (a7)+, d2-d7/a2-a5'
MACRO SetICR(resource,mask) IS ASM ' movem.l d2-d7/a2-a5,-(a7)' BUT Stores(,resource,mask) BUT Loads(A6,A6,D0) BUT ASM ' jsr -24(a6)' BUT ASM ' movem.l (a7)+, d2-d7/a2-a5'
