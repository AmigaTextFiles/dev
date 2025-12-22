/* Patch a given binary by a given patch 
   © 1998 THOR Software. */

PARSE ARG binary patch .
if binary='?' | binary='' then; do
	say 'Usage: PatchFile.rexx <binary> <patch>,'
	say 'where <binary> is the FULL path of an object module'
	say 'and <patch> is the name of a .hop file to apply.'
	exit 0
end
if ~exists(binary) then; do
	say 'I can'D2C(39)'t find the file "'binary'", please check!'
	exit 10
end
if patch='' then;do
	say 'A Patch file (.hop file) is required for the operation.'
	exit 5
end
if ~show(P,'HUNK.1') then; do
	if ~open(.hunklocation,'ENV:Hunk','R') then; do
		address command 'RequestFile Drawer="SYS:" NoIcons Title="Please locate the Hunk" >ENV:Hunk'
		if ~open(.hunklocation,'ENV:Hunk','R') then; exit
		address command 'Copy ENV:Hunk to ENVARC:Hunk'
	end	
	wherehunk=readln(.hunklocation)
	close(.hunklocation)
	if wherehunk='' then; do
		address command 'Delete >NIL: ENV:Hunk ENVARC:Hunk'
		exit
	end
	wherehunk=substr(wherehunk,2,length(wherehunk)-2)
	snip=max(lastpos(':', wherehunk),lastpos('/', wherehunk)) +1
	filename=substr(wherehunk,snip)
	pathname=strip(left(wherehunk, snip-1),'T', '/')
	pragma('D',pathname)
	address command 'run' filename
end
do i=1 while ~show(P,'HUNK.1') & (i<10)
	address command 'Wait 1'
end
if i>9 then; do
	say "Can't lauch the Hunk processor."
	say "Delete ENV:Hunk, ENVARC:Hunk and try again."
	exit
end
address 'HUNK.1'
LOCKGUI
VERIFY off
OPEN binary
ApplyPatch patch
COUNT 'hunks'
do i=0 to hunks-1
	StripZeros i
end
SAVE binary
VERIFY on
UNLOCKGUI
WINDOWTOBACK	
