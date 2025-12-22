-> appkeymap.e - Subroutines to copy the default keymap, modify the copy
->
-> Usage: (PTR TO keymap) appkeymap:=createAppKeyMap()
->        PROC deleteAppKeyMap(appkeymap:PTR TO keymap)
->
-> This example modifies the copied keymap by unmapping all of the numeric
-> keypad keys.  This creates a good keymap for use with either keymap.library
-> MapANSI() or commodities InvertString().  If you used a default keymap with
-> the above functions, numeric keypad raw key values would be returned for
-> keys which are available with fewer keypresses on numeric pad than on the
-> normal keyboard.  It is generally preferable to have the normal keyboard
-> raw values since many applications attach special meanings to numeric pad
-> keys.  The AlterAppKeyMap() routine in this module could easilty be
-> modified to instead set new values for numeric pad or function keys.
->
-> IMPORTANT: Do Not Use SetKeyMapDefault() unless you are a system
-> preferences editor OR an application that takes over the machine.  If you
-> want to use a customized keymap such as this in your application, open your
-> own Intuition window, attach a console device to it, and then use the
-> console device SETKEYMAP command to set your console device unit to your
-> custom keymap.

->>> Header (globals)
OPT MODULE

MODULE 'keymap',
       'devices/keymap'

ENUM ERR_NONE, ERR_ASK, ERR_LIB

RAISE ERR_ASK IF AskKeyMapDefault()=NIL,
      ERR_LIB IF OpenLibrary()=NIL

-> Raw keys we might want to remap which are the same on all keyboards
EXPORT ENUM UP_KEY=$4C, DOWN_KEY, RIGHT_KEY, LEFT_KEY, F1_KEY, F2_KEY, F3_KEY,
       F4_KEY, F5_KEY, F6_KEY, F7_KEY, F8_KEY, F9_KEY, F10_KEY

EXPORT CONST N0_KEY=$0F, N1_KEY=$1D, N2_KEY=$1E, N3_KEY=$1F, N4_KEY=$2D,
             N5_KEY=$2E, N6_KEY=$2F, N7_KEY=$3D, N8_KEY=$3E, N9_KEY=$3F

EXPORT CONST NPERIOD_KEY=$3C, NOPAREN_KEY=$5A, NCPAREN_KEY=$5B, NSLASH_KEY=$5C,
             NASTER_KEY=$5D,  NMINUS_KEY=$4A,  NPLUS_KEY=$5E,   NENTER_KEY=$43

EXPORT CONST RETURN_KEY=$44, HELP_KEY=$5F

-> Count of elements in keymap arrays
EXPORT CONST MAP_SIZE=64, TYPE_SIZE=64, CAPS_SIZE=8, REPS_SIZE=8
EXPORT CONST MAP_SIZE_P=MAP_SIZE*2, TYPE_SIZE_P=TYPE_SIZE*2,
             CAPS_SIZE_P=CAPS_SIZE*2, REPS_SIZE_P=REPS_SIZE*2

-> We allocate our Lo and Hi array pairs each as a single array
EXPORT OBJECT keyMapArrays
   lhKeyMap[MAP_SIZE_P]:ARRAY OF LONG
   lhKeyMapTypes[TYPE_SIZE_P]:ARRAY
   lhCapsable[CAPS_SIZE_P]:ARRAY
   lhRepeatable[REPS_SIZE_P]:ARRAY
ENDOBJECT

DEF karrays:PTR TO keyMapArrays, defkeymap:PTR TO keymap,
    appkeymap:PTR TO keymap, mapsize
->>>

->>> EXPORT PROC createAppKeyMap()
EXPORT PROC createAppKeyMap() HANDLE
  keymapbase:=OpenLibrary('keymap.library', 37)
  defkeymap:=NIL  -> E-Note: help with error trapping
  -> Get a pointer to the keymap which is set as the system default
  defkeymap:=AskKeyMapDefault()
  -> Allocate our KeyMap structures and arrays
  mapsize:=SIZEOF keymap+SIZEOF keyMapArrays
  appkeymap:=NIL
  appkeymap:=NewR(mapsize)
  -> Init our appkeymap fields to point to our allocated arrays.
  -> Each LH array contains a Lo and a Hi array.
  -> E-Note: the +1 in the C version means +SIZEOF keymap
  karrays:=appkeymap+SIZEOF keymap
  appkeymap.lokeymap:=karrays.lhKeyMap
  appkeymap.hikeymap:=karrays.lhKeyMap+(MAP_SIZE*(SIZEOF LONG))
  appkeymap.lokeymaptypes:=karrays.lhKeyMapTypes
  appkeymap.hikeymaptypes:=karrays.lhKeyMapTypes+TYPE_SIZE
  appkeymap.locapsable:=karrays.lhCapsable
  appkeymap.hicapsable:=karrays.lhCapsable+CAPS_SIZE
  appkeymap.lorepeatable:=karrays.lhRepeatable
  appkeymap.hirepeatable:=karrays.lhRepeatable+REPS_SIZE

  -> Copy the user's default system keymap arrays to our appkeymap arrays to
  -> get the proper keymappings for the user's keyboard.
  copyKeyMap(defkeymap, appkeymap)

  -> Now make our changes to our appkeymap
  alterAppKeyMap(appkeymap)
EXCEPT DO
  IF keymapbase THEN CloseLibrary(keymapbase)
ENDPROC appkeymap
->>>

->>> EXPORT PROC deleteAppKeyMap(appkeymap:PTR TO keymap)
EXPORT PROC deleteAppKeyMap(appkeymap:PTR TO keymap)
  IF appkeymap THEN Dispose(appkeymap)
ENDPROC
->>>

->>> PROC alterAppKeyMap(appkeymap:PTR TO keymap)
PROC alterAppKeyMap(appkeymap:PTR TO keymap)
  DEF nullkeys, keymappings:PTR TO LONG, keymaptypes, rawkeynum, i
  -> NIL terminated ARRAY of keys our application wants to remap or disable
  nullkeys:=[N0_KEY,      N1_KEY,      N2_KEY,      N3_KEY,      N4_KEY,
             N5_KEY,      N6_KEY,      N7_KEY,      N8_KEY,      N9_KEY,
             NPERIOD_KEY, NOPAREN_KEY, NCPAREN_KEY, NSLASH_KEY,
             NASTER_KEY,  NMINUS_KEY,  NPLUS_KEY,   NENTER_KEY,
             NIL]:CHAR
  -> Our application wants numeric pad keys remapped to nothing so that we can
  -> use this keymap with MapANSI and NOT get back raw codes for numeric
  -> keypad.  Alternatively (for example) you could set the types to
  -> KCF_STRING and set the mappings to point to NIL terminated strings.
  keymappings:=appkeymap.lokeymap
  keymaptypes:=appkeymap.lokeymaptypes

  i:=0
  WHILE rawkeynum:=nullkeys[i]
    -> Because we allocated each of our Lo and Hi ARRAY pairs as sequential
    -> memory, we can use the RAWKEY values directly to index into our
    -> sequential Lo/Hi ARRAY
    keymaptypes[rawkeynum]:=KCF_NOP
    INC i
  ENDWHILE
ENDPROC
->>>

->>> PROC copyKeyMap(s:PTR TO keymap, d:PTR TO keymap)
PROC copyKeyMap(s:PTR TO keymap, d:PTR TO keymap)
  DEF bb, ll:PTR TO LONG, i
  -> Copy keymap s (source) to keymap d (dest)
  ll:=s.lokeymap
  FOR i:=0 TO MAP_SIZE-1 DO d.lokeymap[i]:=ll[]++
  ll:=s.hikeymap
  FOR i:=0 TO MAP_SIZE-1 DO d.hikeymap[i]:=ll[]++

  bb:=s.lokeymaptypes
  FOR i:=0 TO TYPE_SIZE-1 DO d.lokeymaptypes[i]:=bb[]++
  bb:=s.hikeymaptypes
  FOR i:=0 TO TYPE_SIZE-1 DO d.hikeymaptypes[i]:=bb[]++

  bb:=s.locapsable
  FOR i:=0 TO CAPS_SIZE-1 DO d.locapsable[i]:=bb[]++
  bb:=s.hicapsable
  FOR i:=0 TO CAPS_SIZE-1 DO d.hicapsable[i]:=bb[]++

  bb:=s.lorepeatable
  FOR i:=0 TO REPS_SIZE-1 DO d.lorepeatable[i]:=bb[]++
  bb:=s.hirepeatable
  FOR i:=0 TO REPS_SIZE-1 DO d.hirepeatable[i]:=bb[]++
ENDPROC
->>>

