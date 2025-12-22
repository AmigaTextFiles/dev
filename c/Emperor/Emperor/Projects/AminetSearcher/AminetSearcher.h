#include <AminetSearcher_lowlevel.h>

void Checkbox_Handle(BOOL);
void Checkbox_Handle_onoff(BOOL);

void Window1_CloseWindow_Event(void)
{
    if(Quitrequest1()) terminated = TRUE;
}

void Menu_Info_MenuPick_Event(void)
{
    Inforequest1();
}

void Menu_Quit_MenuPick_Event(void)
{
    if(Quitrequest1()) terminated = TRUE;
}

void Menu_Select_All_MenuPick_Event(void)
{
    Checkbox_Handle_onoff(TRUE);
}

void Menu_Select_None_MenuPick_Event(void)
{
    Checkbox_Handle_onoff(FALSE);
}

void Checkbox16_GadgetUp_Event(void)
{
    in_lha = stringtoint(Emperor_GetGadgetAttr(Checkbox16));
    Checkbox_Handle(!in_lha);
    Emperor_SetGadgetDisabledAttr(Checkbox17, in_lha || !all_or_one_cd);
}

void Checkbox17_GadgetUp_Event(void)
{
    single = stringtoint(Emperor_GetGadgetAttr(Checkbox17));
}

void Chooser1_GadgetUp_Event(void)
{
    all_or_one_cd = stringtoint(Emperor_GetGadgetAttr(Chooser1));
    if(all_or_one_cd) Checkbox_Handle(TRUE);
    else Checkbox_Handle(!in_lha);
    Emperor_SetGadgetDisabledAttr(Checkbox16, all_or_one_cd);
    Emperor_SetGadgetDisabledAttr(Checkbox17, !all_or_one_cd);
}

void Button1_GadgetUp_Event(void)
{
    char output[16] = "";
    char buffer1[16] = "";
    char dirbuffer[300][16];
    char filebuffer[21] = "";
    BOOL term = FALSE, checkboxbool = FALSE;
    BPTR file = NULL;
    WORD i = 0, j = 0, k = 0, l = 0;
    FLOAT calc = 0.00, calc1 = 0.00;
    FLOAT position1 = 0.00, position2 = 0.00, position3 = 0.00, position4 = 0.00;
    ULONG counter = 0;

    entryzahl = 0;
    Checkbox_Handle(TRUE);
    Emperor_SetGadgetDisabledAttr(String1, TRUE);
    Emperor_SetGadgetDisabledAttr(String2, TRUE);
    Emperor_SetGadgetDisabledAttr(String3, TRUE);
    Emperor_SetGadgetDisabledAttr(String4, TRUE);
    Emperor_SetGadgetDisabledAttr(String5, TRUE);
    Emperor_SetGadgetDisabledAttr(Checkbox16, TRUE);
    Emperor_SetGadgetDisabledAttr(Checkbox17, TRUE);
    Emperor_SetGadgetDisabledAttr(Chooser1, TRUE);
    Emperor_SetGadgetDisabledAttr(Button1, TRUE);
    Emperor_SetGadgetDisabledAttr(Button2, FALSE);

    if((pattern[0][0]) || (pattern[1][0]) || (pattern[2][0]) || (pattern[3][0]) || (pattern[4][0]))
    {
        if(!all_or_one_cd)
        {
            /* nur eine CD */
            if(in_lha)
            {
                /* suche in LhAs */
                for(j = 0;j < 14;j++)
                {
                    term = stringtoint(Emperor_GetGadgetAttr(Button2));
                    switch(j)
                    {
                      case 0: checkboxbool = stringtoint(Emperor_GetGadgetAttr(Checkbox1)); break;
                      case 1: checkboxbool = stringtoint(Emperor_GetGadgetAttr(Checkbox2)); break;
                      case 2: checkboxbool = stringtoint(Emperor_GetGadgetAttr(Checkbox3)); break;
                      case 3: checkboxbool = stringtoint(Emperor_GetGadgetAttr(Checkbox4)); break;
                      case 4: checkboxbool = stringtoint(Emperor_GetGadgetAttr(Checkbox5)); break;
                      case 5: checkboxbool = stringtoint(Emperor_GetGadgetAttr(Checkbox6)); break;
                      case 6: checkboxbool = stringtoint(Emperor_GetGadgetAttr(Checkbox7)); break;
                      case 7: checkboxbool = stringtoint(Emperor_GetGadgetAttr(Checkbox8)); break;
                      case 8: checkboxbool = stringtoint(Emperor_GetGadgetAttr(Checkbox9)); break;
                      case 9: checkboxbool = stringtoint(Emperor_GetGadgetAttr(Checkbox10)); break;
                      case 10: checkboxbool = stringtoint(Emperor_GetGadgetAttr(Checkbox11)); break;
                      case 11: checkboxbool = stringtoint(Emperor_GetGadgetAttr(Checkbox12)); break;
                      case 12: checkboxbool = stringtoint(Emperor_GetGadgetAttr(Checkbox13)); break;
                      case 13: checkboxbool = stringtoint(Emperor_GetGadgetAttr(Checkbox14)); break;
                      case 14: checkboxbool = stringtoint(Emperor_GetGadgetAttr(Checkbox15)); break;
                    }
                    if(checkboxbool)
                    {
                        file = NULL;
                        switch(j)
                        {
                            case  0: file = Open("CD0:Aminet/biz/INDEX",  MODE_OLDFILE); break;
                            case  1: file = Open("CD0:Aminet/comm/INDEX", MODE_OLDFILE); break;
                            case  2: file = Open("CD0:Aminet/demo/INDEX", MODE_OLDFILE); break;
                            case  3: file = Open("CD0:Aminet/dev/INDEX",  MODE_OLDFILE); break;
                            case  4: file = Open("CD0:Aminet/disk/INDEX", MODE_OLDFILE); break;
                            case  5: file = Open("CD0:Aminet/docs/INDEX", MODE_OLDFILE); break;
                            case  6: file = Open("CD0:Aminet/game/INDEX", MODE_OLDFILE); break;
                            case  7: file = Open("CD0:Aminet/gfx/INDEX",  MODE_OLDFILE); break;
                            case  8: file = Open("CD0:Aminet/hard/INDEX", MODE_OLDFILE); break;
                            case  9: file = Open("CD0:Aminet/misc/INDEX", MODE_OLDFILE); break;
                            case 10: file = Open("CD0:Aminet/mods/INDEX", MODE_OLDFILE); break;
                            case 11: file = Open("CD0:Aminet/mus/INDEX",  MODE_OLDFILE); break;
                            case 12: file = Open("CD0:Aminet/pix/INDEX",  MODE_OLDFILE); break;
                            case 13: file = Open("CD0:Aminet/text/INDEX", MODE_OLDFILE); break;
                            case 14: file = Open("CD0:Aminet/util/INDEX", MODE_OLDFILE); break;
                        }
                        if(file)
                        {
                            Seek(file, 0, OFFSET_END);
                            position2 += Seek(file, 0, OFFSET_BEGINNING);
                            Close(file);
                        }
                    }
                    if(term) break;
                }
                for(j = 0;j < 14;j++)
                {
                    switch(j)
                    {
                      case 0: checkboxbool = stringtoint(Emperor_GetGadgetAttr(Checkbox1)); break;
                      case 1: checkboxbool = stringtoint(Emperor_GetGadgetAttr(Checkbox2)); break;
                      case 2: checkboxbool = stringtoint(Emperor_GetGadgetAttr(Checkbox3)); break;
                      case 3: checkboxbool = stringtoint(Emperor_GetGadgetAttr(Checkbox4)); break;
                      case 4: checkboxbool = stringtoint(Emperor_GetGadgetAttr(Checkbox5)); break;
                      case 5: checkboxbool = stringtoint(Emperor_GetGadgetAttr(Checkbox6)); break;
                      case 6: checkboxbool = stringtoint(Emperor_GetGadgetAttr(Checkbox7)); break;
                      case 7: checkboxbool = stringtoint(Emperor_GetGadgetAttr(Checkbox8)); break;
                      case 8: checkboxbool = stringtoint(Emperor_GetGadgetAttr(Checkbox9)); break;
                      case 9: checkboxbool = stringtoint(Emperor_GetGadgetAttr(Checkbox10)); break;
                      case 10: checkboxbool = stringtoint(Emperor_GetGadgetAttr(Checkbox11)); break;
                      case 11: checkboxbool = stringtoint(Emperor_GetGadgetAttr(Checkbox12)); break;
                      case 12: checkboxbool = stringtoint(Emperor_GetGadgetAttr(Checkbox13)); break;
                      case 13: checkboxbool = stringtoint(Emperor_GetGadgetAttr(Checkbox14)); break;
                      case 14: checkboxbool = stringtoint(Emperor_GetGadgetAttr(Checkbox15)); break;
                    }
                    if(checkboxbool)
                    {
                        file = NULL;
                        switch(j)
                        {
                            case  0: file = Open("CD0:Aminet/biz/INDEX",  MODE_OLDFILE); break;
                            case  1: file = Open("CD0:Aminet/comm/INDEX", MODE_OLDFILE); break;
                            case  2: file = Open("CD0:Aminet/demo/INDEX", MODE_OLDFILE); break;
                            case  3: file = Open("CD0:Aminet/dev/INDEX",  MODE_OLDFILE); break;
                            case  4: file = Open("CD0:Aminet/disk/INDEX", MODE_OLDFILE); break;
                            case  5: file = Open("CD0:Aminet/docs/INDEX", MODE_OLDFILE); break;
                            case  6: file = Open("CD0:Aminet/game/INDEX", MODE_OLDFILE); break;
                            case  7: file = Open("CD0:Aminet/gfx/INDEX",  MODE_OLDFILE); break;
                            case  8: file = Open("CD0:Aminet/hard/INDEX", MODE_OLDFILE); break;
                            case  9: file = Open("CD0:Aminet/misc/INDEX", MODE_OLDFILE); break;
                            case 10: file = Open("CD0:Aminet/mods/INDEX", MODE_OLDFILE); break;
                            case 11: file = Open("CD0:Aminet/mus/INDEX",  MODE_OLDFILE); break;
                            case 12: file = Open("CD0:Aminet/pix/INDEX",  MODE_OLDFILE); break;
                            case 13: file = Open("CD0:Aminet/text/INDEX", MODE_OLDFILE); break;
                            case 14: file = Open("CD0:Aminet/util/INDEX", MODE_OLDFILE); break;
                        }
                        if(file)
                        {
                            filezahl = 0;
                            Seek(file, 0, OFFSET_END);
                            position1 = Seek(file, 0, OFFSET_BEGINNING);
                            FGets(file, puffer, 100);
                            FGets(file, puffer, 100);
                            while((FGets(file, puffer, 100)) && (filezahl < 300))
                            {
                                stringcopywithoutspace(filebuffer, puffer);
                                for(l = 0;l < 15;l++) buffer1[l] = puffer[l + 19];
                                buffer1[15] = NULL;
                                stringcopywithoutspace(dirbuffer[filezahl], buffer1);
                                strcpy(executepuffer[filezahl], "Run >NIL: lha v CD0:Aminet/");
                                strcat(executepuffer[filezahl], dirbuffer[filezahl]);
                                strcat(executepuffer[filezahl], "/");
                                strcat(executepuffer[filezahl], filebuffer);
                                strcat(executepuffer[filezahl], " >RAM:T/AminetSearcher-LhA.output");
                                filezahl++;
                                term = stringtoint(Emperor_GetGadgetAttr(Button2));
                                if(term) break;
                            }
                            Close(file);
                            for(k = 0;k < filezahl;k++)
                            {
/*****************************************************************************/
/** This section isn't correct ! (and I don't know why !)                   **/
/** Now the packer LhA should be called, but after a calling like:          **/
/**                         SystemTags(executepuffer[k], TAG_DONE);         **/
/** or                                                                      **/
/**                         Execute(executepuffer[k], NULL, NULL);          **/
/** the program doesn't open the outputfile.                                **/
/*****************************************************************************/
/*****************************************************************************/
/** Dieser Abschnitt stimmt noch nicht ganz ! (und ich weiß nicht warum !)  **/
/** Irgendwie soll nun der Aufruf von LhA erfolgen, aber nach diesem Aufruf **/
/** in der Richtung wie:                                                    **/
/**                         SystemTags(executepuffer[k], TAG_DONE);         **/
/** oder                                                                    **/
/**                         Execute(executepuffer[k], NULL, NULL);          **/
/** kann man das Programm, aus welchem Grund auch immer, nicht mehr zum     **/
/** öffnen des Output-Files bewegen.                                        **/
/*****************************************************************************/
                                calc = (FLOAT) k / (FLOAT) filezahl * 100;
                                calc1 = ((calc / 100) * position1 + position3) / position2 * 100;
                                Emperor_SetGadgetAttr(Fuelgauge1, inttostring((LONG) calc));
                                Emperor_SetGadgetAttr(Fuelgauge2, inttostring((LONG) calc1));
                                Emperor_SetGadgetAttr(String6, dirbuffer[k]);
                                term = stringtoint(Emperor_GetGadgetAttr(Button2));
                                if(term) break;
                            }
                            position3 += position1;
                        }
                        else Errorrequest1();
                    }
                    if(term) break;
                }
            }
            else
            {
                /* suche im Index */
                file = Open("CD0:Aminet/INDEX", MODE_OLDFILE);
                if(file)
                {
                    Seek(file, 0, OFFSET_END);
                    position1 = Seek(file, 0, OFFSET_BEGINNING);
                    FGets(file, puffer, 100);
                    FGets(file, puffer, 100);
                    FGets(file, puffer, 100);
                    FGets(file, puffer, 100);
                    FGets(file, puffer, 100);
                    FGets(file, puffer, 100);
                    while((FGets(file, puffer, 100)) && (entryzahl < 1024))
                    {
                        makelower(convert, puffer);
                        make_entry();
                        counter++;
                        if(counter == 50)
                        {
                            counter = 0;
                            position2 = Seek(file, 0, OFFSET_CURRENT);
                            calc = position2 / position1 * 100;
                            for(i = 0;i < 15;i++) output[i] = puffer[19 + i];
                            output[15] = NULL;
                            Emperor_SetGadgetAttr(Fuelgauge1, inttostring((LONG) calc));
                            Emperor_SetGadgetAttr(Fuelgauge2, inttostring((LONG) calc1));
                            Emperor_SetGadgetAttr(String6, output);
                            term = stringtoint(Emperor_GetGadgetAttr(Button2));
                        }
                        if(term) break;
                    }
                    Close(file);
                }
                else Errorrequest1();
            }
        }
        else
        {
            /* alle CDs */
            if(single) file = Open("CD0:Lists/Single_Dir.doc", MODE_OLDFILE);
            else file = Open("CD0:Lists/Aminet_Dir.doc", MODE_OLDFILE);
            if(file)
            {
                Seek(file, 0, OFFSET_END);
                position1 = Seek(file, 0, OFFSET_BEGINNING);
                FGets(file, puffer, 100);
                FGets(file, puffer, 100);
                FGets(file, puffer, 100);
                FGets(file, puffer, 100);
                FGets(file, puffer, 100);
                FGets(file, puffer, 100);
                while((FGets(file, puffer, 100)) && (entryzahl < 1024))
                {
                    makelower(convert, puffer);
                    make_entry();
                    counter++;
                    if(counter == 200)
                    {
                        counter = 0;
                        position2 = Seek(file, 0, OFFSET_CURRENT);
                        calc = position2 / position1 * 100;
                        for(i = 0;i < 15;i++) output[i] = puffer[19 + i];
                        output[15] = NULL;
                        Emperor_SetGadgetAttr(Fuelgauge1, inttostring((LONG) calc));
                        Emperor_SetGadgetAttr(Fuelgauge2, inttostring((LONG) calc1));
                        Emperor_SetGadgetAttr(String6, output);
                        term = stringtoint(Emperor_GetGadgetAttr(Button2));
                    }
                    if(term) break;
                }
                Close(file);
            }
            else Errorrequest1();
        }
    }
    else Nopatternrequest1();
    Emperor_SetGadgetDisabledAttr(String1, FALSE);
    Emperor_SetGadgetDisabledAttr(String2, FALSE);
    Emperor_SetGadgetDisabledAttr(String3, FALSE);
    Emperor_SetGadgetDisabledAttr(String4, FALSE);
    Emperor_SetGadgetDisabledAttr(String5, FALSE);
    Emperor_SetGadgetDisabledAttr(Checkbox16, all_or_one_cd);
    Emperor_SetGadgetDisabledAttr(Checkbox17, !all_or_one_cd);
    Emperor_SetGadgetDisabledAttr(Chooser1, FALSE);
    Emperor_SetGadgetDisabledAttr(Button1, FALSE);
    Emperor_SetGadgetDisabledAttr(Button2, TRUE);
    Emperor_SetGadgetAttr(Fuelgauge1, inttostring(100));
    Emperor_SetGadgetAttr(Fuelgauge2, inttostring(100));
    Emperor_SetGadgetAttr(String6, "Status: ok");
    Checkbox_Handle(!in_lha || all_or_one_cd);
    if(term) Emperor_SetGadgetAttr(Button2, inttostring(FALSE));
}

void Listbrowser1_GadgetUp_Event(void)
{
    char buffer1[20];
    LONG entry;
    WORD choose, i = 0;

    IntuiMessage = GT_GetIMsg(Window1->UserPort);
    if(DoubleClick(Seconds, Micros, IntuiMessage->Seconds, IntuiMessage->Micros))
    {
        entry = stringtoint(Emperor_GetGadgetAttr(Listbrowser1));
        if(entry != -1)
        {
            choose = Extractrequest1();
            if(choose == 1)
            {
                strcpy(puffer, "SYS:Utilities/Multiview CD0:Aminet/");
                stringcopywithoutspace(buffer1, founded_files_list_col3_raw[entry]);
                strcat(puffer, buffer1);
                strcat(puffer, "/");
                stringcopywithoutspace(buffer1, founded_files_list_col2_raw[entry]);
                strcat(puffer, buffer1);
                while(puffer[i]) i++;
                puffer[i - 4] = NULL;
                strcat(puffer, ".readme");
                Execute(puffer, NULL, NULL);
                Emperor_SetGadgetAttr(String6, "Status: ok");
            }
            if(choose == 2)
            {
                strcpy(puffer, "Run >NIL: lha x CD0:Aminet/");
                stringcopywithoutspace(buffer1, founded_files_list_col3_raw[entry]);
                strcat(puffer, buffer1);
                strcat(puffer, "/");
                stringcopywithoutspace(buffer1, founded_files_list_col2_raw[entry]);
                strcat(puffer, buffer1);
                strcat(puffer, " RAM:");
                Execute(puffer, NULL, NULL);
                Emperor_SetGadgetAttr(String6, "Extracted to RAM:");
            }
            if(choose == 3)
            {
                Emperor_SetGadgetAttr(String6, "Status: ok");
            }
        }
    }
    Seconds = IntuiMessage->Seconds;
    Micros = IntuiMessage->Micros;
    GT_ReplyIMsg(IntuiMessage);
}

void Checkbox_Handle(BOOL disabled)
{
    Emperor_SetGadgetDisabledAttr(Checkbox1, disabled);
    Emperor_SetGadgetDisabledAttr(Checkbox2, disabled);
    Emperor_SetGadgetDisabledAttr(Checkbox3, disabled);
    Emperor_SetGadgetDisabledAttr(Checkbox4, disabled);
    Emperor_SetGadgetDisabledAttr(Checkbox5, disabled);
    Emperor_SetGadgetDisabledAttr(Checkbox6, disabled);
    Emperor_SetGadgetDisabledAttr(Checkbox7, disabled);
    Emperor_SetGadgetDisabledAttr(Checkbox8, disabled);
    Emperor_SetGadgetDisabledAttr(Checkbox9, disabled);
    Emperor_SetGadgetDisabledAttr(Checkbox10, disabled);
    Emperor_SetGadgetDisabledAttr(Checkbox11, disabled);
    Emperor_SetGadgetDisabledAttr(Checkbox12, disabled);
    Emperor_SetGadgetDisabledAttr(Checkbox13, disabled);
    Emperor_SetGadgetDisabledAttr(Checkbox14, disabled);
    Emperor_SetGadgetDisabledAttr(Checkbox15, disabled);
}

void Checkbox_Handle_onoff(BOOL onoff)
{
    Emperor_SetGadgetAttr(Checkbox1, inttostring(onoff));
    Emperor_SetGadgetAttr(Checkbox2, inttostring(onoff));
    Emperor_SetGadgetAttr(Checkbox3, inttostring(onoff));
    Emperor_SetGadgetAttr(Checkbox4, inttostring(onoff));
    Emperor_SetGadgetAttr(Checkbox5, inttostring(onoff));
    Emperor_SetGadgetAttr(Checkbox6, inttostring(onoff));
    Emperor_SetGadgetAttr(Checkbox7, inttostring(onoff));
    Emperor_SetGadgetAttr(Checkbox8, inttostring(onoff));
    Emperor_SetGadgetAttr(Checkbox9, inttostring(onoff));
    Emperor_SetGadgetAttr(Checkbox10, inttostring(onoff));
    Emperor_SetGadgetAttr(Checkbox11, inttostring(onoff));
    Emperor_SetGadgetAttr(Checkbox12, inttostring(onoff));
    Emperor_SetGadgetAttr(Checkbox13, inttostring(onoff));
    Emperor_SetGadgetAttr(Checkbox14, inttostring(onoff));
    Emperor_SetGadgetAttr(Checkbox15, inttostring(onoff));
}

void String1_GadgetUp_Event(void)
{
    strcpy(pattern[0], Emperor_GetGadgetAttr(String1));
    makelower(patternlower[0], pattern[0]);
}

void String2_GadgetUp_Event(void)
{
    strcpy(pattern[1], Emperor_GetGadgetAttr(String2));
    makelower(patternlower[1], pattern[1]);
}

void String3_GadgetUp_Event(void)
{
    strcpy(pattern[2], Emperor_GetGadgetAttr(String3));
    makelower(patternlower[2], pattern[2]);
}

void String4_GadgetUp_Event(void)
{
    strcpy(pattern[3], Emperor_GetGadgetAttr(String4));
    makelower(patternlower[3], pattern[3]);
}

void String5_GadgetUp_Event(void)
{
    strcpy(pattern[4], Emperor_GetGadgetAttr(String5));
    makelower(patternlower[4], pattern[4]);
}

