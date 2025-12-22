/* Dice: dcc -l0 -mD dpk.o tags.o Keyboard.c -o Keyboard
**
** This routine tests the keyboard module routines.  Once it puts up the Screen,
** you can type things and the program will read the values and print them out
** to IceBreaker.  When your are finished, push the LMB to see the results.
**
** This is an excellent way of learning how to read the keyboard, and you can
** see how the different Qualifier flags work.
**
** If you have a PC or Amiga hooked up over a null modem, I would recommend
** sending IceBreaker output to it so that you can see the results in real-time.
*/

#include <proto/dpkernel.h>
#include <system/debug.h>
#include <input/keyboard.h>

BYTE *ProgName      = "Keyboard Reader";
BYTE *ProgAuthor    = "Paul Manias";
BYTE *ProgDate      = "February 1998";
BYTE *ProgCopyright = "DreamWorld Productions (c) 1996-1998.  Freely distributable.";
BYTE *ProgShort     = "Keyboard demo.";

void main(void)
{
  struct Keyboard *key = NULL;
  struct JoyData  *joy = NULL;
  struct GScreen  *screen = NULL;
  WORD i;

  if (screen = Init(Get(ID_SCREEN),NULL)) {
     key = Get(ID_KEYBOARD);
     key->Flags = KF_AUTOSHIFT;

     if (key = Init(key,NULL)) {
        if (joy = Init(Get(ID_JOYDATA),NULL)) {

           DMsg("Proceeding with Keyboard processor.");

           Display(screen);

           do {
              Query(key);

              for (i = 0; i < key->AmtRead; i++) {
                 DPrintF("Keyboard:","Qual: $%X, Key: %c ($%X)", key->Buffer[i].Qualifier, key->Buffer[i].Value, key->Buffer[i].Value & 0x00ff);
              }

              for (i = 0; i < 30; i++) {
                 WaitVBL();
              }

              Query(joy);
           } while (!(joy->Buttons & JD_LMB));

        Free(joy);
        }
        else EMsg("Could not initialise joystick.");

     Free(key);
     }
     else EMsg("Could not initialise keyboard.");
  Free(screen);
  }

}

