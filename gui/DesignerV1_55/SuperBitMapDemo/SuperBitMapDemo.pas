program superbitmapdemowinMain;

Uses exec,intuition,gadtools,graphics,amiga,diskfont,
     workbench,utility,superbitmapdemowin;


Var
 done  : boolean;
 class : long;
 code  : word;
 pgsel : pGadget;
 imsg  : pintuimessage;
 dummy : long;
 oldx  : word;
 oldy  : word;
 newx  : word;
 newy  : word;
 drawing  : boolean;
 myborder : tborder;

const
 ScreenName : string[40] = 'DesignerDemoPubScreen'#0;

function inbox:boolean;
begin
inbox:= (SBWin^.mousex-SBWin^.BorderLeft>7) and (SBWin^.mousex-SBWin^.BorderLeft<275) and 
        (SBWin^.mousey-SBWin^.BorderTop>38) and (SBWin^.mousey-SBWin^.BorderTop<145);
end;

Begin
with myborder do
	begin
	leftedge:=0;
    topedge:=0;
	frontpen:=1;
	BackPen:=0;
	DrawMode:=jam1;
	count:=2;
	XY:=@oldx;
	nextborder:=nil;
    end;
oldx:=65535;
oldy:=65535;
drawing:=false;
done:=false;
if OpenLibs then
	Begin
	if OpenWindowSBWin( @ScreenName[1] ) then
		begin
		while (not done) do
			begin
			dummy:=Wait(bitmask(SBWin^.UserPort^.mp_SigBit));
			imsg:=GT_GetIMsg(SBWin^.UserPort);
			while (imsg <>nil ) do
				begin
				class:=imsg^.Class;
				code:=imsg^.Code;
				pgsel:=pgadget(imsg^.IAddress); { Only reference if it is a gadget message }
				GT_ReplyIMsg(imsg);
				if (class=IDCMP_CLOSEWINDOW) then
					done:=true;
				if (class=IDCMP_REFRESHWINDOW) then
					begin
					GT_BeginRefresh(SBWin);
					GT_EndRefresh(SBWin, TRUE);
					end;
				if (class=IDCMP_MOUSEBUTTONS) then
					begin
					if code=selectup then
						begin
						drawing:=false;
					  	end
					else
						if code=selectdown then
							if inbox then
								begin
								drawing:=true;
								oldx:=SBWin^.mousex-SBWin^.BorderLeft;
								oldy:=SBWin^.mousey-SBWin^.BorderTop;
								end;
					end;
				if (class=IDCMP_MOUSEMOVE) then
					begin
					if drawing then
						begin
						if inbox then
							begin
							newx:=SBWin^.mousex-SBWin^.BorderLeft;
							newy:=SBWin^.mousey-SBWin^.BorderTop;
							if oldx<>65535 then
							  drawborder(SBWin^.rport,@myborder,0,0);
							oldx:=newx;
							oldy:=newy;
							end
						else
							begin
							oldx:=65535;
							oldy:=65535;
							end;
						end;
					end;
				if (class=IDCMP_GADGETUP) then
					begin
					if pgsel^.gadgetid=ColourGadget then
						myborder.frontpen:=code;
					end;
				imsg:=GT_GetIMsg(SBWin^.UserPort);
				end;
			end;
		CloseWindowSBWin;
		end
	else
		writeln('Cannot open window.');
	CloseLibs;
	end
else
	writeln('Cannot open libraries.');
end.
