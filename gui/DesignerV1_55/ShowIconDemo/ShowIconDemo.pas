program showicondemo;

Uses exec,intuition,gadtools,graphics,amiga,diskfont,
     workbench,utility,showicondemowin,dos;

Const
  Spaces : string = '                                        ';

Var
 done     : boolean;
 class    : long;
 code     : word;
 pgsel    : pGadget;
 imsg     : pintuimessage;
 dummy    : long;
 awport   : pmsgport;
 id       : long;
 msg      : pappmessage;
 argptr   : pwbarg;
 dirname  : string;
 filename : string;
 argtype  : long;

Procedure ProcessWindowWin0( Class : long ; Code : word ; IAddress : pbyte);
Var
  pgsel : pgadget;
Begin
  Case Class of
    IDCMP_GADGETUP :
      Begin
        { Gadget message, gadget = pgsel. }
        pgsel:=pgadget(iaddress);
      end;
    IDCMP_CLOSEWINDOW :
      Begin
        done:=true;
        { CloseWindow Now }
      end;
    IDCMP_REFRESHWINDOW :
      Begin
        GT_BeginRefresh( Win0);
        { Refresh window. }
        GT_EndRefresh( Win0, True);
      end;
   end;
end;

Begin
  id:=1;
  done:=false;
  if OpenLibs then
	Begin
	  awport:=createmsgport;
	  if awport<>nil then
	    begin
	  	  if OpenWindowWin0(awport,id) then
		    begin
		  	  while (not done) do
				begin
				  dummy:=Wait(bitmask(Win0^.UserPort^.mp_SigBit) or
				              bitmask(awport^.mp_sigbit));
				
				  { Check Window Message Port }
				  
				  imsg:=GT_GetIMsg(Win0^.UserPort);
				  while (imsg <>nil ) do
					begin
					  class:=imsg^.Class;
					  code:=imsg^.Code;
					  pgsel:=pgadget(imsg^.IAddress); { Only reference if it is a gadget message }
					  GT_ReplyIMsg(imsg);
					  ProcessWindowWin0(class, code, pbyte(pgsel));
					  imsg:=GT_GetIMsg(Win0^.UserPort);
					end;
				  
				  { Check AppWindow Port }
				  
				  msg:=pappmessage(GetMsg(awport));
				  while (msg <>nil ) do
					begin
					  
					  { This only handles the first icon in list }
					  { argptr is actually an array of pwbarg }
					  
					  argptr:=msg^.am_arglist;
					    
					  { Get directory lock }
					    
					  dirname:=fexpandlock(argptr^.wa_lock);
					  
					  { Get filename }
					  
					  ctopas(argptr^.wa_name^,filename);
					  
					  ReplyMsg(pmessage(msg));
					  
					  writeln('Dir = '+dirname+copy(spaces,1,40-length(dirname))+'  Name = '+filename);
					  
					  msg:=pappmessage(GetMsg(awport));
					end;
				  
				end;
			  CloseWindowWin0;
		    end
		   else
		    writeln('Cannot open window.');
		  
		  { Make sure message port empty before freeing }
		  
		  msg:=pappmessage(GetMsg(awport));
		  while (msg <>nil ) do
			begin
			  ReplyMsg(pmessage(msg));
			  msg:=pappmessage(GetMsg(awport));
			end;
		  
		  DeleteMsgPort(awport);
		end
	   else
		writeln('Cannot create message port.');
	  CloseLibs;
	end
   else
	writeln('Cannot open libraries.');
end.
