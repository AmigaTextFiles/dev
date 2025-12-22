

var
   tritontags : array[0..500] of TagItem;
   tindex : Integer;

PROCEDURE ProjectStart;
external;

PROCEDURE EndProject;
external;

PROCEDURE WindowTitle(t : STRING);
external;

PROCEDURE ScreenTitle(t : STRING);
external;

PROCEDURE WindowID(gadid : Integer);
external;

PROCEDURE WindowFlags(f : Integer);
external;

PROCEDURE WindowPosition(pos : Integer);
external;

PROCEDURE WindowUnderscore(und : STRING);
external;

PROCEDURE WindowDimensions(dim : TR_DimensionsPtr);
external;

PROCEDURE WindowBackfillWin;
external;

PROCEDURE WindowBackfillReq;
external;

PROCEDURE WindowBackfillNone;
external;

PROCEDURE WindowBackfillS;
external;

PROCEDURE WindowBackfillSA;
external;

PROCEDURE WindowBackfillSF;
external;

PROCEDURE WindowBackfillSB;
external;

PROCEDURE WindowBackfillA;
external;

PROCEDURE WindowBackfillAF;
external;

PROCEDURE WindowBackfillAB;
external;

PROCEDURE WindowBackfillF;
external;

PROCEDURE WindowBackfillFB;
external;

PROCEDURE CustomScreen(scr : address);
external;

PROCEDURE PubScreen(scr : Address);
external;

PROCEDURE PubScreenName(name : STRING);
external;

PROCEDURE QuickHelpOn(on : Short);
external;

(* Menus *)
PROCEDURE BeginMenu(t : STRING);
external;

PROCEDURE MenuFlags(f : Integer);
external;

PROCEDURE MenuItem_(t : STRING ;gadid : Integer);
external;

PROCEDURE MenuItemC(t : STRING; gadid : Integer);
external;

PROCEDURE MenuItemCC(t : STRING; gadid : Integer);
external;

PROCEDURE BeginSub(t : STRING);
external;

PROCEDURE MenuItemD(t : STRING; gadid : Integer);
external;

PROCEDURE SubItem(t : STRING; gadid : Integer);
external;


PROCEDURE SubItemC(t : STRING; gadid : Integer);
external;

PROCEDURE SubItemCC(t : STRING; gadid : Integer);
external;

PROCEDURE SubItemD(t : STRING ;gadid : Integer);
external;

PROCEDURE ItemBarlabel;
external;

PROCEDURE SubBarlabel;
external;

(* Groups *)
PROCEDURE HorizGroup;
external;

PROCEDURE HorizGroupE;
external;

PROCEDURE HorizGroupS;
external;

PROCEDURE HorizGroupA;
external;

PROCEDURE HorizGroupEA;
external;

PROCEDURE HorizGroupSA;
external;

PROCEDURE HorizGroupC;
external;

PROCEDURE HorizGroupEC;
external;

PROCEDURE HorizGroupSC;
external;

PROCEDURE HorizGroupAC;
external;

PROCEDURE HorizGroupEAC;
external;

PROCEDURE HorizGroupSAC;
external;

PROCEDURE VertGroup;
external;

PROCEDURE VertGroupE;
external;

PROCEDURE VertGroupS;
external;

PROCEDURE VertGroupA;
external;

PROCEDURE VertGroupEA;
external;

PROCEDURE VertGroupSA;
external;

PROCEDURE VertGroupC;
external;

PROCEDURE VertGroupEC;
external;

PROCEDURE VertGroupSC;
external;

PROCEDURE VertGroupAC;
external;

PROCEDURE VertGroupEAC;
external;

PROCEDURE VertGroupSAC;
external;

PROCEDURE EndGroup;
external;

PROCEDURE ColumnArray;
external;

PROCEDURE LineArray;
external;

PROCEDURE BeginColumn;
external;

PROCEDURE BeginLine;
external;

PROCEDURE BeginColumnI;
external;

PROCEDURE BeginLineI;
external;

PROCEDURE BeginColumnE;
external;

PROCEDURE BeginLineE;
external;

PROCEDURE EndColumn;
external;

PROCEDURE EndLine;
external;

PROCEDURE EndArray;
external;

(* DisplayObject *)
PROCEDURE QuickHelp(Str : STRING);
external;

(* Space *)
PROCEDURE SpaceB;
external;

PROCEDURE Space;
external;

PROCEDURE SpaceS;
external;

PROCEDURE SpaceN;
external;

(* Text *)
PROCEDURE TextN(ttext : STRING);
external;

PROCEDURE TextH(ttext : STRING);
external;

PROCEDURE Text3(ttext : STRING);
external;

PROCEDURE TextB(ttext : STRING);
external;

PROCEDURE TextT(ttext : STRING);
external;

PROCEDURE TextID(ttext : STRING ; gadid : Integer);
external;

PROCEDURE TextNR(t : STRING);
external;

PROCEDURE ClippedText(t : STRING);
external;

PROCEDURE ClippedTextID(t : STRING; gadid : Integer);
external;

PROCEDURE CenteredText(ttext : STRING);
external;

PROCEDURE CenteredTextH(ttext : STRING);
external;

PROCEDURE CenteredText3(ttext : STRING);
external;

PROCEDURE CenteredTextB(ttext : STRING);
external;

PROCEDURE CenteredTextID(ttext : STRING ; gadid : Integer);
external;

PROCEDURE CenteredText_BS(ttext : STRING);
external;

PROCEDURE TextBox(ttext : STRING ; gadid : Integer ; mwid : Integer);
external;

PROCEDURE ClippedTextBox(ttext : STRING ; gadid : Integer);
external;

PROCEDURE ClippedTextBoxMW(ttext : STRING ; gadid : Integer ; mwid : Integer);
external;

PROCEDURE TextRIGHT(t : STRING ;gadid : Integer);
external;

PROCEDURE IntegerS(i : Integer);
external;

PROCEDURE IntegerH(i : Integer);
external;

PROCEDURE Integer3(i : Integer);
external;

PROCEDURE IntegerB(i : Integer);
external;

PROCEDURE CenteredInteger(i : Integer);
external;

PROCEDURE CenteredIntegerH(i : Integer);
external;

PROCEDURE CenteredInteger3(i : Integer);
external;

PROCEDURE CenteredIntegerB(i : Integer);
external;

PROCEDURE IntegerBox(def,gadid,mwid : Integer);
external;

(* Button *)
PROCEDURE Button(ttext : STRING ; gadid : Integer);
external;

PROCEDURE ButtonR(ttext : STRING ; gadid : Integer);
external;

PROCEDURE ButtonE(ttext : STRING ;gadid : Integer);
external;

PROCEDURE ButtonRE(ttext : STRING ;gadid : Integer);
external;

PROCEDURE CenteredButton(t : STRING;i : Integer);
external;

PROCEDURE CenteredButtonR(t : STRING ;i : Integer);
external;

PROCEDURE CenteredButtonE(t : STRING;i : Integer);
external;

PROCEDURE CenteredButtonRE(t : STRING ;i : Integer);
external;

PROCEDURE EmptyButton(gadid : Integer);
external;

PROCEDURE GetFileButton(gadid : Integer);
external;

PROCEDURE GetDrawerButton(gadid : Integer);
external;

PROCEDURE GetEntryButton(gadid : Integer);
external;

PROCEDURE GetFileButtonS(s : STRING ;gadid : Integer);
external;

PROCEDURE GetDrawerButtonS(s : STRING;gadid : Integer);
external;

PROCEDURE GetEntryButtonS(s : STRING ;gadid : Integer);
external;

(* Line *)
PROCEDURE Line(flags : Integer);
external;

PROCEDURE HorizSeparator;
external;

PROCEDURE VertSeparator;
external;

PROCEDURE NamedSeparator(ttext : STRING);
external;

PROCEDURE NamedSeparatorI(te : STRING ;gadid : Integer);
external;

PROCEDURE NamedSeparatorN(ttext : STRING);
external;

PROCEDURE NamedSeparatorIN(te : STRING ;gadid : Integer);
external;

(* FrameBox *)
PROCEDURE GroupBox;
external;

PROCEDURE NamedFrameBox(t : STRING);
external;

PROCEDURE TTextBox;
external;

(* DropBox *)
PROCEDURE DropBox(gadid : Integer);
external;

(* CheckBox gadget *)
PROCEDURE CheckBox(gadid : Integer);
external;

PROCEDURE CheckBoxV(value : Integer; gadid : Integer);
external;

PROCEDURE CheckBoxC(gadid : Integer);
external;

PROCEDURE CheckBoxLEFT(gadid : Integer);
external;

PROCEDURE CheckBoxCLEFT(gadid : Integer);
external;

(* String gadget *)
PROCEDURE StringGadget(def : STRING;gadid : Integer);
external;

PROCEDURE StringGadgetNR(def : STRING ;gadid : Integer);
external;

PROCEDURE PasswordGadget(def : STRING ;gadid : Integer);
external;

(* Cycle gadget *)
PROCEDURE CycleGadget(ent : Address ; val,gadid : Integer);
external;

PROCEDURE MXGadget(ent : Address ; val,gadid : Integer);
external;

PROCEDURE MXGadgetR(ent : Address; val,gadid : Integer);
external;

(* Slider gadget *)
PROCEDURE SliderGadget(mini,maxi,val,gadid : Integer);
external;

PROCEDURE SliderGadgetV(mini,maxi,val,gadid : Integer);
external;

(* Scroller gadget *)
PROCEDURE ScrollerGadget(total,visible,val,id : Integer);
external;

PROCEDURE ScrollerGadgetV(total,visible,val,id : Integer);
external;

(* Palette gadget *)
PROCEDURE PaletteGadget(val,gadid : Integer);
external;

(* Listview gadget *)
PROCEDURE ListRO(ent : Address;gadid,top : Integer);
external;

PROCEDURE ListSel(ent : Address ;gadid,top : Integer);
external;

PROCEDURE ListSS(e : Address ;gadid,top,v : Integer);
external;

PROCEDURE ListSSM(e : Address ;gadid,top,v,min : Integer);
external;

PROCEDURE ListROC(ent : Address;gadid,top : Integer);
external;

PROCEDURE ListSelC(ent : Address;gadid,top : Integer);
external;

PROCEDURE ListSSC(e : Address;gadid,top,v : Integer);
external;

PROCEDURE ListRON(ent : Address ;gadid,top : Integer);
external;

PROCEDURE ListSelN(ent : Address;gadid,top : Integer);
external;

PROCEDURE ListSSN(e : Address;gadid,top,v : Integer);
external;

PROCEDURE ListROCN(ent : Address;gadid,top : Integer);
external;

PROCEDURE ListSelCN(ent : Address;gadid,top : Integer);
external;

PROCEDURE ListSSCN(e : Address;gadid,top,v : Integer);
external;

PROCEDURE FWListRO(ent : Address;gadid,top : Integer);
external;

PROCEDURE FWListSel(ent : Address;gadid,top : Integer);
external;

PROCEDURE FWListSS(e : Address;gadid,top,v : Integer);
external;

PROCEDURE FWListROC(ent : Address;gadid,top : Integer);
external;

PROCEDURE FWListSelC(ent : Address;gadid,top : Integer);
external;

PROCEDURE FWListSSC(e : Address;gadid,top,v : Integer);
external;

PROCEDURE FWListRON(ent : Address;gadid,top : Integer);
external;

PROCEDURE FWListSelN(ent : Address;gadid,top : Integer);
external;

PROCEDURE FWListSSN(e : Address;gadid,top,v : Integer);
external;

PROCEDURE FWListROCN(ent : Address;gadid,top : Integer);
external;

PROCEDURE FWListSelCN(ent : Address;gadid,top : Integer);
external;

PROCEDURE FWListSSCN(e : Address;gadid,top,v : Integer);
external;

(* Progress indicator *)
PROCEDURE Progress(maxi,value,gadid : Integer);
external;

(* Image *)
PROCEDURE BoopsiImage(img : Address);
external;

PROCEDURE BoopsiImageD(img : Address;mw,mh : Integer);
external;

(* Attributes *)
PROCEDURE ID(gadid : Integer);
external;

PROCEDURE Disabled;
external;

PROCEDURE ObjectBackfillWin;
external;

PROCEDURE ObjectBackfillReq;
external;

PROCEDURE ObjectBackfillB;
external;

PROCEDURE ObjectBackfillS;
external;

PROCEDURE ObjectBackfillSA;
external;

PROCEDURE ObjectBackfillSF;
external;

PROCEDURE ObjectBackfillSB;
external;

PROCEDURE ObjectBackfillA;
external;

PROCEDURE ObjectBackfillAF;
external;

PROCEDURE ObjectBackfillAB;
external;

PROCEDURE ObjectBackfillF;
external;

PROCEDURE ObjectBackfillFB;
external;

(* Requester support *)
PROCEDURE BeginRequester(t : STRING; p : Integer);
external;

PROCEDURE BeginRequesterGads;
external;

PROCEDURE EndRequester;
external;

PROCEDURE SetTRTag( thetag, thedata : Integer);
external;





                



