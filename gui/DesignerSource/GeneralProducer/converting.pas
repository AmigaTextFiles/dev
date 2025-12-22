type
  
  pwholecodestore = ^twholecodestore;
  twholecodestore=record
    procedureoptions : array [1..50] of boolean;
    codeoptions      : array [1..20] of boolean;
    openlibs         : array [1..30] of boolean;
    versionlibs      : array [1..30] of long;
    abortonfaillibs  : array [1..30] of boolean;
    compilername     : string[50];
    includeextra     : string;
    fileversion      : long;
   end;


function readallcode(iff:piffhandle):boolean;
var
  error         : long;
  oksofar       : boolean;
  done          : boolean;
  pcn           : pcontextnode;
begin
  readcodestore.fileversion:=0;
  readcodestore.includeextra:=#0;
  oksofar:=true;
  error:=readchunkbytes(iff,@readcodestore,sizeof(readcodestore));
  if error<0 then
    oksofar:=false;
  readallcode:=oksofar;
  globalincludeextra:=readcodestore.includeextra;
  copymem(@readcodestore.procedureoptions,@procedureoptions,sizeof(procedureoptions));
  copymem(@readcodestore.codeoptions,@codeoptions,sizeof(codeoptions));
  copymem(@readcodestore.openlibs,@openlibs,sizeof(openlibs));
  copymem(@readcodestore.versionlibs,@versionlibs,sizeof(versionlibs));
  copymem(@readcodestore.abortonfaillibs,@abortonfaillibs,sizeof(abortonfaillibs));
  if (0=readcodestore.fileversion)then
    begin
      openlibs[23]:=true;
      versionlibs[23]:=38;
      abortonfaillibs[23]:=false;
    end;

  if (readcodestore.fileversion>SaveFileVersion) then
    begin
      oksofar:=false;
    end;
end;

function readalldata(filename : string):boolean;
var
  psn      : pstringnode;
  iff      : piffhandle;
  error    : long;
  oksofar  : boolean;
  pdwn     : pdesignerwindownode;
  pin      : pimagenode;
  pcn      : pcontextnode;
  done     : boolean;
  winlist  : tlist;
  pgn,pgn2 : pgadgetnode;
  tgs      : tgadgetstore;
  twininfo : twindowinfostore;
  pdwn2    : pdesignerwindownode;
  imagelist: tlist;
  pin2     : pimagenode;
  psin     : psmallimagenode;
  realfile : boolean;
  menulist : tlist;
  pdmn     : pdesignermenunode;
  pmtn     : pmenutitlenode;
  pmin     : pmenuitemnode;
  pmsi     : pmenusubitemnode;
  screenlist : tlist;
  pdsn,pdsn2 : pdesignerscreennode;
  pmt      : pmytag;
begin
  readlocalestuff:=false;
  readcodestore.fileversion:=0;
  realfile:=false;
  newlist(@winlist);
  newlist(@screenlist);
  newlist(@imagelist);
  newlist(@menulist);
  oksofar:=true;
  iff:=allociff;
  if iff<>nil then
    begin
      iff^.iff_stream:=long(open(@filename[1],mode_oldfile));
      if iff^.iff_stream<>0 then
        begin
          initiffasdos(iff);
          error:=openiff(iff,ifff_read);
          if error=0 then
            begin
              repeat
                error:=parseiff(iff,iffparse_rawstep);
                if error=0 then
                  begin
                    pcn:=currentchunk(iff);
                    done:=false;
                    if (pcn^.cn_type=id_des1)and(pcn^.cn_id=id_form) then
                      repeat
                        realfile:=true;
                        error:=parseiff(iff,iffparse_rawstep);
                        if (error=0) or (error=ifferr_eoc) then
                          begin
                            pcn:=currentchunk(iff);
                            if (pcn^.cn_type=id_des1) and 
                               (pcn^.cn_id=id_form) and
                               (error=ifferr_eoc) then
                              done:=true;
                          end
                         else
                          done:=true; 
                        
                        if oksofar and (pcn^.cn_id=id_info) and (error=0) then
                          oksofar:=readallcode(iff);
                        
                      until done;
                  end;
              until (error<>0)and(error<>ifferr_eoc);
              closeiff(iff);
            end
           else
            oksofar:=false;
          if not close_(bptr(iff^.iff_stream)) then
            oksofar:=false;
        end
       else
        oksofar:=false;
    end
   else
    oksofar:=false;
  
  if realfile then
    begin
      
      if oksofar then
        begin
          
          copymem(@readcodestore.procedureoptions,@procedureoptions,sizeof(procedureoptions));
          copymem(@readcodestore.codeoptions,@codeoptions,sizeof(codeoptions));
          
          copymem(@readcodestore.openlibs,@openlibs,sizeof(openlibs));
          copymem(@readcodestore.versionlibs,@versionlibs,sizeof(versionlibs));
          copymem(@readcodestore.abortonfaillibs,@abortonfaillibs,sizeof(abortonfaillibs));
          
        end;
    end
   else
    begin
      oksofar:=false;
    end;
  readalldata:=oksofar;
end;

end.