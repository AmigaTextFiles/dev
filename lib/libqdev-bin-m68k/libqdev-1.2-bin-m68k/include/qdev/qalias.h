/*
   * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *
 * 'qdev' -  A library that helps in Amiga related software development
 * by Burnt Chip Dominators
 *
 * qalias.h
 *
 * --- LICENSE --------------------------------------------------------
 *
 * 'QALIAS' is   free  software;  you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the  Free  Software  Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * 'QALIAS' is   distributed  in  the  hope  that  it  will  be useful,
 * but  WITHOUT  ANY  WARRANTY;  without  even  the implied warranty of
 * MERCHANTABILITY  or  FITNESS  FOR  A  PARTICULAR  PURPOSE.  See  the
 * GNU General Public License for more details.
 *
 * You  should  have  received a copy of the GNU General Public License
 * along  with  'qdev';  if not, write to the Free Software Foundation,
 * Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301   USA
 *
 * --- VERSION --------------------------------------------------------
 *
 * $VER: qalias.h 1.13 (12/09/2014) QALIAS
 * AUTH: BCD
 *
 * --- COMMENT --------------------------------------------------------
 *
 * Aliases are sorted alphabetically. Alias count: 309 .
 *
   * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
*/

#ifndef ___QALIAS_H_INCLUDED___
#define ___QALIAS_H_INCLUDED___

#define ALtoLONG                  cnv_ALtoLONG
#define ALtoQUAD                  cnv_ALtoQUAD
#define ALtoULONG                 cnv_ALtoULONG
#define ALtoUQUAD                 cnv_ALtoUQUAD
#define AtoLONG                   cnv_AtoLONG
#define AtoQUAD                   cnv_AtoQUAD
#define AtoULONG                  cnv_AtoULONG
#define AtoUQUAD                  cnv_AtoUQUAD
#define LONGtoA                   cnv_LONGtoA
#define QUADtoA                   cnv_QUADtoA
#define ULONGtoA                  cnv_ULONGtoA
#define ULONGtoBITS               cnv_ULONGtoBITS
#define UQUADtoA                  cnv_UQUADtoA
#define UQUADtoBITS               cnv_UQUADtoBITS

#define CreateArgv                crt_createargv
#define DestroyArgv               crt_destroyargv
#define ExitMethod                crt_exitmethod
#define FreeInstance              crt_freeinstance
#define InitMethod                crt_initmethod
#define NewInstance               crt_newinstance

#define AddBarTrigger             ctl_addbartrigger
#define AddConLogo                ctl_addconlogo
#define AddConLogoF               ctl_addconlogof
#define AddIDCMPHandler           ctl_addidcmphandler
#define AddViewCtrl               ctl_addviewctrl
#define CliPath                   ctl_clipath
#define CliRun                    ctl_clirun
#define CloseConScreen            ctl_closeconscreen
#define DevMount                  ctl_devmount
#define DevUnmount                ctl_devunmount
#define DiskReqOff                ctl_diskreqoff
#define DiskReqOn                 ctl_diskreqon
#define DoConSwitch               ctl_doconswitch
#define FindScreenSafe            ctl_findscreensafe
#define GetSmParams               ctl_getsmparams
#define HaltIDCMP                 ctl_haltidcmp
#define LockScreenSafe            ctl_lockscreensafe
#define MakeDir                   ctl_makedir
#define NewShell                  ctl_newshell
#define OpenConScreen             ctl_openconscreen
#define PokeBarTrigger            ctl_pokebartrigger
#define RearrangeCon              ctl_rearrangecon
#define Relabel                   ctl_relabel
#define RelocDriMap               ctl_relocdrimap
#define RemBarTrigger             ctl_rembartrigger
#define RemConLogo                ctl_remconlogo
#define RemConLogoF               ctl_remconlogof
#define RemIDCMPHandler           ctl_remidcmphandler
#define RemViewCtrl               ctl_remviewctrl
#define SetCliStack               ctl_setclistack
#define SetConLogoF               ctl_setconlogof
#define SetSmParams               ctl_setsmparams
#define SwapBackPen               ctl_swapbackpen
#define SwapConLogo               ctl_swapconlogo
#define UDirAssign                ctl_udirassign
#define UndoConSwitch             ctl_undoconswitch
#define UnlockScreenSafe          ctl_unlockscreensafe
#define ZoomifyCon                ctl_zoomifycon

#define CloseDiskDev              dev_closediskdev
#define FreeDiskGeo               dev_freediskgeo
#define FreeDiskRDB               dev_freediskrdb
#define GetDiskCmdSet             dev_getdiskcmdset
#define GetDiskGeo                dev_getdiskgeo
#define GetDiskRDB                dev_getdiskrdb
#define OpenDiskDev               dev_opendiskdev
#define SizeInGigs                dev_sizeingigs

#define MountCb                   dmt_mountcb

#define AddFDRelay                dos_addfdrelay
#define AddLinkPoint              dos_addlinkpoint
#define BCheckDevice              dos_bcheckdevice
#define BCopyDevice               dos_bcopydevice
#define CheckDevice               dos_checkdevice
#define CtrlFDRelay               dos_ctrlfdrelay
#define DcLinkPoint               dos_dclinkpoint
#define DevByMsgPort              dos_devbymsgport
#define DoPacket                  dos_dopacket
#define FreeFmFDRelay             dos_freefmfdrelay
#define GetFmFDRelay              dos_getfmfdrelay
#define GetPacket                 dos_getpacket
#define KillDevice                dos_killdevice
#define MakeDevice                dos_makedevice
#define QfAbort                   dos_qfabort
#define QfClose                   dos_qfclose
#define QfIsPending               dos_qfispending
#define QfLink                    dos_qflink
#define QfOpen                    dos_qfopen
#define QfRead                    dos_qfread
#define QfSeek                    dos_qfseek
#define QfSetFctWait              dos_qfsetfctwait
#define QfSetIntSig               dos_qfsetintsig
#define QfSetMode                 dos_qfsetmode
#define QfWait                    dos_qfwait
#define QfWrite                   dos_qfwrite
#define RemFDRelay                dos_remfdrelay
#define RemLinkPoint              dos_remlinkpoint
#define ReplyPacket               dos_replypacket
#define SwapMpFDRelay             dos_swapmpfdrelay
#define WaitPacket                dos_waitpacket

#define BinaryIFH                 han_binaryifh
#define RollIFH                   han_rollifh
#define RwIFH                     han_rwifh
#define TermIFH                   han_termifh

#define AccessArray               mem_accessarray
#define AddExHandler              mem_addexhandler
#define AddrFromBase              mem_addrfrombase
#define AddrFromLVO               mem_addrfromlvo
#define AllocArray                mem_allocarray
#define AllocBmapThere            mem_allocbmapthere
#define AllocCluster              mem_alloccluster
#define AllocMemRegion            mem_allocmemregion
#define AllocJumpTable            mem_allocjumptable
#define AllocLFVec                mem_alloclfvec
#define AllocTerm                 mem_allocterm
#define AllocVecPooled            mem_allocvecpooled
#define AttachHotVec              mem_attachhotvec
#define AttachRelHotVec           mem_attachrelhotvec
#define AttachSniffer             mem_attachsniffer
#define CheckLFVec                mem_checklfvec
#define CloseIFH                  mem_closeifh
#define ConvImgToBmap             mem_convimgtobmap
#define Cooperate                 mem_cooperate
#define CopyItnImage              mem_copyitnimage
#define CopySmlCb                 mem_copysmlcb
#define CsumChs32                 mem_csumchs32
#define CsumEor32                 mem_csumeor32
#define CsumInt32                 mem_csumint32
#define DetachHotVec              mem_detachhotvec
#define DetachSniffer             mem_detachsniffer
#define DoSyncTask                mem_dosynctask
#define DoSyncTasks               mem_dosynctasks
#define FillJumpTable             mem_filljumptable
#define FindInFile                mem_findinfile
#define FindInFileQ               mem_findinfileq
#define FixTerm                   mem_fixterm
#define MemFnv128Hash             mem_fnv128hash
#define MemFnv64Hash              mem_fnv64hash
#define FreeArray                 mem_freearray
#define FreeBmapFromImg           mem_freebmapfromimg
#define FreeCluster               mem_freecluster
#define FreeItnImage              mem_freeitnimage
#define FreeJumpTable             mem_freejumptable
#define FreeLFVec                 mem_freelfvec
#define FreeMemCluster            mem_freememcluster
#define FreeMemRegion             mem_freememregion
#define FreePenHolder             mem_freepenholder
#define FreePenTab                mem_freepentab
#define FreePicture               mem_freepicture
#define FreeSmlCb                 mem_freesmlcb
#define FreeSrcImage              mem_freesrcimage
#define FreeTerm                  mem_freeterm
#define FreeTokenList             mem_freetokenlist
#define FreeVecPooled             mem_freevecpooled
#define GetMemCluster             mem_getmemcluster
#define GetWbStartup              mem_getwbstartup
#define GrabQArea                 mem_grabqarea
#define GrowPenHolder             mem_growpenholder
#define ILoadSeg                  mem_iloadseg
#define ILoadSeg2                 mem_iloadseg2
#define ImportJumpTable           mem_importjumptable
#define InitEmptyBmap             mem_initemptybmap
#define LoadPicture               mem_loadpicture
#define LzwCompress               mem_lzwcompress
#define LzwDecompress             mem_lzwdecompress
#define LzwFree                   mem_lzwfree
#define MakeBmapFromImg           mem_makebmapfromimg
#define MakeTokenList             mem_maketokenlist
#define ObtainHotVec              mem_obtainhotvec
#define ObtainRelHotVec           mem_obtainrelhotvec
#define OpenIFH                   mem_openifh
#define MemPjw64Hash              mem_pjw64hash
#define ReadSrcImage              mem_readsrcimage
#define RemapBitmap               mem_remapbitmap
#define RemapBitmap2              mem_remapbitmap2
#define RemExHandler              mem_remexhandler
#define ResolveHotVec             mem_resolvehotvec
#define ScanFile                  mem_scanfile
#define ScanLbl                   mem_scanlbl
#define ScanLblNcc                mem_scanlblncc
#define SetAddrJtSlot             mem_setaddrjtslot
#define SetDataJtSlot             mem_setdatajtslot
#define SetVecPooled              mem_setvecpooled
#define SignalSafe                mem_signalsafe
#define SwapJumpTable             mem_swapjumptable
#define UnILoadSeg                mem_uniloadseg
#define UnILoadSeg2               mem_uniloadseg2

#define AddDiskModule             mod_adddiskmodule
#define AddModule                 mod_addmodule
#define CodeFind                  mod_codefind
#define CodeFree                  mod_codefree
#define CodeReloc                 mod_codereloc
#define DelDiskModule             mod_deldiskmodule
#define DelModule                 mod_delmodule
#define FindKtpResBy              mod_findktpresby
#define GetMemList                mod_getmemlist
#define KickTagLink               mod_kicktaglink
#define KickTagUnlink             mod_kicktagunlink
#define KtpResCount               mod_ktprescount
#define KtpResUnlink              mod_ktpresunlink

#define DevVerCmp                 nfo_devvercmp
#define FindGfxEntry              nfo_findgfxentry
#define FindGfxRange              nfo_findgfxrange
#define FindGfxReso               nfo_findgfxreso
#define FindGfxSm                 nfo_findgfxsm
#define FreeArgSource             nfo_freeargsource
#define FsQuery                   nfo_fsquery
#define FssmValid                 nfo_fssmvalid
#define GetArgSource              nfo_getargsource
#define GetCmColors               nfo_getcmcolors
#define GetConIOReq               nfo_getconioreq
#define GetConUnit                nfo_getconunit
#define GetDriMap                 nfo_getdrimap
#define GetScParams               nfo_getscparams
#define GetSysTime                nfo_getsystime
#define GetVisCount               nfo_getviscount
#define GetVisState               nfo_getvisstate
#define GetWinAddr                nfo_getwinaddr
#define GrepMl                    nfo_grepml
#define IDCMPToIndex              nfo_idcmptoindex
#define IsBlitable                nfo_isblitable
#define IsChildOfProc             nfo_ischildofproc
#define IsConsole                 nfo_isconsole
#define IsDev64Bit                nfo_isdev64bit
#define IsDirectory               nfo_isdirectory
#define IsInStack                 nfo_isinstack
#define IsMode15kHz               nfo_ismode15khz
#define IsOnListOfMl              nfo_isonlistofml
#define IsOnMemList               nfo_isonmemlist
#define IsPDev64Bit               nfo_ispdev64bit
#define IsPrime                   nfo_isprime
#define IsSegRemote               nfo_issegremote
#define IsTask                    nfo_istask
#define IsWindow                  nfo_iswindow
#define Ktm                       nfo_ktm
#define LibVerCmp                 nfo_libvercmp
#define M68kCpuType               nfo_m68kcputype
#define ModeIdCount               nfo_modeidcount
#define NearestPrime              nfo_nearestprime
#define NumDivisors               nfo_numdivisors
#define ScanList                  nfo_scanlist
#define ScanTurbo                 nfo_scanturbo
#define ScanMl                    nfo_scanml
#define ScreenCount               nfo_screencount
#define StackReport               nfo_stackreport
#define StackValid                nfo_stackvalid
#define TypeOfGfxMem              nfo_typeofgfxmem
#define WaitBack                  nfo_waitback
#define WhichChipSet              nfo_whichchipset

#define BStrNCat                  txt_bstrncat
#define BStrNCatLC                txt_bstrncatlc
#define BStrNCatUC                txt_bstrncatuc
#define BStrNpCat                 txt_bstrnpcat
#define BStrNpCatLC               txt_bstrnpcatlc
#define BStrNpCatUC               txt_bstrnpcatuc
#define DatDat                    txt_datdat
#define DatIDat                   txt_datidat
#define DebugPrintF               txt_debugprintf
#define FixQuotes                 txt_fixquotes
#define Fnv128Hash                txt_fnv128hash
#define Fnv128IHash               txt_fnv128ihash
#define Fnv64Hash                 txt_fnv64hash
#define Fnv64IHash                txt_fnv64ihash
#define IniParse                  txt_iniparse
#define MemCmp                    txt_memcmp
#define MemFill                   txt_memfill
#define MemICmp                   txt_memicmp
#define NeedSlash                 txt_needslash
#define NoANSI                    txt_noansi
#define NoComment                 txt_nocomment
#define ParseLine                 txt_parseline
#define Pjw64Hash                 txt_pjw64hash
#define Pjw64IHash                txt_pjw64ihash
#define PsnPrintF                 txt_psnprintf
#define PStrBoth                  txt_pstrboth
#define PStrCmp                   txt_pstrcmp
#define PStrIBoth                 txt_pstriboth
#define PStrICmp                  txt_pstricmp
#define PStrIPat                  txt_pstripat
#define PStrIStr                  txt_pstristr
#define PStrPat                   txt_pstrpat
#define PStrStr                   txt_pstrstr
#define QuickHash                 txt_quickhash
#define QuickIHash                txt_quickihash
#define SkipCC                    txt_skipcc
#define StrBoth                   txt_strboth
#define StrChr                    txt_strchr
#define StrCmp                    txt_strcmp
#define StrCSpn                   txt_strcspn
#define StrIBoth                  txt_striboth
#define StrIChr                   txt_strichr
#define StrICmp                   txt_stricmp
#define StripANSI                 txt_stripansi
#define StrIPat                   txt_stripat
#define StrIStr                   txt_stristr
#define StrLen                    txt_strlen
#define StrNCat                   txt_strncat
#define StrNCatLC                 txt_strncatlc
#define StrNCatUC                 txt_strncatuc
#define StrNpCat                  txt_strnpcat
#define StrNpCatLC                txt_strnpcatlc
#define StrNpCatUC                txt_strnpcatuc
#define StrNVaCat                 txt_strnvacat
#define StrPat                    txt_strpat
#define StrSpn                    txt_strspn
#define StrStr                    txt_strstr
#define StrTok                    txt_strtok
#define Tokenify                  txt_tokenify
#define VCbPsnPrintF              txt_vcbpsnprintf
#define VDebugPrintF              txt_vdebugprintf
#define VPsnPrintF                txt_vpsnprintf

#endif /* ___QALIAS_H_INCLUDED___ */
