program test ( input, output );
{  This is a simple m2 source program designed to test m2pascal.
 }

const
        C1    =    10;


type
        ConnectPtr  =  ^ConnectType;	
	ConnectType =  record
			node    : integer;
			next    : ConnectPtr;		
	end;

	ArrayType = array [ 1.. C1 ] of  boolean;

var  
        v1int           : integer;
        v2card          : integer;
        v3real          : real;

function proc1() : integer;
begin
    if C1 = 10 then begin
        proc1 :=  C1;
    end
    else begin
        proc1 :=  0;
    end;
end;

begin {  main  }
   v1int   :=   1;
   v2card  :=   2;
   v3real  :=   3.0;

           {  Test while loop  }
   while ( v1int < 2 ) do begin
         v1int  :=  v1int  - 1;
   end;


          {  Test repeat loop  }
   repeat
       v1int := 1;
   until ( v1int < 2 ) ;

   writeln (' Simple test program written in Module-2 to '); 
   writeln (' demonstrate m2pascal (type more test.mod to see) '); writeln;
end.

