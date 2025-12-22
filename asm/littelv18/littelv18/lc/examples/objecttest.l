;// object creation with littel v0.16b

#mode OBJECT

#xdef geteight
#xdef inc1

PROC geteight ;// his one just returns eight in D0
ENDPROC 8

PROC inc1   %param1 ;// call this with parameter on stack, stackcleanup is automatic
   CODESTART       ;// gotta be there!
   INC %param1
ENDPROC %param1

END ;// just a silly example //


