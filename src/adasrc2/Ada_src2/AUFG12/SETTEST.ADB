with sets, Ada.Integer_Text_IO, Ada.Text_IO;
use Ada.Integer_Text_IO, Ada.Text_IO;

procedure settest is
      -- passende Ausgabeprozedur fuer Integers instantiieren.
   procedure Int_Put(i: Integer) is
   begin
      Put(i);
   end Int_Put;
      -- Integer Menge instantiieren, Vergleichsfunktion "Standard"
    package set_int is new sets(Integer,"<",">","=",">=","<=",Int_Put);
   use set_int;
s1, s2, s3: set;
begin
   s2:=incl(incl(incl(incl(incl(incl(newset,2),3),10),4),4),7);
   Put_Line("S2:"); Put(s2);
   Put_Line("S1 := S2 - 4");
   s1:=excl(s2,4);
   Put(s1);
   if contains(s1,4) then
      Put_Line("Error");
   else
      Put_Line("OK");
   end if;
   if contains(s1,7) then
      Put_Line("OK");
   else
      Put_Line("Error");
   end if;
   s3:=incl(incl(newset,2),7);
   Put_Line("S3:");Put(s3);
   Put_Line("S2 - S3:"); Put(difference(s2, s3));
   Put_Line("S2 - NULL:"); Put(difference(s2, newset));
end settest;
