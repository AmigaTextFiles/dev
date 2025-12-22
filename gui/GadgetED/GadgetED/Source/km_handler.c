/*----------------------------------------------------------------------*
  km_handler.c Version 2.3  © Copyright 1990-91 Jaba Development

  Author : Jan van den Baard
  Purpose: handling of menu and keyboard events
 *----------------------------------------------------------------------*/

extern struct Menu        Titles[];
extern struct Screen     *MainScreen;
extern struct Window     *MainWindow;
extern struct RastPort   *MainRP;
extern struct GadgetList  Gadgets;
extern USHORT             FrontPen, BackPen, GadgetCount, BackFill;
extern USHORT             WDBackFill,LightSide,DarkSide;
extern BOOL               Saved, REQUESTER, WORKBENCH, WBSCREEN;
extern UBYTE              wbb[20];

/*
 * quit if the anwser is yes
 */
VOID quit()
{
    BOOL Quit = FALSE;

    if(Saved == FALSE)
    {   if(Ask("Your work isn't saved !","Quit anyway ?") == TRUE)
            Quit = TRUE;
    }
    else
    {   if(Ask("Are you sure you","want to Quit ?") == TRUE)
            Quit = TRUE;
    }
    if(Quit == TRUE) close_up(NULL);
}

/*
 * handle the menu events (drag selections possible)
 */
VOID handle_menus(menu_code)
    USHORT menu_code;
{
    USHORT menu, item, sub, next_select;
    struct MenuItem *select, *ItemAddress();

    while(menu_code != MENUNULL)
    {   select = ItemAddress(&Titles[0],menu_code);
        menu = MENUNUM(menu_code);
        item = ITEMNUM(menu_code);
        sub  = SUBNUM(menu_code);
        switch(menu)
        {   case 0: switch(item)
                    {   case 0: About();
                                break;
                        case 1: new();
                                break;
                        case 2: ReadBinGadgets(FALSE);
                                break;
                        case 3: WriteBinGadgets();
                                break;
                        case 4: switch(sub)
                                {   case 0: WriteCGadgets();
                                            break;
                                    case 1: WriteAsmGadgets();
                                            break;
                                }
                                break;
                        case 5: preferences();
                                break;
                        case 6: if(WORKBENCH == TRUE)
                                { if((WORKBENCH = (BOOL)OpenWorkBench()))
                                  {   strcpy((char *)&wbb,"Close WorkBench");
                                      ScreenToFront(MainScreen);
                                  }
                                  else Error("Can't open WorkBench !");
                                }
                                else
                                {   if((WORKBENCH = CloseWorkBench()))
                                        strcpy((char *)&wbb,"Open WorkBench");
                                    else Error("Can't close WorkBench !");
                                }
                                break;
                        case 7: quit();
                        break;
                    break;
                    }
            break;
            case 1: switch(item)
                    {   case 0: move_gadget();
                                break;
                        case 1: size_gadget();
                                break;
                        case 2: copy_gadget();
                                break;
                        case 3: delete();
                                break;
                        case 4: edit();
                                break;
                        case 5: switch(sub)
                                {   case 0: add_text(0);
                                            break;
                                    case 1: modify(0);
                                            break;
                                    case 2: text_delete(0);
                                            break;
                                    case 3: move_text(0);
                                            break;
                                }
                                break;
                        case 6: switch(sub)
                                {   case 0: render();
                                            break;
                                    case 1: sel_render();
                                            break;
                                    case 2: delete_images();
                                            break;
                                }
                                break;
                        case 7: do_cmap();
                                break;
                        case 8: disable_window();
                                SetPalette(10,20,MainScreen);
                                enable_window();
                                break;
                        case 9: refresh();
                                break;
                        case 10: LightSide = FrontPen;
                                 DarkSide  = BackPen;
                                 break;
                        case 11: switch(sub)
                                 { case 0: if(REQUESTER == FALSE) set_flags();
                                           else { BackFill = BackPen; refresh(); }
                                           break;
                                   case 1: if(REQUESTER == FALSE) idcmp();
                                           else add_text(2);
                                           break;
                                   case 2: if(REQUESTER == FALSE) { WDBackFill = BackPen; refresh(); }
                                           else modify(2);
                                           break;
                                   case 3: if(REQUESTER == FALSE) add_text(1);
                                           else text_delete(2);
                                           break;
                                   case 4: if(REQUESTER == FALSE) modify(1);
                                           else move_text(2);
                                           break;
                                   case 5: text_delete(1);
                                           break;
                                   case 6: move_text(1);
                                           break;
                                  }
                                  break;
                    }
                    break;
            case 2: FrontPen = (USHORT)item; break;
            case 3: BackPen  = (USHORT)item; break;
            default: break;
            }
    menu_code = select->NextSelect;
    }
}

/*
 * handle the keyboard events
 */
VOID handle_keys(key_code,qualifier)
    USHORT key_code, qualifier;
{
    if((key_code & IECODE_UP_PREFIX) != IECODE_UP_PREFIX)
    {   switch(qualifier)
        {   case IEQUALIFIER_RELATIVEMOUSE:
            case IEQUALIFIER_RELATIVEMOUSE+IEQUALIFIER_CAPSLOCK:
            switch(key_code)
            {   case F1:   move_gadget();
                           break;
                case F2:   size_gadget();
                           break;
                case F3:   copy_gadget();
                           break;
                case F4:   delete();
                           break;
                case F5:   edit();
                           break;
                case F6:   add_text(0);
                           break;
                case F7:   render();
                           break;
                case F8:   sel_render();
                           break;
                case F9:   do_cmap();
                           break;
                case F10:  disable_window();
                           SetPalette(10,20,MainScreen);
                           enable_window();
                           break;
                case HELP: refresh();
                           break;
            }
            break;
        }
    }
}
