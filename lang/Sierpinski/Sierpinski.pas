{*******************************************************************}
{ SierPinski.PAS 		                                                }
{                                                                   }
{ Clear code for showing you the use of Intuition and Graphics on   }
{ the Amiga...                                                      }
{*******************************************************************}
{ By Hans Luyten September 1993                                     }
{ Compiler: HighSpeed Pascal 1.1                                    }
{*******************************************************************}
PROGRAM SierPinski;

uses
  Exec, Intuition, Graphics;          { We need these....           }

const
	xTop = 250;
	yTop = 10;
	
VAR
  MyWindow  :  tNewWindow;            { Struct for the NewWindow    }
  Window    : pWindow;                { Pointer to the NewWindow    }
  MyRastPort:  pRastPort;             { Pointer to Window RastPort  }
  
  Teller    : INTEGER;
  c         : CHAR;
                  
  TempString: ARRAY [1..80] OF byte;  { Temp C-stringkind           }
  
  Max_Been	: integer;
  Min_Been  : integer;
    
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
{ DrieHoek(x,y,size);																								}
{																																		}
{ This part draws a triangle with top (x,y) and leggs size.         }
{*******************************************************************}  
procedure Driehoek(x,y : integer; been : integer);
var
	x_Temp : integer;
	y_Temp : integer;
begin
	Move_(MyRastPort,x,y);
	
	x_Temp:=x+(been div 2);
	y_Temp:=y+round(sqrt(sqr(been)-sqr(been div 2)));
	Draw(MyRastPort,x_Temp,y_Temp);
	
	x_Temp:=x-(been div 2);
	Draw(MyRastPort,x_Temp,y_Temp);
	
	Draw(MyRastPort,x,y);
end;

{*******************************************************************}  
{ Tri_Triangle(x,y,been,min_been);																	}
{ 																																	}
{ This is the recursive part of the Sierpinski routine.							}
{*******************************************************************}  
procedure Tri_Triangle(x,y : integer; been, min_been: integer);
var
	x_Temp : integer;
	y_Temp : integer;
begin
	if been >= Min_Been then
		begin
			been:=(been div 2);
			DrieHoek(x,y,been);
			Tri_Triangle(x,y,been,Min_Been);
			
			x_Temp:=x+(been div 2);
			y_Temp:=y+round(sqrt(sqr(been)-sqr(been div 2)));
			Driehoek(x_Temp,y_Temp,been);
			Tri_Triangle(x_temp,y_temp,been, min_been);
			
			x_Temp:=x-(been div 2);
			DrieHoek(x_Temp,y_Temp,been);
			Tri_Triangle(x_temp,y_temp,been,min_been);
		end;
end;

{*******************************************************************}  
{ Main                                                              }
{*******************************************************************}  
BEGIN
	Max_Been:=247;
	Min_Been:=7;
	
  IF ((OpenIntuitionLib(39))AND(OpenGraphicsLib(39))) THEN
  BEGIN
    Window:=OpenNewWindow(10,10,600,240,2,3,ACTIVEWINDOW,
                          SMART_REFRESH OR NOCAREREFRESH,
                          NIL,NIL,
                          'My First HighSpeed Pascal Window',
                          NIL,NIL,10,10,640,256,
                          WBENCHSCREEN,FALSE);
            
    IF Window<>NIL THEN
      BEGIN  
        MyRastPort:=Window^.RPort;            { The window-Rastport }
        
        GfxText(MyRastPort,370,20,4,'Sierpinski,...');
        GfxText(MyRastPort,370,29,4,'A small HSPascal demo,');
        GfxText(MyRastPort,370,38,4,'By Hans Luyten...');
        
        SetAPen(MyRastPort,1);
        Tri_Triangle(xTop,yTop,max_been,min_been);
        
        GfxText(MyRastPort,370,50,3,'Waiting 3000 MilliSecs...');
        
        Delay(3000); 
        
        CloseWindow(Window);                  { Close the window    }
      END
    ELSE
    	writeln('Could not open a window !');
    CloseLibrary(pLibrary(IntuitionBase));    { Close LIBS !!       }
    CloseLibrary(pLibrary(GfxBase));
  END;
END.  