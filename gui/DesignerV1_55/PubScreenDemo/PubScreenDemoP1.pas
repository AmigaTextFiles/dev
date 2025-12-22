program PubScreenDemoP1;

Uses exec,intuition,gadtools,graphics,amiga,diskfont,
     workbench,utility,PubScreenDemop1Win;


Var
 done  : boolean;
 class : long;
 code  : word;
 pgsel : pGadget;
 imsg  : pintuimessage;
 dummy : long;
 Scr   : pscreen;
Begin
done:=false;
if OpenLibs then
	Begin
	Scr:=openMyPubScrscreen;
	if scr<>nil then
		begin
		if OpenWindowScrWin( Scr ) then
			begin 
			if pubscreenstatus(scr,0)=0 then;
			while (not done) do
				begin
				dummy:=Wait(bitmask(ScrWin^.UserPort^.mp_SigBit));
				
				imsg:=GT_GetIMsg(ScrWin^.UserPort);
				while (imsg <>nil ) do
					begin
					class:=imsg^.Class;
					code:=imsg^.Code;
					pgsel:=pgadget(imsg^.IAddress); { Only reference if it is a gadget message }
					GT_ReplyIMsg(imsg);
					if (class=IDCMP_CLOSEWINDOW) then
						begin
						CloseWindowScrWin;
						if closescreen(scr) then
						  	begin
						  	  done:=true;
						  	  scr:=nil;
						  	end
						else
						    begin
						    if not OpenWindowScrWin( Scr ) then
		                    	begin
		                    	writeln('Could not reopen window, program failed.');
		                    	done:=true;
		                    	end;
						    end;
						end;
					if (class=IDCMP_REFRESHWINDOW) then
						begin
						GT_BeginRefresh(ScrWin);
						GT_EndRefresh(ScrWin, TRUE);
						end;
					if (class=IDCMP_GADGETUP) then
						begin
						if pgsel^.gadgetid=state then
							case code of
						    	0 : if pubscreenstatus(scr,0)=0 then;
						    	1 : if pubscreenstatus(scr,psnf_private)=0 then;
							end;
						end;
					imsg:=nil;
					if scrwin<>nil then
						imsg:=GT_GetIMsg(ScrWin^.UserPort);
					end;
				
				end;
			if scrwin<>nil then
			  	closewindowscrwin;
			end
		else
			writeln('Cannot open window.');
		if Scr<>nil then
		  if CloseScreen(Scr) then;
		end
	else
		writeln('Cannot Open Screen.');
	CloseLibs;
	end
else
	writeln('Cannot open libraries.');
end.
