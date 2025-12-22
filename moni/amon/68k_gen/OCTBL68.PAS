program octbl68;

{ version 1.01:                                 }
{ the OCTBL.PAS file needs an end sequence.     }
{ it has to be this form: *end*                 }
{ however, it is possible to run 1.00           }
{ and add *end,#0 at the end of the opcodes.    }
{
{ this produces an identical 68OCTBL.ASC file.  }
{ for this purpose, run debug.exe 68octbl.asc   }
{ and control for the end sequence. if it is    }
{ missing, the opcode file was produced by 1.00 }
{ don't forget to make the end sequence source  }
{ this form: *end* (probably obsolete)          }

uses dos;

var fsrc,fdst:file;                  {input/output files              }
var bufsrc:array[0..1023]of longint; {input buffer                    }
var bufdst:array[0..1023]of longint; {output buffer                   }

var i:longint;                       {loop counter byte image         }
var i2:longint;                      {loop counter clear dst buffer   }
var isr2:longint;                    {loop counter lw image           }

var srcbufmsk,dstbufmsk:longint;     {buffer size a multiply of 2     }

var lwsrc,lwdst:longint;             {lw buffers for shift arithmetic }

var oc,ocsr2:longint;                {output stream byte/lw counter   }

var rcr:word;                        {0:last block<buffer size        }

var im3:byte;                        {loop counter AND 3              }
var a:byte;                          {data byte                       }
var ocm3:byte;                       {output stream byte counter AND 3}
var ots:word;                        {0:write error (disk full)       }

var csw:boolean;                     {enter comment                   }
var srcend:boolean;                  {source end sequence             }
var srcesqctr:byte;                  {sequence counter                }

const srcesqstr:array[0..4]of char=('*','e','n','d','*');
var srcesqbt:array[0..4] of byte;

var oby:array[0..255] of longint;    {save some computation time      }

const lcs:array[0..255] of char=
(#0 ,#0 ,#0, #0 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,
 #0 ,#0 ,#0, #0 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,
 #0 ,#0 ,#0, #0 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,'*',#0 ,#0 ,#0 ,#0 ,#0 ,
 '0','1','2','3','4','5','6','7','8','9',#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,
 #0 ,'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o',
 'p','q','r','s','t','u','v','w','x','y','z',#0 ,#0 ,#0 ,#0 ,#0 ,
 #0 ,'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o',
 'p','q','r','s','t','u','v','w','x','y','z',#0 ,#0 ,#0 ,#0 ,#0 ,
 #0 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,
 #0 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,
 #0 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,
 #0 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,
 #0 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,
 #0 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,
 #0 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,
 #0 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0);

begin

 writeln('68000 opcode table generator.');
 writeln('remove comments/cr/lf/spaces.');
 writeln;
 writeln('version 1.01 2005 10 01');
 writeln('(c) miracleworld software');

 for i:=0 to 4 do srcesqbt[i]:=byte(ord(srcesqstr[i]));
 for i:=0 to 255 do oby[i]:=ord(lcs[i]);

 for i:=0 to (sizeof(bufsrc)shr 2)-1 do bufdst[i]:=$40404040;

 assign(fsrc,'OCTBL.PAS');
 assign(fdst,'68OCTBL.ASC');
 reset(fsrc,sizeof(bufsrc));
 rewrite(fdst,sizeof(bufdst));

 srcbufmsk:=sizeof(bufsrc)-1;
 dstbufmsk:=sizeof(bufsrc)-1;

 oc:=0;
 rcr:=1;
 ots:=0;
 csw:=false;
 i:=0;
 lwdst:=0;
 srcend:=false;
 srcesqctr:=0;

 while ((rcr=1)or((i and srcbufmsk)>0)) do
 begin
  im3:=i and 3;
  if ((i and srcbufmsk)=0) then
  begin
   blockread(fsrc,bufsrc,1,rcr);
  end;

  if im3=0 then lwsrc:=bufsrc[((i and srcbufmsk) shr 2)];
  a:=byte(lwsrc shr(im3*8));

  if(a=srcesqbt[srcesqctr]) then
  begin
   if (srcesqctr<4) then
   begin
    inc(srcesqctr);
   end else
   begin
    srcend:=true;
   end;
  end else
  begin
   if(srcesqctr>0) then
   begin
    srcesqctr:=0;
   end;
  end;

  if not(srcend) then
  begin
   if not(a in [123,125]) then
   begin
    if (csw=false) then
    begin
     if not(a in [10,13,32]) then
     begin
      ocm3:=oc and 3;

      lwdst:=lwdst or (oby[a] shl (ocm3*8));
      if (ocm3=3) then
      begin
       bufdst[(oc and dstbufmsk)shr 2]:=lwdst;
       lwdst:=0;
      end;

      if ((oc and dstbufmsk)=dstbufmsk) then
      begin
       blockwrite(fdst,bufdst,1,ots);
       for i2:=0 to (sizeof(bufsrc)shr 2)-1 do bufdst[i2]:=$40404040;
      end;
      inc(oc);
     end;
    end;
   end else
   begin
    if (a=123) then csw:=true;
    if (a=125) then csw:=false;
   end;
  end;
  inc(i);
 end;

 if ocm3<3 then
 begin
  bufdst[(oc and dstbufmsk)shr 2]:=lwdst;
  inc(oc)
 end;

 if ((oc and dstbufmsk)>0) then
  blockwrite(fdst,bufdst,1,ots);
 close(fsrc);
 close(fdst);

end.