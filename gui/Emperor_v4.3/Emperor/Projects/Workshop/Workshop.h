/** some defined constants used in context with Get/SetEnvironmentVars() **/
#define INITIALVALUES   0
#define TO_DISK         1
#define TO_MEM          2
#define FROM_DISK       1
#define FROM_MEM        2

/** own prototypes **/
void GetEnvironmentVars(BYTE);
void SetEnvironmentVars(BYTE);
void GetEnvVariableFromDisk(struct Gadget *, char *, char *, BYTE);
void SetEnvVariableFromDisk(struct Gadget *, char *, BYTE);

/** own variables **/
char crashfile[200];
char alertfile[200];
STRPTR mempointer;

void Window1_CloseWindow_Event(void)
{
    if(Quitrequest1()) Emperor_QuitProgram();
}

void Startup(void)
{
    mempointer = (STRPTR) AllocMem(200, MEMF_FAST | MEMF_CLEAR);
}

void Shutdown(void)
{
    FreeMem(mempointer, 200);
}

void Window1_ShowWindow_Event(void)
{
    GetEnvironmentVars(FROM_DISK);
}

void Window1_Iconify_Event(void)
{
    Emperor_IconifyWindow_Window1();
}

void Window1_Uniconify_Event(void)
{
    Emperor_UniconifyWindow_Window1();
}

void Menu_Quit1_MenuPick_Event(void)
{
    if(Quitrequest1()) Emperor_QuitProgram();
}

void Menu_ResetToDefaults1_MenuPick_Event(void)
{
    GetEnvironmentVars(INITIALVALUES);
}

void Menu_LastSaved1_MenuPick_Event(void)
{
    GetEnvironmentVars(FROM_DISK);
}

void Menu_Restore1_MenuPick_Event(void)
{
    GetEnvironmentVars(FROM_MEM);
}

void Chooser_AddressHandling_GadgetUp_Event(void)
{
    /** turn address-gadget on or off **/
    BOOL on;

    on = stringtoint(Emperor_GetGadgetAttr(Chooser_AddressHandling));
    Emperor_SetGadgetDisabledAttr(String_Address, !on);
    if(on) GetEnvVariableFromDisk(String_Address, "PowerPC/gfxaddr", "$E0000000", FROM_MEM);
    else Emperor_SetGadgetAttr(String_Address, "$0");
}

void Getfile_CrashFile_GadgetUp_Event(void)
{
    strcpy(crashfile, GetFile1_Filerequest());
    Emperor_SetGadgetAttr(Getfile_CrashFile, crashfile);
}

void Getfile_AlertFile_GadgetUp_Event(void)
{
    strcpy(alertfile, GetFile2_Filerequest());
    Emperor_SetGadgetAttr(Getfile_AlertFile, alertfile);
}

void Button_Save_GadgetUp_Event(void)
{
    SetEnvironmentVars(TO_DISK);
    Emperor_QuitProgram();
}

void Button_Use_GadgetUp_Event(void)
{
    SetEnvironmentVars(TO_MEM);
    Emperor_QuitProgram();
}

void Button_Break_GadgetUp_Event(void)
{
    Emperor_QuitProgram();
}

void GetEnvironmentVars(BYTE which_Place)
{
    /** high-level function to get environment variables **/

    BYTE ignore = 0;

    GetEnvVariableFromDisk(Checkbox_MemProt, "PowerPC/memprot", "1", which_Place);
    GetEnvVariableFromDisk(Checkbox_NoPPC, "PowerPC/noppc", "0", which_Place);
    GetEnvVariableFromDisk(Checkbox_EarlyTerm, "PowerPC/earlyterm", "0", which_Place);
    GetEnvVariableFromDisk(Chooser_Terminator, "PowerPC/terminator", "2", which_Place);
    GetEnvVariableFromDisk(Checkbox_HideWarn, "PowerPC/hidewarning", "0", which_Place);
    GetEnvVariableFromDisk(Checkbox_NoPatch, "PowerPC/nopatch", "0", which_Place);
    GetEnvVariableFromDisk(Chooser_DebuggerHandling, "PowerPC/debug", "0", which_Place);
    GetEnvVariableFromDisk(Checkbox_Segmentinfo, "PowerPC/seginfo", "0", which_Place);
    GetEnvVariableFromDisk(Getfile_AlertFile, "PowerPC/alertfile", "CON:////WarpOS - System Message/AUTO/CLOSE/WAIT/INACTIVE", which_Place);
    GetEnvVariableFromDisk(Getfile_CrashFile, "PowerPC/crashfile", "CON:////WarpOS - PowerPC Exception/AUTO/CLOSE/WAIT/INACTIVE", which_Place);
    GetEnvVariableFromDisk(String_Address, "PowerPC/gfxaddr", "$E0000000", which_Place);
    mempointer++;
    if(*mempointer == '0') ignore = 1;
    mempointer--;

    GetEnvVariableFromDisk(Chooser_AddressHandling, "PowerPC/force", "0", which_Place);
    if(ignore) strcpy(mempointer, "-1");
    Emperor_SetGadgetAttr(Chooser_AddressHandling, inttostring(stringtoint(mempointer) + 1));
    Chooser_AddressHandling_GadgetUp_Event();
}

void GetEnvVariableFromDisk(struct Gadget *which_Gadget, char *which_Variable, char *which_Initial, BYTE which_Place)
{
    /** low-level function to get environment variables  **/
    /** +at first it asks for current directory and var  **/
    /** +second step is to ask for the value             **/
    /** +if no variable will be found, and initial value **/
    /**  is hand-over to mempointer                      **/
    /** +at last the gadget is set with the new value    **/

    char buffer[30];

    if(which_Place == FROM_DISK) strcpy(buffer, "ENV:");
    else strcpy(buffer, "ENVARC:");

    strcat(buffer, which_Variable);
    if((GetVar(buffer, mempointer, 200, GVF_GLOBAL_ONLY) == -1) || (which_Place == INITIALVALUES))
    {
        if((IoErr() == ERROR_OBJECT_NOT_FOUND) || (which_Place == INITIALVALUES))
        {
            strcpy(mempointer, which_Initial);
        }
    }
    Emperor_SetGadgetAttr(which_Gadget, mempointer);
}

void SetEnvironmentVars(BYTE which_Place)
{
    /** high-level function to set environment variables **/

    BYTE ignore;
    char buffer[30];

    SetEnvVariableFromDisk(Checkbox_MemProt, "PowerPC/memprot", which_Place);
    SetEnvVariableFromDisk(Checkbox_NoPPC, "PowerPC/noppc", which_Place);
    SetEnvVariableFromDisk(Checkbox_EarlyTerm, "PowerPC/earlyterm", which_Place);
    SetEnvVariableFromDisk(Chooser_Terminator, "PowerPC/terminator", which_Place);
    SetEnvVariableFromDisk(Checkbox_HideWarn, "PowerPC/hidewarning", which_Place);
    SetEnvVariableFromDisk(Checkbox_NoPatch, "PowerPC/nopatch", which_Place);
    SetEnvVariableFromDisk(Chooser_DebuggerHandling, "PowerPC/debug", which_Place);
    SetEnvVariableFromDisk(Checkbox_Segmentinfo, "PowerPC/seginfo", which_Place);
    SetEnvVariableFromDisk(Getfile_AlertFile, "PowerPC/alertfile", which_Place);
    SetEnvVariableFromDisk(Getfile_CrashFile, "PowerPC/crashfile", which_Place);
    SetEnvVariableFromDisk(String_Address, "PowerPC/gfxaddr", which_Place);

    ignore = stringtoint(Emperor_GetGadgetAttr(Chooser_AddressHandling)) - 1;
    if(ignore == -1) ignore = 0;

    if(which_Place == TO_DISK) strcpy(buffer, "ENV:PowerPC/force");
    else strcpy(buffer, "ENVARC:PowerPC/force");
    SetVar(buffer, inttostring(ignore), 1, GVF_GLOBAL_ONLY);
}

void SetEnvVariableFromDisk(struct Gadget *which_Gadget, char *which_Variable, BYTE which_Place)
{
    /** low-level function to set environment variables  **/
    /** +at first it asks for current directory and var  **/
    /** +second step is to get the value from gadget     **/
    /** +at last the value is saved to current directory **/

    char buffer[30];

    if(which_Place == TO_DISK) strcpy(buffer, "ENV:");
    else strcpy(buffer, "ENVARC:");
    strcat(buffer, which_Variable);

    strcpy(mempointer, Emperor_GetGadgetAttr(which_Gadget));
    SetVar(buffer, mempointer, stringlength(mempointer), GVF_GLOBAL_ONLY);
}
