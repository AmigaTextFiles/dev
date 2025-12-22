#ifndef WPAD_LIBPROTOS_H
#define WPAD_LIBPROTOS_H 1

/***************************************************************************
 * wpad_libprotos.h
 *
 * wpad.library, Copyright ©1995 Lee Kindness.
 *
 * 
 */

/* private functions */

BOOL WPP_Init( VOID );
VOID WPP_Exit( VOID );
VOID LIBENT WPP_Entry( VOID );
VOID __regargs WPP_HandleGetAttrs( struct Pad *pad, struct TagItem *tags );
VOID __regargs WPP_Handler( struct Pad *pad );
BOOL __regargs WPP_HandleSetAttrs( struct Pad *pad, struct TagItem *tags );
VOID __regargs WPP_AddHotKeys( struct Pad *pad );
VOID __regargs WPP_FreeHotKeys( struct Pad *pad );
VOID __regargs WPP_OpenWindow( struct Pad *pad );
VOID __regargs WPP_CloseWindow( struct Pad *pad );
ULONG __regargs WPP_GetSigMask( struct Pad *pad, ULONG *pmpsig, ULONG *cxsig,
                                ULONG *winsig );
VOID __regargs WPP_AllocPIHandles( struct Pad *pad );
VOID __regargs WPP_FreePIHandles( struct Pad *pad );

#endif
