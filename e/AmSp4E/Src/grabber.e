/**
 ** Grabber v1.0
 ** written by Krzysztof Cmok.
 **
 ** This program converting cut-IFF to AmSp or AmIc Bob
 ** In AmigaE procedures to this Bobs is AmosBobs.m module...
 **
 **                          & & & &
 **
 **/

OPT PREPROCESS
OPT OSVERSION=37

/* Modules */
MODULE 'tools/easygui',
   'shark/aslreqs',
   'shark/shkilbm',
   'intuition/screens',
   'intuition/intuition',
   'shark/memtools',
   'graphics/gfx',
   'graphics/rastport',
   'tools/clonescreen'

/*endfold*/

/* abk object */
OBJECT abk
   type:PTR TO CHAR  -> Rodzaj formatu AmSp,AmIc
   ilosc:INT         -> Ilosc objektow
   paleta:PTR TO INT -> Paleta kolorow (zadeklarowana na koncu pliku)
   w:PTR TO INT      -> Jaka szerokosc objekta. TRZEBA POMNOZYC *16
   h:PTR TO INT      -> Jaka dlugosc objekta
   d:PTR TO INT      -> Ile planow dla objekta
   hx:PTR TO INT     -> Hot X (Cieply punkt)
   hy:PTR TO INT     -> Hot Y (Cieply punkt)
   image:PTR TO LONG -> Image objekta (Musi byc w pamieci CHIP bo to graficzna)
ENDOBJECT

/*endfold*/

/* Declarations DEF's and CONSTANT's */
DEF iff_filename[512]:STRING,gh,ifftext,iffmem=0:PTR TO milbm
DEF abk_filename[512]:STRING,abktext,abkmem=0:PTR TO abk,nmrtext,cyctext=0,cyccols=0

DEF curr_obj=0,chipdata,rrrsize,abk_curr:PTR TO abk

DEF iff_textinfo[256]:STRING,abk_textinfo[256]:STRING

CONST BUFORTOOBJECT = 50000  /* Buffer for one current object is be more than
            BUFORTOOBJECT that object can't display */

/*endfold*/

/* Main program "MAIN PROCEDURE" */
PROC main()
IF mIlbmLibraryOpen()=0 THEN RETURN 0

NEW abk_curr
chipdata:=NewM(BUFORTOOBJECT,2)
abkmem:=New(SIZEOF abk)
abkmem.type:=New(10)
abkmem.w:=New(5000 * 4) ; abkmem.h:=New(5000 * 4)
abkmem.d:=New(5000 * 4) ; abkmem.image:=New(5000 * 4)
abkmem.hx:=New(5000 * 4) ; abkmem.hy:=New(5000 * 4)
abkmem.paleta:=New(256 * 4);
abkmem.ilosc:=-1

easyguiA('AmSpGrabber v1.0',
     [EQROWS,
       [COLS,
     cyccols:= [CYCLE,{colors},'Colors',['Default','2','4','8','16','32','64','128','256',0],0],
     cyctext:= [CYCLE,{typ},'File-Format',['AmSp','AmIc',0],0]],
       [COLS,
         [BUTTON,{loadiff},'Load IFF'],
         [BUTTON,{pickpal},'Pick Pal'],
     ifftext:= [TEXT,'No informations!','ILBM',TRUE,3]
       ],
       [COLS,
         [BUTTON,{loadabk},'Load Abk'],
         [BUTTON,{saveabk},'Save Abk'],
     abktext:= [TEXT,'No informations!','AmSp',TRUE,3]
       ],
       [COLS,
         [BUTTON,{grabiff},'Grab IFF'],
         [BUTTON,{hotspot},'Hot Spot'],
         [BUTTON,{leftobj},'|<'],
     nmrtext:= [TEXT,'NONE',NIL,TRUE,1],
         [BUTTON,{rightobj},'>|']
       ],
       [COLS,
         [SBUTTON,{viewbob},'View Bob'],
         [SBUTTON,{replbob},'Replace Bob'],
         [SBUTTON,{addbob},'Add Bob'],
         [SBUTTON,{clearbob},'Clear Bob']
       ],
       [COLS,
         [SBUTTON,{allobj},'All objects'],
         [SBUTTON,{objinfo},'Object info'],
         [SBUTTON,{jumpto},'Jump to obj'],
         [SBUTTON,{eraseall},'Erase all']
       ]
     ],[EG_GHVAR,{gh},0]);

freeabk(abkmem)
IF iffmem THEN mIlbmDispose(iffmem)
mIlbmLibraryClose()
Dispose(chipdata)
END abk_curr
ENDPROC
/*endfold*/

/* Skasowanie jednego bob'a "CLEARBOB PROCEDURE" */
PROC clearbob()
DEF a,s[512]:STRING
IF abkmem.ilosc<>TRUE
   Dispose(abkmem.image[curr_obj])
   FOR a:=curr_obj TO abkmem.ilosc-1
     abkmem.image[a]:=abkmem.image[a+1]
     abkmem.w[a]:=abkmem.w[a+1]
     abkmem.h[a]:=abkmem.h[a+1]
     abkmem.d[a]:=abkmem.d[a+1]
     abkmem.hx[a]:=abkmem.hx[a+1]
     abkmem.hy[a]:=abkmem.hy[a+1]
   ENDFOR
     abkmem.w[abkmem.ilosc]:=0
     abkmem.h[abkmem.ilosc]:=0
   abkmem.ilosc:=abkmem.ilosc-1
   StringF(s,'[\z\d[4]/\z\d[4]] CL',curr_obj,abkmem.ilosc-1)
   settext(gh,nmrtext,s)
ENDIF
ENDPROC

/*endfold*/

/* Zastapienie starego boba nowym "REPLBOB PROCEDURE" */
PROC replbob()
IF abkmem.ilosc<>TRUE
  Dispose(abkmem.image[curr_obj])
ELSE
  curr_obj:=0
  abkmem.ilosc:=1
  IF abkmem.type[]=0 THEN strtomem(abkmem.type,'AmSp')
ENDIF
IF (chipdata)
  IF (rrrsize>0)
    abkmem.w[curr_obj]:=abk_curr.w
    abkmem.h[curr_obj]:=abk_curr.h
    abkmem.d[curr_obj]:=abk_curr.d
    abkmem.hx[curr_obj]:=0;
    abkmem.hy[curr_obj]:=0;
    abkmem.image[curr_obj]:=New(rrrsize + 100);
    CopyMemQuick(chipdata,abkmem.image[curr_obj],rrrsize);
  ENDIF
ENDIF

ENDPROC

/*endfold*/

/* Dodanie do listy kolejnego boba "ADDBOB PROCEDURE" */
PROC addbob()
DEF a,s[512]:STRING
IF abkmem.ilosc=-1
  curr_obj:=0
  abkmem.ilosc:=0
  IF abkmem.type[]=0 THEN strtomem(abkmem.type,'AmSp')
ENDIF

IF abkmem.ilosc<>TRUE
IF (chipdata)
  IF (rrrsize>0)
   FOR a:=abkmem.ilosc TO curr_obj STEP -1
       abkmem.w[a+1]:=abkmem.w[a];
       abkmem.h[a+1]:=abkmem.h[a];
       abkmem.d[a+1]:=abkmem.d[a];
       abkmem.hx[a+1]:=abkmem.hx[a];
       abkmem.hy[a+1]:=abkmem.hy[a];
       abkmem.image[a+1]:=abkmem.image[a];
   ENDFOR
   abkmem.ilosc:=abkmem.ilosc+1;
       abkmem.w[curr_obj]:=abk_curr.w
       abkmem.h[curr_obj]:=abk_curr.h
       abkmem.d[curr_obj]:=abk_curr.d
       abkmem.hx[curr_obj]:=0;
       abkmem.hy[curr_obj]:=0;
       abkmem.image[curr_obj]:=New(rrrsize + 100);
       CopyMemQuick(chipdata,abkmem.image[curr_obj],rrrsize);
     StringF(s,'[\z\d[4]/\z\d[4]] AD',curr_obj,abkmem.ilosc-1)
     settext(gh,nmrtext,s)
  ENDIF
ENDIF
ENDIF
ENDPROC

/*endfold*/

/* ustawienia przez GUI kolorow  "COLORS PROCEDURE" */
PROC colors(depth)
IF abkmem.ilosc<>TRUE
   IF depth=0
     IF iffmem
       depth:=iffmem.depth;
     ELSE
       setcycle(gh,cyccols,abkmem.d[curr_obj]);
       depth:=abkmem.d[curr_obj];
       ifferr(0)
     ENDIF
   ENDIF
   abkmem.d[curr_obj]:=depth;
ENDIF
ENDPROC

/*endfold*/

/* wyczyszczenie pamieci "ERASEALL PROCEDURE" */
PROC eraseall()
abkmem.ilosc:=-1
IF iffmem THEN mIlbmDispose(iffmem)
IF abkmem.ilosc<>TRUE THEN freeabk(abkmem,TRUE)
iffmem:=0
ENDPROC

/*endfold*/

/* pick palette from IFF "PICKPAL PROCEDURE" */
PROC pickpal()
DEF abc
IF abkmem.ilosc<>TRUE
   IF iffmem
     FOR abc:=0 TO (iffmem.colors-1)
       abkmem.paleta[abc]:=iffmem.colortable[abc];
     ENDFOR
     bifferr('Picked IFF Palette!',1)
   ENDIF
ENDIF
ENDPROC

/*endfold*/

/* ustawienie czulego punktu "HOTSPOT/HOTSPT2/SPT3 PROCEDURES" */
PROC hotspot()
IF abkmem.ilosc<>TRUE THEN easyguiA('Change HotSpot...',[EQROWS,[BEVEL,[INTEGER,{hotspot2},'Hot.X',abkmem.hx[curr_obj],10]],
                 [BEVEL,[INTEGER,{hotspot3},'Hot.Y',abkmem.hy[curr_obj],10]]])
ENDPROC

PROC hotspot2(value)
IF value>(abkmem.w[curr_obj]*16) THEN value:=abkmem.w[curr_obj]*16
IF value<0 THEN value:=0
abkmem.hx[curr_obj]:=value;
ENDPROC

PROC hotspot3(value)
IF value>(abkmem.h[curr_obj]) THEN value:=abkmem.h[curr_obj]
IF value<0 THEN value:=0
abkmem.hy[curr_obj]:=value;
ENDPROC

/*endfold*/

/* skok do innego bob'a "JUMPTO/JMPTO2 PROCEDURE" */
PROC jumpto()
IF abkmem.ilosc<>TRUE THEN easyguiA('Jump to...',[EQROWS,[BEVEL,[INTEGER,{jumpto2},'Jump',curr_obj,10]]])
ENDPROC

PROC jumpto2(value)
DEF s[256]:STRING

curr_obj:=value
IF curr_obj<0 THEN curr_obj:=0
IF curr_obj>(abkmem.ilosc-1) THEN curr_obj:=(abkmem.ilosc-1)
StringF(s,'[\z\d[4]/\z\d[4]] JM',curr_obj,abkmem.ilosc-1)
settext(gh,nmrtext,s)
setcycle(gh,cyccols,abkmem.d[curr_obj])
ENDPROC

/*endfold*/

/* pokazanie jednego boba "VIEWBOB PROCEDURE" */
PROC viewbob()
DEF s:PTR TO screen,font,a,cols=1
IF abkmem.ilosc<>TRUE
   s,font:=openclonescreen('Workbench','AmSp Grabber',abkmem.d[curr_obj])
   SetAPen(s.rastport,0) ; RectFill(s.rastport,0,0,s.width-1,40)
   FOR a:=1 TO abkmem.d[curr_obj] DO cols:=cols*2
   LoadRGB4(s.viewport,abkmem.paleta,cols);
   drwbob(s.rastport,curr_obj,(s.width/2)-(abkmem.w[curr_obj]/2),0)
   REPEAT ; UNTIL Mouse()=1;
   Delay(10);
   closeclonescreen(s,font)
ELSE
   bifferr('No a Abk file loaded!',1)
ENDIF
ENDPROC

/*endfold*/

/* pokazanie wszystkich bobow na ekran "ALLOBJ PROCEDURE" */
PROC allobj()
DEF s:PTR TO screen,font,cols=1,a,z,h,h2,objekt

IF abkmem.ilosc<>TRUE
   s,font:=openclonescreen('Workbench','AmSp Grabber',abkmem.d[curr_obj])
   SetAPen(s.rastport,0) ; RectFill(s.rastport,0,0,s.width-1,40)
   FOR a:=1 TO abkmem.d[curr_obj] DO cols:=cols*2
   LoadRGB4(s.viewport,abkmem.paleta,cols);

     objekt:=curr_obj; z:=0; h:=0; h2:=0
     REPEAT
   REPEAT
     IF abkmem.w[objekt]>0 THEN drwbob(s.rastport,objekt,z,h) ELSE JUMP allobj_here
     z:=z+(abkmem.w[objekt]*16)+1
     IF h2<(abkmem.h[objekt]) THEN h2:=abkmem.h[objekt]

     objekt++;
   UNTIL z>(s.width-(abkmem.w[objekt]*16))
     h:=h+h2+1; z:=0
     UNTIL h>(s.height-h2)
   Delay(10)
   allobj_here:
   REPEAT ; UNTIL Mouse()=1;
   closeclonescreen(s,font)
ELSE
   bifferr('No a Abk file loaded!',1)
ENDIF
ENDPROC

/*endfold*/

/* procedurka wyswietla bob'y "DRWBOB PROCEDURE" */
PROC drwbob(rport,imgnr,x,y)
DEF cols=1,a,rasize
FOR a:=1 TO abkmem.d[imgnr] DO cols:=cols*2
rasize:=(RASSIZE(abkmem.w[imgnr]*16,abkmem.h[imgnr]) * abkmem.d[imgnr])
IF rasize<BUFORTOOBJECT
CopyMemQuick(abkmem.image[imgnr],chipdata,rasize)
DrawImage(rport,[0,0,abkmem.w[imgnr]*16,abkmem.h[imgnr],
      abkmem.d[imgnr],chipdata,cols-1,0,0]:image,x,y);
      rrrsize:=0;
ENDIF
ENDPROC

/*endfold*/

/* rodzaj formatu AmSp/AmIc "TYP PROCEDURE" */
PROC typ(v)
   IF v=0 THEN strtomem(abkmem.type,'AmSp')
   IF v=1 THEN strtomem(abkmem.type,'AmIc')
ENDPROC

/*endfold*/

/* bob o jeden raz w lewo "LEFTOBJ PROCEDURE" */
PROC leftobj()
DEF s[512]:STRING
IF abkmem.ilosc<>TRUE
   DEC curr_obj
   IF curr_obj<0 THEN curr_obj:=(abkmem.ilosc-1)
   StringF(s,'[\z\d[4]/\z\d[4]] <=',curr_obj,abkmem.ilosc-1)
   settext(gh,nmrtext,s)
   setcycle(gh,cyccols,abkmem.d[curr_obj])
ELSE
   settext(gh,nmrtext,'NONE')
ENDIF
ENDPROC

/*endfold*/

/* bob o jeden raz w prawo "RIGHTOBJ PROCEDURE" */
PROC rightobj()
DEF s[512]:STRING
IF abkmem.ilosc<>TRUE
   INC curr_obj
   IF curr_obj>(abkmem.ilosc-1) THEN curr_obj:=0
   StringF(s,'[\z\d[4]/\z\d[4]] =>',curr_obj,abkmem.ilosc-1)
   settext(gh,nmrtext,s)
   setcycle(gh,cyccols,abkmem.d[curr_obj])
ELSE
   settext(gh,nmrtext,'NONE')
ENDIF
ENDPROC

/*endfold*/

/* informacje o bobie "OBJINFO PROCEDURE" */
PROC objinfo()
DEF s[512]:STRING
IF abkmem.ilosc<>TRUE
   StringF(s,'How much objects: \d\n\n' +
       'Numer object: \d\n' +
       'Width: \d Height: \d\n' +
       'Depth: \d Type: \s',
     abkmem.ilosc,curr_obj,abkmem.w[curr_obj]*16,
     abkmem.h[curr_obj],abkmem.d[curr_obj],abkmem.type)
   mRequest(0,s,'OK')
ENDIF
ENDPROC

/*endfold*/

/* wczytaj rys. IFF "LOADIFF PROCEDURE" */
PROC loadiff()
DEF x[1024]:STRING,y[512]:STRING,z
IF iffmem THEN mIlbmDispose(iffmem) ; iffmem:=0
settext(gh,ifftext,'Choose picture IFF!')
iff_filename:=asl_file()
IF iff_filename[]=0 ; ifferr(2) ; RETURN 0 ; ENDIF
StringF(x,'(\s) Loading...',iff_filename) ; bifferr(x)
IF checkiff(iff_filename)=0 ; ifferr(0) ; RETURN 0 ; ENDIF
iffmem:=mIlbmLoad(iff_filename)
IF iffmem=0 ; ifferr(1) ; RETURN 0 ; ENDIF
IF iffmem.depth>8
     bifferr('Sorry, but don\at read this file!')
     mIlbmDispose(iffmem); iffmem:=0
ENDIF
z:=StrLen(iff_filename)-30
IF z<0 THEN z:=0
MidStr(y,iff_filename,z,30)
StringF(x,'(\s) (\dx\dx\d) Loaded!',y,iffmem.width,iffmem.height,iffmem.colors)
bifferr(x)
setcycle(gh,cyccols,iffmem.depth)
curr_obj:=0;
ENDPROC

/*endfold*/

/* sprawdzenie czy plik jest IFF'em "CHECKIFF PROCEDURE" */
PROC checkiff(file)
DEF fh,tmp,ret=0
tmp:=New(100)
fh:=Open(file,OLDFILE)
Seek(fh,8,0)
Read(fh,tmp,8)
IF StrCmp(tmp,'ILBMBMHD',8) THEN ret:=TRUE
Dispose(tmp)
Close(fh)
ENDPROC ret

/*endfold*/

/* wyciecie kawalka jako bob "GRABIFF PROCEDURE" */
PROC grabiff()
DEF s:PTR TO screen,w:PTR TO window,x,y,mx,my
DEF t_x,t_y,t_mx,t_my,bm:PTR TO bitmap,a,tyk=0
IF iffmem
   s:=OpenScreenTagList(0,
         [SA_WIDTH,  iffmem.width,
          SA_HEIGHT, iffmem.height,
          SA_DEPTH,  iffmem.depth,
          SA_DISPLAYID,  iffmem.viewmode,
          SA_AUTOSCROLL, TRUE,
          SA_TYPE, SCREENQUIET,0])
   w:=OpenW(0,1,iffmem.width-1,iffmem.height-1,0,WFLG_RMBTRAP+WFLG_BORDERLESS,NIL,s,$F,0);
   mIlbmGetPalette(iffmem,s.viewport)
   mIlbmShow(iffmem,s.bitmap)
   SetDrMd(w.rport,RP_JAM1+RP_COMPLEMENT);
   REPEAT
     x:=w.mousex; y:=w.mousey
     Line(0,y,iffmem.width-1,y)
     Line(x,0,x,iffmem.height-1)
     Delay(2)
     Line(0,y,iffmem.width-1,y)
     Line(x,0,x,iffmem.height-1)
     WHILE Mouse()=1
       mx:=w.mousex; my:=w.mousey; tyk:=1;
       Line(x,y,mx,y)
       Line(x,y,x,my)
       Line(mx,my,x,my)
       Line(mx,my,mx,y)
       Delay(2)
       Line(x,y,mx,y)
       Line(x,y,x,my)
       Line(mx,my,x,my)
       Line(mx,my,mx,y)
       IF x>mx ; t_mx:=x ; t_x:=mx ; ELSE ; t_mx:=mx ; t_x:=x ; ENDIF
       IF y>my ; t_my:=y ; t_y:=my ; ELSE ; t_my:=my ; t_y:=y ; ENDIF
     ENDWHILE
   UNTIL Mouse()=2
           -> nawet x lub y moze byc wieksze od mx czy my,
           -> zawsze grabnie, dzieki zmiennym t_mx,t_my...

       abk_curr.w:=((t_mx-t_x)+16)/16 ; abk_curr.h:=(t_my-t_y);
       abk_curr.d:=s.rastport.bitmap.depth
       rrrsize:=RASSIZE(abk_curr.w*16,abk_curr.h)*abk_curr.d

    IF (tyk)=1
     IF (rrrsize)<BUFORTOOBJECT
      IF (rrrsize)>3
        bm:=new_BitMap(abk_curr.d,abk_curr.w*16,abk_curr.h)
        BltBitMap(s.bitmap,t_x,t_y,bm,0,0,abk_curr.w*16,abk_curr.h,$C0,-1,0)
        FOR a:=0 TO abk_curr.d-1
          CopyMemQuick(bm.planes[a],chipdata+(RASSIZE(abk_curr.w*16,abk_curr.h)*a),RASSIZE(abk_curr.w*16,abk_curr.h))
        ENDFOR
        free_BitMap(bm,abk_curr.d,abk_curr.w*16,abk_curr.h)
        bifferr('temporary bob in memory!',1)
      ENDIF
     ELSE
       bifferr('Buffer is low!',1)
     ENDIF
    ENDIF

   CloseWindow(w)
   CloseScreen(s)
ELSE
   ifferr(2)
ENDIF
ENDPROC

/*endfold*/

/* nagranie abk pliku "SAVEABK PROCEDURE" */
PROC saveabk()
DEF fh,a,cols=1
bifferr('Choose name to Save abk...',1)
abk_filename:=asl_file()
IF abk_filename[]=0 ; ifferr(2,abktext) ; RETURN 0 ; ENDIF
IF abkmem.ilosc=TRUE THEN RETURN 0
bifferr('Saving as AbkFile...',1)
fh:=Open(abk_filename,NEWFILE)
IF fh=0 THEN RETURN 0
   Write(fh,abkmem.type,4)
   Write(fh,[abkmem.ilosc]:INT,2)
FOR a:=0 TO abkmem.ilosc-1
   Write(fh,[abkmem.w[a]]:INT,2)
   Write(fh,[abkmem.h[a]]:INT,2)
   Write(fh,[abkmem.d[a]]:INT,2)
   Write(fh,[abkmem.hx[a]]:INT,2)
   Write(fh,[abkmem.hy[a]]:INT,2)
   Write(fh,abkmem.image[a],RASSIZE(abkmem.w[a]*16,abkmem.h[a])*abkmem.d[a])
ENDFOR
FOR a:=1 TO abkmem.d[curr_obj] DO cols:=cols*2
IF cols<32 THEN cols:=32
Write(fh,abkmem.paleta,cols * 2)
Close(fh)
bifferr('Done!',1)
ENDPROC

/*endfold*/

/* wczytanie abk pliku "LOADABK PROCEDURE" */
PROC loadabk()
DEF fh,data,a,s[512]:STRING,w,h,d,wz[512]:STRING
bifferr('Choose abk file!',1)
abk_filename:=asl_file()
IF abk_filename[]=0 ; ifferr(2,abktext) ; RETURN 0 ; ENDIF
IF checkabk(abk_filename)=0 ; ifferr(3,abktext) ; RETURN 0 ; ENDIF
IF abkmem.ilosc<>TRUE THEN freeabk(abkmem,TRUE)
fh:=Open(abk_filename,OLDFILE)
IF fh=0 ; Dispose(abkmem) ; abkmem:=0 ; ifferr(1) ; RETURN 0 ; ENDIF
bifferr('Loading...',1)
data:=New(100); Read(fh,data,4) ; strtomem(abkmem.type,data)
     Read(fh,data,2) ; abkmem.ilosc:=Int(data)
FOR a:=0 TO abkmem.ilosc-1
   Read(fh,data,2) ; abkmem.w[a]:=Int(data); w:=Int(data)
   Read(fh,data,2) ; abkmem.h[a]:=Int(data); h:=Int(data)
   Read(fh,data,2) ; abkmem.d[a]:=Int(data); d:=Int(data)
   Read(fh,data,2) ; abkmem.hx[a]:=Int(data);
   Read(fh,data,2) ; abkmem.hy[a]:=Int(data);
   abkmem.image[a]:=New((RASSIZE(w*16,h) * d)+100)
   Read(fh,abkmem.image[a],RASSIZE(w*16,h)*d)

   IF abkmem.ilosc<100
     StringF(s,'OBJECT \d: (\dx\dx\d) loaded!',a,w*16,h,d);
     bifferr(s,1)
     Delay(2)
   ENDIF
ENDFOR
Dispose(data)
Read(fh,abkmem.paleta,512)
Close(fh)
StringF(s,'Loaded \d objects!',abkmem.ilosc)
bifferr(s,1)
StringF(wz,'[\z\d[4]/\z\d[4]] <=',curr_obj,abkmem.ilosc-1)
settext(gh,nmrtext,wz)
IF StrCmp(abkmem.type,'AmSp',4) THEN setcycle(gh,cyctext,0) ELSE setcycle(gh,cyctext,1)
ENDPROC

/*endfold*/

/* sprawdzenie czy plik to abk "CHECKABK PROCEDURE" */
PROC checkabk(file)
DEF fh,rd,ret=0
rd:=New(10)
fh:=Open(file,OLDFILE)
Read(fh,rd,4)
IF StrCmp(rd,'AmSp',4) THEN ret:=TRUE
IF StrCmp(rd,'AmIc',4) THEN ret:=TRUE
Close(fh)
Dispose(rd)
ENDPROC ret

/*endfold*/

/* wyczyszczenie z pamieci abk'u "FREEABK PROCEDURE" */
PROC freeabk(abkmem:PTR TO abk,x=0)
DEF a
FOR a:=0 TO abkmem.ilosc-1
Dispose(abkmem.image[a])
abkmem.w[a]:=0; abkmem.h[a]:=0;
ENDFOR
IF x=TRUE THEN RETURN 0
Dispose(abkmem.image) ; Dispose(abkmem.d)
Dispose(abkmem.h) ; Dispose(abkmem.w)
Dispose(abkmem.hx) ; Dispose(abkmem.hy)
Dispose(abkmem.type) ; Dispose(abkmem.paleta)
Dispose(abkmem) ; abkmem:=0;
ENDPROC

/*endfold*/

/* komunikaty w panelu AmSp i ILBM "IFFERR/BIFFERR PROCEDURES" */
PROC ifferr(nr,type=0)
DEF text:PTR TO LONG
text:=['No a IFF file!','File read error!','File not found!','No ABK file!',0]
IF type=0
StringF(iff_textinfo,text[nr])
settext(gh,ifftext,iff_textinfo)
ELSE
StringF(abk_textinfo,text[nr])
settext(gh,abktext,abk_textinfo)
ENDIF
ENDPROC

PROC bifferr(text,type=0)
IF type=0
   StringF(iff_textinfo,text)
   settext(gh,ifftext,iff_textinfo)
ELSE
   StringF(abk_textinfo,text)
   settext(gh,abktext,abk_textinfo)
ENDIF
ENDPROC

/*endfold*/

/* standardowy requester "MREQUEST PROCEDURE" */
PROC mRequest(title,text,gads)
DEF answer
answer:=EasyRequestArgs(NIL,[SIZEOF easystruct, 0,
       title,text,gads]:easystruct,
       NIL,NIL)
ENDPROC answer

/*endfold*/

/* alokacja/dealokacja bitmapow "FREE/NEW_BITMAP" */
PROC free_BitMap(bitmap:PTR TO bitmap, depth, width, height)
  DEF ktr
  IF bitmap
    FOR ktr:=0 TO depth-1
      IF bitmap.planes[ktr] THEN FreeRaster(bitmap.planes[ktr], width, height)
    ENDFOR
    Dispose(bitmap)
  ENDIF
ENDPROC

PROC new_BitMap(depth, width, height) HANDLE
  DEF ktr, bitmap=NIL:PTR TO bitmap
  bitmap:=New(SIZEOF bitmap)
  InitBitMap(bitmap, depth, width, height)

  FOR ktr:=0 TO depth-1
    bitmap.planes[ktr]:=AllocRaster(width, height)
    BltClear(bitmap.planes[ktr], RASSIZE(width, height), 1)
  ENDFOR
EXCEPT
  free_BitMap(bitmap, depth, width, height)
  ReThrow()
ENDPROC bitmap

/*endfold*/
/*EE folds
-1
15 11 17 13 19 11 21 56 23 21 25 23 27 35 29 16 31 8 33 13 35 18 37 16 39 17 41 30 43 13 45 6 47 14 49 14 51 14 53 24 55 12 57 68 59 27 61 38 63 12 65 15 67 23 69 8 71 25 
EE folds*/
