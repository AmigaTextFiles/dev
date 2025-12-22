MODULE  Intel2Mot;

(* $StackChk- $OvflChk- $RangeChk- $CaseChk- $ReturnChk- $NilChk- $TypeChk- $OddChk- $ClearVars- *)

(* $JOIN Intel2Mot.o *)

PROCEDURE LSB2MSBLong * {"_LSB2MSBLong"} (long{0}: LONGINT): LONGINT;

PROCEDURE LSB2MSBShort * {"_LSB2MSBShort"} (short{0}: INTEGER): INTEGER;

PROCEDURE LSB2MSBLSet * {"_LSB2MSBLong"} (set{0}: LONGSET): LONGSET;

PROCEDURE ByteTo32 * {"_ByteTo32"} (byte{0}: CHAR): LONGINT;

PROCEDURE ShortTo32 * {"_ShortTo32"} (short{0}: INTEGER): LONGINT;

PROCEDURE Round * {"_Round"} (long{0}: LONGINT;
                              round{1}: LONGINT): LONGINT;

END Intel2Mot.

