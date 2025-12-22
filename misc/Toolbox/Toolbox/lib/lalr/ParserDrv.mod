(* $Id: ParserDrv.mi,v 1.2 1992/08/07 15:28:42 grosch rel $ *)

$@ MODULE @Drv;

$@ FROM @	IMPORT @, Close@;
FROM IO		IMPORT CloseIO;

BEGIN
$@    IF @ () = 0 THEN END;
$@    Close@;
   CloseIO;
$@ END @Drv.
