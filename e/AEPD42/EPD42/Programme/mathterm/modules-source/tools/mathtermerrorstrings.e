-> engl. Fehlerbeschreibungen zu mathterm

OPT MODULE

MODULE	'tools/mathtermerrors'


EXPORT CONST MT_ERRORLENGTH = 150

EXPORT PROC getMTErrorStr(mt_errstring, ex, info)

	SELECT ex
	CASE "MEM"  -> innerhalb von mathterm
		StringF(mt_errstring,'Out of memory')
	CASE MT_NOSTRING
		StringF(mt_errstring,'No expression-description')
	CASE MT_IDRESERVED
		StringF(mt_errstring,'Identifier "\s" is already used by another function/constant',info)
	CASE MT_UNKNOWNID
		StringF(mt_errstring,'Unknown/invalid code at position \d',info)
	CASE MT_IDTOOSHORT
		StringF(mt_errstring,'No identifier specified')
	CASE MT_NOTALLOWEDID
		StringF(mt_errstring,'Indentifier "\s" invalid.',info)
	CASE MT_VARSTWICE
		StringF(mt_errstring,'Variable-name used twice ("\s")',info)
	CASE MT_MISSOPERANDBEFORE
		StringF(mt_errstring,'Operand (constant, variable, function) before position \d expected',info)
	CASE MT_MISSOPERANDAFTER
		StringF(mt_errstring,'Operand (constant, variable, function) after position \d expected',info)
	CASE MT_MISSOPERATOR
		StringF(mt_errstring,'Operator (+ - * /  ^) expected at position \d',info)
	CASE MT_MISSOPENBRACKET
		StringF(mt_errstring,'Opening bracket expected after position \d',info)
	CASE MT_TOOMUCHOPENBR
		StringF(mt_errstring,'Missing \d closing brackets',info)
	CASE MT_TOOMUCHCLOSEBR
		StringF(mt_errstring,'Missing \d opening brackets',info)
	CASE MT_KOMMASEPARATES
		StringF(mt_errstring,'Comma separates arguments within function-calls (error at position \d)',info)
	CASE MT_WRONGARGS
		StringF(mt_errstring,'Wrong number of arguments for function "\s()"',info)
	CASE MT_STACKOVERFLOW
		StringF(mt_errstring,'Stack underflow')
	CASE MT_TERMINUSE
		StringF(mt_errstring,'Function "\s()" is still in use by other terms and therefore can\at be deleted',info)
	ENDSELECT
ENDPROC mt_errstring
