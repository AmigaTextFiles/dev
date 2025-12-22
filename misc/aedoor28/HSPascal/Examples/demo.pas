PROGRAM Demo;
USES exec,AEDoor;

VAR  str:strptr;
    data:pLongint;
       d:pointer;
   username:aestring;
   key:char;

BEGIN
	AEDBase:= OpenLibrary('AEDoor.library',1);
	IF AEDBase=NIL
		{
		 Better display an alert if this call fails, because normally
		 you won't see the standard ouput, unless you use redirection
		 But this is only a demo program, so we skip the useless stuff
		}
		THEN BEGIN
			WriteLn('Needs AEDoor.library to run!');
			Halt(0);
		     END;

	{
	 Setup our communication channel with /X. NOTE: this procedure takes
	 care of stupid sysops who try to run this door from the cli! :-)
	}
	d:= CreateLink;
	IF d=NIL
		THEN BEGIN
			WriteLn('This is supposed to be run from AmiExpress!');
			CloseLibrary(AEDbase);
			Halt(0);
		     END;

	str:=  GetString(d);	{Get ptr to string field}
	data:= GetData(d);		{Get ptr to data field}

	GetDT(d,DT_NAME,'');		{Get the user's name}
	CtoPas(str^,username);		{Copy & Convert to Pascal format,
								 DON'T forget this! Since the format
								 differs ALOT!
								}

	{
	 Now let's do something we can't do in C or E. And that is, use string
	 concatination directly as a parameter to WriteStr().
	}
	WriteStr(d,'Hello '+username,LF);

	WriteStr(d,'Do you want to change your handle? (Y/N) ',NOLF);
	REPEAT
		key:= HotKey(d,'');
	UNTIL (key in ['Y','y','N','n']) OR (LC = TRUE);
	IF not LC THEN
	BEGIN
		WriteStr(d,key,LF);				{Show the pressed key}
		IF key in ['Y','y'] THEN
		BEGIN
			GetStr(d,20,username);
			IF not LC THEN
			BEGIN
			 CtoPas(str^,username);	{Copy & convert new string}
			 SetDT(d,DT_NAME,username);
			 WriteStr(d,'Done.',LF);
			END ELSE WriteStr(d,#13+#10+'LOST CARRIER!',LF);
		END;
	END ELSE WriteStr(d,#13+#10+'LOST CARRIER!',LF);

	{
	 That's it. Let's close our link with /X now. NOTE: you don't have to
	 exit your program after closing the link with /X, but remember that
	 you can NOT re-establish the link after closing it.
	}
	DeleteComm(d);
	CloseLibrary(AEDBase);
END.
