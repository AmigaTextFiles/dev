	.text
	.globl _HookEntryA1

_HookEntryA1:
	movel a1,SP@-
	movel a0@(12),a0
	jsr a0@
	addql #4,SP
	rts
