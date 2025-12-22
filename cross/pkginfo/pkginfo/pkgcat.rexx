/* $VER: pkgcat 0.6 $ */
/* concatenate AppleLink package */
/* © by Stefan Haubenthal 1998 */
align=8
if ~arg() then exit 0*writeln(stdout,"Usage: pkgcat name")
parse arg name
if ~open(file2,name"/0") then exit 10
if ~open(file,name".pkg",W) then exit 10
call writech(file,readch(file2,260))
call close(file2)
do i=1
	if ~open(file2,name"/"i) then leave
	len=c2d(readch(file2,3))
	type=readch(file2)
	call seek(file2,4)/* \0\0\0\0 */
	rec=readch(file2,65535)
	say i"	"length(rec)-len+8
	len=length(rec)+8/* correction */
	call writech(file,d2c(len,3)type"00000000"x||rec)
	if len//align>0 then call writech(file,copies("00"x,align-len//align))
	call close(file2)
end
