
LVODEF:		MACRO
		XDEF	_LVO\1
_LVO\1		EQU	\2
		ENDM

		LVODEF QuitToolManager,-36
		LVODEF AllocTMHandle,-42
		LVODEF FreeTMHandle,-48
		LVODEF CreateTMObjectTagList,-54
		LVODEF DeleteTMObject,-60
		LVODEF ChangeTMObjectTagList,-66

		END
