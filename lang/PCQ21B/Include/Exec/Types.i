
CONST
 INCLUDE_VERSION = 36; { Version of the include files in use. (Do not
                              use this label for OpenLibrary() calls!) }


  {  WARNING: APTR was redefined for the V36 Includes!  APTR is a   }
  {  32-Bit Absolute Memory Pointer.  C pointer math will not       }
  {  operate on APTR --  use "ULONG *" instead.                     }

Type

  APTR   = Address;       { 32-bit untyped pointer }
  BPTR   = Integer;       { Long word pointer/4 }
  BSTR   = Integer;       { Long word pointer/4 to BCPL string }
  LONG   = Integer;       { signed 32-bit quantity }
  ULONG  = Integer;       { unsigned 32-bit quantity }
  LONGBITS = Integer;     { 32 bits manipulated individually }



  { WORD   = Short; }  { Ist bei PCQ1.2d schon definiert, wenn Sie mit
                        einer älteren Version arbeiten, entfernen Sie
                        bitte die Klammern. }

  
  
  UWORD    = Short;       { unsigned 16-bit quantity }
  WORDBITS = Short;       { 16 bits manipulated individually }
  UBYTE    = Byte;        { unsigned 8-bit quantity }
  BYTEBITS = Byte;        { 8 bits manipulated individually }
  RPTR     = Short;       { signed relative pointer }
  STRPTR   = String;      { string pointer (NULL terminated) }


{ For compatibility only: (don't use in new code) }

  USHORT = Short;     { unsigned 16-bit quantity (use UWORD) }
  COUNT  = Short;
  UCOUNT = Short;
  CPTR   = Address;

  BOOL   = Short;

 
CONST

  BYTEMASK  = $FF;

  BOOLTRUE  =  1;
  BOOLFALSE =  0;

 { #define LIBRARY_VERSION is now obsolete.  Please use LIBRARY_MINIMUM }
 { or code the specific minimum library version you require.            }

 LIBRARY_MINIMUM = 33; { Lowest version supported by Commodore-Amiga }


