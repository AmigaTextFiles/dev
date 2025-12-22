SUB WinMsg(App$,EM$,Btn$)
{This SUB displays an error message. App$=title, EM$=error message,
 Btn$=button text.}
  WINDOW 9,App$,(0,0) - (200,50),0
  PRINT
  PRINT " ";EM$
  GADGET 1,ON,Btn$,(75,22) - (125,32),BUTTON
  GADGET WAIT 1
  WINDOW CLOSE 9
END SUB
