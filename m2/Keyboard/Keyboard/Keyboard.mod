IMPLEMENTATION MODULE Keyboard;
(*******************************************************************************
Name         : Keyboard.mod
Version      : 1.0
Purpose      : Enables access to RAWKEY events via Intuition.
Author       : Peter Graham Evans. Translation into Modula-2 of a program
             : in the C language by Fabbian G. Dufoe, III on Fish Disk 291.
Language     : Modula-2. Used TDI Modula-2 version 3.01a which I received
             : in the first quarter 1988 from M2S in Bristol, England.
Status       : This is a public domain program and thus can be used for
             : commercial or non commerial purposes.
Date Started : 12/MAR/90.
Date Complete: 25/MAR/90.
Modified     : 18/MAR/90.Renamed the procedures.
             : 19/MAR/90.fixed up some code incorrectly translated.
             : 22/MAR/90.removed some extraneous variables;changed the way
             :           the ConsoleDevice was set up
             : 25/MAR/90.eliminated the need for an InputEventPtr;changed
             :           many CASE statements that I had blindly translated
             :           into Modula-2 into IF statements cutting down size
             :           of link file considerably. In fact I saved 36
             :           bytes for each one.
*******************************************************************************)

(* Based on the C Language source code Keyboard.h and Keyboard.c on the
public domain Fish Disk library disk 291 by Fabbian Dufoe. *)

FROM ConsoleDevice IMPORT ConsoleBase, ConsoleName, KeyMapPtr, RawKeyConvert;
FROM Devices       IMPORT CloseDevice, DevicePtr, OpenDevice;
FROM InputEvents   IMPORT IEQualifierSet, InputEvent, rawKey, UpPrefix;
FROM Intuition     IMPORT IDCMPFlagSet, IntuiMessagePtr, RawKey;
FROM IO            IMPORT IOStdReq, IOStdReqPtr;
FROM SYSTEM        IMPORT ADDRESS, ADR, BYTE, NULL;

VAR
  Console       : IOStdReq;
  Consoledevice : DevicePtr;

PROCEDURE OpenKey() : INTEGER;
(* For information on OpenDevice see pB-27 of ROM Kernal Manual
where it states "A unit of -1 indicates that no actual console is to
be opened; this is used to get a pointer to the device library vector.".
   Unfortunately TDI's implementation of OpenDevice requires the
unit to be a LONGCARD. This is incorrect and we have to force a -1 in here.*)

TYPE
  ConvertRec = RECORD
                 CASE : CARDINAL OF
                   1 : pseudolongcard : LONGCARD;  | (* this will have
                                                     -1 moved into it! *)
                   2 : longint        : LONGINT;
                 END;
               END; (* record *)
VAR
  Convert        : ConvertRec;

BEGIN

  Convert.longint:=-1; (* Place -1 in the long integer *)

  IF OpenDevice(ConsoleName, Convert.pseudolongcard, ADR(Console), 0)
                                                                <> 0 THEN
    RETURN -1;
  END;
  Consoledevice:=Console.ioReq.ioDevice;
  ConsoleBase:=ADDRESS(Consoledevice); (* Note that ConsoleBase is the
                                       Modula-2 name for C's ConsoleDevice *)
  (* The book Amiga C for Advanced Programmers by Bleek, Jennrich, Schulz
  published by Data Becker GmbH  ISBN 0-916439-88-7 on page 406 states
    "The RawKeyConvert function is part of the console device. This
    function can be accessed by selecting a pointer to console base
    without opening the console device first, because the function can
    be called like a library function. You receive the pointer to console
    device by calling:
    OpenConsole("console.device",-1L,IOStd,0L);  .....".
  *)
  RETURN 0;
END OpenKey;

PROCEDURE CloseKey;
BEGIN
  IF Consoledevice <> NULL THEN
    CloseDevice(ADR(Console));
  END;
END CloseKey;

PROCEDURE DeadKeyConvert(VAR KeyMessage : IntuiMessagePtr; (* in     *)
                         VAR KeyBuffer  : ARRAY OF CHAR;   (* in/out *)
                             BufferSize : INTEGER;         (* in     *)
                         VAR KeyMap     : KeyMapPtr        (* in     *) ) :
                                                           LONGINT;
(* FUNCTION
      This function converts an Intuition RAWKEY message to the kind of
      keycodes returned by the Console Device.  It uses the Console Device's
      RawKeyConvert() function.

   INPUT
      KeyMessage - a pointer to the intuition message
      KeyBuffer - a pointer to the buffer the user supplied for keycodes
      BufferSize - the size of KeyBuffer
      KeyMap - a pointer to a KeyMap structure to be used for the
               conversion.  A NULL value selects the default KeyMap.

   RESULTS
      The function returns -2 if the message was not a RAWKEY class
      message.  If the number of keycodes produced was greater than
      BufferSize the function returns -1.  Otherwise the function returns
      the number of keycodes it placed in the buffer.
*)
VAR
  addressptr    : POINTER TO ADDRESS;
  Inputevent    : InputEvent;
BEGIN
  IF KeyMessage^.Class <> IDCMPFlagSet{RawKey} THEN
    RETURN -2;
  END;
  addressptr:=KeyMessage^.IAddress;
  WITH Inputevent DO
    ieNextEvent:=NULL;
    ieClass    :=rawKey;
    ieSubClass :=BYTE(0);
    ieCode     :=KeyMessage^.Code;
    ieQualifier:=IEQualifierSet(KeyMessage^.Qualifier);
    ieAddr     :=addressptr^;
  END; (* WITH *)
  RETURN RawKeyConvert(ADR(Inputevent), ADR(KeyBuffer),
                        LONGCARD(BufferSize), KeyMap);
END DeadKeyConvert;

PROCEDURE ReadKey(VAR KeyMessage : IntuiMessagePtr; (* in  *)
                  VAR KeyID      : INTEGER;         (* out *)
                  VAR KeyMap     : KeyMapPtr        (* in  *) ):INTEGER;
(* FUNCTION
      This routine converts an Intuition RAWKEY message to an ASCII
      character or an integer code identifying the special key pressed.

   INPUT
      KeyMessage - a pointer to the Intuition message
      KeyID - a pointer used to return the ID code of a function key
      KeyMap - a pointer to the keymap structure to be used for the
               conversion.  A NULL pointer specifies the default keymap.

   RETURNS
      If the function converts a RAWKEY message to an ASCII character it
      returns that character.  It returns zero if a special key was pressed
      and it places the key's ID code in the integer pointed to by KeyID.
      If the message was not a RAWKEY class message or if it was a "key up"
      message ReadKey() returns -2.  The calling program can ignore any
      calls which return -2.  If it fails it returns -1.
*)
VAR
  actual    : LONGINT;
  KeyBuffer : ARRAY [0..9] OF CHAR;
BEGIN
  KeyID:=0;
  IF KeyMessage^.Class <> IDCMPFlagSet{RawKey} THEN
    RETURN -2;
  END;
      (* If it's not a RAWKEY message we'll just ignore it.  We tell the
         caller it can ignore it, too. *)
  IF (BITSET(KeyMessage^.Code) * BITSET(UpPrefix)) = BITSET(UpPrefix) THEN
    RETURN -2;
  END;
      (* If it's a key up message we'll ignore it and tell the caller to
         ignore it, too. *)
  actual:=DeadKeyConvert(KeyMessage, KeyBuffer, 10, KeyMap);
  IF actual = 1 THEN
    RETURN INTEGER(KeyBuffer[0]);
      (* If DeadKeyConvert() converted the message to a single code we can
         return it to the caller. *)
  END;
  IF actual = -1 THEN
    RETURN -1; (* If DeadKeyConvert overflowed its buffer there is error *)
  END;
   IF KeyBuffer[0] = CSI THEN
      CASE KeyBuffer[1] OF
      space:
         CASE KeyBuffer[2] OF
         '@':
            KeyID:=KSRIGHT;       |
         'A':
            KeyID:=KSLEFT;
         ELSE
         END;                  |
      '?':
         IF KeyBuffer[2] = '~' THEN
           KeyID:=KHELP;
         END;                  |
      '0':
         IF KeyBuffer[2] = '~' THEN
           KeyID:=KF1;
         END;                  |
      '1':
         CASE KeyBuffer[2] OF
         '~':
            KeyID:=KF2;         |
         '0':
            IF KeyBuffer[3] = '~' THEN
              KeyID:=KSF1;
            END;                |
         '1':
            IF KeyBuffer[3] = '~' THEN
              KeyID:=KSF2;
            END;                |
         '2':
            IF KeyBuffer[3] = '~' THEN
              KeyID:=KSF3;
            END;                |
         '3':
            IF KeyBuffer[3] = '~' THEN
              KeyID:=KSF4;
            END;                |
         '4':
            IF KeyBuffer[3] = '~' THEN
              KeyID:=KSF5;
            END;                |
         '5':
            IF KeyBuffer[3] = '~' THEN
              KeyID:=KSF6;
            END;                |
         '6':
            IF KeyBuffer[3] = '~' THEN
              KeyID:=KSF7;
            END;                |
         '7':
            IF KeyBuffer[3] = '~' THEN
              KeyID:=KSF8;
            END;                |
         '8':
            IF KeyBuffer[3] = '~' THEN
              KeyID:=KSF9;
            END;                |
         '9':
            IF KeyBuffer[3] = '~' THEN
              KeyID:=KSF10;
            END;
         ELSE
         END;                  |
      '2':
         IF KeyBuffer[2] = '~' THEN
           KeyID:=KF3;
         END;                  |
      '3':
         IF KeyBuffer[2] = '~' THEN
           KeyID:=KF4;
         END;                  |
      '4':
         IF KeyBuffer[2] = '~' THEN
           KeyID:=KF5;
         END;                  |
      '5':
         IF KeyBuffer[2] = '~' THEN
           KeyID:=KF6;
         END;                  |
      '6':
         IF KeyBuffer[2] = '~' THEN
           KeyID:=KF7;
         END;                  |
      '7':
         IF KeyBuffer[2] = '~' THEN
           KeyID:=KF8;
         END;                  |
      '8':
         IF KeyBuffer[2] = '~' THEN
           KeyID:=KF9;
         END;                  |
      '9':
         IF KeyBuffer[2] = '~' THEN
           KeyID:=KF10;
         END;                  |
      'A':
         KeyID:=KUP;           |
      'B':
         KeyID:=KDOWN;         |
      'C':
         KeyID:=KRIGHT;        |
      'D':
         KeyID:=KLEFT;         |
      'S':
         KeyID:=KSDOWN;        |
      'T':
         KeyID:=KSUP;
      ELSE
      END;
   ELSE
   END;
   IF KeyID = 0 THEN
     RETURN -1;
   ELSE
     RETURN 0;
   END;
END ReadKey;

END Keyboard.
