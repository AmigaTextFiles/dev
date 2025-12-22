/*
** INFO - Display some informations
**
** Author:        Allebrand Brice
** E translation: Maciej Plewa
*/

MODULE 'bignum'

PROC main()

	IF bignumbase:=OpenLibrary('BigNum.library', 37)
		BigNumInfo()
		CloseLibrary(bignumbase)
	ENDIF

ENDPROC
