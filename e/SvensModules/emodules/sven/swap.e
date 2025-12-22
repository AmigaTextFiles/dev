/* does an standard ASM-swap
*/

OPT MODULE

EXPORT PROC swap(value)
  MOVE.L value,D0
  SWAP   D0
ENDPROC D0

