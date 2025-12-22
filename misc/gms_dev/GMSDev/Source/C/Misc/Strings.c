/* Dice: 1> dcc -l0 -mD dpk.o tags.o Strings.c -o Strings
**
** Demonstrates the Strings module.  You need to be running IceBreaker
** to see the output.
*/

#include <proto/dpkernel.h>
#include <pragmas/strings_pragmas.h>

BYTE *ProgName      = "Strings";
BYTE *ProgAuthor    = "Paul Manias";
BYTE *ProgDate      = "July 1998";
BYTE *ProgCopyright = "DreamWorld Productions (c) 1996-1998.  Freely distributable.";
BYTE *ProgShort     = "Strings Demonstration.";

struct Module *StringsMod = NULL;
APTR STRBase;

BYTE Hello[]  = { "Hello World!" };
BYTE Games[]  = { "Games " };
BYTE Master[] = { "Master" };
BYTE *String;

LONG main(void) {
  if (StringsMod = OpenModule(MOD_STRINGS,"strings.mod")) {
     STRBase = StringsMod->ModBase;

     DPrintF("!Demo:","String manipulations now follow...");

     if (String = StrClone(Hello,MEM_DATA|MEM_PRIVATE)) {
        DPrintF("!StrClone:","%s",String);
        FreeMemBlock(String);
     }

     if (String = IntToStr(4096,NULL)) {
        DPrintF("!IntToStr:","%s",String);
        DPrintF("!StrToInt:","%ld",StrToInt(String));
        FreeMemBlock(String);
     }

     DPrintF("!StrLength:","%d : %s", StrLength(Hello), Hello);

     if (String = StrMerge(Games,Master,NULL)) {
        DPrintF("!StrMerge:","%s",String);
        FreeMemBlock(String);
     }

     StrLower(Hello);
     DPrintF("!StrLower:","%s",Hello);

     StrUpper(Hello);
     DPrintF("!StrUpper:","%s",Hello);

     StrCapitalize(Hello);
     DPrintF("!StrCapitalize:","%s",Hello);
  }

  Free(StringsMod);
  return(ERR_OK);
}

