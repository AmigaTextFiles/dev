	;Input device commands
IDC_NEXTWIN			equ	1			;Make next window the active scroll window
IDC_SCROLL1UP		equ	2			;Scroll current logical window
IDC_SCROLLPGUP		equ	3
IDC_SCROLLHOME		equ	4
IDC_SCROLLEND		equ	5
IDC_SCROLL1DO		equ	6
IDC_SCROLLPGDO		equ	7
IDC_SCROLLRIGHT	equ	8
IDC_SCROLL1RI		equ	9
IDC_SCROLL1LE		equ	10
IDC_DSCROLL1UP		equ	11			;Scroll current debug task
IDC_DSCROLLPGUP	equ	12
IDC_DSCROLL1DO		equ	13
IDC_DSCROLLPGDO	equ	14
IDC_DSCROLLPC		equ	15
IDC_EXEC				equ	16			;Execute commandline (ptr in InputDevArg)
IDC_SNAP				equ	17			;Snap to commandline (ptr in InputDevArg)
IDC_EXECALWAYS		equ	18			;Execute always (ptr in InputDevArg)
IDC_DSCROLL1IUP	equ	19			;Scroll current debug task
IDC_DSCROLL1IDO	equ	20

LINELEN				equ	400

GRAY					equ	0
BLACK					equ	1
WHITE					equ	2
BLUE					equ	3

BoxBackgroundPen			equ	0
LWBackgroundPen			equ	1
NormalTextPen				equ	2
PromptTextPen				equ	3
StatusTextInActivePen	equ	4
StatusTextActivePen		equ	5
InActivePen					equ	6
ActivePen					equ	7
TopLeft3DPen				equ	8
BottomRight3DPen			equ	9
BoxLinePen					equ	10
EmptyBoxPen					equ	11
LeftBoxPen					equ	12
RightBoxPen					equ	13
ShowPos3DPen				equ	14
SGInActiveTextPen			equ	15
SGInActiveBackPen			equ	16
SGActiveTextPen			equ	17
SGActiveBackPen			equ	18
HilightPen					equ	19
HilightBackPen				equ	20

	;First argument is name of pen
	;Second argument is destination
	;Third argument is scratch address register (or '-' to save automatic)
GETPEN	macro
	ifc	'\3','-'
			move.l	a6,-(a7)
			movea.l	(Pens,pc),a6
			move.b	(\1,a6),\2
			movea.l	(a7)+,a6
	endc
	ifnc	'\3','-'
			movea.l	(Pens,pc),\3
			move.b	(\1,\3),\2
	endc
			endm

