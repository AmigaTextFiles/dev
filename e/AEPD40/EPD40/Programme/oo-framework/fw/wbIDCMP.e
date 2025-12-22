
-> wbIDCMP is an abstraction of intuition IDCMP events.

-> Copyright © Guichard Damien 01/04/1996

OPT MODULE
OPT EXPORT

MODULE 'intuition/intuition'
MODULE 'fw/wbObject','fw/wbMessagePort'

OBJECT wbIDCMP OF wbMessagePort
ENDOBJECT

-> Handle the receipt of a message at the object's MsgPort.
PROC handleMessage(msg:PTR TO intuimessage) OF wbIDCMP
  DEF class
  class:=msg.class
  SELECT class
  CASE IDCMP_SIZEVERIFY      
    RETURN self.handleSizeVerify(msg)
  CASE IDCMP_NEWSIZE
    RETURN self.handleNewSize(msg)
  CASE IDCMP_REFRESHWINDOW
    RETURN self.handleRefreshWindow(msg)
  CASE IDCMP_MOUSEBUTTONS
    RETURN self.handleMouseButtons(msg)
  CASE IDCMP_MOUSEMOVE
    RETURN self.handleMouseMove(msg)
  CASE IDCMP_GADGETDOWN
    RETURN self.handleGadgetDown(msg)
  CASE IDCMP_GADGETUP
    RETURN self.handleGadgetUp(msg)
  CASE IDCMP_REQSET
    RETURN self.handleReqSet(msg)
  CASE IDCMP_MENUPICK
    RETURN self.handleMenuPick(msg)
  CASE IDCMP_CLOSEWINDOW
    RETURN self.handleCloseWindow(msg)
  CASE IDCMP_RAWKEY
    RETURN self.handleRawKey(msg)
  CASE IDCMP_REQVERIFY
    RETURN self.handleReqVerify(msg)
  CASE IDCMP_REQCLEAR
    RETURN self.handleReqClear(msg)
  CASE IDCMP_MENUVERIFY
    RETURN self.handleMenuVerify(msg)
  CASE IDCMP_NEWPREFS
    RETURN self.handleNewPrefs(msg)
  CASE IDCMP_DISKINSERTED
    RETURN self.handleDiskInserted(msg)
  CASE IDCMP_DISKREMOVED
    RETURN self.handleDiskRemoved(msg)
  CASE IDCMP_ACTIVEWINDOW
    RETURN self.handleActiveWindow(msg)
  CASE IDCMP_INACTIVEWINDOW
    RETURN self.handleInactiveWindow(msg)
  CASE IDCMP_DELTAMOVE
    RETURN self.handleDeltaMove(msg)
  CASE IDCMP_VANILLAKEY
    RETURN self.handleVanillaKey(msg)
  CASE IDCMP_INTUITICKS
    RETURN self.handleIntuiTicks(msg)
  CASE IDCMP_IDCMPUPDATE
    RETURN self.handleIdcmpUpdate(msg)
  CASE IDCMP_MENUHELP
    RETURN self.handleMenuHelp(msg)
  CASE IDCMP_CHANGEWINDOW
    RETURN self.handleChangeWindow(msg)
  CASE IDCMP_GADGETHELP
    RETURN self.handleGadgetHelp(msg)
  DEFAULT
    RETURN self.defaultHandler(msg)
  ENDSELECT
ENDPROC

PROC handleSizeVerify(msg) OF wbIDCMP IS PASS

PROC handleNewSize(msg) OF wbIDCMP IS PASS

PROC handleRefreshWindow(msg) OF wbIDCMP IS PASS

PROC handleMouseButtons(msg) OF wbIDCMP IS PASS

PROC handleMouseMove(msg) OF wbIDCMP IS PASS

PROC handleGadgetDown(msg) OF wbIDCMP IS PASS

PROC handleGadgetUp(msg) OF wbIDCMP IS PASS

PROC handleReqSet(msg) OF wbIDCMP IS PASS

PROC handleMenuPick(msg) OF wbIDCMP IS PASS

PROC handleCloseWindow(msg) OF wbIDCMP IS STOPIT

PROC handleRawKey(msg) OF wbIDCMP IS PASS

PROC handleReqVerify(msg) OF wbIDCMP IS PASS

PROC handleReqClear(msg) OF wbIDCMP IS PASS

PROC handleMenuVerify(msg) OF wbIDCMP IS PASS

PROC handleNewPrefs(msg) OF wbIDCMP IS PASS

PROC handleDiskInserted(msg) OF wbIDCMP IS PASS

PROC handleDiskRemoved(msg) OF wbIDCMP IS PASS

PROC handleActiveWindow(msg) OF wbIDCMP IS PASS

PROC handleInactiveWindow(msg) OF wbIDCMP IS PASS

PROC handleDeltaMove(msg) OF wbIDCMP IS PASS

PROC handleVanillaKey(msg) OF wbIDCMP IS PASS

PROC handleIntuiTicks(msg) OF wbIDCMP IS PASS

PROC handleIdcmpUpdate(msg) OF wbIDCMP IS PASS

PROC handleMenuHelp(msg) OF wbIDCMP IS PASS

PROC handleChangeWindow(msg) OF wbIDCMP IS PASS

PROC handleGadgetHelp(msg) OF wbIDCMP IS PASS

-> Default handler for message classes that don't have their own handler.
-> Calling this should be considered a bug, leading to program halting.
PROC defaultHandler(msg) OF wbIDCMP IS PASS

