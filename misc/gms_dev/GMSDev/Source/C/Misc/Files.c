/* Dice: dcc -l0 -mD dpk.o tags.o Files.c -o Files
**
** Run this demo with the IceBreaker debug program and observe the output.
*/

#include <proto/dpkernel.h>
#include <misc/time.h>
#include <system/debug.h>

extern APTR FILBase;

BYTE *ProgName      = "Files";
BYTE *ProgAuthor    = "Paul Manias";
BYTE *ProgDate      = "March 1998";
BYTE *ProgCopyright = "DreamWorld Productions (c) 1996-1998.  Freely distributable.";
BYTE *ProgShort     = "File demo.";

void main(void)
{
  struct Directory *dir = NULL;
  struct FileName  loc  = { ID_FILENAME, "GMS:System/" };
  struct Directory *tdir;
  struct File      *tfile;
  struct Time      *date;
  BYTE *comment;

   if (dir = InitTags(NULL,
       TAGS_DIRECTORY, NULL,
       DIRA_Source,     &loc,
       TAGEND)) {

      if (Activate(dir) IS ERR_OK) {
         DPrintF("Demo:","Directory activated, now printing dir/file list.");

         /* SetFComment(dir,"Testing SetFComment() in GMS."); */

         tdir = dir->ChildDir;
         while (tdir) {

            if (date = GetFDate(tdir)) {
               DPrintF("Demo:","Dir:  %s  Date: %d/%d/%d", tdir->Source->Name, date->Day, date->Month, date->Year);
            }

            tdir = tdir->Next;
         }

         tfile = dir->ChildFile;

         while (tfile) {

            if (date = GetFDate(tfile)) {
               DPrintF("Demo:","File: %s Date: %d/%d/%d", ((struct FileName *)tfile->Source)->Name, date->Day, date->Month, date->Year);
            }

            if (comment = GetFComment(tfile)) {
               DPrintF("Demo:","Comment: %s  Permission Flags: $%x", comment, GetFPermissions(tfile));
            }
            else {
               DPrintF("Demo:","Permission Flags: $%x", GetFPermissions(tfile));
            }

            tfile = tfile->Next;
         }
      }
      else EMsg("Sorry, could not successfully activate the directory.");
   }
   else EMsg("Could not initialise directory object.");

   Free(dir);
}

