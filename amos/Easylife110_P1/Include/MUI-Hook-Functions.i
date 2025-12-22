*****************************************************************************
* Easylife MUI Assembler Hook Funcion Include File. V1.07
* =======================================================
*
*
* When your hook function is called the following variables may be accessed
* as offsets from address register A3.
*
* E.g. The address of the application object can be found with:
*      Move.l AppObj(a3),a0
*
* Also, when your hook is called:
*
* A0 = Address of the start of your hook code that is executing
*
* A1 = As defined by the MUI Function calling your hook. Usually a string,
*      structure, or taglist specifying arguments.
*
* A2 = As defined by the MUI Function calling your hook. Usually a pointer
*      to a relevant object. 
*
* A3 = Base for variables defined below
*
*
* A4 = Address of data area you passed to the Elmui Hook function when
*      creating the hook.
*
* A5 = Normal AMOS Value of A5 when programing extensions. It is a pointer
*      to the main AMOS data zone, defined in the file  "|equ.s" which
*      is in the extensions drawer of AMOS's Extras: or AMOSPro_Tutorial:
*
* A6 = Intuition Base
*
* A7 = The Stack Pointer
*
*
* Easylife will store the neccessary registers before your hook is called,
* and restore them on exit - you may trash any register you want (Except
* A7 of course). If you need to return a value to MUI, put it in D0.
*
*
*
* Offsets from A3:

ElMUI_AMOS_A5	equ	-8	;Also in a5
ElMUI_IntBase	equ	-4	;Also in a6
ELMUI_MUIBase	equ	0	;Base of muimaster.library
				;Do not close it!
ELMUI_Tags	equ	4	;Bank number of current tagbank
ELMUI_TagLists	equ	8	;Bank number of current taglist bank
ELMUI_AppObj	equ	12	;Address of the application object
				;(Or 0 if none exists)

* Do not use values outside this range - Other easylife extension data
* is stored there, and its use may change in the future.		
