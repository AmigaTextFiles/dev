Program Test;

Uses
	Exec, wangi;

Var
	l : LONG;
	
Begin
	WangiBase := OpenLibrary('wangi.library',0);
	if wangibase <> NIL then begin
		Writeln(Wangi1);
		Writeln(Wangi2(5));
		Writeln(Wangi3(5));
		CloseLibrary(WangiBase);
	End else
		Writeln('cant open lib!!!');
End.
