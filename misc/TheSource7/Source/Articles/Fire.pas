{
and here's the pas code.. sorry its way crap.. I was just testing it out
when I wrote it.. so understand the effect, you should see the text mode
version! :))
}
PROGRAM Testfireball;

Uses Dos,Crt;
  {$M $4000,0,0 }   { 16K stack, no heap }
CONST MAX=319;
      MAY=199;

VAR
   OldArray:Array [0..MAy,0..MAx]of byte;
   NewArray:Array [0..MAy,0..MAx]of byte absolute $a000:0000;
   pal:array[0..256,0..2]of byte;
   i,j:integer;


PROCEDURE Initarrays;     {clear both arrays to 0}
Var i,j:integer;
begin
     for i:= 0 to may do
         begin
              for j:=0 to max do
                  begin
                       oldarray[i,j]:=0;
                       newarray[i,j]:=0;
                  end;
         end;
end;

procedure PAL1;   {crap way to set a palette} {change this}
BEGIN
     SWAPVECTORS;
     exec('pal1.exe','');
     swapvectors;
end;


PROCEDURE Sumnewarray;  {calc new point value by averaging surrounding pixels}
var i,j:integer;
    newval:word;
begin
     for i:= 1 to (may-1) do
         begin
              for j:=1 to (max-1) do
                  begin
                      newval:=
                      (oldarray[i+1,j-1]+
                       oldarray[i+1,j  ]+
                       oldarray[i+1,j+1]+
                       oldarray[i+2,j-1]+
                       oldarray[i+2,j+1]+
                       oldarray[i+3,j-1]+
                       oldarray[i+3,j+1]+
                       oldarray[i+3,j  ]);
                       newval:=(newval shr 3);   {faster div by 8}
                       if (newval>0) then dec(newval); {decrement (fadeout)}

                       newarray[i,j]:=(lo(newval));

                  end;
         end;


end;

PROCEDURE CopyNewtoold; {save new(updated) array to old}
var i,j:integer;
begin
     for i:= 0 to may do
         begin
              for j:=0 to max do
                  begin
                       oldarray[i,j]:=newarray[i,j];
                  end;
         end;
end;

PROCEDURE Putrandomhotspots;        {puts random hotspots on bottom line}
var i,j:integer;
    hotspot:integer;
begin
randomize;
for hotspot:=0 to 60 do                 {60 hotspots.. }
    begin
         i:=(random(max));
         j:=(may-3);
         oldarray[j,i]:=255;
         oldarray[j-1,i]:=255;
         oldarray[j+1,i]:=255;
         oldarray[j,i+1]:=255;
         oldarray[j,i-1]:=255;
         oldarray[j+1,i+1]:=255;
         oldarray[j,i+2]:=255;
    end;


end;

Procedure Initmode(n:byte);assembler; {sets the vid mode}
asm
   mov  ah,0h
   mov  al,n
   int  10h
end;



BEGIN
    initmode(19);
    Initarrays;
    pal1;
    repeat
    putrandomhotspots;
    sumnewarray;
    copynewtoold;
    until keypressed;
    initmode(3);
END.
{
as you can see, you need a palette procedure... but I should hope you
can do that.. :))
}
