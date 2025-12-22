/* -- --------------------------------------------------------------- -- *
 * -- Autor.........: Daniel Kasmeroglu alias Gideon                  -- *
 * -- Programm......: BOOPSI-Klasse "IFFImageClass"                   -- *
 * -- Original von..: Holger Engels                                   -- *
 * -- Version.......: 0.2                                             -- *
 * -- --                                                           -- -- *
 * -- History.......:                                                 -- *
 * --    0.1        - Die erste Version ;-)                           -- *
 * --                 (10.02.1996)                                    -- *
 * --    0.2        - Auslöschen einiger kleiner Fehler.              -- *
 * --                 (19.02.1996)                                    -- *
 * -- --------------------------------------------------------------- -- */


     /* -- ------------------------------------------------- -- *
      * --                 Compiler-Optionen                 -- *
      * -- ------------------------------------------------- -- */

OPT OSVERSION = 37          ->: BOOPSI gibt es erst ab Amiga OS 2.04
OPT REG = 5                 ->: Register-Optimierung einschalten
OPT PREPROCESS              ->: Präprozessor aktivieren
OPT MODULE                  ->: E-Modul generieren


     /* -- ------------------------------------------------ -- *
      * --                 benötigte Module                 -- *
      * -- ------------------------------------------------ -- */

MODULE 'tools/ilbmdefs',
       'tools/installhook',
       'amigalib/boopsi',
       'amigalib/lists',
       'intuition/classes',
       'intuition/classusr',
       'intuition/imageclass',
       'intuition/intuition',
       'libraries/iffparse',
       'utility/tagitem',
       'exec/lists',
       'exec/memory',
       'iffparse',
       'utility'


     /* -- ------------------------------------------------ -- *
      * --               wichtige Konstanten                -- *
      * -- ------------------------------------------------ -- */

CONST ERR_NO_ERROR           = 0,
      ERR_NO_LIBRARY         = 1,
      ERR_NO_MEMORY          = 2,
      ERR_INVALID_PATH       = 4,
      ERR_FILE_CORRUPT       = 8,
      ERR_OPEN_FAILURE       = 10,
      ERR_SCAN_FAILURE       = 20,
      ERR_NO_IFFLIST         = 40,
      ERR_NO_NORMAL_STATE    = 80


CONST ID_ILBM = "ILBM",
      ID_NAME = "NAME",
      ID_BMHD = "BMHD",
      ID_BODY = "BODY"



EXPORT ENUM ISD_NORMAL = $80000000,
            ISD_SELECTED,
            ISD_DISABLED,
            ISD_BUSY,
            ISD_INDETERMINANT,
            ISD_INACTIVENORMAL,
            ISD_INACTIVESELECTED,
            ISD_INACTIVEDISABLED,
            ISD_SELECTEDDISABLED,
            IFFIM_IFFLIST = $80000014


     /* -- ------------------------------------------------ -- *
      * --            wichtige Datenstrukturen              -- *
      * -- ------------------------------------------------ -- */

OBJECT iffimagenode
  succ     : PTR TO iffimagenode
  pred     : PTR TO iffimagenode
  type     : CHAR
  pri      : CHAR
  name     : PTR TO CHAR
  bmhd     : PTR TO bmhd
  body     : PTR TO CHAR
  bodysize : LONG
ENDOBJECT


OBJECT iffimagedata
  availableimages : PTR TO tagitem
ENDOBJECT


     /* -- ------------------------------------------------ -- *
      * --                   die Methoden                   -- *
      * -- ------------------------------------------------ -- */

->: Private Klasse erstellen
EXPORT PROC iff_InitIFFIMAGEClass()
DEF ini_class : PTR TO iclass

  ini_class := MakeClass(NIL,IMAGECLASS,NIL,SIZEOF iffimagedata,0)
  IF ini_class <> NIL THEN installhook(ini_class.dispatcher,{iff_DispatchIFFIMAGEClass})

ENDPROC ini_class


->: Private Klasse auflösen
EXPORT PROC iff_FreeIFFIMAGEClass(fre_class : PTR TO iclass) IS FreeClass(fre_class)


->: der Dispatcher
PROC iff_DispatchIFFIMAGEClass(dis_class : PTR TO iclass,dis_object : PTR TO object,dis_msg : PTR TO msg)
DEF dis_iid      : PTR TO iffimagedata
DEF dis_in       : PTR TO iffimagenode
DEF dis_ifflist  : PTR TO lh
DEF dis_im       : PTR TO image
DEF dis_tag1     : PTR TO tagitem
DEF dis_tag2     : PTR TO tagitem
DEF dis_retval,dis_error,dis_mid,dis_avimnum

  dis_retval := NIL
  dis_error  := FALSE
  dis_im     := NIL
  dis_mid    := dis_msg.methodid

  SELECT dis_mid

    CASE OM_NEW

      ->: Datenstruktur mit Hilfe der Superklassen beschaffen
      dis_retval := doSuperMethodA(dis_class,dis_object,dis_msg)

      IF dis_retval <> NIL
 
        ->: Struktur holen und mit Werten füllen
        dis_iid     := INST_DATA(dis_class,dis_retval)
        dis_ifflist := GetTagData(IFFIM_IFFLIST,0,dis_msg::opset.attrlist)
        IF dis_ifflist <> NIL
 
          dis_iid.availableimages := CloneTagItems(dis_msg::opset.attrlist)
          dis_avimnum             := FilterTagItems(dis_iid.availableimages,{knownimagetags},TAGFILTER_AND)
          dis_tag1                := dis_iid.availableimages

          ->: In dieser Schleife werden die IFF-Grafiken in Images
          ->: umgewandelt und erhalten den Namen ihrer Datei
          WHILE (dis_tag2 := NextTagItem({dis_tag1})) <> NIL

            dis_in := FindName(dis_ifflist,dis_tag2.data)
            IF dis_in <> NIL
              dis_tag2.data := AllocVec(SIZEOF image,MEMF_CLEAR)
              IF dis_tag2.data <> NIL
                dis_im           := dis_tag2.data
                dis_im.imagedata := AllocVec(dis_in.bodysize,MEMF_CLEAR OR MEMF_CLEAR)
                IF dis_im.imagedata <> NIL

                  dis_im.leftedge   := GetTagData(IA_LEFT,0,dis_msg::opset.attrlist)
                  dis_im.topedge    := GetTagData(IA_TOP,0,dis_msg::opset.attrlist)
                  dis_im.width      := dis_in.bmhd.w
                  dis_im.height     := dis_in.bmhd.h
                  dis_im.planepick  := Shl(1,dis_in.bmhd.planes) - 1
                  dis_im.planeonoff := 0
                  dis_im.nextimage  := NIL
 
                  ->: die Konvertierung von Brush- zu Image-Daten
                  iff_Brush2Image(dis_in.body,dis_im.imagedata,dis_im.width,dis_im.height,dis_in.bmhd.planes)

                ELSE
                  dis_error := ERR_NO_MEMORY
                ENDIF
              ELSE
                dis_error := ERR_NO_MEMORY
              ENDIF
            ELSE
              dis_tag1.data := NIL
            ENDIF
          ENDWHILE

          IF Not(iff_SendSET2Super(dis_class,dis_retval,ISD_NORMAL)) THEN dis_error := ERR_NO_NORMAL_STATE

        ELSE
          dis_error := ERR_NO_IFFLIST
        ENDIF

        IF dis_error <> NIL

          IF dis_error = ERR_NO_MEMORY
            iff_DisposeImages(dis_iid.availableimages)
            coerceMethodA(dis_class,dis_retval,OM_DISPOSE)
            dis_retval := NIL
          ENDIF

        ENDIF

      ENDIF

    CASE IM_DRAW

      IF iff_SendSET2Super(dis_class,dis_object,dis_msg::impdraw.state OR ISD_NORMAL)
        dis_retval := doSuperMethodA(dis_class,dis_object,dis_msg)
      ELSE
        dis_retval := NIL
      ENDIF

    CASE OM_DISPOSE

      dis_iid := INST_DATA(dis_class,dis_object)
      iff_DisposeImages(dis_iid.availableimages)
      FreeTagItems(dis_iid.availableimages)
      dis_retval := doSuperMethodA(dis_class,dis_object,dis_msg)

    DEFAULT
 
      dis_retval := doSuperMethodA(dis_class,dis_object,dis_msg)

    ENDSELECT

ENDPROC dis_retval


PROC iff_SendSET2Super(sen_class : PTR TO iclass,sen_object : PTR TO object,sen_which)
DEF sen_iid      : PTR TO iffimagedata
DEF sen_im       : PTR TO image
DEF sen_attrs[8] : ARRAY OF tagitem

  sen_iid := INST_DATA(sen_class,sen_object)
  sen_im  := GetTagData(sen_which,NIL,sen_iid.availableimages)
  
  IF sen_im <> NIL

    sen_attrs[0].tag  := IA_LEFT
    sen_attrs[0].data := sen_im.leftedge
    sen_attrs[1].tag  := IA_TOP
    sen_attrs[1].data := sen_im.topedge
    sen_attrs[2].tag  := IA_WIDTH
    sen_attrs[2].data := sen_im.width
    sen_attrs[3].tag  := IA_HEIGHT
    sen_attrs[3].data := sen_im.height
    sen_attrs[4].tag  := IA_DATA
    sen_attrs[4].data := sen_im.imagedata
    sen_attrs[5].tag  := IA_FGPEN
    sen_attrs[5].data := sen_im.planepick
    sen_attrs[6].tag  := IA_BGPEN
    sen_attrs[6].data := sen_im.planeonoff
    sen_attrs[7].tag  := TAG_END
    sen_attrs[7].data := TAG_END

    doSuperMethodA(sen_class,sen_object,[OM_SET, sen_attrs,NIL]:opset)
    RETURN TRUE

  ENDIF

ENDPROC FALSE


PROC iff_DisposeImages(dis_taglist : PTR TO tagitem)
DEF dis_tag    : PTR TO tagitem
DEF dis_tstate : PTR TO tagitem

  dis_tstate := dis_taglist
  WHILE (dis_tag := NextTagItem({dis_tstate})) <> NIL

    IF dis_tag.data <> NIL
      FreeVec(dis_tag.data::image.imagedata)
      FreeVec(dis_tag.data)
    ENDIF

  ENDWHILE

ENDPROC


->: eine einfache Konvertierungsfunktion
PROC iff_Brush2Image(bru_brush : PTR TO CHAR,bru_image : PTR TO CHAR,bru_w,bru_h,bru_d)
DEF bru_l,bru_p

  bru_w := Shr(bru_w + 15,3)

  FOR bru_p := 0 TO bru_d - 1
    FOR bru_l := 0 TO bru_h - 1
      CopyMem(bru_brush + ((bru_l * bru_d + bru_p) * bru_w),bru_image + ((bru_p * bru_h + bru_l) * bru_w),bru_w)
    ENDFOR
  ENDFOR

ENDPROC


->: die Liste mit den Brushes wird initialisiert
EXPORT PROC iff_InitIFFList(ini_path : PTR TO CHAR)
DEF ini_ifflist     : PTR TO lh
DEF ini_in          : PTR TO iffimagenode
DEF ini_iff         : PTR TO iffhandle
DEF ini_sp          : PTR TO storedproperty
DEF ini_error,ini_ret,ini_state

  ini_ifflist := NIL
  ini_in      := NIL
  ini_iff     := NIL
  ini_sp      := NIL
  ini_error   := ERR_NO_ERROR
  ini_state   := TRUE

  ini_ifflist := AllocVec(SIZEOF lh,MEMF_CLEAR)
  IF ini_ifflist <> NIL
    newList(ini_ifflist)
    ini_iff := AllocIFF()
    IF ini_iff <> NIL
      ini_iff.stream := Open(ini_path,OLDFILE)
      IF ini_iff.stream <> NIL
 
        InitIFFasDOS(ini_iff)

        ini_error := OpenIFF(ini_iff,IFFF_READ)
        IF Not(ini_error) <> NIL
          StopOnExit(ini_iff,ID_ILBM,ID_FORM)
          PropChunk(ini_iff,ID_ILBM,ID_NAME)
          PropChunk(ini_iff,ID_ILBM,ID_BMHD)
          PropChunk(ini_iff,ID_ILBM,ID_BODY)
 
          WHILE (ini_ret := ParseIFF(ini_iff,IFFPARSE_SCAN)) <> NIL

            IF ini_ret = IFFERR_EOF
              JUMP endehier           
            ELSE
              
              ini_in := AllocVec(SIZEOF iffimagenode,MEMF_CLEAR)
              IF ini_in <> NIL
                ini_sp := FindProp(ini_iff,ID_ILBM,ID_NAME)
                ini_in.name := String(ini_sp.size + 1)
                IF ini_in.name <> NIL
                  StrCopy(ini_in.name,ini_sp.data,ini_sp.size)
                  ini_in.name[ini_sp.size] := 0
                  ini_sp                   := FindProp(ini_iff,ID_ILBM,ID_BMHD)
                  ini_in.bmhd              := AllocVec(SIZEOF bmhd,MEMF_PUBLIC)
                  IF ini_in.bmhd <> NIL
                    CopyMemQuick(ini_sp.data,ini_in.bmhd,SIZEOF bmhd)
                    ini_sp := FindProp(ini_iff,ID_ILBM,ID_BODY)
                    ini_in.body := AllocVec(ini_sp.size,MEMF_PUBLIC)
                    IF ini_in.body <> NIL
                      CopyMem(ini_sp.data,ini_in.body,ini_sp.size)
                      ini_in.bodysize := ini_sp.size
                      AddHead(ini_ifflist,ini_in)
                    ELSE
                      FreeVec(ini_in.body)
                      FreeVec(ini_in.bmhd)
                      Dispose(ini_in.name)
                      FreeVec(ini_in)
                    ENDIF
                  ELSE
                    FreeVec(ini_in.bmhd)
                    Dispose(ini_in.name)
                    FreeVec(ini_in)
                  ENDIF
                ELSE
                  Dispose(ini_in.name)
                  FreeVec(ini_in)
                ENDIF 
              ELSE
                FreeVec(ini_in)
              ENDIF
            ENDIF

          ENDWHILE
endehier:
          CloseIFF(ini_iff)

        ELSE
          ini_error := ERR_OPEN_FAILURE
        ENDIF
      
        Close(ini_iff.stream)
      
      ELSE
        ini_error := ERR_INVALID_PATH
      ENDIF
 
      FreeIFF(ini_iff)

    ENDIF

  ELSE
    ini_error := ERR_NO_MEMORY
  ENDIF

  IF ini_error <> NIL THEN RETURN NIL

ENDPROC ini_ifflist


->: Die Liste mit den Brushes wird wieder freigegeben
EXPORT PROC iff_FreeIFFList(fre_ifflist : PTR TO lh)
DEF fre_in : PTR TO iffimagenode

  WHILE (fre_in := RemTail(fre_ifflist)) <> NIL
    IF fre_in.name <> NIL THEN Dispose(fre_in.name)
    IF fre_in.bmhd <> NIL THEN FreeVec(fre_in.bmhd)
    IF fre_in.body <> NIL THEN FreeVec(fre_in.body)
    FreeVec(fre_in)
  ENDWHILE
  FreeVec(fre_ifflist)

ENDPROC


knownimagetags: 
LONG  ISD_NORMAL,ISD_SELECTED,ISD_DISABLED,ISD_BUSY,ISD_INDETERMINANT,
      ISD_INACTIVENORMAL,ISD_INACTIVESELECTED,ISD_INACTIVEDISABLED,
      ISD_SELECTEDDISABLED,TAG_END
