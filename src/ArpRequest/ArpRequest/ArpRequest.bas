'*****************************************************************************
'*                                                                           *
'*                             ArpRequest.bas                                *
'*                      written on 3rd october 1991                          *
'*                         © by Andreas Ackermann                            *
'*                                                                           *
'*****************************************************************************
                  ' die Parameter der SUB-Routine sind auch in deutsch
                  ' beschrieben !!!
startup:          ' you must do all this once in your programm;
                  ' the best thing is, to do it right at the beginning
LIBRARY "arp.library"
LIBRARY "exec.library"
DECLARE FUNCTION filerequest&() LIBRARY
DECLARE FUNCTION allocmem&() LIBRARY

DIM code%(12)
FOR i=0 TO 12      ' get the DATA-statements in a variable-field
  READ  code%(i)
NEXT

' end of Startup.
' That's all. Here you can start your own programm !


' Let's display the requester twice; once on the workbenchscreen, and once
' on a custom-screen

main:

PRINT
PRINT " Try out pressing right mouse-button when the requester is active !"
CALL getfilename (dir$,file$,"Select a file",40,10,0&,erg%,code%())
Print
if erg%=2 then Print" User selected CANCEL":goto goon
PRINT " Directory:     ";dir$
PRINT " Filename:      ";file$
path$=dir$
IF RIGHT$(path$,1)><":" AND RIGHT$(path$,1)><"/" AND path$><"" THEN path$=path$+"/"
path$=path$+file$
PRINT " Complete path: ";path$
goon:
PRINT:PRINT:PRINT " - Press left mouse button to go on -"
SLEEP:SLEEP

SCREEN 2,640,200,2,2
WINDOW 2,"Arp-Filerequester-Demo",(1,12)-(630,180),6,2
WINDOW OUTPUT 2
spointer&=PEEKL(WINDOW(7)+46)
file$=""
CALL getfilename (dir$,file$,"Select a file",40,10,spointer&,erg%,code%())
PRINT:PRINT " Of course, you may give the user something to edit."
PRINT " [Try out selecting a directory in the first example !]"
PRINT
if erg%=2 then print" User selected CANCEL":goto ende
PRINT " Directory:     ";dir$
PRINT " Filename:      ";file$
path$=dir$
IF RIGHT$(path$,1)><":" AND RIGHT$(path$,1)><"/" AND path$><"" THEN path$=path$+"/"
path$=path$+file$
PRINT " Complete path: ";path$

ende:
PRINT:PRINT:PRINT " - Press left mouse button to exit -"
SLEEP:SLEEP
SCREEN CLOSE 2


END

'Explaination on the parameters:
'path$ contains, after calling Getfilename, the directory name of the choosen
'      file.
'      if it's not empty when passing it to Getfilename, this string will appear
'      in the directory-stringgadget
'file$ the same as path$, but it contains the filename
'text$ String for the titlebar of the requester
'xpos% x-position of the requester
'ypos% y-position of the requester
'disp& startaddress of the screen on which the requester should appear or 0& to
'      get it on the Workbench-screen.
'      How to get the address: activate by WINDOW OUTPUT any window of that
'      screen; then assign any variable as PEEKL(WINDOW(7)+46) and pass it to
'      Getfilename.
'feh%  after calling Getfilename it contains zero if everything was ok,
'      1 if there was not enough memory
'      and 2 if the user selected CANCEL
'dat%() This field contains a small assembly programm (13 words) making it
'      possible to let the requester appear on other screens and at other
'      positions.


'Erkärung der Parameter:
'path$ nach Ausführung von Getfilename enthält diese Variable das Verzeichnis,
'      in dem das ausgewählte File steht.
'      Enthält path$ vor der Ausführung bereits einen String, so erscheint die-
'      ser im path-Stringgadget.
'file$ hier gilt das gleiche wie für path$; diese Variable enthält jedoch den
'      Dateinamen.
'text$ Text für die Titelleiste des Requesters.
'xpos% x-Position des Requesters.
'ypos% y-position des Requesters.
'disp& enthält die Startaddresse des Screens, auf dem der Requester erscheinen
'      soll, oder 0& für den Workbenchscreen
'      Die Addresse bekommen Sie so: Mit WINDOW OUTPUT aktivieren Sie ein
'      beliebiges Fenster dieses Screens; dann weisen Sie irgendeiner Variablen
'      den (& !!!) Wert PEEKL(WINDOW(7)+46) zu und übergeben diese an Getfile-
'      name.
'feh%  Enthält nach der Ausführung 0 wenn alles gut ging,
'      1 wenn der Speicher nicht reichte,
'      und 2 wenn der Anwender CANCEL gewählt hat.
'dat%() Dieses Variablenfeld enthält die 13 Words, die das Assembler-Programm
'      darstellen, das benötigt wird, um den Requester auf einem anderen Screen
'      bzw. an einer anderen Position erscheinen zu lassen.

SUB getfilename(path$,file$,text$,xpos%,ypos%,disp&,feh%,dat%()) STATIC
  feh%=0
  mem&=allocmem&(150&,65536&)
  IF mem&=0 GOTO fehler
  frmem&=mem&           'we must store the start of memory to free it afterwards.
  FOR i=0 TO 12         'the assembly-code must be placed in a piece of memory
                        'allocated by allocmem()
    POKEW  mem&,dat%(i) 'to avoid the Amiga jumping to India(GURU) cause
    mem&=mem&+2         'Basic often shifts its variables.
  NEXT                     'the following 4 pokes will modify the newwindow-
  IF disp&><0 THEN         'structure which is passed to the assembly-programm
    POKEW frmem&+12,15     'when calling filerequest()
    POKEL frmem&+18,disp&  '1st: indicate that its a customscreen and not WB
  END IF                   'which would require a 1
  txt$=text$+CHR$(0)       '2nd: address of screen in nw_wscreen
  POKEW frmem&+2,xpos%     '3rd: x-pos of request
  POKEW frmem&+6,ypos%     '4th: ...
  POKEL mem&,SADD(txt$)    'title-bar-text in the filerequest-structure
  POKEL mem&+4,mem&+30     'start of file-buffer     }length: 34 bytes
  POKEL mem&+8,mem&+70     'start of directory-buffer}        each
  POKE mem&+16,8           'flag: we wanna get the newwindow-struct
                           'the only other possibility: 40 : this will result
                           'in a change of colors
  FOR i=1 TO LEN(path$)                   'write path$ in directory-buffer
    POKE mem&+69+i,ASC(MID$(path$,i,1))
  NEXT i
  FOR i=1 TO LEN(file$)                   'write file$ in filename-buffer
    POKE mem&+29+i,ASC(MID$(file$,i,1))
  NEXT i
  POKEL mem&+18,frmem&
  result&=filerequest&(mem&)              'call it
  IF result&=0 THEN feh%=2:GOTO cancel    'if zero: user selected cancel
  path$="":i=0
  WHILE PEEK(mem&+70+i)><0                'read directory-buffer
    path$=path$+CHR$(PEEK(mem&+70+i))     '(zero-terminated)
    i=i+1
  WEND
  file$="":i=0
  WHILE PEEK(mem&+30+i)><0                'read file-buffer
    file$=file$+CHR$(PEEK(mem&+30+i))     '(zero-terminated)
    i=i+1
  WEND
cancel:
  CALL freemem&(frmem&,150&)              'clean up
  EXIT SUB
fehler:
  feh%=1
END SUB

' Assembly code:             ' we get the newwindow-structure in a0 and
' move.w  #$0010,(a0)        ' modify it as we need.
' move.w  #$0010,02(a0)
' move.w  #$0001,46(a0)
' move.l  #$0000,30(a0)
' rts

DATA &h30BC,&h0010,&h317C,&h0010,&h0002,&h317C
DATA &h0001,&h002E,&h217C,&h0000,&h0000,&h001E,&h4E75

' here is the filerequest structure :
'
' type  name          offset explaination
' CPTR  fr_hail       + 0    title-bar-text
' CPTR  fr_file       + 4    *filename array
' CPTR  fr_dir        + 8    *directory array
' CPTR  fr_window     +12    window requesting or NULL
' UBYTE fr_funcflags  +16    flags (Basic only 8 and 40); any other
'                            value here will crash the machine !!!
' UBYTE fr_reserved1  +17    set to zero
' APTR  fr_function   +18    here we put a pointer to our assemply programm
'                            so that we may modify the newwindow structure
' LONG  fr_reserved2  +22    set to zero
' total length :       26



