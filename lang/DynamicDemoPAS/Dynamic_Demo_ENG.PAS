{*******************************************************************}
{ DynamicLists V1.2                                                 }
{*******************************************************************}
{ Een demonstratie hoe je met dynamic lists kunt werken.            }
{*******************************************************************}
{ Door Hans Luyten                                                  }
{                                                                   }
{ Compiler: HiSpeed Pascal v2.0 (Amiga)                             }
{           (Works also with:  Turbo Pascal >v5.5  (MSDos)          }
{                        and: HiSpeed Pascal >v2.4 (Atari))         }
{           HiSpeed Pascal: (c) 1992 HiSoft                         }
{           Turbo Pascal:   (c) 1991 Borland                        }
{                                                                   }
{ Remark: VGAHi is also supported on Amiga and Atari HSPascal !!    }
{                                                                   }
{ Compiler options: Range Check, Stack Check, I/O Check             }
{                                                                   }
{*******************************************************************}
{ Version: 1.0, 17 September 1993.                                  }
{                                                                   }
{ Version: 1.1, 18 September 1993, Added:     Delete Node,          }
{                                             Position Insert.      }            
{ Version: 1.2, 19 September 1993, Bug removed at 'Delete' and      }
{                                 'positionInsert', also index-     }
{                                 line for nodenumbering added.     }
{*******************************************************************}
PROGRAM DynamicLists;

uses
  Graph,Crt;
TYPE                                             { Onze LINKEDLIST  } 
  StudentP    = ^StudentData;
  StudentData = RECORD
                  Naam   : string[10];
                  ANr    : string[10];
                  Next   : StudentP;
                END;
CONST
  CX      =  8;                                  { Karakter afstand }
  CY      = 8;                                   { Regel afstand    }
  FormH   = 20;                                  { Node Hoogte      }
  FormW   = 95;                                  { Node Breedte     }      
  Dist    =  5;                                  { Block afstand    }
  MaxNodes= 5;                                   { Maximum Nodes    }

VAR 
  StudentHead : StudentP;
  VGAMode     : BOOLEAN;
  c           : CHAR;
  OldPalette  : PaletteType;
  ActiveNodes : INTEGER;
  
{*******************************************************************}
{************************* Alg-Procedures **************************}
{*******************************************************************}

{*******************************************************************}
{ FixBar(x,y,x2,y2,Color1,Color2);                                  }
{ Vervangt SetColor, SetFillStyle en Bar in 1 procedure.            }
{*******************************************************************}
{ PRE  : VGAMode                                                    }
{ POST : Bar getekend.                                              }
{*******************************************************************}
PROCEDURE FixBar(x,y,x2,y2 : INTEGER; color1, color2 : INTEGER);
BEGIN
  SetColor(Color1);
  SetFillStyle(SolidFill,Color2);
  Bar(x,y,x2,y2);
END;

{*******************************************************************}
{ LeesInput(x,y,'Naam:',String);                                    }
{ Leest het keyboard tijdens grafisch scherm (ReadLn geeft probleem)}
{ van maximaal 10 tekens !                                          }
{*******************************************************************}
{ PRE  : VGAMode=TRUE                                               }
{ POST : In String staat de input.                                  }
{*******************************************************************}
PROCEDURE LeesInput(x,y: INTEGER; header : String; 
                    VAR TEXT : String);
CONST
  MaxLengte = 10;
VAR
  Letter : CHAR;
  Teller : INTEGER;
BEGIN
  OutTextXY(x+CX,y+CY,header);
  TEXT:='';
  FOR Teller:=1 TO MaxLengte DO
    BEGIN
      Letter:=ReadKey;
      IF ((Letter>CHR(31)) AND (Letter<CHR(127))) THEN
        BEGIN                                 { Letters/Cijfers ?   }
          TEXT:=concat(TEXT,Letter);          { Nieuwe letter erbij }
          OutTextXY(x+CX*(Teller+6),y+CY,Letter);
        END          
      ELSE IF ((Letter=CHR(13)) OR (Letter=CHR(10))) THEN
        exit                                  { RETURN = chr(13)    }
      ELSE IF Letter=CHR(8) THEN
        BEGIN                                 { Backspace = chr(8)  }
          IF Teller>2 THEN
            BEGIN
              Teller:=Teller-2; { backspace + voorganger = 2 chars !}
              delete(TEXT,Teller+1,1);        { verwijder laatste   }
              FixBar(x+CX*(Teller+7),y+CY,x+CX*(Teller+8),y+2*CY,
                     Yellow,Yellow);
              SetColor(DarkGray);
            END
          ELSE
            BEGIN
              TEXT:='';                       { Alles wissen !!     }
              Teller:=0;                      { = opnieuw invoeren  }
              FixBar(x+CX*(Teller+7),y+CY,x+CX*(Teller+8),y+2*CX,
                     Yellow,Yellow);
              SetColor(DarkGray);
            END;
        END
      ELSE 
        Letter:=ReadKey;                      { Ctrl-codes opvangen }
    END;
END;

{*******************************************************************}
{************************* GFX-Procedures **************************}
{*******************************************************************}
  
{*******************************************************************}
{ OpenVGAScreen();                                                  }
{ Deze procedure zal proberen een VGAScherm te openen (600x480)     }
{ Tevens worden de gebruikte kleuren aangepast.                     }
{ Note: VGAHi wordt door HiSpeed Pascal (Amiga en Atari) en         }
{       Turbo-Pascal (PC) simuleert/ondersteund !!                  }
{*******************************************************************}
{ PRE  : De variabele VGAMode (boolean) moet geinitialiseerd        }
{        zijn als globale variabele.                                }
{ POST : Als het VGA-scherm open is, is VGAMode=TRUE.               }
{        Zoniet, dan is VGAMode=FALSE.                              }
{*******************************************************************}
PROCEDURE OpenVGAScreen;
VAR
  GfxDriver, DriverMode, ErrorCode : INTEGER;
BEGIN
  GfxDriver:=Detect;                             { Gfx mogelijk ?   }
  InitGraph(GfxDriver,DriverMode,'');            { Gfx Init         }
  SetGraphMode(VGAHi);                           { Probeer VGA ..   }
  ErrorCode:=GraphResult;                        { VGA gelukt ??    }
  IF ErrorCode=grOK THEN
    VGAMode:=TRUE                                { VGA Gelukt...    }
  ELSE
    VGAMode:=FALSE;                              { Niks geen VGA !  }
  IF VGAMode=TRUE THEN
    BEGIN
      GetPalette(OldPalette);                    { Actieve Palette  }
      SetRGBPalette(Black   ,0 ,0 ,0 );          { opslaan en       }
      SetRGBPalette(Blue    ,0 ,0 ,63);          { instellen voor   }
      SetRGBPalette(Green   ,0 ,63,0 );          { correcte kleur-  }
      SetRGBPalette(Red     ,63,0 ,0 );          { Palette.         }
      SetRGBPalette(Yellow  ,63,63,0 );          { Ook voor Amiga,  }
      SetRGBPalette(White   ,63,63,63);          { Atari en PC !!   }
      SetRGBPalette(DarkGray,20,20,20);          { HIGHSPEED PASCAL }
      SetColor(Yellow);
      OutTextXY(180,470,'(C) 1993 By Hans Luyten. A-Yeah!');
    END;  
END;

{*******************************************************************}
{ RestoreColors;                                                    }
{ Herstelt oude palette... (als het goed is...)                     }
{*******************************************************************}
{ PRE  : OldPalette moet de oude palette bevatten.                  }
{ POST : Oude Palette actief.                                       }
{*******************************************************************}
PROCEDURE RestoreColors;
BEGIN
  SetAllPalette(OldPalette);
END;

{*******************************************************************}
{ DrawShadowBox(x,y,w,h);                                           }
{ Tekent een Shadowed-box.                                          }
{*******************************************************************}
{ PRE  : VGAMode moet TRUE zijn (en dus geopend zijn!).             }
{ POST : Box op het sherm met schaduw rand.                         }
{*******************************************************************}
PROCEDURE DrawShadowBox(x,y,w,h:INTEGER);
BEGIN
  FixBar(x+3,y+3,x+w+3,y+h+3,DarkGray,DarkGray);  
  FixBar(x,y,x+w,y+h,Yellow,Yellow);
END;

{*******************************************************************}
{ DrawNodeBox(x,y);                                                 }
{ Tekent een NODE-Box voor de Linked-List.                          }
{*******************************************************************}
{ PRE  : Heeft DrawShadowBox en VGAMode=TRUE nodig.                 }
{ POST : Een 3-delige box op het scherm.                            }
{*******************************************************************}
PROCEDURE DrawNodeBox(x,y: INTEGER);
VAR
  Teller : INTEGER;
BEGIN
  FOR Teller:=0 TO 2 DO
    DrawShadowBox(x,y+(FormH+Dist)*Teller,FormW,FormH);
END;

{*******************************************************************}
{ DrawPointer(x,y);                                                 }
{ Tekent een NODE-pointer voor de Linked-List (PIJL).               }
{*******************************************************************}
{ PRE  : Heeft VGAMode=TRUE nodig.                                  }
{ POST : Pijl van Node n^.Next naar Node n+1^.Naam.                 }
{*******************************************************************}
PROCEDURE DrawPointer(x,y : INTEGER);
BEGIN
  y:=y+2*FormH+2*Dist+(FormH DIV 2);
  x:=x+FormW-3*Dist;
  SetColor(DarkGray);
  SetFillStyle(SolidFill,DarkGray);
  Circle(x,y,5);                                        { Cirkeltje }
  SetColor(DarkGray);
  FloodFill(x-3,y,DarkGray);                            { gevuld .. }
  Bar(x+4,y-2,x+5*Dist,y+2);
  Bar(x+5*Dist,y+2,x+5*Dist+4,y-2*FormH-2*Dist);
  Bar(x+5*Dist+4,y-2*FormH-2*Dist,x+7*Dist,y-2*FormH-2*Dist+4);
  PieSlice(x+8*Dist+4,y-2*FormH-2*Dist+2,138,215,10);
END;

{*******************************************************************}
{ DrawMenu(x,y);                                                    }
{ Tekent option-menu (F1..F5).                                      }
{*******************************************************************}
{ PRE  : Heeft DrawShadowBox en VGAMode=TRUE nodig.                 }
{ POST : Een Menu-Box voor de opties.                               }
{*******************************************************************}
PROCEDURE DrawMenu(x,y : INTEGER);
BEGIN
  DrawShadowBox(x,y,32*CX,17*CY);
  SetColor(DarkGray);
  OutTextXY(x+CX,y+CY,'Opties:');
  OutTextXY(x+CX,y+3*CY, '1 Head Insertion Node');
  OutTextXY(x+CX,y+5*CY, '2 Position Insertion Node');
  OutTextXY(x+CX,y+7*CY, '3 Tail Insertion Node');
  OutTextXY(x+CX,y+9*CY, '4 Remove Node');
  OutTextXY(x+CX,y+11*CY,'5 Exit program');
  OutTextXY(x+CX,y+15*CY,'(Max. 5 Nodes Allowed!)');
END;

{*******************************************************************}
{ DrawNodeIndex;                                                    }
{ Tekent de balk met daarin de node nummering.                      }
{*******************************************************************}
{ PRE  : VGAMode moet TRUE zijn, en de procedure DrawShadowBox      }
{         moet aanwezig zijn.                                       }
{ POST : Een genummerde balk.                                       }
{*******************************************************************}
PROCEDURE DrawNodeIndex;
BEGIN
  DrawShadowBox(20,250,595,3*CX);
  SetColor(DarkGray);
  OutTextXY(20+CX ,250+CY,'[Number 1]');
  OutTextXY(145+CX,250+CY,'[Number 2]');
  OutTextXY(270+CX,250+CY,'[Number 3]');
  OutTextXY(395+CX,250+CY,'[Number 4]');
  OutTextXY(520+CX,250+CY,'[Number 5]');
END;

  
{*******************************************************************}
{********************* DynamicList-Procedures **********************}
{*******************************************************************}
  
{*******************************************************************}
{ EmptyList(StudentP);                                              }
{ Kijkt of een DynamischeLijst LEEG is. Een lege lijst is een lijst }
{ waarvoor nog geen 'new()' is gebruikt. StudentP wijst dus naar NIL}
{*******************************************************************}
{ PRE  : Type 'StudentP' moet gedefinieerd zijn.                    }
{ POST : De functie geeft TRUE als de lijst leeg is, FALSE als de   }
{        lijst niet leeg is.                                        }
{*******************************************************************}
FUNCTION EmptyList(Student : StudentP):BOOLEAN;
BEGIN
  IF Student=NIL THEN
    EmptyList:=TRUE                 { Head=NIL betekent: LEGE lijst }
  ELSE
    EmptyList:=FALSE;
END;

{*******************************************************************}
{ InputStudent(x,y,StudentP);                                       }
{ Invoer van de data voor 'StudentP'.                               }
{*******************************************************************}
{ PRE  : 'StudentP' moet geinitialiseerd zijn met new().            }
{        en VGAMode=TRUE.                                           }
{ POST : 'StudentP' bevat de nieuwe data.                           }
{*******************************************************************}
PROCEDURE InputStudent(x,y : INTEGER;VAR Current : StudentP);
BEGIN
  SetColor(Yellow);
  DrawShadowBox(x-CX,y-CY,23*CX,7*CY);
  SetColor(DarkGray);
  OutTextXY(x,y,'Input New node');
  LeesInput(x,y+CY,'Name:',Current^.Naam);
  LeesInput(x,y+3*CY,'ANr :',Current^.ANr);
  FixBar(x-Cx,y-3*CY,x+22*CX+Dist,y+6*CY+Dist,Black,Black);
END;

{*******************************************************************}
{ OutputStudent(x,y,StudentP);                                      }
{ Weergave van de data die in de node 'StudentP' staat.             }
{*******************************************************************}
{ PRE  : 'StudentP' moet geinitialiseerd zijn met new() en mag niet }
{        leeg zijn.                                                 }
{ POST : De inhoud van StudentP op het scherm.                      }
{*******************************************************************}
PROCEDURE OutputStudent(x,y : INTEGER; Current : StudentP);
BEGIN
  DrawNodeBox(x,y);
  SetColor(DarkGray);
  OutTextXY(x+CX,y+CY,Current^.Naam);
  OutTextXY(x+CX,y+CY+FormH+Dist,Current^.ANr);
  IF Current^.Next=NIL THEN
    OutTextXY(x+CX,Y+CY+2*FormH+2*Dist,'NIL')
  ELSE
    DrawPointer(x,y);
END;

{*******************************************************************}
{ GotoEnd(StudentP);                                                }
{ Maakt van 'StudentP' de pointer naar de laatste node. Let dus op! }
{*******************************************************************}
{ PRE  : Type 'StudentP' moet gedefinieerd zijn.                    }
{         De lijst mag ook NIET leeg zijn !                         }
{ POST : 'StudenP' wijst nu naar de LAATSTE node in de lijst.       }
{*******************************************************************}
PROCEDURE GotoEnd(VAR Position : StudentP);
BEGIN
  WHILE Position^.Next<>NIL DO        { Laatste Node wijst naar NIL }
    Position:=Position^.Next;
END;

{*******************************************************************}
{ GotoNodeNr(n,StudentP);                                           }
{ Maakt van 'StudentP' de pointer naar de n-de node. Let dus op!    }
{*******************************************************************}
{ PRE  : Type 'StudentP' moet gedefinieerd zijn.                    }
{         De lijst mag ook NIET leeg zijn !                         }
{ POST : 'StudenP' wijst nu naar de n-de node in de lijst.          }
{*******************************************************************}
PROCEDURE GotoNodeNr(n : INTEGER; VAR Position : StudentP);
VAR
  Teller : INTEGER;
  Temp   : StudentP;
BEGIN
  Position:=StudentHead;
    FOR Teller:=2 TO n DO        { StudentHead is global 1e node !! }
    BEGIN
       IF Position^.Next<>NIL THEN { Laatste Node wijst naar NIL !! }
      Position:=Position^.Next;
    END;
END;

{*******************************************************************}
{ HeadInsert(x,y,StudentP);                                         }
{ Initialiseerd indien nodig de lijst en voegt aan de kop van de    }
{ lijst een nieuwe node toe.                                        }
{*******************************************************************}
{ PRE  : Type 'StudentP' moet gedefinieerd zijn.                    }
{ POST : De lijst is 1 node langer geworden, aan de kop !           }
{*******************************************************************}
PROCEDURE HeadInsert(x,y : INTEGER; VAR Head : StudentP);
VAR
  Node  : StudentP;
  Empty : BOOLEAN;
BEGIN
  Empty:=EmptyList(Head);        { Kijk of de lijst leeg is         }
  IF Empty THEN
    BEGIN
      NEW(Head);                 { Lege lijst wordt geinitialiseerd }
      Node:=Head;                { Nieuw node = head, bij lege lijst}
    END
  ELSE
    NEW(Node);                   { Er wordt een 'node' toegevoegd   }
  InputStudent(x,y,Node);        { Invoer data van de node          }
  IF Empty THEN
    Node^.Next:=NIL
  ELSE
    BEGIN
      Node^.Next:=Head;          { Vooraan schuiven van de node     }
      Head:=Node;
    END;
END;

{*******************************************************************}
{ PositionInsert(x,y,StudentP);                                     }
{ Initialiseerd indien nodig de lijst en plaatst op POS een nieuwe  }
{ node in de lijst. Doet OOK position insert als: -de lijst leeg is }
{                                                 -Maar 1 node heeft}
{*******************************************************************}
{ PRE  : Type 'StudentP' moet gedefinieerd zijn.                    }
{ POST : De lijst is 1 node langer geworden.                        }
{*******************************************************************}
PROCEDURE PositionInsert(x,y : INTEGER; VAR Head : StudentP);
VAR
  Node     : StudentP;
  Position : StudentP;
  Empty    : BOOLEAN;
  Invoer   : string[15];
  Nr       : INTEGER;
  
BEGIN
  Empty:=EmptyList(Head);        { Kijk of de lijst leeg is         }
  IF Empty THEN
    BEGIN
      NEW(Head);                 { Lege lijst wordt geinitialiseerd }
      Node:=Head;                { Nieuw node = head, bij lege lijst}
      Node^.Next:=NIL;           { eerste en laatse Node            }
    END
  ELSE IF ActiveNodes<2 THEN
    BEGIN
      NEW(Node);
      Head^.Next:=Node;
      Node^.Next:=NIL;
    END 
  ELSE IF ActiveNodes>1 THEN
    BEGIN
      NEW(Node);                  { Er wordt een 'node' toegevoegd  }
      Position:=Head;
      Invoer:='Position number [1-';
      Invoer:=ConCat(Invoer,CHR(48+ActiveNodes),']: ');
      REPEAT                      { Read 1-ActiveNodes (max=5)      }
        SetColor(Yellow);
        SetFillStyle(SolidFill,Yellow);
        DrawShadowBox(x-CX,y-CY,23*CX,3*CY);
        SetColor(DarkGray);
        OutTextXY(x,y,Invoer);
        c:=readKey;
      UNTIL ((c>#48)AND(c<CHR(48+ActiveNodes+1)));
      Nr:=ORD(c)-48;    
      GotoNodeNr(Nr-1,Position);  { Add after n-1                   }
    END;
  InputStudent(x,y,Node);         { Invoer data van de node         }
  IF (NOT(Empty)AND(ActiveNodes>1)) THEN
    BEGIN  
      Node^.Next:=Position^.Next;
      Position^.Next:=Node;
    END
  ELSE IF Empty THEN
    Head:=Node;
END;

{*******************************************************************}
{ TailInsert(x,y,StudentP);                                         }
{ Initialiseerd indien nodig de lijst en voegt aan de staart van de }
{ lijst een nieuwe node toe.                                        }
{*******************************************************************}
{ PRE  : Type 'StudentP' moet gedefinieerd zijn.                    }
{ POST : De lijst is 1 node langer geworden, aan de staart !        }
{*******************************************************************}
PROCEDURE TailInsert(x,y : INTEGER; VAR Head : StudentP);
VAR
  Node  : StudentP;
  Tail  : StudentP;
  Empty : BOOLEAN;
BEGIN
  Empty:=EmptyList(Head);        { Kijk of de lijst leeg is         }
  IF Empty THEN
    BEGIN
      NEW(Head);                 { Lege lijst wordt geinitialiseerd }
      Node:=Head;                { Nieuw node = head, bij lege lijst}
    END
  ELSE
    BEGIN
      NEW(Node);                 { Er wordt een 'node' toegevoegd   }
      Tail:=Head;
      GotoEnd(Tail);
    END;
  InputStudent(x,y,Node);        { Invoer data van de node          }
   Node^.Next:=NIL;
  IF NOT(Empty) THEN
    Tail^.Next:=Node             { Achteraan schuiven van de node   }
  ELSE
    Head:=Node;
END;

{*******************************************************************}    
{ ShowList(x,y,StudentP);                                           }
{ Laat alle nodes in een lijst zien, te beginnen bij de node die    }
{ als parameter gegeven wordt (studentP).                           }
{*******************************************************************}
{ PRE  : Type 'StudentP' moet gedefinieerd zijn.                    }
{ POST : Als de lijst niet leeg is, is de hele lijst zichtbaar      }
{        vanaf 'StudentP'.                                          }
{*******************************************************************}
PROCEDURE ShowList(x,y : INTEGER;Head : StudentP);
BEGIN
  IF NOT(EmptyList(Head)) THEN
    BEGIN
      OutputStudent(x,y,Head);
      x:=x+FormW+6*Dist;    
      ShowList(x,y,Head^.Next);      { recursion }
    END;
END;

{*******************************************************************}  
{ DeleteNode(x,y);                                                  }
{ Verwijderd een node, nummer wordt afgevraagd.                     }
{*******************************************************************}
{ PRE  : Er moet minstens 1 node in de list staan.                  }
{ POST : 1 element minder in de list.                               }  
{*******************************************************************}  
PROCEDURE DeleteNode(x,y : INTEGER);
VAR
  Nr       : INTEGER;
  Position : StudentP;
  BadNode  : StudentP;
  Invoer   : string[35];
BEGIN
  Position:=StudentHead;
  IF StudentHead^.Next=NIL THEN
    DISPOSE(StudentHead)
  ELSE    
    BEGIN  
      Invoer:='Remove Position number [1-';
      Invoer:=ConCat(Invoer,CHR(48+ActiveNodes),']: ');
      REPEAT                      { Read 1-ActiveNodes (max=5)      }
        SetColor(Yellow);
        SetFillStyle(SolidFill,Yellow);
        DrawShadowBox(x-CX,y-CY,36*CX,3*CY);
        SetColor(DarkGray);
        OutTextXY(x,y,Invoer);
        c:=readKey;
      UNTIL ((c>#48)AND(c<=CHR(48+ActiveNodes+1)));
      Nr:=ORD(c)-48;              { pos 2 =  insert NA pos 1        }  
    IF Nr>1 THEN
      BEGIN
        GotoNodeNr(Nr-1,Position);
        BadNode:=Position^.Next;
        Position^.Next:=BadNode^.Next;                { Wipe Node   }
        DISPOSE(BadNode);                             { free memory }    
      END
    ELSE 
      BEGIN
        BadNode:=StudentHead;
        StudentHead:=BadNode^.Next;
        DISPOSE(BadNode);
      END;
    END;
    FixBar(x-CX,y-CY,x+36*CX+Dist,y+4*CY,Black,Black);
END;

{*******************************************************************}
{ ClearList;                                                        }
{ Verwijderd de LinkedList uit het geheugen, reserved memory komt   }
{ nu vrij voor andere toepassingen.                                 }
{*******************************************************************}
{ PRE  : De globale variable STUDENTHEAD moet bestaan.              }
{ POST : Een lege lijst.                                            }
{*******************************************************************}
PROCEDURE ClearList;
VAR
  Temp : StudentP;
BEGIN
  WHILE NOT(EmptyList(StudentHead)) DO
  BEGIN
    Temp:=StudentHead^.Next;
    DISPOSE(StudentHead);
    StudentHead:=Temp;
  END;
END;

{*******************************************************************}
{ ReadMenuKeys;                                                     }
{ Leest het toetsenbord voor de menu opties.                        }
{*******************************************************************}
{ PRE  : Werkt met HeadInsert, PositionInsert, TailInsert en        }
{         ShowList, deze moeten dus aanwezig zijn.                  }
{ POST : -                                                          }
{*******************************************************************}
PROCEDURE ReadMenuKeys;
BEGIN
  REPEAT 
    c:=ReadKey;
    CASE c OF
      '1' : BEGIN
               IF ActiveNodes<MaxNodes THEN
                BEGIN
                  HeadInsert(20,80,StudentHead);      { 1 }
                  ShowList(20,300,StudentHead);
                  ActiveNodes:=SUCC(ActiveNodes);
                END;
            END;
      '2' : BEGIN
               IF ActiveNodes<MaxNodes THEN
                BEGIN
                  PositionInsert(20,80,StudentHead);  { 2 }
                  ShowList(20,300,StudentHead);
                  ActiveNodes:=SUCC(ActiveNodes);
                END;
            END;
      '3' : BEGIN
              IF ActiveNodes<MaxNodes THEN
                BEGIN
                  TailInsert(20,80,StudentHead);      { 3 }
                  ActiveNodes:=SUCC(ActiveNodes);
                  ShowList(20,300,StudentHead);
                END
            END;
      '4' : BEGIN
              IF ActiveNodes>1 THEN
                BEGIN
                  DeleteNode(20,80);                  { 4 }
                  FixBar(20,300,650,450,Black,Black);
                  ActiveNodes:=PRED(ActiveNodes);
                END
              ELSE
                BEGIN
                  ClearList;
                  StudentHead:=NIL;
                  FixBar(20,300,599,400,Black,Black);
                  ActiveNodes:=0;
                END;
              ShowList(20,300,StudentHead);
            END;
      '5' : exit;                                      { 5 }
      END;
  UNTIL FALSE;
END;
  
{*******************************************************************}
{******************************* MAIN ******************************}
{*******************************************************************}
BEGIN
  ActiveNodes:=0;
  StudentHead:=NIL;       { Nog lege lijst  }
  OpenVGAScreen;          { VGAHi openen    }
  IF VGAMode THEN         { VGAHi is nodig! }
  BEGIN
      DrawNodeIndex;      { Node nummering  }
      DrawMenu(380,72);   { Menu tekenen    }
      ReadMenuKeys;       { Menu afwachten  }
      RestoreColors;      { Herstel kleuren }
      CloseGraph;         { VGAHi Sluiten   }
      ClearList;          { Release memory  }
  END;
END.                      { doei !          }

