#ifndef MACRO_H
#define MACRO_H


#define PATCH_INIT(osfun, ixfun, failrc)                      \
                                                              \
  static void (*osfun)(void) = NULL;                          \
                                                              \
  static void                                                 \
  ixfun(void)                                                 \
  {                                                           \
    asm volatile(                                             \
      "movem.l  d6/d7,-(sp)        ;"                         \
      "move.l   #" #failrc ",d7    ;");


#define PATCH_EXIT                                            \
                                                              \
    asm volatile(                                             \
      "move.l   d7,d0              ;"                         \
      "movem.l  (sp)+,d6/d7        ;");                       \
  }


#define PATCH_LAB(ixfun, reg)                                 \
                                                              \
    asm volatile (#ixfun #reg ":");


#define PATCH_PUSH(ixfun, reg)                                \
                                                              \
    asm volatile(                                             \
      "move.l   d7,-(sp)           ;"                         \
      "movem.l  d0/d1/a0/a1,-(sp)  ;"                         \
      "move.l   " #reg ",-(sp)     ;"                         \
      "bsr      _make_ospath       ;"                         \
      "addq.l   #4,sp              ;"                         \
      "move.l   d0,d7              ;"                         \
      "movem.l  (sp)+,d0/d1/a0/a1  ;"                         \
      "move.l   d7," #reg "        ;"                         \
      "move.l   (sp)+,d7           ;"                         \
      "tst.l    " #reg "           ;"                         \
      "beq      " #ixfun #reg "    ;"                         \
      "move.l   " #reg ",-(sp)     ;");


#define PATCH_POP                                             \
                                                              \
    asm volatile(                                             \
      "bsr      _IoErr             ;"                         \
      "move.l   d0,d6              ;"                         \
      "bsr      _FreeVec           ;"                         \
      "addq.l   #4,sp              ;"                         \
      "move.l   d6,-(sp)           ;"                         \
      "bsr      _SetIoErr          ;"                         \
      "addq.l   #4,sp              ;");


#define PATCH_CALL(osfun)                                     \
                                                              \
    asm volatile(                                             \
      "move.l   a5,-(sp)           ;"                         \
      "move.l   _" #osfun ",a5     ;"                         \
      "jsr      (a5)               ;"                         \
      "move.l   d0,d7              ;"                         \
      "move.l   (sp)+,a5           ;");


#define DEF_PATCH1(osfun, ixfun, failrc, reg)                 \
                                                              \
  PATCH_INIT(osfun, ixfun, failrc)                            \
    PATCH_PUSH(ixfun, reg)                                    \
      PATCH_CALL(osfun)                                       \
      PATCH_POP                                               \
    PATCH_LAB(ixfun, reg)                                     \
  PATCH_EXIT


#define DEF_PATCH2(osfun, ixfun, failrc, reg1, reg2)          \
                                                              \
  PATCH_INIT(osfun, ixfun, failrc)                            \
    PATCH_PUSH(ixfun, reg1)                                   \
      PATCH_PUSH(ixfun, reg2)                                 \
        PATCH_CALL(osfun)                                     \
        PATCH_POP                                             \
      PATCH_LAB(ixfun, reg2)                                  \
      PATCH_POP                                               \
    PATCH_LAB(ixfun, reg1)                                    \
  PATCH_EXIT


#endif

