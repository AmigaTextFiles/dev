external;

{$I "include:utils/stringlib.i"}

function Str_Insert(s,s1 : string;pos : integer) : string;

var
	s2  : string;
	l,c : integer;

begin
	l := strlen(s1);
	s2 := allocstring(strlen(s)+l+1);
	pos := pos - 1;
	for c := 0 to (pos-1) do
		s2[c] := s[c];
	for c := 0 to (l-1) do
		s2[c+pos] := s1[c];
	for c := pos to (strlen(s)-1) do
		s2[c+l] := s[c];
	Str_Insert := s2;
end;

