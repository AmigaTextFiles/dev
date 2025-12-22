;
; ** $VER: types.h 40.1 (10.8.93)
; ** Includes Release 40.15
; **
; ** Data typing.  Must be included before any other Amiga include.
; **
; ** (C) Copyright 1985-1993 Commodore-Amiga, Inc.
; **     All Rights Reserved
;


#IncludeFile_VERSION = 40 ;  Version of the include files in use. (Do not
;          use this label for OpenLibrary() calls!)


;#GLOBAL = extern     ;  the declaratory use of an external
;#IMPORT = extern     ;  reference to an external
;#STATIC = static     ;  a local static variable
;#REGISTER = register   ;  a (hopefully) register variable


;#VOID  = void


;   WARNING: APTR was redefined for the V36 Includes!  APTR is a
;   32-Bit Absolute Memory Pointer.  C pointer math will not
;   operate on APTR -- use "ULONG *" instead.
;typedef void        *APTR     ;  32-bit untyped pointer
;typedef LONG.l     ;  signed 32-bit quantity
;typedef .ltypedef .l     ;  unsigned 32-bit quantity
;typedef unsigned LONGBITS.l   ;  32 bits manipulated individually
;typedef .wtypedef .w     ;  signed 16-bit quantity
;typedef .wtypedef .w     ;  unsigned 16-bit quantity
;typedef .wtypedef .w   ;  16 bits manipulated individually
;#If __STDC__
;typedef .btypedef .b     ;  signed 8-bit quantity
;#Else
;typedef .btypedef .b     ;  signed 8-bit quantity
;typedef .btypedef .b     ;  unsigned 8-bit quantity
;typedef .btypedef .b   ;  8 bits manipulated individually
;typedef unsigned RPTR.w     ;  signed relative pointer

;#ifdef __cplusplus
;typedef char        *STRPTR     ;  string pointer (NULL terminated)
;#Else
;typedef unsigned char  *STRPTR     ;  string pointer (NULL terminated)


;  For compatibility only: (don't use in new code)
;typedef SHORT.w     ;  signed 16-bit quantity (use WORD)
;typedef .wtypedef .w     ;  unsigned 16-bit quantity (use UWORD)
;typedef COUNT.w
;typedef unsigned UCOUNT.w
;typedef CPTR.l


;  Types with specific semantics
;typedef float  FLOAT
;typedef double  DOUBLE
;typedef BOOL.w
;typedef unsigned char TEXT

;#True  = 1
;#False  = 0
;#Null  = 0L

;#= .b


;  #define LIBRARY_VERSION is now obsolete.  Please use LIBRARY_MINIMUM
;  or code the specific minimum library version you require.
#LIBRARY_MINIMUM = 33 ;  Lowest version supported by Commodore-Amiga


