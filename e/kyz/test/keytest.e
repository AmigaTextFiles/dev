OPT OSVERSION=37,PREPROCESS

MODULE 'keymap', 'devices/inputevent', '*keypress'

CONST MAX_KEYS=512

PROC main()
  DEF keys[MAX_KEYS]:ARRAY OF keypress, len

  IF arg[]="\0"
    PutStr('Usage: keytest <a message>\n')
    RETURN 0
  ENDIF

  IF keymapbase := OpenLibrary('keymap.library', 36)
    IF (len := MapANSI(arg, StrLen(arg), keys, MAX_KEYS, NIL)) > 0 THEN
      presskeys(keys, len)
    CloseLibrary(keymapbase)
  ENDIF
ENDPROC

/****

PROC describe_keys(keys:PTR TO keypress, len)
  DEF c, q, x
  FOR x := 0 TO len-1 DO Vprintf(
    '\z\d[3]: code=\z\h[2] qual=\z\h[2]   \s\s\s\s\s\s\s\s\s\n', [
      x,
      c := keys[x].code,
      q := keys[x].qual,
      IF q AND IEQUALIFIER_LSHIFT   THEN 'LShift ' ELSE '',
      IF q AND IEQUALIFIER_RSHIFT   THEN 'RShift ' ELSE '',
      IF q AND IEQUALIFIER_CAPSLOCK THEN 'Caps '   ELSE '',
      IF q AND IEQUALIFIER_CONTROL  THEN 'Ctrl '   ELSE '',
      IF q AND IEQUALIFIER_LALT     THEN 'LAlt '   ELSE '',
      IF q AND IEQUALIFIER_RALT     THEN 'RAlt '   ELSE '',
      IF q AND IEQUALIFIER_LCOMMAND THEN 'LAmiga ' ELSE '',
      IF q AND IEQUALIFIER_RCOMMAND THEN 'RAmiga ' ELSE '',
      describe_key(c)
    ])
  PutStr('\n')
ENDPROC

PROC describe_key(key) IS
  IF (key < 0) OR (key > $67) THEN '???' ELSE ListItem([
    '`', '1', '2', '3', '4', '5', '6', '7', '8', '9', '0', '-', '=', '\\',
    'key $0e', 'Keypad 0', 'Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P',
    '[', ']', 'key $1c', 'Keypad 1', 'Keypad 2', 'Keypad 3', 'A', 'S', 'D',
    'F', 'G', 'H', 'J', 'K', 'L', ';', '\a', 'key beside return', 'key $2c',
    'Keypad 4', 'Keypad 5', 'Keypad 6', 'key beside left shift', 'Z', 'X',
    'C', 'V', 'B', 'N', 'M', ',', '.', '/', 'key $3b', 'Keypad .', 'Keypad 7',
    'Keypad 8', 'Keypad 9', 'Space', 'Backspace', 'Tab', 'Keypad Enter',
    'Return', 'Esc', 'Del', 'key $47', 'key $48', 'key $49', 'Keypad -',
    'key $4b', 'Up', 'Down', 'Right', 'Left', 'F1', 'F2', 'F3', 'F4', 'F5',
    'F6', 'F7', 'F8', 'F9', 'F10', 'Keypad (', 'Keypad )', 'Keypad /',
    'Keypad *', 'Keypad +', 'Help'
  ], key)

***/
