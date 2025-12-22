/* -- --------------------------------------------------------------- -- *
 * -- Programname......: NewAreaClass.e                               -- *
 * -- Description......: This areaclass works similar to the one of   -- *
 * --                    the "bgui.library" with one useful           -- *
 * --                    difference: An object has it's own rastport. -- *
 * --                                                                 -- *
 * -- Author...........: Daniel Kasmeroglu (alias Deekah)             -- *
 * -- E-Mail...........: raptor@cs.tu-berlin.de                       -- *
 * -- Version..........: 1.0     (15.03.1997)                         -- *
 * -- --------------------------------------------------------------- -- */

     /* -- ------------------------------------------------- -- *
      * --                   Compiler-Option's               -- *
      * -- ------------------------------------------------- -- */

OPT REG = 5                -> activate register-optimisation
OPT PREPROCESS             -> enable preprocessor
OPT MODULE                 -> generate e-module


     /* -- ------------------------------------------------- -- *
      * --                        E-Module                   -- *
      * -- ------------------------------------------------- -- */

MODULE 'libraries/bgui',
       'libraries/bguim',
       'utility/tagitem',
       'utility/hooks',
       'exec/memory',
       'exec/lists',
       'exec/nodes',
       'graphics/text',
       'graphics/rastport',
       'devices/inputevent',
       'intuition/icclass',
       'intuition/cghooks',
       'intuition/classusr',
       'intuition/screens',
       'intuition/classes',
       'intuition/gadgetclass',
       'intuition/intuition',
       'tools/installhook',
       'tools/boopsi',
       'amigalib/boopsi',
       'amigalib/lists'

MODULE 'utility',
       'bgui'


     /* -- ------------------------------------------------- -- *
      * --                      Constant's                   -- *
      * -- ------------------------------------------------- -- */

CONST INTERN_TAGBASE    = $90000000,  -> // I don't know how to allocate
      INTERN_METHODBASE = $90000000   -> // some constant's only for me $#%&

EXPORT CONST AREA_Width         = INTERN_TAGBASE + $0001,   -> I-G--
             AREA_Height        = INTERN_TAGBASE + $0002,   -> I-G--
             AREA_RastPort      = INTERN_TAGBASE + $0003,   -> I-G--
             AREA_Depth         = INTERN_TAGBASE + $0004,   -> I-G--
             AREA_MinVWidth     = INTERN_TAGBASE + $0005,   -> I-G--
             AREA_MinVHeight    = INTERN_TAGBASE + $0006,   -> I-G--
             AREA_X             = INTERN_TAGBASE + $0007,   -> ISG-U
             AREA_Y             = INTERN_TAGBASE + $0008,   -> ISG-U
             AREA_HProp         = INTERN_TAGBASE + $0009,   -> I-G--
             AREA_VProp         = INTERN_TAGBASE + $000A,   -> I-G--
             AREA_VisibleWidth  = INTERN_TAGBASE + $000B,   -> --G--
             AREA_VisibleHeight = INTERN_TAGBASE + $000C    -> --G--

EXPORT CONST ARM_CHANGERP  = INTERN_METHODBASE + $0001     


     /* -- ------------------------------------------------- -- *
      * --                      Structure's                  -- *
      * -- ------------------------------------------------- -- */

EXPORT OBJECT armChangeRP
  arm_MethodID : LONG                    -> ARM_CHANGERP
  arm_Tags     : PTR TO tagitem          -> Following tags are allowed: AREA_Width, AREA_Height, AREA_Depth
  arm_Copy     : LONG                    -> TRUE = make copy of the old contents
ENDOBJECT


OBJECT areadata
  area_MinVWidth     : INT               -> minimal visible width
  area_MinVHeight    : INT               -> minimal visible height
  area_X             : INT               -> current x-position
  area_Y             : INT               -> current y-position
  area_Width         : INT               -> width of the whole area
  area_Height        : INT               -> height of the whole area
  area_Depth         : CHAR              -> depth of the area
  area_RastPort      : PTR TO rastport   -> my own rastport
  area_Horizontal    : PTR TO object     -> a horizontal prop
  area_Vertical      : PTR TO object     -> a vertical prop
  area_VisibleWidth  : INT               -> visible width
  area_VisibleHeight : INT               -> visible height
ENDOBJECT


     /* -- ------------------------------------------------- -- *
      * --                      Procedure's                  -- *
      * -- ------------------------------------------------- -- */

EXPORT PROC nar_InitNewAreaClass()
DEF ini_super : PTR TO iclass
DEF ini_class : PTR TO iclass

  ini_class := NIL

  -> // check if needed librarys are available
  IF (bguibase <> NIL) AND (utilitybase <> NIL)

    -> // subclass from baseclass
    ini_super := BgUI_GetClassPtr( BGUI_BASE_GADGET )
    IF ini_super <> NIL

      -> // normal installation stuff
      ini_class := MakeClass( NIL, NIL, ini_super, SIZEOF areadata, 0 )
      IF ini_class <> NIL THEN installhook( ini_class.dispatcher, {intern_Dispatcher} )
 
    ENDIF 

  ENDIF

ENDPROC ini_class


-> // use this version instead of the direct "FreeClass()" call
EXPORT PROC nar_FreeNewAreaClass( fre_cl ) IS FreeClass( fre_cl )


     /* -- ------------------------------------------------- -- *
      * --                       Dispatcher                  -- *
      * -- ------------------------------------------------- -- */

PROC intern_Dispatcher( dis_cl, dis_obj, dis_msg : PTR TO msg )
DEF dis_mid

  dis_mid := dis_msg.methodid

  SELECT dis_mid
  CASE OM_NEW         ; RETURN intern_Method_NEW(        dis_cl, dis_obj, dis_msg )
  CASE OM_GET         ; RETURN intern_Method_GET(        dis_cl, dis_obj, dis_msg )  
  CASE OM_SET         ; RETURN intern_Method_SET(        dis_cl, dis_obj, dis_msg )
  CASE OM_UPDATE      ; RETURN intern_Method_SET(        dis_cl, dis_obj, dis_msg )
  CASE OM_DISPOSE     ; RETURN intern_Method_DISPOSE(    dis_cl, dis_obj, dis_msg )
  CASE GM_RENDER      ; RETURN intern_Method_RENDER(     dis_cl, dis_obj, dis_msg )
  CASE GRM_DIMENSIONS ; RETURN intern_Method_DIMENSIONS( dis_cl, dis_obj, dis_msg )
  CASE ARM_CHANGERP   ; RETURN intern_Method_CHANGERP(   dis_cl, dis_obj, dis_msg )
  DEFAULT             ; RETURN doSuperMethodA(           dis_cl, dis_obj, dis_msg )
  ENDSELECT

ENDPROC


     /* -- ------------------------------------------------- -- *
      * --                        Methoden                   -- *
      * -- ------------------------------------------------- -- */

-> // OM_NEW : Constructor

PROC intern_Method_NEW( new_cl : PTR TO iclass, new_obj, new_msg : PTR TO opnew )
DEF new_data : PTR TO areadata
DEF new_retval

  new_retval := doSuperMethodA( new_cl, new_obj, new_msg )
  IF new_retval <> NIL

    -> // read out all needed data
    new_data                    := INST_DATA( new_cl, new_retval )
    new_data.area_Width         := GetTagData( AREA_Width,         100, new_msg.attrlist )
    new_data.area_Height        := GetTagData( AREA_Height,        50,  new_msg.attrlist )
    new_data.area_Depth         := GetTagData( AREA_Depth,         6,   new_msg.attrlist )
    new_data.area_MinVWidth     := GetTagData( AREA_MinVWidth,     100, new_msg.attrlist )
    new_data.area_MinVHeight    := GetTagData( AREA_MinVHeight,    50,  new_msg.attrlist )
    new_data.area_X             := GetTagData( AREA_X,             0,   new_msg.attrlist )
    new_data.area_Y             := GetTagData( AREA_Y,             0,   new_msg.attrlist )
    new_data.area_Horizontal    := GetTagData( AREA_HProp,         NIL, new_msg.attrlist )
    new_data.area_Vertical      := GetTagData( AREA_VProp,         NIL, new_msg.attrlist )
    new_data.area_VisibleWidth  := new_data.area_MinVWidth
    new_data.area_VisibleHeight := new_data.area_MinVHeight

    -> // setup my own rastport
    new_data.area_RastPort      := BgUI_CreateRPortBitMap( NIL, new_data.area_Width, new_data.area_Height, new_data.area_Depth )

    IF new_data.area_RastPort = NIL

      -> // bullshit ! I'm missing some memory $#%&
      coerceMethodA( new_cl, new_retval, [ OM_DISPOSE ]:msg )
      new_retval := NIL

    ELSE

      -> // I don't know if the allocated memory was allocated with the
      -> // attribute MEMF_CLEAR, so I'm clearing the rastport by myself.
      SetAPen( new_data.area_RastPort, 0 )
      RectFill( new_data.area_RastPort, 0, 0, new_data.area_Width - 1, new_data.area_Height - 1 )

      IF new_data.area_Horizontal <> NIL

        -> // set needed attribute's
        SetAttrsA( new_data.area_Horizontal, 
        [ ICA_TARGET,      new_retval,
          ICA_MAP,         {lab_TranslateX},
          PGA_TOTAL,       new_data.area_Width,
          TAG_END ] )

      ENDIF

      IF new_data.area_Vertical <> NIL

        -> // set needed attribute's
        SetAttrsA( new_data.area_Vertical, 
        [ ICA_TARGET,      new_retval,
          ICA_MAP,         {lab_TranslateY},
          PGA_TOTAL,       new_data.area_Height,
          TAG_END ] )

      ENDIF

    ENDIF

  ENDIF

ENDPROC new_retval


-> // OM_GET : read data

PROC intern_Method_GET( get_cl : PTR TO iclass, get_obj, get_msg : PTR TO opget )
DEF get_data : PTR TO areadata
DEF get_attrid

  get_data   := INST_DATA( get_cl, get_obj )
  get_attrid := get_msg.attrid

  -> // poke requested data or let the superclass make the work
  SELECT get_attrid
  CASE AREA_Width         ; PutLong( get_msg.storage, get_data.area_Width         )
  CASE AREA_Height        ; PutLong( get_msg.storage, get_data.area_Height        )
  CASE AREA_Depth         ; PutLong( get_msg.storage, get_data.area_Depth         )
  CASE AREA_RastPort      ; PutLong( get_msg.storage, get_data.area_RastPort      )
  CASE AREA_X             ; PutLong( get_msg.storage, get_data.area_X             )
  CASE AREA_Y             ; PutLong( get_msg.storage, get_data.area_Y             )
  CASE AREA_MinVWidth     ; PutLong( get_msg.storage, get_data.area_MinVWidth     )
  CASE AREA_MinVHeight    ; PutLong( get_msg.storage, get_data.area_MinVHeight    )
  CASE AREA_HProp         ; PutLong( get_msg.storage, get_data.area_Horizontal    )
  CASE AREA_VProp         ; PutLong( get_msg.storage, get_data.area_Vertical      )
  CASE AREA_VisibleWidth  ; PutLong( get_msg.storage, get_data.area_VisibleWidth  )
  CASE AREA_VisibleHeight ; PutLong( get_msg.storage, get_data.area_VisibleHeight )
  DEFAULT                 ; RETURN doSuperMethodA( get_cl, get_obj, get_msg )
  ENDSELECT

ENDPROC TRUE


-> // OM_SET : write data

PROC intern_Method_SET( set_cl : PTR TO iclass, set_obj, set_msg : PTR TO opset )
DEF set_rport : PTR TO rastport
DEF set_data  : PTR TO areadata
DEF set_retval

  -> // get instance
  set_data        := INST_DATA( set_cl, set_obj )

  -> // first let make the work by the superclass
  set_retval      := doSuperMethodA( set_cl, set_obj, [ OM_SET, set_msg.attrlist, set_msg.ginfo ]:opset )

  -> // now get the new data, if there are some
  set_data.area_X := GetTagData( AREA_X, set_data.area_X, set_msg.attrlist )
  set_data.area_Y := GetTagData( AREA_Y, set_data.area_Y, set_msg.attrlist )

  -> // evetually change immediately
  IF set_msg.methodid = OM_UPDATE

    set_rport  := ObtainGIRPort( set_msg.ginfo )
    IF set_rport <> NIL
      coerceMethodA( set_cl, set_obj, [ GM_RENDER, set_msg.ginfo, set_rport, GREDRAW_UPDATE ]:gprender )
      ReleaseGIRPort( set_rport )
    ENDIF

  ENDIF

ENDPROC set_retval


-> // OM_DISPOSE : Destructor

PROC intern_Method_DISPOSE( dis_cl : PTR TO iclass, dis_obj, dis_msg )
DEF dis_data : PTR TO areadata

  -> // kill the private rastport
  dis_data := INST_DATA( dis_cl, dis_obj )
  IF dis_data.area_RastPort <> NIL THEN BgUI_FreeRPortBitMap( dis_data.area_RastPort )

ENDPROC doSuperMethodA( dis_cl, dis_obj, dis_msg )


-> // GM_RENDER : Render the object

PROC intern_Method_RENDER( ren_cl : PTR TO iclass, ren_obj, ren_msg : PTR TO gprender )
DEF ren_data : PTR TO areadata
DEF ren_ibox : PTR TO ibox
DEF ren_retval,ren_x,ren_y
DEF ren_w,ren_h

  -> // first let do the superclass render (MUST BE DONE)
  ren_retval := doSuperMethodA( ren_cl, ren_obj, ren_msg )
  IF ren_retval <> NIL

    -> // now get the innerbox to render in
    doSuperMethodA( ren_cl, ren_obj, [ OM_GET, BT_InnerBox, {ren_ibox} ]:opget )
    ren_data := INST_DATA( ren_cl, ren_obj )

    -> // update the visible-attribute's
    ren_data.area_VisibleWidth  := ren_ibox.width
    ren_data.area_VisibleHeight := ren_ibox.height


    -> // update the proportional-gadgets
    IF ren_data.area_Horizontal <> NIL THEN SetAttrsA( ren_data.area_Horizontal, [ PGA_VISIBLE, ren_data.area_VisibleWidth,  TAG_END ] )
    IF ren_data.area_Vertical   <> NIL THEN SetAttrsA( ren_data.area_Vertical,   [ PGA_VISIBLE, ren_data.area_VisibleHeight, TAG_END ] )
 
    -> // calculate drawable area and basic position to center
    -> // if required
    IF ren_ibox.width > ren_data.area_Width
      ren_x := Shr( ren_ibox.width - ren_data.area_Width, 1 )
      ren_w := ren_data.area_Width
    ELSE
      ren_x := 0
      ren_w := ren_ibox.width
    ENDIF

    IF ren_ibox.height > ren_data.area_Height
      ren_y := Shr( ren_ibox.height - ren_data.area_Height, 1 )
      ren_h := ren_data.area_Height
    ELSE
      ren_y := 0
      ren_h := ren_ibox.height
    ENDIF

    -> // blit the requested area to the real rastport
    BltBitMapRastPort( ren_data.area_RastPort.bitmap, 
                       ren_data.area_X,
                       ren_data.area_Y,
                       ren_msg.rport,
                       ren_ibox.left + ren_x,
                       ren_ibox.top  + ren_y, 
                       ren_w,
                       ren_h,
                       $0C0 )

  ENDIF
  
ENDPROC ren_retval


-> // ARM_CHANGERP : change some attribute's ( AREA_Width, AREA_Height, AREA_Depth )

PROC intern_Method_CHANGERP( cha_cl : PTR TO iclass, cha_obj, cha_msg : PTR TO armChangeRP )
DEF cha_data  : PTR TO areadata
DEF cha_rport : PTR TO rastport
DEF cha_width,cha_height,cha_depth
DEF cha_return

  -> // get some needed data
  cha_data   := INST_DATA( cha_cl, cha_obj )
  cha_width  := GetTagData( AREA_Width,  cha_data.area_Width,  cha_msg.arm_Tags )
  cha_height := GetTagData( AREA_Height, cha_data.area_Height, cha_msg.arm_Tags )
  cha_depth  := GetTagData( AREA_Depth,  cha_data.area_Depth,  cha_msg.arm_Tags )
  cha_return := FALSE

  -> // setup a new rastport
  cha_rport  := BgUI_CreateRPortBitMap( NIL, cha_width, cha_height, cha_depth )
  IF cha_rport <> NIL

    -> // clear it's contents
    SetAPen( cha_rport, 0 )
    RectFill( cha_rport, 0, 0, cha_width - 1, cha_height - 1 )

    -> // eventually copy the old information
    IF cha_msg.arm_Copy <> FALSE
      BltBitMapRastPort( cha_data.area_RastPort.bitmap, 0, 0, cha_rport, 0, 0, Min( cha_width, cha_data.area_Width ), Min( cha_height, cha_data.area_Height ), $0C0 )
    ENDIF

    -> // free the old rastport
    BgUI_FreeRPortBitMap( cha_data.area_RastPort )

    -> // store the new data
    cha_data.area_RastPort := cha_rport
    cha_data.area_Width    := cha_width
    cha_data.area_Height   := cha_height
    cha_data.area_Depth    := cha_depth

    -> // update the props
    IF cha_data.area_Horizontal <> NIL
      SetAttrsA( cha_data.area_Horizontal, [ PGA_TOTAL, cha_data.area_Width, TAG_END ] )
    ENDIF

    IF cha_data.area_Vertical <> NIL
      SetAttrsA( cha_data.area_Vertical, [ PGA_TOTAL, cha_data.area_Height, TAG_END ] )
    ENDIF

    cha_return             := TRUE

  ENDIF

ENDPROC cha_return


-> // GRM_DIMENSIONS : tell minimum required dimensions

PROC intern_Method_DIMENSIONS( dim_cl : PTR TO iclass, dim_obj, dim_msg : PTR TO grmDimensions )
DEF dim_data : PTR TO areadata
DEF dim_retval

  dim_data   := INST_DATA( dim_cl, dim_obj )
  dim_retval := doSuperMethodA( dim_cl, dim_obj, dim_msg )
  
  PutInt( dim_msg.minSizeWidth,  Int( dim_msg.minSizeWidth  ) + dim_data.area_MinVWidth  )
  PutInt( dim_msg.minSizeHeight, Int( dim_msg.minSizeHeight ) + dim_data.area_MinVHeight )

ENDPROC dim_retval


     /* -- ------------------------------------------------- -- *
      * --                        Data                       -- *
      * -- ------------------------------------------------- -- */

lab_TranslateX:
LONG PGA_TOP, AREA_X, TAG_END

lab_TranslateY:
LONG PGA_TOP, AREA_Y, TAG_END
