;/*

	flushcache
	ec icongadgets
	iconsASgads.e
	quit

*/


OPT MODULE

MODULE 'icon', 
		 'intuition/intuition',
		 'workbench/workbench',
		 '*gadgetinfo'

CONST MAX_ICONGADGETS=20

/*- (because for some reason you can't do icon.diskobj[n]:=thingy in E) -*/
OBJECT fixbugdiskobject
	diskobj:PTR TO diskobject
ENDOBJECT

EXPORT OBJECT icongadgets
	/* for icon gadgets */
	diskobj[MAX_ICONGADGETS]:ARRAY OF fixbugdiskobject	/* the icons */
	max																/* how many gadgets we have */
	win:PTR TO window												/* the window we are connected to */
ENDOBJECT

EXPORT DEF icon:PTR TO icongadgets


EXPORT PROC init_icongadgets(win:PTR TO window)
	DEF n
	
	/*- allocate some memory, and check whether it has done so -*/
	NEW icon
	IF icon=0 THEN Throw("MEM", 'init_icongadgets: Could not allocate object')
	
	/*- Make sure that all values are initialised -*/
	icon.max:=0
	icon.win:=win
	FOR n:=1 TO MAX_ICONGADGETS-1
		icon.diskobj[n].diskobj:=0
	ENDFOR
ENDPROC


EXPORT PROC end_icongadgets()
	DEF n
	IF icon
		FOR n:=1 TO MAX_ICONGADGETS-1
			IF icon.diskobj[n].diskobj THEN FreeDiskObject(icon.diskobj[n].diskobj)
		ENDFOR
		
		END icon
	ENDIF
ENDPROC

EXPORT PROC add_icongadget(id, file, text, x, y)
	/*- do some simple idiot checking -*/
	IF (id=0) OR (id>=MAX_ICONGADGETS) THEN Throw("icon", 'add_icongadget: id out of range')
	
	/*- have we already used this index? -*/
	IF icon.diskobj[id].diskobj THEN Throw("icon", 'add_icongadget: id index already used')
	
	/*- get diskobject -*/
	icon.diskobj[id].diskobj:=GetDiskObject(file)
	IF icon.diskobj[id].diskobj=NIL THEN Throw("icon", 'add_icongadget: Could not GetGiskObject')
	
	/*- modify gadget -*/
	icon.diskobj[id].diskobj.gadget.leftedge:=x
	icon.diskobj[id].diskobj.gadget.topedge:=y
	icon.diskobj[id].diskobj.gadget.gadgetid:=id

	/*- Add to windows gadget list -*/
	AddGadget(icon.win, icon.diskobj[id].diskobj.gadget, NIL)

	/*- Add icon info to this gadget -*/
	add_gadgetinfo(id, text)

	icon.max:=Max(icon.max, id+1)

	/*- pass back width and height so we can fit the icons in properly... -*/
ENDPROC icon.diskobj[id].diskobj.gadget.width, icon.diskobj[id].diskobj.gadget.height