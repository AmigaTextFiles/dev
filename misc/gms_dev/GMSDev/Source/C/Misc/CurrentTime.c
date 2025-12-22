/* Dice: dcc -l0 -mD dpk.o tags.o CurrentTime.c -o CurrentTime
**
** Run this demo with the IceBreaker debug program and observe the output.
*/

#include <proto/dpkernel.h>
#include <misc/time.h>
#include <system/debug.h>

BYTE *ProgName      = "Current Time";
BYTE *ProgAuthor    = "Paul Manias";
BYTE *ProgDate      = "March 1998";
BYTE *ProgCopyright = "DreamWorld Productions (c) 1996-1998.  Freely distributable.";
BYTE *ProgShort     = "Gets the system time and prints it.";

void main(void)
{
  struct Time *date;

   if (date = Init(Get(ID_TIME),NULL)) {
      if (Activate(date) IS ERR_OK) {
         DPrintF("System Date:","The date is %d/%d/%d", date->Day, date->Month, date->Year);
         DPrintF("System Date:","The time is %d:%d:%d.%d",date->Hour, date->Minute, date->Second, date->Micro);
      }
      else EMsg("Sorry, could not get the current system time.");
   }
   else EMsg("Could not initialise the Time object.");

   Free(date);
}

