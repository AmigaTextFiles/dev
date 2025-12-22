enuNumber, qualifier=0)
  DEF item:PTR TO menuitem, origItem:PTR TO menuitem, subitem:PTR TO menuitem,
      correctItem=NIL:PTR TO menuitem, commandChar, tChar=0
  /*-- Get the vanilla item address: --*/
  IF (origItem:=ItemAddress(menuStrip, menuNumber))=NIL THEN RETURN NIL
  /*-------------------------------------------------------------------*
    Qualifier will be:
     - 0 if selected with the mouse;
     - LCOMMAND unshifted, or RCOMMAND shifted if selected with hotkey
    If Qualifier is 0, just return the one Intuition sent us.
   *-------------------------------------------------------------------*/
  IF qualifier=0 THEN RETURN origItem
  /*-- Determine if we're looking for a shifted char or not: --*/
  commandChar:=IF qualifier AND (IEQUALIFIER_RSHIFT OR IEQUALIFIER_LSHIFT) THEN
                  upperChar(origItem.command) ELSE lowerChar(origItem.command)
  /*-- Loop through menus, looking for our char: --*/
  IF commandChar=origItem.command
    correctItem:=origItem
  ELSE
    REPEAT  ->cycle thru menus
      item:=menuStrip.firstitem
      REPEAT  ->cycle thru items
        subitem:=item.subitem
        WHILE subitem<>NIL  ->cycle thru subitems
          IF (tChar:=subitem.command)=commandChar
            correctItem:=subitem
            subitem:=NIL
          ELSE
            subitem:=subitem.nextitem
          ENDIF
        ENDWHILE
        IF tChar=commandChar
          item:=NIL
        ELSEIF (tChar:=item.command)=commandChar
          correctItem:=item
          item:=NIL
        ELSE
          item:=item.nextitem
        ENDIF
      UNTIL item=NIL
      menuStrip:=IF tChar=commandChar THEN NIL ELSE menuStrip.nextmenu
    UNTIL menuStrip=NIL
  ENDIF
  /*-- Preserve multiple selections for a single menu event. -*/
  IF c