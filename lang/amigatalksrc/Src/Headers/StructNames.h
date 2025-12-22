/****h* AmigaTalk/StructNames.h [2.0] *********************************
*
* NAME 
*   StructNames.c
*
* DESCRIPTION
*   A bunch of #defines for all structures & an index number for
*   each of them.  This file is only used by GrabMem.c
*
* HISTORY
*   19-Feb-2002 - Created this file.
*
* NOTES
*   $VER: AmigaTalk:Src/StructNames.h 2.0 (19-Feb-2002) by J.T. Steichen
***********************************************************************
*
*/

#ifndef  STRUCTNAMES_H
# define STRUCTNAMES_H 1

// cybergraphics/cybergraphics.h
# define STRUCT_CyberModeNode           0
# define STRUCT_CDrawMsg                1

// datatypes/animationclass.h
# define STRUCT_AnimHeader              2
# define STRUCT_adtFrame                3
# define STRUCT_adtStart                4

// datatypes/datatypes.h
# define STRUCT_DataTypeHeader          5
# define STRUCT_DTHookContext           6
# define STRUCT_Tool                    7 
# define STRUCT_DataType                8
# define STRUCT_ToolNode                9

// datatypes/datatypesclass.h
# define STRUCT_DTSpecialInfo           10
# define STRUCT_DTMethod                11
# define STRUCT_FrameInfo               12
# define STRUCT_dtGeneral               13
# define STRUCT_dtSelect                14
# define STRUCT_dtFrameBox              15
# define STRUCT_dtGoto                  16
# define STRUCT_dtTrigger               17
# define UNION_printerIO                18
# define STRUCT_dtPrint                 19
# define STRUCT_dtDraw                  20
# define STRUCT_dtWrite                 21

// datatypes/pictureclass.h
# define STRUCT_BitMapHeader            22
# define STRUCT_ColorRegister           23

// datatypes/pictureclassext.h        
# define STRUCT_gpBlitPixelArray        24

// datatypes/soundclass.h
# define STRUCT_VoiceHeader             25

// datatypes/textclass.h
# define STRUCT_Line                    26

// devices/audio.h
# define STRUCT_IOAudio                 27

// devices/bootblock.h
# define STRUCT_BootBlock               28

// devices/cd.h
# define STRUCT_CDInfo                  29 
# define STRUCT_RMSF                    30 // Rocky Mountain System Format.   
# define UNION_LSNMSF                   31
# define STRUCT_CDXL                    32
# define STRUCT_TOCSummary              33
# define STRUCT_TOCEntry                34
# define UNION_CDTOC                    35
# define STRUCT_QCode                   36

// devices/clipboard.h
# define STRUCT_ClipboardUnitPartial    37
# define STRUCT_IOClipReq               38
# define STRUCT_SatisfyMsg              39

// devices/conunit.h
# define STRUCT_ConUnit                 40

// devices/gameport.h
# define STRUCT_GamePortTrigger         41

// devices/hardblocks.h
# define STRUCT_RigidDiskBlock          42 
# define STRUCT_BadBlockEntry           43
# define STRUCT_BadBlockBlock           44
# define STRUCT_PartitionBlock          45
# define STRUCT_FileSysHeaderBlock      46
# define STRUCT_LoadSegBlock            47

// devices/inputevent.h
# define STRUCT_IEPointerPixel          48
# define STRUCT_IEPointerTablet	        49
# define STRUCT_IENewTablet             50
# define STRUCT_InputEvent              51

// devices/keymap.h
# define STRUCT_KeyMap                  52
# define STRUCT_KeyMapNode              53
# define STRUCT_KeyMapResource          54

// devices/narrator.h
# define STRUCT_narrator_rb             55
# define STRUCT_mouth_rb                56

// devices/parallel.h
# define STRUCT_IOPArray                57
# define STRUCT_IOExtPar                58

// devices/printer.h
# define STRUCT_IOPrtCmdReq             59
# define STRUCT_IODRPReq                60

// devices/prtbase.h
# define STRUCT_DeviceData              61
# define STRUCT_PrinterData             62
# define STRUCT_PrinterExtendedData     63
# define STRUCT_PrinterSegment          64

// devices/scsidisk.h
# define STRUCT_SCSICmd                 65

// devices/timer.h
# define STRUCT_timeval                 66
# define STRUCT_timerequest             67

// devices/trackdisk.h
# define STRUCT_IOExtTD                 68
# define STRUCT_TDU_PublicUnit          69

// exec/devices.h
# define STRUCT_Device                  70
# define STRUCT_Unit                    71

// exec/execbase.h
# define STRUCT_ExecBase                72

// exec/interrupts.h
# define STRUCT_Interrupt               73 // Software interrupt list.
# define STRUCT_IntVector               74 // For EXEC use ONLY!
# define STRUCT_SoftIntList             75 // For EXEC use ONLY!

// exec/io.h
# define STRUCT_IORequest               76 
# define STRUCT_IOStdReq                77

// exec/libraries.h
# define STRUCT_Library                 78

// exec/lists.h
# define STRUCT_List                    79
# define STRUCT_MinList                 80

// exec/memory.h
# define STRUCT_MemChunk                81
# define STRUCT_MemHeader               82
# define STRUCT_MemEntry                83
# define STRUCT_MemList                 84

// exec/nodes.h
# define STRUCT_Node                    85 
# define STRUCT_MinNode                 86

// exec/ports.h
# define STRUCT_MsgPort                 87
# define STRUCT_Message                 88

// exec/resident.h
# define STRUCT_Resident                89 // Similar to STRUCT_Library. 

// exec/semaphores.h
# define STRUCT_Semaphore               90
# define STRUCT_SemaphoreRequest        91
# define STRUCT_SignalSemaphore         92

// gadgets/colorwheel.h
# define STRUCT_ColorWheelHSB           93
# define STRUCT_ColorWheelRGB           94

// graphics/clip.h
# define STRUCT_Layer                   95
# define STRUCT_ClipRect                96

// graphics/copper.h
# define STRUCT_CopIns                  97
# define STRUCT_cprlist                 98
# define STRUCT_CopList                 99
# define STRUCT_UCopList                100
# define STRUCT_copinit                 101

// graphics/displayinfo.h
# define STRUCT_QueryHeader             102
# define STRUCT_DisplayInfo             103
# define STRUCT_DimensionInfo           104
# define STRUCT_MonitorInfo             105
# define STRUCT_NameInfo                106
# define STRUCT_VecInfo                 107

// graphics/gels.h
# define STRUCT_VSprite                 108
# define STRUCT_AnimComp                109
# define STRUCT_AnimOb                  110 
# define STRUCT_Bob                     111
# define STRUCT_DBufPacket              112
# define STRUCT_collTable               113

// graphics/gfx.h
# define STRUCT_Rectangle               114
# define STRUCT_Rect32                  115
# define STRUCT_Point                   116 // typedef struct tPoint
# define STRUCT_BitMap                  117

// graphics/gfxbase.h
# define STRUCT_GfxBase                 118

// graphics/gfxnodes.h
# define STRUCT_ExtendedNode            119

// graphics/graphint.h
# define STRUCT_Isrvstr                 120

// graphics/layers.h
# define STRUCT_Layer_Info              121

// graphics/monitor.h
# define STRUCT_MonitorSpec             122
# define STRUCT_AnalogSignalInterval    123
# define STRUCT_SpecialMonitor          124

// graphics/rastport.h
# define STRUCT_AreaInfo                125
# define STRUCT_TmpRas                  126
# define STRUCT_GelsInfo                127
# define STRUCT_RastPort                128

// graphics/regions.h
# define STRUCT_RegionRectangle         129
# define STRUCT_Region                  130

// graphics/scale.h
# define STRUCT_BitScaleArgs            131

// graphics/sprite.h
# define STRUCT_SimpleSprite            132
# define STRUCT_ExtSprite               133

// graphics/text.h
# define STRUCT_TextAttr                134
# define STRUCT_TTextAttr               135
# define STRUCT_TextFont                136
# define STRUCT_TextFontExtension	137 // this structure is read-only
# define STRUCT_ColorFontColors         138
# define STRUCT_ColorTextFont           139
# define STRUCT_TextExtent              140

// graphics/view.h
# define STRUCT_ColorMap                141 
# define STRUCT_ViewPort                142
# define STRUCT_View                    143
# define STRUCT_RasInfo                 144 // used by callers to and InitDspC()
# define STRUCT_ViewExtra               145
# define STRUCT_ViewPortExtra           146
# define STRUCT_PaletteExtra            147 // structure may be extended so watch out!
# define STRUCT_DBufInfo                148

// hardware/blit.h
# define STRUCT_bltnode                 149

// hardware/cia.h
# define STRUCT_CIA                     150 

// hardware/custom.h
# define STRUCT_Custom                  151

// hardware/mmu.h
# define STRUCT_mmu                     152

// intuition/cghooks.h
# define STRUCT_GadgetInfo              153
# define STRUCT_PGX                     154

// intuition/classes.h
# define STRUCT_Class                   155 // typedef struct IClass
# define STRUCT__Object                 156

// intuition/classusr.h
# define STRUCT_opSet                   157
# define STRUCT_opUpdate                158
# define STRUCT_opGet                   159
# define STRUCT_opAddTail               160
# define STRUCT_opMember                161

// intuition/gadgetclass.h
# define STRUCT_gpHitTest               162
# define STRUCT_gpRender                163
# define STRUCT_gpInput                 164
# define STRUCT_gpGoInactive            165
# define STRUCT_gpLayout                166

// intuition/imageclass.h
# define STRUCT_impFrameBox             167
# define STRUCT_impDraw                 168
# define STRUCT_impErase                169
# define STRUCT_impHitTest              170

// intuition/intuition.h
# define STRUCT_Menu                    171
# define STRUCT_MenuItem                172
# define STRUCT_Requester               173
# define STRUCT_Gadget                  174
# define STRUCT_ExtGadget               175
# define STRUCT_BoolInfo                176
# define STRUCT_PropInfo                177
# define STRUCT_StringInfo              178
# define STRUCT_IntuiText               179 
# define STRUCT_Border                  180
# define STRUCT_Image                   181 
# define STRUCT_IntuiMessage            182
# define STRUCT_ExtIntuiMessage         183
# define STRUCT_IBox                    184
# define STRUCT_Window                  185
# define STRUCT_NewWindow               186
# define STRUCT_ExtNewWindow            187
# define STRUCT_Remember                188
# define STRUCT_ColorSpec               189
# define STRUCT_EasyStruct              190
# define STRUCT_TabletData              191
# define STRUCT_TabletHookData          192

// intuition/intuitionbase.h
# define STRUCT_IntuitionBase           193

// intuition/preferences.h
# define STRUCT_Preferences             194

// intuition/screens.h
# define STRUCT_DrawInfo                195
# define STRUCT_Screen                  196
# define STRUCT_NewScreen               197
# define STRUCT_ExtNewScreen            198
# define STRUCT_PubScreenNode           199
# define STRUCT_ScreenBuffer            200

// intuition/sghooks.h
# define STRUCT_StringExtend            201
# define STRUCT_SGWork	                202

// libraries/amigaguide.h
# define STRUCT_AmigaGuideMsg           203
# define STRUCT_NewAmigaGuide           204
# define STRUCT_XRef                    205
# define STRUCT_AmigaGuideHost          206
# define STRUCT_opFindHost              207
# define STRUCT_opNodeIO                208
# define STRUCT_opExpungeNode           209

// libraries/asl.h
# define STRUCT_FileRequester           210 
# define STRUCT_FontRequester           211
# define STRUCT_ScreenModeRequester     212
# define STRUCT_DisplayMode             213

// libraries/cd.h is the same as devices/cd.h

// libraries/commodities.h              214
# define STRUCT_NewBroker               215
# define STRUCT_InputXpression          216

// libraries/configregs.h
# define STRUCT_ExpansionRom            217
# define STRUCT_ExpansionControl        218
# define STRUCT_DiagArea                219

// libraries/configvars.h
# define STRUCT_ConfigDev               220
# define STRUCT_CurrentBinding          221

// Other/ico.h
# define STRUCT_IDENTRY;                222 // typedef struct IconDirectoryEntry 
# define STRUCT_ICONHEADER              223 // typedef struct IconDir
# define STRUCT_BITMAPINFOHEADER        224 // typedef struct bitmapInfoHeader
# define STRUCT_BGR_QUEAD               225 // typedef struct bgrQuad
# define STRUCT_ICOIMAGE                226 // typedef struct icoImage
# define STRUCT_GROUPIDENTRY            227 // typedef struct groupIcoDirEntry
# define STRUCT_GROUPICONDIR            228 // typedef struct groupIconDir

// dos/dos.h
# define STRUCT_DateStamp               229
# define STRUCT_FileInfoBlock           230
# define STRUCT_InfoData                231

// dos/dosextens.h
# define STRUCT_Process                 232
# define STRUCT_FileHandle              233
# define STRUCT_DosPacket               234
# define STRUCT_StandardPacket          235
# define STRUCT_DosLibrary              236
# define STRUCT_RootNode                237 
# define STRUCT_DosInfo                 238
# define STRUCT_CommandLineInterface    239
# define STRUCT_DeviceList              240
# define STRUCT_FileLock                241
# define STRUCT_DevInfo                 242

// libraries/diskfont.h
# define STRUCT_FontContents            243 
# define STRUCT_FontContentsHeader      244
# define STRUCT_DiskFontHeader          245
# define STRUCT_AvailFonts              246
# define STRUCT_AvailFontsHeader        247

// libraries/expansionbase.h
# define STRUCT_BootNode                248
# define STRUCT_ExpansionBase           249

// libraries/filehandler.h
# define STRUCT_FileSysStartupMsg       250
# define STRUCT_DeviceNode              251

// libraries/gadtools.h
# define STRUCT_NewGadget               252
# define STRUCT_NewMenu                 253
# define STRUCT_LVDrawMsg               254

// libraries/iffparse.h
# define STRUCT_IFFHandle               255
# define STRUCT_IFFStreamCmd            256
# define STRUCT_ContextNode             257
# define STRUCT_LocalContextItem        258
# define STRUCT_StoredProperty          259
# define STRUCT_CollectionItem          260
# define STRUCT_ClipboardHandle         261

// libraries/locale.h
# define STRUCT_LocaleBase              262
# define STRUCT_Locale                  263
# define STRUCT_Catalog                 264

// libraries/lowlevel.h
# define STRUCT_KeyQuery                265

// libraries/nonvolatile.h
# define STRUCT_NVInfo                  266
# define STRUCT_NVEntry                 267

// libraries/realtime.h
# define STRUCT_Conductor               268
# define STRUCT_Player                  269 
# define STRUCT_pmTime                  270
# define STRUCT_pmState                 271
# define STRUCT_RealTimeBase            272

// newicons/newicon.h
# define STRUCT_NewIconBase             273
# define STRUCT_ChunkyImage             274
# define STRUCT_NewDiskObject           275
# define STRUCT_NewIconsPrefs           276

// resources/disk.h
# define STRUCT_DiscResourceUnit        277
# define STRUCT_DiscResource            278

// resources/misc.h
# define STRUCT_MiscResource            279

// rexx/rexxio.h
# define STRUCT_IoBuff                  280
# define STRUCT_RexxMsgPort             281

// rexx/rxslib.h
# define STRUCT_RxsLib                  282

// rexx/storage.h
# define STRUCT_NexxStr                 283
# define STRUCT_RexxArg                 284
# define STRUCT_RexxMsg                 285
# define STRUCT_RexxRsrc                286
# define STRUCT_RexxTask                287 
# define STRUCT_SrcNode                 288

// utility/date.h
# define STRUCT ClockData               308

// utility/hooks.h
# define STRUCT_Hook                    307

// utility/name.h
# define STRUCT_NamedObject             309

// utility/tagitem.h
# define STRUCT TagItem                 310

// utility/utility.h
# define STRUCT_UtilityBase             311

// workbench/startup.h
# define STRUCT_WBStartup               289
# define STRUCT_WBArg                   290
 
// workbench/workbench.h
# define STRUCT_DrawerData              291
# define STRUCT_DiskObject              292  
# define STRUCT_FreeList                293
# define STRUCT_AppMessage              294
# define STRUCT_AppWindow               295 // { void *aw_PRIVATE;  };
# define STRUCT_AppIcon                 296 // { void *ai_PRIVATE;  };
# define STRUCT_AppMenuItem             297 // { void *ami_PRIVATE; };

// dos.h
# define STRUCT_MELT                    298
# define STRUCT_MELT2                   299
# define STRUCT_ProcID                  300 // packet returned from fork()
# define STRUCT_FORKENV                 301 
# define STRUCT_TermMsg                 302 // termination message from child

// ios1.h
# define STRUCT_UFB                     303

// math.h
# define STRUCT_exception               304

// setjmp.h
# define STRUCT_JMP_BUF                 305
 
// stdio.h
# define STRUCT__iobuf                  306

#endif

/* -------------------- END of StructNames.h file! --------------------- */
