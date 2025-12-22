(********************************************************************************

Name         : InfoTest.MOD
Version      : 1.0
Purpose      : Try to get infos
Author       : ms
Modified     : 2.4.86  15:35  ms

********************************************************************************)

MODULE InfoTest;

FROM Terminal   IMPORT Read, BusyRead, Write, WriteLn, WriteString;
FROM AMIGADos   IMPORT AMIGAInfoData, AMIGALockPtr, Info, Lock, UnLock;

CONST   bs  = 10C;
        lf  = 12C;
        ff  = 14C;
        cr  = 15C;
        esc = 33C;
        del =177C;

PROCEDURE ReadString(VAR st: ARRAY OF CHAR);
  VAR pos: CARDINAL;
      ch: CHAR;
BEGIN
  pos:=0;
  LOOP
    Read(ch);
    IF (ch=' ')  OR (ch=cr) OR (ch=lf) THEN
      IF pos<=HIGH(st) THEN st[pos]:=0C END;
      EXIT
    ELSIF ch=esc THEN
      st[0]:=0C;
      EXIT
    ELSIF (ch=del) & (pos>0) THEN
      Write(del); DEC(pos);
    ELSIF (ch=bs) & (pos>0) THEN
      Write(bs); DEC(pos);
    ELSIF (ch>' ') & (pos<HIGH(st)) THEN
      st[pos]:=ch;
      Write(ch);
      INC(pos)
    ELSE
    END
  END
END ReadString;

PROCEDURE WriteLong(p:LONGINT);
 VAR i:CARDINAL; s:ARRAY [0..9] OF CHAR;
BEGIN
  s:='          ';
  i:=9;
  WHILE p#0D DO
    s[i]:=CHR(CARDINAL(p MOD 10D)+48); p:=p DIV 10D; DEC(i)
  END;
  WriteString(s);
END WriteLong;

  VAR lock: AMIGALockPtr;
      infoData: AMIGAInfoData;
      name: ARRAY [0..31] OF CHAR;
      ok: BOOLEAN;
      ch: CHAR;
BEGIN
  WriteString('InfoTest          5.3.86'); WriteLn;
  WriteString('========================'); WriteLn;
  WriteLn;
  WriteString('get info to > '); ReadString(name); WriteLn;
  WriteLn;
  WriteString('lock '); WriteString(name); WriteString(' ...');
  lock:=Lock(name, FALSE);
  IF LONGINT(lock)#0D THEN
    WriteString('done'); WriteLn;
    WriteString('info ... ');
    Info(lock, infoData, ok);
    IF ok THEN
      WriteString('done'); WriteLn;
      WITH infoData DO
        WriteString('numSoftErrors :'); WriteLong(numSoftErrors); WriteLn;
        WriteString('unitNumber    :'); WriteLong(unitNumber); WriteLn;
        WriteString('diskState     :'); WriteLong(diskState); WriteLn;
        WriteString('numBlocks     :'); WriteLong(numBlocks); WriteLn;
        WriteString('numBlocksUsed :'); WriteLong(numBlocksUsed); WriteLn;
        WriteString('bytesPerBlock :'); WriteLong(bytesPerBlock); WriteLn;
        WriteString('diskType      :');
        IF diskType.val=-1D THEN WriteString('no disk present')
        ELSE WriteString(diskType.typ)
        END;
        WriteLn;
        WriteString('volumeNode    :'); WriteLong(volumeNode); WriteLn;
        WriteString('inUse         :'); WriteLong(inUse); WriteLn
      END
    ELSE
      WriteString('not done'); WriteLn
    END;
    UnLock(lock);
  ELSE
    WriteString('not done'); WriteLn
  END;
  WriteLn;
  WriteString('-- press any key to continue (BusyRead)');
  REPEAT BusyRead(ch) UNTIL ch#0C;
  WriteLn;
  WriteString('-- press any key to continue');
  Read(ch);
END InfoTest.MOD
