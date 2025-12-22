/*==========================================================================+
| test_oss_output.e                                                         |
| test writing to oss                                                       |
| test passed                                                               |
+--------------------------------------------------------------------------*/

MODULE '*oss', '*oss_output'

/*-------------------------------------------------------------------------*/

PROC main() HANDLE
	DEF i = 0, oo = NIL : PTR TO oss_output
	-> initialise
	oss_init()
	NEW oo.oss_output(1)
	-> check stuff
	WHILE oo.write(Fsin(i ! * 3.141593 * 440.0 / 22050.0)) DO i++
EXCEPT DO
	END oo
	oss_cleanup()
	-> report errors
ENDPROC IF exception THEN 5 ELSE 0

/*--------------------------------------------------------------------------+
| END: test_oss_output.e                                                    |
+==========================================================================*/
