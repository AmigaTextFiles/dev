/* $Id: extensions.h 18593 2003-07-13 13:07:39Z chodorowski $ */
OPT NATIVE
MODULE 'target/intuition/intuition'
MODULE 'target/utility/tagitem'
{#include <intuition/extensions.h>}
NATIVE {INTUITION_EXTENSIONS_H} CONST

/*** Sysiclass **************************************************************/
/*= SYSIA_Which ============================================================*/
NATIVE {ICONIFYIMAGE}             CONST ICONIFYIMAGE             = ($12)
NATIVE {LOCKIMAGE}                CONST LOCKIMAGE                = ($13)
NATIVE {MUIIMAGE}                 CONST MUIIMAGE                 = ($14)
NATIVE {POPUPIMAGE}               CONST POPUPIMAGE               = ($15)
NATIVE {SNAPSHOTIMAGE}            CONST SNAPSHOTIMAGE            = ($16)
NATIVE {JUMPIMAGE}                CONST JUMPIMAGE                = ($17)
NATIVE {MENUTOGGLEIMAGE}          CONST MENUTOGGLEIMAGE          = ($19)
NATIVE {SUBMENUIMAGE}             CONST SUBMENUIMAGE             = ($1A)

/*** Window attributes ******************************************************/

NATIVE {WA_ExtraTitlebarGadgets}                 CONST WA_EXTRATITLEBARGADGETS                 = (WA_DUMMY + 151)
NATIVE {WA_ExtraGadgetsStartID}                  CONST WA_EXTRAGADGETSSTARTID                  = (WA_DUMMY + 152)
NATIVE {WA_ExtraGadget_Iconify}                  CONST WA_EXTRAGADGET_ICONIFY                  = (WA_DUMMY + 153)
NATIVE {WA_ExtraGadget_Lock}                     CONST WA_EXTRAGADGET_LOCK                     = (WA_DUMMY + 154)
NATIVE {WA_ExtraGadget_MUI}                      CONST WA_EXTRAGADGET_MUI                      = (WA_DUMMY + 155)
NATIVE {WA_ExtraGadget_PopUp}                    CONST WA_EXTRAGADGET_POPUP                    = (WA_DUMMY + 156)
NATIVE {WA_ExtraGadget_Snapshot}                 CONST WA_EXTRAGADGET_SNAPSHOT                 = (WA_DUMMY + 157)
NATIVE {WA_ExtraGadget_Jump}                     CONST WA_EXTRAGADGET_JUMP                     = (WA_DUMMY + 158)


/*= WA_ExtraTitlebarGadgets ================================================*/
/*- Flags ------------------------------------------------------------------*/
NATIVE {ETG_ICONIFY}              CONST ETG_ICONIFY              = ($01)
NATIVE {ETG_LOCK}                 CONST ETG_LOCK                 = ($02)
NATIVE {ETG_MUI}                  CONST ETG_MUI                  = ($04)
NATIVE {ETG_POPUP}                CONST ETG_POPUP                = ($08)
NATIVE {ETG_SNAPSHOT}             CONST ETG_SNAPSHOT             = ($10)
NATIVE {ETG_JUMP}                 CONST ETG_JUMP                 = ($20)

/*- Gadget ID offsets ------------------------------------------------------*/
NATIVE {ETD_Iconify}              CONST ETD_ICONIFY              = (0)
NATIVE {ETD_Lock}                 CONST ETD_LOCK                 = (1)
NATIVE {ETD_MUI}                  CONST ETD_MUI                  = (2)
NATIVE {ETD_PopUp}                CONST ETD_POPUP                = (3)
NATIVE {ETD_Snapshot}             CONST ETD_SNAPSHOT             = (4)
NATIVE {ETD_Jump}                 CONST ETD_JUMP                 = (5)

/*- Gadget IDs -------------------------------------------------------------*/
NATIVE {ETI_Dummy}                CONST ETI_DUMMY                = ($FFD0)
NATIVE {ETI_Iconify}              CONST ETI_ICONIFY              = (ETI_DUMMY + ETD_ICONIFY)
NATIVE {ETI_Lock}                 CONST ETI_LOCK                 = (ETI_DUMMY + ETD_LOCK)
NATIVE {ETI_MUI}                  CONST ETI_MUI                  = (ETI_DUMMY + ETD_MUI)
NATIVE {ETI_PopUp}                CONST ETI_POPUP                = (ETI_DUMMY + ETD_POPUP)
NATIVE {ETI_Snapshot}             CONST ETI_SNAPSHOT             = (ETI_DUMMY + ETD_SNAPSHOT)
NATIVE {ETI_Jump}                 CONST ETI_JUMP                 = (ETI_DUMMY + ETD_JUMP)



/*** Defines for WindowAction() *********************************************/
/*= Commands ===============================================================*/
NATIVE {WAC_BASE}                 CONST WAC_BASE                 = ($0001)
NATIVE {WAC_HIDEWINDOW}           CONST WAC_HIDEWINDOW           = (WAC_BASE + 0)
NATIVE {WAC_SHOWWINDOW}           CONST WAC_SHOWWINDOW           = (WAC_BASE + 1)
NATIVE {WAC_SENDIDCMPCLOSE}       CONST WAC_SENDIDCMPCLOSE       = (WAC_BASE + 2)
NATIVE {WAC_MOVEWINDOW}           CONST WAC_MOVEWINDOW           = (WAC_BASE + 3)
NATIVE {WAC_SIZEWINDOW}           CONST WAC_SIZEWINDOW           = (WAC_BASE + 4)
NATIVE {WAC_CHANGEWINDOWBOX}      CONST WAC_CHANGEWINDOWBOX      = (WAC_BASE + 5)
NATIVE {WAC_WINDOWTOFRONT}        CONST WAC_WINDOWTOFRONT        = (WAC_BASE + 6)
NATIVE {WAC_WINDOWTOBACK}         CONST WAC_WINDOWTOBACK         = (WAC_BASE + 7)
NATIVE {WAC_ZIPWINDOW}            CONST WAC_ZIPWINDOW            = (WAC_BASE + 8)
NATIVE {WAC_MOVEWINDOWINFRONTOF}  CONST WAC_MOVEWINDOWINFRONTOF  = (WAC_BASE + 9)
NATIVE {WAC_ACTIVATEWINDOW}       CONST WAC_ACTIVATEWINDOW       = (WAC_BASE + 10)

/*= Tags ===================================================================*/
NATIVE {WAT_BASE}                 CONST WAT_BASE                 = (TAG_USER)

/*- WAC_MOVEWINDOW ---------------------------------------------------------*/
NATIVE {WAT_MOVEWINDOWX}          CONST WAT_MOVEWINDOWX          = (WAT_BASE + 1)
NATIVE {WAT_MOVEWINDOWY}          CONST WAT_MOVEWINDOWY          = (WAT_BASE + 2)

/*- WAC_SIZEWINDOW ---------------------------------------------------------*/
NATIVE {WAT_SIZEWINDOWX}          CONST WAT_SIZEWINDOWX          = (WAT_BASE + 3)
NATIVE {WAT_SIZEWINDOWY}          CONST WAT_SIZEWINDOWY          = (WAT_BASE + 4)

/*- WAC_CHANGEWINDOWBOX ----------------------------------------------------*/
NATIVE {WAT_WINDOWBOXLEFT}        CONST WAT_WINDOWBOXLEFT        = (WAT_BASE + 5)
NATIVE {WAT_WINDOWBOXTOP}         CONST WAT_WINDOWBOXTOP         = (WAT_BASE + 6)
NATIVE {WAT_WINDOWBOXWIDTH}       CONST WAT_WINDOWBOXWIDTH       = (WAT_BASE + 7)
NATIVE {WAT_WINDOWBOXHEIGHT}      CONST WAT_WINDOWBOXHEIGHT      = (WAT_BASE + 8)

/*- WAC_MOVEWINDOWINFRONTOF ------------------------------------------------*/
NATIVE {WAT_MOVEWBEHINDWINDOW}    CONST WAT_MOVEWBEHINDWINDOW    = (WAT_BASE + 9)
