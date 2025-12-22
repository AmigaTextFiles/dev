external;

{$I "include:utils/stringlib.i"}

function Str_Delete(s : string;dep,long : integer) : string;

var
	s1 : string;
	c	: integer;

begin
	s1 := allocstring(strlen(s)+1-long);
	dep := dep-1;
	for c := 0 to (dep-1) do
		s1[c] := s[c];
	for c := (dep+long) to (strlen(s)-1) do
		s1[c-long] := s[c];
	Str_Delete := s1;
end;

