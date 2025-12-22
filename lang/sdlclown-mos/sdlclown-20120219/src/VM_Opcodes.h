/* === SDL_clown v0.3.5, based on clown v0.2.5 === */
/*
   Clown Script Interpreter
      v0.2.5 - Public
    Written by Bl0ckeduser
*/

/*
 * Clown System bytecode definitions
 *
 * <opcodeName> <ParamCount> <opcodeNum>
 *
 * Compiles using a specially modified clown
 * interpreter (not included) to a very big
 * string stored in "AssemblyOutputTable.h"
 *
 * Much information on the opcodes is given
 * in VM_Binary.c.
 *
 * non-SDL_Clown opcodes were updated March 2, 2011
 */

#START
Do 4 10
PtrTo 1 12
PtrFrom 1 13
Echo 1 11
zbPtrTo 3 35
sqrt 1 40
cos 1 41
sin 1 42
tan 1 43
not 1 44
min 1 45
floor 1 46
PutChar 1 150
NewLine 0 151
InputInt 1 152
end 0 255
FlipVideo 0 70
GetMouseX 1 71
GetMouseY 1 72
DrawRect 7 73
LimitFPS 1 74
#END

