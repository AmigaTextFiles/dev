/* $VER: bin2hex 1.0 $
 * Convert binary to Intel Hex
 * © by Stefan Haubenthal 1992/2001
 */
/* line::= ":" size addr mark {data} checksum
   size::=00..FF
   addr::=0000..FFFF
   mark::=00 | 01
   data::=00..FF
   checksum::=-{data} */
if ~open(file,arg(1)) then exit 0*writeln(stdout,"Usage: bin2hex binary")
do addr=0 by 16
	line=readch(file,16)
	if eof(file) then leave
	line=d2c(length(line))d2c(addr,2)"00"x||line
	sum=0
	do i=1 to length(line)
		sum=sum+c2d(substr(line,i,1))
	end
	say ":"c2x(line)d2x(-sum,2)
end
say ":00000001FF"
