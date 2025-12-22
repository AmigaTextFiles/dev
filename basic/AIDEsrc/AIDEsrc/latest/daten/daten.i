*   AIDE 2.13, an environment for ACE
*   Copyright (C) 1995/97 by Herbert Breuer
*		  1997/99 by Daniel Seifert
*
*                 contact me at: dseifert@gmx.net
*
*                                Daniel Seifert
*                                Elsenborner Weg 25
*                                12621 Berlin
*                                GERMANY
*
*   This program is free software; you can redistribute it and/or modify
*   it under the terms of the GNU General Public License as published by
*   the Free Software Foundation; either version 2 of the License, or
*   (at your option) any later version.
*
*   This program is distributed in the hope that it will be useful,
*   but WITHOUT ANY WARRANTY; without even the implied warranty of
*   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
*   GNU General Public License for more details.
*
*   You should have received a copy of the GNU General Public License
*   along with this program; if not, write to the
*          Free Software Foundation, Inc., 59 Temple Place, 
*          Suite 330, Boston, MA  02111-1307  USA

*--------------------------------------
* daten.i
*--------------------------------------

appendTxt   dc.l ID_ass_other_txt
            dc.l ID_lnk_other_txt
            dc.l ID_preco_other_txt
            dc.l ID_error_ass_other_txt
            dc.l ID_error_lnk_other_txt
            dc.l ID_error_preco_other_txt
            dc.l ID_text1_module_dir_error
            dc.l ID_text1_temp_dir_error
            dc.l ID_text_souce_file_aktiv1
            dc.l ID_err_text
            dc.l 0

append2Txt  dc.l ass_other_txt
            dc.l lnk_other_txt
            dc.l preco_other_txt
            dc.l error_ass_other_txt
            dc.l error_lnk_other_txt
            dc.l error_preco_other_txt
            dc.l text1_module_dir_error
            dc.l text1_temp_dir_error
            dc.l text_souce_file_aktiv1
            dc.l err_text
            dc.l 0

appendOffset
            dc.l ass_other_txt_offset
            dc.l lnk_other_txt_offset
            dc.l preco_other_txt_offset
            dc.l error_ass_other_txt_offset
            dc.l error_lnk_other_txt_offset
            dc.l error_preco_other_txt_offset
            dc.l text1_module_dir_error_offset
            dc.l text1_temp_dir_error_offset
            dc.l text_souce_file_aktiv1_offset
            dc.l err_text_offset
            dc.l 0

ass_other_txt_offset           dc.l 0
lnk_other_txt_offset           dc.l 0
preco_other_txt_offset         dc.l 0
error_ass_other_txt_offset     dc.l 0
error_lnk_other_txt_offset     dc.l 0
error_preco_other_txt_offset   dc.l 0
text1_module_dir_error_offset  dc.l 0
text1_temp_dir_error_offset    dc.l 0
text_souce_file_aktiv1_offset  dc.l 0
err_text_offset                dc.l 0

aslname                 ASLNAME
dosname                 DOSNAME
gadtoolsname            GADTOOLSNAME
graphname               GRAPHNAME
intname                 INTNAME
utilityname             UTILITYNAME
diskfontname            DISKFONTNAME
mrtname                 MRTNAME
iconname                ICONNAME
localename              LOCALENAME
rexxsyslibname          REXXSYSLIBNAME

wbname                  dc.b "workbench.library",0
                        even

WBString                dc.b "Workbench",0
                        even
* Konstanten
*--------------------------------------
minStackSize            equ     4000
strSize                 equ     80
FileSize                equ     32
True                    equ     1
False                   equ     0
MemSize                 equ     5000
BufferSize              equ     2500
*--------------------------------------
Anzahl_Lib              equ     10
*--------------------------------------
*Pointer
*-------
_AslBase                dc.l    0
_DOSBase                dc.l    0
_GadToolsBase           dc.l    0
_GfxBase                dc.l    0
_IntuitionBase          dc.l    0
_UtilityBase            dc.l    0
_MRTBase                dc.l    0
_DiskfontBase           dc.l    0
_IconBase               dc.l    0
_LocaleBase             dc.l    0
_RexxSysBase            dc.l    0
_WBBase                 dc.l    0
*--------------------------------------
_AppIcon_MsgPort        dc.l    0
_AppIcon                dc.l    0
_icondat                dc.l    0
*--------------------------------------
_ScrnPtr                dc.l    0
_ScrnRastPort           dc.l    0
_ScrnViewPort           dc.l    0
_WBScreen               dc.l    0
*--------------------------------------
_MainWinPtr             dc.l    0
_MainWinRastPort        dc.l    0
_WinMsgPort             dc.l    0
_MainGadList            dc.l    0
*--------------------------------------
_MsgWinPtr              dc.l    0
_MsgWinRPort            dc.l    0
*--------------------------------------
_SetupWinPtr            dc.l    0
_SetupGadList           dc.l    0
_SetupWinRastPort       dc.l    0
*--------------------------------------
_SOptWinPtr             dc.l    0
_SOptGadList            dc.l    0
_SOptWinRastPort        dc.l    0
*--------------------------------------
IDCMP_Flag              dc.l    0
*--------------------------------------
_VInfo                  dc.l    0
_MenuePtr               dc.l    0
_MenueTagList           dc.l    0
_GadList                dc.l    0
_eigenerTask            dc.l    0
_FontPtr                dc.l    0
_MemPtr                 dc.l    0
_BufferPtr              dc.l    0
*--------------------------------------
_GadgetTexte            dc.l    IDGadText_0       ;pos  0
                        dc.l    IDGadText_1       ;pos  1
                        dc.l    IDGadText_2       ;pos  2
                        dc.l    IDGadText_3       ;pos  3
                        dc.l    IDGadText_4       ;pos  4
                        dc.l    IDGadText_5       ;pos  5
                        dc.l    IDGadText_6       ;pos  6
                        dc.l    IDGadText_7       ;pos  7
                        dc.l    IDGadText_8       ;pos  8
                        dc.l    IDGadText_9       ;pos  9
                        dc.l    IDGadText_10      ;pos 10
                        dc.l    IDGadText_11      ;pos 11
                        dc.l    0               ;pos 12
                        dc.l    IDGadText_15      ;pos 13
                        dc.l    IDGadText_16      ;pos 14
                        dc.l    IDGadText_17      ;pos 15
                        dc.l    IDGadText_18      ;pos 16
                        dc.l    IDGadText_19      ;pos 17
                        dc.l    IDGadText_20      ;pos 18
                        dc.l    IDGadText_21      ;pos 19
                        dc.l    IDGadText_22      ;pos 20
                        dc.l    IDGadText_23      ;pos 21
                        dc.l    IDGadText_24      ;pos 22
                        dc.l    IDGadText_25      ;pos 23
                        dc.l    0               ;pos 24
                        dc.l    IDGadText_29      ;pos 25
                        dc.l    IDGadText_30      ;pos 26
                        dc.l    IDGadText_31      ;pos 27
                        dc.l    IDGadText_32      ;pos 28
                        dc.l    0               ;pos 29
                        dc.l    0               ;pos 30
                        dc.l    IDGadText_39      ;pos 31
                        dc.l    IDGadText_40      ;pos 32
                        dc.l    IDGadText_41      ;pos 33
                        dc.l    IDGadText_42      ;pos 34
                        dc.l    IDGadText_43      ;pos 35
                        dc.l    0               ;Ende Markierung
*---------------------------------------------
_MxGadTexte_pre         dc.l    IDGadText_12
                        dc.l    IDGadText_13
                        dc.l    IDGadText_14
                        dc.l    0
*---------------------------------------------
_MxGadTexte_ass         dc.l    IDGadText_26
                        dc.l    IDGadText_27
                        dc.l    IDGadText_28
                        dc.l    0
*---------------------------------------------
_MxGadTexte_lnklib      dc.l    IDGadText_35
                        dc.l    IDGadText_34
                        dc.l    IDGadText_33
                        dc.l    0
*---------------------------------------------
_MxGadTexte_lnk         dc.l    IDGadText_36
                        dc.l    IDGadText_37
                        dc.l    IDGadText_38
                        dc.l    0
*---------------------------------------------
_Gadget_Ptr_MainWin     ds.l    50
_Gadget_Ptr_SOptWin     ds.l    50
*---------------------------------------------

_SOptGadgetsText
              dc.l    ID_SOptGad00
              dc.l    ID_SOptGad01
              dc.l    ID_SOptGad02
              dc.l    ID_SOptGad03
              dc.l    ID_SOptGad04
              dc.l    ID_SOptGad05
              dc.l    ID_SOptGad06
              dc.l    ID_SOptGad07
              dc.l    ID_SOptGad08
              dc.l    ID_SOptGad09
              dc.l    ID_SOptGad10
              dc.l    ID_SOptGad11
              dc.l    ID_SOptGad12
              dc.l    ID_SOptGad13
              dc.l    ID_SOptGad14
              dc.l    ID_SOptGad15
              dc.l    ID_SOptGad16
              dc.l    0

_SOptButtons  dc.l 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,ID_SOptButton1
              dc.l ID_SOptButton2,ID_SOptButton3,ID_SOptButton4,0



Thinpaz_Font_Name       dc.b    "thinpaz.font",0
                        even

_ThinpazAttr            dc.l    Thinpaz_Font_Name
                        dc.w    8
                        dc.b    0
                        dc.b    2
*--------------------------------------
Wahl_Font_Name          ds.b    32

_WahlFontAttr           dc.l    Wahl_Font_Name
                        dc.w    0
                        dc.b    0
                        dc.b    2
*--------------------------------------
_FontAttrPtr            dc.l    _ThinpazAttr
*--------------------------------------
* ColorMap 4 Farben
*--------------------------------------
default_ColorMap        dc.w $0AAA,$0000,$0FFF,$068B

*                       0=hellgrau, 1=schw, 2=weiss, 3=blau

FarbenAnzahl            equ     4

ColorMapPtr             dc.l    default_ColorMap
*--------------------------------------
AsynchFlag              dc.l    0

                        CNOP    0,4

dos_tags                dc.l    NP_StackSize,40000
                        dc.l    SYS_Input,0
                        dc.l    SYS_Output,0
                        dc.l    0
*--------------------------------------
run_tags                dc.l    NP_StackSize,40000
                        dc.l    SYS_Input,0
                        dc.l    SYS_Output,0
                        dc.l    0
*--------------------------------------
run_asynch_tags         dc.l    NP_StackSize,40000
                        dc.l    SYS_Input,0
                        dc.l    SYS_Output,0
                        dc.l    SYS_Asynch,1
                        dc.l    0
*--------------------------------------
con_def                 dc.b    "CON:"
                        even
con_def_buffer          ds.b    100
con_fortsetzung         dc.b    "/1280/100/ AIDE Output Window/AUTO",0
                        even
*--------------------------------------
shell_def               dc.b    "CON:"
                        even
shell_def_buffer        ds.b    100
shell_fortsetzung       dc.b    "/1280/200/ AIDE Shell Window/AUTO/WAIT/CLOSE",0
                        even
*--------------------------------------
cmd_txt_table           dc.l    IDnap_txt
                        dc.l    IDacpp_txt
                        dc.l    preco_other_txt
                        dc.l    IDremoveline_txt
                        dc.l    IDace_txt
                        dc.l    IDsuperopt_txt
                        dc.l    IDa68k_txt
                        dc.l    IDphxass_txt
                        dc.l    ass_other_txt
                        dc.l    IDblink_txt
                        dc.l    IDphxlnk_txt
                        dc.l    lnk_other_txt
*--------------------------------------
cmd_error_table         dc.l    IDerror_nap_txt
                        dc.l    IDerror_acpp_txt
                        dc.l    error_preco_other_txt
                        dc.l    IDerror_removeline_txt
                        dc.l    IDerror_ace_txt
                        dc.l    IDerror_superopt_txt
                        dc.l    IDerror_a68k_txt
                        dc.l    IDerror_phxass_txt
                        dc.l    error_ass_other_txt
                        dc.l    IDerror_blink_txt
                        dc.l    IDerror_phxlnk_txt
                        dc.l    error_lnk_other_txt
*--------------------------------------
dos_cmd_table           dc.l    0
                        dc.l    0
                        dc.l    0
                        dc.l    0
                        dc.l    0
                        dc.l    0
                        dc.l    0
                        dc.l    0
                        dc.l    0
                        dc.l    0
                        dc.l    0
                        dc.l    0
                        dc.l    0
*--------------------------------------
dos_cmd_txt_table       dc.l    dos_cmd_nap
                        dc.l    dos_cmd_acpp
                        dc.l    dos_cmd_preco_other
                        dc.l    dos_cmd_removeline
                        dc.l    dos_cmd_ace
                        dc.l    dos_cmd_superopt
                        dc.l    dos_cmd_a68k
                        dc.l    dos_cmd_phxass
                        dc.l    dos_cmd_ass_other
                        dc.l    dos_cmd_blink
                        dc.l    dos_cmd_phxlnk
                        dc.l    dos_cmd_lnk_other
                        dc.l    0
*--------------------------------------
* Bit Definitionen und Daten für MakeProzess
*-------------------------------------------
nap                     equ     0
acpp                    equ     1
preco_other             equ     2
removeline              equ     3
ace                     equ     4
superopt                equ     5
a68k                    equ     6
phxass                  equ     7
ass_other               equ     8
blink                   equ     9
phxlnk                  equ     10
lnk_other               equ     11

default_MakeSetup       equ     %00010001111010 ;12 Bits benötigt

SOptAbbr                dc.l    %00000000000000000000000000000000 ; none
                        dc.l    %00000000000000010100100001100000 ; less
                        dc.l    %00000000000000011101100001101011 ; std
                        dc.l    %00000000000000011111111111111111 ; full
                                ;- v1.x level - LFmsMPEcSrCTIAXBZ

CompileErrorFlag        dc.l    0
CommandoSetup           dc.l    0
KomplettFlag            dc.l    0
StringEndeAddress       dc.l    0

DosCmdOtherOffset       equ     8
*--------------------------------------
* Make Process info
*------------------
new_source_file_Flag    dc.w    0
source_set_Flag         dc.w    0
precompiled             dc.w    0
compiled                dc.w    0
superoptimized          dc.w    0
assembled               dc.w    0
linked                  dc.w    0
built                   dc.w    0

*--------------------------------------
* Bit Definitionen für CompilerOptions
*--------------------------------------

ace_option_table        dc.l    win_trapp
                        dc.l    optim_ass
                        dc.l    add_icon
                        dc.l    asm_comm
                        dc.l    break_trapp

break_trapp             dc.b    "b",0
                        even
asm_comm                dc.b    "c",0
                        even
add_icon                dc.b    "i",0
                        even
optim_ass               dc.b    "O",0
                        even
win_trapp               dc.b    "w",0
                        even

OptionChars             dc.b    "ZBXAITCrScEPMsmFL",0
                        even
*--------------------------------------
AceObjectFlag           dc.l    0
_ASLonlydir             dc.l    0

* ACE
*----
break_trapping          equ     4
asm_comment             equ     3
create_icon             equ     2
optimize_assembly       equ     1
window_trapping         equ     0

* Assembler
*----------
ass_small_code          equ     7
ass_small_data          equ     6
ass_debug_info          equ     5

* Linker
*-------
linker_small_code       equ     10
linker_small_data       equ     9
linker_no_debug         equ     8

* Amiga Linker Libs
*------------------
ami_lib                 equ     13
amiga_lib               equ     12
other_lib               equ     11

default_OptionsSetup    equ     %10000000000010 ;14 Bits benötigt

*--------------------------------------
* Directory Setup
*----------------
env_dir_tab             dc.l    default_ace_dir
                        dc.l    default_aide_dir
                        dc.l    default_bin_dir
                        dc.l    default_bmap_dir
                        dc.l    default_icon_dir
                        dc.l    default_inc_dir
                        dc.l    default_lib_dir

EnvDirAnzahl            equ     7
*--------------------------------------

* änderbare Dirs durch ConfigFile
*--------------------------------

ConfigDirs

editor                  dc.l    default_editor
viewer                  dc.l    default_viewer
calc                    dc.l    default_calc
agdtool                 dc.l    default_agdtool
tmp_dir                 dc.l    default_tmp_dir
src_dir                 dc.l    default_src_dir
blt_dir                 dc.l    default_blt_dir
doc_dir                 dc.l    default_doc_dir
mod_dir                 dc.l    default_mod_dir
fd_dir                  dc.l    default_fd_dir
ab2ascii                dc.l    default_ab2ascii
uppercacer              dc.l    default_uppercacer
fd2bmap                 dc.l    default_fd2bmap
reqed                   dc.l    default_reqed

AnzahlConfigDirs        equ     14

mltvtool                dc.l    default_mltvtool

ConfigDirOffsetTab

                        dc.l    new_editor
                        dc.l    new_viewer
                        dc.l    new_calc
                        dc.l    new_agdtool
                        dc.l    new_tmp_dir
                        dc.l    new_src_dir
                        dc.l    new_blt_dir
                        dc.l    new_doc_dir
                        dc.l    new_mod_dir
                        dc.l    new_fd_dir
                        dc.l    new_abtoascii
                        dc.l    new_uppercacer
                        dc.l    new_fdtobmap
                        dc.l    new_reqed
*--------------------------------------

* temporäre Dirs
*---------------
source_fullname         ds.b    256+32
source_dirname          ds.b    256
source_filename         ds.b    32

TempDir                 ds.b    256
TempFile                ds.b    32

curr_open_dir           ds.b    256
curr_open_file          ds.b    32

curr_view_dir           ds.b    256
curr_view_file          ds.b    32

curr_rename_dir         ds.b    256
curr_rename_file        ds.b    32
curr_rename_fullname1   ds.b    256+32
curr_rename_fullname2   ds.b    256+32

curr_copy_dir           ds.b    256
curr_copy_file          ds.b    32
curr_copy_fullname1     ds.b    256+32
curr_copy_fullname2     ds.b    256+32

curr_delete_dir         ds.b    256
curr_delete_file        dc.l    0

curr_print_dir          ds.b    256
curr_print_file         ds.b    32

curr_basic_dir          ds.b    256
curr_basic_file         ds.b    256+32
curr_basic_dest_dir     ds.b    256

OtherConfigDir          ds.b    256
OtherConfigName         ds.b    32
*--------------------------------------
ModuleAnzahl            dc.l    0
_AvailableModule        dc.l    0
StartZeile              dc.w    0
ModuleTextPuffer        ds.b    32
ZeilenLaenge            equ     27
*--------------------------------------
* File Daten
*-----------
ASLReqTitel             dc.l    0
_FileListPuffer         dc.l    0
FileListAnzahl          dc.l    0
MultiSelectFlag         dc.w    0
*-------------------------------------
Dateigroesse            dc.l    0
*--------------------------------------
Datei_geladen           dc.b    0
Datei_gesichert         dc.b    1
sichern_Flag            dc.b    0
ConfigFileFlag          dc.b    0
pruef_Flag              dc.w    0
*--------------------------------------
_fr_Dirname             dc.l    0
_fr_Filename            dc.l    0
DummyBuffer             dc.l    0
*--------------------------------------
PruefBuffer             ds.b    10
Dateiname               ds.b    256+32
*--------------------------------------
CurrentDirLock          dc.l    0
OldCurrentDirLock       dc.l    0
CurrentDirError         dc.w    0
*--------------------------------------
old_def_table           dc.l    old_editor_def
                        dc.l    old_viewer_def
                        dc.l    old_calc_def
                        dc.l    old_agd_def
                        dc.l    old_tmpdir_def
                        dc.l    old_srcdir_def
                        dc.l    old_bltdir_def
                        dc.l    old_docdir_def
                        dc.l    old_moddir_def
*--------------------------------------

* Daten zu Wb_Args
*-----------------

AnzahlToolTypes         equ     3

ToolTypesTable          dc.l    file_type
                        dc.l    config_file_type
                        dc.l    preco_type
                        dc.l    0               ;EndeMarkierung!!!

ToolTypesAblage         ds.l    3               ;Zeigerablage für gefundene ToolTypes
                        dc.l    0               ;EndeMarkierung!!!

ToolTypesEinstellungen  dc.l    tp_filetype
                        dc.l    tp_configfile
                        dc.l    tp_preco
                        dc.l    0               ;EndeMarkierung!!!

file_type               dc.b    "FILETYPE",0
                        even
config_file_type        dc.b    "CONFIGFILE",0
                        even
preco_type              dc.b    "PRECO",0
                        even

tp_filetype             ds.b    12
tp_configfile           ds.b    80
tp_preco                ds.b    12

*--------------------------------------
tp_filetype_name        dc.b    "ACESource",0
                        even
tp_program_dir          ds.b    80
tp_program_name         ds.b    32
*--------------------------------------
* Werte für Configuration
*------------------------
default_CleanUpFlag     equ     0
default_SOptLevel       equ     $0C01FFFF
default_SOptVersion     equ     0
*--------------------------------------
ScreenFlag              dc.l    0
RequesterFlag           dc.l    0
CleanUpFlag             dc.l    1

MakeSetup               dc.l    0
OldSetup                dc.l    0
OptionsSetup            dc.l    0
SOptLevel               dc.l    0
SOptVersion             dc.l    0

*--------------------------------------
Config_geaendert        dc.w    0
Config_loaded           dc.w    0
*--------------------------------------

******************************
* Offsetwerte für ConfigFile *
******************************

IDString                dc.b    "AIDE configuration file",0
                        even
LaengeIDString          equ     *-IDString
*--------------------------------------

* Flags
*------

screen_flag             equ     LaengeIDString
*--------------------------------------
requester_flag          equ     screen_flag+4
*--------------------------------------
clean_up_flag           equ     requester_flag+4
*--------------------------------------
new_MakeSetup           equ     clean_up_flag+4
*--------------------------------------
new_OptionsSetup        equ     new_MakeSetup+4
*--------------------------------------
superopt_level          equ     new_OptionsSetup+4
*--------------------------------------
superopt_version        equ     superopt_level+4                ; was MenuPen
*--------------------------------------

* Names + Strings
*----------------

other_precomp_name      equ     superopt_version+4
*--------------------------------------

other_ace_options       equ     other_precomp_name+32
*--------------------------------------

other_ass_name          equ     other_ace_options+82
*--------------------------------------

ass_options             equ     other_ass_name+32
*--------------------------------------

other_lib_name          equ     ass_options+256
*--------------------------------------

other_linker_name       equ     other_lib_name+32
*--------------------------------------

linker_options          equ     other_linker_name+32
*--------------------------------------

* Directories
*------------

new_editor              equ     linker_options+256
*--------------------------------------
new_viewer              equ     new_editor+80
*--------------------------------------
new_calc                equ     new_viewer+80
*--------------------------------------
new_agdtool             equ     new_calc+80
*--------------------------------------
new_tmp_dir             equ     new_agdtool+80
*--------------------------------------
new_src_dir             equ     new_tmp_dir+80
*--------------------------------------
new_blt_dir             equ     new_src_dir+80
*--------------------------------------
new_doc_dir             equ     new_blt_dir+80
*--------------------------------------
new_mod_dir             equ     new_doc_dir+80
*--------------------------------------
new_fd_dir              equ     new_mod_dir+80
*--------------------------------------
new_abtoascii           equ     new_fd_dir+80
*--------------------------------------
new_uppercacer          equ     new_abtoascii+80
*--------------------------------------
new_fdtobmap            equ     new_uppercacer+80
*--------------------------------------
new_reqed               equ     new_fdtobmap+80
*--------------------------------------
new_util_a              equ     new_reqed+80
*--------------------------------------
new_util_b              equ     new_util_a+80
*--------------------------------------
new_util_c              equ     new_util_b+80
*--------------------------------------
new_util_d              equ     new_util_c+80
*--------------------------------------
ConfigFileSize          equ     new_util_d+80
*--------------------------------------
ChangeableConfigDirs    equ     18
*--------------------------------------


