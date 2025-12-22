{ this program generates a 128bit-each entry table }
{ containing 68000 opcode.                         }
{ id string       : 64bit                          }
{ register rights : 64bit                          }
{                                                  }
{ (c) by alex of miracleworld software.            }
{ this software is limited public domain.          }
{ version 1.01 2005-10-10                          }

program ocgen68;

uses dos,crt;

var fsrc,fdst:file;                  {input/output files              }
var bufsrc:array[0..1023]of longint; {input buffer                    }
var bufdst:array[0..1023]of longint; {output buffer                   }

var i:longint;                       {loop counter byte image         }
var i2:longint;                      {loop counter clear dst buffer   }

var srcbufmsk,dstbufmsk:longint;     {buffer size a multiply of 2     }

var lwsrc,lwdst:longint;             {lw buffers for shift arithmetic }

var oc:longint;                      {output stream byte/lw counter   }

var rcr:word;                        {0:last block<buffer size        }

var im3:byte;                        {loop counter AND 3              }
var a:byte;                          {data byte                       }
var ocm3:byte;                       {output stream byte counter AND 3}
var ocm38:byte;                      {multiplication by 8             }

var ots:word;                        {0:write error (disk full)       }

var srcend:boolean;                  {source end sequence             }
var srcesqctr:byte;                  {sequence counter                }

var mode:byte;                       {copy mode                       }
var bctr:byte;                       {byte counter                    }
var hbc:byte;                        {2 half bytes                    }

var lbyte:longint;                   {it works now                    }
var mticswitch:boolean;              {combining 2x4bit into 8bit      }

const srcesqstr:array[0..3]of char=('*','e','n','d');
var srcesqbt:array[0..3] of byte;

var hxoby:array[0..127] of longint;  {crunch 8bit-> 4bit              }

const hxlcs:array[0..127] of char=
(#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,
 #0 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,
 #0 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,
 #0 ,#1 ,#2 ,#3 ,#4 ,#5 ,#6 ,#7 ,#8 ,#9 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,
 #0 ,#10,#11,#12,#13,#14,#15,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,
 #0 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,
 #0 ,#10,#11,#12,#13,#14,#15,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,
 #0 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0 ,#0);

begin

 writeln('68000 opcode table formatter part II.');
 writeln('opcode id       -> 64bits.');
 writeln('register rights -> 64bits.');
 writeln;
 writeln('version 1.01 2005-10-10');
 writeln('(c) miracleworld software');

 for i:=0 to 3 do srcesqbt[i]:=byte(ord(srcesqstr[i]));

 for i:=0 to 127 do hxoby[i]:=longint(hxlcs[i]);

 for i:=0 to (sizeof(bufsrc)shr 2)-1 do bufdst[i]:=$40404040;

 assign(fsrc,'68OCTBL.ASC');
 assign(fdst,'68OC.TBL');
 reset(fsrc,sizeof(bufsrc));
 rewrite(fdst,sizeof(bufdst));

 srcbufmsk:=sizeof(bufsrc)-1;
 dstbufmsk:=sizeof(bufsrc)-1;

 oc:=0;
 rcr:=1;
 ots:=0;
 i:=0;
 lwdst:=0;
 srcend:=false;
 srcesqctr:=0;
 mode:=0;
 bctr:=0;
 mticswitch:=false;

 while ((rcr=1)or(((i and srcbufmsk))>1)) do
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
   if (srcesqctr<3) then
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

  if (a=42) then mode:=1;
  if (bctr>7) then
  begin
   mode:=2;
   if(a<>42)then mode:=3;
  end;

  if (bctr>8) then mode:=3;
  if (bctr>16) then
  begin
   mode:=0;
   bctr:=0;
   writeln;
   mticswitch:=false;
  end;

  if(mode<>2) then write(chr(a));

  ocm3:=oc and 3;
  ocm38:=ocm3 shl 3;

  if(mode=0) then lwdst:=lwdst or (longint(a) shl (ocm38));
  if(mode=1) then lwdst:=lwdst or (longint(42) shl (ocm38));

  if(mode=3) then
  begin
   if((hbc and 1)=0)then lbyte:=hxoby[a];
   if((hbc and 1)=1)then
   begin
    lbyte:=(lbyte shl(4))or (hxoby[a]);
    lwdst:=lwdst or (lbyte shl (ocm38));
    write('\',lbyte:3,'-');
    delay(300);
    lbyte:=0;
   end;
  end;

  if((mode=0)or(mode=1)) then
  begin
   if(ocm3=3) then
   begin
    bufdst[(oc and dstbufmsk)shr 2]:=lwdst;
    lwdst:=0;
   end;
   if ((oc and dstbufmsk)=dstbufmsk) then
   begin
    blockwrite(fdst,bufdst,1,ots);
    for i2:=0 to (sizeof(bufsrc)shr 2)-1 do bufdst[i2]:=$40404040;
   end;
  end;

  if((mode=3)and(mticswitch=true)) then
  begin
   {writeln;write(ocm3);readln;}
   if(ocm3=3) then
   begin
    bufdst[(oc and dstbufmsk)shr 2]:=lwdst;
    lwdst:=0;
    if(a<>64) then write(' <---> ');
   end;

   if((oc and dstbufmsk)=dstbufmsk) then
   begin
    blockwrite(fdst,bufdst,1,ots);
    for i2:=0 to (sizeof(bufsrc)shr 2)-1 do bufdst[i2]:=$40404040;
   end;

   mticswitch:=false;
  end;

  if((mode=3)and(ocm3=3)) then mticswitch:=true;

  if(mode=0) then
  begin
   inc(i);
   inc(oc);
   inc(bctr);
  end;

  if(mode=1) then
  begin
   inc(oc);
   inc(bctr);
  end;

  if(mode=2) then
  begin
   inc(i);
   inc(bctr);
   hbc:=0;
  end;

  if(mode=3) then
  begin
   inc(i);
   if((hbc and 1)=1)then
   begin
    inc(oc);
    inc(bctr);
   end;
   inc(hbc);
  end;
 end;
 if (oc and dstbufmsk)>0 then inc(oc);

 if ((oc and dstbufmsk)>0) then blockwrite(fdst,bufdst,1,ots);
 close(fsrc);
 close(fdst);

end.