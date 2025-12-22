OPT MODULE
OPT PREPROCESS

/*
** THIS PRODUCT IS FREEWARE!
** AMSP4E v1.3 (30-12-98)
** AMSP4E v1.4 (25-01-99)
** AMSP4E v2.0  (27-04-99)
** AMSP4E v2.01 (30-05-99)
*/

MODULE	'intuition/intuition',
	'intuition/screens',
	'graphics/gfx',
	'graphics/rastport',
	'graphics/clip',
	'exec/memory'

EXPORT SET
	IB_WIDTH,   -> (WIDTH) Szerokosc objektu.
	IB_HEIGHT,  -> (HEIGHT) Dlugosc objektu.
	IB_DEPTH,   -> (DEPTH) Ilosc planow w palecie (na koncu danych).
	IB_COLOURS, -> (COLORS) Ilosc kolorow w objektcie.
	IB_FACE,    -> (IMAGES) Twarz objektu.
	IB_OBJLEN,  -> (RASSIZE) Dlugosc w bajtach twarzy.
	IB_CX,	     -> (X-IMAGE) Wsp. X objektu.
	IB_CY,	     -> (Y-IMAGE) Wsp. Y objektu.
	IB_CN,	     -> (N-IMAGE) Numer twarzy objekta.
	IB_CMAXOBJS,-> (LOADEDBOBS) Ilosc objektow.
	IB_CDEPTH,  -> (DEPTHBOBS) Ilosc planow dla objekta.
	IB_CCOLOURS,-> (MAX-COLORS) Ilosc kolorow w palecie (na koncu danych).
	IB_HOTX,    -> (HOTSPOT X) Cieply punkt (x).
	IB_HOTY     -> (HOTSPOT Y) Cieply punkt (y).

OBJECT ib			-> struktura wielu objektow.
	amount:INT		-> ilosc objektow (bobow/ikon) w pliku.
	offset:PTR TO LONG	-> adresy roznych objektow w pliku.
	palette:PTR TO INT	-> paleta kolorow
	depth:INT		-> maxymalna ilosc planow w wszystkich objektach.
	colours:INT		-> ilosc kolorow na palecie
	data:PTR TO LONG	-> wczytane dane.
	mmib:PTR TO mib		-> mib struktura.
	buffered_bob:PTR TO LONG -> bufforowanie bobow.
	buffered_msk:PTR TO LONG -> bufforowanie mask.
ENDOBJECT

OBJECT mib
	x:INT			-> (X) wsp. X
	y:INT			-> (Y) wsp. Y
	bx:INT			-> (BX) byly wsp. X
	by:INT			-> (BY) byly wsp. Y
	backdrop:PTR TO bitmap	-> (SAVEBACK) jak wyglada obraz pod bobem.
	nr:INT			-> (IMGE-NMR) jaki wyswietlony jest objekt (z indeksu rysunkow)
	bnr:INT			-> (IMGE-BNR) byly IMGE-NMR..
ENDOBJECT

DEF maxofbobs,update

EXPORT PROC mStBuf(n) IS maxofbobs:=n		-> Set buffer to command mIB.
EXPORT PROC mIBUpdateOn() IS update:=0;		-> Auto Update On to mIB.
EXPORT PROC mIBUpdateOff() IS update:=-1;	-> Auto Update Off to mIB.

/*---------
	(LOAD AND SETTING BOBS)
   Wczytuje plik z objektami (AmSp,AmIc) do pamieci.
   uwaga! Moze zaladowac nawet w trybie AGA co w zwyklym amosie niema.
          Ale konieczny jest nowy edytor objektow.
   · ib:=mLoadIB(filename,screen)
   jezeli 'ib' bedzie 0 tzn. ze operacja ladowania niepowiodla sie!
*/

EXPORT PROC mLoadIB(filename,s=0)
DEF fh,read,len,ibds
IF (len:=FileLength(filename))=-1 THEN RETURN 0;
IF (fh:=Open(filename,OLDFILE))=0 THEN RETURN 0;
read:=New(len);
IF Read(fh,read,len)<len ; Dispose(read) ; RETURN 0 ; ENDIF
Close(fh);
ibds:=mDecodeIB(read,len,s);
ENDPROC ibds

/* -decodebobs (initializuje wczytane obrazki przez INCBIN (SETTING BOBS) -*/

EXPORT PROC mDecodeIB(data,length,s=0)
DEF ibds:PTR TO ib,dlugosc=0,a,z=0,mmib:PTR TO mib,tmp_d=0
DEF offset:PTR TO LONG

ibds:=New(SIZEOF ib);							-> nowa struktura (ptr)
IF maxofbobs=0 THEN maxofbobs:=64				-> max bufor dla bobow.
mmib:=New((SIZEOF mib*maxofbobs)+10);

ibds.amount:=Int(data+4);					-> ilosc bobkow w pamieci.
ibds.data:=data+6						-> przestrojenie na czesc glowna danych.

offset:=New((ibds.amount*4)+100)
ibds.offset:=offset						-> nowy offset (poszczegolne objekty gdzie sa?)

->>>>>> Gdzie jakie objs.
FOR a:=0 TO ibds.amount
dlugosc:=dlugosc+z;
ibds.offset[a]:=dlugosc
z:=RASSIZE(Int(ibds.data+0+dlugosc)*16,Int(ibds.data+2+dlugosc))*(tmp_d:=Int(ibds.data+4+dlugosc))+10
IF ibds.amount<>a THEN IF tmp_d>ibds.depth ; ibds.depth:=tmp_d ; ENDIF
ENDFOR
ibds.colours:=d2c(ibds.depth)					-> depth ilosc planow

->>>>>> Paleta kolorow
ibds.palette:=New(ibds.colours*2)
CopyMemQuick(ibds.data+dlugosc,ibds.palette,ibds.colours*2)

	ibds.mmib:=mmib;						-> mmib do ibds.
->>>>>> Kolejne inicjalizacje tym razem wszystko -1 (-1 oznacza ze nic niema).
FOR a:=0 TO maxofbobs
	ibds.mmib[a].x:=-1;
	ibds.mmib[a].y:=-1;
	ibds.mmib[a].bx:=-1;
	ibds.mmib[a].by:=-1;
	ibds.mmib[a].backdrop:=-2;
	ibds.mmib[a].nr:=-1;
	ibds.mmib[a].bnr:=-1;
ENDFOR
->>>>>>> Inicjacja bufforowania
	ibds.buffered_bob:=New((ibds.amount)*4)
	ibds.buffered_msk:=New((ibds.amount)*4)
ENDPROC ibds

/* ------------- czysci i dezynfekuje! (CLEAN MEMORY) */

EXPORT PROC mEraseIB(ibds:PTR TO ib)
DEF a
FOR a:=0 TO maxofbobs
	IF ibds.mmib[a].nr<>-1
		IF ((ibds.mmib[a].backdrop<>-2) OR (ibds.mmib[a].backdrop<>0))
			free_BitMap(ibds.mmib[a].backdrop,
				mGetIBInfo(ibds,ibds.mmib[a].nr,IB_DEPTH),
				mGetIBInfo(ibds,ibds.mmib[a].nr,IB_WIDTH),
				mGetIBInfo(ibds,ibds.mmib[a].nr,IB_HEIGHT))	-> wyczyszczenie SAVEBACK'u.
		ENDIF
		Dispose(ibds.mmib[a])			-> wyczysczenie calej struktury.
	ENDIF
ENDFOR
FOR a:=0 TO ibds.amount-1
	IF ibds.buffered_bob[a]<>-2 THEN free_BitMap(ibds.buffered_bob[a],mGetIBInfo(ibds,a,IB_DEPTH),mGetIBInfo(ibds,a,IB_WIDTH),mGetIBInfo(ibds,a,IB_HEIGHT))
	IF ibds.buffered_msk[a]<>-2 THEN Dispose(ibds.buffered_msk[a])
ENDFOR
IF ibds.buffered_bob THEN Dispose(ibds.buffered_bob)
IF ibds.buffered_msk THEN Dispose(ibds.buffered_msk)
IF ibds.offset THEN Dispose(ibds.offset)
IF ibds.palette THEN Dispose(ibds.palette)
IF ibds.data THEN Dispose(ibds.data)
IF ibds THEN Dispose(ibds)						-> wyczysczenie calej str.
ENDPROC

/* -------------
	(alike to amos command PASTE ICON with mask)
     Instrukcja pokazuje objekt z maska.
     · mPasteIB(rport,ibds,x,y,nr)
	rp - pointer to rport
	ibds - pointer to bank
	x,y - coordinates.
	nr - number of image.
*/

EXPORT PROC mPasteIB(rport,ibds:PTR TO ib,x,y,nr)
DEF w,h,d,i,r,f,bm:PTR TO bitmap,mask:PTR TO LONG,hx,hy
IF nr>(ibds.amount-1) THEN nr:=(ibds.amount-1)
w:=mGetIBInfo(ibds,nr,IB_WIDTH)
h:=mGetIBInfo(ibds,nr,IB_HEIGHT)
d:=mGetIBInfo(ibds,nr,IB_DEPTH)
f:=mGetIBInfo(ibds,nr,IB_FACE)
hx:=mGetIBInfo(ibds,nr,IB_HOTX)
hy:=mGetIBInfo(ibds,nr,IB_HOTY)
r:=RASSIZE(w,h)
IF ibds.buffered_bob[nr]=0 THEN ibds.buffered_bob[nr]:=new_BitMap(d,w,h)	->\_ Buforowanie
bm:=ibds.buffered_bob[nr];							->/  Objektu

	FOR i:=0 TO d-1
		CopyMemQuick(f+(i*r),bm.planes[i],r)
	ENDFOR

IF ibds.buffered_msk[nr]=0 THEN ibds.buffered_msk[nr]:=bltmask(bm,r)		->\_ Buforowanie
mask:=ibds.buffered_msk[nr]							->/  Maski
BltMaskBitMapRastPort(bm,0,0,rport,x-hx,y-hy,w,h,$E0,mask)
ENDPROC

/* -------------
	(CHANGE PALETTE)
     Instrukcja ktora ma na celu zmienic palete kolorow odpowiednio
     dla wczytanych objektow, cos podobnego do (Get Bob Palette).
     · mGetIBPalette(ibds,vport)
     ibds - pointer to bank.
     vport - pointer to viewport.
*/

EXPORT PROC mGetIBPalette(ibds:PTR TO ib,vport)
LoadRGB4(vport,ibds.palette,ibds.colours)
ENDPROC

/* -------------
	(CLEAR ALL BOBS)
     Instrukcja wyczyszcza z okna (nie z pamieci) objekty.
     · mClearIB(rp,ibds)
	rp - pointer to rport
	ibds - pointer to bank
*/

EXPORT PROC mClearIB(rport,ibds:PTR TO ib)
DEF i,hx,hy
	FOR i:=0 TO maxofbobs
		IF ibds.mmib[i].nr<>-1
			hx:=mGetIBInfo(ibds,ibds.mmib[i].nr,IB_HOTX)
			hy:=mGetIBInfo(ibds,ibds.mmib[i].nr,IB_HOTY)
			BltBitMapRastPort(ibds.mmib[i].backdrop,0,0,rport, 
							ibds.mmib[i].x-hx , ibds.mmib[i].y-hy ,
							mGetIBInfo(ibds,ibds.mmib[i].nr,IB_WIDTH),mGetIBInfo(ibds,ibds.mmib[i].nr,IB_HEIGHT),$C0);
		ENDIF
	ENDFOR
ENDPROC

/* ------------
	(DRAW ALL BOBS)
     Instrukcja wyczyszcza z okna (nie z pamieci) objekty.
     · mDrawIB(rp,ibds)
	rp - pointer to rport
	ibds - pointer to bank.
*/

EXPORT PROC mDrawIB(rport,ibds:PTR TO ib)
DEF i
	FOR i:=0 TO maxofbobs
		IF ibds.mmib[i].nr<>-1
			mPasteIB(rport,ibds,ibds.mmib[i].x,ibds.mmib[i].y,ibds.mmib[i].nr)
		ENDIF
	ENDFOR
ENDPROC

/* -------------
	(INFORMATIONS ABOUT OBJECT)
     Informacje o bobie    
     · info:=mGetIBInfo(ibds,nr,flag)
     ibds - pointer to bank
     nr - numer objektu
     flag - flagi AMB_xxxx
     RETURN - informations.
*/

EXPORT PROC mGetIBInfo(ibds:PTR TO ib,nr,flag)
	SELECT flag
		CASE IB_WIDTH;
			RETURN Int(ibds.data+0+ibds.offset[nr])*16 ->(*16 musi byc)
		CASE IB_HEIGHT;
			RETURN Int(ibds.data+2+ibds.offset[nr]);
		CASE IB_DEPTH;
			RETURN Int(ibds.data+4+ibds.offset[nr]);
		CASE IB_HOTX;
			RETURN Int(ibds.data+6+ibds.offset[nr]);
		CASE IB_HOTY;
			RETURN Int(ibds.data+8+ibds.offset[nr]);
		CASE IB_COLOURS;
			RETURN d2c(Int(ibds.data+4+ibds.offset[nr]));
		CASE IB_FACE;
			RETURN ibds.data+10+ibds.offset[nr];
		CASE IB_OBJLEN;
			RETURN RASSIZE(Int(ibds.data+0+ibds.offset[nr])*16 , Int(ibds.data+2+ibds.offset[nr])) * Int(ibds.data+4+ibds.offset[nr]);
		CASE IB_CX;
			RETURN ibds.mmib[nr].x;
		CASE IB_CY;
			RETURN ibds.mmib[nr].y;
		CASE IB_CN;
			RETURN ibds.mmib[nr].nr;
		CASE IB_CMAXOBJS;
			RETURN ibds.amount
		CASE IB_CDEPTH;
			RETURN ibds.depth
		CASE IB_CCOLOURS;
			RETURN ibds.colours
		DEFAULT;
			RETURN 0;
	ENDSELECT
ENDPROC

/* ----------
	(Display Icon without Mask)
       Wyswietla na szybko obrazek bez maski.
       · mPasteQuickIB(ibds,x,y,nr)
	rp - pointer to rport
	ibds - pointer to bank
	x,y - wspolrzedne
	nr - nr obj.
*/

EXPORT PROC mPasteQuickIB(rport,ibds:PTR TO ib,x,y,nr)
DEF truedatas,images:image,d,w,h,c,hx,hy
IF nr>(ibds.amount-1) THEN nr:=(ibds.amount-1)
truedatas:=_MEMF(mGetIBInfo(ibds,nr,IB_FACE),MEMF_CHIP,mGetIBInfo(ibds,nr,IB_OBJLEN));
hx:=mGetIBInfo(ibds,nr,IB_HOTX);
hy:=mGetIBInfo(ibds,nr,IB_HOTY);
w:=mGetIBInfo(ibds,nr,IB_WIDTH)
h:=mGetIBInfo(ibds,nr,IB_HEIGHT)
d:=mGetIBInfo(ibds,nr,IB_DEPTH)
c:=mGetIBInfo(ibds,nr,IB_COLOURS)-1
images:=[0,0,w,h,d,truedatas,c,0,NIL]:image
DrawImage(rport,images,x-hx,y-hy);
Dispose(truedatas);
ENDPROC -1

/* ----------
	(DISPLAY A BOB (alike to amos command))
       Wyswietla narescie normalnego boba.
       · mIB(rp,ibds,nr,x,y,img)
	rp - pointer to rport
	ibds - pointer to bank
	x,y - wspolrzedne
	nr - nr obj.
*/

EXPORT PROC mIB(rport:PTR TO rastport,ibds:PTR TO ib,nr,x,y,img,inwin=FALSE)
DEF w,h,d,f,hx,hy,ww,hh,layx=0,layy=0
IF img>(ibds.amount-1) THEN img:=(ibds.amount-1)
w:=mGetIBInfo(ibds,img,IB_WIDTH)
h:=mGetIBInfo(ibds,img,IB_HEIGHT)
d:=mGetIBInfo(ibds,img,IB_DEPTH)
f:=mGetIBInfo(ibds,img,IB_FACE)
hx:=mGetIBInfo(ibds,img,IB_HOTX)
hy:=mGetIBInfo(ibds,img,IB_HOTY)
ibds.mmib[nr].bnr:=ibds.mmib[nr].nr;
ibds.mmib[nr].bx:=ibds.mmib[nr].x
ibds.mmib[nr].by:=ibds.mmib[nr].y
IF ibds.mmib[nr].bx<>-1
		IF update=0
			ww:=mGetIBInfo(ibds,ibds.mmib[nr].bnr,IB_WIDTH)
			hh:=mGetIBInfo(ibds,ibds.mmib[nr].bnr,IB_HEIGHT)
			BltBitMapRastPort(ibds.mmib[nr].backdrop,0,0,rport,ibds.mmib[nr].bx-hx,ibds.mmib[nr].by-hy,ww,hh,$C0);
		ENDIF
ENDIF
ibds.mmib[nr].x:=x;
ibds.mmib[nr].y:=y;
ibds.mmib[nr].nr:=img;

-> Zrobic SAVEBACK
	IF ibds.mmib[nr].bnr<>img
		IF ibds.mmib[nr].backdrop<>-2 THEN free_BitMap(ibds.mmib[nr].backdrop,
				mGetIBInfo(ibds,ibds.mmib[nr].bnr,IB_DEPTH),
				mGetIBInfo(ibds,ibds.mmib[nr].bnr,IB_WIDTH),
				mGetIBInfo(ibds,ibds.mmib[nr].bnr,IB_HEIGHT));
			ibds.mmib[nr].backdrop:=new_BitMap(d,w,h)
	ENDIF
	IF (inwin=TRUE)					-> Bo jak tak niezrobimy to jakies bykasy wychodza
			layx:=rport.layer.minx			
			layy:=rport.layer.miny
	ENDIF		

	BltBitMap(rport.bitmap,layx+(x-hx),layy+(y-hy),ibds.mmib[nr].backdrop,0,0,w,h,$C0,-1,NIL)
-> Teraz tylko bob na okno
	IF update=0 THEN mPasteIB(rport,ibds,x,y,img)
ENDPROC

/* ----------
	(HIDE A BOB)
       Skrywanie boba.
       · mIBOff(ibds,nr)
	ibds - struktura ib
	x,y - wspolrzedne
	nr - nr obj..
*/

EXPORT PROC mIBOff(rport,ibds:PTR TO ib,nr)
DEF hx,hy
	IF ibds.mmib[nr].nr<>-1
		hx:=mGetIBInfo(ibds,ibds.mmib[nr].nr,IB_HOTX)
		hy:=mGetIBInfo(ibds,ibds.mmib[nr].nr,IB_HOTY)
		BltBitMapRastPort(ibds.mmib[nr].backdrop,0,0, rport, 
					ibds.mmib[nr].x-hx , ibds.mmib[nr].y-hy ,
					mGetIBInfo(ibds,ibds.mmib[nr].nr,IB_WIDTH),mGetIBInfo(ibds,ibds.mmib[nr].nr,IB_HEIGHT),$C0);
		free_BitMap(ibds.mmib[nr].backdrop,mGetIBInfo(ibds,ibds.mmib[nr].nr,IB_DEPTH),mGetIBInfo(ibds,ibds.mmib[nr].nr,IB_WIDTH),mGetIBInfo(ibds,ibds.mmib[nr].nr,IB_HEIGHT))
		ibds.mmib[nr].x:=-1;
		ibds.mmib[nr].y:=-1;
		ibds.mmib[nr].bx:=-1;
		ibds.mmib[nr].by:=-1;
		ibds.mmib[nr].backdrop:=-2;
		ibds.mmib[nr].nr:=-1;
		ibds.mmib[nr].bnr:=-1;
	ENDIF
ENDPROC

/***************************** (No export!!!)
 ***************************** (Te procedury nie podlegaja programowi (tylko dla AmosBobs.m))
 *****************************
 *****************************/

PROC d2c(a)
DEF b=1,i
FOR i:=1 TO a DO b:=b*2
ENDPROC b

PROC _MEMF(data,type,size)
  DEF mem
  mem:=NewM(size, type)
  CopyMemQuick(data, mem, size)
ENDPROC mem

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

PROC bltmask(bm:PTR TO bitmap,rassize)
DEF data:PTR TO CHAR,a,b
data:=NewM(rassize,2)
FOR a:=0 TO rassize-1 DO data[a]:=0;
FOR a:=0 TO rassize-1
	FOR b:=0 TO bm.depth-1
		data[a]:=Or(data[a],bm.planes[b][a])
	ENDFOR
ENDFOR
ENDPROC data
