/* Compile with:

dcc -3.1 -mRR -mi -ms -I/dev/c/include -o wbstarttest wbstarttest.c
    -L/dev/c/dlib -lwbstart

*/
#include <dos/dos.h>
#include <libraries/wbstart.h>
#include <clib/dos_protos.h>
#include <clib/wbstart_protos.h>
#include <pragmas/dos_pragmas.h>
#include <pragmas/wbstart_pragmas.h>
#include <stdlib.h>
#include <stdio.h>

extern struct Library *DOSBase;

void DoIt(const char *title, const char *dir, const char *file)
{
 printf("%s: ", title);

 if (WBStartTags(WBStart_DirectoryName, dir,
                 WBStart_Name, file,
                 TAG_DONE) == RETURN_OK) {

  printf("OK\n");

  Delay(50);

 } else

  printf("FAILED\n");
}

int main(int argc, char **argv)
{
 DoIt("Tool           (normal, no Path)    ", "WBSTART:wbsparams", "wbsparams");
 DoIt("Tool           (normal, only Assign)", NULL,                "WBSTART1:wbsparams");
 DoIt("Tool           (normal, with Path)  ", "WBSTART:",          "wbsparams/wbsparams");
 DoIt("Tool           (normal, relative)   ", "WBSTART:",          "/test/wbsparams/wbsparams");
 DoIt("Project-NoFile (normal, no Path)    ", "WBSTART:",          "Project-NoFile1");
 DoIt("Project-File   (normal, only Assign)", NULL,                "WBSTART:Project-File1");
 DoIt("Project-NoFile (normal, only Assign)", NULL,                "WBSTART:Project-NoFile1");
 DoIt("Project-File   (normal, with Path)  ", "WBSTART:",          "wbsparams/Project-File2");
 DoIt("Project-NoFile (normal, with Path)  ", "WBSTART:",          "wbsparams/Project-NoFile2");
 DoIt("Project-File   (multi,  only Assign)", NULL,                "WBSTART-MULTI:Project-File1");
 DoIt("Project-NoFile (multi,  only Assign)", NULL,                "WBSTART-MULTI:Project-NoFile1");
 DoIt("Project-File   (multi,  with Path)  ", NULL,                "WBSTART-MULTI:wbsparams/Project-File2");
 DoIt("Project-NoFile (multi,  with Path)  ", NULL,                "WBSTART-MULTI:wbsparams/Project-NoFile2");
 DoIt("Tool-Soft      (normal, no Path)    ", "WBSTART:",          "Tool-Soft1");
 DoIt("Tool-Soft      (normal, only Assign)", NULL,                "WBSTART:Tool-Soft1");
 DoIt("Tool-Soft      (normal, with Path)  ", "WBSTART:",          "soft/Tool-Soft2");
 DoIt("Tool-Soft      (normal, relative)   ", "WBSTART:",          "/test/Tool-Soft1");
 DoIt("Tool-Soft      (multi,  only Assign)", NULL,                "WBSTART-MULTI:Tool-Soft1");
 DoIt("Tool-Soft      (multi,  with Path)  ", NULL,                "WBSTART-MULTI:soft/Tool-Soft2");

 return(0);
}
