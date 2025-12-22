/* A little demo of what E's built-in 'Single Linked List' functions can do */

CONST STRINGLENGTH=120

DEF	stringptr=NIL,					/* a dynamic used pointer          */
	beginptr=NIL					/* the global head pointer 		*/

PROC main()
	beginptr := stringptr := make_new_string(0,'first string\n')
	stringptr := make_new_string(stringptr,'second string\n')
	stringptr := make_new_string(stringptr,'third string\n')
	stringptr := make_new_string(stringptr,'fourth string\n')
	stringptr := make_new_string(stringptr,'fifth string\n')

/************/

	WriteF('\n\nLet\as see what is in the Single Linked List...\n')

	stringptr := beginptr			/* reset to first string: beginptr */
	WriteF('1: \s',stringptr)

	stringptr := Next(stringptr)
	WriteF('2: \s',stringptr)

	stringptr := Next(stringptr)
	WriteF('3: \s',stringptr)

	stringptr := Next(stringptr)
	WriteF('4: \s',stringptr)

	stringptr := Next(stringptr)
	WriteF('5: \s',stringptr)

ENDPROC

/*--------------------------------------------------------------------------*/

PROC make_new_string(node,contents)
     DEF newentry=NIL						/* initialize as error	*/
	IF (newentry := String(STRINGLENGTH)) 		/* if we get the memory	*/
		StrCopy(newentry,contents,ALL)         	/* fill it up 			*/
		IF node
			node := Link(node,newentry)		/* link it in the chain	*/
		ENDIF
	ENDIF
ENDPROC newentry


