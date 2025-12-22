Unit PathList;

INTERFACE
Uses Exec, AmigaDos;

Type
	pPathList  = ^tPathList;
	tPathList  = Record
		NextPath,
		PathLock : BPTR;
	End;
	
Procedure InitPathList(VAR pl : pPathList);
Procedure CopyPathList(src : pPathList; VAR dest : pPathList);
Procedure FreePathList(VAR pl : pPathList);
	
IMPLEMENTATION	

Procedure InitPathList;

Var
	cli    : pCommandLineInterface;
	dummy  : pPathList;
	wbproc : pProcess;
	tn     : String;
	
Begin	
	{ get pointer to a path }
	pl := NIL;
	dummy := NIL;
	wbproc := NIL;
	if (pProcess(ThisTask)^.pr_Task.tc_Node.ln_Type <> NT_PROCESS) or
		   (BADDR(pProcess(ThisTask)^.pr_CLI) = NIL) then begin
		{ we have been run from Wb, copy WB pathlist }
		tn := 'Workbench'#0;
		wbproc := pProcess(FindTask(@tn[1]));
		{ make sure it is a process }
		if wbproc^.pr_Task.tc_Node.ln_Type = NT_PROCESS then begin
			cli := BADDR(wbproc^.pr_CLI);
			{ check we are a cli }
			If cli <> NIL then begin
				{ copy the path list }
				CopyPathList(pPathList(BADDR(cli^.cli_CommandDir)),pl);
			End;
		End;
	End;
End;


{ copy a path list }
Procedure CopyPathList;

Var
	pl, pl2 : pPathList;
	
Begin
	dest := NIL;
	pl2 := dest;
	While src <> NIL do begin
		pl := AllocVec(Sizeof(tPathList),MEMF_CLEAR);
		If pl <> NIL then begin
			pl^.PathLock := DupLock(src^.PathLock);
			if pl2 = NIL then begin
				pl2 := pl;
				dest := pl2;
			end else begin
				pl2^.NextPath := MKBADDR(pl);
				pl2 := pl;
			End;
			pl := NIL;
		End;
		src := BADDR(src^.NextPath);
	End;
End;


{ Free a path list }
Procedure FreePathList;

Var
	pla : pPathList;
	
Begin
	if pl <> NIL then begin
		Repeat 
			UnLock(pl^.PathLock);
			pla := BADDR(pl^.NextPath);
			FreeVec(pl);
			pl := pla;
		Until pl = NIL;
	End;
End;

End.
