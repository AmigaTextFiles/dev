/* maxMem.e module test */
PMODULE 'PMODULES:maxMem'

PROC main()
  DEF availChip, maxChip, availFast, maxFast
  availChip:=AvailMem(MEMF_CHIP)
  maxChip:=maxMem(MEMF_CHIP)
  availFast:=AvailMem(MEMF_FAST)
  maxFast:=maxMem(MEMF_FAST)
  WriteF('CHIP=\d/\d\n', availChip, maxChip)
  WriteF('FAST=\d/\d\n', availFast, maxFast)
  WriteF('TOTAL=\d/\d\n', availChip+availFast, maxChip+maxFast)
ENDPROC
