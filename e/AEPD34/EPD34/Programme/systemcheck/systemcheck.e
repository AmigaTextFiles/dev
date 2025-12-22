/*
** Produck...: systemcheck.e
** Version...: 0.1 (13.03.95)
** Author....: Jørgen 'Da' Larsen (Posse Pro. DK)
** Note......: Remember to read the documentation!!!
** Tabs......: 4
**
** History...: Version 0.1
**              o First release
**
*/


/********************************* Options **********************************/
OPT MODULE, REG=5


/********************************* Modules **********************************/
MODULE 'exec/execbase', 'exec/libraries'


/********************************* systemcheck Object ***********************/
EXPORT OBJECT systemcheck
 base : PTR TO execbase
ENDOBJECT


/********************************* systemcheck.init() ***********************/
->PROC init() OF systemcheck IS EMPTY


/********************************* systemcheck.new() ************************/
PROC new() OF systemcheck
 self.base := execbase
ENDPROC


/********************************* systemcheck.end **************************/
PROC end() OF systemcheck IS EMPTY
-> Dispose(self.base)
->ENDPROC


/********************************* systemcheck.getkickstartversion **********/
PROC getkickstartversion() OF systemcheck IS self.base.lib.version


/********************************* systemcheck.getkickstartrevision() *******/
PROC getkickstartrevision() OF systemcheck IS self.base.softver


/********************************* systemcheck.getvblankfrequency() *********/
PROC getvblankfrequency() OF systemcheck IS self.base.vblankfrequency


/********************************* systemcheck.getfpunumber() ***************/
PROC getfpunumber() OF systemcheck
 DEF attnflag, fpu
 attnflag := self.base.attnflags
 IF (attnflag AND AFF_68881)
	fpu := 68881
 ELSEIF (attnflag AND AFF_68882)
	fpu := 68882
 ELSEIF (attnflag AND AFF_FPU40)
	fpu := 68040
 ELSE
	fpu := FALSE
 ENDIF
ENDPROC fpu


/********************************* systemcheck.getcpunumber() ***************/
PROC getcpunumber() OF systemcheck
 DEF attnflag, cpu
 attnflag := self.base.attnflags
 IF (attnflag AND AFF_68040)
	cpu := 68040
 ELSEIF (attnflag AND AFF_68030)
	cpu := 68030
 ELSEIF (attnflag AND AFF_68020)
	cpu := 68020
 ELSEIF (attnflag AND AFF_68010)
	cpu := 68010
 ELSE
	cpu := 68000
 ENDIF
ENDPROC cpu


/********************************* systemcheck.checkaga() *******************/
PROC checkaga() OF systemcheck
 -> Orginal asm source from 'The AGA doc (V2.5) for AGA CODERS'
 -> by RANDY of COMAX
 LEA     $DFF000,A3
 MOVE.W  $7C(A3),D0            ;-> DeniseID or LisaID in AGA
 MOVEQ   #30,D2                ;-> Check 30 times ( prevents old denise random)
 ANDI.W  #%000000011111111,D0  ;-> low byte only
denloop:
 MOVE.W  $7C(A3),D1            ;-> Denise ID (LisaID on AGA)
 ANDI.W  #%000000011111111,D1  ;-> low byte only
 CMP.B   D0,D1                 ;-> same value?
 BNE.S   notaga                ;-> Not the same value, then OCS Denise!
 DBRA    D2,denloop            ;-> (THANX TO DDT/HBT FOR MULTICHECK HINT)
 ORI.B   #%11110000,D0         ;-> MASK AGA REVISION (will work on new aga)
 CMPI.B  #%11111000,D0         ;-> BIT 3=AGA (this bit will be=0 in AAA!)
 BNE.S   notaga                ;-> IS THE AGA CHIPSET PRESENT?
 RETURN  TRUE                  ;-> AGA -> Return TRUE
notaga:                        ;-> NOT AGA, BUT IS POSSIBLE AN AAA MACHINE!!
ENDPROC FALSE
