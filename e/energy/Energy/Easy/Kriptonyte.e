/* Kriptonyte v 2.3 by Marco Talamelli ( 28-11-1995 ) 	*/
/* cripta un file ascii con una password		*/

OPT OSVERSION=37

ENUM ERR_SHORT, ERR_MEM, ERR_IO, ERR_FILE, ERR_ARGS, ERR_NONE

ENUM ARG_FROM, ARG_TO,PASS,OPT_ASCII

RAISE ERR_ARGS IF ReadArgs()=NIL,
      ERR_MEM  IF New()=NIL,
      ERR_FILE IF Open()=NIL

PROC main() HANDLE
  DEF password:PTR TO CHAR,dentro:PTR TO CHAR, fuori:PTR TO CHAR,count,
      sorgente=NIL, destinazione=NIL, lunghezza, max, bin=NIL, bout=NIL,
      errori:PTR TO LONG, argomenti=NIL, args:PTR TO LONG, numero=0,template
  args:=[0, 0 ,0, 0]
  template:='FROM/A,TO/A,PASSWORD/A,ASCII/S'
  argomenti:=ReadArgs(template, args, NIL)
  sorgente:=Open(args[ARG_FROM], OLDFILE)
  IF (lunghezza:=FileLength(args[ARG_FROM]))=0 THEN Raise(ERR_SHORT)
  IF args[ARG_TO]
    destinazione:=Open(args[ARG_TO], NEWFILE)
  ELSE
    WriteF('')
    destinazione:=stdout
  ENDIF
	WriteF('Kriptonyte v2.3 by Marco Talamelli (28-11-1995)\n')
	WriteF(IF args[OPT_ASCII] THEN 'DECRIPTO...\n' ELSE 'CRIPTO..\n')
  bin:=New(lunghezza)
  bout:=New(lunghezza)
  IF (Read(sorgente, bin, lunghezza)<>lunghezza) THEN Raise(ERR_IO)
  dentro:=bin
  fuori:=bout
  password:=args[PASS]
  count:= StrLen(password)
  max:=bin+lunghezza
  WHILE dentro<max

IF args[OPT_ASCII]
        fuori[]++:= IF (dentro[]-password[numero]+count)<0 THEN (dentro[]+count+127-password[numero]) ELSE dentro[]-password[numero]+count
 IF count=numero THEN numero:=0 ELSE numero++
ELSE

        fuori[]++:= IF (dentro[]+password[numero]-count)>127 THEN (dentro[]+password[numero]-count-127) ELSE dentro[]+password[numero]-count
 IF count=numero THEN numero:=0 ELSE numero++
ENDIF
    dentro++

  ENDWHILE
  Write(destinazione, bout, fuori-bout)
  Raise(ERR_NONE)
EXCEPT
  errori:=['Il File è vuoto\n', 'Non posso allocare memoria\n',
           'File leggendo errore\n'] 
  IF destinazione THEN Close(destinazione)
  IF sorgente THEN Close(sorgente)
  IF argomenti THEN FreeArgs(argomenti)
  IF exception=ERR_FILE
    WriteF('File "\s" non trovato!\n', args[ARG_FROM])
  ELSEIF exception=ERR_ARGS
    WriteF('Usage: Kriptonyte "\s"\n', template)
  ELSEIF exception<>ERR_NONE
    WriteF(errori[exception])
  ENDIF
ENDPROC
