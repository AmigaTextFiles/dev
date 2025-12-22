void Calculate(void);
void AllocListbrowserNodesExtra(struct List *, char labels[96][5], WORD);
char *shift_comma_in_string(char *, const char *, UBYTE);
STRPTR floattostring(DOUBLE, UBYTE);

char string[5][96][5];
struct IntuiText WindowIntuitext;
struct List Listbrowser_List_E6;
struct List Listbrowser_List_E12;
struct List Listbrowser_List_E24;
struct List Listbrowser_List_E48;
struct List Listbrowser_List_E96;
struct RastPort *WindowRastport;

void Startup(void)
{
    /** This function calculates the values    **/
    /** later shown within the listbrowser.    **/
    /** Each value is calculated by extracting **/
    /** the m-th root of 10, a countervalue n  **/
    /** while 0 <= n < m, that powers the root **/
    /** and m is the nominalvalue 6 * 2^(0..4) **/
    /** Also here are the single functions for **/
    /** getting the colours to draw the layout **/

    DOUBLE i;

    NewList(&Listbrowser_List_E6);
    NewList(&Listbrowser_List_E12);
    NewList(&Listbrowser_List_E24);
    NewList(&Listbrowser_List_E48);
    NewList(&Listbrowser_List_E96);
    for(i = 0;i <  6;i++)
    {
      strcpy(string[0][(ULONG) i], floattostring(pow(10, i / 6), 1));
      strcat(string[0][(ULONG) i], "0");
    }
    for(i = 0;i < 12;i++)
    {
      strcpy(string[1][(ULONG) i], floattostring(pow(10, i / 12), 1));
      strcat(string[1][(ULONG) i], "0");
    }
    for(i = 0;i < 24;i++)
    {
      strcpy(string[2][(ULONG) i], floattostring(pow(10, i / 24), 1));
      strcat(string[2][(ULONG) i], "0");
    }
    for(i = 0;i < 48;i++) strcpy(string[3][(ULONG) i], floattostring(pow(10, i / 48), 2));
    for(i = 0;i < 96;i++) strcpy(string[4][(ULONG) i], floattostring(pow(10, i / 96), 2));
    strcpy(string[0][3],  "3.30");
    strcpy(string[0][4],  "4.70");
    strcpy(string[1][5],  "2.70");
    strcpy(string[1][6],  "3.30");
    strcpy(string[1][7],  "3.90");
    strcpy(string[1][8],  "4.70");
    strcpy(string[1][11], "8.20");
    strcpy(string[2][10], "2.70");
    strcpy(string[2][11], "3.00");
    strcpy(string[2][12], "3.30");
    strcpy(string[2][13], "3.60");
    strcpy(string[2][14], "3.90");
    strcpy(string[2][15], "4.30");
    strcpy(string[2][16], "4.70");
    strcpy(string[2][22], "8.20");
    AllocListbrowserNodesExtra(&Listbrowser_List_E6,  string[0],  6);
    AllocListbrowserNodesExtra(&Listbrowser_List_E12, string[1], 12);
    AllocListbrowserNodesExtra(&Listbrowser_List_E24, string[2], 24);
    AllocListbrowserNodesExtra(&Listbrowser_List_E48, string[3], 48);
    AllocListbrowserNodesExtra(&Listbrowser_List_E96, string[4], 96);
    sw = ObtainBestPen(Screen1->ViewPort.ColorMap, 0x00000000, 0x00000000, 0x00000000, OBP_Precision, PRECISION_IMAGE, TAG_DONE);
    br = ObtainBestPen(Screen1->ViewPort.ColorMap, 0x96000000, 0x3C000000, 0x00000000, OBP_Precision, PRECISION_IMAGE, TAG_DONE);
    rt = ObtainBestPen(Screen1->ViewPort.ColorMap, 0xFFFFFFFF, 0x00000000, 0x00000000, OBP_Precision, PRECISION_IMAGE, TAG_DONE);
    or = ObtainBestPen(Screen1->ViewPort.ColorMap, 0xFFFFFFFF, 0x96000000, 0x32000000, OBP_Precision, PRECISION_IMAGE, TAG_DONE);
    ge = ObtainBestPen(Screen1->ViewPort.ColorMap, 0xFFFFFFFF, 0xFFFFFFFF, 0x00000000, OBP_Precision, PRECISION_IMAGE, TAG_DONE);
    gn = ObtainBestPen(Screen1->ViewPort.ColorMap, 0x00000000, 0xFFFFFFFF, 0x00000000, OBP_Precision, PRECISION_IMAGE, TAG_DONE);
    bl = ObtainBestPen(Screen1->ViewPort.ColorMap, 0x00000000, 0x00000000, 0xFFFFFFFF, OBP_Precision, PRECISION_IMAGE, TAG_DONE);
    vl = ObtainBestPen(Screen1->ViewPort.ColorMap, 0xFFFFFFFF, 0x00000000, 0xFFFFFFFF, OBP_Precision, PRECISION_IMAGE, TAG_DONE);
    gr = ObtainBestPen(Screen1->ViewPort.ColorMap, 0x64000000, 0x64000000, 0x64000000, OBP_Precision, PRECISION_IMAGE, TAG_DONE);
    ws = ObtainBestPen(Screen1->ViewPort.ColorMap, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, OBP_Precision, PRECISION_IMAGE, TAG_DONE);
    au = ObtainBestPen(Screen1->ViewPort.ColorMap, 0xE6000000, 0xE6000000, 0x64000000, OBP_Precision, PRECISION_IMAGE, TAG_DONE);
    ag = ObtainBestPen(Screen1->ViewPort.ColorMap, 0xD2000000, 0xD2000000, 0xBE000000, OBP_Precision, PRECISION_IMAGE, TAG_DONE);
}

void Shutdown(void)
{
    /** Release all pens and free the lists when done **/

    ReleasePen(Screen1->ViewPort.ColorMap, sw);
    ReleasePen(Screen1->ViewPort.ColorMap, br);
    ReleasePen(Screen1->ViewPort.ColorMap, rt);
    ReleasePen(Screen1->ViewPort.ColorMap, or);
    ReleasePen(Screen1->ViewPort.ColorMap, ge);
    ReleasePen(Screen1->ViewPort.ColorMap, gn);
    ReleasePen(Screen1->ViewPort.ColorMap, bl);
    ReleasePen(Screen1->ViewPort.ColorMap, vl);
    ReleasePen(Screen1->ViewPort.ColorMap, gr);
    ReleasePen(Screen1->ViewPort.ColorMap, ws);
    ReleasePen(Screen1->ViewPort.ColorMap, au);
    ReleasePen(Screen1->ViewPort.ColorMap, ag);
    FreeListBrowserList(&Listbrowser_List_E6);
    FreeListBrowserList(&Listbrowser_List_E12);
    FreeListBrowserList(&Listbrowser_List_E24);
    FreeListBrowserList(&Listbrowser_List_E48);
    FreeListBrowserList(&Listbrowser_List_E96);
}

void Chooser1_GadgetUp_Event(void)
{
    /** Function copies listbrowser-entrys into the    **/
    /** listbrowser (see the typecasted argument:      **/
    /** "(STRPTR) &Listbrowser_List_EXX" for the list) **/

    switch(stringtoint(Emperor_GetGadgetAttr(Chooser1)))
    {
        case 0: Emperor_SetGadgetAttrComplex(Listbrowser1, LISTBROWSER_Labels, (STRPTR) &Listbrowser_List_E6);  break;
        case 1: Emperor_SetGadgetAttrComplex(Listbrowser1, LISTBROWSER_Labels, (STRPTR) &Listbrowser_List_E12); break;
        case 2: Emperor_SetGadgetAttrComplex(Listbrowser1, LISTBROWSER_Labels, (STRPTR) &Listbrowser_List_E24); break;
        case 3: Emperor_SetGadgetAttrComplex(Listbrowser1, LISTBROWSER_Labels, (STRPTR) &Listbrowser_List_E48); break;
        case 4: Emperor_SetGadgetAttrComplex(Listbrowser1, LISTBROWSER_Labels, (STRPTR) &Listbrowser_List_E96); break;
    }
    Calculate();
}

void Chooser2_GadgetUp_Event(void)
{
    Calculate();
}

void Listbrowser1_GadgetUp_Event(void)
{
    Calculate();
}

void Window1_ShowWindow_Event(void)
{
    Emperor_SetGadgetAttrComplex(Listbrowser1, LISTBROWSER_Labels, (STRPTR) &Listbrowser_List_E12);
    Emperor_SetGadgetAttr(Listbrowser1, "0");
    Emperor_SetGadgetAttr(Chooser1, "1");
    Emperor_SetGadgetAttr(Chooser2, "5");
    WindowRastport = Window1->RPort;
    Calculate();
}

void Window1_CloseWindow_Event(void)
{
    if(Quitrequest()) Emperor_QuitProgram();
}

void Menu_Quit_MenuPick_Event(void)
{
    if(Quitrequest()) Emperor_QuitProgram();
}

void Menu_Information_MenuPick_Event(void)
{
    Inforequest();
}

void Menu_E6_MenuPick_Event(void)
{
    Emperor_SetGadgetAttr(Chooser1, "0");
    Chooser1_GadgetUp_Event();
    Calculate();
}

void Menu_E12_MenuPick_Event(void)
{
    Emperor_SetGadgetAttr(Chooser1, "1");
    Chooser1_GadgetUp_Event();
    Calculate();
}

void Menu_E24_MenuPick_Event(void)
{
    Emperor_SetGadgetAttr(Chooser1, "2");
    Chooser1_GadgetUp_Event();
    Calculate();
}

void Menu_E48_MenuPick_Event(void)
{
    Emperor_SetGadgetAttr(Chooser1, "3");
    Chooser1_GadgetUp_Event();
    Calculate();
}

void Menu_E96_MenuPick_Event(void)
{
    Emperor_SetGadgetAttr(Chooser1, "4");
    Chooser1_GadgetUp_Event();
    Calculate();
}

void Calculate(void)
{
    /** This is the main-calculation function, which   **/
    /** calculates the colours of the resistorlayout   **/
    /** and shows its results within the layout-gadget **/

    BYTE counter;
    BYTE nextring;
    BYTE tolerance;
    BYTE multiplicator;
    BYTE resistorentry;
    char *resistorvalue = "1234567890";

    tolerance = stringtoint(Emperor_GetGadgetAttr(Chooser1));
    multiplicator = stringtoint(Emperor_GetGadgetAttr(Chooser2));
    resistorentry = stringtoint(Emperor_GetGadgetAttr(Listbrowser1));

    SetAPen(WindowRastport, 0);
    RectFill(WindowRastport, 210, 50, 390, 310);

    SetAPen(WindowRastport, 2);
    Move(WindowRastport, 366, 139);
    Draw(WindowRastport, 234, 139);
    Draw(WindowRastport, 234, 191);

    SetAPen(WindowRastport, 1);
    Move(WindowRastport, 234, 191);
    Draw(WindowRastport, 366, 191);
    Draw(WindowRastport, 366, 139);

    Move(WindowRastport, 367, 138);
    Draw(WindowRastport, 233, 138);
    Draw(WindowRastport, 233, 192);
    Draw(WindowRastport, 367, 192);
    Draw(WindowRastport, 367, 138);

    Move(WindowRastport, 233, 163);
    Draw(WindowRastport, 222, 163);
    Draw(WindowRastport, 222, 167);
    Draw(WindowRastport, 233, 167);
    Draw(WindowRastport, 233, 163);

    Move(WindowRastport, 367, 163);
    Draw(WindowRastport, 378, 163);
    Draw(WindowRastport, 378, 167);
    Draw(WindowRastport, 367, 167);
    Draw(WindowRastport, 367, 163);

    Move(WindowRastport, 240, 140);
    Draw(WindowRastport, 255, 140);
    Draw(WindowRastport, 255, 190);
    Draw(WindowRastport, 240, 190);
    Draw(WindowRastport, 240, 140);

    Move(WindowRastport, 260, 140);
    Draw(WindowRastport, 275, 140);
    Draw(WindowRastport, 275, 190);
    Draw(WindowRastport, 260, 190);
    Draw(WindowRastport, 260, 140);

    Move(WindowRastport, 280, 140);
    Draw(WindowRastport, 295, 140);
    Draw(WindowRastport, 295, 190);
    Draw(WindowRastport, 280, 190);
    Draw(WindowRastport, 280, 140);

    if(tolerance >= 1)
    {
        Move(WindowRastport, 300, 140);
        Draw(WindowRastport, 315, 140);
        Draw(WindowRastport, 315, 190);
        Draw(WindowRastport, 300, 190);
        Draw(WindowRastport, 300, 140);
    }

    if(tolerance >= 3)
    {
        Move(WindowRastport, 320, 140);
        Draw(WindowRastport, 335, 140);
        Draw(WindowRastport, 335, 190);
        Draw(WindowRastport, 320, 190);
        Draw(WindowRastport, 320, 140);
    }

    switch(multiplicator)
    {
        case 0:  shift_comma_in_string(resistorvalue, string[tolerance][resistorentry], 1); break;
        case 1:  shift_comma_in_string(resistorvalue, string[tolerance][resistorentry], 2); break;
        case 3:  shift_comma_in_string(resistorvalue, string[tolerance][resistorentry], 1); break;
        case 4:  shift_comma_in_string(resistorvalue, string[tolerance][resistorentry], 2); break;
        case 6:  shift_comma_in_string(resistorvalue, string[tolerance][resistorentry], 1); break;
        case 7:  shift_comma_in_string(resistorvalue, string[tolerance][resistorentry], 2); break;
        case 9:  shift_comma_in_string(resistorvalue, string[tolerance][resistorentry], 1); break;
        case 10: shift_comma_in_string(resistorvalue, string[tolerance][resistorentry], 2); break;
        default: strcpy(resistorvalue, string[tolerance][resistorentry]);
    }
    if(multiplicator <= 1) strcat(resistorvalue, " mOhm");
    else
    {
        if(multiplicator <= 4) strcat(resistorvalue, " Ohm");
        else
        {
            if(multiplicator <= 7) strcat(resistorvalue, " kOhm");
            else
            {
                if(multiplicator <= 10) strcat(resistorvalue, " MOhm");
                else strcat(resistorvalue, " GOhm");
            }
        }
    }
    WindowIntuitext.FrontPen = 1;
    WindowIntuitext.LeftEdge = 250;
    WindowIntuitext.TopEdge = 100;
    WindowIntuitext.IText = (UBYTE *) resistorvalue;
    PrintIText(WindowRastport, &WindowIntuitext, 0, 0);

    switch(multiplicator)
    {
        case 0:  SetAPen(WindowRastport, ag); break;
        case 1:  SetAPen(WindowRastport, au); break;
        case 2:  SetAPen(WindowRastport, sw); break;
        case 3:  SetAPen(WindowRastport, br); break;
        case 4:  SetAPen(WindowRastport, rt); break;
        case 5:  SetAPen(WindowRastport, or); break;
        case 6:  SetAPen(WindowRastport, ge); break;
        case 7:  SetAPen(WindowRastport, gn); break;
        case 8:  SetAPen(WindowRastport, bl); break;
        case 9:  SetAPen(WindowRastport, vl); break;
        case 10: SetAPen(WindowRastport, gr); break;
        case 11: SetAPen(WindowRastport, ws); break;
    }
    if(tolerance >= 3) RectFill(WindowRastport, 301, 141, 314, 189);
    else RectFill(WindowRastport, 281, 141, 294, 189);
    switch(tolerance)
    {
        case 1:  SetAPen(WindowRastport, ag); break;
        case 2:  SetAPen(WindowRastport, au); break;
        case 3:  SetAPen(WindowRastport, rt); break;
        case 4:  SetAPen(WindowRastport, br); break;
        default: SetAPen(WindowRastport,  0); break;
    }
    if(tolerance >= 3) RectFill(WindowRastport, 321, 141, 334, 189);
    else RectFill(WindowRastport, 301, 141, 314, 189);
    for(counter = 0, nextring = 0;counter <= 3;counter++)
    {
        if(counter == 1) continue;
        if((tolerance < 3) && (counter == 3)) break;
        switch(string[tolerance][resistorentry][counter])
        {
            case '0': SetAPen(WindowRastport, sw); break;
            case '1': SetAPen(WindowRastport, br); break;
            case '2': SetAPen(WindowRastport, rt); break;
            case '3': SetAPen(WindowRastport, or); break;
            case '4': SetAPen(WindowRastport, ge); break;
            case '5': SetAPen(WindowRastport, gn); break;
            case '6': SetAPen(WindowRastport, bl); break;
            case '7': SetAPen(WindowRastport, vl); break;
            case '8': SetAPen(WindowRastport, gr); break;
            case '9': SetAPen(WindowRastport, ws); break;
        }
        RectFill(WindowRastport, 241 + 20 * nextring, 141, 254 + 20 * nextring, 189);
        nextring++;
    }
}

/** Now some low-level funcs.. **/

void AllocListbrowserNodesExtra(struct List *list, char labels[96][5], WORD number_of_entrys)
{
    /** Extra-function for creating lists, that **/
    /** will be shown within the listbrowser    **/

    WORD counter;
    struct Node *node;

    NewList(list);
    for(counter = 0;counter < number_of_entrys;counter++)
    {
        node = AllocListBrowserNode(1, LBNCA_Text, labels[counter], LBNCA_CopyText, TRUE, TAG_DONE);
        AddTail(list, node);
    }
}

STRPTR floattostring(DOUBLE number_to_convert, UBYTE digits_behind_comma)
{
    /** This function converts a double    **/
    /** precision floatvalue into a string **/

    ULONG integer_number;
    UWORD integer_length;
    UWORD single_digit;
    char *buffstr = "1234567890";

    strcpy(buffstr, "");
    if(number_to_convert < 0)
    {
        strcpy(buffstr, "-");
        number_to_convert = -number_to_convert;
    }
    integer_number = (ULONG) ((number_to_convert * pow(10, digits_behind_comma)) + 0.5);
    if(integer_number > 0) integer_length = 1;
    if(integer_number/10 > 0) integer_length = 2;
    if(integer_number/100 > 0) integer_length = 3;
    if(integer_number/1000 > 0) integer_length = 4;
    if(integer_number/10000 > 0) integer_length = 5;
    if(integer_number/100000 > 0) integer_length = 6;
    if(integer_number/1000000 > 0) integer_length = 7;
    if(integer_number/10000000 > 0) integer_length = 8;
    if(integer_number/100000000 > 0) integer_length = 9;
    if(integer_number == 0)  strcpy(buffstr, "0");
    else
    {
        for(integer_length = integer_length;integer_length > 0;integer_length--)
        {
            single_digit = (UWORD) (integer_number / pow(10, integer_length - 1));
            if(single_digit == 0) strcat(buffstr, "0");
            if(single_digit == 1) strcat(buffstr, "1");
            if(single_digit == 2) strcat(buffstr, "2");
            if(single_digit == 3) strcat(buffstr, "3");
            if(single_digit == 4) strcat(buffstr, "4");
            if(single_digit == 5) strcat(buffstr, "5");
            if(single_digit == 6) strcat(buffstr, "6");
            if(single_digit == 7) strcat(buffstr, "7");
            if(single_digit == 8) strcat(buffstr, "8");
            if(single_digit == 9) strcat(buffstr, "9");
            integer_number -= single_digit * pow(10, integer_length - 1);
            if(integer_length == digits_behind_comma + 1) strcat(buffstr, ".");
        }
    }
    return(buffstr);
}

char *shift_comma_in_string(char *buffer1, const char *buffer2, UBYTE number_of_bytes)
{
    BOOL comma_found = FALSE;
    char *d = buffer1, c;

    do
    {
        c = *buffer2++;
        if(c != '.') *buffer1++ = c;
        else comma_found = TRUE;
        if(!number_of_bytes) *buffer1++ = '.';
        if(comma_found) number_of_bytes--;
    }
    while(c);

    return(d);
}

