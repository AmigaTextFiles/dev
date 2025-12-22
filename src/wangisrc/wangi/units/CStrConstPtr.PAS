Unit CstrConstPtr;

INTERFACE

USES 
	Intuition, Exec;

Function CSCPAR(rk : ppRemember; s : String) : STRPTR;

IMPLEMENTATION

function CSCPAR;

VAR
	p : STRPTR;
	
begin
  s := s + #0;
  p := AllocRemember(rk, length(s), MEMF_CLEAR);
  if p <> NIL then
  	move(s[1], p^, length(s));
  CSCPAR := p;
end;

End. {unit}