;/*

    ec dtpic
    flushcache
    ec dtpic_test
    dtpic_test
    quit

    $VER: DTPic Plugin V1.00

    Synopsis: I had the idea of writing this quickly after looking at the bitmap_plugin.
                 Eeek! Not a user friendly way of sticking a picture onto a window.
    
                 Do you want to stick a nice picture in your EasyGui's? Don't want
                 too much bother? Need automatic colour remapping? Here's what you
                 are looking for then.

    Written by: Will Harwood (147800.97@swansea.ac.uk)


    Notes: Apologies for the rather messy implementation, but for colour remapping
             DoDTMethod needs a pointer to a window which does not exist...
    
             This could easily be extended to allow the user to set the screen palette
             as that of the picture (this code is taken for some more comprehensive stuff
             I wrote for a game) but since EasyGUI is designed primarily for Workbench GUI's,
             this seems rather pointless.
    

    Please, *please* e-mail me if you find any errors or obvious omissions in the code!
    (Not spelling though.)

*/

OPT OSVERSION=39
OPT MODULE
OPT EXPORT

MODULE  'workbench/workbench',
        'exec/ports',
          'datatypes', 
        'intuition/screens', 'intuition/intuition',
        'tools/easygui', 'tools/Exceptions',
          'graphics/gfx', 'graphics/scale',
          'datatypes/datatypes', 'datatypes/datatypesclass', 'datatypes/pictureclass',
          'utility', 'utility/tagitem'


ENUM PLA_DTPic_Scale=$82010000, PLA_DTPic_Filename


OBJECT dtpic_plugin OF plugin
    PRIVATE
    object                          /* the datatype object */
    bitmap:PTR TO bitmap            /* a pointer to its bitmap */
    bmh:PTR TO bitmapheader     /* a pointer to the bitmapheader */
    filename:PTR TO CHAR
    scale
ENDOBJECT

PROC init(tags=NIL:PTR TO tagitem) OF dtpic_plugin
    DEF t_bitmap=NIL:PTR TO bitmap, t_bmh=NIL:PTR TO bitmapheader

    /* Open our own libraries */
    IF NIL=(datatypesbase:=OpenLibrary('datatypes.library', 39)) THEN Raise("dlib")
    IF NIL=(utilitybase:=OpenLibrary('utility.library', 39)) THEN Raise("util") 

    self.filename:=GetTagData(PLA_DTPic_Filename, '', tags)
   self.scale:=GetTagData(PLA_DTPic_Scale, FALSE, tags)

    /*- Here we come to a circular problem: To use colour remapping I need a pointer to
        the window, but before the window can be opened EasyGUI needs to get the minimum
        dims of the picture. Erk. So I have to open the picture twice, first to get the
        dims, and secondly in render to get the actual picture. -*/

    /* Get a new datatypes object from disk, and quit if something went wrong */
    self.object:=NewDTObjectA(self.filename, [DTA_SOURCETYPE, DTST_FILE,
                                             DTA_GROUPID,    GID_PICTURE,
                                             PDTA_REMAP,     TRUE,
                                             0])

    IF self.object=0 THEN Raise("FILE")
    
    IF DoDTMethodA(self.object, 0, 0, [DTM_PROCLAYOUT,FALSE,TRUE])=NIL
        DisposeDTObject(self.object)
        self.object:=NIL
        Raise("dt")
    ENDIF

    IF GetDTAttrsA(self.object, [PDTA_BITMAPHEADER,{t_bmh}, 0])<>1 THEN Raise("dt")

    self.bmh:=t_bmh
    self.bitmap:=0

ENDPROC

PROC end() OF dtpic_plugin
    IF self.object THEN DisposeDTObject(self.object)
    IF datatypesbase THEN CloseLibrary(datatypesbase)
    IF utilitybase THEN CloseLibrary(utilitybase)
ENDPROC

PROC will_resize() OF dtpic_plugin IS self.scale

PROC min_size(ta, fh) OF dtpic_plugin IS self.bmh.width, self.bmh.height

PROC render(ta, x,y, xs, ys, win:PTR TO window) OF dtpic_plugin
    DEF t_bitmap=NIL:PTR TO bitmap, t_bmh=NIL:PTR TO bitmapheader, tbm=NIL:PTR TO bitmap

    /* A rather messy solution to an intractable problem (unless we do something sneaky
        in dtpic_test, but I don't want to have to alter the source). If self.bitmap=NIL
        then this is the first time this procedure hase been called, so we have to close
        the object, and then open it up again. */
    IF (self.bitmap=NIL) AND (self.object)
        DisposeDTObject(self.object)
        self.object:=NewDTObjectA(self.filename, [DTA_SOURCETYPE, DTST_FILE,
                                                     DTA_GROUPID,    GID_PICTURE,
                                                     PDTA_REMAP,     TRUE,
                                             0])

        IF self.object=0 THEN Raise("FILE")
        
        IF DoDTMethodA(self.object, win, 0, [DTM_PROCLAYOUT,FALSE,TRUE])=NIL
            DisposeDTObject(self.object)
            self.object:=NIL
            Raise("dt")
        ENDIF
    
        /* GetDTAttrsA returns the number of items of information about the object it was able
            to get, so if it returns any less than two here there's been a problem */
        IF GetDTAttrsA(self.object,
                                [PDTA_BITMAP,      {t_bitmap},
                                 PDTA_BITMAPHEADER,{t_bmh},
                                 0])<>2 THEN Raise("dt")
    
        self.bitmap:=t_bitmap
        self.bmh:=t_bmh
    ENDIF
    
    IF self.object
        IF self.scale
            /* Use bitmap scale into a temporary bitmap */
            IF NIL=(tbm:=AllocBitMap(win.width, win.height, self.bmh.depth, 0, 0)) THEN Raise("bm")
            BitMapScale([0, 0, self.bmh.width, self.bmh.height, self.bmh.width, self.bmh.height, 
                             0, 0, xs, ys, xs, ys,
                             self.bitmap, tbm, 0, 0, 0, 0, 0]:bitscaleargs)
            BltBitMapRastPort(tbm, 0, 0, win.rport, x, y, xs, ys, $c0)
            FreeBitMap(tbm)
        ELSE
            /* No scaling, so just blit it */
            BltBitMapRastPort(self.bitmap, 0, 0, win.rport, x, y, xs, ys, $c0)
        ENDIF
    ENDIF
ENDPROC

PROC set(attr, value) OF dtpic_plugin
    SELECT attr
    CASE PLA_DTPic_Scale
        self.scale:=value
    ENDSELECT
ENDPROC

PROC get(attr) OF dtpic_plugin
    SELECT attr
    CASE PLA_DTPic_Scale
        RETURN self.scale, TRUE
    ENDSELECT
ENDPROC
