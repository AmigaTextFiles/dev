external;

{$I "include:utils/stringlib.i"}

function Str_Copy(s : string;dep,long : integer) : string;

var
	s1 : string;
	c	: integer;

begin
	s1 := allocstring(long+1);
	dep := dep-1;
	for c := 0 to (long-1) do
		s1[c] := s[c+dep];
	Str_copy := s1;
end;


