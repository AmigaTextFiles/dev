#include <iostream.h>
#include <iomanip.h>
#include <fstream.h>

void ReadOut(void);
void AllocListbrowserNodes(struct List *, char labels[256][41]);

char *devsdir[] = { "DEVS:Datatypes", "DEVS:DOSDrivers", "DEVS:Keymaps", "DEVS:Monitors", "DEVS:Printers", NULL };
char *storagedir[] = { "SYS:Storage/Datatypes", "SYS:Storage/DOSDrivers", "SYS:Storage/Keymaps", "SYS:Storage/Monitors", "SYS:Storage/Printers", NULL };
char devsentry[5][256][41];
char storageentry[5][256][41];
BYTE devsitems[5] = { 0, 0, 0, 0, 0 };
BYTE storageitems[5] = { 0, 0, 0, 0, 0 };
struct FileLock *lock;
struct FileInfoBlock *f_info;
struct List devslist[5];
struct List storagelist[5];

void Window1_CloseWindow_Event(void)
{
    if(Quitrequest1()) Emperor_QuitProgram();
}

void Menu_Quit_MenuPick_Event(void)
{
    Window1_CloseWindow_Event();
}

void Menu_Information_MenuPick_Event(void)
{
    Inforequest1();
}

void Menu_DataTypes_MenuPick_Event(void)
{
    Emperor_SetGadgetAttr(Chooser1, "0");
    Chooser1_GadgetUp_Event();
}

void Menu_DOSDrivers_MenuPick_Event(void)
{
    Emperor_SetGadgetAttr(Chooser1, "1");
    Chooser1_GadgetUp_Event();
}

void Menu_Keymaps_MenuPick_Event(void)
{
    Emperor_SetGadgetAttr(Chooser1, "2");
    Chooser1_GadgetUp_Event();
}

void Menu_Monitors_MenuPick_Event(void)
{
    Emperor_SetGadgetAttr(Chooser1, "3");
    Chooser1_GadgetUp_Event();
}

void Menu_Printers_MenuPick_Event(void)
{
    Emperor_SetGadgetAttr(Chooser1, "4");
    Chooser1_GadgetUp_Event();
}

void Window1_ShowWindow_Event(void)
{
    Chooser1_GadgetUp_Event();
}

void Startup(void)
{
    lock = (struct FileLock *) AllocMem(sizeof(struct FileLock), MEMF_CHIP | MEMF_CLEAR);
    f_info = (struct FileInfoBlock *) AllocMem(sizeof(struct FileInfoBlock), MEMF_CHIP | MEMF_CLEAR);
    ReadOut();
}

void Shutdown(void)
{
    FreeMem(lock, sizeof(struct FileLock));
    FreeMem(f_info, sizeof(struct FileInfoBlock));
}

void Listbrowser1_GadgetUp_Event(void)
{
    char buffer[200];
    BYTE type, entry;

    type = stringtoint(Emperor_GetGadgetAttr(Chooser1));
    entry = stringtoint(Emperor_GetGadgetAttr(Listbrowser1));
    strcpy(buffer, devsdir[type]);
    strcat(buffer, "/");
    strcat(buffer, devsentry[type][entry]);
    strcat(buffer, "  ->  ");
    strcat(buffer, storagedir[type]);
    Emperor_SetGadgetDisabledAttr(Button1, FALSE);
    Emperor_SetGadgetDisabledAttr(Button2, TRUE);
    Emperor_SetGadgetDisabledAttr(Button4, FALSE);
    Emperor_SetGadgetAttr(Listbrowser2, inttostring(-1));
    Emperor_SetGadgetAttr(String1, buffer);
}

void Listbrowser2_GadgetUp_Event(void)
{
    char buffer[200];
    BYTE type, entry;

    type = stringtoint(Emperor_GetGadgetAttr(Chooser1));
    entry = stringtoint(Emperor_GetGadgetAttr(Listbrowser2));
    strcpy(buffer, storagedir[type]);
    strcat(buffer, "/");
    strcat(buffer, storageentry[type][entry]);
    strcat(buffer, "  ->  ");
    strcat(buffer, devsdir[type]);
    Emperor_SetGadgetDisabledAttr(Button1, TRUE);
    Emperor_SetGadgetDisabledAttr(Button2, FALSE);
    Emperor_SetGadgetDisabledAttr(Button4, FALSE);
    Emperor_SetGadgetAttr(Listbrowser1, inttostring(-1));
    Emperor_SetGadgetAttr(String1, buffer);
}

void Chooser1_GadgetUp_Event(void)
{
    BYTE type;

    type = stringtoint(Emperor_GetGadgetAttr(Chooser1));
    Emperor_SetGadgetAttrComplex(Listbrowser1, LISTBROWSER_Labels, (STRPTR) &devslist[type]);
    Emperor_SetGadgetAttrComplex(Listbrowser2, LISTBROWSER_Labels, (STRPTR) &storagelist[type]);
    Emperor_SetGadgetDisabledAttr(Button1, TRUE);
    Emperor_SetGadgetDisabledAttr(Button2, TRUE);
    Emperor_SetGadgetDisabledAttr(Button4, TRUE);
    Emperor_SetGadgetAttr(String1, NULL);
}

void Button1_GadgetUp_Event(void)
{
    char buffer[200];
    BYTE type, entry;

    type = stringtoint(Emperor_GetGadgetAttr(Chooser1));
    entry = stringtoint(Emperor_GetGadgetAttr(Listbrowser1));
    strcpy(buffer, "Run >NIL: C:Copy ");
    strcat(buffer, devsdir[type]);
    strcat(buffer, "/");
    strcat(buffer, devsentry[type][entry]);
    strcat(buffer, "#? ");
    strcat(buffer, storagedir[type]);
    Execute(buffer, NULL, NULL);
    strcpy(buffer, "Run >NIL: C:Delete ");
    strcat(buffer, devsdir[type]);
    strcat(buffer, "/");
    strcat(buffer, devsentry[type][entry]);
    strcat(buffer, "#?");
    Execute(buffer, NULL, NULL);
    ReadOut();
    Chooser1_GadgetUp_Event();
}

void Button2_GadgetUp_Event(void)
{
    char buffer[200];
    BYTE type, entry;

    type = stringtoint(Emperor_GetGadgetAttr(Chooser1));
    entry = stringtoint(Emperor_GetGadgetAttr(Listbrowser2));
    strcpy(buffer, "Run >NIL: C:Copy ");
    strcat(buffer, storagedir[type]);
    strcat(buffer, "/");
    strcat(buffer, storageentry[type][entry]);
    strcat(buffer, "#? ");
    strcat(buffer, devsdir[type]);
    Execute(buffer, NULL, NULL);
    strcpy(buffer, "Run >NIL: C:Delete ");
    strcat(buffer, storagedir[type]);
    strcat(buffer, "/");
    strcat(buffer, storageentry[type][entry]);
    strcat(buffer, "#?");
    Execute(buffer, NULL, NULL);
    ReadOut();
    Chooser1_GadgetUp_Event();
}

void Button3_GadgetUp_Event(void)
{
    ReadOut();
    Chooser1_GadgetUp_Event();
}

void Button4_GadgetUp_Event(void)
{
    char buffer[200];
    BYTE type, entry1, entry2;

    type = stringtoint(Emperor_GetGadgetAttr(Chooser1));
    entry1 = stringtoint(Emperor_GetGadgetAttr(Listbrowser1));
    entry2 = stringtoint(Emperor_GetGadgetAttr(Listbrowser2));
    if(entry1 != -1)
    {
        strcpy(buffer, "Run >NIL: C:Delete ");
        strcat(buffer, devsdir[type]);
        strcat(buffer, "/");
        strcat(buffer, devsentry[type][entry1]);
        strcat(buffer, "#?");
        Execute(buffer, NULL, NULL);
    }
    if(entry2 != -1)
    {
        strcpy(buffer, "Run >NIL: C:Delete ");
        strcat(buffer, storagedir[type]);
        strcat(buffer, "/");
        strcat(buffer, storageentry[type][entry2]);
        strcat(buffer, "#?");
        Execute(buffer, NULL, NULL);
    }
    ReadOut();
    Chooser1_GadgetUp_Event();
}

void ReadOut(void)
{
    BYTE i = 0, j;

    for(i = 0;i < 5;i++)
    {
        for(j = 0;j <= devsitems[i];j++)
        {
            devsentry[i][j][0] = NULL;
        }
        for(j = 0;j <= storageitems[i];j++)
        {
            storageentry[i][j][0] = NULL;
        }
        devsitems[i] = 0;
        storageitems[i] = 0;

        if(lock = (struct FileLock *) Lock(devsdir[i], ACCESS_READ))
        {
            if(Examine((BPTR) lock, f_info))
            {
                while(ExNext((BPTR) lock, f_info))
                {
                    if(!strstr(f_info->fib_FileName, ".info"))
                    {
                        strcpy(devsentry[i][devsitems[i]], f_info->fib_FileName);
                        devsitems[i]++;
                    }
                    if(devsitems[i] == 255) break;
                }
            }
            UnLock((BPTR) lock);
        }
        if(lock = (struct FileLock *) Lock(storagedir[i], ACCESS_READ))
        {
            if(Examine((BPTR) lock, f_info))
            {
                while(ExNext((BPTR) lock, f_info))
                {
                    if(!strstr(f_info->fib_FileName, ".info"))
                    {
                        strcpy(storageentry[i][storageitems[i]], f_info->fib_FileName);
                        storageitems[i]++;
                    }
                    if(storageitems[i] == 255) break;
                }
            }
            UnLock((BPTR) lock);
        }

        AllocListbrowserNodes(&devslist[i], devsentry[i]);
        AllocListbrowserNodes(&storagelist[i], storageentry[i]);
    }
}

void AllocListbrowserNodes(struct List *list, char labels[256][41])
{
  struct Node *node;
  WORD i = 0;

  NewList(list);
  while(labels[i][0] != NULL)
  {
    node = AllocListBrowserNode(1, LBNCA_CopyText, TRUE, LBNCA_Text, labels[i], TAG_DONE);
    AddTail(list, node);
    i++;
  }
}

