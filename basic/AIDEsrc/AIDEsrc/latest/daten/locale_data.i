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

* Daten, die zum Einsatz für die Locale.library gebraucht werden.
*****************************************************************


* Zeiger zum Catalog
catalog_ptr dc.l 0

* Name des Catalogs
catalogname dc.b "AIDE.catalog",0
            even

* Eingebaute Sprache
def_language dc.b "english",0
             even


OC_TagBase         EQU TAG_USER+$90000
OC_BuiltInLanguage EQU OC_TagBase+1     ; language of built-in strings
OC_BuiltInCodeSet  EQU OC_TagBase+2     ; code set of built-in strings
OC_Version         EQU OC_TagBase+3     ; catalog version number required
OC_Language        EQU OC_TagBase+4     ; preferred language of catalog


* Tags
localetags  dc.l OC_BuiltInLanguage
            dc.l def_language
            dc.l TAG_DONE
            dc.l 0

******************************************************************
* Daten
******************************************************************


* Textarray: Dieses Array enthält alle Texte, die in verschiedenen
*    Sprachen vorliegen können in der selben Reihenfolge, wie ihre
*    Kennummer ist.


textptr dc.l 0                                 ; Kennummer 0
        dc.l about_gad_txt                     ; Kennummer 1
        dc.l text_about1
        dc.l text_about2
        dc.l text_about3
        dc.l text_about4
        dc.l req_title
        dc.l error_req_title
        dc.l alert_req_title
        dc.l text_okay
        dc.l text_i_see                        ; Kennummer 10
        dc.l text_yes
        dc.l text_no
        dc.l text_cancel
        dc.l text_wrong_system
        dc.l text_not_enough_start_mem1
        dc.l text_not_enough_start_mem2
        dc.l text_mrtlib
        dc.l text_wblib
        dc.l text_asllib
        dc.l text_diskfontlib                  ; Kennummer 20
        dc.l text_gadtoolslib
        dc.l text_utillib
        dc.l text_doslib
        dc.l text_gfxlib
        dc.l text_iconlib
        dc.l text_no_port
        dc.l text_window_not_opened
        dc.l text_gt_gadgets_not_created
        dc.l text_menu_not_created
        dc.l text_config_changed               ; Kennummer 30
        dc.l text_want_to_save
        dc.l text_prg_title
        dc.l text_prg_end
        dc.l text_dirname_wrong
        dc.l text_correct_it
        dc.l text_filename_wrong
        dc.l text_filelength_null
        dc.l text_file_not_marked
        dc.l text_no_source_file_selected1
        dc.l text_no_source_file_selected2     ; Kennummer 40
        dc.l text_kill_source
        dc.l text_no_data_file
        dc.l text_default_settings
        dc.l text_current_settings
        dc.l text_no_config_loaded
        dc.l text_new_config_not_saved1
        dc.l text_new_config_not_saved2
        dc.l text_no_other_preco_eingetragen
        dc.l text_no_other_assembler_eingetragen
        dc.l text_no_other_linker_eingetragen  ; Kennummer 50
        dc.l text_no_other_linkerlib_eingetragen
        dc.l text_compiler_run_abort
        dc.l text_config_not_saved
        dc.l text_error_env1
        dc.l text_error_env2
        dc.l text_error_env3
        dc.l text_not_loaded_complete
        dc.l text_file_exists
        dc.l text_configfile_exists
        dc.l text_overwrite_it                 ; Kennummer 60
        dc.l text_rename_it
        dc.l text_file_error
        dc.l text_delete_it
        dc.l text_no_module_dir
        dc.l text_too_many_modules
        dc.l Source_Titel_Text
        dc.l Program_Titel_Text
        dc.l Make_Titel_Text
        dc.l Preco_Titel_Text
        dc.l AceOpt_Titel_Text
        dc.l View_Titel_Text
        dc.l SuperOpt_Titel_Text
        dc.l Ass_Titel_Text
        dc.l LinkLib_Titel_Text
        dc.l Linker_Titel_Text
        dc.l Module_Titel_Text
        dc.l GadText_0
        dc.l GadText_1
        dc.l GadText_2
        dc.l GadText_3
        dc.l GadText_4
        dc.l GadText_5
        dc.l GadText_6
        dc.l GadText_7
        dc.l GadText_8
        dc.l GadText_9
        dc.l GadText_10
        dc.l GadText_11
        dc.l GadText_12
        dc.l GadText_13
        dc.l GadText_14
        dc.l GadText_15
        dc.l GadText_16
        dc.l GadText_17
        dc.l GadText_18
        dc.l GadText_19
        dc.l GadText_20
        dc.l GadText_21
        dc.l GadText_22
        dc.l GadText_23
        dc.l GadText_24
        dc.l GadText_25
        dc.l GadText_26
        dc.l GadText_27
        dc.l GadText_28
        dc.l GadText_29
        dc.l GadText_30
        dc.l GadText_31
        dc.l GadText_32
        dc.l GadText_33
        dc.l GadText_34
        dc.l GadText_35
        dc.l GadText_36
        dc.l GadText_37
        dc.l GadText_38
        dc.l GadText_39
        dc.l GadText_40
        dc.l GadText_41
        dc.l GadText_42
        dc.l GadText_43
        dc.l acpp_txt
        dc.l nap_txt
        dc.l removeline_txt
        dc.l ace_txt
        dc.l superopt_txt
        dc.l a68k_txt
        dc.l phxass_txt
        dc.l blink_txt
        dc.l phxlnk_txt
        dc.l application_built_txt
        dc.l compile_erfolgreich_txt
        dc.l comp_error_text2
        dc.l error_acpp_txt
        dc.l error_nap_txt
        dc.l error_removeline_txt
        dc.l error_ace_txt
        dc.l error_superopt_txt
        dc.l error_a68k_txt
        dc.l error_phxass_txt
        dc.l error_blink_txt
        dc.l error_phxlnk_txt
        dc.l Cmd_Line_Text
        dc.l Ace_Options_Text
        dc.l Asm_Options_Text
        dc.l Lnk_Options_Text
        dc.l Preco_Other_Text
        dc.l Asm_Other_Text
        dc.l Lib_Other_Text
        dc.l Lnk_Other_Text
        dc.l laden_Text
        dc.l view_Text
        dc.l rename_Text1
        dc.l rename_Text2
        dc.l copy_Text1
        dc.l copy_Text2
        dc.l delete_Text
        dc.l print_Text
        dc.l config_laden_Text
        dc.l set_source_Text
        dc.l config_sichern_Text
        dc.l dirname_Text
        dc.l filename_Text
        dc.l bmaps_Text
        dc.l ab2ascii_Text1
        dc.l ab2ascii_Text2
        dc.l Exec_Prg_Text
        dc.l text_printer_error1
        dc.l text_printer_error2
        dc.l text_printer_error3
        dc.l text_printer_openerror1
        dc.l text_printer_openerror2
        dc.l SOptTitle
        dc.l _SOptGad00
        dc.l _SOptGad01
        dc.l _SOptGad02
        dc.l _SOptGad03
        dc.l _SOptGad04
        dc.l _SOptGad05
        dc.l _SOptGad06
        dc.l _SOptGad07
        dc.l _SOptGad08
        dc.l _SOptGad09
        dc.l _SOptGad10
        dc.l _SOptGad11
        dc.l _SOptGad12
        dc.l _SOptGad13
        dc.l _SOptGad14
        dc.l _SOptGad15
        dc.l _SOptGad16
        dc.l _SOptButton1
        dc.l _SOptButton2
        dc.l _SOptButton3
        dc.l _SOptButton4
        dc.l no_monitor_text
        dc.l newer_custom_chips_text
        dc.l not_enough_mem_text
        dc.l not_enough_chip_mem_text
        dc.l aide_already_active_text
        dc.l unknown_display_mode_text
        dc.l screen_to_deep_text
        dc.l failed_to_attach_screen_text
        dc.l mode_not_available_text
        dc.l m1t
        dc.l m1p1t
        dc.l m1p2t
        dc.l m1p3t
        dc.l m1p4t
        dc.l m1p5t
        dc.l m1p6t
        dc.l m1p7t
        dc.l m1p8t
        dc.l m1p9t
        dc.l m1p10t
        dc.l default_text
        dc.l other_text
        dc.l m1p11t
        dc.l m1p12t
        dc.l m1p13t
        dc.l m1p14t
        dc.l m2t
        dc.l m2p1t
        dc.l m2p2t
        dc.l m2p3t
        dc.l m2p4t
        dc.l m2p5t
        dc.l m2p6t
        dc.l m2p7t
        dc.l m2p8t
        dc.l m2p9t
        dc.l m3t
        dc.l DirSetup_Titel_Text
        dc.l NewSrcDir_Titel_Text
        dc.l NewTmpDir_Titel_Text
        dc.l NewBltDir_Titel_Text
        dc.l NewDocDir_Titel_Text
        dc.l NewModDir_Titel_Text
        dc.l NewFDDir_Titel_Text
        dc.l NewEditor_Titel_Text
        dc.l NewViewer_Titel_Text
        dc.l NewAGD_Titel_Text
        dc.l NewFD2BMAP_Titel_Text
        dc.l NewAB2ASCII_Titel_Text
        dc.l NewUppercACEr_Titel_Text
        dc.l NewCalc_Titel_Text
        dc.l NewReqEd_Titel_Text
        dc.l NewUtil0_Titel_Text
        dc.l NewUtil1_Titel_Text
        dc.l NewUtil2_Titel_Text
        dc.l NewUtil3_Titel_Text
        dc.l Other_Text
        dc.l PubScreen_Text1
        dc.l PubScreen_Text2
        dc.l ReqSet_Text
        dc.l All_Text
        dc.l Error_Text
        dc.l Min_Text
        dc.l Cleanup_Text
        dc.l soptversion_Text
        dc.l Old_Text
        dc.l New_Text
        dc.l text_no_doc_dir1
        dc.l text_no_doc_dir2
        dc.l text_doc_file
        dc.l text_not_found
        dc.l errCA
        dc.l errCC
        dc.l errCD
        dc.l errD2
        dc.l errD5
        dc.l errD6
        dc.l errDA
        dc.l errDD
        dc.l errDE
        dc.l errDF
        dc.l errE0
        dc.l errE1
        dc.l errE2
        dc.l _err_text
        dc.l err_retry
        dc.l err_cancel
        dc.l err_2text
        dc.l err_3text
        dc.l io_error_titel
        dc.l text_font_not_loaded2
        dc.l _text_souce_file_aktiv1
        dc.l text_souce_file_aktiv2
        dc.l _text1_module_dir_error
        dc.l text2_module_dir_error
        dc.l text3_module_dir_error
        dc.l _text1_temp_dir_error
        dc.l _error_preco_other_txt
        dc.l _error_ass_other_txt
        dc.l _error_lnk_other_txt
        dc.l _preco_other_txt
        dc.l _ass_other_txt
        dc.l _lnk_other_txt
        dc.l CompileGadText
        dc.l _SetupWinTitle
        dc.l _SOptWinTitle
        dc.l _ScreenTitle
        dc.l _MainWinTitle
        dc.l _MsgWinTitle
        dc.l _InputWinTitle
        dc.l 0

* Kenncodes: Der Kenncode für einen String mit der Bezeichnung
*    <name> ist ID<name>. Die Kenncodes müssen an die Locale.
*    library weitergegeben werden.
*
*

IDabout_gad_txt                       equ   1
IDtext_about1                         equ   2
IDtext_about2                         equ   3
IDtext_about3                         equ   4
IDtext_about4                         equ   5
IDreq_title                           equ   6
IDerror_req_title                     equ   7
IDalert_req_title                     equ   8
IDtext_okay                           equ   9
IDtext_i_see                          equ  10
IDtext_yes                            equ  11
IDtext_no                             equ  12
IDtext_cancel                         equ  13
IDtext_wrong_system                   equ  14
IDtext_not_enough_start_mem1          equ  15
IDtext_not_enough_start_mem2          equ  16
IDtext_mrtlib                         equ  17
IDtext_wblib                          equ  18
IDtext_asllib                         equ  19
IDtext_diskfontlib                    equ  20
IDtext_gadtoolslib                    equ  21
IDtext_utillib                        equ  22
IDtext_doslib                         equ  23
IDtext_gfxlib                         equ  24
IDtext_iconlib                        equ  25
IDtext_no_port                        equ  26
IDtext_window_not_opened              equ  27
IDtext_gt_gadgets_not_created         equ  28
IDtext_menu_not_created               equ  29
IDtext_config_changed                 equ  30
IDtext_want_to_save                   equ  31
IDtext_prg_title                      equ  32
IDtext_prg_end                        equ  33
IDtext_dirname_wrong                  equ  34
IDtext_correct_it                     equ  35
IDtext_filename_wrong                 equ  36
IDtext_filelength_null                equ  37
IDtext_file_not_marked                equ  38
IDtext_no_source_file_selected1       equ  39
IDtext_no_source_file_selected2       equ  40
IDtext_kill_source                    equ  41
IDtext_no_data_file                   equ  42
IDtext_default_settings               equ  43
IDtext_current_settings               equ  44
IDtext_no_config_loaded               equ  45
IDtext_new_config_not_saved1          equ  46
IDtext_new_config_not_saved2          equ  47
IDtext_no_other_preco_eingetragen     equ  48
IDtext_no_other_assembler_eingetragen equ  49
IDtext_no_other_linker_eingetragen    equ  50
IDtext_no_other_linkerlib_eingetragen equ  51
IDtext_compiler_run_abort             equ  52
IDtext_config_not_saved               equ  53
IDtext_error_env1                     equ  54
IDtext_error_env2                     equ  55
IDtext_error_env3                     equ  56
IDtext_not_loaded_complete            equ  57
IDtext_file_exists                    equ  58
IDtext_configfile_exists              equ  59
IDtext_overwrite_it                   equ  60
IDtext_rename_it                      equ  61
IDtext_file_error                     equ  62
IDtext_delete_it                      equ  63
IDtext_no_module_dir                  equ  64
IDtext_too_many_modules               equ  65
IDSource_Titel_Text                   equ  66
IDProgram_Titel_Text                  equ  67
IDMake_Titel_Text                     equ  68
IDPreco_Titel_Text                    equ  69
IDAceOpt_Titel_Text                   equ  70
IDView_Titel_Text                     equ  71
IDSuperOpt_Titel_Text                 equ  72
IDAss_Titel_Text                      equ  73
IDLinkLib_Titel_Text                  equ  74
IDLinker_Titel_Text                   equ  75
IDModule_Titel_Text                   equ  76
IDGadText_0                           equ  77
IDGadText_1                           equ  78
IDGadText_2                           equ  79
IDGadText_3                           equ  80
IDGadText_4                           equ  81
IDGadText_5                           equ  82
IDGadText_6                           equ  83
IDGadText_7                           equ  84
IDGadText_8                           equ  85
IDGadText_9                           equ  86
IDGadText_10                          equ  87
IDGadText_11                          equ  88
IDGadText_12                          equ  89
IDGadText_13                          equ  90
IDGadText_14                          equ  91
IDGadText_15                          equ  92
IDGadText_16                          equ  93
IDGadText_17                          equ  94
IDGadText_18                          equ  95
IDGadText_19                          equ  96
IDGadText_20                          equ  97
IDGadText_21                          equ  98
IDGadText_22                          equ  99
IDGadText_23                          equ 100
IDGadText_24                          equ 101
IDGadText_25                          equ 102
IDGadText_26                          equ 103
IDGadText_27                          equ 104
IDGadText_28                          equ 105
IDGadText_29                          equ 106
IDGadText_30                          equ 107
IDGadText_31                          equ 108
IDGadText_32                          equ 109
IDGadText_33                          equ 110
IDGadText_34                          equ 111
IDGadText_35                          equ 112
IDGadText_36                          equ 113
IDGadText_37                          equ 114
IDGadText_38                          equ 115
IDGadText_39                          equ 116
IDGadText_40                          equ 117
IDGadText_41                          equ 118
IDGadText_42                          equ 119
IDGadText_43                          equ 120
IDacpp_txt                            equ 121
IDnap_txt                             equ 122
IDremoveline_txt                      equ 123
IDace_txt                             equ 124
IDsuperopt_txt                        equ 125
IDa68k_txt                            equ 126
IDphxass_txt                          equ 127
IDblink_txt                           equ 128
IDphxlnk_txt                          equ 129
IDapplication_built_txt               equ 130
IDcompile_erfolgreich_txt             equ 131
IDcomp_error_text2                    equ 132
IDerror_acpp_txt                      equ 133
IDerror_nap_txt                       equ 134
IDerror_removeline_txt                equ 135
IDerror_ace_txt                       equ 136
IDerror_superopt_txt                  equ 137
IDerror_a68k_txt                      equ 138
IDerror_phxass_txt                    equ 139
IDerror_blink_txt                     equ 140
IDerror_phxlnk_txt                    equ 141
IDCmd_Line_Text                       equ 142
IDAce_Options_Text                    equ 143
IDAsm_Options_Text                    equ 144
IDLnk_Options_Text                    equ 145
IDPreco_Other_Text                    equ 146
IDAsm_Other_Text                      equ 147
IDLib_Other_Text                      equ 148
IDLnk_Other_Text                      equ 149
IDladen_Text                          equ 150
IDview_Text                           equ 151
IDrename_Text1                        equ 152
IDrename_Text2                        equ 153
IDcopy_Text1                          equ 154
IDcopy_Text2                          equ 155
IDdelete_Text                         equ 156
IDprint_Text                          equ 157
IDconfig_laden_Text                   equ 158
IDset_source_Text                     equ 159
IDconfig_sichern_Text                 equ 160
IDdirname_Text                        equ 161
IDfilename_Text                       equ 162
IDbmaps_Text                          equ 163
IDab2ascii_Text1                      equ 164
IDab2ascii_Text2                      equ 165
IDExec_Prg_Text                       equ 166
IDtext_printer_error1                 equ 167
IDtext_printer_error2                 equ 168
IDtext_printer_error3                 equ 169
IDtext_printer_openerror1             equ 170
IDtext_printer_openerror2             equ 171
IDSOptTitle                           equ 172
ID_SOptGad00                          equ 173
ID_SOptGad01                          equ 174
ID_SOptGad02                          equ 175
ID_SOptGad03                          equ 176
ID_SOptGad04                          equ 177
ID_SOptGad05                          equ 178
ID_SOptGad06                          equ 179
ID_SOptGad07                          equ 180
ID_SOptGad08                          equ 181
ID_SOptGad09                          equ 182
ID_SOptGad10                          equ 183
ID_SOptGad11                          equ 184
ID_SOptGad12                          equ 185
ID_SOptGad13                          equ 186
ID_SOptGad14                          equ 187
ID_SOptGad15                          equ 188
ID_SOptGad16                          equ 189
ID_SOptButton1                        equ 190
ID_SOptButton2                        equ 191
ID_SOptButton3                        equ 192
ID_SOptButton4                        equ 193
IDno_monitor_text                     equ 194
IDnewer_custom_chips_text             equ 195
IDnot_enough_mem_text                 equ 196
IDnot_enough_chip_mem_text            equ 197
IDaide_already_active_text            equ 198
IDunknown_display_mode_text           equ 199
IDscreen_to_deep_text                 equ 200
IDfailed_to_attach_screen_text        equ 201
IDmode_not_available_text             equ 202
IDm1t                                 equ 203
IDm1p1t                               equ 204
IDm1p2t                               equ 205
IDm1p3t                               equ 206
IDm1p4t                               equ 207
IDm1p5t                               equ 208
IDm1p6t                               equ 209
IDm1p7t                               equ 210
IDm1p8t                               equ 211
IDm1p9t                               equ 212
IDm1p10t                              equ 213
IDdefault_text                        equ 214
IDother_text                          equ 215
IDm1p11t                              equ 216
IDm1p12t                              equ 217
IDm1p13t                              equ 218
IDm1p14t                              equ 219
IDm2t                                 equ 220
IDm2p1t                               equ 221
IDm2p2t                               equ 222
IDm2p3t                               equ 223
IDm2p4t                               equ 224
IDm2p5t                               equ 225
IDm2p6t                               equ 226
IDm2p7t                               equ 227
IDm2p8t                               equ 228
IDm2p9t                               equ 229
IDm3t                                 equ 230
IDDirSetup_Titel_Text                 equ 231
IDNewSrcDir_Titel_Text                equ 232
IDNewTmpDir_Titel_Text                equ 233
IDNewBltDir_Titel_Text                equ 234
IDNewDocDir_Titel_Text                equ 235
IDNewModDir_Titel_Text                equ 236
IDNewFDDir_Titel_Text                 equ 237
IDNewEditor_Titel_Text                equ 238
IDNewViewer_Titel_Text                equ 239
IDNewAGD_Titel_Text                   equ 240
IDNewFD2BMAP_Titel_Text               equ 241
IDNewAB2ASCII_Titel_Text              equ 242
IDNewUppercACEr_Titel_Text            equ 243
IDNewCalc_Titel_Text                  equ 244
IDNewReqEd_Titel_Text                 equ 245
IDNewUtil0_Titel_Text                 equ 246
IDNewUtil1_Titel_Text                 equ 247
IDNewUtil2_Titel_Text                 equ 248
IDNewUtil3_Titel_Text                 equ 249
IDOther_Text                          equ 250
IDPubScreen_Text1                     equ 251
IDPubScreen_Text2                     equ 252
IDReqSet_Text                         equ 253
IDAll_Text                            equ 254
IDError_Text                          equ 255
IDMin_Text                            equ 256
IDCleanup_Text                        equ 257
IDsoptversion_Text                    equ 258
IDOld_Text                            equ 259
IDNew_Text                            equ 260
IDtext_no_doc_dir1                    equ 261
IDtext_no_doc_dir2                    equ 262
IDtext_doc_file                       equ 263
IDtext_not_found                      equ 264
IDerrCA                               equ 265
IDerrCC                               equ 266
IDerrCD                               equ 267
IDerrD2                               equ 268
IDerrD5                               equ 269
IDerrD6                               equ 270
IDerrDA                               equ 271
IDerrDD                               equ 272
IDerrDE                               equ 273
IDerrDF                               equ 274
IDerrE0                               equ 275
IDerrE1                               equ 276
IDerrE2                               equ 277
ID_err_text                           equ 278
IDerr_retry                           equ 279
IDerr_cancel                          equ 280
IDerr_2text                           equ 281
IDerr_3text                           equ 282
IDio_error_titel                      equ 283
IDtext_font_not_loaded2               equ 284
ID_text_souce_file_aktiv1             equ 285
IDtext_souce_file_aktiv2              equ 286
ID_text1_module_dir_error             equ 287
IDtext2_module_dir_error              equ 288
IDtext3_module_dir_error              equ 289
ID_text1_temp_dir_error               equ 290
ID_error_preco_other_txt              equ 291
ID_error_ass_other_txt                equ 292
ID_error_lnk_other_txt                equ 293
ID_preco_other_txt                    equ 294
ID_ass_other_txt                      equ 295
ID_lnk_other_txt                      equ 296
IDCompileGadText                      equ 297
ID_SetupWinTitle                      equ 298
ID_SOptWinTitle                       equ 299
ID_ScreenTitle                        equ 300
ID_MainWinTitle                       equ 301
ID_MsgWinTitle                        equ 302
ID_InputWinTitle                      equ 303


count_txt                             equ 303
