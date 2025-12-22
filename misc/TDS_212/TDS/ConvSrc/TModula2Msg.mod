(*
 * TModula2Msg
 * Error converter TurboModula/TDS - ©1994 by Matthias Bock (public domain)
 * Bugs? Suggestions? Write to starfox@incubus.sub.org
 *)

MODULE TModula2Msg;

FROM M2Lib IMPORT argc,argv;
FROM Dos{37} IMPORT Lock,UnLock,FileLockPtr,ACCESS_READ,System,DeleteFile;
FROM FIO IMPORT OpenToRead,File,Close,Status,IOStatus,EOF,ReadLn;
FROM BIO IMPORT PutString,PutLine,PutInteger;
FROM StdLib IMPORT atoi;
FROM String IMPORT strcat,strcpy,strlen;

(*FROM Intuition IMPORT DisplayBeep;*)

CONST
  maxStringLen=256;

VAR
  flPtr:FileLockPtr;
  s:ARRAY BOOLEAN OF ARRAY [0..maxStringLen] OF CHAR;
  temp,name:ARRAY [0..80] OF CHAR;
  inFile:File;
  examine,delMode,switch:BOOLEAN;
  line,numberStartPos,found,count,pos:INTEGER;
  c:CHAR;

BEGIN
  IF argc<>2 THEN HALT END;
  switch:=FALSE;

  strcpy(name,argv^[1]);
  strcpy(temp,argv^[1]);

  (* create error file name *)
  pos:=strlen(temp);
  IF (temp[pos-4]=".")
  &((CAP(temp[pos-3])="D")&(CAP(temp[pos-2])="E")&(CAP(temp[pos-1])="F")
  OR(CAP(temp[pos-3])="M")&(CAP(temp[pos-2])="O")&(CAP(temp[pos-1])="D"))
  THEN
    temp[pos-3]:="e";
    temp[pos-2]:="r";
    temp[pos-1]:="r";
  END;
  
  (* is there an errorfile? *)
  flPtr:=NIL;
  flPtr:=Lock(temp,ACCESS_READ);
  examine:=flPtr<>NIL;
  UnLock(flPtr);
  
  IF examine THEN
    (* Call M2E *)
    s[switch]:="M2E ";
    strcat(s[switch],name);
    strcat(s[switch]," >T:TModula2Msg.tmp");
    System(s[switch],NIL);

    (* Convert the errors *)
    inFile:=OpenToRead("T:TModula2Msg.tmp");
    IF IOStatus(inFile)=NoError THEN
      REPEAT
        ReadLn(inFile,s[switch]);
        IF s[switch][0]="@" THEN
          IF ~switch THEN   (* @--^---^ *)
            pos:=0;
          ELSE              (* @eyymxx: bla 'bla' *)
            (* extract line number *)
            count:=0; found:=0;
            LOOP WHILE count<maxStringLen DO
              CASE s[switch][count] OF
                |CHR(27): IF found=0 THEN found:=1 END;
                |"m": IF found=1 THEN found:=2 END;
                |"0".."9": IF found=2 THEN found:=3; numberStartPos:=count END;
                |":": IF found=3 THEN EXIT END;
                ELSE
              END;
            INC(count)END; HALT END;
            FOR found:=0 TO count-numberStartPos DO
              temp[found]:=s[switch][numberStartPos+found];
            END;
            temp[count-numberStartPos]:=0C;
            line:=atoi(temp);
            
            (* extract horizontal position *)
            WHILE (pos<maxStringLen)&(s[~switch][pos]<>"^") DO INC(pos) END;
            INC(pos);
            
            (* extract error text *)
            IF s[switch][count]=":" THEN INC(count) END;
            IF s[switch][count]=" " THEN INC(count) END;
            delMode:=FALSE;
            found:=0;
            WHILE (count<maxStringLen)&(s[switch][count]<>0C) DO
              c:=s[switch][count];
              IF c=CHR(27) THEN delMode:=TRUE END;
              IF ~delMode THEN temp[found]:=c; INC(found) END;
              IF c="m" THEN delMode:=FALSE END;
            INC(count)END;
            temp[found]:=0C;
            
            (* write message *)
            PutString("<"); PutString(name); PutString("> ");
            PutInteger(line); PutString(" "); PutInteger(pos); 
            PutString(" E <"); PutString(temp); PutString(">"); PutLine;
          END;
          switch:=TRUE;
        ELSE
          switch:=FALSE;
        END;
      UNTIL EOF(inFile);
      Close(inFile);
      DeleteFile("T:TModula2Msg.tmp");
    END;
  END;
END TModula2Msg.
