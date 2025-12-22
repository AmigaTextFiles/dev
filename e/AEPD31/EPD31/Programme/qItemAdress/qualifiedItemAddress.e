/*----------------------------------------------------------------------------*

  EMODULES:other/qualifiedItemAddress

    NAME
      qualifiedItemAddress -- processes case-sensitive menu command hotkeys
                              for either shift key

    SYNOPSIS
      itemAddress:=qualifiedItemAddress(menuStrip, menuNumber, qualifier)

      PROC qualifiedItemAddress(menuStrip:PTR TO menu, menuNumber, qualifier=0)
        DEF itemAddress:PTR TO menuitem
      ENDPROC itemAddress

    FUNCTION
      Use of this function is similar to the Intuition routine ItemAddress(),
      with the addition of the qualifier argument.  Both menuNumber and
      qualifier can be obtained from the Intuition IDCMP_MENUPICK message
      received by your program.  menuStrip is searched for the upper- or
      lowercase equivalent menu command hotkey, depending on whether
      qualifier contains IEQUALIFIER_RSHIFT and/or IEQUALIFIER_LSHIFT.  If
      qualifier is 0, the function will return the item identified by
      Intuition (if indeed menuNumber corresponds to a valid menu item).  A
      value of NIL will be returned if no valid menu item can be identified.

    INPUTS
      menuStrip = a pointer to the first menu in your menu strip
      menuNumber = the value which contains the packed data that selects the
         the menu and item (and sub-item).  Very simply, the rawkey code
         gotten from an IDCMP_MENUPICK intuimessage
      qualifier = the rawkey qualifier gotten from and IDCMP_MENUPICK
         intuimessage

    RESULT
      If menuNumber = MENUNULL or does not correspond to a valid menu item on
      menuStrip, this function returns NIL; else this function returns the
      address of the menu item specified by menuNumber and qualifier.

 *----------------------------------------------------------------------------*/

OPT MODULE
OPT REG=5

MODULE 'intuition/intuition',
       'devices/inputevent',
       'other/lowerChar',
       'other/upperChar'

EXPORT PROC qualifiedItemAddress(menuStrip:PTR TO menu, menuNumber, qualifier=0)
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
  IF correctItem THEN correctItem.nextselect:=origItem.nextselect
ENDPROC correctItem
  /* qualifiedItemAddress */
