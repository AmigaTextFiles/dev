/* useful for all those LoadRGB32()/GetRGB32()-systemcalls.
*/

OPT MODULE


/* converts byte unsgined (0..255) to 32bit unsigned (0 .. $ffffffff)
** == Shl(value AND $FF,24) OR Shl(value AND $FF,16) OR Shl(value AND $FF,8) OR (value AND $FF)
*/
EXPORT PROC scaleByte2ULong(value)
       MOVE.B  value.B,D0
       MOVE.B  D0,D1
       LSL.W   #8,D1
       MOVE.B  D0,D1
       MOVE.W  D1,D0
       SWAP    D0
       MOVE.W  D1,D0
ENDPROC D0


/* converts 32bit unsigned (0 .. $ffffffff) TO byte (0 .. 255)
*/
EXPORT PROC scaleULong2Byte(value)
       MOVE.L  value,D1
       MOVEQ   #0,D0
       ROL.L   #8,D1
       MOVE.B  D1,D0
ENDPROC D0

