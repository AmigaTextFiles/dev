IMPLEMENTATION MODULE GadTools ;

FROM SYSTEM IMPORT ADDRESS ;
IMPORT M2Lib , Intuition ;

PROCEDURE GTMENU_USERDATA( menu : ADDRESS ) : ADDRESS ;
  VAR x : POINTER TO ADDRESS ;
BEGIN
  INC( menu , SIZE( Intuition.Menu ) ) ;
  x := menu ;
  RETURN x^
END GTMENU_USERDATA ;

PROCEDURE GTMENUITEM_USERDATA( menuitem : ADDRESS ) : ADDRESS ;
  VAR x : POINTER TO ADDRESS ;
BEGIN
  INC( menuitem , SIZE( Intuition.MenuItem ) ) ;
  x := menuitem ;
  RETURN x^
END GTMENUITEM_USERDATA ;

BEGIN GadToolsBase := M2Lib.OpenLib("gadtools.library",VERSION)
END GadTools.
