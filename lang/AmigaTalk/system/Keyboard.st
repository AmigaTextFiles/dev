" --------------------------------------------------------------------- "
" This class is NOT a full implementation of the keyboard.device, just  "
" a way to get keystrokes from a Window.                                "
""
"  WARNING:  You should know what you're doing to the Amiga OS before   "
"            messing with this Class, or any other System Class!        "
"" 
" Bear in mind that the keyCodes returned by the getKey method are      "
" RawKey codes, NOT ASCII!                                              "
""
" Use this Class only if you need function keys, ESC, Help or the Arrow "
" keys for some purpose, otherwise use the Console Class or the         "
" NewGadgets or NewMenus class for getting vanilla keys.                "
""
" Use the translateKey: method to get an ASCII value for the            "
" RawKey (if there is one; '?' will be returned for non-ASCII keys)     "
" --------------------------------------------------------------------- "

Class Key :Device ! keyCode keyQualifier aWindow !
[
   initialize 
     keyCode      <- 0.
     keyQualifier <- 0
|
   registerTo: thisWindow

     " Which Window will be the focus of your keyboard activity? "

     aWindow <- thisWindow
|
   getRawKey
     ^ keyCode <- <primitive 222 1 0 self>
|
   translateKey: aKeyCode

     (self keyShifted)
        ifTrue:  [^ <primitive 222 1 1 aKeyCode true>]
        ifFalse: [^ <primitive 222 1 1 aKeyCode false>]
|
   getVanillaKey
     ^ keyCode <- <primitive 222 1 2 self>
|
   keyCode 
     ^ keyCode
|
   keyQualifiers
     ^ keyQualifier     
|
   keyShifted ! mask !
   
     mask <- <primitive 23 keyQualifier (self leftShift + self rightShift + self capsLock)>.

     ^ (mask ~= 0)
|
   keyControlled ! mask !
     mask <- <primitive 23 keyQualifier (self control)>.

     ^ (mask ~= 0)
|
   keyAlternated ! mask !
     mask <- <primitive 23 keyQualifier (self leftAlt + self rightAlt)>.
     
     ^ (mask ~= 0)
|
   leftShift
     ^ 1       "IEQUALIFIER_LSHIFT"
|
   rightShift
     ^ 2       "IEQUALIFIER_RSHIFT"
|
   capsLock
     ^ 4       "IEQUALIFIER_CAPSLOCK"
|
   control
     ^ 8       "IEQUALIFIER_CONTROL"
|
   leftAlt
     ^ 16r10   "IEQUALIFIER_LALT"
|
   rightAlt
     ^ 16r20   "IEQUALIFIER_RALT"
|
   leftAmiga
     ^ 16r40   "IEQUALIFIER_LCOMMAND"
|
   rightAmiga
     ^ 16r80   "IEQUALIFIER_RCOMMAND"
|
   leftMouseButton
     ^ 16r4000 "IEQUALIFIER_LEFTBUTTON"
|
   rightMouseButton
     ^ 16r2000 "IEQUALIFIER_RBUTTON"
|
   middleMouseButton
     ^ 16r1000 "IEQUALIFIER_MIDBUTTON"
|
   numericPad
     ^ 16r100  "IEQUALIFIER_NUMERICPAD"
|
   repeatKey
     ^ 16r200  "IEQUALIFIER_REPEAT"
]
