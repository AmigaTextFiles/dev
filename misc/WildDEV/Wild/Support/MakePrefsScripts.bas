LIBRARY "dos.library"
'$INCLUDE basu:_Command.bas

v$=CHR$(34)
dir$="sw:/kube/":		app$="Kube":		GOSUB mka
dir$="sw:":			app$="SimpleWorld":	GOSUB mka
dir$="sw:/fountainOfFire/":	app$="Fountain":	GOSUB mka
dir$="sw:/earth/":		app$="Earth":		GOSUB mka
dir$="sw:/single/":		app$="Single":		GOSUB mka
dir$="sw:/cynetik/":		app$="Cynetik":		GOSUB mka
dir$="sw:/dangerousscope/":	app$="Scope":		GOSUB mka

END

mka:
name$="FASTTD":	line$="TD SimplyFast":				GOSUB mkk
name$="SAFETD":	line$="TD Monkey":				GOSUB mkk
name$="WIRE":	line$="DI TryZkren DW Wire BK no LI no":	GOSUB mkk
name$="FLAT":	line$="DW Flat BK NiX+ LI Flash":		GOSUB mkk
name$="GOURAUD":line$="DW Fluff BK ShiX LI Torch":		GOSUB mkk
name$="TEXTURE":line$="DW Candy+ BK TiX+ LI Torch":		GOSUB mkk
name$="AGA":	line$="DI "+v$+"TryPeJam+"+v$:			GOSUB mkk
name$="CGFX":	line$="DI Cyborg":				GOSUB mkk
name$="PPCAGA":	line$="DI TryNoe8":				GOSUB mkk
name$="PPCTEX": line$="DW PowerDragon LI WTorch BK WTiX":	GOSUB mkk
name$="PPCTD":	line$="TD Evolution":				GOSUB mkk
name$="PPCFULL":line$="TD Evolution DW PowerDragon LI WTorch BK WTiX DI TryNoe8":GOSUB mkk
name$="LORES":	line$="WID 320 HEI 256 MODEID 0":		GOSUB mkk
name$="HIRES":	line$="WID 640 HEI 512 MODEID $8004":		GOSUB mkk
name$="WARP3D":	line$="DW DrScott DI CyborgHi LI Torch BK no":	GOSUB mkk
Command("Delete "+dir$+"#?.info")
RETURN

mkk:
file$=dir$+"_Set"+app$+"_"+name$
OPEN file$ FOR OUTPUT AS 1
PRINT #1,"WildPJ:Tools/CloseWild"
PRINT #1,"WildPJ:Tools/SetWildAppPrefs "+app$+" save "+line$
PRINT #1,"ECHO "+CHR$(34)+name$+" Preset set to "+app$+" application."+CHR$(34)
CLOSE 1
Command("Protect "+file$+" se add")
RETURN

