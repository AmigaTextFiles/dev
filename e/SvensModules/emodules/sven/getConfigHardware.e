/* Does Nothing than getting the system datas
** Need to be initialized onces *after* opening the Libraries
*/

OPT PREPROCESS
OPT MODULE

MODULE 'exec/execbase',
       'graphics/gfxbase'

EXPORT ENUM MC_None,
            MC68000,
            MC68010,
            MC68020,
            MC68030,
            MC68040,
            MC68060
EXPORT ENUM FPU_None,
            FPU_MC68881,
            FPU_MC68882,
            FPU_040,
            FPU_060
EXPORT ENUM GFX_None,
            GFX_Standard,
            GFX_ECS,
            GFX_AGA

DEF processor_type,
    fpu_type,
    gfx_type

#define lib_Version 20
#define ChipRevBits0 236
#define AttnFlags 296


/* Call this proc after all libraries are opened */
EXPORT PROC initConfigHardware()
->// "checks the system and initialize ALL datas"

  MOVEQ   #0,D0

  -> get version OF graphics
  MOVE.L  gfxbase,D1
  BEQ.S   no_graphics
  MOVEA.L D1,A6
  MOVE.B  ChipRevBits0(A6),D0
-> check aga
  MOVEQ   #GFX_AGA,D1
  BTST.B  #GFXB_AA_ALICE,D0
  BNE.S   gsc_gfx_ok
-> check ecs
  MOVEQ   #GFX_ECS,D1
  BTST.B  #GFXB_HR_AGNUS,D0
  BNE.S   gsc_gfx_ok
-> its an standard chipset
  MOVEQ   #GFX_Standard,D1

gsc_gfx_ok:
  MOVE.L  D1,gfx_type
no_graphics:

  MOVE.L  execbase,D1
  BEQ.S   no_exec
  MOVEA.L D1,A6
  MOVE.W  AttnFlags(A6),D0
-> check 060
  MOVEQ   #MC68060,D1
  MOVEQ   #FPU_060,D2
  BTST.W  #AFB_68060,D0
  BNE.S   gsc_processor_ok
-> check 040
  MOVEQ   #MC68040,D1
  MOVEQ   #FPU_040,D2
  BTST.W  #AFB_68040,D0
  BNE.S   gsc_processor_ok
-> check 030
  MOVEQ   #MC68030,D1
  BTST.W  #AFB_68030,D0
  BNE.S   gsc_processor_ok
-> check 020
  MOVEQ   #MC68020,D1
  BTST.W  #AFB_68020,D0
  BNE.S   gsc_processor_ok
-> check 010
  MOVEQ   #MC68010,D1
  BTST.W  #AFB_68010,D0
  BNE.S   gsc_processor_ok
-> its an 000
  MOVEQ   #MC68000,D1

gsc_processor_ok:
  MOVE.L  D1,processor_type


-> check built in (D2 IS already initalized above)
  BTST.W  #AFB_FPU40,D0
  BNE.S   gsc_fpu_ok
-> check 882
  MOVEQ   #FPU_MC68882,D2
  BTST.W  #AFB_68882,D0
  BNE.S   gsc_fpu_ok
-> check 881
  MOVEQ   #FPU_MC68881,D2
  BTST.W  #AFB_68881,D0
  BNE.S   gsc_fpu_ok
-> no fpu
  MOVEQ   #FPU_None,D2

gsc_fpu_ok:
  MOVE.L  D2,fpu_type
no_exec:

ENDPROC
->\\


/* returns TRUE if current processortype is greater or equal to 'mintype' or
** the processortype if you pass no value for 'mintype'
*/
EXPORT PROC getProcessorType(mintype=MC_None) IS
  IF mintype=MC_None THEN processor_type ELSE (processor_type>=mintype)

EXPORT PROC getFPUType(mintype=FPU_None) IS
  IF mintype=FPU_None THEN fpu_type ELSE (fpu_type>=mintype)

EXPORT PROC getChipSet(mintype=GFX_None) IS
  IF mintype=GFX_None THEN gfx_type ELSE (gfx_type>=mintype)


/* returns the pointer to the chunky2planar hardware routine or NIL
** if now hardware is installed
*/
EXPORT PROC getC2PHardwarePtr()

       MOVEQ   #NIL,D0
       MOVEA.L gfxbase,A6
       MOVEQ   #40,D1
       CMP.W   lib_Version(A6),D1
       BGT.S   noC2P
       MOVE.L  508(A6),D0
noC2P:

ENDPROC D0

