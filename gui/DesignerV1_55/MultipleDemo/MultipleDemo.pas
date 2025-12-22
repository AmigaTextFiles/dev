program MultipleDemo;

Uses exec,intuition,gadtools,graphics,amiga,diskfont,
     workbench,utility,MultipleDemoPascal,defs;

Var
  done        : boolean;
  class       : long;
  code        : word;
  pgsel       : pGadget;
  imsg        : pintuimessage;
  dummy       : long;
  twindowlist : tlist;
  pwinnode    : pwindownode;
  pwinnode2   : pwindownode;
  mymsgport   : pmsgport;
  loop        : long;
  count       : long;
  
function openonewin : boolean;
begin
  openonewin:=false;
  pwinnode2:=allocmem(sizeof(twindownode),memf_any or memf_clear);
  if pwinnode2<>nil then
    begin
      if openwindowpwinnodepwin(mymsgport,pwinnode2) then
        begin
          openonewin:=true;
          pwinnode2^.pwin^.userdata:=pointer(pwinnode2);
          addtail(@twindowlist,pnode(pwinnode2));
        end
       else
        freemem(pwinnode,sizeof(twindownode));
    end;
  count:=0;
  pwinnode2:=pwindownode(twindowlist.lh_head);
  while (pwinnode2^.ln_succ<>nil) do
    begin
      inc(count);
      gt_setsinglegadgetattr(pwinnode2^.pwingads[commonwin_gad2],pwinnode2^.pwin,
                             gtnm_number,count);
      pwinnode2:=pwinnode2^.ln_succ;
    end;
end;

procedure closeonewin(pwn : pwindownode);
begin
  remove(pnode(pwn));
  closewindowpwinnodepwin(pwn);
  freemem(pwinnode,sizeof(twindownode));
  count:=0;
  pwinnode2:=pwindownode(twindowlist.lh_head);
  while (pwinnode2^.ln_succ<>nil) do
    begin
      inc(count);
      gt_setsinglegadgetattr(pwinnode2^.pwingads[commonwin_gad2],pwinnode2^.pwin,
                             gtnm_number,count);
      pwinnode2:=pwinnode2^.ln_succ;
    end;
end;

Procedure ProcessMenuIDCMPCommonMenu( MenuNumber : word);
Var
  ItemNumber : Word;
  Item       : pMenuItem;
Begin
  while (MenuNumber<>MENUNULL) do
    Begin
      Item:=ItemAddress( CommonMenu, MenuNumber);
      ItemNumber:=ITEMNUM(MenuNumber);
      MenuNumber:=MENUNUM(MenuNumber);
      Case MenuNumber of
        CommonMenu_Options :
          Case ItemNumber of
            CommonMenu_Options_Item0 :
              Begin
                pwinnode2:=pwindownode(remhead(@twindowlist));
                while (pwinnode2<>nil) do
                  begin
                    if twindowlist.lh_head^.ln_succ=nil then
                      begin
                        addhead(@twindowlist,pnode(pwinnode2));
                        pwinnode2:=nil;
                      end
                     else
                      begin
                        closeonewin(pwinnode2);
                        pwinnode2:=pwindownode(remhead(@twindowlist));
                      end;
                  end;
              end;
            CommonMenu_Options_Item2 :
              Begin
                pwinnode2:=pwindownode(remhead(@twindowlist));
                while (pwinnode2<>nil) do
                  begin
                    closeonewin(pwinnode2);
                    pwinnode2:=pwindownode(remhead(@twindowlist));
                  end;
                done:=true;
              end;
           end;
       end;
      MenuNumber:=Item^.NextSelect;
    end;
end;

Begin
  newlist(@twindowlist);
  done:=false;
  if OpenLibs then
	Begin
	  mymsgport:=createmsgport;
	  if mymsgport<>nil then
		begin
		  if openonewin then
		    while (not done) do
	   		  begin
			    dummy:=Wait(bitmask(mymsgport^.mp_SigBit));
			    imsg:=GT_GetIMsg(mymsgport);
			    while (imsg <>nil ) do
			  	  begin
				    class:=imsg^.Class;
		  		    code:=imsg^.Code;
				    pgsel:=pgadget(imsg^.IAddress);
				    pwinnode:=pointer(imsg^.idcmpwindow^.userdata);
				    GT_ReplyIMsg(imsg);
				    case class of
				      IDCMP_GADGETUP :
                        Begin
                          Case pgsel^.gadgetid of
                            CommonWin_Gad0 :
                              Begin
                                if not openonewin then
                                  writeln('Could not open window.');
                              end;
                            CommonWin_Gad1 :
                              Begin
                                for loop:=1 to 5 do
                                  if not openonewin then
                                    writeln('Could not open window.');
                              end;
                           end;
                        end;
                      IDCMP_CLOSEWINDOW :
                        begin
                          closeonewin(pwinnode);
                          if twindowlist.lh_head^.ln_succ=nil then
                            done:=true;
                        end;
                      IDCMP_MENUPICK :
                        ProcessMenuIDCMPCommonMenu( Code );
				     end;
				    imsg:=GT_GetIMsg(mymsgport);
				  end;
			  end;
		  if commonmenu<>nil then
		    freemenus(commonmenu);
		  deletemsgport(mymsgport);
		end
	   else
		writeln('Cannot make msg port.');
	  CloseLibs;
	end
   else
	writeln('Cannot open libraries.');
end.
