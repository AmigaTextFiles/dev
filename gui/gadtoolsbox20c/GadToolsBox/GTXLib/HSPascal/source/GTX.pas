unit GTX;

INTERFACE
uses Exec, Graphics, Intuition, Gadtools, Utility;


{ ------------------------------------------------------------------------
  :Program.       GadToolsBox
  :Contents.      Interface to Jan van den Baard's Library
  :Author.        Richard Waspe
  :Address.       FIDO     :   2:255/72.2
  :Address.       INTERNET :   waspy@cix.compulink.co.uk
  :Address.       UUCP     :   rwaspe@hamlet.adsp.sub.org
  :History.       v1.0 24-Feb-93 (translated from C and Oberon)
  :History.       Library version bump to 39
  :Copyright.     Freely Distributable
  :Language.      PASCAL
  :Translator.    Hisoft HSPascal V1.1
  :Warning.                     First translation, compiles OK, but untested
------------------------------------------------------------------------ }

{ From Forms.h}

CONST
  { GadToolsBox FORM identifiers }
  ID_GXMN       :       ARRAY [0..3] OF CHAR = ('G', 'X', 'M', 'N');
  ID_GXTX       :       ARRAY [0..3] OF CHAR = ('G', 'X', 'T', 'X');
  ID_GXBX       :       ARRAY [0..3] OF CHAR = ('G', 'X', 'B', 'X');
  ID_GXGA       :       ARRAY [0..3] OF CHAR = ('G', 'X', 'G', 'A');
  ID_GXWD       :       ARRAY [0..3] OF CHAR = ('G', 'X', 'W', 'D');

  { GadToolsBox chunk identifiers. }
    ID_MEDA     :       ARRAY [0..3] OF CHAR = ('M', 'E', 'D', 'A');
  ID_ITXT       :       ARRAY [0..3] OF CHAR = ('I', 'T', 'X', 'A');
  ID_BBOX       :       ARRAY [0..3] OF CHAR = ('B', 'B', 'O', 'X');
  ID_GADA       :       ARRAY [0..3] OF CHAR = ('G', 'A', 'D', 'A');
  ID_WDDA       :       ARRAY [0..3] OF CHAR = ('W', 'D', 'D', 'A');
  ID_GGUI       :       ARRAY [0..3] OF CHAR = ('G', 'G', 'U', 'I');

  { Version (ID_VERS) chunk... }
  ID_VERS       :       ARRAY [0..3] OF CHAR = ('V', 'E', 'R', 'S');


TYPE
        pVERSION = ^tVERSION;
        tVERSION = RECORD
                vr_Version      :       WORD;
                vr_Flags                :       WORD;
                vr_Reserved     :       ARRAY [0..3] OF LONGINT;
        END;

  { NewMenu (ID_MEDA) chunk... }
CONST
        MAXMENUTITLE    =       80;     MMT     =       79;
        MAXMENULABEL    =       34;     MML     =       33;
        MAXSHORTCUT             =       2;              MSC     =       1;
        MAXMENUVERSION  =       0;

TYPE
        pMENUDATA       =       ^tMENUDATA;
        tMENUDATA       =       RECORD
                mda_NewMenu     :       tNewMenu;
                mda_Title       :       ARRAY [0..MMT] OF BYTE;
                mda_Label       :       ARRAY [0..MML] OF BYTE;
                mda_ShortCut    :       ARRAY [0..MSC] OF BYTE;
                mda_Flags       :       WORD;
  END;

  { IntuiText (ID_ITXT) chunk... }
CONST
        MAXTEXTLENGTH   =       80;     MTL     =       79;
        ITXTVERSION             =       0;

TYPE
        pITEXTDATA      =       ^tITEXTDATA;
        tITEXTDATA      =       RECORD
                it_IText        :       tIntuiText;
                it_Text :       ARRAY [0..MTL] OF BYTE;
        END;

  { BevelBox (ID_BBOX) chunk... }
CONST
        BBOXVERSION     =       0;

TYPE
        pBBOXDATA       =       ^tBBOXDATA;
        tBBOXDATA       =       RECORD
                bbx_Left                :       WORD;
                bbx_Top         :       WORD;
                bbx_Width       :       WORD;
                bbx_Height      :       WORD;
                bbx_Flags       :       WORD;
        END;

CONST
  { BevelBox flag bits }
        BBF_RECESSED    =       1;
        BBF_DROPBOX             =       1;

  { NewGadget (ID_GADA) chunk... }
CONST
        MAXGADGETTEXT   =       80;     MGT     =       79;
        MAXGADGETLABEL  =       34;     MGL     =       33;
        GADGETVERSION   =       0;

TYPE
        pGADGETDATA     =       ^tGADGETDATA;
        tGADGETDATA     =       RECORD
                gd_NewGadget    :       tNewGadget;
                gd_GadgetText   :       ARRAY [0..MGT] OF CHAR;
                gd_GadgetLabel  :       ARRAY [0..MGL] OF CHAR;
                gd_Flags                        :       LONGINT;
                gd_Kind                 :       WORD;
                gd_NumTags              :       WORD;
                gd_Reserved             : ARRAY [0..3] OF LONGINT;
        END;

  { NewGadget flag bits }
CONST
        GDF_ISLOCKED    =       32;
        GDF_NEEDLOCK    =       64;

  { Window (ID_WDDA) chunk... }
CONST
        MAXWINDOWNAME           =       34;     MWN     =       33;
        MAXWINDOWTITLE          =       80;     MWT     =       79;
        MAXWDSCREENTITLE        =       80;     MWST    =       79;
        WINDOWVERSION           =       0;

TYPE
        pWINDOWDATA     =       ^tWINDOWDATA;
        tWINDOWDATA     =       RECORD
                wda_Name                                :       ARRAY [0..MWN] OF CHAR;
                wda_Title                       :       ARRAY [0..MWT] OF CHAR;
                wda_ScreenTitl          :       ARRAY [0..MWST] OF CHAR;
                wda_NumTags                     :       WORD;
                wda_IDCountFrom :       WORD;
                wda_IDCMP                       :       LONGINT;
                wda_WindowFlags :       LONGINT;
                wda_TagFlags            :       LONGINT;
                wda_InnerWidth          :       WORD;
                wda_InnerHeight :       WORD;
                wda_ShowTitle           :       BOOLEAN;
                wda_MouseQueue          :       WORD;
                wda_RptQueue            :       WORD;
                wda_Flags                       :       WORD;
                wda_LeftBorder          :       WORD;
                wda_TopBorder           :       WORD;
                wda_Reserved            :       ARRAY [0..9] OF BYTE;
        END;

CONST
  { Window tag flag bits }
        WDF_INNERWIDTH      = 0;
        WDF_INNERHEIGHT     = 1;
        WDF_ZOOM            = 2;
        WDF_MOUSEQUEUE      = 3;
        WDF_RPTQUEUE        = 4;
        WDF_AUTOADJUST      = 5;
        WDF_DEFAULTZOOM     = 6;
        WDF_FALLBACK        = 7;

  { GUI (ID_GGUI) chunk... }
CONST
        MAXSCREENTITLE  =       80;     MSTI    =       79;
        FONTNAMELENGTH  =       128;    FNL     =       127;
        MAXCOLORSPEC    =       33;     MCS     =       32;
        MAXDRIPENS              =       10;     MDP     =       9;
        MAXMOREDRIPENS  =       10;     MMDP    =       9;
        GUIVERSION              =       0;

TYPE
        pGUIDATA        =       ^tGUIDATA;
        tGUIDATA        =       RECORD
                gui_Flags0                      :       LONGINT;
                gui_ScreenTitle :       ARRAY [0..MSTI] OF CHAR;
                gui_Left                                :       WORD;
                gui_Top                         :       WORD;
                gui_Width                       :       WORD;
                gui_Height                      :       WORD;
                gui_Depth                       :       WORD;
                gui_DisplayID           :       LONGINT;
                gui_Overscan            :       WORD;
                gui_DriPens                     :       ARRAY [0..MDP] OF WORD;
                gui_Colors                      :       ARRAY [0..MCS] OF tColorSpec;
                gui_FontName            :       ARRAY [0..FNL] OF CHAR;
                gui_Font                                :       tTextAttr;
                gui_MoreDriPens :       ARRAY [0..MMDP] OF WORD;
                gui_Reserved            :       ARRAY [0..4] OF LONGINT;
        {Following fields are PRIVATE }
                gui_Flags1                      :       LONGINT;
                gui_StdScreenWidth      :       WORD;
                gui_StdScreenHeight     :       WORD;
                gui_ActiveKind                  :       WORD;
                gui_LastProject         :       WORD;
                gui_GridX                               :       WORD;
                gui_GridY                               :       WORD;
                gui_OffX                                        :       WORD;
                gui_OffY                                        :       WORD;
                gui_Reserved1                   :       ARRAY [0..6] OF WORD;
        END;

CONST
  { GUI gui_Flags0 flag bits }
  GU0_AUTOSCROLL = 0;
  GU0_WORKBENCH  = 1;
  GU0_PUBLIC     = 2;
  GU0_CUSTOM     = 3;


{               ***             From Prefs.h            ***              }


CONST
        GTBCONFIGSAVE   =       'ENVARC:GadToolsBox/GadToolsBox.prefs';
        GTBCONFIGUSE    =       'ENV:GadToolsBox/GadToolsBox.prefs';

        GTBCONFIGVERSION        =       0;
        MAXUSERNAME                     =       64;     MUN     =       63;
        MAXICONPATH                     =       128;    MICP    =       127;

        ID_GTCO :       ARRAY [0..3] OF CHAR = ('G', 'T', 'C', 'O');

TYPE
        pGadToolsConfig =       ^tGadToolsConfig;
        tGadToolsConfig =       RECORD
                gtc_ConfigFlags0        :       LONGINT;
                gtc_ConfigFlags1        :       LONGINT;
                gtc_CrunchBuffer        :       WORD;
                gtc_CrunchType          :       WORD;
                gtc_UserName            :       ARRAY [0..MUN] OF CHAR;
                gtc_IconPath            :       ARRAY [0..MICP] OF CHAR;
                gtc_Reserved            :       ARRAY [0..3] OF LONGINT;
        END;

  { flag definitions for gtc_ConfigFlags0 }
CONST
        GC0_COORDINATES =       1;
        GC0_WRITEICON           =       2;
        GC0_GZZADJUST           =       4;
        GC0_CRUNCH                      =       8;
        GC0_CLOSEWBENCH =       16;
        GC0_PASSWORD            =       32;
        GC0_OVERWRITE           =       64;
        GC0_ASLFREQ                     =       128;
        GC0_FONTADAPT           =       256;
        GC0_USEPUBSCREEN        =       512;


{       GadToolsBox Library generation prefs file format }
{       NOTE : This is not yet supported }


CONST
        GTLIBGENSAVE            =       'ENVARC:GadToolsBox/LibGen.Prefs';
        GTBLIBGENUSE            =       'ENV:GadToolsBox/Libgen.Prefs';
        GTBLIBGENVERSION        =       0;
        MAXLIBNAME                      =       32;     MLN     =       31;
        MAXBASENAME                     =       32;     MBN     =       31;
        ID_LIBG :       ARRAY [0..3] OF CHAR = ('L', 'I', 'B', 'G');


TYPE
        tLibraryGen     =       RECORD
                lg_LibraryName          :       ARRAY [0..MLN] OF CHAR;
                lg_LibraryBase          :       ARRAY [0..MBN] OF CHAR;
                lg_Flags                                :       WORD;
                lg_MinVersion           :       WORD;
                lg_Reserved                     :       ARRAY [0..3] OF LONGINT;
        END;

{ Flags for the Library generation preferences }

CONST
        LGF_GENERATE            =       1;
        LGF_MODULE                      =       2;
        LGF_FAILREQ                     =       4;
        LGF_DISKLIB                     =       8;
        LGF_INTERNAL            =       16;



{               ***             From  GTXbase.h         ***             }



CONST
  GTXNAME               =       'gadtoolsbox.library';
  GTXVERSION    =       39;

TYPE
        pGTXBASE                =       ^tGTXBase;
        tGTXBase                =       RECORD
                LibNode :       tLibrary;

{    These library bases may be extracted from this structure}
{    for your own usage as long as the GTXBase pointer remains}
{    valid.}

                DosBase                 :               pLibrary;
                IntuitionBase   :               pLibrary;
                GFXBase                 :               pLibrary;
                GadToolsBase    :               pLibrary;
                UtilityBase             :               pLibrary;
                IFFParseBase    :               pLibrary;
                ConsoleDevice   :               pLibrary;
                NoFragBase              :               pLibrary;
    {
    The next library pointer is not guaranteed to
    be valid! Please check this pointer *before* using
    it.
    }
                PPBase                  :               pLibrary;
  END;



{               ***             From  Gui.h             ***             }

TYPE
        pExtNewGadget   =       ^tExtNewGadget;

        pExtGadgetList  =       ^tExtGadgetList;
        tExtGadgetList  =       RECORD
                gl_First                :       pExtNewGadget;
                gl_EndMark      :       pExtNewGadget;
                gl_Last         :       pExtNewGadget;
        END;

        tExtNewGadget   =       RECORD
                en_Next                 :       pExtNewGadget;
                en_Prev                 :       pExtNewGadget;
                en_Tags                 :       pTagItem;
                en_Reserved0    :       ARRAY [0..3] OF BYTE;
                en_NewGadget    :       tNewGadget;
                en_GadgetLabel  :       ARRAY [0..MGL] OF CHAR;
                en_GadgetText   :       ARRAY [0..MGT] OF CHAR;
                en_Flags                        :       LONGINT;
                en_Kind                 :       WORD;
                en_Reserved1    :       ARRAY [0..137] OF BYTE;
        END;


        pExtNewMenu             =       ^tExtNewMenu;

        pExtMenuList    =       ^tExtMenuList;
        tExtMenuList    =       RECORD
                ml_First                :       pExtNewMenu;
                ml_EndMark      :       pExtNewMenu;
                ml_Last         :       pExtNewMenu;
        END;

        tExtNewMenu             =       RECORD
                em_Next                 :       pExtNewMenu;
                em_Prev                 :       pExtNewMenu;
                em_Reserved0    :       ARRAY [0..5] OF BYTE;
                em_NewMenu              :       tNewMenu;
                em_MenuTitle    :       ARRAY [0..MMT] OF CHAR;
                em_MenuLabel    :       ARRAY [0..MML] OF CHAR;
                em_Reserved1    :       ARRAY [0..3] OF BYTE;
                em_Items                        :       pExtMenuList;
                em_Reserved2    :       ARRAY [0..1] OF BYTE;
                em_CommKey              :       ARRAY [0..MSC] OF CHAR;
                em_Reserved3    :       ARRAY [0..1] OF BYTE;
        END;


        pBevelBox       =       ^tBevelBox;
        pBevelList      =       ^tBevelList;
        tBevelList      =       RECORD
                bl_First                :       pBevelBox;
                bl_EndMark      :       pBevelBox;
                bl_Last         :       pBevelBox;
        END;


        tBevelBox       =       RECORD
                bb_Next                 :       pBevelBox;
                bb_Prev                 :       pBevelBox;
                bb_Reserved0    :       ARRAY [0..3] OF BYTE;
                bb_Left                 :       WORD;
                bb_Top                  :       WORD;
                bb_Width                        :       WORD;
                bb_Height               :       WORD;
                bb_Reserved1    :       ARRAY [0..31] OF BYTE;
                bb_Flags                        :       WORD;
        END;


        pProjectWindow          =       ^tProjectWindow;
        pWindowList                     =       ^tWindowList;
        tWindowList             =       RECORD
                wl_First                :       pProjectWindow;
                wl_EndMark      :       pProjectWindow;
                wl_Last         :       pProjectWindow;
        END;


        tProjectWindow          =       RECORD
                pw_Next                 :       pProjectWindow;
                pw_Prev                 :       pProjectWindow;
                pw_Reserved0    :       ARRAY [0..5] OF BYTE;
                pw_Name                 :       ARRAY [0..MWN] OF CHAR;
                pw_CountIDFrom  :       WORD;
                pw_Tags                 :       pTagItem;
                pw_LeftBorder   :       WORD;
                pw_TopBorder    :       WORD;
                pw_WindowTitle  :       ARRAY [0..MWT] OF CHAR;
                pw_ScreenTitle  :       ARRAY [0..MWST] OF CHAR;
                pw_Reserved2            :       ARRAY [0..191] OF BYTE;
                pw_IDCMP                        :       LONGINT;
                pw_WindowFlags  :       LONGINT;
                pw_WindowText   :       pIntuiText;
                pw_Gadgets              :       tExtGadgetList;
                pw_Menus                        :       tExtMenuList;
                pw_Boxes                        :       tBevelList;
                pw_TagFlags             :       LONGINT;
                pw_InnerWidth   :       WORD;
                pw_InnerHeight  :       WORD;
                pw_ShowTitle    :       BOOLEAN;
                pw_Reserved3    :       ARRAY [0..5] OF BYTE;
                pw_MouseQueue   :       WORD;
                pw_RptQueue             :       WORD;
                pw_Flags                        :       WORD;
        END;


  { tags for the GTX_LoadGUI() routine }

CONST

        RG_TagBase              =       $80000200;

        RG_GUI                  =       $80000201;
        RG_Config               =       $80000202;
        RG_CConfig              =       $80000203;
        RG_AsmConfig    =       $80000204;
        RG_LibGen               =       $80000205;
        RG_WindowList   =       $80000206;
        RG_Valid                        =       $80000207;
        RG_PasswordEntry        =       $80000208;

        VLF_GUI                 =       1;
        VLF_CONFIG              =       2;
        VLF_CCONFIG             =       4;
        VLF_ASMCONFIG   =       8;
        VLF_LIBGEN              =       16;
        VLF_WINDOWLIST  =       32;

        ERROR_NOMEM      = 1;
        ERROR_OPEN       = 2;
        ERROR_READ       = 3;
        ERROR_WRITE      = 4;
        ERROR_PARSE      = 5;
        ERROR_PACKER     = 6;
        ERROR_PPLIB      = 7;
        ERROR_NOTGUIFILE = 8;



{               ***             From Hotkey.h           ***             }


{ A _very_ important handle }

TYPE

        HOTKEYHANDLE    =       LONGINT;

CONST

  { Flags for the HKH_SetRepeat tag }
  SRB_MX                                =       0;
  SRF_MX                                =       1;
  SRB_CYCLE                     =       1;
  SRF_CYCLE                     =       2;
  SRB_SLIDER            =       2;
  SRF_SLIDER            =       4;
  SRB_SCROLLER          =       3;
  SRF_SCROLLER          =       8;
  SRB_LISTVIEW          =       4;
  SRF_LISTVIEW          =       16;
  SRB_PALETTE           =       5;
  SRF_PALETTE           =       32;


  { tags for the hotkey system }

  HKH_TagBase                   =       $80000100;
  HKH_KeyMap                    =       $80000101;
  HKH_UseNewButton      =       $80000102;
  HKH_NewText                   =       $80000103;
  HKH_SetRepeat         =       $80000104;




{               ***             From Textclass.h                ***             }

  TX_TagBase                    =       $80000001;

  TX_TX_tAttr                   =       $80000002;
  TX_Style                              =       $80000003;
  TX_ForceTextPen               =       $80000004;
  TX_Underscore         =       $80000005;
  TX_Flags                              =       $80000006;
  TX_Text                               =       $80000007;
  TX_NoBox                              =       $80000008;




{ LIBRARY FUNCTION DESCRIPTIONS }

function GTX_TagInArray
                (tag: longint;
                taglist: pointer): longint;

function GTX_SetTagData
                (tag,
                data: longint;
                taglist: pointer): longint;

function GTX_GetNode
                (list: pointer;
                nodenum: longint): longint;

function GTX_GetNodeNumber
                (list,
                node: pointer): longint;

function GTX_CountNodes (list: pointer): longint;
function GTX_MoveNode
                (list,
                node: pointer;
                direction: longint): longint;

function GTX_IFFErrToStr
                (error,
                skipendof: longint): longint;

function GTX_GetHandleA (tags: pointer): longint;
function GTX_FreeHandle (handle: pointer): longint;
function GTX_RefreshWindow
                (handle,
                window,
                requester: pointer): longint;

function GTX_CreateGadgetA
                (handle: pointer;
                kind: longint;
                pred,
                newgadget,
                tags: pointer): longint;

function GTX_RawToVanilla
                (handle: pointer;
                code,
                qualifier: longint): longint;

function GTX_GetIMsg
                (handle,
                port: pointer): longint;

function GTX_ReplyIMsg
                (handle,
                imsg: pointer): longint;

function GTX_SetGadgetAttrsA
                (handle,
                gadget,
                tags: pointer): longint;

function GTX_DetachLabels
                (handle,
                gadget: pointer): longint;

function GTX_DrawBox
                (rport: pointer;
                left,
                top,
                width,
                height: longint;
                dri: pointer;
                state: longint): longint;

function GTX_InitTextClass: longint;
function GTX_InitGetFileClass: longint;
function GTX_SetHandleAttrsA
                (handle,
                taglist: pointer): longint;

function GTX_BeginRefresh (handle: pointer): longint;
function GTX_EndRefresh
                (handle: pointer;
                all: longint): longint;

function GTX_FreeWindows
                (chain,
                windows: pointer): longint;

function GTX_LoadGUIA
                (chain,
                name,
                tags: pointer): longint;



var
  GTXBase: pLibrary;





IMPLEMENTATION

function GTX_TagInArray; xassembler;
asm
        move.l  a6,-(sp)
        lea             8(sp),a6
        move.l  (a6)+,a0
        move.l  (a6)+,d0
        move.l  GTXBase,a6
        jsr             -$1E(a6)
        move.l  d0,$10(sp)
        move.l  (sp)+,a6
end;

function GTX_SetTagData; xassembler;
asm
        move.l  a6,-(sp)
        lea             8(sp),a6
        move.l  (a6)+,a0
        move.l  (a6)+,d1
        move.l  (a6)+,d0
        move.l  GTXBase,a6
        jsr             -$24(a6)
        move.l  d0,$14(sp)
        move.l  (sp)+,a6
end;

function GTX_GetNode; xassembler;
asm
        move.l  a6,-(sp)
        movem.l 8(sp),d0/a0
        move.l  GTXBase,a6
        jsr             -$2A(a6)
        move.l  d0,$10(sp)
        move.l  (sp)+,a6
end;

function GTX_GetNodeNumber; xassembler;
asm
        move.l  a6,-(sp)
        lea             8(sp),a6
        move.l  (a6)+,a1
        move.l  (a6)+,a0
        move.l  GTXBase,a6
        jsr             -$30(a6)
        move.l  d0,$10(sp)
        move.l  (sp)+,a6
end;

function GTX_CountNodes; xassembler;
asm
        move.l  a6,-(sp)
        move.l  8(sp),a0
        move.l  GTXBase,a6
        jsr             -$36(a6)
        move.l  d0,$C(sp)
        move.l  (sp)+,a6
end;

function GTX_MoveNode; xassembler;
asm
        move.l  a6,-(sp)
        lea             8(sp),a6
        move.l  (a6)+,d0
        move.l  (a6)+,a1
        move.l  (a6)+,a0
        move.l  GTXBase,a6
        jsr             -$3C(a6)
        move.l  d0,$14(sp)
        move.l  (sp)+,a6
end;

function GTX_IFFErrToStr; xassembler;
asm
        move.l  a6,-(sp)
        lea             8(sp),a6
        move.l  (a6)+,d1
        move.l  (a6)+,d0
        move.l  GTXBase,a6
        jsr             -$42(a6)
        move.l  d0,$10(sp)
        move.l  (sp)+,a6
end;

function GTX_GetHandleA; xassembler;
asm
        move.l  a6,-(sp)
        move.l  8(sp),a0
        move.l  GTXBase,a6
        jsr             -$48(a6)
        move.l  d0,$C(sp)
        move.l  (sp)+,a6
end;

function GTX_FreeHandle; xassembler;
asm
        move.l  a6,-(sp)
        move.l  8(sp),a0
        move.l  GTXBase,a6
        jsr             -$4E(a6)
        move.l  d0,$C(sp)
        move.l  (sp)+,a6
end;

function GTX_RefreshWindow; xassembler;
asm
        movem.l a2/a6,-(sp)
        lea             $C(sp),a6
        move.l  (a6)+,a2
        move.l  (a6)+,a1
        move.l  (a6)+,a0
        move.l  GTXBase,a6
        jsr             -$54(a6)
        move.l  d0,$18(sp)
        movem.l (sp)+,a2/a6
end;

function GTX_CreateGadgetA; xassembler;
asm
        movem.l a2-a3/a6,-(sp)
        lea             $10(sp),a6
        move.l  (a6)+,a3
        move.l  (a6)+,a2
        move.l  (a6)+,a1
        move.l  (a6)+,d0
        move.l  (a6)+,a0
        move.l  GTXBase,a6
        jsr             -$5A(a6)
        move.l  d0,$24(sp)
        movem.l (sp)+,a2-a3/a6
end;

function GTX_RawToVanilla; xassembler;
asm
        move.l  a6,-(sp)
        lea             8(sp),a6
        move.l  (a6)+,d1
        move.l  (a6)+,d0
        move.l  (a6)+,a0
        move.l  GTXBase,a6
        jsr             -$60(a6)
        move.l  d0,$14(sp)
        move.l  (sp)+,a6
end;

function GTX_GetIMsg; xassembler;
asm
        move.l  a6,-(sp)
        lea             8(sp),a6
        move.l  (a6)+,a1
        move.l  (a6)+,a0
        move.l  GTXBase,a6
        jsr             -$66(a6)
        move.l  d0,$10(sp)
        move.l  (sp)+,a6
end;

function GTX_ReplyIMsg; xassembler;
asm
        move.l  a6,-(sp)
        lea             8(sp),a6
        move.l  (a6)+,a1
        move.l  (a6)+,a0
        move.l  GTXBase,a6
        jsr             -$6C(a6)
        move.l  d0,$10(sp)
        move.l  (sp)+,a6
end;

function GTX_SetGadgetAttrsA; xassembler;
asm
        movem.l a2/a6,-(sp)
        lea             $C(sp),a6
        move.l  (a6)+,a2
        move.l  (a6)+,a1
        move.l  (a6)+,a0
        move.l  GTXBase,a6
        jsr             -$72(a6)
        move.l  d0,$18(sp)
        movem.l (sp)+,a2/a6
end;

function GTX_DetachLabels; xassembler;
asm
        move.l  a6,-(sp)
        lea             8(sp),a6
        move.l  (a6)+,a1
        move.l  (a6)+,a0
        move.l  GTXBase,a6
        jsr             -$78(a6)
        move.l  d0,$10(sp)
        move.l  (sp)+,a6
end;

function GTX_DrawBox; xassembler;
asm
        movem.l d3-d4/a6,-(sp)
        lea             $10(sp),a6
        move.l  (a6)+,d4
        move.l  (a6)+,a1
        move.l  (a6)+,d3
        move.l  (a6)+,d2
        move.l  (a6)+,d1
        move.l  (a6)+,d0
        move.l  (a6)+,a0
        move.l  GTXBase,a6
        jsr             -$7E(a6)
        move.l  d0,$2C(sp)
        movem.l (sp)+,d3-d4/a6
end;

function GTX_InitTextClass; xassembler;
asm
        movem.l d3-d4/a6,-(sp)
        move.l  GTXBase,a6
        jsr             -$84(a6)
        move.l  d0,$10(sp)
        movem.l (sp)+,d3-d4/a6
end;

function GTX_InitGetFileClass; xassembler;
asm
        movem.l d3-d4/a6,-(sp)
        move.l  GTXBase,a6
        jsr             -$8A(a6)
        move.l  d0,$10(sp)
        movem.l (sp)+,d3-d4/a6
end;

function GTX_SetHandleAttrsA; xassembler;
asm
        move.l  a6,-(sp)
        lea             8(sp),a6
        move.l  (a6)+,a1
        move.l  (a6)+,a0
        move.l  GTXBase,a6
        jsr             -$90(a6)
        move.l  d0,$10(sp)
        move.l  (sp)+,a6
end;

function GTX_BeginRefresh; xassembler;
asm
        move.l  a6,-(sp)
        move.l  8(sp),a0
        move.l  GTXBase,a6
        jsr             -$96(a6)
        move.l  d0,$C(sp)
        move.l  (sp)+,a6
end;

function GTX_EndRefresh; xassembler;
asm
        move.l  a6,-(sp)
        movem.l 8(sp),d0/a0
        move.l  GTXBase,a6
        jsr             -$9C(a6)
        move.l  d0,$10(sp)
        move.l  (sp)+,a6
end;

function GTX_FreeWindows; xassembler;
asm
        move.l  a6,-(sp)
        lea             8(sp),a6
        move.l  (a6)+,a1
        move.l  (a6)+,a0
        move.l  GTXBase,a6
        jsr             -$E4(a6)
        move.l  d0,$10(sp)
        move.l  (sp)+,a6
end;

function GTX_LoadGUIA; xassembler;
asm
        movem.l a2/a6,-(sp)
        lea             $C(sp),a6
        move.l  (a6)+,a2
        move.l  (a6)+,a1
        move.l  (a6)+,a0
        move.l  GTXBase,a6
        jsr             -$EA(a6)
        move.l  d0,$18(sp)
        movem.l (sp)+,a2/a6
end;

end.
