PROC main() HANDLE
/* EPP must have already been run with the -m option */
/* in order for this program to show anything.       */
  DEF fh=NIL, index:PTR TO INT, moduleName[30]:STRING, exitmsg, interrupted=FALSE
  '$VER: ShowMap 1.4a (3.13.94)'
  index:=[0, 0, 0]:INT
  IF (fh:=Open('T:epp.map', OLDFILE))=NIL THEN Raise("FILO")
  REPEAT
    IF Read(fh, index, 6)<6 THEN Raise("FILR")
    IF CtrlC() THEN interrupted:=TRUE
    IF interrupted=FALSE THEN WriteF('moduleId=\d global=\d local=\d\n', index[0], index[1], index[2])
  UNTIL index[0]=0
  IF interrupted THEN WriteF('*** Index display interrupted\n')
  WHILE ReadStr(fh, moduleName)>-1 DO WriteF('\s\n', moduleName)
  Close(fh)
EXCEPT
  IF fh THEN Close(fh)
  SELECT exception
    CASE "FILO"; exitmsg:='Can\at open file'
    CASE "FILR"; exitmsg:='Error reading file'
    DEFAULT;     exitmsg:='Oof!  What hit me?'
  ENDSELECT
  WriteF('\s\n', exitmsg)
ENDPROC
