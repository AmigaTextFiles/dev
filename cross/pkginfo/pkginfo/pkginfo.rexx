/* $VER: pkginfo/split 0.6 $ */
/* information about/split AppleLink package */
/* © by Stefan Haubenthal 1997/98 */
align=8
parse source . . "pkg"arg0 .
if ~arg() then exit 0*writeln(stdout,"Usage: pkg"arg0" name[.pkg]")
parse arg name".pkg"
call open(file,name".pkg")
if ~abbrev(readch(file,8),"package") then exit 10
if arg0="split" then address command makedir name
call seek(file,4)/* xxxx */
say "packageFlags:		"c2x(readch(file,4))
say "versionNo:		"c2d(readch(file,4))
call seek(file,2)/* \0\0 */
acl=c2d(readch(file,2))
say "authorCopyrightLength:	"acl
call seek(file,2)
pnl=c2d(readch(file,2))
say "packageNameLength:	"pnl
say "packageLength:		"c2d(readch(file,4))
say "createdTimeStamp:	"c2d(readch(file,4))
say "modifiedTimeStamp:	"c2d(readch(file,4))
call seek(file,4)/* \0\0\0\0 */
fro=c2d(readch(file,4))
say "firstRecordOffset:	"fro
say "partCount:		"c2d(readch(file,4))
call seek(file,4)/* \0\0\0\0 */
say "partOffset:		"c2d(readch(file,4))
say "lengthOfData:		"c2d(readch(file,4))
say "partType:		"readch(file,4)
call seek(file,4)/* \0\0\0\0 */
call seek(file,4)/* \0\0\0 0x81 */
say "partStringOffset:	"c2d(readch(file,2))
say "partStringLength:	"c2d(readch(file,2))
call seek(file,4)/* \0\0\0\0 */
say
say readch(file,acl)
say readch(file,pnl)
say
if arg0="split" then do
	call open(file2,name"/0",W)
	call seek(file,0,B)
	call writech(file2,readch(file,fro))
	call close(file2)
end
call seek(file,fro,B)
do i=1
	len=c2d(readch(file,3))
	if eof(file) then leave
	type=readch(file)
	call seek(file,4)/* \0\0\0\0 */
	rec=readch(file,len-8)
	if len>65535 then call seek(file,len-8-65535)
	if len//align>0 then call seek(file,align-len//align)
	select
		when type=@ then call data
		when type=A then call array
		when type=C then call frame
	end
	if arg0="split" then do
		call open(file2,name"/"i,W)
		call writech(file2,d2c(len,3)type"00000000"x||rec)
/*		if len//align>0 then call writech(file2,copies("00"x,align-len//align))*/
		call close(file2)
	end
end
exit

DATA:
class=c2x(left(rec,4))
select
	when class="00055552" then say i"	"type len"	"class substr(rec,9)
	when class="0000064D" then say i"	"type len"	"class translate(substr(rec,5),copies("7f"x,31),xrange("01"x,"1f"x))
	otherwise say i"	"type len"	"class
end
return

ARRAY:
say i"	"type len
return

FRAME:
say i"	"type len
return
