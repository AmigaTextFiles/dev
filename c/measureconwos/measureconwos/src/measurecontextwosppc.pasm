## MeasureContextWOS
## by Álmos Rajnai (Rachy/BiøHazard)
## on 21.11.1999
##
##  mailto: racs@fs2.bdtf.hu
##
## measurecontextwosppc.pasm
## This part is the PowerPC core code.
## It does nothing, just returns to the caller.
##
## See .build file for compiling!

	.global	@__timerppc
	.text

	.global	_timerppc
_timerppc:
	blr
