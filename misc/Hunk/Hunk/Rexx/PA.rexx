/* Patch a user selectable file by Hunk, automatically.
   Run PowerPacker afterwards to crunch it.
   Be warned! Due to a bug in RTPatch, this version DOES NOT
   work with RTPatch installed. If you absolutely MUST use it,
   then remove all "MultiSelect" strings, or quit RTPatch
   manually first.
  
   © 1997 THOR Software.
   PowerPacker is © Nico François		*/

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
if ~show(P,'POWERPACKER') then; do
	if ~open(.pplocation,'ENV:PowerPacker','R') then; do
		address command 'RequestFile Drawer="SYS:" NoIcons Title="Please locate the PowerPacker" >ENV:PowerPacker'
		if ~open(.pplocation,'ENV:PowerPacker','R') then; exit
		address command 'Copy ENV:PowerPacker to ENVARC:PowerPacker'
	end	
	wherepp=readln(.pplocation)
	close(.pplocation)
	if wherepp='' then; do
		address command 'Delete >NIL: ENV:PowerPacker ENVARC:PowerPacker'
		exit
	end
	wherepp=substr(wherepp,2,length(wherepp)-2)
	snip=max(lastpos(':', wherepp),lastpos('/', wherepp)) +1
	filename=substr(wherepp,snip)
	pathname=strip(left(wherepp, snip-1),'T', '/')
	pragma('D',pathname)
	address command 'run' filename
end
do i=1 while ~show(P,'HUNK.1') & (i<10)
	address command 'Wait 1'
end
do i=1 while ~show(P,'POWERPACKER') & (i<10)
	address command 'Wait 1'
end
if i>9 then; do
	say "Can't lauch the Hunk processor or the PowerPacker."
	say "Delete ENV:Hunk, ENVARC:Hunk, ENV:PowerPacker and "
	say "ENVARC:PowerPacker and try again."
	exit
end
address 'HUNK.1'
WindowToBack
address command 'Requestfile Drawer="RAM:" NoIcons MultiSelect Title="Select the file to process" >t:FileName'
if open(.filename,'T:FileName','R') then; do
	files=readln(.filename)
	Verify off
	do while files~=''
		dbcln=index(files,'"',2)
		filename=substr(files,2,dbcln-2)
		files=substr(files,dbcln+2)
		address 'HUNK.1'
		WindowToFront
		Clear
		Open '"'filename'"'
		ApplyPatch "Libnix.hop"
        	ApplyPatch "Libnix.hop"
	        ApplyPatch "Lattice.hop"
	        ApplyPatch "HCE_NorthC.hop"
	        ApplyPatch "AmigaE_32a.hop"
	        ApplyPatch "Dice_206.hop"
	        ApplyPatch "General020.hop"
	        ApplyPatch "AmigaLib.hop"
	        ApplyPatch "Ace_235.hop"
	        ApplyPatch "Silver_MULU_256.hop"
	        ApplyPatch "Silver.hop"
	        ApplyPatch "SASC_6xx.hop"
	        ApplyPatch "PCQ_12b.hop"
	        ApplyPatch "OberonII_30.hop"
	        ApplyPatch "Oberon-A_16.hop"
	        ApplyPatch "Manx.hop"
		MergeRelocs
		Save '"'filename'.new"'
		Clear
		Address 'POWERPACKER'
		PP2Front
		CommandFile
		DecrNone
		RemoveSymbol on
		RemoveDebug on
		Overwrite on
		Load filename'.new'
		Save filename'.new'
		Say '"'filename' is done. Saved as "'filename'.new"'
	end
	Address 'HUNK.1'
	WindowToBack
	Verify On
end
