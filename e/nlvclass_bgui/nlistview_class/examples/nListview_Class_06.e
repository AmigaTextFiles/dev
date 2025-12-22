OPT MODULE
OPT PREPROCESS,REG=5

/*
          File: nListView_Class.e
   Description: Klasa ListView umoûliwiajâca scrollowanie w poziomie
     Copyright: Copyright (c) 1996 Piotr Gapiïski (kolo8@ely.pg.gda.pl)
         All Rights Reserved.

         Class: nListView (private)
    Superclass: BGUI_LISTVIEW_GADGET (public)


  v0.1 (21.09.96)
    - brak moûliwoôci podîâczenia zewnëtrznego horiz scrollera!
    - w zasadzie dziaîa (przynajmniej dziaîa scrollowanie w poziomie)
    - wielkoôê (wysokoôê) scrollera jest niestety STAÎA (13 pixeli)
    - wprowadzone notyfikacje (wewnëtrzne)

  v0.2 (22.09.96)
    - uzupeînione o moûliwoôê definicji wîasnego horiz scrollera
      LISTV_HORIZOBJECT /*I...*/
    - custom display hook jest wywoîywany w konwencji
      A0 - struktura hook (displayhook)
      A1 - wskaúnik na strukturë lvRender
      A2 - obiekt (listview - NIE nlistview!!!! ani BGUI listview!!!!)
      sposób uzyskania offsetu w pixelach:
      DEF lvr:PTR TO lvrender,data:PTR TO LONG
      DEF offset,chars
      MOVE.L  A2,obj
      cl:=OCLASS(obj)
      data:=INST_DATA(cl,obj)
      MOVE.L  data,A0
      MOVE.L  (A0),offset              ->- offset w PIXELACH
      MOVE.L  A1,lvr
      chars:=offset/lvr.rport.txwidth  ->- offset w ZNAKACH
    - horiz scroller NIE wskazuje dîugoôci linii

  v0.3 (23.09.96)
    - poprawiona obsîuga atrybutu LISTV_HORIZOBJECT - obiekt przekazywany
      nie jest juû wîâczany do grupy razem z listviewem - teraz jest on tylko
      podîaczony do listviewa przez system notyfikacji (dzieki czemu bie ma
      problemu z wielokrotnym zwalnianiem tego samego obiektu co powodowaîo
      maîe GURU :)
    - atrybut LISTV_HORIZOFFSET jest teraz prywatny
    - sprawne w 99% (1% niepewnoôci bo nie byîo testowane zachowanie sië
      klasy w przypadku zdefiniowanego przez uûytkownika displayhook'a)

  v0.4 (23.09.96)
    - zmieniony wewnëtrzny displayhook (rendering dokonywany wewnëtrznie ale nie
      przez BGUI) - wzorowane na hscroll.c
    - dodany custom disable (listview)

  v0.5 (23.09.96)
    zmiany dotyczâ w wiëkszoôci custom display hook'a
    - do rysowania textu wykorzystane BGUI_InfoText()
    - rendering przeprowadzony jest teraz na ukrytym rastporcie, potem nastëpuje
      kopiowane do rastportu listviewa (dzieki temu wszystkie infosequences bëdâ
      wyôwietlane poprawnie)
    - wprowadzone CUSTOMDISABLE (ghosted pattern)
    - atrybut LISTV_HORIZOBJECT jest teraz (I.G.)
    - nowe argumenty dla atrybutu LISTV_HORIZOFFSET
      LISTV_HORIZOFFSET_RIGHT
      LISTV_HORIZOFFSET_LEFT
      LISTV_HORIZOFFSET_PAGE_LEFT
      LISTV_HORIZOFFSET_PAGE_RIGHT
      LISTV_HORIZOFFSET_FIRST
      LISTV_HORIZOFFSET_LAST
    - atrybut LISTV_HORIZSTEPS jest teraz (I.G.)
    - LISTV_HORIZSTEPS nie moûe byê wiëksze niz MAX_HORIZ_OFFSET znaków
      (aktualnie, MAX_HORIZ_OFFSET = 200)
    - LISTV_DISPLAYHOOK nie byî testowany ale zostaî tak skonstuowany,ûe
      uûytkownik nie musi sië troszczyê o scrolowanie danych; jeôli
      hook func zwróci wartoôê <>NIL to bëdzie to znaczyîo, ûe jednak
      sam zatroszczyî sie o scrolowanie

  v0.6 (26.09.96)
    optymalizacja display hook'a
    - fragment dotyczâcy detekcji kodów specjalnych przeniesiony z
      listview_DisplayFunc do listview_Set co zwiësza szybkoôê renderingu textu
    - umoûliwiona obsîuga listview'a MULTICOLUMN
    - nowy atrybut
      LISTV_SCROLLCOLUMN,nr  (I...)
    - BRAK WSPÓÎPRACY Z TITLEHOOK'iem




  NOWE METODY
    NONE
  NOWE ATRYBUTY
   LISTV_HORIZOFFSET  (ISGN)  v0.1
     liczba znaków pominiëtych na poczâtku linii
      specjalne wartôci
      LISTV_HORIZOFFSET_RIGHT     - scroll o 1 znak w prawo
      LISTV_HORIZOFFSET_LEFT      - scroll o 1 znak w lewo
      LISTV_HORIZOFFSET_PAGE_LEFT - scroll o szerokoôê listviewa w lewo
      LISTV_HORIZOFFSET_PAGE_RIGHT- scroll o szerokoôê listviewa w prawo
      LISTV_HORIZOFFSET_FIRST     - scroll max w lewo
      LISTV_HORIZOFFSET_LAST      - scroll max w prawo
   LISTV_VERTOBJECT   (ISG.)  v0.1
     patrz BGUI_listview_class/LISTV_PROPOBJECT
   LISTV_HORIZSTEPS   (I.G.)  v0.1
     okreôla maksymalnâ dîugoôê linii
     standardowo ustawiane na MAX_HORIZ_OFFSET=200 znaków
   LISTV_HORIZOBJECT  (I.G.)  v0.2
     podobnie jak LISTV_VERTOBJECT ale dotyczy moûliwoôci podstawienia wîasnego
     obiektu jako horiz scrollera (gdy tag.data=NIL to listview bëdzie bez
     horiz scrollera
     standardowo dolâczany jest horiz scroller o wysokoôci HORIZ_SCROLLER_HEIGHT
     czyli 14 pixeli
   LISTV_SCROLLCOLUMN (I...)  v0.6
     okreôla którâ kolumnë moûna scrolowaê w poziomie w przypadku uûycia atrybutu
     LISTV_COLUMNS, standardowo scrolowanie dotyczy wzystkich kolumn

*/


MODULE 'bgui/bgui','bgui/bguic','bgui/bguim','bgui',
       'utility/tagitem','utility/hooks','utility',
       'intuition/intuition',
       'intuition/classusr','intuition/classes',
       'intuition/cghooks','intuition/gadgetclass',
       'intuition/screens',
       'graphics/displayinfo','graphics/modeid',
       'graphics/gfx','graphics/text','graphics/rastport',
       'graphics/gfxmacros',
       'exec/memory'
MODULE 'amigalib/boopsi','other/ecode','tools/installhook'



->- KLASA LISTVIEW ---

EXPORT CONST LISTV_HORIZOFFSET           = TAG_USER + $80000 + 1   /*ISGN*/
EXPORT CONST LISTV_HORIZOFFSET_RIGHT     = -1
EXPORT CONST LISTV_HORIZOFFSET_LEFT      = -2
EXPORT CONST LISTV_HORIZOFFSET_PAGE_LEFT = -3
EXPORT CONST LISTV_HORIZOFFSET_PAGE_RIGHT= -4
EXPORT CONST LISTV_HORIZOFFSET_FIRST     = -5
EXPORT CONST LISTV_HORIZOFFSET_LAST      = -6
EXPORT CONST LISTV_HORIZSTEPS            = TAG_USER + $80000 + 2   /*I.G.*/
EXPORT CONST LISTV_SCROLLCOLUMN          = TAG_USER + $80000 + 3   /*I...*/

CONST MAX_HORIZ_OFFSET = 200-1
CONST DEF_HORIZ_OFFSET = 80-1

OBJECT listview_Data PRIVATE
  offset             ->- offset w pixelach
  hoffset            ->- current offset
  ohoffset           ->- old offset
  maxoffset          ->- maximum offset
  udisphook:PTR TO hook
  urport:PTR TO rastport
  scol               ->- w przypadku listviewa MULTICOL - którâ kolumnë skrolujemy
ENDOBJECT

PROC listview_Get(cl:PTR TO iclass,obj:PTR TO object,msg:PTR TO opget)
  DEF data:PTR TO listview_Data,id,tmp

  data:=INST_DATA(cl,obj)
  tmp:=msg.storage
  id:=msg.attrid
  SELECT id
    CASE LISTV_HORIZOFFSET
      ^tmp:=data.ohoffset
    DEFAULT
      doSuperMethodA(cl,obj,msg)
  ENDSELECT
ENDPROC

PROC listview_Set(cl:PTR TO iclass,obj:PTR TO object,msg:PTR TO opupdate)
  DEF data:PTR TO listview_Data,tag:PTR TO tagitem,tmp
  DEF box:PTR TO ibox

  ->- w tej metodzie problemem jest okreôlenie rp.txwidth
  ->- rozwiâzaniem jest korzystanie z data.urport.txwidth bo data.urport jest
  ->- kopiâ rastportu listviewa

  doSuperMethodA(cl,obj,msg)
  data:=INST_DATA(cl,obj)
  tag:=FindTagItem(LISTV_HORIZOFFSET,msg.attrlist)

  IF tag<>NIL
    ->- zmieniono pozycje?
    IF data.hoffset<>tag.data
      ->- zapamiëtaj jâ
      data.hoffset:=tag.data
      ->- sprawdú czy nie przekazano specjalnych atrybutów...
      GetAttr(LISTV_VIEWBOUNDS,obj,{box})
      tmp:=data.hoffset
      SELECT tmp
      CASE LISTV_HORIZOFFSET_RIGHT
        data.hoffset:=Min(data.ohoffset+1,data.maxoffset)
      CASE LISTV_HORIZOFFSET_LEFT
        data.hoffset:=Max(0,data.ohoffset-1)
      CASE LISTV_HORIZOFFSET_PAGE_RIGHT
        data.hoffset:=Min(data.ohoffset+(box.width/data.urport.txwidth),data.maxoffset)
      CASE LISTV_HORIZOFFSET_PAGE_LEFT
        data.hoffset:=Max(0,data.ohoffset-(box.width/data.urport.txwidth))
      CASE LISTV_HORIZOFFSET_LAST
        data.hoffset:=data.maxoffset
      CASE LISTV_HORIZOFFSET_FIRST
        data.hoffset:=0
      DEFAULT
        data.hoffset:=Abs(data.hoffset)
      ENDSELECT
      ->- odrysuj zawartoôê tylko czëôci widocznych listviewwa wykorzystujâc
      ->- nowâ wartoôê offsetu
      doSuperMethodA(cl,obj,[LVM_REDRAW,msg.ginfo])
      ->- wyôlij sygnaî notyfikacji (wykorzystywane np. przez horiz sctoller'a)
      dispIdList_NotifyChange(obj,msg.ginfo,
        IF msg.methodid=OM_UPDATE THEN msg.flags ELSE 0,
        [LISTV_HORIZOFFSET,data.hoffset,TAG_END])
      data.ohoffset:=data.hoffset
    ENDIF
  ENDIF
ENDPROC

PROC listview_DisplayFunc()
  DEF lvr:PTR TO lvrender,rp:PTR TO rastport
  DEF ulvr:lvrender
  DEF pens:PTR TO INT,pen,l,t,r,b,rc=0
  DEF cl:PTR TO iclass,obj:PTR TO object,data:PTR TO listview_Data

  MOVE.L  A1,lvr
  MOVE.L  A2,obj
  ->- najpierw trzeba dostaê sie do danych wew. klasy...
  cl:=OCLASS(obj)
  data:=INST_DATA(cl,obj)

  ->- ustaw offset w pixelach
  data.offset:=data.hoffset*lvr.rport.txwidth

  ->- zbuduj dodatkowy rastport z bitmapâ (o ile nie istnieje)
  ->- byê moûe w przyszîoôci rastport do buforowania bëdzie udostëpniony
  IF data.urport=NIL
    data.urport:=BgUI_CreateRPortBitMap(lvr.rport,MAX_HORIZ_OFFSET*lvr.rport.txwidth,
                lvr.rport.txheight,lvr.rport.bitmap.depth)
  ENDIF

  ->- jeûeli istnieje display hook uûytkownika to po prostu wywoîaj go
  ->- ze zmienionym obiektem lvrender (podstawienie ukrytego rportu)
  IF data.udisphook
    CopyMem(lvr,ulvr,SIZEOF lvrender)
    ulvr.rport:=data.urport
    ulvr.bounds.minx:=0
    ulvr.bounds.miny:=0
    ulvr.bounds.maxx:=MAX_HORIZ_OFFSET*lvr.rport.txwidth
    ulvr.bounds.maxy:=lvr.rport.txheight
    rc:=CallHookPkt(data.udisphook,obj,ulvr)
  ELSE
    ->- zmienne pomocnicze...
    l:=lvr.bounds.minx
    t:=lvr.bounds.miny
    r:=lvr.bounds.maxx
    b:=lvr.bounds.maxy
    pens:=lvr.drawinfo.pens
    rp:=lvr.rport

    ->- okreôl tryb rysowania i kolory renderingu
    SetDrMd(data.urport,RP_JAM1)
    IF lvr.state=LVRS_SELECTED
      pen:=pens[FILLPEN]
    ELSEIF lvr.state=LVRS_NORMAL_DISABLED
      pen:=pens[BACKGROUNDPEN]
    ELSEIF lvr.state=LVRS_SELECTED_DISABLED
      pen:=pens[FILLPEN]
    ELSE
      pen:=pens[BACKGROUNDPEN]
    ENDIF

    ->- czy wîaônie tâ kolumnë mamy pzesówaê?
    IF (data.scol<>-1)AND(data.scol<>lvr.column)
      SetAPen(rp,pen)
      RectFill(rp,l,t,r,b)
      BgUI_InfoText(rp,lvr.entry,[l+1,t,r-l+1,b-t+1]:ibox,lvr.drawinfo)
      RETURN NIL
    ENDIF

    SetAPen(data.urport,pen)

    ->- wyczyôê ukryty rastport...
    RectFill(data.urport,0,0,r+data.offset,rp.txheight)

    ->- wyôwietl to co masz do wyôwietlenia (w ukrytym rastporcie)
    BgUI_InfoText(data.urport,lvr.entry,[0,0,r+(data.offset)-l+1,rp.txheight]:ibox,lvr.drawinfo)
  ENDIF
  IF rc=0
    ->- przenieô dane sprawiajâc wraûenie scrolowania...
    ClipBlit(data.urport,data.offset-1,0,rp,l,t,r-l+1,b-t+1,$C0)

    ->- jeûeli trzeba to wyôwietl pattern (ghosted)
    IF (lvr.state=LVRS_NORMAL_DISABLED)OR(lvr.state=LVRS_SELECTED_DISABLED)
      SetABPenDrMd(rp,pens[BLOCKPEN],0,RP_JAM1)
      SetAfPt(rp,[$1111,$4444]:INT,1)
      RectFill(rp,l,t,r,b)
      SetAfPt(rp,NIL,0)
    ENDIF
  ENDIF
  ->- zwracamy NIL co by BGUI myôlaîo ûe rendering zakoïczony
  RETURN NIL
ENDPROC

PROC listview_New(cl:PTR TO iclass,obj:PTR TO object,msg:PTR TO opset)
  DEF displayHook:PTR TO hook,
      tag:PTR TO tagitem,udisp:PTR TO hook,
      data:PTR TO listview_Data

  ->- biblioteka utility.library MUSI byê wczeôniej otwarta
  IF utilitybase=NIL THEN RETURN NIL
  ->- sprawdzamy czy uûytkownik zdefiniowaî wîasny DISPLAYHOOK
  tag:=FindTagItem(LISTV_DISPLAYHOOK,msg.attrlist)
  udisp:=IF tag=NIL THEN NIL ELSE tag.data

  ->- wprowadzamy wîasny display hook (umoûliwiajâcy scrolowanie w poziomie)
  NEW displayHook
  installhook(displayHook,{listview_DisplayFunc})

  ->- tworzymy obiekt
  ->- najpierw klasa po której dziedziczymy...
  IF (obj:=doSuperMethodA(cl,obj,
      [ OM_NEW,
      [ LISTV_DISPLAYHOOK,displayHook,
        TAG_MORE,msg.attrlist,
        TAG_DONE ],
      NIL]))=NIL THEN RETURN NIL

  ->- zainicjui pozostaîe atrybuty
  data:=INST_DATA(cl,obj)
  data.hoffset:=0
  data.ohoffset:=0
  data.udisphook:=udisp
  tag:=FindTagItem(LISTV_SCROLLCOLUMN,msg.attrlist)
  data.scol:=IF tag=NIL THEN -1 ELSE tag.data

  tag:=FindTagItem(LISTV_HORIZSTEPS,msg.attrlist)
  IF tag<>NIL THEN data.maxoffset:=tag.data

  ->- ustaw atrybuty które byîy przekazane w wywoîaniu...
  SetAttrsA(obj,msg.attrlist)
ENDPROC obj

PROC listview_Dispose(cl:PTR TO iclass,obj:PTR TO object,msg)
  DEF data:PTR TO listview_Data

  data:=INST_DATA(cl,obj)
  ->- no i zwolniê pamiëc zajmowanâ przez wewnëtrznâ strukturë rastport
  IF data.urport THEN BgUI_FreeRPortBitMap(data.urport)
ENDPROC doSuperMethodA(cl,obj,msg)


PROC dispIdList_NotifyChange(obj:PTR TO object,gi:PTR TO gadgetinfo,flags,tags)
ENDPROC doMethodA(obj,[OM_NOTIFY,tags,gi,flags])

PROC listview_Dispatcher()
  DEF cl:PTR TO iclass,obj:PTR TO object,msg:PTR TO msg
  DEF id

  MOVE.L A0,cl
  MOVE.L A2,obj
  MOVE.L A1,msg
  id:=msg.methodid
  SELECT id
    CASE OM_NEW
      RETURN listview_New(cl,obj,msg)
    CASE OM_DISPOSE
      RETURN listview_Dispose(cl,obj,msg)
    CASE OM_SET
      RETURN listview_Set(cl,obj,msg)
    CASE OM_UPDATE
      RETURN listview_Set(cl,obj,msg)
    CASE OM_GET
      RETURN listview_Get(cl,obj,msg)
  ENDSELECT
ENDPROC doSuperMethodA(cl,obj,msg)

PROC listview_MakeClass()
  DEF cl=NIL:PTR TO iclass,super:PTR TO iclass

  IF bguibase=NIL THEN RETURN NIL
  IF (super:=BgUI_GetClassPtr(BGUI_LISTVIEW_GADGET))<>NIL
    ->- klasa bëdzie prywatna...
    cl:=MakeClass(NIL,NIL,super,SIZEOF listview_Data,0)
    IF cl<>NIL THEN cl.dispatcher.entry:=eCodePreserve({listview_Dispatcher})
  ENDIF
ENDPROC cl

PROC listview_FreeClass(class) IS FreeClass(class)





->- KLASA NLISTVIEW ---

EXPORT CONST LISTV_HORIZOBJECT     = TAG_USER + $80000 + 4   /*I.G.*/
EXPORT CONST LISTV_VERTOBJECT      = LISTV_PROPOBJECT        /*ISG.*/

CONST HORIZ_SCROLLER_HEIGHT = 14

->- obiekt (nieznacznie) uîatwiajâcy uûywanie klasy nlistview
EXPORT OBJECT nlistviewclass
  class:PTR TO iclass
ENDOBJECT
PROC init() OF nlistviewclass
  self.class:=nlistview_MakeClass()
ENDPROC
PROC end() OF nlistviewclass IS nlistview_FreeClass(self.class)
PROC newObject(tags=NIL) OF nlistviewclass IS NewObjectA(self.class,NIL,tags)
PROC disposeObject(obj) OF nlistviewclass IS DisposeObject(obj)

->- dane prywatne klasy
OBJECT nlistview_Data PRIVATE
  horizsteps
  ulistview
  ulistview_cl
  uscroller
ENDOBJECT

PROC nlistview_Get(cl:PTR TO iclass,obj:PTR TO object,msg:PTR TO opget)
  DEF data:PTR TO nlistview_Data,id,tmp,x=0

  ->- najpierw poôlij wszystko do klasy po której dziedziczymy
  doSuperMethodA(cl,obj,msg)
  data:=INST_DATA(cl,obj)
  tmp:=msg.storage
  id:=msg.attrid
  SELECT id
    CASE LISTV_HORIZOBJECT
      ^tmp:=data.uscroller
    CASE LISTV_HORIZSTEPS
      ^tmp:=data.horizsteps
    DEFAULT
      ->- standardowo kieruj wszystko do klasy listview (mojej,nie do bgui!)
      GetAttr(id,data.ulistview,{x})
      ^tmp:=x
  ENDSELECT
ENDPROC

PROC nlistview_Set(cl:PTR TO iclass,obj:PTR TO object,msg:PTR TO opupdate)
  DEF data:PTR TO nlistview_Data ->,tag:PTR TO tagitem

  data:=INST_DATA(cl,obj)
  ->- standardowo kieruj wszystko do klasy listview (mojej,nie do bgui!)
  doMethodA(data.ulistview,msg)
ENDPROC doSuperMethodA(cl,obj,msg)

PROC nlistview_New(cl:PTR TO iclass,obj:PTR TO object,msg:PTR TO opset)
  DEF tag:PTR TO tagitem,data:PTR TO nlistview_Data,
      horizsteps,uscroller,ulistview,ulistview_cl

  ->- biblioteka utility.library MUSI byê wczeôniej otwarta
  IF utilitybase=NIL THEN RETURN NIL
  ->- zbuduj klasë listview z moûliwoôciâ scrollowania w poziomie...
  ulistview_cl:=listview_MakeClass()

  tag:=FindTagItem(LISTV_HORIZSTEPS,msg.attrlist)
  horizsteps:=IF tag=NIL THEN DEF_HORIZ_OFFSET ELSE Min(tag.data,MAX_HORIZ_OFFSET)

  IF ulistview_cl=NIL THEN RETURN NIL
  ->- tworzymy obiekty
  ->- najpierw klasa po której dziedziczymy...
  IF (obj:=doSuperMethodA(cl,obj,
      [OM_NEW,
      [GROUP_STYLE,GRSTYLE_VERTICAL,
       StartMember,ulistview:=NewObjectA(ulistview_cl,NIL,
         [LISTV_CUSTOMDISABLE,TRUE,
         LISTV_HORIZSTEPS,horizsteps,
         TAG_MORE,msg.attrlist,
         TAG_DONE]),
       EndMember,
       TAG_DONE],NIL]))=NIL THEN RETURN NIL

  tag:=FindTagItem(LISTV_HORIZOBJECT,msg.attrlist)
  IF tag=NIL
    ->- nic nie wiadomo o tagu LISTV_HORIZOBJECT - doîâcz do listviewa
    ->- standardowy scroller
    uscroller:=PropObject,
      PGA_TOP,0,
      PGA_TOTAL,horizsteps+10,
      PGA_VISIBLE,10,
      PGA_FREEDOM,FREEHORIZ,
      PGA_ARROWS,TRUE,
      ->- pole do popisu dla Ciebie...
      ->- PGA_ARROWSIZE,12,
      IF (tag:=FindTagItem(LISTV_THINFRAMES,msg.attrlist)) THEN PGA_THINFRAME ELSE TAG_IGNORE,tag.data,
      IF (tag:=FindTagItem(PGA_NEWLOOK,msg.attrlist))  THEN PGA_NEWLOOK ELSE TAG_IGNORE,tag.data,
    EndObject
    ->- niestety bëdzie on miaî staîâ wysokoôê (HORIZ_SCROLLER_HEIGHT)
    doMethodA(obj,
      [GRM_INSERTMEMBER,uscroller,ulistview,
      LGO_FixHeight,HORIZ_SCROLLER_HEIGHT,TAG_DONE])
  ELSE
    ->- w przeciwnym wypadku niech decyduje uûytkownik...
    uscroller:=tag.data
  ENDIF

  IF uscroller<>NIL
    ->- zainicjuj poîâczenie miëdzy obiekatmi LISTVIEW I SCROLLER
    ->- dla bezpieczeïstwa zakîadane sâ dwie notyfikacje - w koïcu nie wiadomo
    ->- jakiego obiektu uûyje uûytkownik jako scrollera
    ->- (a moûe byê i PropObject jak i SliderObject :)
    doMethodA(uscroller,[BASE_ADDMAP,ulistview,[PGA_TOP,LISTV_HORIZOFFSET,TAG_DONE]])
    doMethodA(uscroller,[BASE_ADDMAP,ulistview,[SLIDER_LEVEL,LISTV_HORIZOFFSET,TAG_DONE]])

    ->- odwrotnie - zmiana poîoûenia (programowa) powinna zmieniaê offset
    ->- listview'a - chwilowo ZABLOKOWANE
    doMethodA(ulistview,[BASE_ADDMAP,uscroller,[LISTV_HORIZOFFSET,PGA_TOP,TAG_DONE]])
    doMethodA(ulistview,[BASE_ADDMAP,uscroller,[LISTV_HORIZOFFSET,SLIDER_LEVEL,TAG_DONE]])
  ENDIF

  ->- zainicjuj pozostaîe atrybuty
  data:=INST_DATA(cl,obj)
  data.horizsteps:=horizsteps
  data.ulistview:=ulistview
  data.uscroller:=uscroller
  data.ulistview_cl:=ulistview_cl

  ->- ustaw atrybuty które byîy przekazane w wywoîaniu...
  SetAttrsA(obj,msg.attrlist)
ENDPROC obj

PROC nlistview_Dispose(cl:PTR TO iclass,obj:PTR TO object,msg)
  DEF data:PTR TO nlistview_Data

  data:=INST_DATA(cl,obj)
  ->- jedyne co moûna zrobiê tutaj to zlikwidowaê klasë listview (mojâ!)
  IF data.ulistview_cl THEN listview_FreeClass(data.ulistview_cl)
ENDPROC doSuperMethodA(cl,obj,msg)

PROC nlistview_Dispatcher()
  DEF cl:PTR TO iclass,obj:PTR TO object,msg:PTR TO msg
  DEF id

  MOVE.L A0,cl
  MOVE.L A2,obj
  MOVE.L A1,msg
  id:=msg.methodid
  SELECT id
    CASE OM_NEW
      RETURN nlistview_New(cl,obj,msg)
    CASE OM_DISPOSE
      RETURN nlistview_Dispose(cl,obj,msg)
    CASE OM_SET
      RETURN nlistview_Set(cl,obj,msg)
    CASE OM_UPDATE
      RETURN nlistview_Set(cl,obj,msg)
    CASE OM_GET
      RETURN nlistview_Get(cl,obj,msg)
  ENDSELECT
ENDPROC doSuperMethodA(cl,obj,msg)

EXPORT PROC nlistview_MakeClass()
  DEF cl=NIL:PTR TO iclass,super:PTR TO iclass

  IF bguibase=NIL THEN RETURN NIL
  IF (super:=BgUI_GetClassPtr(BGUI_GROUP_GADGET))<>NIL
    ->- klasa bëdzie prywatna...
    cl:=MakeClass(NIL,NIL,super,SIZEOF nlistview_Data,0)
    IF cl<>NIL THEN cl.dispatcher.entry:=eCodePreserve({nlistview_Dispatcher})
  ENDIF
ENDPROC cl

EXPORT PROC nlistview_FreeClass(class) IS FreeClass(class)
