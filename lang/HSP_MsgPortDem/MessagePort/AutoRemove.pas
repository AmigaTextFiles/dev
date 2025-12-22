{***********************************************************************}
{ AutoRemoveDemo.PAS                                                    }
{                                                                       }
{ This little program demonstrates the use op MessagePorts and how to   }
{ use intuition with HighSpeed Pascal.                                  }
{ It will first check if a copy of the program is already running,      }
{ if NOT: Then open a window and wait for a message                     }
{ else  : Open a window and close both programs (the copy aswell !!)    }
{ So a program can be terminated by running it again...                 }
{***********************************************************************}
{ By Hans Luyten September 1993                                         }
{ Original idea: Amiga Magazin 3/93 by C. Bruehann (who did this in C)  }
{ Compiler: HighSpeed Pascal 1.1                                        }
{***********************************************************************}
PROGRAM AutoRemoveDemo;

uses
  Exec, Intuition, Graphics;          { We need these....               }

VAR                        
  MyWindow  :  tNewWindow;            { Struct for the NewWindow        }
  Window    :  pWindow;               { Pointer to the NewWindow        }
  
  NewPort   : tMsgPort;               { MessagePort 1, a new one        }
  ReplyPort : tMsgPort;               { MessagePort 2, a reply port     }
  OldPort   : pMsgPort;               { Pointer to an oldport           }
  MsgSend   : tMessage;               { Message to send                 }
  MsgReceive: pMessage;               { Message to receive              }
  Dummy     : pMessage;               { Dummy for WaitPort              }
  PortName  : string;                 { PASCAL string                   }
  PortCName : ARRAY [1..40] OF BYTE;  { C string                        }
  NodeName  : string;                 { PASCAL string                   }
  NodeCName : ARRAY [1..40] OF BYTE;  { C string                        }
                
    
{***********************************************************************}
{ OpenIntuitionLib(version);                                            }
{                                                                       }
{ Tries to open the Intuition.library, if version=0 then ANY            }
{ version of intuition.library will be opened.                          }
{ It will return TRUE or FALSE.                                         }
{***********************************************************************}  
FUNCTION OpenIntuitionLib(version:INTEGER):BOOLEAN;
BEGIN
  IntuitionBase:=pIntuitionBase(OpenLibrary('intuition.library',version));
  IF IntuitionBase=NIL THEN
    OpenIntuitionLib:=FALSE           { Couldn't open intuition.library }
  ELSE
    OpenIntuitionLib:=TRUE;           { Yippy! Opened intuition.library }
END;

{***********************************************************************}  
{ OpenNewWindow(....);                                                  }
{                                                                       }
{ Tries to open a NewWindow, ALL parameters for the NewWindowStruct     }
{ are passed to OpenNewWindow !                                         }
{ It will return the pWindow pointer.                                   }
{ TitleMode is TRUE if you USE a title, and FALSE if you don't !!       }
{ If you don't use a title then enter ANY kind of string, ie. ''.       }
{***********************************************************************}  
FUNCTION OpenNewWindow(WLeftEdge,WTopEdge,WWidth,WHeight: INTEGER;
                       WDetailPen,WBlockPen: shortint;
                       WIDCMPFlags,WFlags: long;
                       WFirstGadget: pGadget;
                       WCheckMark: pImage;
                       WTitle: string;
                       WScreen: pScreen;
                       WBitMap: pBitMap;
                       WMinWidth,WMinHeight: INTEGER;
                       WMaxWidth,WMaxHeight,WType_: word;
                       TitleMode:BOOLEAN):pWindow;
VAR TempWindow  :  tNewWindow;
    TempTitle   :  ARRAY [1..80] OF byte;
BEGIN
  IF TitleMode THEN                   { Title to C-format string        }
    PasToC(WTitle,TempTitle);
  WITH TempWindow DO
    BEGIN
      LeftEdge    :=WLeftEdge;        { Look at the AutoDocs or         }
      TopEdge     :=WTopEdge;         { intuition unit for more details }
      Width       :=WWidth;
      Height      :=WHeight;
      DetailPen   :=WDetailPen;
      BlockPen    :=WBlockPen;
      IDCMPFlags  :=WIDCMPFlags;
      Flags       :=WFlags;
      FirstGadget :=WFirstGadget;
      CheckMark   :=WCheckMark;
      Title       :=@TempTitle;        { POINTER to the title string    }
      Screen      :=WScreen;
      BitMap      :=WBitMap;
      MinWidth    :=WMinwidth;
      MinHeight   :=WMinHeight;
      MaxWidth    :=WMaxWidth;
      MaxHeight   :=WMaxHeight;
      Type_       :=WType_;
    END;
    IF NOT(TitleMode) THEN
      TempWindow.Title:=NIL;           { No title used...               }
    OpenNewWindow := OpenWindow(@TempWindow);  
END;

{***********************************************************************}  
{ Main                                                                  }
{***********************************************************************}  
BEGIN
  IF OpenIntuitionLib(0) THEN           { Try to open intuition.library }
    BEGIN
      PortName:='AutoRemove Port';      { Our Port's name...            }
      PasToC(PortName,PortCName);       { Convert it to C-String        }
      OldPort:=FindPort(@PortCName);    { Look if it is already there   }
      IF (OldPort<>NIL) THEN            { <>NIL = Found our port        }
        BEGIN
          Window:=OpenNewWindow(100,150,300,45,2,3,ACTIVEWINDOW,
                                 SMART_REFRESH OR NOCAREREFRESH,
                                 NIL,NIL,'^ AutoRemove Already Started',
                                 NIL,NIL,10,10,640,256,WBENCHSCREEN,TRUE);
      
          NodeName:='AutoRemove Reply'; { Create our new port...        }
          PasToC(NodeName,NodeCName);   { and convert it to C-String    }
      
          ReplyPort.mp_Node.ln_Pri:=0;  { Init this new port            }
          ReplyPort.mp_Node.ln_Name:=@NodeCName;
          ReplyPort.mp_SigTask:=pTask(FindTask(NIL));
          AddPort(@ReplyPort);          { Add this new port             }
      
          MsgSend.mn_length:=SizeOf(tMessage);  { Init a message        }
          MsgSend.mn_Node.ln_Type:=NT_MESSAGE;  
          MsgSend.mn_ReplyPort:=@ReplyPort;
          PutMsg(OldPort,@MsgSend);     { Send it to the oldport...     }
      
          MsgReceive:=WaitPort(@ReplyPort); { Wait for respons..        }
          RemPort(@ReplyPort);          { Remove the oldport            }
          Delay(2000);
          CloseWindow(window);
        END
      ELSE
        BEGIN 
          Window:=OpenNewWindow(100,100,300,45,2,3,ACTIVEWINDOW,
                                SMART_REFRESH OR NOCAREREFRESH,
                                NIL,NIL,'AutoRemove Started',NIL,NIL,
                                10,10,640,256,WBENCHSCREEN,TRUE);
          IF Window<>NIL THEN                       { Window opened ??? }
            BEGIN  
              NewPort.mp_Node.ln_Pri:=0;      { Init this port          }
              NewPort.mp_Node.ln_Name:=@PortCName;
              NewPort.mp_SigTask:=pTask(FindTask(NIL));
              AddPort(@NewPort);              { Add this port           }
              
              Dummy:=WaitPort(@NewPort);      { Wait for a message      }
              MsgReceive:=GetMsg(@NewPort);     { Get the message       }
              ReplyMsg(MsgReceive);           { Reply to message        }
              RemPort(@NewPort);              { Remove this port        }
              Delay(2000);   { Small delay, so you'll notice the action }
              CloseWindow(Window);            { Close the window        }
            END;
        END;
      CloseLibrary(pLibrary(IntuitionBase));  { Close LIBS !!           }
    END;
END.  
