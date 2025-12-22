; This is a rewrite of original CBM autodoc example:

;##### ADF control:
;***** #c
;***** =financial.library

;***** StealMoney
;* =	Steal money from the Federal Reserve Bank. (V77)
;* i	userName,D0,STRPTR = name to make the transaction under.
;*	Popular favorites include "Ronald Reagan" and "Mohamar Quadaffi".
;* i	amount,D1.W,UWORD = Number to dollars to transfer (in thousands).
;* i	destAccount,A0,struct AccountSpec * = A filled-in AccountSpec
;*	structure detailing the destination account
;*	(see financial/accounts.h). If NULL, a second Great Depression
;*	will be triggered.
;* i	falseTrail,[A1],struct falseTrail * = If the DA_FALSETRAIL bit
;*	is set in the destAccount, a falseTrail structure must be provided.
;* r	error,D0+Z,BYTE = zero for success, else an error code is returned
;*	(see financial/errors.h). The Z condition code is guaranteed.
;* f	Transfer money from the Federal Reserve Bank into the specified
;*	interest-earning checking account.  No records of the transaction
;*	will be retained.
;* e	Federal regulations prohibit a demonstration of this function.
;* n	Do not run on Tuesdays!
;* b	Before V88, this function would occasionally print the address and
;*	home phone number of the caller on local police 976 terminals.
;*	We are confident that this problem has been resolved.
;* s	CreateAccountSpec(), security.device/SCMD_DESTROY_EVIDENCE,
;*	financial/misc.h
;*****

