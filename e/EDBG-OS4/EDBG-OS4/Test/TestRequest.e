->TestRequest.e
->Program to open up a test requester

MODULE 'intuition/intuition'

DEF testeasystruct:PTR TO easystruct, testtext:PTR TO CHAR

PROC main()
  testtext:='This is a system requester test.\n\n' +
            'This particular requester is built\n' +
            'using the EasyRequest() function.\n\n' +
            'Click Okay to continue...'

  testeasystruct:=[SIZEOF easystruct,NIL,
                   'RequestTest',testtext,'Okay']:easystruct

  EasyRequestArgs(NIL,testeasystruct,NIL,NIL)
ENDPROC
