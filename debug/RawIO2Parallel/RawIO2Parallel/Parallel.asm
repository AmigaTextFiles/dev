	xdef _ParallelIOInit
	xdef _ParallelPutChar
	;xdef _ParallelMayGetChar

	xref PRawPutChar
	xref PRawMayGetChar

_ParallelIOInit:
	; The parallel interface needs no init, but we want to replace the current
	; one with something, so it does not get called and the serial port
	; baud rate is changed.
	rts

_ParallelPutChar:
	; Bug in ddebug.lib putchar function - does not discard zero bytes.
	;
	; When a putchar function is used with exec.library/RawDoFmt() for
	; formatted output, the convention is that the output is ended by
	; sending a zero byte to the putchar function.
	;
	; The result is that a zero byte will be output at the end of every
	; formatted string that is output via the ddebug.lib putchar function.
	;
	; I guess zero bytes are discarded by parallel printers in general, as
	; this bug apparently was not discovered back in the days.
	;
	; Now however, when our intention is to redirect the "RawIO" output to the
	; parallel port and attach a device to it which converts parallel output to
	; serial output, we want to fix this bug as serial terminal software does
	; not necessarily discard zero bytes or behave well when receiving them.
	;
	tst.b	d0
	bne.s	PRawPutChar
	rts

;_ParallelMayGetChar:
;	bra.s	PRawMayGetChar
