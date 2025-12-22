OPT MODULE
OPT EXPORT

MODULE 'exec/memory'
MODULE 'exec'

PROC copyListToChip(data:ILIST)
  DEF size, mem:ARRAY
  size:=ListLen(data)*SIZEOF VALUE
  mem:=NewM(size, MEMF_CHIP)
  CopyMemQuick(data, mem, size!!UINT)
ENDPROC mem
