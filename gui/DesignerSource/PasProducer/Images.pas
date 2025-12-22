unit images;

interface

uses utility,layers,gadtools,exec,intuition,dos,routines,liststuff,producerlib,
     amigados,graphics,definitions,iffparse,amiga,asl,workbench,producerwininterface;

procedure makeimagemakefunction;
procedure makeimagefreefunction;
procedure processimage(pin:pimagenode);
procedure makewaitpointer;

implementation

{ In pascal this function allocates chip ram for the images }
{ and copies the data to chip if allocated succesfully }
{ also includes waitpointer }

procedure makeimagemakefunction;
var
  pin     : pimagenode;
  oksofar : boolean;
  s       : string;
  psn     : pstringnode;
begin
  addline(@procfunclist,'','');
  addline(@procfuncdefslist,'Function MakeImages:Boolean;','');
  addline(@procfunclist,'Function MakeImages:Boolean;','');
  addline(@procfunclist,'Var','');
  addline(@procfunclist,'  oksofar : boolean;','');
  addline(@procfunclist,'begin','');
  addline(@procfunclist,'  oksofar:=true;','');
  if producernode^.codeoptions[2] then
    begin
      addline(@procfunclist,'  pWaitPointer:=AllocMem( 72, Memf_Chip);','');
      addline(@procfunclist,'  if pWaitPointer<>Nil then','');
      addline(@procfunclist,'    CopyMem(@WaitPointerData[1],pWaitPointer,72)','');
      addline(@procfunclist,'   else','');
      addline(@procfunclist,'    oksofar:=false;','');
    end;
  pin:=pimagenode(producernode^.imagelist.mlh_head);
  while(pin^.ln_succ<>nil) do
    begin
      str(pin^.sizeallocated,s);
      addline(@procfunclist,'  '+sfp(pin^.in_label)+'.imagedata:=allocmem('+s+',memf_clear or memf_chip);','');
      addline(@procfunclist,'  if '+sfp(pin^.in_label)+'.imagedata<>nil then','');
      addline(@procfunclist,'    with '+sfp(pin^.in_label)+' do','');
      addline(@procfunclist,'      begin','');
      addline(@procfunclist,'        copymem(@'+sfp(pin^.in_label)+'data,'+sfp(pin^.in_label)+'.imagedata,'+s+');','');
      addline(@procfunclist,'        leftedge:=0;','');
      addline(@procfunclist,'        topedge:=0;','');
      str(pin^.width,s);
      addline(@procfunclist,'        width:='+s+';','');
      str(pin^.height,s);
      addline(@procfunclist,'        height:='+s+';','');
      str(pin^.depth,s);
      addline(@procfunclist,'        depth:='+s+';','');
      str(pin^.planepick,s);
      addline(@procfunclist,'        planepick:='+s+';','');
      str(pin^.planeonoff,s);
      addline(@procfunclist,'        planeonoff:='+s+';','');
      addline(@procfunclist,'        nextimage:=nil;','');
      addline(@procfunclist,'      end','');
      addline(@procfunclist,'   else','');
      addline(@procfunclist,'    oksofar:=false;','');
      pin:=pin^.ln_succ;
    end;
  addline(@procfunclist,'  if not oksofar then','');
  addline(@procfunclist,'    freeimages;','');
  addline(@procfunclist,'  makeimages:=oksofar;','');
  addline(@procfunclist,'end;','');
  makeimagefreefunction;
end;

{ function to free all allocated chip ram }

procedure makeimagefreefunction;
var
  pin     : pimagenode;
  oksofar : boolean;
  s       : string;
  psn     : pstringnode;
begin
  addline(@procfunclist,'','');
  addline(@procfuncdefslist,'Procedure FreeImages;','');
  addline(@procfunclist,'Procedure FreeImages;','');
  addline(@procfunclist,'begin','');
  if producernode^.codeoptions[2] then
    begin
      addline(@procfunclist,'  If pWaitPointer<>Nil then','');
      addline(@procfunclist,'    FreeMem_( pWaitPointer, 72);','');
    end;
  pin:=pimagenode(producernode^.imagelist.mlh_head);
  while(pin^.ln_succ<>nil) do
    begin
      str(pin^.sizeallocated,s);
      addline(@procfunclist,'  if '+sfp(pin^.in_label)+'.imagedata<>nil then','');
      addline(@procfunclist,'    freemem_('+sfp(pin^.in_label)+'.imagedata,'+s+');','');
      pin:=pin^.ln_succ;
    end;
  addline(@procfunclist,'end;','');
end;

{ produces textual version of image data, with definitions }
{ also produces array containing colour definitions }

procedure processimage(pin:pimagenode);
var
  psn        : pstringnode;
  datasize   : long;
  s          : string;
  currentpos : long;
  pwa        : pwordarray;
  loop       : long;
  count      : long;
  s2         : string[20];
begin
  if pin^.colourmap<>nil then
    begin
      addline(@constlist,'','');
      str(pin^.mapsize div 2,s);
      addline(@constlist,'  '+sfp(pin^.in_label)+'Colours : array[1..'+s+'] of word =','  { Use LoadRGB4 to use this. }');
      addline(@constlist,'  (','');
      s:='  ';
      for loop:=0 to (pin^.mapsize div 2)-1 do
        begin
          str(pin^.colourmap^[loop],s2);
          s:=s+s2;
          if loop=(pin^.mapsize div 2 )-1then
            begin
              addline(@constlist,s,'');
            end
           else
            if length(s)>80 then
              begin
                s:=s+',';
                addline(@constlist,s,'');
                s:='  ';
              end
             else
              s:=s+',';
        end;
      addline(@constlist,'  );','');
    end;
  addline(@constlist,'','');
  addline(@varlist,'  '+sfp(pin^.in_label)+' : timage;','');
  if  oksofar then
    begin
      {constlist}
      psn:=allocmymem(sizeof(tstringnode),memf_clear or memf_public);
      if psn=nil then
        oksofar:=false
       else
        begin
          psn^.st:='  '+sfp(pin^.in_label)+'data : array[';
          datasize:=trunc((pin^.width+15)/16)*pin^.height*pin^.depth;
          str(datasize,s);
          psn^.st:=psn^.st+'1..'+s+'] of word='#0;
          addtail(@constlist,pnode(psn));
          inc(linecount);
        end;
      if oksofar then
        begin
          pwa:=pwordarray(pin^.imagedata);
          currentpos:=1;
          psn:=nil;
          if oksofar then
            psn:=allocmymem(sizeof(tstringnode),memf_clear or memf_public);
          if psn=nil then
            oksofar:=false
           else
            begin
              psn^.st:='  ('#0;
              addtail(@constlist,pnode(psn));
              inc(linecount);
            end;
          psn:=nil;
          if oksofar then
            psn:=allocmymem(sizeof(tstringnode),memf_clear or memf_public);
          if psn=nil then
            oksofar:=false
           else
            begin
              psn^.st:='  ';
              repeat
                str(pwa^[currentpos],s);
                if length(psn^.st+s)>79 then   {allowing for comma}
                  begin
                    psn^.st:=psn^.st+#0;
                    addtail(@constlist,pnode(psn));
                    inc(linecount);
                    if (linecount div 19)*19=linecount then
                      begin
                        setlinenumber;
                        if oksofar then
                          oksofar:=checkinput;
                      end;
                    psn:=nil;
                    if oksofar then
                      psn:=allocmymem(sizeof(tstringnode),memf_clear or memf_public);
                    if psn=nil then
                      oksofar:=false
                     else
                      psn^.st:='  ';
                  end;
                if oksofar then
                  begin
                    psn^.st:=psn^.st+s;
                    if currentpos<>datasize then
                      psn^.st:=psn^.st+','
                     else
                      begin
                        psn^.st:=psn^.st+#0;
                        addtail(@constlist,pnode(psn));
                        inc(linecount);
                        if (linecount div 19)*19=linecount then
                          begin
                            setlinenumber;
                            if oksofar then
                              oksofar:=checkinput;
                          end;
                      end;
                  end;
                inc(currentpos);
              until (not oksofar) or (currentpos>datasize);
              psn:=nil;
              if oksofar then
                psn:=allocmymem(sizeof(tstringnode),memf_clear or memf_public);
              if psn=nil then
                oksofar:=false
               else
                begin
                  psn^.st:='  );'#0;
                  addtail(@constlist,pnode(psn));
                  inc(linecount);
                end;
            end;
        end;
    end;
end;

procedure makewaitpointer;
begin
  addline(@varlist,'  pWaitPointer : pWord;','');
  addline(@initlist,'  pWaitPointer:=Nil;','');
  addline(@constlist,'','');
  addline(@constlist,'  WaitPointerData : array[1..36] of word=','');
  addline(@constlist,'  (','');
  addline(@constlist,'  $0000,$0000,$0400,$07c0,','');
  addline(@constlist,'  $0000,$07c0,$0100,$0380,','');
  addline(@constlist,'  $0000,$07e0,$07c0,$1ff8,','');
  addline(@constlist,'  $1ff0,$3fec,$3ff8,$7fde,','');
  addline(@constlist,'  $3ff8,$7fbe,$7ffc,$ff7f,','');
  addline(@constlist,'  $7ffc,$ffff,$7ffc,$ffff,','');
  addline(@constlist,'  $3ff8,$7ffe,$3ff8,$7ffe,','');
  addline(@constlist,'  $1ff0,$3ffc,$07c0,$1ff8,','');
  addline(@constlist,'  $0000,$07e0,$0000,$0000','');
  addline(@constlist,'  );','');
end;

end.