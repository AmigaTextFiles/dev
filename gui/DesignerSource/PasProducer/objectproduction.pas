unit objectproduction;

{  
pgn data fields
  labelid         = label string
  x,y,w,h
  id
  datas           = class name
  tags[1].ti_tag  = class type
  tags[1].ti_data = scale ?
  tags[2].ti_tag  = create now ?
  tags[2].ti_data = gadget ?
  tags[3].ti_tag  = what is it ?
  tags[4].ti_tag  = dispose ?
  infolist        = list of tmytag
}

interface

uses amiga,exec,intuition,routines,definitions,liststuff,fonts,localestuff,producerlib;

procedure addmyobjectconstdata(pdwn:pdesignerwindownode;pgn:pgadgetnode);
function  getenoughtags(pdwn:pdesignerwindownode):string;
procedure doobjects(pdwn:pdesignerwindownode;spaces:string);
procedure addgadgetimagerenders(pdwn:pdesignerwindownode;spaces:string);
procedure addfreeobjects(pdwn:pdesignerwindownode;spaces:string);

implementation

procedure addfreeobjects(pdwn:pdesignerwindownode;spaces:string);
var
  pgn : pgadgetnode;
  pmt : pmytag;
begin
  pgn:=pgadgetnode(pdwn^.gadgetlist.mlh_head);
  while(pgn^.ln_succ<>nil) do
    begin
      if pgn^.kind=myobject_kind then
        begin
          if pgn^.tags[4].ti_tag<>0 then
            begin
              addline(@procfunclist,spaces+'if '+no0(pdwn^.labelid)+'gads['+no0(pgn^.labelid)+']<>nil then','');
              addline(@procfunclist,spaces+'  DisposeObject(pointer('+no0(pdwn^.labelid)+'gads['+no0(pgn^.labelid)+']));','');
            end;
        end;
      pgn:=pgn^.ln_succ;
    end;
end;

procedure doobjects(pdwn:pdesignerwindownode;spaces:string);
var
  loop : long;
  pmt,pmt2  : pmytag;
  pgn  : pgadgetnode;
  s    : string;
  s2   : string;
  s3   : string;
  pin  : pimagenode;
  num : long;
  pgn2 : pgadgetnode;
  pl : plist;
  pn : pnode;
  s4 : string;
  loop2 : long;
  pit : pintuitext;
  s6 : string;
begin
  loop:=0;
  pgn:=pgadgetnode(pdwn^.gadgetlist.mlh_head);
  while(pgn^.ln_succ<>nil) do
    begin
      loop:=0;
      if pgn^.kind=myobject_kind then
        begin
          pmt:=pmytag(pgn^.infolist.mlh_head);
          while(pmt^.ln_succ<>nil) do
            begin
              inc(loop);
              str(loop,s);
              s2:=spaces+'SetTagItem(@tags['+s+'],';
              str(pmt^.value,s);
              if pmt^.value=-1 then
                s2:=s2+sfp(pmt^.mt_label)+','
               else
                s2:=s2+s+',';
              
              
              case pmt^.tagtype of
                
                tagtypeintuitext :
                  begin
                    if pmt^.sizebuffer>0 then
                      begin
                        num:=1;
                        pit:=pintuitext(pmt^.data);
                        while(pit^.nexttext<>nil) do
                          begin
                            inc(num);
                            pit:=pit^.nexttext;
                          end;
                        
                        str(loop,s4);
                        str(num-1,s3);
                        
                        addline(@procfunclist,spaces+'for res:=0 to '+s3+' do','');
                        addline(@procfunclist,spaces+'  begin','');
                        
                        addline(@procfunclist,spaces+'    pit:=@'+no0(pgn^.labelid)+
                                   'Tag'+s4+'IntuiTexts[res];','');
                        
                        
                        if pdwn^.codeoptions[17] then
                          s3:='pScr^.Font'
                         else
                          if pdwn^.codeoptions[6] then
                            s3:='@'+makemyfont(pdwn^.gadgetfont)
                           else
                            s3:='@'+makemyfont(pgn^.font);
                 
                        addline(@procfunclist,spaces+'    pit^.ITextFont:='+s3+';','');
                        
                        s3:=no0(pgn^.labelid)+'Tag'+s4+'IntTexts';
                        if pdwn^.localeoptions[1] then
                          s3:=sfp(producernode^.getstring)+'ptr('+s3+'[res])'
                         else
                          s3:='@'+s3+'[res,1]';
                        
                        addline(@procfunclist,spaces+'    pit^.IText:='+s3+';','');
                        
                        str(num-1,s3);
                        addline(@procfunclist,spaces+'    if res<'+s3+' then','');
                        addline(@procfunclist,spaces+'      pit^.NextText:=@'+
                                             no0(pgn^.labelid)+'Tag'+s4+'IntuiTexts[res+1];','');
                        addline(@procfunclist,spaces+'  end;','');
                        s2:=s2+'long(@'+no0(pgn^.labelid)+'Tag'+s4+'IntuiTexts[0])';
                      end
                     else
                      s2:=s2+'0';
                  end;
                
                tagtypestringlist : 
                  begin
                    if pmt^.sizebuffer>0 then
                      begin
                        str(loop,s3);
                        s3:=no0(pgn^.labelid)+'Tag'+s3;
                        s2:=s2+'long(@'+s3+'List)';
                        addline(@procfunclist,spaces+'newlist(@'+s3+'List);','');
                        pl:=plist(pmt^.data);
                        loop2:=sizeoflist(pl);
                        str(loop2-1,s);
                        addline(@procfunclist,spaces+'for res:=0 to '+s+' do','');
                        addline(@procfunclist,spaces+'  begin','');
                        
                        str(loop,s4);
                        
                        if pdwn^.localeoptions[1] then
                          addline(@procfunclist,spaces+'    '+s3+'ListItems[res].ln_name:='
                                           +sfp(producernode^.getstring)+'ptr('+no0(pgn^.labelid)+'Tag'+
                                           s4+'ListViewTexts[res]);','')
                         else
                          addline(@procfunclist,spaces+'    '+s3+'ListItems[res].ln_name:=@'
                                           +no0(pgn^.labelid)+'Tag'+s4+'ListViewTexts[res,1];','');
                        
                        addline(@procfunclist,spaces+'    addtail( @'+s3+'List, @'+s3+'ListItems[res]);','');
                        addline(@procfunclist,spaces+'  end;','');
                        
                      end
                     else
                      s2:=s2+'0';
                  end;
                
                tagtypeuser :
                  begin
                    if pmt^.sizebuffer>0 then
                      begin
                        ctopas(pmt^.data^,s);
                        s2:=s2+s;
                      end
                     else
                      s2:=s2+'0';
                  end;
                
                tagtypearraystring :
                  begin
                    if pmt^.sizebuffer>0 then
                      begin
                        pla:=plongarray(pmt^.data);
                        num:=0;
                        while (pla^[num]<>0) do
                          inc(num);
                        str(num-1,s);
                        str(loop,s3);
                        addline(@procfunclist,spaces+'for res:=0 to '+s+' do','');
                        if not pdwn^.localeoptions[1] then
                          addline(@procfunclist,spaces+'  '+no0(pgn^.labelid)+'Tag'+s3+'DataArray[res]:=@'+
                                        no0(pgn^.labelid)+'Tag'+s3+'Data[res,1];','')
                         else
                          addline(@procfunclist,spaces+'  '+no0(pgn^.labelid)+'Tag'+s3+'DataArray[res]:='+
                               sfp(producernode^.getstring)+
                                        'ptr( '+no0(pgn^.labelid)+'Tag'+s3+'Data[res]);','');
                        
                        str(num,s);
                        addline(@procfunclist,spaces+no0(pgn^.labelid)+'Tag'+s3+'DataArray['+s+']:=nil;','');
                        s2:=s2+'long(@'+no0(pgn^.labelid)+'Tag'+s3+'DataArray[0])';
                      end
                     else
                      s2:=s2+'0';
                  end;
                
                tagtypeobject :
                  begin
                    str(loop,s);
                    if pmt^.data<>nil then
                      begin
                        pgn2:=pgadgetnode(pmt^.data);
                        if getlistpos(@pdwn^.gadgetlist,pnode(pgn2))<getlistpos(@pdwn^.gadgetlist,pnode(pgn)) then
                          begin
                            s2:=s2+'long('+no0(pdwn^.labelid)+'Gads['+no0(pgn2^.labelid)+'])';
                          end
                         else
                          s2:='bad';
                      end
                     else
                      s2:='bad';
                  end;
                
                tagtypestring :
                  begin
                    str(loop,s);
                    if pmt^.sizebuffer>0 then
                      if not pdwn^.localeoptions[1] then
                        s2:=s2+'long(@'+no0(pgn^.labelid)+'Tag'+s+'Data[1])'
                       else
                        begin
                          s2:=s2+'long('+sfp(producernode^.getstring)+'ptr('+no0(pgn^.labelid)+'Tag'+s+'DataString))';
                        end
                     else
                      s2:=s2+'0';
                  end;
                
                tagtypearraybyte,tagtypearraylong,tagtypearrayword :
                  begin
                    str(loop,s);
                    if pmt^.sizebuffer>0 then
                      s2:=s2+'long(@'+no0(pgn^.labelid)+'Tag'+s+'Data[0])'
                     else
                      s2:=s2+'0';
                  end;
                tagtypelong :
                  begin
                    str(long(pmt^.data),s);
                    s2:=s2+s;
                  end;
                
                tagtypeboolean :
                  begin
                    if long(pmt^.data)=0 then
                      s2:=s2+'0'
                     else
                      s2:=s2+'1';
                  end;

                tagtypeimage : 
                  begin
                    pin:=pimagenode(pmt^.data);
                    if pin<>nil then
                      s2:=s2+'long(@'+sfp(pin^.in_label)+')'
                     else
                      s2:=s2+'0';
                  end;
                
                tagtypeimagedata : 
                  begin
                    pin:=pimagenode(pmt^.data);
                    if pin<>nil then
                      s2:=s2+'long('+sfp(pin^.in_label)+'.ImageData)'
                     else
                      s2:=s2+'0';
                  end;
                
                tagtypeleftcoord :
                  begin
                    str(pgn^.x,s);
                    if (pdwn^.codeoptions[17]) then
                      s:='round('+s+'*scalex)';
                    s2:=s2+s+'+offx';
                  end;
            
                tagtypetopcoord :
                  begin
                    str(pgn^.y,s);
                    if (pdwn^.codeoptions[17]) then
                      s:='round('+s+'*scaley)';
                    s2:=s2+s+'+offy';
                  end;
                
                tagtypewidthcoord :
                  begin
                    str(pgn^.w,s);
                    if (pdwn^.codeoptions[17]) and (pgn^.tags[1].ti_data<>0) then
                      s:='round('+s+'*scalex)';
                    s2:=s2+s;
                  end;
                
                tagtypeheightcoord :
                  begin
                    str(pgn^.h,s);
                    if (pdwn^.codeoptions[17]) and (pgn^.tags[1].ti_data<>0) then
                      s:='round('+s+'*scaley)';
                    s2:=s2+s;
                  end;
            
                tagtypefont :
                  begin
                    if pdwn^.codeoptions[17] then
                      s:='pScr^.Font'
                     else
                      if pdwn^.codeoptions[6] then
                        s:='@'+makemyfont(pdwn^.gadgetfont)
                       else
                        s:='@'+makemyfont(pgn^.font);
                    s2:=s2+'long('+s+')'
                  end;
                
                tagtypegadgetid : 
                  begin
                    str(pgn^.id,s3);
                    s2:=s2+s3;
                  end;
                
                tagtypescreen : 
                  begin
                    s2:=s2+'long(PScr)';
                  end;
                
                tagtypeuser2 : 
                  begin
                    if pmt^.sizebuffer>0 then
                      begin
                        ctopas(pmt^.data^,s6);
                        s2:=s2+'long('+s6+')';
                      end
                     else
                      s2:=s2+'0';
                  end;
                
                tagtypedrawinfo : 
                  begin
                    s2:=s2+'long('+no0(pdwn^.labelid)+'DrawInfo)';
                  end;
                tagtypevisualinfo : 
                  begin
                    s2:=s2+'long('+no0(pdwn^.labelid)+'VisualInfo)';
                  end;



               end;
              if s2<>'bad' then
                begin
                  s2:=s2+');';
                  addline(@procfunclist,s2,'');
                end
               else
                dec(loop);
              pmt:=pmt^.ln_succ;
            end;
          if pgn^.tags[3].ti_tag=0 then
            begin
              inc(loop);
              str(loop,s);
              str(ga_previous,s2);
              addline(@procfunclist,spaces+'SetTagItem(@tags['+s+'],'+s2+',long(pgad));','');
            end;
          
          str(loop+1,s);
          addline(@procfunclist,spaces+'SetTagItem(@tags['+s+'],0,0);','');
          if pgn^.tags[1].ti_tag=0 then
            begin
              s:='nil,@objectname[1]';
              addline(@procfunclist,spaces+'objectname:='''+no0(pgn^.datas)+'''#0;','');
            end
           else
            s:=no0(pgn^.datas)+',nil';

          addline(@procfunclist,spaces+'if pgad<>nil then','');
          addline(@procfunclist,spaces+'    pgad2:=pgadget(NewObjectA('+s+',@tags[1]));','');
          addline(@procfunclist,spaces+'if pgad2<>nil then','');
          addline(@procfunclist,spaces+'  begin','');
          if pgn^.tags[3].ti_tag=0 then
            addline(@procfunclist,spaces+'    pgad:=pgad2;','');
          
          addline(@procfunclist,spaces+'    '+no0(pdwn^.labelid)+'Gads['+no0(pgn^.labelid)+']:=pgad2;','');
          
          
          pgn2:=pgadgetnode(pdwn^.gadgetlist.mlh_head);
          while(pgn2^.ln_succ<>nil) do
            begin
              if pgn^.kind=myobject_kind then
                begin
                  pmt2:=pmytag(pgn^.infolist.mlh_head);
                  while(pmt2^.ln_succ<>nil) do
                    begin
                      if pmt2^.tagtype=tagtypeobject then
                        begin
                          if pmt2^.data=pointer(pgn2) then
                            begin
                              if pgn2^.tags[3].ti_tag=0 then
                                begin
                                  str(pmt2^.value,s);
                                  if pmt2^.value=-1 then
                                    s:=sfp(pmt^.mt_label);
                                  addline(@procfunclist,spaces+'    SetTagItem(@tags[1],'+s+',long(pgad2));','');
                                  addline(@procfunclist,spaces+'    SetTagItem(@tags[2],0,0);','');
                                  addline(@procfunclist,spaces+'    res:=SetGadgetAttrsA(','');
                                  addline(@procfunclist,spaces+'         '+no0(pdwn^.labelid)+
                                                               'Gads['+no0(pgn2^.labelid)+'],','');
                                  addline(@procfunclist,spaces+'         nil,nil,','');
                                  addline(@procfunclist,spaces+'         @tags[1]);','');
                                end
                               else
                                begin
                                  str(pmt2^.value,s);
                                  if pmt2^.value=-1 then
                                    s:=sfp(pmt^.mt_label);
                                  addline(@procfunclist,spaces+'    SetTagItem(@tags[1],'+s+',long(pgad2));','');
                                  addline(@procfunclist,spaces+'    SetTagItem(@tags[2],0,0);','');
                                  addline(@procfunclist,spaces+'    res:=SetAttrsA(','');
                                  addline(@procfunclist,spaces+'         '+no0(pdwn^.labelid)+
                                                               'Gads['+no0(pgn2^.labelid)+'],','');
                                  addline(@procfunclist,spaces+'         @tags[1]);','');
                                end;
                            end;
                        end;
                      pmt2:=pmt2^.ln_succ;
                    end;
                end;
              pgn2:=pgn2^.ln_succ;
            end;
          addline(@procfunclist,spaces+'  end;','');
          
        end;
      pgn:=pgn^.ln_succ;
    end;

end;

procedure addmyobjectconstdata(pdwn:pdesignerwindownode;pgn:pgadgetnode);
var
  pmt :pmytag;
  s : string;
  s2 : string;
  s3 : string;
  s4 : string;
  loop : long;
  l1,l2,l3 : long;
  pla : plongarray;
  pwa : pwordarray2;
  pba : pbytearray;
  num : long;
  pin : pimagenode;
  pgn2 : pgadgetnode;
  len : word;
  pb : pbyte;
  loop2 : word;
  pl:plist;
  pn:pnode;
  cow : long;
  pit : pintuitext;
begin
  loop:=0;
  if pgn^.kind=myobject_kind then
    begin
      pmt:=pmytag(pgn^.infolist.mlh_head);
      while(pmt^.ln_succ<>nil) do
        begin
          inc(loop);
          case pmt^.tagtype of
            
            tagtypeintuitext :
              begin
                if pmt^.sizebuffer>0 then
                  begin
                    num:=1;
                    len:=0;
                    pit:=pintuitext(pmt^.data);
                    while(pit^.nexttext<>nil) do
                      begin
                        ctopas(pit^.itext^,s);
                        if length(s)>len then
                          len:=length(s);
                        inc(num);
                        pit:=pit^.nexttext;
                      end;
                    
                    pit:=pintuitext(pmt^.data);
                    
                    str(loop,s4);
                    str(num-1,s);
                    str(len+1,s3);
                    if pdwn^.localeoptions[1] then
                      addline(@procfunclist,'  '+no0(pgn^.labelid)+'Tag'+s4+'IntTexts : array [0..'+s+'] of long = (','')
                     else
                      addline(@procfunclist,'  '+no0(pgn^.labelid)+'Tag'+s4+
                              'IntTexts : array [0..'+s+'] of string['+s3+'] = (','');
                    
                    cow:=0;
                    while (pit<>nil) do
                      begin
                        if pdwn^.localeoptions[1] then
                          begin
                            str(cow,s);
                            inc(cow);
                            ctopas(pit^.itext^,s4);
                            str(loop,s3);
                            localestring(s4,no0(pgn^.labelid)+'Tag'+s3+'IntString'+s
                                ,' Window: '+no0(pdwn^.title)+' Gadget: '+no0(pgn^.title)+'Tag'+s3+'String'+s);
                            s:='    '+no0(pgn^.labelid)+'Tag'+s3+'IntString'+s;
                            if pit^.nexttext<>nil then
                              s:=s+',';
                          end
                         else
                          begin
                            ctopas(pit^.itext^,s4);
                            s:='    '''+s4+'''#0';
                            if pit^.nexttext<>nil then
                              s:=s+',';
                          end;
                        addline(@procfunclist,s,'');
                        pit:=pit^.nexttext;
                      end;
                    addline(@procfunclist,'    );','');
                    
                    
                    pit:=pintuitext(pmt^.data);
                    
                    str(loop,s4);
                    str(num-1,s);
                    addline(@procfunclist,'  '+no0(pgn^.labelid)+'Tag'+s4+'IntuiTexts : array [0..'
                       +s+'] of tintuitext = (','');
                    
                    s2:=s2+'long(@'+no0(pgn^.labelid)+'Tag'+s4+'IntuiTexts[0])';
                    
                    cow:=0;
                    while (pit<>nil) do
                      begin
                        
                        str(pit^.FrontPen,s3);
                        s:='( FrontPen : '+s3;
                        str(pit^.backpen,s3);
                        s:=s+'; BackPen : '+s3;
                        str(pit^.drawmode,s3);
                        s:=s+'; DrawMode : '+s3;

                        str(pit^.leftedge,s3);
                        s:=s+'; LeftEdge : '+s3;
                        str(pit^.topedge,s3);
                        s:=s+'; TopEdge : '+s3+' )';
                                                
                        
                        if pit^.nexttext<>nil then
                          s:=s+',';
                        addline(@procfunclist,'    '+s,'');
                        pit:=pit^.nexttext;
                      end;
                    addline(@procfunclist,'    );','');
                    
                  end
                 else
                  s2:=s2+'0';
              end;
            
            tagtypestringlist :
              begin
                if pmt^.sizebuffer>0 then
                  begin
                    pl:=plist(pmt^.data);
                    loop2:=sizeoflist(pl);
                    str(loop2-1,s);
                    str(loop,s3);
                    s3:=no0(pgn^.labelid)+'Tag'+s3;
                    addline(@varlist,'  '+s3+'List      : tlist;','');
                    addline(@varlist,'  '+s3+'ListItems : array[0..'+s+'] of tnode;','');
                    loop2:=0;
                    pn:=pnode(pl^.lh_head);
                    while (pn^.ln_succ<>nil) do
                      begin
                        ctopas(pn^.ln_name^,s);
                        if length(s)>loop2 then
                          loop2:=length(s);
                        pn:=pn^.ln_succ;
                      end;
                    str(loop2+1,s3);
                    str(loop,s4);
                    str(sizeoflist(pl)-1,s);
                    if pdwn^.localeoptions[1] then
                      addline(@procfunclist,'  '+no0(pgn^.labelid)+'Tag'+s4+'ListViewTexts : array [0..'+s+'] of long = (','')
                     else
                      addline(@procfunclist,'  '+no0(pgn^.labelid)+'Tag'+s4+
                              'ListViewTexts : array [0..'+s+'] of string['+s3+'] = (','');
                    
                    cow:=0;
                    pn:=pnode(pl^.lh_head);
                    while (pn^.ln_succ<>nil) do
                      begin
                        if pdwn^.localeoptions[1] then
                          begin
                            str(cow,s);
                            inc(cow);
                            ctopas(pn^.ln_name^,s4);
                            str(loop,s3);
                            localestring(s4,no0(pgn^.labelid)+'Tag'+s3+'String'+s
                                ,' Window: '+no0(pdwn^.title)+' Gadget: '+no0(pgn^.title)+'Tag'+s3+'String'+s);
                            s:='    '+no0(pgn^.labelid)+'Tag'+s3+'String'+s;
                            if pn^.ln_succ^.ln_succ<>nil then
                              s:=s+',';
                          end
                         else
                          begin
                            ctopas(pn^.ln_name^,s4);
                            s:='    '''+s4+'''#0';
                            if pn^.ln_succ^.ln_succ<>nil then
                              s:=s+',';
                          end;
                        addline(@procfunclist,s,'');
                        pn:=pn^.ln_succ;
                      end;
                    addline(@procfunclist,'    );','');

                    
                  end
                 else
                  s2:=s2+'0';
              end;
            
            tagtypearraystring :
              begin
                if pmt^.sizebuffer>0 then
                  begin
                    pla:=plongarray(pmt^.data);
                    len:=0;
                    num:=0;
                    while (pla^[num]<>0) do
                      begin
                        pb:=pbyte(pla^[num]);
                        ctopas(pb^,s);
                        if length(s)>len then
                          len:=length(s);
                        inc(num);
                      end;
                    
                    if not pdwn^.localeoptions[1] then
                      begin
                        str(loop,s);
                        str(num-1,s2);
                        str(len+1,s3);
                        addline(@procfunclist,'  '+no0(pgn^.labelid)+'Tag'+s+'Data : array [0..'
                                                +s2+'] of string['+s3+'] =(','');
                        str(num,s2);
                        addline(@varlist,'  '+no0(pgn^.labelid)+'Tag'+s+'DataArray : array [0..'+s2+'] of pbyte;','');
                        for loop2:=0 to num-1 do
                          begin
                            s:='';
                            if loop2<>num-1 then
                              s:=',';
                            pb:=pbyte(pla^[loop2]);
                            ctopas(pb^,s2);
                            addline(@procfunclist,'    '''+s2+'''#0'+s,'');
                          end;
                        addline(@procfunclist,'    );','');
                      end
                     else
                      begin
                        str(loop,s);
                        str(num-1,s2);
                        str(len+1,s3);
                        addline(@procfunclist,'  '+no0(pgn^.labelid)+'Tag'+s+'Data : array [0..'
                                                +s2+'] of long =(','');
                        str(num,s2);
                        addline(@varlist,'  '+no0(pgn^.labelid)+'Tag'+s+'DataArray : array [0..'+s2+'] of pbyte;','');
                        for loop2:=0 to num-1 do
                          begin
                            s:='';
                            if loop2<>num-1 then
                              s:=',';
                            pb:=pbyte(pla^[loop2]);
                            ctopas(pb^,s2);
                            str(loop2,s3);
                            str(loop,s4);
                            localestring(s2,no0(pgn^.labelid)+'Tag'+s4+'DataString'+s3,
                                         'Window: '+no0(pdwn^.title)+' Gadget: '+no0(pgn^.labelid)+' Tag '+s4+' String '+s3);
                            addline(@procfunclist,'    '+no0(pgn^.labelid)+'Tag'+s4+'DataString'+s3+s,'');
                          end;
                        addline(@procfunclist,'    );','');
                      end;
                  end;
              end;
            
            tagtypestring :
              begin
                str(loop,s);
                s2:='';
                if pmt^.sizebuffer>0 then
                  begin
                    ctopas(pmt^.data^,s2);
                    str(length(s2)+1,s3);
                    if not pdwn^.localeoptions[1] then
                      addline(@procfunclist,'  '+no0(pgn^.labelid)+'Tag'+s+'Data : string['+s3+'] = '''+no0(s2)+'''#0;','')
                     else
                      begin
                        localestring(s2,no0(pgn^.labelid)+'Tag'+s+'DataString',
                                         'Window: '+no0(pdwn^.title)+' Gadget: '+no0(pgn^.labelid)+' Tag '+s4);
                      end;
                  end;
              end;
            
            tagtypeobject :
              begin
                if pmt^.data<>nil then
                  begin
                    pgn2:=pgadgetnode(pmt^.data);
                    if getlistpos(@pdwn^.gadgetlist,pnode(pgn2))<getlistpos(@pdwn^.gadgetlist,pnode(pgn)) then
                      begin
                      end
                     else
                      dec(loop);
                  end
                 else
                  dec(loop);
              end;
            
            tagtypearraybyte,tagtypearraylong,tagtypearrayword :
              begin
                if pmt^.tagtype=tagtypearraylong then
                  s2:='long'
                 else
                  if pmt^.tagtype=tagtypearrayword then
                    s2:='word'
                   else
                    if pmt^.tagtype=tagtypearraybyte then
                      s2:='byte';
                
                str(loop,s);
                if pmt^.sizebuffer>0 then
                  begin
                    if pmt^.tagtype=tagtypearraylong then
                      num:=pmt^.sizebuffer div 4
                     else
                      if pmt^.tagtype=tagtypearrayword then
                        num:=pmt^.sizebuffer div 2
                       else
                        if pmt^.tagtype=tagtypearraybyte then
                          num:=pmt^.sizebuffer;
                    
                    str(num-1,s3);
                    
                    s2:='  '+no0(pgn^.labelid)+'Tag'+s+'Data : array [0..'+s3+'] of '+s2+' = (';
                    addline(@procfunclist,s2,'');
                    
                    l2:=0;
                    
                    pla:=plongarray(pmt^.data);
                    pwa:=pwordarray2(pmt^.data);
                    pba:=pbytearray(pmt^.data);
                    
                    for l1:=0 to ((num - 1) div 8) do
                      begin
                        s2:='';
                        for l3:=0 to 7 do
                          begin
                            if l2<num then
                              begin
                                if pmt^.tagtype=tagtypearraylong then
                                  str(pla^[l2],s3)
                                 else
                                  if pmt^.tagtype=tagtypearrayword then
                                    str(pwa^[l2],s3)
                                   else
                                    if pmt^.tagtype=tagtypearraybyte then
                                      str(pba^[l2],s3);
                                s2:=s2+s3+',';
                              end;
                            inc(l2);
                          end;
                        if l2>=num then
                          dec(s2[0],1);
                        addline(@procfunclist,'  '+s2,'');
                      end;
                    
                    addline(@procfunclist,'  );','');
                  end;
              end;

           end;
          pmt:=pmt^.ln_succ;
        end;
    end;

end;


procedure addgadgetimagerenders(pdwn:pdesignerwindownode;spaces:string);
var
  pgn : pgadgetnode;
  pmt : pmytag;
begin
  pgn:=pgadgetnode(pdwn^.gadgetlist.mlh_head);
  while(pgn^.ln_succ<>nil) do
    begin
      if pgn^.kind=myobject_kind then
        begin
          if pgn^.tags[3].ti_tag=1 then
            begin
              addline(@procfunclist,spaces+'if '+no0(pdwn^.labelid)+'gads['+no0(pgn^.labelid)+']<>nil then','');
              addline(@procfunclist,spaces+'  DrawImageState('+no0(pdwn^.labelid)+'^.RPort,','');
              addline(@procfunclist,spaces+'	pointer('+no0(pdwn^.labelid)+'gads['+no0(pgn^.labelid)+']),','');
              addline(@procfunclist,spaces+'	0,0,IDS_NORMAL,'+no0(pdwn^.labelid)+'DrawInfo);','');
            end;
        end;
      pgn:=pgn^.ln_succ;
    end;
end;

function getenoughtags(pdwn):string;
var
  pmt : pmytag;
  pgn : pgadgetnode;
  num : long;
  s : string[20];
begin
  num:=40;
  pgn:=pgadgetnode(pdwn^.gadgetlist.mlh_head);
  while(pgn^.ln_succ<>nil) do
    begin
      if pgn^.kind=myobject_kind then
        begin
          if sizeoflist(@pgn^.infolist.mlh_head)+2>num then
            num:=sizeoflist(@pgn^.infolist.mlh_head)+2;
        end;
      pgn:=pgn^.ln_succ;
    end;
  str(num,s);
  getenoughtags:=s;
end;

begin
  
end.