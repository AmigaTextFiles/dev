/* Dice: 1> dcc -l0 -mD dpk.o tags.o PlayMusic.c -o PlayMusic
**
** This demo plays music modules (protracker/soundtracker format).
** You can alter the filename to play whatever mod you have on
** your hard-drive.
*/

#include <proto/dpkernel.h>
#include <sound/all.h>

BYTE *ProgName      = "Play Music";
BYTE *ProgAuthor    = "Paul Manias";
BYTE *ProgDate      = "May 1998";
BYTE *ProgCopyright = "DreamWorld Productions (c) 1996-1998.  Freely distributable.";
BYTE *ProgShort     = "Plays a music module.";

struct GScreen *Screen;

/*=========================================================================*/

void main(void)
{
  struct JoyData *joy;
  struct Music *music;
  struct FileName musicfile = { ID_FILENAME, "HD1:tune2_00.mod" };
  struct Module *MusicModule;

  if (Screen = Init(Get(ID_SCREEN),NULL)) {

     if (joy = Init(Get(ID_JOYDATA),NULL)) {

        if (MusicModule = OpenModule(NULL, "music.mod")) {

           if (music = Get(ID_MUSIC)) {

              music->Source = &musicfile;

              if (Init(music,NULL)) {

                 Show(Screen);

                 Activate(music);

                 do {
                   Query(joy);
                   WaitAVBL();
                 } while (!(joy->Buttons & JD_LMB));
              }
           Free(music);
           }
        Free(MusicModule);
        }
     Free(joy);
     }
  Free(Screen);
  }
}

