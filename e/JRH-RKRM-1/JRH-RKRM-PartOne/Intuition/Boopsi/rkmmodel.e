-> RKMModel.e - A simple custom modelclass subclass.

OPT MODULE
OPT PREPROCESS

OPT OSVERSION=37

MODULE 'utility',
       'amigalib/boopsi',
       'tools/installhook',
       'intuition/classes',
       'intuition/classusr',
       'utility/hooks',
       'utility/tagitem'

-> The attributes defined by this class
EXPORT ENUM RKMMOD_DUMMY=TAG_USER,
            RKMMOD_CURRVAL, -> This attribute is the current value of the model.
            RKMMOD_UP,   -> These two are fake attributes that rkmmodelclass
            RKMMOD_DOWN, -> uses as pulse values to increment/decrement the
                         -> rkmmodel's RKMMOD_CURRVAL attribute.
            RKMMOD_LIMIT -> This attribute contains the upper bound of the
                         -> rkmmodel's RKMMOD_CURRVAL.  The rkmmodel has a
                         -> static lower bound of zero.

-> If the programmer doesn't set RKMMOD_LIMIT, it defaults to this.
CONST DEFAULTVALLIMIT=100

OBJECT rkmModData
  currval, vallimit  -> The instance data for this class
ENDOBJECT

-> Initialise the class
EXPORT PROC initRKMModClass() -> Make the class and set up the dispatcher's hook
  DEF cl:PTR TO iclass
  IF cl:=MakeClass(NIL, 'modelclass', NIL, SIZEOF rkmModData, 0)
    -> E-Note: use installhook to set up the hook
    installhook(cl.dispatcher, {dispatchRKMModel})  -> Initialise the Hook
  ENDIF
ENDPROC cl

-> Free the class
EXPORT PROC freeRKMModClass(cl) IS FreeClass(cl)

-> The class Dispatcher
PROC dispatchRKMModel(cl:PTR TO iclass, o, msg:PTR TO msg)
  DEF mmd:PTR TO rkmModData, id, ti:PTR TO tagitem, tstate, tag,
      retval=NIL -> A generic return value used by this class's methods.  The
                 -> meaning of this field depends on the method.  For example,
                 -> OM_GET uses this as a boolean return value, while OM_NEW
                 -> uses it as a pointer to the new object.
  -> E-Note: installhook makes sure A4 is set-up properly
  id:=msg.methodid
  IF id=OM_SET THEN id:=OM_UPDATE -> E-Note: handled the same in this class
  SELECT id
  CASE OM_NEW -> Pass message onto superclass first so it can set aside memory
              -> for the object and take care of superclass instance data.
    IF retval:=doSuperMethodA(cl, o, msg)
      -> For the OM_NEW method, the object pointer passed to the dispatcher
      -> does not point to an object (how could it?  The object doesn't exist
      -> yet.).  doSuperMethodA() returns a pointer to a newly created object.
      -> INST_DATA() is a macro defined in 'intuition/classes' that returns a
      -> pointer to the object's instance data that is local to this class. For
      -> example, the instance data local to this class is the rkmModData
      -> structure defined above.
      mmd:=INST_DATA(cl, retval)
      -> Initialise object's attributes
      -> E-Note: "opnew" is really "opset"
      mmd.currval:=GetTagData(RKMMOD_CURRVAL, 0, msg::opnew.attrlist)
      mmd.vallimit:=GetTagData(RKMMOD_LIMIT,DEFAULTVALLIMIT,msg::opnew.attrlist)
    ENDIF
  CASE OM_UPDATE -> E-Note: includes OM_SET (see "IF id=.." above)
    mmd:=INST_DATA(cl, o)
    doSuperMethodA(cl,o,msg) -> Let the superclasses set their attributes first
    tstate:=msg::opset.attrlist
    -> Step through all of the attribute/value pairs in the list.  Use the
    -> utility.library tag functions to do this so they can properly process
    -> special tag IDs like TAG_SKIP, TAG_IGNORE, etc.
    WHILE ti:=NextTagItem({tstate})
      tag:=ti.tag
      SELECT tag
      CASE RKMMOD_CURRVAL
        IF ti.data>mmd.vallimit THEN ti.data:=mmd.vallimit
        mmd.currval:=ti.data
        notifyCurrVal(cl, o, msg, mmd)
        retval:=1 -> Changing RKMMOD_CURRVAL can cause a visual change to the
                  -> gadgets in the rkmmodel's broadcast list.  The rkmmodel has
                  -> to tell the application by returning a value besides zero.
      CASE RKMMOD_UP
        mmd.currval:=mmd.currval+1
        -> Make sure the current value is not greater than value limit.
        IF mmd.currval>mmd.vallimit THEN mmd.currval:=mmd.vallimit
        notifyCurrVal(cl, o, msg, mmd)
        retval:=1 -> Changing RKMMOD_UP can cause a visual change to the gadgets
                  -> in the rkmmodel's broadcast list.  The rkmmodel has to tell
                  -> the application by returning a value besides zero.
      CASE RKMMOD_DOWN
        mmd.currval:=mmd.currval-1
        -> Make sure the currval didn't go negative
        IF mmd.currval<0 THEN mmd.currval:=0
        notifyCurrVal(cl, o, msg, mmd)
        retval:=1 -> Changing RKMMOD_DOWN can cause a visual change to gadgets
                  -> in the rkmmodel's broadcast list.  The rkmmodel has to tell
                  -> the application by returning a value besides zero.
      CASE RKMMOD_LIMIT
        mmd.vallimit:=ti.data -> Set the limit.  Note that this does not do
                              -> bounds checking on the current
                              -> rkmModData.currval value.
      ENDSELECT
    ENDWHILE
  CASE OM_GET             -> The only attribute that is "gettable" in this class
    mmd:=INST_DATA(cl, o) -> or its superclasses is RKMMOD_CURRVAL.
    IF msg::opget.attrid=RKMMOD_CURRVAL
      msg::opget.storage[]:=mmd.currval
      retval:=TRUE
    ELSE
      retval:=doSuperMethodA(cl, o, msg)
    ENDIF
  DEFAULT -> rkmmodelclass does not recognise the methodID, so let the
          -> superclass's dispatcher take a look at it.
    retval:=doSuperMethodA(cl, o, msg)
  ENDSELECT
ENDPROC retval

PROC notifyCurrVal(cl, o, msg:PTR TO opupdate, mmd:PTR TO rkmModData)
  DEF notifymsg:PTR TO opnotify  -> E-Note: "opnotify" is really "opupdate"
  -> If this is an OM_UPDATE method, make sure the part the OM_UPDATE message
  -> adds to the OM_SET message gets added.  That lets the dispatcher handle
  -> OM_UPDATE and OM_SET in the same case.
  notifymsg:=[OM_NOTIFY, [RKMMOD_CURRVAL, mmd.currval, NIL], msg.ginfo,
              IF msg.methodid=OM_UPDATE THEN msg.flags ELSE 0]:opnotify

  -> E-Note: A bug (?) in Intuition means that the methodid of an OM_NOTIFY
  ->         message may be altered, so you can't get away with just using a
  ->         constant value in the above static list...
  notifymsg.methodid:=OM_NOTIFY

  -> If the RKMMOD_CurrVal changes, we want everyone to know about it.
  -> Theoretically, the class is supposed to send itself a OM_NOTIFY message.
  -> Because this class lets its superclass handle the OM_NOTIFY message, it
  -> skips the middleman and sends the OM_NOTIFY directly to its superclass.
  doSuperMethodA(cl, o, notifymsg)
ENDPROC
