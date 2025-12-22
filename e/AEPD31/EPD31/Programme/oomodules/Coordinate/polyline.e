/*----------------------------------------------------------------------------*

  EMODULES:other/qualifiedItemAddress

    NAME
      qualifiedItemAddress -- processes case-sensitive menu command hotkeys
                              for either shift key

    SYNOPSIS
      itemAddress:=qualifiedItemAddress(menuStrip, menuNumber, qualifier)

      PROC qualifiedItemAddress(menuStrip:PTR TO menu, menuNumber, qualifier=0)
        DEF itemAddress:PTR TO menuitem
  