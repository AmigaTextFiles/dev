{  superview/superview.i            }
{  Version    : 7.1                 }
{  Date       : 16.07.1994          }
{  Written by : Andreas R. Kleinert }
{  PCQ - Konvertierung by Andreas Neumann }


{  *************************************************** }
{  *                                                 * }
{  * Version Defines                                 * }
{  *                                                 * }
{  *************************************************** }

CONST
    SVLIB_VERSION   =   7;


{  *************************************************** }
{  *                                                 * }
{  * Includes                                        * }
{  *                                                 * }
{  *************************************************** }

{ PCQ : für OS_VER }
{$I "Include:exec/Execbase.i"}

{$I "Include:libraries/dos.i" }

{$I "Include:Utils/Stringlib.i" }

{$I "Include:sv/SuperView/SVInfo.i" }


{  *************************************************** }
{  *                                                 * }
{  * Custom Defines                                  * }
{  *                                                 * }
{  *************************************************** }


CONST
    N   =   NIL;


{  *************************************************** }
{  *                                                 * }
{  * MACROs for Version-Tests                        * }
{  *                                                 * }
{  *************************************************** }


FUNCTION LibVer (x : LibraryPtr) : Short;

BEGIN
 LibVer:=x^.lib_version;
END;

FUNCTION OS_VER : Short;

VAR EBase   :   ExecBasePtr;

FUNCTION GetEBase : Address;

BEGIN
{$A
        move.l  $4,d0
}
END;

BEGIN
 EBase:=GetEBase;
 IF EBase<>NIL THEN
  OS_VER:=LibVer (Adr(EBase^.LibNode));
END;


{  *************************************************** }
{  *                                                 * }
{  * DEFINES                                         * }
{  *                                                 * }
{  *************************************************** }


{  Possible FileTypes }

CONST
    SV_FILETYPE_NONE    :   INTEGER = 0;
    SV_FILETYPE_UNKNOWN :   INTEGER = SV_FILETYPE_NONE;
    SV_FILETYPE_ILLEGAL :   INTEGER = $FFFFFFFF;

    SV_FILETYPE_ILBM    :   INTEGER =   1;      { IFF-ILBM, any derivat }
    SV_FILETYPE_ACBM    :   INTEGER =   2;      { IFF-ACBM, any derivat }
    SV_FILETYPE_DATATYPE :  INTEGER =   3;      { V39-Datatype-Object   }

    {
        up to here  : Constant codes for IFF-ILBM, IFF-ACBM and DataTypes
                      (constant for compatibility reasons).
        above these : External, user defined FileSubTypes
                      (defined EACH TIME NEW at Library's startup-time).
    }


{  Possible SubTypes of FileTypes }

    SV_SUBTYPE_NONE     :   INTEGER =   0;
    SV_SUBTYPE_UNKNOWN  :   INTEGER =   SV_SUBTYPE_NONE;
    SV_SUBTYPE_ILLEGAL  :   INTEGER =   $FFFFFFFF;

    SV_SUBTYPE_ILBM     :   INTEGER =   1;      { Is IFF-ILBM              }
    SV_SUBTYPE_ILBM_01  :   INTEGER =   2;      { Is IFF-ILBM, CmpByteRun1 }
    SV_SUBTYPE_ACBM     :   INTEGER =   3;      { Is IFF-ACBM              }
    SV_SUBTYPE_DATATYPE :   INTEGER =   4;      { Is V39-DataType-Object   }

    {
        up to here  : Constant codes for IFF-ILBM, IFF-ACBM and DataTypes
                      (constant for compatibility reasons).
        above these : External, user defined FileSubTypes
                      (defined EACH TIME NEW at Library's startup-time).
    }


{ Possible Input and Output mediums }

    AKO_MEDIUM_NONE     :   INTEGER =   0;          { means : DEFAULT       }
    AKO_MEDIUM_ILLEGAL  :   INTEGER =   $FFFFFFFF;

    AKO_MEDIUM_DISK     :   INTEGER =   1;          { Read and Write media  }
    AKO_MEDIUM_CLIP     :   INTEGER =   2;

    { not any medium might be supported by any SVObject }


{  *************************************************** }
{  *                                                 * }
{  * Function Error Codes                            * }
{  *                                                 * }
{  *************************************************** }

    SVERR_MAX_ERROR_TEXT_LENGTH :   INTEGER =   80;     { plus Null-Byte }

    SVERR_NO_ERROR              :   INTEGER =   0;
    SVERR_INTERNAL_ERROR        :   INTEGER =   $FFFFFFFF;

    SVERR_UNKNOWN_FILE_FORMAT   :   INTEGER =   1;
    SVERR_FILE_NOT_FOUND        :   INTEGER =   2;
    SVERR_NO_MEMORY             :   INTEGER =   3;
    SVERR_IFFPARSE_ERROR        :   INTEGER =   4;
    SVERR_NO_CLIPBOARD          :   INTEGER =   5;
    SVERR_NO_SCREEN             :   INTEGER =   6;
    SVERR_NO_FILE               :   INTEGER =   7;
    SVERR_NO_HANDLE             :   INTEGER =   8;
    SVERR_NO_DATA               :   INTEGER =   9;
    SVERR_GOT_NO_WINDOW         :   INTEGER =   10;
    SVERR_GOT_NO_SCREEN         :   INTEGER =   11;
    SVERR_NO_INFORMATION        :   INTEGER =   12;
    SVERR_ILLEGAL_ACCESS        :   INTEGER =   13;
    SVERR_DECODE_ERROR          :   INTEGER =   14;
    SVERR_UNKNOWN_PARAMETERS    :   INTEGER =   15;
    SVERR_ACTION_NOT_SUPPORTED  :   INTEGER =   16;
    SVERR_VERSION_CONFLICT      :   INTEGER =   17;
    SVERR_NO_DRIVER_AVAILABLE   :   INTEGER =   18;

        {  Each new Library-Subversion may contain new Codes above
           the last one of these.
           So do not interpret the codes directly, but use
           SVL_GetErrorString().
           Maybe, newer Codes will not be listed up here.
        }

TYPE
    SV_GfxBuffer    =   RECORD
 {  All pointers (e.g. svgfx_Buffer) have to be and are AllocVec()'ed.

    If you did not allocate SV_GfxBuffers by yourself, you must
    neither free them nor do write-accesses to them.

    If you allocated them by yourself, you also have to free them
    by yourself - if no one else is still accessing them.
 }

        svgfx_Version   :   INTEGER;        { structure version, see below  }

        svgfx_BufferType :  INTEGER;        { Data organization, see below  }

        svgfx_Width     :   INTEGER;        { Graphic's Width               }
        svgfx_Height    :   INTEGER;        { Graphic's Height              }
        svgfx_ColorDepth :  INTEGER;        { Graphic's ColorDepth          }
        svgfx_ViewMode32 :  INTEGER;        { if NULL, best ScreenMode is
                                              suggested
                                              (results in LowRes, if not
                                              changed).                     }

        svgfx_Colors    :   ARRAY [1..256] OF ARRAY [1..3] OF BYTE; { For ColorDepth <= 8 : 3-Byte RGB entries  }

{
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
begin of "case-dependent" entries
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

    ONLY if svgfx_BufferType == SVGFX_BUFFERTYPE_BITPLANE, else NULL.

    svgfx_BytesPerLine :

       size of one row
       of a plane in Bytes
     = Bytes per Row            : (( [width] +7)>>3)
       Number of Rows per Plane : [height]
       Number of Planes         : [depth]

 }

    svgfx_BytesPerLine  :   INTEGER; { see above }
    svgfx_PixelBits     :   INTEGER; { see below }

{
    ONLY if svgfx_BufferType == SVGFX_BUFFERTYPE_ONEPLANE, else NULL.

    svgfx_PixelBits    :

       Bits Per Pixel
       (8, 16, 24, ...)
    => Bytes per Row            : (svgfx_PixelBits>>3) * [width]
       Number of Rows per Plane : [height]
       Number of Planes         : ONE

<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
end of "case-dependent" entries
<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
 }


    svgfx_Buffer    :   ADDRESS; { any kind of memory (no chip ram needed)  }
    svgfx_BufferSize :  INTEGER; { if you want to copy it ...               }


 { size of structure may grow in future versions : Check svgfx_Version ! }

                        END;
   SV_GfxBufferPtr = ^SV_GfxBuffer;


CONST
    SVGFX_VERSION   =   1;

    SVGFX_BUFFERTYPE_BITPLANE   =   1;  { Amiga-like BitPlanes          }
    SVGFX_BUFFERTYPE_ONEPLANE   =   2;  { single Byte-/Word-/24 Bit-Plane }

{  there may be more types in the future }
{  (at least reject all types > 2)       }


{
   Some words about interpreting and using SV_GfxBuffer structures
   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

   SVGFX_BUFFERTYPE_BITPLANE
   =========================

   SVGFX_BUFFERTYPE_BITPLANE means, that there's plane stored after plane,
   but _no padding_ of the lines is done (e.g. to word- or longword-
   boundaries), which is different from Amiga-BPs or ACBM-ABITs :

         | line 1 of plane 1              | (each with svgfx_BytesPerLine)
         | ...                            |
         | line [height] of plane 1       |

               ...

         | line 1 of plane []             |
         | ...                            |
         | line [height] of plane []      |

               ...

         | line 1 of plane [depth]        |
         | ...                            |
         | line [height] of plane [depth] |


   SVGFX_BUFFERTYPE_BITPLANE is only used upto 256 Colors at the time :
   16 and 24 Bit data will usually not be stored this way.


   SVGFX_BUFFERTYPE_ONEPLANE
   =========================

   SVGFX_BUFFERTYPE_ONEPLANE means, that there's only one single plane stored.
   The size of one pixel in this plane is defined in svgfx_PixelBits
   (currently 8 for ChunkyPixel graphics or 24 for 24 Bit graphics).

         | line 1 with ([PixelBits] / 8) * [width] Bytes        |
         | ...                                                  |
         | line [height] with ([PixelBits] / 8) * [width] Bytes |


   8 Bit  : Chunky Pixel (ColorMap) = 8       ; ColorRegister index
   16 Bit : R:G:B                   = 5:5:5:1 ; + 1 Bit Alpha Channel : IGNORED
   24 Bit : R:G:B                   = 8:8:8   ; RGB-value


   So   8 Bit Data contains [height]   bytes in a row,
       16 Bit Data contains [height]*2 bytes in a row
   and 24 Bit Data contains [height]*3 bytes in a row.

   Currently you will not find any SV_GfxBuffers with 16 Bit data,
   but this may change in the future.


   Differences, which perhaps are not obviously
   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

   In SV_GfxBuffer structures there are two "case-dependent" entries
   (see structure definition of SV_GfxBuffer) :

   BITPLANE :   svgfx_BytesPerLine = ( [width] +7 )>>3
                svgfx_PixelBits    = 0;                   ** IGNORE IT
                svgfx_ColorDepth   = [number of planes]

   ONEPLANE :   svgfx_BytesPerLine = 0;                   ** IGNORE IT
                svgfx_PixelBits    = 8;                   ** or == 24
                svgfx_ColorDepth   = [used PixelBits]


   svgfx_ColorDepth always describes the _real_ ColorDepth of the graphics,
   which means the stored number of planes for BITPLANE data and the number
   of _actually_ used pixelbits for ONEPLANE data.

   If svgfx_PixelBits is 24, svgfx_ColorDepth will perhaps always be 24, too.
   But if svgfx_PixelBits is 8, it may be anything between 1 and 8.

   The reason is, that e.g. GIF pictures are always stored 8 Bit-wide,
   no matter if they contain 4, 8 or 256 Colors.
   This is just because these 8 Bit are simply a ColorRegister index
   (into the field of RGB-Colors : svgfx_Colors).

   OK, there's no problem in displaying a ONEPLANE-8 graphics on a 256 Color
   Screen, no matter which value svgfx_ColorDepth actually contains.
   But if svgfx_ColorDepth is, let's say, only 4, this will be just a
   waste of memory (and the last 256-16 = 240 colors will be black, anyway).

   So finally we can say, that the data in a ONEPLANE SV_GfxBuffer is just
   stored the same way, as e.g. in ChunkyPixel modes of VGA-like Graphic Cards
   or in the source-buffers for GfxLibs's WritePixelLine8().
   (See "graphics.library"'s AutoDocs for more information on ChunkyPixel
    buffer (PixelLine8) handling under V37/39 with ECS/AGA.)


   Which kind of data-storage is more likely ?
   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   The ways of data-storage only depends the specific SVObjects.

   Some Examples :

   FileType   BufferType     PixelBits    ColorDepth

   GIF        ONEPLANE       8            1..8
   ILBM       BITPLANE       -            1..8
   JPGE       ONEPLANE       8/24         8/24

   ( an : Hier meint der Andi wohl nicht JPGE sondern JPEG.... )

   So any program, which supports GfxBuffers should handle both formats.
   This is not difficult, since superviewsupport.library
   contains functions to convert ONEPLANE buffers into BITPLANE buffers
   and vice versa.
   So you actually only have to support one of the data-storage alternatives.

   (See Example-SourceCodes for more and detailed information !)
}

