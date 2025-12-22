MODULE Pointers;

FROM InOut   IMPORT WriteString, WriteInt, WriteLn;
FROM Heap    IMPORT Allocate, Deallocate;
FROM SYSTEM  IMPORT TSIZE;

TYPE Name = ARRAY[0..20] OF CHAR;

VAR  MyName : POINTER TO Name;    (* MyName points to a string *)
     MyAge  : POINTER TO INTEGER; (* MyAge points to an INTEGER *)

BEGIN

   Allocate(MyAge,TSIZE(INTEGER));
   Allocate(MyName,TSIZE(Name));

   MyAge^ := 27;
   MyName^ := "John Q. Doe";

   WriteString("My name is ");
   WriteString(MyName^);
   WriteString(" and I am ");
   WriteInt(MyAge^,3);
   WriteString(" years old.");
   WriteLn;

   Deallocate(MyAge);
   Deallocate(MyName);

END Pointers.
