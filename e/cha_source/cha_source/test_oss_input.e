/*==========================================================================+
| test_oss_input.e                                                          |
| test reading from oss                                                     |
| test passed                                                               |
+--------------------------------------------------------------------------*/

MODULE '*oss', '*oss_input'

/*-------------------------------------------------------------------------*/

PROC main() HANDLE
	DEF i, oi = NIL : PTR TO oss_input
	oss_init()
	-> initialise
	NEW oi.oss_input(1)
	-> check stuff
	FOR i := 1 TO 20
		WriteF('\d[4]\n', ! oi.read() * 100.0 !)
	ENDFOR
	WriteF('all ok\n')
EXCEPT DO
	END oi
	oss_cleanup()
	-> report errors
ENDPROC IF exception THEN 5 ELSE 0

/*--------------------------------------------------------------------------+
| END: test_oss_input.e                                                     |
+==========================================================================*/
