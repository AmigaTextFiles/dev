(**********************************************************************

    :Program.    Menu2Asm.mod
    :Contents.   Procedure which writes an initialized menu as A68k-
    :Contents.   compatible source-code on disk
    :Author.     Jürgen Zimmermann [JnZ]
    :Address.    Ringstraße 6, W-6719 Altleiningen, Germany
    :Phone.      06356/1456
    :Copyright.  Freeware (but donation is always welcome!)
    :Language.   Modula-2
    :Translator. M2Amiga AMSoft V4.096d
    :History.    V1.13 [JnZ] 04.Jun.1991 first published version
**********************************************************************)

IMPLEMENTATION MODULE Menu2Asm;

FROM IntuitionD IMPORT Window, WindowPtr, Menu, MenuPtr, MenuItem,
                       MenuItemPtr, MenuItemFlags, MenuItemFlagSet,
                       IntuiText, IntuiTextPtr;

IMPORT io: InOut,
       co: Conversions,
       d : DosL,
       s : String,
       SY: SYSTEM;


CONST Version = "1.13d";
      VersionDate = "04.06.91";

CONST StandardTitle = "Menu2Asm "+Version+", "+VersionDate+", © Würmi-Connection\n() Name of the module> ";

      Header1 = "; Menu created by Menu2Asm (Version "+Version+") by Jürgen Zimmermann\n; For A68k V2.61\n\n\n   IDNT ";
      Header2 = "Asm\n   SECTION __MERGED,DATA\n   XDEF ";
      Header3 = "Asm_MenuStrip\n\n";
      Header4 = "Asm_MenuStrip:\n          DC.L Menu00\n\n";

      DefMod = 'DEFINITION MODULE ;\n\nFROM IntuitionD IMPORT MenuPtr;\n\nVAR MenuStrip[<"Asm_MenuStrip"]: MenuPtr;\n\nEND .';
      ModMod = "IMPLEMENTATION MODULE ;\n\nBEGIN\nEND .";


TYPE StrPtr = POINTER TO ARRAY[0..255] OF CHAR;


VAR open: BOOLEAN;


PROCEDURE OpenFiles;

   VAR ws1, ws2: ARRAY[0..200] OF CHAR;
       Name: ARRAY[0..100] OF CHAR;
       PathName : ARRAY[0..200] OF CHAR;
       lpos: LONGINT;


   PROCEDURE GetPathAndName(VAR file: ARRAY OF CHAR;
                            VAR name: ARRAY OF CHAR);

      VAR lpos: LONGINT;
          path: ARRAY[0..100] OF CHAR;

      BEGIN
         name[0]:=0C;
         path[0]:=0C;
         lpos:=s.LastPos(file,MAX(LONGCARD),"/");
         IF (lpos = s.noOccur)
            THEN
               lpos:=s.LastPos(file,MAX(LONGCARD),":");
               IF (lpos = s.noOccur)
                  THEN (* nur Filename! *)
                     s.Copy(name,file);
               END; (* IF *)
         END; (* IF *)

         IF (lpos # s.noOccur)
            THEN (* Path- & Filename! *)
               s.CopyPart(path,file,0,(lpos + 1));
               s.CopyPart(name,file,(lpos + 1),(s.Length(file) - (lpos + 1)));
         END; (* IF *)

         lpos:=s.LastPos(name,MAX(LONGCARD),".");
         IF (lpos # s.noOccur)
            THEN
               s.Delete(name,lpos,(s.Length(name) - lpos));
         END; (* IF *)

        (* Filename aktualisieren! *)
         s.Copy(file,path);
         s.Concat(file,name);
      END GetPathAndName;

   BEGIN
      io.WriteString(StandardTitle);
      io.ReadString(PathName);
      GetPathAndName(PathName,Name);

(* Definitionsmodul schreiben! *)
      s.Copy(ws1,PathName);
      s.Concat(ws1,".def");
      io.SetOutput(ws1);
      IF NOT(io.done)
         THEN
            HALT;
      END; (* IF *)
      open:=TRUE;
      s.Copy(ws2,DefMod);
      s.Insert(ws2,101,Name);
      s.Insert(ws2,70,Name); (* Variablenname *)
      s.Insert(ws2,18,Name);
      io.WriteString(ws2);
      io.CloseOutput;
      open:=FALSE;


(* "Leeres" Implementationsmodul schreiben *)
      s.Copy(ws1,PathName);
      s.Concat(ws1,".mod");
      io.SetOutput(ws1);
      IF NOT(io.done)
         THEN
            HALT;
      END; (* IF *)
      open:=TRUE;
      s.Copy(ws2,ModMod);
      s.Insert(ws2,35,Name);
      s.Insert(ws2,22,Name);
      io.WriteString(ws2);
      io.CloseOutput;
      open:=FALSE;


(* Assemblerquelltext erzeugen *)
      s.Copy(ws1,PathName);
      s.Concat(ws1,"Asm.asm");
      io.SetOutput(ws1);
      IF NOT(io.done)
         THEN
            HALT;
      END; (* IF *)
      open:=TRUE;
      io.WriteString(Header1);
      io.WriteString(Name);
      io.WriteString(Header2);
      io.WriteString(Name);
      io.WriteString(Header3);
      io.WriteString(Name);
      io.WriteString(Header4);
   END OpenFiles;


PROCEDURE CloseFiles;

   BEGIN
      IF open
         THEN
            io.CloseOutput;
            open:=FALSE;
      END; (* IF *)
   END CloseFiles;


PROCEDURE MakeMenu2Asm(window: WindowPtr);

   VAR  MenuList   : MenuPtr;
        ItemList   : MenuItemPtr;
        SubItemList: MenuItemPtr;
        Menus      : INTEGER;
        Items      : INTEGER;
        SubItems   : INTEGER;

        error      : BOOLEAN; (* For "Conversions" *)
        CS         : ARRAY[0..2] OF CHAR;


    PROCEDURE MenuNumName(num     : INTEGER;
                          VAR name: ARRAY OF CHAR);

       BEGIN
           s.Copy(name,"Menu");
           co.ValToStr(num,FALSE,CS,10,2,"0",error);
           s.Insert(name,4,CS);
       END MenuNumName;


   PROCEDURE MakeMenuName(num     : INTEGER;
                          VAR name: ARRAY OF CHAR);

      BEGIN
         MenuNumName(num,name);
         s.Insert(name,4,"Name");
      END MakeMenuName;


      PROCEDURE ItemNumName(mnum, inum: INTEGER;
                            VAR name  : ARRAY OF CHAR);

         BEGIN
            MenuNumName(mnum,name);
            s.Insert(name,s.last,"Item");
            co.ValToStr(inum,FALSE,CS,10,2,"0",error);
            s.Insert(name,s.last,CS);
         END ItemNumName;


      PROCEDURE SubNumName(mnum, inum, snum: INTEGER;
                           VAR name        : ARRAY OF CHAR);

         BEGIN
            ItemNumName(mnum,inum,name);
            s.Insert(name,s.last,"Sub");
            co.ValToStr(snum,FALSE,CS,10,2,"0",error);
            s.Insert(name,s.last,CS);
         END SubNumName;


      PROCEDURE WriteName(name: ARRAY OF CHAR;
                          a   : StrPtr);

         VAR i: INTEGER;

         BEGIN
            io.WriteString(name);
            io.WriteString(':\n          DC.B "');
            FOR i:=0 TO (s.Length(a^)-1) DO
               io.Write(a^[i]);
            END; (* FOR *)
            io.WriteString('",0\n          EVEN\n\n\n');
         END WriteName;


   PROCEDURE WriteIntuiTextName(name: ARRAY OF CHAR);

       BEGIN
          io.WriteString(name);
          io.WriteString("IText");
       END WriteIntuiTextName;


   PROCEDURE WriteIntuiText(itp : IntuiTextPtr;
                            name: ARRAY OF CHAR);

      BEGIN
         s.Insert(name,s.last,"IText");
         io.WriteString(name);
         io.WriteString(":\n          DC.B   ");
         io.WriteCard(itp^.frontPen,1);
         io.Write(",");
         io.WriteCard(itp^.backPen,1);
         io.WriteString("\n          DC.B   ");
         io.WriteCard(SY.CAST(SHORTCARD,itp^.drawMode),1);
         io.WriteString(",0   ; DrawModeSet + pad\n          DC.W   ");
         io.WriteCard(itp^.leftEdge,1);
         io.Write(",");
         io.WriteCard(itp^.topEdge,1);
         io.WriteString("\n          DC.L   0   ; At this time no special font\n          DC.L   ");
         s.Insert(name,s.last,"String");
         io.WriteString(name);
         io.WriteString("\n          DC.L   0   ; only one intuitext per item at this time \n\n\n");
         WriteName(name,itp^.iText);
      END WriteIntuiText;


   PROCEDURE WriteMenu;

      VAR MenuString: ARRAY[0..30] OF CHAR;
          NextMenuSt: ARRAY[0..30] OF CHAR;
          FirstItemS: ARRAY[0..30] OF CHAR;
          MenuName  : ARRAY[0..30] OF CHAR;
          MenuNamePtr: StrPtr;
          i: INTEGER;

      BEGIN
         MenuNumName(Menus,MenuString);
         io.WriteString(MenuString);
         io.WriteString(":\n");
         io.WriteString("          DC.L   ");
         IF (MenuList^.nextMenu # NIL)
            THEN
               MenuNumName((Menus+1),NextMenuSt);
               io.WriteString(NextMenuSt);
            ELSE
               io.WriteString("0");
         END; (* IF *)

         io.WriteString("\n          DC.W    ");
         io.WriteCard(MenuList^.leftEdge,1);
         io.Write(",");
         io.WriteCard(MenuList^.topEdge,1);
         io.Write(",");
         io.WriteCard(MenuList^.width,1);
         io.Write(",");
         io.WriteCard(MenuList^.height,1);
         io.WriteString("\n          DC.W   $");
         IF (0 IN MenuList^.flags)
            THEN
               io.WriteHex(1,4);
            ELSE
               io.WriteHex(0,4);
         END; (* IF *)
(*         io.WriteHex(SY.CAST(CARDINAL,MenuList^.flags),4); *)
         io.WriteString("   ; MenuFlags\n          DC.L   ");
         MakeMenuName(Menus,MenuName);
         io.WriteString(MenuName);
         io.WriteString("\n          DC.L   ");
         ItemNumName(Menus,0,FirstItemS);
         io.WriteString(FirstItemS);
         io.WriteString("   ; First Item\n          DC.W   0,0,0,0\n\n\n");

         WriteName(MenuName,MenuList^.menuName);
      END WriteMenu;


   PROCEDURE WriteItem(sub: BOOLEAN);

      VAR error: BOOLEAN;
          ip   : MenuItemPtr;
          n    : INTEGER;
          ItemString: ARRAY[0..30] OF CHAR;
          ItemNString: ARRAY[0..30] OF CHAR;
          ItemSString: ARRAY[0..30] OF CHAR;

      BEGIN
         IF sub
            THEN
               ip:=SubItemList;
               n :=SubItems;
               SubNumName(Menus,Items,SubItems,ItemString);
            ELSE
               ip:=ItemList;
               n :=Items;
               ItemNumName(Menus,Items,ItemString);
         END; (* IF *)

         io.WriteString(ItemString);
         io.WriteString(":\n          DC.L   ");
         IF (ip^.nextItem # NIL)
            THEN
               IF sub
                  THEN
                     SubNumName(Menus,Items,(SubItems + 1),ItemNString);
                  ELSE
                     ItemNumName(Menus,(Items + 1),ItemNString);
               END; (* IF *)
               io.WriteString(ItemNString);
            ELSE
               io.Write("0");
         END; (* IF *)
         io.WriteString("\n          DC.W   ");
         io.WriteCard(ip^.leftEdge,1);
         io.Write(",");
         io.WriteCard(ip^.topEdge,1);
         io.Write(",");
         io.WriteCard(ip^.width,1);
         io.Write(",");
         io.WriteCard(ip^.height,1);
         io.WriteString("\n          DC.W   $");
         io.WriteHex(SY.CAST(CARDINAL,ip^.flags),4);
         io.WriteString(" ; Flags\n          DC.L   $");
         io.WriteHex(SY.CAST(LONGCARD,ip^.mutualExclude),8);
         io.WriteString(" ; MutualExclude\n          DC.L   ");
         WriteIntuiTextName(ItemString);
         io.WriteString("  ; IntuiTextPtr\n          DC.L   0 ; selectFill (not at the moment!)\n          DC.B   ");   (* not at the moment *)
         io.WriteCard(CARDINAL(ip^.command),1);
         io.WriteString(",0   ; command, pad\n          DC.L   ");
         IF (NOT(sub) AND (ip^.subItem # NIL))
            THEN
               SubNumName(Menus,Items,0,ItemSString);
               io.WriteString(ItemSString);
             ELSE
               io.Write("0");
         END; (* IF *)
         io.WriteString("  ; SubItem\n          DC.W   ");
         io.WriteCard(ip^.nextSelect,1);
         io.WriteString("\n          DC.W   0 ; pad\n\n\n");
         WriteIntuiText(ip^.itemFill,ItemString);
      END WriteItem;


   BEGIN
      IF (window = NIL)
         THEN
            io.WriteString("The window-pointer you gave me was NIL!\n");
            RETURN;
      ELSIF (window^.menuStrip = NIL)
         THEN
            io.WriteString("There is no menu at the window you gave me!\n");
            RETURN;
      END; (* IF *)
      OpenFiles;


      MenuList:=window^.menuStrip;
      Menus   :=0;

      WHILE (MenuList # NIL) DO
         WriteMenu;

         ItemList:=MenuList^.firstItem;
         Items:=0;
         WHILE (ItemList # NIL) DO
            WriteItem(FALSE);

            SubItemList:=ItemList^.subItem;
            SubItems:=0;
            WHILE (SubItemList # NIL) DO
               WriteItem(TRUE);

               INC(SubItems);
               SubItemList:=SubItemList^.nextItem;
            END; (* WHILE *)

            INC(Items);
            ItemList:=ItemList^.nextItem;
         END; (* WHILE *)

         INC(Menus);
         MenuList:=MenuList^.nextMenu;
      END; (* WHILE *)

      io.WriteString("   END");
      CloseFiles;
      io.WriteString("\n\nOperation successful!\n\n");
   END MakeMenu2Asm;

BEGIN
   open:=FALSE;
CLOSE
   CloseFiles;
END Menu2Asm.
