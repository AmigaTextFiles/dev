/*
 * example.c  V2.1
 *
 * Shows the usage of the library in programs
 *
 * (c) 1990-1993 Stefan Becker
 */

#include <utility/tagitem.h>
#include <utility/hooks.h>
#include <clib/dos_protos.h>
#include <clib/exec_protos.h>
#include <clib/intuition_protos.h>
#include <clib/toolmanager_protos.h>
#include <pragmas/dos_pragmas.h>
#include <pragmas/exec_pragmas.h>
#include <pragmas/intuition_pragmas.h>
#include <pragmas/toolmanager_pragmas.h>
#include <stdlib.h>
#include <stdio.h>

extern struct Library *DOSBase;
extern struct Library *IntuitionBase;
extern struct Library *SysBase;
extern struct Library *ToolManagerBase;

/* Example hook function (not used) */
__geta4 BOOL hookfunc(__A0 struct Hook *hook, __A1 struct AppMessage *msg,
                      __A2 void *object)
{
 DisplayBeep(NULL);
 Delay(25);
 return(TRUE);
}

struct Hook hook={NULL,NULL,(ULONG (*)()) hookfunc,NULL,(APTR) 1};

struct TagItem execti1[]={
                     TMOP_Arguments,  TRUE,
                     TMOP_Command,    (ULONG) "'call [] getfile()'",
                     TMOP_CurrentDir, (ULONG) "SYS:",
                     TMOP_Delay,      0,
                     TMOP_ExecType,   TMET_ARexx,
                     TMOP_HotKey,     (ULONG) "ralt a",
                     TMOP_PubScreen,  (ULONG) "TERM",
                     TMOP_ToFront,    TRUE,
                     TAG_DONE};

struct TagItem execti2[]={
                     TMOP_Arguments,  TRUE,
                     TMOP_Command,    (ULONG) "dir [] all",
                     TMOP_CurrentDir, (ULONG) "SYS:",
                     TMOP_Delay,      0,
                     TMOP_ExecType,   TMET_CLI,
                     TMOP_HotKey,     (ULONG) "ralt b",
                     TMOP_Output,     (ULONG) "CNN:WAIT",
                     TMOP_Path,       (ULONG) "C:,BOOT:,s:",
                     TMOP_Priority,   10,
                     TMOP_PubScreen,  (ULONG) "TERM",
                     TMOP_Stack,      10000,
                     TMOP_ToFront,    TRUE,
                     TAG_DONE};

struct TagItem execti3[]={
                     TMOP_Arguments,  TRUE,
                     TMOP_Command,    (ULONG) "sys:bin/DME",
                     TMOP_CurrentDir, (ULONG) "SYS:",
                     TMOP_Delay,      0,
                     TMOP_ExecType,   TMET_WB,
                     TMOP_HotKey,     (ULONG) "ralt c",
                     TMOP_Priority,   10,
                     TMOP_PubScreen,  (ULONG) "TERM",
                     TMOP_Stack,      10000,
                     TMOP_ToFront,    TRUE,
                     TAG_DONE};

struct TagItem imageti1[]={
                           TMOP_File, (ULONG) "TM:Icons/Bin",
                           TMOP_Data, NULL,
                           TAG_DONE};

struct TagItem imageti2[]={
                           TMOP_File, (ULONG) "TM:Icons/Disk",
                           TMOP_Data, NULL,
                           TAG_DONE};

struct TagItem imageti3[]={
                           TMOP_File, (ULONG) "TM:icons/MapleV.brush",
                           TMOP_Data, NULL,
                           TAG_DONE};

struct TagItem imageti4[]={
                           TMOP_File, (ULONG) "TM:Anims/test1.anim",
                           TMOP_Data, NULL,
                           TAG_DONE};

struct TagItem soundti1[]={
                           TMOP_Command, (ULONG) "id warn_general",
                           TAG_DONE};

struct TagItem soundti2[]={
                           TMOP_Command, (ULONG) "playmod qdh2:delitracker/modules/markII/MkII.Hard.pp",
                           TMOP_Port,    (ULONG) "rexx_DT",
                           TAG_DONE};

struct TagItem menuti1[]={
                          TMOP_Exec,  (ULONG) "testexec1",
                          TMOP_Sound, (ULONG) "testsound1",
                          TAG_DONE};

struct TagItem menuti2[]={
                          TMOP_Exec,  (ULONG) "testexec2",
                          TMOP_Sound, (ULONG) "testsound2",
                          TAG_DONE};

struct TagItem menuti3[]={
                          TMOP_Exec,  (ULONG) "testexec3",
                          TMOP_Sound, (ULONG) "testsound1",
                          TAG_DONE};

struct TagItem iconti1[]={
                          TMOP_Exec,     (ULONG) "testexec1",
                          TMOP_LeftEdge, 100,
                          TMOP_Image,    (ULONG) "testimage1",
                          TMOP_ShowName, TRUE,
                          TMOP_Sound,    (ULONG) "testsound1",
                          TMOP_TopEdge,  350,
                          TAG_DONE};

struct TagItem iconti2[]={
                           TMOP_Exec,     (ULONG) "testexec2",
                           TMOP_LeftEdge, 170,
                           TMOP_Image,    (ULONG) "testimage2",
                           TMOP_ShowName, FALSE,
                           TMOP_Sound,    (ULONG) "testsound2",
                           TMOP_TopEdge,  350,
                           TAG_DONE};

struct TagItem iconti3[]={
                          TMOP_Exec,     (ULONG) "testexec3",
                          TMOP_LeftEdge, 240,
                          TMOP_Image,    (ULONG) "testimage3",
                          TMOP_ShowName, TRUE,
                          TMOP_Sound,    (ULONG) "testsound1",
                          TMOP_TopEdge,  350,
                          TAG_DONE};

struct TagItem iconti4[]={
                          TMOP_Exec,     (ULONG) "testexec1",
                          TMOP_LeftEdge, 330,
                          TMOP_Image,    (ULONG) "testimage4",
                          TMOP_ShowName, FALSE,
                          TMOP_Sound,    (ULONG) "testsound2",
                          TMOP_TopEdge,  350,
                          TAG_DONE};

char *tool1[]={"testexec1","testimage1","testsound1"};
char *tool2[]={"testexec2","testimage2","testsound2"};
char *tool3[]={"testexec3","testimage3","testsound1"};
char *tool4[]={"testexec1","testimage4","testsound2"};
struct TagItem dockti1[]={
                         TMOP_LeftEdge,  80,
                         TMOP_TopEdge,   200,
                         TMOP_Activated, TRUE,
                         TMOP_Centered,  FALSE,
                         TMOP_Columns,   3,
                         TMOP_FrontMost, TRUE,
                         TMOP_HotKey,    (ULONG) "rcommand rshift d",
                         TMOP_Vertical,  TRUE,
                         TMOP_Text,      FALSE,
                         TMOP_Title,     (ULONG) "Blaaaa 1",
                         TMOP_Pattern,   TRUE,
                         TMOP_Tool,      (ULONG) tool1,
                         TMOP_Tool,      (ULONG) tool2,
                         TMOP_Tool,      (ULONG) tool3,
                         TMOP_Tool,      (ULONG) tool4,
                         TAG_DONE};

struct TextAttr ta={"topaz.font",20,0,0};

struct TagItem dockti2[]={
                         TMOP_LeftEdge,  80,
                         TMOP_TopEdge,   300,
                         TMOP_Activated, TRUE,
                         TMOP_Centered,  TRUE,
                         TMOP_Columns,   2,
                         TMOP_FrontMost, TRUE,
                         TMOP_HotKey,    (ULONG) "rcommand rshift e",
                         TMOP_Vertical,  TRUE,
                         TMOP_Text,      TRUE,
                         TMOP_Title,     (ULONG) "Blaaaa 2",
                         TMOP_Tool,      (ULONG) tool1,
                         TMOP_Tool,      (ULONG) tool2,
                         TMOP_Tool,      (ULONG) tool3,
                         TMOP_Tool,      (ULONG) tool4,
                         TMOP_Menu,      TRUE,
                         TMOP_Font,      (ULONG) &ta,
                         TAG_DONE};

struct TagItem dockti3[]={
                         TMOP_LeftEdge,  300,
                         TMOP_TopEdge,   200,
                         TMOP_Activated, TRUE,
                         TMOP_Centered,  FALSE,
                         TMOP_Columns,   2,
                         TMOP_FrontMost, TRUE,
                         TMOP_HotKey,    (ULONG) "rcommand rshift f",
                         TMOP_Vertical,  FALSE,
                         TMOP_Text,      FALSE,
                         TMOP_Tool,      (ULONG) tool1,
                         TMOP_Tool,      (ULONG) tool2,
                         TMOP_Tool,      (ULONG) tool3,
                         TMOP_Tool,      (ULONG) tool4,
                         TAG_DONE};

struct TagItem dockti4[]={
                         TMOP_LeftEdge,  300,
                         TMOP_TopEdge,   300,
                         TMOP_Activated, TRUE,
                         TMOP_Centered,  TRUE,
                         TMOP_Columns,   2,
                         TMOP_FrontMost, TRUE,
                         TMOP_HotKey,    (ULONG) "rcommand rshift g",
                         TMOP_Vertical,  FALSE,
                         TMOP_Text,      TRUE,
                         TMOP_Tool,      (ULONG) tool1,
                         TMOP_Tool,      (ULONG) tool2,
                         TMOP_Tool,      (ULONG) tool3,
                         TMOP_Tool,      (ULONG) tool4,
                         TAG_DONE};

struct TagItem dockti5[]={
                         TMOP_LeftEdge,  450,
                         TMOP_TopEdge,   200,
                         TMOP_Activated, TRUE,
                         TMOP_Centered,  FALSE,
                         TMOP_PopUp,     TRUE,
                         TMOP_Columns,   2,
                         TMOP_FrontMost, TRUE,
                         TMOP_HotKey,    (ULONG) "rcommand rshift h",
                         TMOP_Vertical,  TRUE,
                         TMOP_Text,      FALSE,
                         TMOP_Tool,      (ULONG) tool1,
                         TMOP_Tool,      (ULONG) tool2,
                         TMOP_Tool,      (ULONG) tool3,
                         TMOP_Tool,      (ULONG) tool4,
                         TAG_DONE};

struct TagItem dockti6[]={
                         TMOP_LeftEdge,  450,
                         TMOP_TopEdge,   300,
                         TMOP_Activated, TRUE,
                         TMOP_Centered,  TRUE,
                         TMOP_PopUp,     TRUE,
                         TMOP_Columns,   2,
                         TMOP_FrontMost, TRUE,
                         TMOP_HotKey,    (ULONG) "rcommand rshift i",
                         TMOP_Vertical,  TRUE,
                         TMOP_Text,      TRUE,
                         TMOP_Tool,      (ULONG) tool1,
                         TMOP_Tool,      (ULONG) tool2,
                         TMOP_Tool,      (ULONG) tool3,
                         TMOP_Tool,      (ULONG) tool4,
                         TAG_DONE};

int main(int argc, char *argv[])
{
 void *handle;

 if (handle=AllocTMHandle()) {
  printf("handle: 0x%08lx\n",handle);

  CreateTMObjectTagList(handle,"testexec1",TMOBJTYPE_EXEC,execti1);
  CreateTMObjectTagList(handle,"testexec2",TMOBJTYPE_EXEC,execti2);
  CreateTMObjectTagList(handle,"testexec3",TMOBJTYPE_EXEC,execti3);
  CreateTMObjectTagList(handle,"testimage1",TMOBJTYPE_IMAGE,imageti1);
  CreateTMObjectTagList(handle,"testimage2",TMOBJTYPE_IMAGE,imageti2);
  CreateTMObjectTagList(handle,"testimage3",TMOBJTYPE_IMAGE,imageti3);
  CreateTMObjectTagList(handle,"testimage4",TMOBJTYPE_IMAGE,imageti4);
  CreateTMObjectTagList(handle,"testsound1",TMOBJTYPE_SOUND,soundti1);
  CreateTMObjectTagList(handle,"testsound2",TMOBJTYPE_SOUND,soundti2);
  CreateTMObjectTagList(handle,"testmenu1",TMOBJTYPE_MENU,menuti1);
  CreateTMObjectTagList(handle,"testmenu2",TMOBJTYPE_MENU,menuti2);
  CreateTMObjectTagList(handle,"testmenu3",TMOBJTYPE_MENU,menuti3);
  CreateTMObjectTagList(handle,"testicon1",TMOBJTYPE_ICON,iconti1);
  CreateTMObjectTagList(handle,"testicon2",TMOBJTYPE_ICON,iconti2);
  CreateTMObjectTagList(handle,"testicon3",TMOBJTYPE_ICON,iconti3);
  CreateTMObjectTagList(handle,"testicon4",TMOBJTYPE_ICON,iconti4);
  CreateTMObjectTagList(handle,"testdock1",TMOBJTYPE_DOCK,dockti1);
  CreateTMObjectTagList(handle,"testdock2",TMOBJTYPE_DOCK,dockti2);
  CreateTMObjectTagList(handle,"testdock3",TMOBJTYPE_DOCK,dockti3);
  CreateTMObjectTagList(handle,"testdock4",TMOBJTYPE_DOCK,dockti4);
  CreateTMObjectTagList(handle,"testdock5",TMOBJTYPE_DOCK,dockti5);
  CreateTMObjectTagList(handle,"testdock6",TMOBJTYPE_DOCK,dockti6);

  Wait(0xF000);

  FreeTMHandle(handle);
 }
 exit(0);
}
