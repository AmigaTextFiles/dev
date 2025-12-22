MODULE  StringLib;

(* $StackChk- $OvflChk- $RangeChk- $CaseChk- $ReturnChk- $NilChk- $TypeChk- *)
(* $JOIN StringLib.o *)

IMPORT  e:=Exec,
        y:=SYSTEM;

PROCEDURE isupper * {"_isupper"} (c{0}: CHAR): BOOLEAN;
PROCEDURE islower * {"_islower"} (c{0}: CHAR): BOOLEAN;
PROCEDURE isalnum * {"_isalnum"} (c{0}: CHAR): BOOLEAN;
PROCEDURE isalpha * {"_isalpha"} (c{0}: CHAR): BOOLEAN;
PROCEDURE isdigit * {"_isdigit"} (c{0}: CHAR): BOOLEAN;
PROCEDURE isspace * {"_isspace"} (c{0}: CHAR): BOOLEAN;
PROCEDURE toupper * {"_toupper"} (c{0}: CHAR): CHAR;
PROCEDURE tolower * {"_tolower"} (c{0}: CHAR): CHAR;
PROCEDURE streq   * {"_streq"}   (s1{8}: ARRAY OF CHAR;
                                  s2{9}: ARRAY OF CHAR): BOOLEAN;
PROCEDURE strieq  * {"_strieq"}  (s1{8}: ARRAY OF CHAR;
                                  s2{9}: ARRAY OF CHAR): BOOLEAN;
PROCEDURE strneq  * {"_strneq"}  (s1{8}: ARRAY OF CHAR;
                                  s2{9}: ARRAY OF CHAR;
                                  n{0}: LONGINT): BOOLEAN;
PROCEDURE strnieq * {"_strnieq"} (s1{8}: ARRAY OF CHAR;
                                  s2{9}: ARRAY OF CHAR;
                                  n{0}: LONGINT): BOOLEAN;
PROCEDURE strcmp  * {"_strcmp"}  (s1{8}: ARRAY OF CHAR;
                                  s2{9}: ARRAY OF CHAR): LONGINT;
PROCEDURE stricmp * {"_stricmp"} (s1{8}: ARRAY OF CHAR;
                                  s2{9}: ARRAY OF CHAR): LONGINT;
PROCEDURE strncmp * {"_strncmp"} (s1{8}: ARRAY OF CHAR;
                                  s2{9}: ARRAY OF CHAR;
                                  n{0}: LONGINT): LONGINT;
PROCEDURE strnicmp* {"_strnicmp"}(s1{8}: ARRAY OF CHAR;
                                  s2{9}: ARRAY OF CHAR;
                                  n{0}: LONGINT): LONGINT;
PROCEDURE strlen  * {"_strlen"}  (s{8}: ARRAY OF CHAR): LONGINT;
PROCEDURE strcpy  * {"_strcpy"}  (s1{8}: ARRAY OF CHAR;
                                  VAR s2{9}: ARRAY OF CHAR);
PROCEDURE strncpy * {"_strncpy"} (s1{8}: ARRAY OF CHAR;
                                  VAR s2{9}: ARRAY OF CHAR;
                                  n{0}: LONGINT);
PROCEDURE strcat  * {"_strcat"}  (s1{8}: ARRAY OF CHAR;
                                  VAR s2{9}: ARRAY OF CHAR);
PROCEDURE strncat * {"_strncat"} (s1{8}: ARRAY OF CHAR;
                                  VAR s2{9}: ARRAY OF CHAR;
                                  n{0}: LONGINT);
PROCEDURE strpos  * {"_strpos"}  (s{8}: ARRAY OF CHAR;
                                  c{0}: CHAR): LONGINT;
PROCEDURE strrpos * {"_strrpos"} (s{8}: ARRAY OF CHAR;
                                  c{0}: CHAR): LONGINT;

PROCEDURE PutChar * (); (* $EntryExitCode- *)
BEGIN
  y.INLINE(016C0U,04E75U);
END PutChar;


(* /// ------------------------- "PROCEDURE sprintf()" ------------------------- *)
PROCEDURE sprintf * {"StringLib.sprintfA"} (VAR buffer{11}: ARRAY OF CHAR;
                                            fmt{8}: ARRAY OF CHAR;
                                            data{9}..: e.APTR);

PROCEDURE sprintfP * {"StringLib.sprintfA"} (buffer{11}: e.LSTRPTR;
                                             fmt{8}: ARRAY OF CHAR;
                                             data{9}..: e.APTR);

PROCEDURE sprintfA * (buffer{11}: e.LSTRPTR;
                      fmt{8}: e.LSTRPTR;
                      data{9}: e.APTR);
BEGIN
  e.OldRawDoFmt(fmt^,data,PutChar,buffer);
END sprintfA;
(* \\\ ------------------------------------------------------------------------- *)

END StringLib.
