************************************************************************* 
*   This routine is used to convert a signed long int in d0 to a        *
*   vnum (signed variable length number) to a buffer in a0.             *
*   The number of bytes used in the buffer is returned in d0.           *
*                                                                       *
* SAS C prototype:                                                      *
* extern int __asm putvnum(register __d0 int, register __a0 char *);    *
*                                                                       *
*************************************************************************
_putvnum:
* called by: 
* d0 = number to transform into a vnum
* a0 = char * for buffer to fill with vnum
*
* returns number of bytes in the buffer in d0
*
        clr.l   d1              ;clear the counter
        bsr.s   pvnm1
        bclr    #7,-1(a0)
        move.l  d1,d0           ;return number of characters in vnum in d0
        rts
pvnm1:  cmp.l   #$80,d0
        bcs.s   1$
        move.w  d0,-(sp)
        lsr.l   #7,d0
        bsr.s   pvnm1
        move.w  (sp)+,d0
1$      bset    #7,d0
        move.b  d0,(a0)+
        addq.l  #1,d1
        rts
