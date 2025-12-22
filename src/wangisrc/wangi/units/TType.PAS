Unit TType;

INTERFACE

Uses
	Exec, Icon, Workbench, Amiga;

Function GetArgString(Args     : ppbyte; 
                      tooltype, 
                      Default  : String) : String;
Function GetArgBool  (Args     : ppbyte; 
                      tooltype : String; 
                      default  : Boolean) : Boolean;
Function GetArgInt   (Args     : ppbyte; 
                      tooltype : String; 
                      Default  : LONG) : LONG;

IMPLEMENTATION

Function GetArgString;

VAR
	tmpstr : STRPTR;
	
begin
	tooltype := tooltype + #0;
	tmpstr := FindToolType(Args, @tooltype[1]);
	If tmpstr <> NIL then
		GetArgString := PtrToPas(tmpstr)
	else
		GetArgString := default;
end;



Function GetArgBool; 

VAR
	tmpstr : STRPTR;
	
begin
	tooltype := tooltype + #0;
	tmpstr := FindToolType(Args, @tooltype[1]);
	If tmpstr <> NIL then begin
		GetArgBool := True;
	end else
		GetArgBool := Default;
end;



Function GetArgInt;

VAR
	tmpstr : STRPTR;
	err : Integer;
	tmpInt : LONG;
	
Begin
	tooltype := tooltype + #0;
	tmpstr := FindToolType(Args, @tooltype[1]);
	If tmpstr <> NIL then begin
		Val(PtrToPas(tmpstr), tmpint, err);
		If err = 0 then
			GetArgInt := tmpint
		else
			GetArgInt := default;
	end else
		GetArgInt := default;
end;


End.