Function StartCLIProgram;

VAR
	newcd   : BPTR;     { Lock for program's current directory }
	oldcd   : BPTR;     { pointer to old current directory }
	t       : Array[0..6] of tTagItem; { tags for SystemTags() }
	cmd,dir : String;
	out     : String;
	outfile : BPTR;
	rc,OK   : Boolean;

Begin
	rc := False;
	cmd := node^.LSK_Cmd[1] + #0; { null terminate }
	dir := node^.LSK_Cmd[0] + #0; { null terminate }
	newcd := Lock(@dir[1] ,SHARED_LOCK);
	if (newcd <> 0) and (node^.LSK_Cmd[1] <> '') then begin

		{ Go to program's current directory }
		oldcd := CurrentDir(newcd);

		{ open IO file }
		if node^.LSK_Output = '' then Out := 'NIL:'#0
		else out := node^.LSK_Output+#0;
		 
		outfile := Open(@out[1], MODE_OLDFILE);
		
		{ Start program }
				
		t[0].ti_Tag  := SYS_Asynch;
		t[0].ti_Data := Ord(node^.LSK_ASynch);
		t[1].ti_Tag  := SYS_Input;
		t[1].ti_Data := outfile;
		t[2].ti_Tag  := NP_StackSize;
		t[2].ti_Data := node^.LSK_Stack;
		t[3].ti_Tag  := NP_Priority;
		t[3].ti_Data := node^.LSK_Priority;
		t[4].ti_Tag  := SYS_Output;
		t[4].ti_Data := 0;
		t[5].ti_Tag  := SYS_UserShell;
		t[5].ti_Data := True_;
		t[6].ti_Tag  := TAG_END;
				
		if SystemTagList(@cmd[1],@t) = 0 then
       	rc := TRUE; { Program started! }
       	
      if NOT rc then begin
      	ok := Close_(outfile);
      	outfile := 0;
      end;
      
      if NOT node^.LSK_ASynch then begin
      	if outfile <> 0 then
      		ok := Close_(outfile);
      end;
      	
      { Go back to old current directory }
      newcd := CurrentDir(oldcd);
	End;
	UnLock(newcd);
	if node^.LSK_Cmd[1] = '' then 
		rc := True;
	StartCLIProgram := rc;
End;
