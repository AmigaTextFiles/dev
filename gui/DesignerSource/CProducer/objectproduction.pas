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

uses amiga,exec,intuition,definitions,producerlib;

procedure addmyobjectconstdata(pdwn:pdesignerwindownode;pgn:pgadgetnode);
function  getenoughtags(pdwn:pdesignerwindownode):string;
function doobjects(pdwn:pdesignerwindownode;pgn:pgadgetnode;pos:long):long;
procedure addgadgetimagerenders(pdwn:pdesignerwindownode;spaces:string);
procedure addfreeobjects(pdwn:pdesignerwindownode;spaces:string);
procedure thosewhichneedscaling(pdwn:pdesignerwindownode;spaces:string);
function addwintags(pdwn:pdesignerwindownode;spaces:string):long;
procedure addcreateobjectcode(pdwn:pdesignerwindownode;spaces:string);

implementation

procedure addcreateobjectcode(pdwn:pdesignerwindownode;spaces:string);
var
  s2 : string;
  pmt : pmytag;
  s,s3 : string;
  pgn : pgadgetnode;
  pgn2: pgadgetnode;
  s6,s7 : string;
begin
      str(sizeoflist(@pdwn^.gadgetlist),s2);
      addline(@procfunclist,spaces+'for ( loop=0 ; loop<'+s2+' ; loop++ )','');
      
      addline(@procfunclist,spaces+'	if ('+nicestring(no0(pdwn^.labelid))+'GadgetTypes[loop] == 198)','');
      
      spaces:=spaces+'	';
      
      addline(@procfunclist,spaces+'	{','');
      
      addline(@procfunclist,spaces+'	'+no0(pdwn^.labelid)+'Gadgets[ loop ] = NULL;','');
      
      
      s:=no0(pdwn^.labelid)+'Gadgets[ loop ] = ';
      
      if producernode^.codeoptions[10] then
        s2:=nicestring(no0(pdwn^.labelid))+'NGad[ loop ]'
       else
        s2:=nicestring(no0(pdwn^.labelid))+'NewGadgets[ loop ]';
      
      addline(@procfunclist,spaces+'	Cla = NULL;','');
      pgn:=pgadgetnode(pdwn^.gadgetlist.mlh_head);
      while(pgn^.ln_succ<>nil) do
        begin
          
          if pgn^.kind=myobject_kind then
          begin
          
          addline(@procfunclist,spaces+'	if ( loop ==  ( '+no0(pgn^.labelid)+'  - '+
                           nicestring(no0(pdwn^.labelid))+'FirstID ))','');
          addline(@procfunclist,spaces+'		{','');
          if pgn^.tags[1].ti_tag=1 then
            begin
              addline(@procfunclist,spaces+'		Cla = (APTR)'+no0(pgn^.datas)+';','');
            end;
          
          pmt:=pmytag(pgn^.infolist.mlh_head);
          while(pmt^.ln_succ<>nil) do
            begin
              if pmt^.tagtype=tagtypeobject then
                begin
                  str(long(pmt^.pos),s6);
                  pgn2:=pgadgetnode(pmt^.data);
                  if pgn2<>nil then
                    if getlistpos(@pdwn^.gadgetlist,pnode(pgn2))<getlistpos(@pdwn^.gadgetlist,pnode(pgn)) then
                      begin
                        s7:=no0(pdwn^.labelid)+'Gadgets['+no0(pgn2^.labelid)+' - '
                                  +nicestring(no0(pdwn^.labelid))+'FirstID]';
                        addline(@procfunclist,spaces+'		'+nicestring(no0(pdwn^.labelid))+
                              'GadgetTags['+s6+'] = (ULONG)'+s7+';','');
                      end;
                end;
              pmt:=pmt^.ln_succ;
            end;
          
          if pgn^.tags[3].ti_tag=0 then
            begin
              str(pgn^.prevtagpos,s6);
              if pgn^.prevobject=nil then
                s7:='Gad'
               else
                s7:=no0(pdwn^.labelid)+'Gadgets['+no0(pgn^.prevobject^.labelid)+' - '
                                +nicestring(no0(pdwn^.labelid))+'FirstID]';
              addline(@procfunclist,spaces+'		'+nicestring(no0(pdwn^.labelid))+'GadgetTags['+s6+'] = (ULONG)'+s7+';','');
            end;
          
          addline(@procfunclist,spaces+'		}','');
          
          end;
          
          pgn:=pgn^.ln_succ;
        end;
      addline(@procfunclist,spaces+'	if (Gad)','');
      addline(@procfunclist,spaces+'		'+s+'Gad2 = (struct Gadget *) NewObjectA( (struct IClass *)Cla, '+
                                          s2+'.ng_GadgetText, (struct TagItem *)'+s2+'.ng_UserData );',''); 
      
      pgn:=pgadgetnode(pdwn^.gadgetlist.mlh_head);
      while(pgn^.ln_succ<>nil) do
        begin
          
          if pgn^.kind=myobject_kind then
          begin
          
          addline(@procfunclist,spaces+'	if ( (loop ==  ( '+no0(pgn^.labelid)+'  - '+
                           nicestring(no0(pdwn^.labelid))+'FirstID )) && (Gad2))','');
          addline(@procfunclist,spaces+'		{','');
          
          
           pgn2:=pgadgetnode(pdwn^.gadgetlist.mlh_head);
           
           while (pgn2^.ln_succ<>nil) do
             begin
                    
               if (getlistpos(@pdwn^.gadgetlist,pnode(pgn2))<getlistpos(@pdwn^.gadgetlist,pnode(pgn))) 
                  and (pgn2^.kind=myobject_kind) then
                 begin
                   pmt:=pmytag(pgn2^.infolist.mlh_head);
                   while(pmt^.ln_succ<>nil) do
                     begin
                        
                       if (pmt^.tagtype=tagtypeobject)and(pmt^.data=pointer(pgn)) then
                        begin
                        
                        s6:=no0(pgn2^.labelid)+' - '
                                  +nicestring(no0(pdwn^.labelid))+'FirstID';
                        
                        s3:=nicestring(no0(pdwn^.labelid))+'Gadgets[ '+s6+' ]';
                        
                        str(pmt^.value,s2);
                        if pmt^.value=-1 then
                          s2:=sfp(pmt^.mt_label);
                        if pgn^.tags[3].ti_tag>0 then
                          begin
                            s:='SetAttrs( (APTR)'+s3+', (ULONG)'+s2+', (ULONG)Gad2, 0);';
                          end
                         else
                          begin
                            s:='SetGadgetAttrs( (APTR)'+s3+', NULL, NULL, (ULONG)'+s2+', (ULONG)Gad2, 0);';
                            addline(@procfunclist,spaces+'		Gad = Gad2;','');
                          end;
                        addline(@procfunclist,spaces+'		'+s,'');
                 
                        end;
                 
                        pmt:=pmt^.ln_succ;
                     end;
                 end;
              pgn2:=pgn2^.ln_succ;
            end;
           
          addline(@procfunclist,spaces+'		}','');
          
          end;
          
          pgn:=pgn^.ln_succ;
        end;
      
  addline(@procfunclist,spaces+'	}','');

end;

procedure thosewhichneedscaling(pdwn:pdesignerwindownode;spaces:string);
var
  pgn : pgadgetnode;
  pin : pimagenode;
  pmt : pmytag;
  loop : long;
  s,s2:string;
  s4 : string;
  s3 : string;
  pgn2:pgadgetnode;
  num : long;
  pit : pintuitext;
  s6 : string;
begin
  pgn:=pgadgetnode(pdwn^.gadgetlist.mlh_head);
  while(pgn^.ln_succ<>nil) do
    begin
      if pgn^.kind=myobject_kind then
        begin
          loop:=0;
          pmt:=pmytag(pgn^.infolist.mlh_head);
          while(pmt^.ln_succ<>nil) do
            begin
              case pmt^.tagtype of
                tagtypefont :
                  begin
                    str(pgn^.tags[10].ti_tag+loop*2,s3);
                    if pdwn^.codeoptions[17] then
                      addline(@procfunclist,spaces+nicestring(no0(pdwn^.labelid))+'GadgetTags['+s3
                              +'] = (ULONG)Scr->Font;','');
                    
                  end;
                tagtypeobject :
                  begin
                    str(loop,s);
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
                
                tagtypescreen :
                  begin
                    str(pgn^.tags[10].ti_tag+loop*2,s3);
                    addline(@procfunclist,spaces+nicestring(no0(pdwn^.labelid))+'GadgetTags['+s3
                              +'] = (ULONG)Scr;','');
                  end;
                tagtypeuser2 :
                  begin
                    str(pgn^.tags[10].ti_tag+loop*2,s3);
                    if pmt^.sizebuffer>0 then
                      begin
                        ctopas(pmt^.data^,s6);
                        addline(@procfunclist,spaces+nicestring(no0(pdwn^.labelid))+'GadgetTags['+s3
                                  +'] = (ULONG)'+no0(s6)+';','');
                      end;
                  end;
                tagtypevisualinfo :
                  begin
                    str(pgn^.tags[10].ti_tag+loop*2,s3);
                    addline(@procfunclist,spaces+nicestring(no0(pdwn^.labelid))+'GadgetTags['+s3
                              +'] = (ULONG)'+no0(pdwn^.labelid)+'VisualInfo;','');
                  end;
                tagtypedrawinfo :
                  begin
                    str(pgn^.tags[10].ti_tag+loop*2,s3);
                    addline(@procfunclist,spaces+nicestring(no0(pdwn^.labelid))+'GadgetTags['+s3
                              +'] = (ULONG)'+no0(pdwn^.labelid)+'DrawInfo;','');
                  end;
                tagtypeimagedata :
                  begin
                    pin:=pimagenode(pmt^.data);
                    if pin<>nil then
                      begin
                         str(pgn^.tags[10].ti_tag+loop*2,s3);
                         addline(@procfunclist,spaces+nicestring(no0(pdwn^.labelid))+'GadgetTags['+s3
                              +'] = (ULONG)'+sfp(pin^.in_label)+'.ImageData;','');
                      end;
                  end;
                tagtypeleftcoord,tagtypetopcoord,tagtypewidthcoord,tagtypeheightcoord :
                  begin
                    str(pgn^.tags[10].ti_tag+loop*2,s3);
                    case pmt^.tagtype of
                      tagtypeleftcoord :
                        begin
                          str(pgn^.x,s2);
                          if pdwn^.codeoptions[17] then
                            s2:=s2+'*scalex/65535';
                          s2:='offx + '+s2;
                        end;
                      tagtypetopcoord :
                        begin
                          str(pgn^.y,s2);
                          if pdwn^.codeoptions[17] then
                            s2:=s2+'*scaley/65535';
                          s2:='offy + '+s2;
                        end;
                      tagtypewidthcoord :
                        begin
                          str(pgn^.w,s2);
                          if pdwn^.codeoptions[17] and (pgn^.tags[1].ti_data<>0) then
                            s2:=s2+'*scalex/65535';
                        end;
                      tagtypeheightcoord :
                        begin
                          str(pgn^.h,s2);
                          if pdwn^.codeoptions[17] and (pgn^.tags[1].ti_data<>0) then
                            s2:=s2+'*scaley/65535';
                        end;
                     end;
                    addline(@procfunclist,spaces+nicestring(no0(pdwn^.labelid))+'GadgetTags['+s3
                              +'] = (ULONG)('+s2+');','');
                  end;
                tagtypeintuitext :
                  begin
                    if (pmt^.sizebuffer>0) and (pdwn^.codeoptions[17]) then
                      begin
                        num:=1;
                        pit:=pintuitext(pmt^.data);
                        while(pit^.nexttext<>nil) do
                          begin
                            inc(num);
                            pit:=pit^.nexttext;
                          end;
                        
                        str(loop,s4);
                        str(num,s3);
                        addline(@procfunclist,spaces+
                                   'for (loop = 0; loop < '+s3+'; loop++ )','');
                        addline(@procfunclist,spaces+'	'+
                                 no0(pgn^.labelid)+'Tag'+s4+'IntuiTexts[ loop ].ITextFont = Scr->Font;','');;
                        
                      end;

                  end;
               end;
              inc(loop);
              pmt:=pmt^.ln_succ;
            end;
        end;
      pgn:=pgn^.ln_succ;
    end;

end;  

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
              addline(@procfunclist,spaces+'if ('+no0(pdwn^.labelid)+
                              'Gadgets['+no0(pgn^.labelid)+'])','');
              addline(@procfunclist,spaces+'	DisposeObject( ( APTR ) '+
                        no0(pdwn^.labelid)+'Gadgets['+no0(pgn^.labelid)+'] );','');
            end;
        end;
      pgn:=pgn^.ln_succ;
    end;
end;

function doobjects( pdwn:pdesignerwindownode ; pgn : pgadgetnode ; pos:long ):long;
var
  loop  : long;
  pmt,pmt2  : pmytag;
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
begin
  pgn^.prevobject:=nil;
  if pgn^.tags[3].ti_tag=0 then
    begin
      pgn^.prevobject:=lastobject;
      lastobject:=pgn;
    end;
  
  pgn^.tags[10].ti_tag:=pos;
  loop:=0;
          
          pmt:=pmytag(pgn^.infolist.mlh_head);
          while(pmt^.ln_succ<>nil) do
            begin
              str(loop,s);
              s2:='(ULONG)(';
              str(pmt^.value,s);
              
              if pmt^.value=-1 then
                s2:=s2+sfp(pmt^.mt_label)+'),'
               else
                s2:=s2+s+'),';
              
              
              case pmt^.tagtype of
                
                tagtypeintuitext :
                  begin
                    if (pmt^.sizebuffer>0) then
                      begin
                        num:=1;
                        pit:=pintuitext(pmt^.data);
                        while(pit^.nexttext<>nil) do
                          begin
                            inc(num);
                            pit:=pit^.nexttext;
                          end;
                        
                        str(loop,s4);
                        str(num,s3);
                        
                        if pdwn^.localeoptions[1] then
                          begin
                        
                            addline(@procfunclist,'	for (loop = 0; loop < '+s3+'; loop++ )','');
                            addline(@procfunclist,'		'+no0(pgn^.labelid)+'Tag'+s4+'IntuiTexts[ loop ].IText = '
                                              +sfp(producernode^.getstring)+'( (ULONG) '+
                                                      no0(pgn^.labelid)+'Tag'+s4+'IntuiTexts[ loop ].IText );','');
                        
                          end;
                        
                        s2:=s2+'(ULONG)&'+no0(pgn^.labelid)+'Tag'+s4+'IntuiTexts[0]';
                        
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
                        s2:=s2+'(ULONG)&'+s3+'List';
                        
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
                        str(loop,s3);
                        s2:=s2+'(ULONG)&'+no0(pgn^.labelid)+'Tag'+s3+'DataArray[0]';
                        
                        if pdwn^.localeoptions[1] then
                          begin  
                            str(loop,s4);
                            pla:=plongarray(pmt^.data);
                            num:=0;
                            while(pla^[num]<>0) do
                              inc(num);
                            str(num,s3);
                            addline(@procfunclist,'	for (loop=0; loop<'+s3+'; loop++ )','');
                            addline(@procfunclist,'		'+no0(pgn^.labelid)+'Tag'+
                                       s4+'DataArray[loop] = '
                                    +sfp(producernode^.getstring)+'((ULONG)'+
                                    no0(pgn^.labelid)+'Tag'+s4+'DataArray[loop]);','');

                          end;

                        
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
                            s2:=s2+'0';
                            pmt^.pos:=pos+loop*2;
                          end
                         else
                          s2:='bad';
                      end
                     else
                      s2:='bad';
                  end;
                
                tagtypestring :
                  begin
                    if pmt^.sizebuffer>0 then
                      begin
                        ctopas(pmt^.data^,s);
                        if not pdwn^.localeoptions[1] then
                          s2:=s2+'(ULONG)"'+s+'"'
                         else
                          begin
                            str(loop,s4);
                            localestring(s,no0(pgn^.labelid)+'Tag'+s4+'DataString',
                                         'Window: '+no0(pdwn^.title)+' Gadget: '+no0(pgn^.labelid)+' Tag '+s4);
                            str(loop*2+pos,s);
                            addline(@procfunclist,'	'+nicestring(no0(pdwn^.labelid))+'GadgetTags['+s+'] = (ULONG)'+
                                              sfp(producernode^.getstring)+'('+no0(pgn^.labelid)+'Tag'+s4+'DataString);','');
                            s2:=s2+'0';
                          end;
                      end
                     else
                      s2:=s2+'0';
                  end;
                
                tagtypearraybyte,tagtypearraylong,tagtypearrayword :
                  begin
                    str(loop,s);
                    if pmt^.sizebuffer>0 then
                      s2:=s2+'(ULONG)&'+no0(pgn^.labelid)+'Tag'+s+'Data[0]'
                     else
                      s2:=s2+'0';
                  end;
                
                tagtypelong :
                  begin
                    str(long(pmt^.data),s);
                    s2:=s2+'(ULONG)('+s+')';
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
                      s2:=s2+'(ULONG)&'+sfp(pin^.in_label)
                     else
                      s2:=s2+'0';
                  end;
                
                tagtypeimagedata : 
                  begin
                    s2:=s2+'0';
                  end;
                
                tagtypeheightcoord,tagtypewidthcoord,tagtypetopcoord,tagtypeleftcoord :
                  begin
                    s2:=s2+'0';
                  end;
            
                tagtypefont :
                  begin
                    if pdwn^.codeoptions[17] then
                      s:='0'
                     else
                      if pdwn^.codeoptions[6] then
                        s:='(ULONG)&'+makemyfont(pdwn^.gadgetfont)
                       else
                        s:='(ULONG)&'+makemyfont(pgn^.font);
                    s2:=s2+s;
                  end;
                
                tagtypegadgetid : 
                  begin
                    str(pgn^.id,s3);
                    s2:=s2+s3;
                  end;
                
                tagtypedrawinfo,tagtypevisualinfo,tagtypescreen,tagtypeuser2 : 
                  begin
                    s2:=s2+'0';
                  end;


               end;
              if s2<>'bad' then
                begin
                  addline(@constlist,'	'+s2+',','');
                end
               else
                begin
                  dec(loop);
                end;
              inc(loop);
              pmt:=pmt^.ln_succ;
            end;
          
          if pgn^.tags[3].ti_tag=0 then
            begin
              pgn^.prevtagpos:=pos+2*loop;
              inc(loop);
              str(ga_previous,s);
              addline(@constlist,'	(ULONG)('+s+'),0,','');
            end;
          
          {
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
          
          
          pgn2:=pgadgetnode(pdwn^.gadgetlist.lh_head);
          while(pgn2^.ln_succ<>nil) do
            begin
              if pgn^.kind=myobject_kind then
                begin
                  pmt2:=pmytag(pgn^.infolist.lh_head);
                  while(pmt2^.ln_succ<>nil) do
                    begin
                      if pmt2^.tagtype=tagtypeobject then
                        begin
                          if pmt2^.data=pointer(pgn2) then
                            begin
                              if pgn2^.tags[3].ti_tag=0 then
                                begin
                                  str(pmt2^.value,s);
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
          }
  
  doobjects:=pos+loop*2;
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
  s5  : string;
  coun : long;
  mycount : word;
begin
  loop:=0;
  if pgn^.kind=myobject_kind then
    begin
      pmt:=pmytag(pgn^.infolist.mlh_head);
      while(pmt^.ln_succ<>nil) do
        begin
          case pmt^.tagtype of
            
            tagtypeintuitext :
              begin
                if pmt^.sizebuffer>0 then
                  begin
                    
                    pit:=pintuitext(pmt^.data);
                    
                    str(loop,s4);
                    addline(@constlist,'struct IntuiText '+no0(pgn^.labelid)+'Tag'+s4+'IntuiTexts[]  = {','');
                    
                    cow:=0;
                    while (pit<>nil) do
                      begin
                        inc(cow);
                        str(pit^.FrontPen,s3);
                        s:='	{ '+s3;
                        str(pit^.backpen,s3);
                        s:=s+', '+s3;
                        str(pit^.drawmode,s3);
                        s:=s+','+s3;

                        str(pit^.leftedge,s3);
                        s:=s+', '+s3;
                        str(pit^.topedge,s3);
                        s:=s+', '+s3;
                        
                        if pdwn^.codeoptions[17] then
                          s3:='0'
                         else
                          if pdwn^.codeoptions[6] then
                            s3:='&'+makemyfont(pdwn^.gadgetfont)
                           else
                            s3:='&'+makemyfont(pgn^.font);
                        
                        s:=s+', '+s3;
                        
                        if pdwn^.localeoptions[1] then
                          begin
                            ctopas(pit^.itext^,s5);
                            str(cow-1,s3);
                            localestring(no0(s5),no0(pgn^.labelid)+'Tag'+s4+'String'+s3,'Window: '+
                                         no0(pdwn^.title)+' Gadget: '+no0(pgn^.title)+' String');
                            
                            s:=s+', (UBYTE *)'+no0(pgn^.labelid)+'Tag'+s4+'String'+s3;
                            
                          end
                         else
                          begin
                            ctopas(pit^.itext^,s3);
                            s:=s+', (STRPTR)"'+s3+'"';
                          end;
                        
                        str(cow,s3);
                        if pit^.nexttext<>nil then
                          s:=s+', &'+no0(pgn^.labelid)+'Tag'+s4+'IntuiTexts['+s3+']'
                         else
                          s:=s+', NULL';
                        
                        addline(@constlist,s+' },','');
                        pit:=pit^.nexttext;
                      end;
                    addline(@constlist,'	};','');
                    
                  end;
              end;
            
            tagtypestringlist :
              begin
                if pmt^.sizebuffer>0 then
                  begin
                    
                    
                    str(loop,s4);
                    loop2:=0;
                    addline(@constlist,'','');
                    addline(@constlist,'struct Node '+no0(pgn^.labelid)+'Tag'+s4+'ListItems[] =','');
                    addline(@constlist,'	{','');
                    mycount:=0;
                    pl:=plist(pmt^.data);
                    pn:=pnode(pl^.lh_head);
                    while (pn^.ln_succ<>nil) do
                      begin
                        if sizeoflist(pl)>1 then
                          if loop2=0 then
                            begin
                              str(loop2+1,s);
                              ctopas(pn^.ln_name^,s5);
                              if pdwn^.localeoptions[1] then
                                begin
                                  str(mycount,s3);
                                  localestring(no0(s5),no0(pgn^.labelid)+'Tag'+s4+'String'+s3,'Window: '+
                                          no0(pdwn^.title)+' Gadget: '+no0(pgn^.title)+' String');
                                  s:='	&'+no0(pgn^.labelid)+'Tag'+s4+'ListItems['+s+'], (struct Node *)&'
                                    +no0(pgn^.labelid)+'Tag'+s4+'List.mlh_Head, 0, 0, (STRPTR)'+
                                    no0(pgn^.labelid)+'Tag'+s4+'String'+s3+',';
                                end
                               else
                                s:='	&'+no0(pgn^.labelid)+'Tag'+s4+'ListItems['+s+'], (struct Node *)&'
                                    +no0(pgn^.labelid)+'Tag'+s4+'List.mlh_Head, 0, 0, (STRPTR)"'+no0(s5)+'",';
                              addline(@constlist,s,'');
                            end
                           else
                            if loop2=sizeoflist(pl)-1 then
                              begin
                                ctopas(pn^.ln_name^,s5);
                                str(loop2-1,s);
                                if pdwn^.localeoptions[1] then
                                  begin
                                    str(mycount,s3);
                                    localestring(no0(s5),no0(pgn^.labelid)+'Tag'+s4+'String'+
                                      s3,'Window: '+no0(pdwn^.title)+' Gadget: '+no0(pgn^.title)+' String');
                                    s:='&'+no0(pgn^.labelid)+'Tag'+s4+'ListItems['+s+'], 0, 0, (STRPTR)'+
                                    no0(pgn^.labelid)+'Tag'+s4+'String'+s3;
                                  end
                                 else
                                  begin
                                    s:='&'+no0(pgn^.labelid)+'Tag'+s4+'ListItems['+s+'], 0, 0, (STRPTR)"'+no0(s5)+'"';
                                  end;
                                s:='( struct Node *)&'+no0(pgn^.labelid)+'Tag'+s4+'List.mlh_Tail, '+s;
                                addline(@constlist,'	'+s,'');
                              end
                             else
                              begin
                                ctopas(pn^.ln_name^,s5);
                                str(loop2+1,s);
                                s:='&'+no0(pgn^.labelid)+'Tag'+s4+'ListItems['+s+'], &';
                                str(loop2-1,s3);
                                s:=s+no0(pgn^.labelid)+'Tag'+s4+'ListItems['+s3+'], ';
                                if pdwn^.localeoptions[1] then
                                  begin
                                    str(mycount,s3);
                                    localestring(no0(s5),no0(pgn^.labelid)+'Tag'+s4+'String'+s3,'Window: '+
                                      no0(pdwn^.title)+' Gadget: '+no0(pgn^.title)+' String');
                                    addline(@constlist,'	'+s+'0, 0, (STRPTR)'+no0(pgn^.labelid)+
                                      'Tag'+s4+'String'+s3+',','');
                                  end
                                 else
                                  begin
                                    addline(@constlist,'	'+s+'0, 0, (STRPTR)"'+no0(s5)+'",','');
                                  end;
                              end
                             else
                              begin
                                if pdwn^.localeoptions[1] then
                                  begin
                                    ctopas(pn^.ln_name^,s5);
                                    str(mycount,s3);
                                    localestring(no0(s5),no0(pgn^.labelid)+'Tag'+s4+'String'+s3,'Window: '+no0(pdwn^.title)
                                            +' Gadget: '+no0(pgn^.title)+' String');
                                    addline(@constlist,'	( struct Node * )&'+no0(pgn^.labelid)+'Tag'+s4+'List.mlh_Tail'+
                                                   ', ( struct Node * )&'+no0(pgn^.labelid)+'Tag'+s4+'List.mlh_Head,'+
                                                   ' 0, 0, (STRPTR)'+no0(pgn^.labelid)+'Tag'+s4+'String'+s3,'');
                                  end
                                 else
                                  addline(@constlist,'	( struct Node * )&'+no0(pgn^.labelid)+'Tag'+s4+'List.mlh_Tail'+
                                                   ', ( struct Node * )&'+no0(pgn^.labelid)+'Tag'+s4+'List.mlh_Head,'+
                                                   ' 0, 0, (STRPTR)"'+no0(s5)+'"','');
                              end;
                        
                        inc(loop2);
                        inc(mycount);
                        pn:=pn^.ln_succ;
                      end;
                    addline(@constlist,'	};','');
                    addline(@constlist,'','');
                    addline(@constlist,'struct MinList '+no0(pgn^.labelid)+'Tag'+s4+'List =','');
                    addline(@externlist,'extern struct MinList '+no0(pgn^.labelid)+'Tag'+s4+'List;','');
                    addline(@constlist,'	{','');
                    str(sizeoflist(pl)-1,s2);
                    addline(@constlist,'	( struct MinNode * )&'+no0(pgn^.labelid)
                                       +'Tag'+s4+'ListItems[0], ( struct MinNode * )NULL , '+
                                       '( struct MinNode * )&'+no0(pgn^.labelid)
                                       +'Tag'+s4+'ListItems['+s2+']','');
                    addline(@constlist,'	};','');
                    str(mycount,s);
                    
                    if pdwn^.localeoptions[1] then
                      begin
                        addline(@procfunclist,'    for ( loop=0; loop<'+s+'; loop++)','');
                        addline(@procfunclist,'      '+no0(pgn^.labelid)+'Tag'+s4+'ListItems[loop].ln_Name = '
                            +sfp(producernode^.getstring)+'((ULONG)'+no0(pgn^.labelid)+
                             'Tag'+s4+'ListItems[loop].ln_Name);','');
                      end;
                    
                  end;
              end;
            
            tagtypearraystring :
              begin
                if pmt^.sizebuffer>0 then
                  begin
                    addline(@constlist,'','');
                    str(loop,s4);
                    addline(@constlist,'STRPTR '+no0(pgn^.labelid)+'Tag'+s4+'DataArray[] =','');
                    addline(@constlist,'{','');
                    mycount:=0;
                    
                    pla:=plongarray(pmt^.data);
                    
                    coun:=0;
                    while (pla^[coun]<>0) do
                      begin
                        pb:=pbyte(pla^[coun]);
                        ctopas(pb^,s5);
                        if pdwn^.localeoptions[1] then
                          begin
                            str(mycount,s3);
                            localestring(no0(s5),no0(pgn^.labelid)+
                                 'Tag'+s4+'String'+s3,'Window: '+no0(pdwn^.title)+' Gadget: '+no0(pgn^.title)+' String');
                            addline(@constlist,'	(STRPTR)'+
                                no0(pgn^.labelid)+'Tag'+s4+'String'+s3+',','');
                          end
                         else
                          addline(@constlist,'	(STRPTR)"'+no0(s5)+'",','');
                        inc(mycount);
                        inc(coun);
                      end;
                    
                    addline(@constlist,'	NULL',''); 
                    addline(@constlist,'};',''); 
                    
                  end;
              end;
            
            tagtypeobject :
              begin
                str(loop,s);
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
                  s2:='LONG'
                 else
                  if pmt^.tagtype=tagtypearrayword then
                    s2:='UWORD'
                   else
                    if pmt^.tagtype=tagtypearraybyte then
                      s2:='UBYTE';
                
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
                    
                    s2:=s2+' '+no0(pgn^.labelid)+'Tag'+s+'Data[] = {';
                    addline(@constlist,s2,'');
                    
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
                        addline(@constlist,'  '+s2,'');
                      end;
                    
                    addline(@constlist,'  };','');
                  end;
              end;

           end;
          inc(loop);
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
              addline(@procfunclist,spaces+'if ('+no0(pdwn^.labelid)+'Gadgets['+no0(pgn^.labelid)+
                               ' - '+nicestring(no0(pdwn^.labelid))+'FirstID])','');
              addline(@procfunclist,spaces+'  DrawImageState('+no0(pdwn^.labelid)+'->RPort'+
                                    ', (APTR)'+no0(pdwn^.labelid)+'Gadgets['+no0(pgn^.labelid)+
                                    ' - '+nicestring(no0(pdwn^.labelid))+'FirstID],'+
                                    ' 0, 0, 0, '+no0(pdwn^.labelid)+'DrawInfo);','');
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

function addwintags(pdwn:pdesignerwindownode;spaces:string): long;
var 
  s,s2,s3 : string;
  loop : long;
begin
  s3:=spaces+'				';  
  s:=s3;
  str(pdwn^.y,s2);
  addline(@procfunclist,s3+'(WA_Top), '+s2+',','');  {37}
  if pdwn^.innerw=0 then
    begin
      str(pdwn^.w,s2);
      if not pdwn^.codeoptions[17] then
        addline(@procfunclist,s3+'(WA_Width), '+s2+'+offx,','') {37}
       else
        addline(@procfunclist,s3+'(WA_Width), '+s2+'*scalex/65535+offx,',''); {37}
    end
   else
    begin
      str(pdwn^.innerw,s2);
      if not pdwn^.codeoptions[17] then
        addline(@procfunclist,s3+'(WA_InnerWidth), '+s2+',','')
       else
        addline(@procfunclist,s3+'(WA_InnerWidth), '+s2+'*scalex/65535,','');
    end;
  if pdwn^.innerh=0 then
    begin
      str(pdwn^.h,s2);
      if not pdwn^.codeoptions[17] then
        addline(@procfunclist,s3+'(WA_Height), '+s2+'+offy,','')  {41}
       else
        addline(@procfunclist,s3+'(WA_Height), '+s2+'*scaley/65535+offy,','')  {41}
    end
   else
    begin
      str(pdwn^.innerh,s2);
      if not pdwn^.codeoptions[17] then
        addline(@procfunclist,s3+'(WA_InnerHeight), '+s2+',','')  {42}
       else
        addline(@procfunclist,s3+'(WA_InnerHeight), '+s2+'*scaley/65535,','')  {42}
    end;
  
  if no0(pdwn^.title)<>'' then
    begin
  if pdwn^.localeoptions[3] then
    begin
      localestring(no0(pdwn^.title),nicestring(no0(pdwn^.labelid))+'Title','Window: '+no0(pdwn^.title)+' Title');
      addline(@procfunclist,s3+'(WA_Title), (LONG)'+sfp(producernode^.getstring)+
              '('+nicestring(no0(pdwn^.labelid))+'Title),','');  {43}
    end
   else
    addline(@procfunclist,s3+'(WA_Title), "'+no0(pdwn^.title)+'",','');  {43}
    end;
  
  if no0(pdwn^.screentitle)<>'' then
    begin
      if pdwn^.localeoptions[4] then
        begin
          localestring(no0(pdwn^.screentitle),nicestring(no0(pdwn^.labelid))+
          'ScreenTitle','Window: '+no0(pdwn^.title)+' Screen Title');
          addline(@procfunclist,s3+'(WA_ScreenTitle), (LONG)'+sfp(producernode^.getstring)+'('
          +nicestring(no0(pdwn^.labelid))+'ScreenTitle),','');  {44}
        end
       else
        addline(@procfunclist,s3+'(WA_ScreenTitle), "'+no0(pdwn^.screentitle)+'",','');  {44}
    end;
  str(pdwn^.minw,s2);
  addline(@procfunclist,s3+'(WA_MinWidth), '+s2+',',''); {45}
  str(pdwn^.minh,s2);
  addline(@procfunclist,s3+'(WA_MinHeight), '+s2+',',''); {46}
  str(pdwn^.maxw,s2);
  addline(@procfunclist,s3+'(WA_MaxWidth), '+s2+',',''); {47}
  str(pdwn^.maxh,s2);
  addline(@procfunclist,s3+'(WA_MaxHeight), '+s2+',',''); {48}
  loop:=11;
  if pdwn^.sizegad then
    begin
      addline(@procfunclist,s3+'(WA_SizeGadget), TRUE,',''); {49}
      if (pdwn^.sizebright)and(pdwn^.sizebbottom) then
        begin
          addline(@procfunclist,s3+'(WA_SizeBRight), TRUE,',''); {50}
        end;
      if pdwn^.sizebbottom then
        begin
          addline(@procfunclist,s3+'(WA_SizeBBottom), TRUE,',''); {51}
        end;
    end;
  if pdwn^.dragbar then
    begin
      str(loop,s);
      addline(@procfunclist,s3+'(WA_DragBar), TRUE,','');     {52}
      inc(loop);
    end;
  if pdwn^.Depthgad then
    addline(@procfunclist,s3+'(WA_DepthGadget), TRUE,',''); {53}
  if pdwn^.CloseGad then
    addline(@procfunclist,s3+'(WA_CloseGadget), TRUE,',''); {54}
  if pdwn^.reportmouse then
    addline(@procfunclist,s3+'(WA_ReportMouse), TRUE,',''); {55}
  if pdwn^.NoCareRefresh then
    addline(@procfunclist,s3+'(WA_NoCareRefresh), TRUE,',''); {56}
  if pdwn^.borderless then
    addline(@procfunclist,s3+'(WA_BorderLess), TRUE,',''); {57}
  if pdwn^.backdrop then
    addline(@procfunclist,s3+'(WA_Backdrop), TRUE,',''); {58}
  if pdwn^.gimmezz then
      addline(@procfunclist,s3+'(WA_GimmeZeroZero), TRUE,',''); {59}
  if pdwn^.Activate then
    addline(@procfunclist,s3+'(WA_Activate), TRUE,',''); {60}
  if pdwn^.RMBTrap then
    addline(@procfunclist,s3+'(WA_RMBTrap), TRUE,',''); {61}
  
  if pdwn^.moretags[1] then
    addline(@procfunclist,s3+'(WA_Dummy+0x30), TRUE,',''); {61}
  if pdwn^.moretags[2] then
    addline(@procfunclist,s3+'(WA_Dummy+0x32), TRUE,',''); {61}
  if pdwn^.moretags[3] then
    addline(@procfunclist,s3+'(WA_Dummy+0x37), TRUE,',''); {61}
  
  if pdwn^.SimpleRefresh then
    addline(@procfunclist,s3+'(WA_SimpleRefresh), TRUE,',''); {62}
  if pdwn^.Smartrefresh then
    addline(@procfunclist,s3+'(WA_SmartRefresh), TRUE,',''); {63}
  if pdwn^.autoadjust then
    addline(@procfunclist,s3+'(WA_AutoAdjust), TRUE,',''); {64}
  if pdwn^.MenuHelp then
    addline(@procfunclist,s3+'(WA_MenuHelp), TRUE,',''); {65}
  if sizeoflist(@pdwn^.gadgetlist)>0 then
    addline(@procfunclist,s3+'(WA_Gadgets), '+no0(pdwn^.labelid)+'GList,',''); {66}
  
  if pdwn^.extracodeoptions[1] then
    if pdwn^.extracodeoptions[2] then
      addline(@procfunclist,s3+'(WA_SuperBitMap), '+no0(pdwn^.labelid)+'BitMap,','')
     else
      addline(@procfunclist,s3+'(WA_SuperBitMap), bitmap,','');
  
  if pdwn^.usezoom then
    addline(@procfunclist,s3+'(WA_Zoom), '+no0(pdwn^.labelid)+'ZoomInfo,',''); {67}
  if pdwn^.mousequeue<>5 then
    begin
      str(pdwn^.mousequeue,s2);
      addline(@procfunclist,s3+'(WA_MouseQueue), '+s2+',',''); {68}
    end;
  if pdwn^.rptqueue<>3 then
    begin
      str(pdwn^.rptqueue,s2);
      addline(@procfunclist,s3+'(WA_RptQueue)  , '+s2+',',''); {69}
    end;
  
  
  {
  if pdwn^.pubscreenfallback and pdwn^.pubscreenname then
    addline(@procfunclist,s3+'(WA_PubScreenFallBack), TRUE,','');
  }
  {************************* here we go }
  
  if (pdwn^.customscreen) then
    begin
      addline(@procfunclist,s3+'(WA_CustomScreen)  , (LONG)Scr,',''); {69}
    end;
    
  if (pdwn^.pubscreen) then
    begin
      addline(@procfunclist,s3+'(WA_PubScreen) , (LONG)Scr,',''); {69}
    end;
  
  if (pdwn^.pubscreenname) then
    begin
      addline(@procfunclist,s3+'(WA_PubScreen) , (LONG)Scr,',''); {69}
    end;
  
  
  
  
  addwintags:=loop;
  
end;

begin
  
end.