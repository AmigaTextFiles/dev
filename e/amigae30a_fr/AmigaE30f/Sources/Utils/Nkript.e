/* Nkript.e, très simple (dé)codeur de fichier
   USAGE: nkript <file>

   nkript demande une clé de 4 lettre,et un code de 3 lettre.
   Comme nkrip utilise EOR, vous pouvez utiliser ce programme pour coder et
   décoder. La clé et le code ne sont sauvés nul part, comme ça il est
   _relativement_ sûr. Ca a pour effet que si vous taper la mauvaise clé,
   aucune erreur n'est donné, mais le fichier est simplement mal décodé.

*/

MODULE 'tools/file'

ENUM ER_NONE,ER_FILE,ER_MEM,ER_USAGE,ER_OUT,ER_ILLEGAL,ER_NONUM

PROC main() HANDLE
  DEF flen,mem=NIL,key,keyadd,file[200]:STRING,p
  WriteF('Nkript (c) 1992 $#%!\n')
  IF StrCmp(arg,'',1) OR StrCmp(arg,'?',2) THEN Raise(ER_USAGE)
  mem,flen:=readfile(arg)
  key:=readpass('key',4,FALSE)
  keyadd:=readpass('pin',3,TRUE) OR 3
  WriteF('Now (de)coding "\s".\n',arg)
  MOVE.L flen,D7
  LSR.L  #2,D7          /* D7 = #of LONGs */
  MOVE.L key,D6
  MOVE.L keyadd,D4
  MOVE.L mem,A0
  loop:
  MOVE.L D4,D5
  SUB.L  D6,D5
  LSL.L  #3,D6          /* random alg.  D6*7+keyadd (11) */
  ADD.L  D5,D6
  EOR.L  D6,(A0)+
  DBRA   D7,loop
  SUB.L  #$10000,D7
  BCC.S  loop           /* DBRA.L emulation */
  p:=InStr(arg,'.',0)
  StrCopy(file,arg,p)
  IF StrCmp(arg+p,'.nkr',ALL)=FALSE THEN StrAdd(file,'.nkr',ALL)
  writefile(file,mem,flen)
EXCEPT DO
  IF mem THEN freefile(mem)
  SELECT exception
    CASE ER_NONE;    WriteF('OK.\n')
    CASE "OPEN";     WriteF('Ne peut atteindre le fichier "\s" !\n',exceptioninfo)
    CASE "IN";       WriteF('Ne peut lire le fichier "\s" !\n',exceptioninfo)
    CASE "OUT";      WriteF('Ne peut écrire le fichier "\s" !\n',exceptioninfo)
    CASE "MEM";      WriteF('Pas de mémoire pour charger!\n')
    CASE ER_USAGE;   WriteF('USAGE: Nkript <file>\n')
    CASE ER_ILLEGAL; WriteF('Mauvais nombre de caractères\n')
    CASE ER_NONUM;   WriteF('N''est pas un nombre décimal\n')
  ENDSELECT
ENDPROC

PROC readpass(messy,numchars,decflag)
  DEF s[25]:STRING,a,t,n=0,f=1
  WriteF('\s[\d]: ',messy,numchars)
  ReadStr(stdout,s)
  IF EstrLen(s)<>numchars THEN Raise(ER_ILLEGAL)
  IF decflag
    t:=s
    FOR a:=1 TO numchars
      n:=n+(t[]-"0"*f)
      IF (t[]<"0") OR (t[]++>"9") THEN Raise(ER_NONUM)
      f:=f*10
    ENDFOR
    ^s:=n
  ENDIF
ENDPROC ^s
