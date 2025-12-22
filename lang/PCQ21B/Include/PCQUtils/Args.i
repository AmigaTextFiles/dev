
{
   PCQUtils/Args.i

   How to use this functions.

   To check the args for a cli program

   FOR i := 1 TO ParamCount() DO
       Writeln(ParamStr(i));

   If you want the correct number of args

   IF ParamCount() = 3 THEN ....
       ....
   ELSE
       .....

   For an example look at the demo Strtol.p

   Author: nils.sjoholm@mailbox.swipnet.se  (Nils Sjoholm)
}


FUNCTION ParamCount():INTEGER;
EXTERNAL;

FUNCTION ParamStr( thenum : INTEGER): STRING;
EXTERNAL;

FUNCTION SwitchNum(S : STRING) : INTEGER;
EXTERNAL;

{
   Search for a specific switch.
   Lets say you want the user to use the switch -o for the
   output file, then you can do like this.

   const
       outsw = "-o";
   ....
   ....

   IF SwitchThere(outsw) THEN BEGIN
       OutFile := SwitchData(outsw); (* OutFile must be allocated *)
       .....
   END ELSE CleanUp("No outputfile",5);
   ....

   SwitchThere and SwitchData is casesensitive so -o and -O is
   not the same.
}
FUNCTION SwitchThere(S : STRING) : BOOLEAN;
EXTERNAL;

FUNCTION SwitchData(S : STRING) : STRING;
EXTERNAL;

FUNCTION WBArgNum(): Integer;
EXTERNAL;

FUNCTION GetWBArg(num : Integer): STRING;
EXTERNAL;



 






                                        
