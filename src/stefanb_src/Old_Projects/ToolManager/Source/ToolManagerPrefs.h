/*
 * ToolManagerPrefs.h  V2.1
 *
 * preferences file format include file
 *
 * (c) 1990-1993 Stefan Becker
 */

#include <libraries/iffparse.h>

/* ToolManager Preferences File */
#define TMPREFSVERSION 0                     /* current prefs file version */
#define TMPREFSNAME    "ToolManager.prefs"   /* file name */
#define TMPREFSUSE     "ENV:" TMPREFSNAME    /* temporary preferences file */
#define TMPREFSSAVE    "ENVARC:" TMPREFSNAME /* non-volatile prefs file */

/* Exec object entry */
#define ID_TMEX MAKE_ID('T','M','E','X')
struct ExecPrefsObject {
                        ULONG epo_StringBits;
                        ULONG epo_Flags;
                        ULONG epo_Delay;
                        ULONG epo_Stack;
                        UWORD epo_ExecType;
                        WORD  epo_Priority;
                       };
#define EXPO_NAME    (1L << 0)
#define EXPO_COMMAND (1L << 1)
#define EXPO_CURDIR  (1L << 2)
#define EXPO_HOTKEY  (1L << 3)
#define EXPO_OUTPUT  (1L << 4)
#define EXPO_PATH    (1L << 5)
#define EXPO_PSCREEN (1L << 6)
#define EXPOF_ARGS    (1L << 0)
#define EXPOF_TOFRONT (1L << 1)

/* Image object entry */
#define ID_TMIM MAKE_ID('T','M','I','M')
struct ImagePrefsObject {
                         ULONG ipo_StringBits;
                        };
#define IMPO_NAME (1L << 0)
#define IMPO_FILE (1L << 1)

/* Sound object entry */
#define ID_TMSO MAKE_ID('T','M','S','O')
struct SoundPrefsObject {
                         ULONG spo_StringBits;
                        };
#define SOPO_NAME    (1L << 0)
#define SOPO_COMMAND (1L << 1)
#define SOPO_PORT    (1L << 2)

/* Menu object entry */
#define ID_TMMO MAKE_ID('T','M','M','O')
struct MenuPrefsObject {
                        ULONG mpo_StringBits;
                       };
#define MOPO_NAME  (1L << 0)
#define MOPO_EXEC  (1L << 1)
#define MOPO_SOUND (1L << 2)

/* Icon object entry */
#define ID_TMIC MAKE_ID('T','M','I','C')
struct IconPrefsObject {
                        ULONG ipo_StringBits;
                        ULONG ipo_Flags;
                        LONG  ipo_XPos;
                        LONG  ipo_YPos;
                       };
#define ICPO_NAME  (1L << 0)
#define ICPO_EXEC  (1L << 1)
#define ICPO_IMAGE (1L << 2)
#define ICPO_SOUND (1L << 3)
#define ICPOF_SHOWNAME (1L << 0)

/* Dock object entry */
#define ID_TMDO MAKE_ID('T','M','D','O')
struct DockPrefsObject {
                        ULONG           dpo_StringBits;
                        ULONG           dpo_Flags;
                        LONG            dpo_XPos;
                        LONG            dpo_YPos;
                        ULONG           dpo_Columns;
                        struct TextAttr dpo_Font;
                       };
#define DOPO_NAME     (1L << 0)
#define DOPO_HOTKEY   (1L << 1)
#define DOPO_PSCREEN  (1L << 2)
#define DOPO_TITLE    (1L << 3)
#define DOPO_FONTNAME (1L << 4)
#define DOPOF_ACTIVATED (1L << 0)
#define DOPOF_CENTERED  (1L << 1)
#define DOPOF_FRONTMOST (1L << 2)
#define DOPOF_MENU      (1L << 3)
#define DOPOF_PATTERN   (1L << 4)
#define DOPOF_POPUP     (1L << 5)
#define DOPOF_TEXT      (1L << 6)
#define DOPOF_VERTICAL  (1L << 7)
#define DOPOF_BACKDROP  (1L << 8)
#define DOPOF_STICKY    (1L << 9)
#define DOPOT_EXEC     (1L << 0)
#define DOPOT_IMAGE    (1L << 1)
#define DOPOT_SOUND    (1L << 2)
#define DOPOT_CONTINUE (1L << 7)

/* Access object entry */
#define ID_TMAC MAKE_ID('T','M','A','C')
struct AccessPrefsObject {
                          ULONG apo_StringBits;
                         };
#define AOPO_NAME (1L << 0)
#define AOPOE_EXEC     (1L << 0)
#define AOPOE_CONTINUE (1L << 7)
