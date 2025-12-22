unit mainstuff;

interface

uses utility,layers,gadtools,exec,intuition,dos,routines,liststuff,producerlib,
     amigados,graphics,definitions,iffparse,amiga,asl,workbench,fonts;

procedure makemainfilelist;

implementation

procedure makemainfilelist;
var
  loop : byte;
  spaces : string;
  pdwn : pdesignerwindownode;
  pdsn  : pdesignerscreennode;
  s     : string[20];
begin
  pdwn:=pdesignerwindownode(producernode^.windowlist.mlh_head);
  spaces:='';
  addline(@mainfilelist,'','');
  addline(@mainfilelist,'','');
  addline(@mainfilelist,'Var','');
  addline(@mainfilelist,' done  : boolean;','');
  addline(@mainfilelist,' class : long;','');
  addline(@mainfilelist,' code  : word;','');
  addline(@mainfilelist,' pgsel : pGadget;','');
  addline(@mainfilelist,' imsg  : pintuimessage;','');
  addline(@mainfilelist,' dummy : long;','');
  if producernode^.codeoptions[12] and (sizeoflist(plist(@producernode^.screenlist))>0) then
    begin
      addline(@mainfilelist,' Scr   : pscreen;','');
    end;

  
  addline(@mainfilelist,'Begin','');
  addline(@mainfilelist,'done:=false;','');
  if (producernode^.codeoptions[4]) then
    begin
      spaces:=spaces+'	';
      addline(@mainfilelist,'if OpenLibs then','');
      addline(@mainfilelist,spaces+'Begin','');
    end;
  if producernode^.localecount>0 then
    addline(@mainfilelist,spaces+'Open'+sfp(producernode^.basename)+'Catalog(nil,nil);','');
  if producernode^.codeoptions[6] and (sizeoflist(@opendiskfontlist)>0) then
    begin
      addline(@mainfilelist,spaces+'if OpenDiskFonts then;','');
    end;
  if (sizeoflist(plist(@producernode^.imagelist))>0) and (not producernode^.codeoptions[5]) then
    begin
      addline(@mainfilelist,spaces+'if MakeImages then','');
      spaces:=spaces+'	';
      addline(@mainfilelist,spaces+'begin','');
    end;
  
  if producernode^.codeoptions[12] and (sizeoflist(plist(@producernode^.screenlist))>0) then
    begin
      pdsn:=pdesignerscreennode(producernode^.screenlist.mlh_head);
      addline(@mainfilelist,spaces+'Scr:=open'+sfp(pdsn^.sn_label)+'screen;','');
      addline(@mainfilelist,spaces+'if scr<>nil then','');
      addline(@mainfilelist,spaces+'	begin','');
      spaces:=spaces+'	';
    end;

  
  if sizeoflist(plist(@producernode^.windowlist))>0 then
    begin
      s:='';
      
      if producernode^.codeoptions[12] and (sizeoflist(plist(@producernode^.screenlist))>0) and pdwn^.customscreen then
        s:='( Scr )';
      
      if pdwn^.codeoptions[4] then
        begin
          addline(@mainfilelist,spaces+'if OpenWindow'+nicestring(no0(pdwn^.labelid))+s+' then','');
          spaces:=spaces+'	';
          addline(@mainfilelist,spaces+'begin','');
        end
       else
        begin
          addline(@mainfilelist,spaces+'OpenWindow'+nicestring(no0(pdwn^.labelid))+s+';','');
        end;
      
      addline(@mainfilelist,spaces+'while (not done) do','');
      addline(@mainfilelist,spaces+'	begin','');
      addline(@mainfilelist,spaces+'	dummy:=Wait(bitmask('+no0(pdwn^.labelid)+'^.UserPort^.mp_SigBit));','');
      addline(@mainfilelist,spaces+'	imsg:=GT_GetIMsg('+no0(pdwn^.labelid)+'^.UserPort);','');
      addline(@mainfilelist,spaces+'	while (imsg <>nil ) do','');
      addline(@mainfilelist,spaces+'		begin','');
      addline(@mainfilelist,spaces+'		class:=imsg^.Class;','');
      addline(@mainfilelist,spaces+'		code:=imsg^.Code;','');
      addline(@mainfilelist,spaces+'		pgsel:=pgadget(imsg^.IAddress); '+
             '{ Only reference if it is a gadget message }','');
      addline(@mainfilelist,spaces+'		GT_ReplyIMsg(imsg);','');
      
      if producernode^.codeoptions[3] then
        begin
          addline(@mainfilelist,spaces+'		ProcessWindow'+nicestring(no0(pdwn^.labelid))+'(class, code, pbyte(pgsel));','');
          addline(@mainfilelist,spaces+'		{ The next line is just so you can quit, '+
               'remove when proper method implemented. }','');
          addline(@mainfilelist,spaces+'		if (class=IDCMP_CLOSEWINDOW) then','');
          addline(@mainfilelist,spaces+'			done:=true;','');
         end
       else
        begin
          addline(@mainfilelist,spaces+'		if (class=IDCMP_CLOSEWINDOW) then','');
          addline(@mainfilelist,spaces+'			done:=true;','');
          addline(@mainfilelist,spaces+'		if (class=IDCMP_REFRESHWINDOW) then','');
          addline(@mainfilelist,spaces+'			begin','');
          addline(@mainfilelist,spaces+'			GT_BeginRefresh('+no0(pdwn^.labelid)+');','');
          addline(@mainfilelist,spaces+'			GT_EndRefresh('+no0(pdwn^.labelid)+', TRUE);','');
          addline(@mainfilelist,spaces+'			end;','');
        end;
      addline(@mainfilelist,spaces+'		imsg:=GT_GetIMsg('+no0(pdwn^.labelid)+'^.UserPort);','');
      addline(@mainfilelist,spaces+'		end;','');
      addline(@mainfilelist,spaces+'	end;','');
      
      addline(@mainfilelist,spaces+'CloseWindow'+no0(pdwn^.labelid)+';','');
      
      if pdwn^.codeoptions[4] then
        begin
          addline(@mainfilelist,spaces+'end','');
          dec(spaces[0],1);
          addline(@mainfilelist,spaces+'else','');
          addline(@mainfilelist,spaces+'	writeln(''Cannot open window.'');','');
        end;
      
    end
   else
    addline(@mainfilelist,spaces+'{  No windows - so not a lot to do here, ho hum. }','');
  
  if producernode^.codeoptions[12] and (sizeoflist(plist(@producernode^.screenlist))>0) then
    begin
      pdsn:=pdesignerscreennode(producernode^.screenlist.mlh_head);
      dec(spaces[0]);
      addline(@mainfilelist,spaces+'	if not CloseScreen(Scr) then','');
      addline(@mainfilelist,spaces+'		writeln(''Cannot Close Screen.'');','');
      addline(@mainfilelist,spaces+'	end','');
      addline(@mainfilelist,spaces+'else','');
      addline(@mainfilelist,spaces+'	writeln(''Cannot Open Screen.'');','');
    end;
  
  if (sizeoflist(plist(@producernode^.imagelist))>0) and (not producernode^.codeoptions[5]) then
    begin
      addline(@mainfilelist,spaces+'FreeImages;','');
      addline(@mainfilelist,spaces+'end','');
      dec(spaces[0]);
      addline(@mainfilelist,spaces+'else','');
      addline(@mainfilelist,spaces+'	writeln(''Cannot make images.'');','');
    end;
  
  if producernode^.localecount>0 then
    addline(@mainfilelist,spaces+'Close'+sfp(producernode^.basename)+'Catalog;','');
  
  if (producernode^.codeoptions[4]) then
    begin
      addline(@mainfilelist,spaces+'CloseLibs;','');
      addline(@mainfilelist,spaces+'end','');
      dec(spaces[0],1);
      addline(@mainfilelist,'else','');
      addline(@mainfilelist,'	writeln(''Cannot open libraries.'');','');
    end;
  addline(@mainfilelist,'end.','');
end;



end.