
procedure StripIntuiMessages(msg : MsgPortPtr ;win : WindowPtr);
external;

procedure CloseWindowSafely(win : WindowPtr);
external;

PROCEDURE CheckMenu (win : WindowPtr; themenu, theitem, thesubitem: short);
external;

Function MenuChecked (win : WindowPtr; themenu, theitem, thesubitem: short) : Boolean;
external;



                     
               
