/* $VER: RedHat 1.1 $
 * Extract Red Hat® (i.e. SuSE) package
 * © by Stefan Haubenthal 2001
 */
if ~arg() then exit 0*writeln(stdout,"Usage: RedHat package[.spm]")
dest="T:"
clip="package"
parse arg name"."ext
if ext="" then ext="spm"
address command
signal on ERROR

/* Pass 1a */
dest=dest||name"/"
xadunfile name"."ext dest
rxset clip "`"dir dest"`"
parse value getclip(clip) with name".cpio"ext1

/* Pass 1b */
if ext1=".gz" then do
	ext="cpio.gz"
	xadunfile dest||name"."ext dest
	delete dest||name"."ext
end

/* Pass 2 */
ext="cpio"
xadunfile dest||name"."ext dest
delete dest||name"."ext

/* Pass 3a */
ext="tar.gz"
rxset clip "`"dir dest"#?."ext"`"
parse value getclip(clip) with name".tar.gz"
if ext1=".gz" then do
	xadunfile dest||name"."ext dest
	delete dest||name"."ext

/* Pass 3b */
	ext="tar"
	xadunfile dest||name"."ext dest
end
else	xaduntar dest||name"."ext dest
delete dest||name"."ext

ERROR:
rxset clip
exit rc
