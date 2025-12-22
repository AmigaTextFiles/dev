{*******************************************************************}
{ IntuitionDemo.PAS                                                 }
{                                                                   }
{ Clear code for showing you the use of Intuition and Graphics on   }
{ the Amiga...                                                      }
{*******************************************************************}
{ By Hans Luyten September 1993                                     }
{ Compiler: HighSpeed Pascal 1.1                                    }
{*******************************************************************}
PROGRAM Intuitiondemo;

uses
  Exec, Intuition, Graphics;          { We need these....           }

VAR
  MyWindow  :  tNewWindow;            { Struct for the NewWindow    }
  Window    : pWindow;                { Pointer to the NewWindow    }
  MyRastPort:  pRastPort;             { Pointer to Window RastPort  }
  
  Teller    : INTEGER;
  c          : CHAR;
                  
  TempString: ARRAY [1..80] OF byte;  { Temp C-stringkind           }
    
{*******************************************************************}
{ OpenIntuitionLib(version);                                        }
{                                                                   }
{ Tries to open the Intuition.library, if version=0 then ANY        }
{ version of intuition.library will be opened.                      }
{ It will return TRUE or FALSE.                                     }
{*******************************************************************}  
FUNCTION OpenIntuitionLib(version:INTEGER):BOOLEAN;
BEGIN
  IntuitionBase:=pIntuitionBase(OpenLibrary('intuition.library',version));
  IF IntuitionBase=NIL THEN
    OpenIntuitionLib:=FALSE
  ELSE
    OpenIntuitionLib:=TRUE;
END;

{*******************************************************************}
{ OpenGraphicsLib(version);                                         }
{                                                                   }
{ Tries to open the Graphics.library, if version=0 then ANY         }
{ version of Graphics.library will be opened.                       }
{ It will return TRUE or FALSE.                                     }
{*******************************************************************}  
FUNCTION OpenGraphicsLib(version:INTEGER):BOOLEAN;
BEGIN
  GfxBase:=pGfxBase(OpenLibrary('graphics.library',version));
  IF GfxBase=NIL THEN
    OpenGraphicsLib:=FALSE
  ELSE
    OpenGraphicsLib:=TRUE;
END;

{*******************************************************************}
{ GfxText(RPort,x,y,color,'Text');                                  }
{                                                                   }
{ Display the text on the rastport... using color and x,y           }
{ OutTextXY() look-a-like using intuition/graphics                  }
{*******************************************************************}
PROCEDURE GfxText(RPort : pRastPort; x,y : INTEGER; 
                  color : INTEGER; TempText : String);
VAR
  TempString  :  ARRAY [1..80] OF byte;
BEGIN
  SetAPen(RPort,Color);                       { Set Pen Color       }
  Move_(RPort,x,y);                           { Move pen            }
  PasToC(TempText,TempString);                { Convert to C-String }
  Text_(RPort,@TempString,length(TempText));  { Write string !!     }
END;

{*******************************************************************}  
{ OpenNewWindow(....);                                              }
{                                                                   }
{ Tries to open a NewWindow, ALL parameters for the NewWindowStruct }
{ are passed to OpenNewWindow !                                     }
{ It will return the pWindow pointer.                               }
{ TitleMode is TRUE if you USE a title, and FALSE if you don't !!   }
{*******************************************************************}  
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
  IF TitleMode THEN                { Title to C-format string       }
    PasToC(WTitle,TempTitle);
  WITH TempWindow DO
    BEGIN
      LeftEdge    :=WLeftEdge;
      TopEdge     :=WTopEdge;
      Width       :=WWidth;
      Height      :=WHeight;
      DetailPen   :=WDetailPen;
      BlockPen    :=WBlockPen;
      IDCMPFlags  :=WIDCMPFlags;
      Flags       :=WFlags;
      FirstGadget :=WFirstGadget;
      CheckMark   :=WCheckMark;
      Title       :=@TempTitle;    { POINTER to the title string    }
      Screen      :=WScreen;
      BitMap      :=WBitMap;
      MinWidth    :=WMinwidth;
      MinHeight   :=WMinHeight;
      MaxWidth    :=WMaxWidth;
      MaxHeight   :=WMaxHeight;
      Type_       :=WType_;
    END;
    IF NOT(TitleMode) THEN
      TempWindow.Title:=NIL;
    OpenNewWindow := OpenWindow(@TempWindow);  
END;

{*******************************************************************}  
{ Main                                                              }
{*******************************************************************}  
BEGIN
  IF ((OpenIntuitionLib(39))AND(OpenGraphicsLib(39))) THEN
  BEGIN
    Window:=OpenNewWindow(10,10,600,200,2,3,ACTIVEWINDOW,
                          SMART_REFRESH OR NOCAREREFRESH,
                          NIL,NIL,
                          'My First HighSpeed Pascal Window',
                          NIL,NIL,10,10,640,256,
                          WBENCHSCREEN,TRUE);
            
    IF Window<>NIL THEN
      BEGIN  
        MyRastPort:=Window^.RPort;            { The window-Rastport }
        
        FOR Teller:=1 TO 150 DO
          BEGIN
            SetAPen(MyRastPort,Random(8));    
            DrawCircle(MyRastPort,Random(500)+50,Random(100)+50,Random(30));
          END;
        Move_(MyRastPort,300,40);             { Draw circles...     }
        
        GfxText(MyRastPort,300,40,1,'A Small demo in HSPascal ');
                
        SetAPen(MyRastPort,2);
        Move_(MyRastPort,300,42);             { Move pen            }
        Draw(MyRastPort,490,42);              { Underline text      }
        
        GfxText(MyRastPort,300,190,3,'I will exit after 3000 MilliSecs...');
        
        Delay(3000);                    
        CloseWindow(Window);                  { Close the window    }
      END;
    CloseLibrary(pLibrary(IntuitionBase));    { Close LIBS !!       }
    CloseLibrary(pLibrary(GfxBase));
  END;
END.  