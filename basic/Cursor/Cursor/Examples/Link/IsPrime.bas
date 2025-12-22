
' This example shows how you can link C-subprograms to BASIC-programs
' The C-program was compiled using SAS/Lattice C V5.10a

 INPUT "Enter a Number";a&
 CALL IsPrime (a&),VARPTR(IsPrime%)

 IF IsPrime% THEN
   PRINT a&;" is a prime number"
 ELSE
   PRINT a&;" is no prime number"
 END IF

 PRINT
 PRINT "Press any key to continue"
 WHILE INKEY$ = ""
   SLEEP
 WEND

 SUB EXTERNAL IsPrime (Number&,IsPrimePointer&) STATIC

' The SUB-command does the following things:
' - Whenever you call 'IsPrime' via the CALL-command the parameters of the
'   CALL-command are converted to the types specified in the SUB-command
'   and dumped on the stack.
' - The C or assembly program is called. It must have the name '_ISPRIME'
'   (must be in upper case). You MUST disable the stack-checking at the
'   beginning of a C-procedure (SAS/Lattice C: "lc -v").
' - At the moment it is not possible to get the result of the C-function
'   (returned in D0), thus the C-program must get a pointer to a variable
'   to return anything.
'   In this example program the result is returned in 'IsPrime%'.
' - 'Cursor' will not create an executable program but an object file, which
'   can be linked with the C-routines.
'   The object file created by 'Cursor' must be the first file linked!
'
' Note that the new program might not be 'pure' any more, this depends
' on the linked C or assembly language routines.

