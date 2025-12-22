procedure processfiles;
var
  oksofar : boolean;
  filename : string;
  pap : panchorpath;
  indifile : string;
  error : long;
  curdir : BPTR;
begin
  oksofar:=true;
  { handle multiple files in either environment }
  { you should not need to change this }  
  
  if (wbenchmsg<>nil) or 
     ((wbenchmsg=nil) and ((paramcount>0) 
       and (paramstr(1)<>'?'))) then
    begin
      if openmainwindow then
        begin
          if wbenchmsg<>nil then
            begin
              
              { WB params }
              
              paramnum:=0;
              pwbs:=pwbStartup(wbenchmsg);
              pwbaa:=pwbargarray(pwbs^.sm_arglist);
              if paramcount>0 then
                repeat
                  inc(paramnum);
                  curdir:=currentdir(pwbaa^[paramnum].wa_lock);
                  
                  ctopas(pwbaa^[paramnum].wa_name^,ds);
                  
                  if oksofar then
                    oksofar:=checkinput;
                  if oksofar then
                    oksofar:=mainprocess(ds);
                  
                  curdir:=currentdir(curdir);
                until paramnum = paramcount
               else
                begin
                  doing(@nofiles[1]);
                  delay_(25);
                end;
            end
           else
            begin
              
              { CLI params }
              
              pap:=panchorpath(allocmymem(sizeof(tanchorpath),memf_clear));
              if pap<>nil then
                begin
                  paramnum:=0;
                  repeat
                    inc(paramnum);
                    if oksofar then
                      oksofar:=checkinput;
                    if oksofar then
                      begin
                        filename:=paramstr(paramnum)+#0;
                        error:=matchfirst(@filename[1],pap);
                        if error<>0 then
                          begin
                            filename:=no0(filename)+'.des'#0;
                            error:=matchfirst(@filename[1],pap);
                          end;
                        while (error=0) and oksofar do
                          begin
                            
                            curdir:=currentdir(pap^.ap_last^.an_lock);
                            
                            ctopas(pap^.ap_info.fib_filename,indifile);
                            
                            if oksofar then
                              oksofar:=checkinput;

                            if oksofar then
                              oksofar:=mainprocess(indifile);
                            
                            curdir:=currentdir(curdir);
                            error := matchnext(pap);
                          end;
                        matchend(pap);
                      end;
                  until paramnum >= paramcount;
                  freemymem(pap);
                end
               else
                begin
                  doing(@nomem[1]);
                  delay_(25);
                end;
            end;
          
          closemainwindow;
        end
       else
        writeln('Unable to open main window.');
    end
   else
    begin
      writeln('Producer (C) Ian OConnor 1994');
      writeln('Usage : Producer <Filenames>');
    end;
                                                              
end;

