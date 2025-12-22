program essai;

{$I "include:utils/string.i"}

var
	s : string;
	c : char;
	p : Str_ListPtr;

begin
	s := allocstring(80);
	write('Enter a string : ');
	readln(s);
	write('Enter a char : ');
	readln(c);
	p := Str_C_Pos(s,c);
	while p<>nil do
	begin
		write(p^.pos:3);
		p := p^.next;
	end;
	writeln;
	if p<>nil then
		Str_FreeStr_List(p);
end.
