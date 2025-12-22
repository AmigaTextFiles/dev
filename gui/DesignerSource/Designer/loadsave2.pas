unit loadsave2;

interface

uses asl,utility,exec,intuition,amiga,workbench,layers,icon,
     gadtools,graphics,dos,amigados,definitions,iffparse,routines;

const
  id_obj1 = $4f424a31;
  id_des1 = $44455332;
  id_wind = $57494e44;
  id_gadg = $47414447;
  id_bevl = $4245564c;
  id_imag = $494d4147;
  id_text = $54455854;
  id_info = $494e464f;
  id_pics = $50494353;
  id_pic1 = $50494331;
  id_head = $48454144;
  id_data = $44415441;
  id_strn = $5354524e;
  id_strl = $5354524c;
  id_menu = $4d454e55;
  id_ttle = $54544c45;
  id_item = $4954454d;
  id_SubI = $53554249;
  id_subs = $53554253;
  id_itms = $49544d53;
  id_ttls = $54544c53;
  id_loca = $4c4f4341;
  id_loci = $4c4f4349;
  id_scrn = $5343524e;
  id_scri = $53435249;
  id_scrc = $53435243;
  id_tagi = $54414749;
  id_tagd = $54414744;
  id_tags = $54414753;

var incompletesave : boolean;

type
  ttagstore = record
    tagtype  : word;
    title    : string[66];
    value    : long;
    datasize : long;
    data     : long;
    dataname : string[66];
   end;
  
  pgadgetstore = ^tgadgetstore;
  tgadgetstore = record
    leftedge  : long;
    topedge   : long;
    width     : long;
    height    : long;
    kind      : long;
    title     : string[66];
    id        : long;
    flags     : long;
    labelid   : string[66];
    fontname  : string[46];
    fontysize : word;
    fontstyle : byte;
    fontflags : byte;
    tags      : array [1..15] of ttagitem;
    joined    : boolean;
    datas     : string[66];
    listfollows : long;
    specialdata : long;
    edithook    : string;
    defstring   : string[85];
    defnumber   : long;
   end;

function writegadgetstore(pgn:pgadgetnode;iff:piffhandle):boolean;
function readgadget(iff:piffhandle;pdwn:pdesignerwindownode):boolean;
procedure loadpresetobjects(d : string);
procedure writepresetobject(d:string;pgn : pgadgetnode);

implementation

procedure writepresetobject(d:string;pgn : pgadgetnode);
var
  oksofar : boolean;
  iff     : piffhandle;
  error   : long;
  pmt     : pmytag;
  f : string;
begin
  f:=d+no0(pgn^.labelid)+'.des.object'#0;
  iff:=allociff;
  if iff<>nil then
    begin
      iff^.iff_stream:=long(open(@f[1],mode_newfile));
      if iff^.iff_stream<>0 then
        begin
          initiffasdos(iff);
          error:=openiff(iff,ifff_write);
          if error=0 then
            begin
              error:=pushchunk(iff,id_obj1,id_form,iffsize_unknown);
              if error=0 then
                begin
                  oksofar:=writegadgetstore(pgn,iff);
                  error:=popchunk(iff);
                end;
              closeiff(iff);
            end;
          if close_(bptr(iff^.iff_stream)) then;
        end;
      freeiff(iff);
    end;
end;

procedure readpresetobject(f : pbyte);
var
  tdwn    : tdesignerwindownode;
  oksofar : boolean;
  pcn     : pcontextnode;
  iff     : piffhandle;
  error   : long;
  pgn     : pgadgetnode;
  pmt     : pmytag;
begin
  oksofar:=true;
  newlist(@tdwn.gadgetlist);
  iff:=allociff;
  if iff<>nil then
    begin
      iff^.iff_stream:=long(open(f,mode_oldfile));
      if iff^.iff_stream<>0 then
        begin
          initiffasdos(iff);
          error:=openiff(iff,ifff_read);
          if error=0 then
            begin
              
              
              if error=0 then
                begin
                  repeat
                    error:=parseiff(iff,iffparse_rawstep);
                    if error=0 then
                      begin
                        pcn:=currentchunk(iff);
                        if (pcn^.cn_id=id_gadg) then
                          begin
                            oksofar:=readgadget(iff,@tdwn);
                            if oksofar then
                              begin
                                pgn:=pgadgetnode(remhead(@tdwn.gadgetlist));
                                if pgn<>nil then
                                  begin
                                    addtail(@presetobjectlist,pnode(pgn));
                                  end;
                              end;
                          end;
                      end;
                  until (error<>0)and(error<>ifferr_eoc);
                end;
              closeiff(iff);
            end;
          if close_(bptr(iff^.iff_stream)) then;
        end;
      freeiff(iff);
    end;
end;

procedure loadpresetobjects(d : string);
var
  ap : panchorpath;
  error : long;
  cd : bptr;
begin
  d:=d+'#?.des.object'#0;
  ap := allocvec(sizeof(tanchorpath),memf_clear);
  if ap<>nil then
    begin
      error:=matchfirst(@d[1],ap);
      while(error = 0 ) do
        begin
          cd:=currentdir(ap^.ap_Last^.an_Lock);
          readpresetobject(@ap^.ap_info.fib_filename[0]);
          cd:=currentdir(cd);
          error:=matchnext(ap);
        end;
      matchend(ap);
      freevec(ap);
    end;
end;

function readgadget(iff:piffhandle;pdwn:pdesignerwindownode):boolean;
var
  pgn     : pgadgetnode;
  tgs     : tgadgetstore;
  oksofar : boolean;
  error   : long;
  pcn     : pcontextnode;
  psn     : pstringnode;
  tts     : ttagstore;
  pmt     : pmytag;
begin
  tgs.defstring:=#0;
  tgs.defnumber:=0;
  pmt:=nil;
  tgs.edithook:=#0;
  oksofar:=true;
  pgn:=allocmymem(sizeof(tgadgetnode),memf_clear or memf_any);
  if pgn<>nil then
    begin
      addtail(@pdwn^.gadgetlist,pnode(pgn));
      error:=readchunkbytes(iff,@tgs,sizeof(tgadgetstore));
      if error>0 then
        begin
          with tgs do
            begin
              pgn^.ln_name:=@pgn^.labelid[1];
              pgn^.flags:=flags;
              pgn^.x:=leftedge;
              pgn^.y:=topedge;
              pgn^.w:=width;
              pgn^.h:=height;
              pgn^.kind:=kind;
              pgn^.title:=title;
              pgn^.id:=id;
              pgn^.labelid:=labelid;
              pgn^.fontname:=fontname;
              pgn^.font.ta_ysize:=fontysize;
              pgn^.font.ta_style:=fontstyle;
              pgn^.font.ta_flags:=fontflags;
              pgn^.high:=false;
              pgn^.font.ta_name:=@pgn^.fontname[1];
              pgn^.editwindow:=nil;
              copymem(@tags[1],@pgn^.tags[1],120);
              pgn^.joined:=joined;
              pgn^.datas:=datas;
              pgn^.edithook:=edithook;
              newlist(@pgn^.infolist);
              pgn^.contents:=defstring;
              pgn^.contents2:=defnumber;
              pgn^.pointers[1]:=nil;
              if specialdata=1 then
                pgn^.pointers[1]:=pointer(10101010); {getfile}
              case pgn^.kind of
                string_kind : begin
                                if pgn^.joined then 
                                  pgn^.pointers[1]:=pointer(specialdata);
                              end;
                listview_kind : begin
                                  pgn^.tags[1].ti_data:=long(@pgn^.infolist);
                                  if pgn^.tags[3].ti_data<>0 then
                                    pgn^.tags[3].ti_data:=specialdata;
                                end;
                text_kind : begin
                              pgn^.tags[1].ti_data:=long(@pgn^.datas[1]);
                            end;
               end;
            end;
          while (tgs.listfollows>0) and oksofar do
            begin
              
              error:=parseiff(iff,iffparse_rawstep);
              
              if (error=ifferr_eoc)or(error=0) then
                begin
                  pcn:=currentchunk(iff);
                  
                  if (pcn^.cn_id=id_tagd) and
                     (error=0) then
                    begin
                      dec(tgs.listfollows);
                      pmt:=allocmymem(sizeof(tmytag),memf_clear or memf_any);
                      if pmt<>nil then
                        begin
                          addtail(@pgn^.infolist,pnode(pmt));
                          pmt^.ln_name:=@pmt^.title[1];
                          error:=readchunkbytes(iff,@tts,sizeof(tts));
                          pmt^.title:=tts.title;
                          pmt^.tagtype:=tts.tagtype;
                          pmt^.value:=tts.value;
                          pmt^.sizebuffer:=tts.datasize;
                          pmt^.data:=pointer(tts.data);
                          pmt^.dataname:=tts.dataname;
                          if pmt^.sizebuffer>0 then
                            begin
                              pmt^.data:=allocmymem(pmt^.sizebuffer,memf_clear);
                              if pmt^.data=nil then
                                begin
                                  oksofar:=false;
                                  pmt^.sizebuffer:=0;
                                end;
                              inc(tgs.listfollows);
                            end;
                          if error<0 then
                            oksofar:=false;
                        end
                       else
                        oksofar:=false;
                    end;
                  
                  if (pcn^.cn_id=id_tags) and
                     (error=0) then
                    begin
                      if pmt<>nil then
                        if pmt^.data<>nil then
                          begin
                            dec(tgs.listfollows);
                            error:=readchunkbytes(iff,pmt^.data,pmt^.sizebuffer);
                            if error<0 then
                              oksofar:=false;
                            pmt:=nil;
                          end
                         else
                          oksofar:=false
                       else
                        oksofar:=false;
                    end;
                                      
                  if (pcn^.cn_id=id_strn) and
                     (error=0) then
                    begin
                      dec(tgs.listfollows);
                      psn:=allocmymem(sizeof(tstringnode),memf_clear or memf_any);
                      if psn<>nil then
                        begin
                          addtail(@pgn^.infolist,pnode(psn));
                          psn^.ln_name:=@psn^.st[1];
                          error:=readchunkbytes(iff,@psn^.st,256);
                          if error<0 then
                            oksofar:=false;
                        end
                       else
                        oksofar:=false;
                    end;

                end
               else
                oksofar:=false;
              
              
            end;
        end
       else
        oksofar:=false;
    end
   else
    oksofar:=false;
  readgadget:=oksofar;
end;



function writegadgetstore(pgn:pgadgetnode;iff:piffhandle):boolean;
var
  error   : long;
  oksofar : boolean;
  tgs     : tgadgetstore;
  psn     : pstringnode;
  pgn2    : pgadgetnode;
  pin     : pimagenode;
  tts     : ttagstore;
  pg : pgadgetnode;
  pmt : pmytag;
begin
  if pgn^.kind=mybool_kind then
    begin
      newlist(@pgn^.infolist);
      psn:=allocmymem(sizeof(tstringnode),memf_clear or memf_any);
      if psn<>nil then
        begin
          pin:=pimagenode(pgn^.pointers[1]);
          if pin<>nil then
            begin
              psn^.st:=pin^.title;
            end
           else
            psn^.st:=''#0;
          addtail(@pgn^.infolist,pnode(psn))
        end
       else
        oksofar:=false;
      psn:=allocmymem(sizeof(tstringnode),memf_clear or memf_any);
      if psn<>nil then
        begin
          pin:=pimagenode(pgn^.pointers[2]);
          if pin<>nil then
            begin
              psn^.st:=pin^.title;
            end
           else
            psn^.st:=''#0;
          addtail(@pgn^.infolist,pnode(psn))
        end
       else
        oksofar:=false;
    end;
  oksofar:=true;
  error:=pushchunk(iff,id_wind,id_gadg,sizeof(tgadgetstore));
  if error=0 then
    begin
      with tgs do
        begin
          flags:=pgn^.flags;
          leftedge:=pgn^.x;
          topedge:=pgn^.y;
          width:=pgn^.w;
          height:=pgn^.h;
          kind:=pgn^.kind;
          title:=pgn^.title;
          id:=pgn^.id;
          joined:=(pgn^.joined)and(pgn^.kind=string_kind);
          labelid:=pgn^.labelid;
          fontname:=pgn^.fontname;
          fontysize:=pgn^.font.ta_ysize;
          fontstyle:=pgn^.font.ta_style;
          fontflags:=pgn^.font.ta_flags;
          datas:=pgn^.datas;
          edithook:=pgn^.edithook;
          copymem(@pgn^.tags[1],@tags[1],120);
          listfollows:=sizeoflist(@pgn^.infolist);
          
          defstring:=pgn^.contents;
          defnumber:=pgn^.contents2;
          
          if demoversion then
            if listfollows>4 then
              begin
                listfollows:=4;
                {
                seterror('Only Four Items Per Gadget Saved In The Demo Version.');
                }
                incompletesave:=true;
              end;
          
          specialdata:=0;
          case pgn^.kind of
            string_kind :
              if pgn^.joined then
                begin
                  pgn2:=pgadgetnode(pgn^.pointers[1]);
                  specialdata:=pgn2^.id;
                end;
            listview_kind : 
              if pgn^.tags[3].ti_data<>0 then
                begin
                  pgn2:=pgadgetnode(pgn^.tags[3].ti_data);
                  specialdata:=pgn2^.id;
                end;
           end;
        end;
      
      error:=writechunkbytes(iff,@tgs,sizeof(tgadgetstore));
      if error<0 then
        oksofar:=false;
      error:=popchunk(iff);
      if error<>0 then
        oksofar:=false;
      
      if oksofar and (sizeoflist(@pgn^.infolist)>0) then
        begin
          
          if pgn^.kind<>myobject_kind then
            begin
              error:=pushchunk(iff,id_strl,id_form,iffsize_unknown);
              if error<>0 then 
                oksofar:=false;
              if oksofar then
                begin
                  psn:=pstringnode(pgn^.infolist.lh_head);
                  while(psn^.ln_succ<>nil) do
                    begin
                      error:=pushchunk(iff,id_strl,id_strn,iffsize_unknown);
                      if error<0 then oksofar:=false;
                      if oksofar then
                        error:=writechunkbytes(iff,@psn^.st,length(psn^.st)+1);
                      if error<0 then
                        oksofar:=false;
                      error:=popchunk(iff);
                      if error<>0 then
                        oksofar:=false;
                      psn:=psn^.ln_succ;
                    end;
                end;
              error:=popchunk(iff);
              if error<>0 then
                oksofar:=false;
            end
           else
            begin
              error:=pushchunk(iff,id_tagi,id_form,iffsize_unknown);
              if error<>0 then 
                oksofar:=false;
              if oksofar then
                begin
                  pmt:=pmytag(pgn^.infolist.lh_head);
                  while(pmt^.ln_succ<>nil) do
                    begin
                      error:=pushchunk(iff,id_tagi,id_tagd,iffsize_unknown);
                      if error<0 then oksofar:=false;
                      
                      tts.tagtype:=pmt^.tagtype;
                      tts.title:=pmt^.title;
                      tts.value:=pmt^.value;
                      tts.datasize:=pmt^.sizebuffer;
                      tts.data:=long(pmt^.data);
                      
                      if (pmt^.tagtype=tagtypeimage) or (pmt^.tagtype=tagtypeimagedata) then
                        begin
                          tts.data:=0;
                          pin:=pimagenode(pmt^.data);
                          if pin<>nil then
                            tts.dataname:=pin^.title
                           else
                            tts.dataname:=''#0;
                        end;
                      
                      if (pmt^.tagtype=tagtypeobject) then
                        begin
                          tts.data:=0;
                          pg:=pgadgetnode(pmt^.data);
                          if pg<>nil then
                            tts.dataname:=pg^.labelid
                           else
                            tts.dataname:=''#0;
                        end;
                      
                      if oksofar then
                        error:=writechunkbytes(iff,@tts,sizeof(tts));
                      if error<0 then
                        oksofar:=false;
                      
                      error:=popchunk(iff);
                      if error<>0 then
                        oksofar:=false;
                      
                      if pmt^.sizebuffer>0 then
                        begin
                          error:=pushchunk(iff,id_tagi,id_tags,iffsize_unknown);
                          if error<0 then oksofar:=false;
                          if oksofar then
                            error:=writechunkbytes(iff,pmt^.data,pmt^.sizebuffer);
                          if error<0 then
                            oksofar:=false;
                          error:=popchunk(iff);
                          if error<>0 then
                            oksofar:=false;
                        end;
                      
                      pmt:=pmt^.ln_succ;
                    end;
                end;
              error:=popchunk(iff);
              if error<>0 then
                oksofar:=false;
            end;
          
        end;
      
    end
   else
    oksofar:=false;
  writegadgetstore:=oksofar;
  if pgn^.kind=mybool_kind then
    begin
      freelist(@pgn^.infolist,sizeof(tstringnode));
    end;
end; 


end.