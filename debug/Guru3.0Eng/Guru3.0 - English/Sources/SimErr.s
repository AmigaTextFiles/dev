* SimErr V1.01
* By E.Lensink
* Devpac III
*-----------------
* Causes a RECOVERY alert
*-----------------------------------------------------------------------

* Includes -------------------------------------------------------------

	incdir "Work:Programming/Devpac"		

	include "include/exec/exec_lib.i"		
	include	"include/intuition/intuition_lib.i"
	
	include "/subs/easystart.i"
	
* Libraries ------------------------------------------------------------

	lea		Intname,a1		Intuition	
	moveq		#0,d0			All kickstarts
	CALLEXEC 	OpenLibrary
	move.l 		d0,_IntuitionBase 
	beq		EXIT			Error ? -> EXIT
	
* Alert ----------------------------------------------------------------

	moveq		#0,d0
	lea		String,a0
	moveq		#50,d1
	CALLINT		DisplayAlert

	move.l		#$82011234,$100		Set LAST error

* Afsluiten ------------------------------------------------------------

CLALL	move.l 		_IntuitionBase,a1
	CALLEXEC	CloseLibrary
EXIT	rts

* Constanten & variabelen ----------------------------------------------

		even
Intname 	dc.b 'intuition.library'
		even
_IntuitionBase 	dc.l 0

String  	dc.w 50
		dc.b 15
		dc.b '     Software failure.     Press left mouse button to continue.',0,255
		dc.w 50
		dc.b 35
		dc.b '          Error : 82011234       Task : Just kidding...        ',0,0
	
	* String definities :
	*	Word	X-Coordinaat
	* 	Byte   	Y-Coordinaat
	*	String	Oneven aantal tekens , gevolgd door :
	*			Laatste string   -> ,0,0   (0000)
	*			Nog meer strings -> ,0,255 (00FF)
	
