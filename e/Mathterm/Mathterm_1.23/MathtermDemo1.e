/****************************************************
				Mathterm-Demo 1
-----------------------------------------------------

:description     how to interface mathterm with a
                 simple term

:author          Marcel Bennicke
                 Dorfstr. 32
                 03130 Bohsdorf
                 Germany

:email           marcel.bennicke@t-online.de

:compiler        EC V3.2e
:version         1.23
:last modified   16.06.1996

!! program will probably crash on some
!! 68040/60-Boards due to an internal error of ec
!! (module "singlesupport" drives him into problems)
*****************************************************/


MODULE 'tools/mathterms','mathieeesingbas','mathieeesingtrans',
	   'tools/SingleSupport','tools/mathtermerrorstrings'

CONST   MATHEXCEPT = "math"

PROC main() HANDLE
    DEF descr[100]:STRING, input[40]:STRING,
        func=NIL:PTR TO mathterms,r,
        out[50]:STRING,

		err_string[MT_ERRORLENGTH]:STRING,	-> space for error-strings
		type,info							-> space for error-numbers

    IF (mathieeesingbasbase:=OpenLibrary('mathieeesingbas.library',37))=NIL THEN Raise("sinB")
    IF (mathieeesingtransbase:=OpenLibrary('mathieeesingtrans.library',37))=NIL THEN Raise("sinT")

    mtsInit(MATHEXCEPT)      -> initialize module

   
    WriteF('Please enter name and description for a function\n'+
            'using two variables \ax\a and \ay\a.\n\n')

	WriteF('Name: ');ReadStr(stdout,input)
	WriteF('\s(x,y) = ',input);ReadStr(stdout,descr)

    ->create Object with input-string and variables x & y
	NEW func.mathterms(descr,['x','y'],input)

    WriteF('Enter values for x and y. Nothing for x quits.\n\n')

	LOOP
	    WriteF('x = ');ReadStr(stdout,input)
        IF EstrLen(input)=0 THEN Raise("quit")
		r:=str2Single(input)
        func.setVar(r,0)         -> set variable x (index 0)

	    WriteF('y = ');ReadStr(stdout,input)
        func.setVar(str2Single(input),1)         -> set y

        r:=func.calc()                           -> compute

        -> output results (floats must be converted into strings)
        WriteF('\s(\s,',func.getFuncName(),single2Estr(out,func.getVar(0)))
        WriteF('\s) = ',single2Estr(out,func.getVar(1)))
        WriteF('\s\n\n',single2Estr(out,r))
    ENDLOOP

EXCEPT DO

    SELECT exception
    CASE "sinB"
	    WriteF('\nError opening mathieeesingbas.library\n')
    CASE "sinT"
	    WriteF('\nError opening mathieeesingtrans.library\n')

    CASE MATHEXCEPT -> catch ALL exceptions raised by module
		-> inquire error-type and additional -info with mtsGetError() [or mtdGetError() when using doubles]
		type,info:=mtsGetError()
        -> pass these args and an EString to GetMTErrorStr() to get a description
        WriteF('\nError within mathterm:\n\s!\n',getMTErrorStr(err_string,type,info))

    CASE "quit"
        WriteF('\nProgram finished.\n')
    ENDSELECT

    END func     			-> never forget!
    mtsCleanup()

    IF mathieeesingbasbase THEN CloseLibrary(mathieeesingbasbase)
    IF mathieeesingtransbase THEN CloseLibrary(mathieeesingtransbase)
ENDPROC
