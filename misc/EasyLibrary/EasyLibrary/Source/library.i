**
** Library Specific Includes and Macros
** 
** You must either include a bumprev generated include, or define the
** relevant macros that you'd find in one, eg:
**
** VERSION		EQU	37
** REVISION	EQU	1
** DATE	MACRO
** 		dc.b	'24.7.98'
** 	ENDM
** VERS	MACRO
** 		dc.b	'library 37.1'
** 	ENDM
** VSTRING	MACRO
** 		dc.b	'library 37.1 (24.7.98)',13,10,0
** 	ENDM
** VERSTAG	MACRO
** 		dc.b	0,'$VER: library 37.1 (24.7.98)',0
** 	ENDM
** 
**

		include	library_rev.i
		
LIBRARYNAME	macro
		dc.b	"library.library",0
		endm
		