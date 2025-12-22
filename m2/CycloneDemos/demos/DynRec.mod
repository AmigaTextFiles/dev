MODULE DynRec;

FROM InOut   IMPORT WriteString, Write, WriteLn;
FROM Heap    IMPORT Allocate, Deallocate;
FROM SYSTEM  IMPORT TSIZE;
FROM DosL    IMPORT Delay;

CONST  NumberOfFriends = 50;

TYPE   FullName = RECORD
         FirstName : ARRAY[0..12] OF CHAR;
         Initial   : CHAR;
         LastName  : ARRAY[0..15] OF CHAR;
       END;

       Date = RECORD
         Day   : CARDINAL;
         Month : CARDINAL;
         Year  : CARDINAL;
       END;

       PersonID = POINTER TO Person;
       Person = RECORD
         Name      : FullName;
         City      : ARRAY[0..15] OF CHAR;
         State     : ARRAY[0..3] OF CHAR;
         BirthDay  : Date;
       END;

VAR   Friend  : ARRAY[1..NumberOfFriends] OF PersonID;
      Self, Mother, Father : PersonID;
      Temp    : Person;
      Index   : CARDINAL;

BEGIN  (* Main program *)
   Allocate(Self,TSIZE(Person));    (* Create a dynamically
                                                Allocated variable *)
   Self^.Name.FirstName := "Charley ";
   Self^.Name.Initial := 'Z';
   Self^.Name.LastName := " Brown";
   WITH Self^ DO
      City := "Anywhere";
      State := "CA";
      BirthDay.Day := 17;
      WITH BirthDay DO
         Month := 7;
         Year := 1938;
      END;
   END;     (* All data for Self is now defined *)

   Allocate(Mother,TSIZE(Person));
   Mother := Self;

   Allocate(Father,TSIZE(Person));
   Father^ := Mother^;

   FOR Index := 1 TO NumberOfFriends DO
      Allocate(Friend[Index],TSIZE(Person));
      Friend[Index]^ := Mother^;
   END;

   Temp := Friend[27]^;
   WriteString(Temp.Name.FirstName);
   Write(Self^.Name.Initial);
   WriteString(Mother^.Name.LastName);
   WriteLn;

   Delay(100); (* Wait a while *)

   Deallocate(Self);
(* Deallocate(Mother); Since Mother is lost, it cannot
                                                    be disposed of *)
   Deallocate(Father);
   FOR Index := 1 TO NumberOfFriends DO
      Deallocate(Friend[Index]);
   END;

END DynRec.
