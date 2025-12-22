OPT MODULE
OPT EXPORT

CONST PNGFILESIG1 = $89504E47,
      PNGFILESIG2 = $0D0A1A0A

-> chunks are not guarantied to have any alignment !!
OBJECT pchunk
   length:LONG -> of data
   type:LONG
   data[0]:ARRAY OF CHAR  -> any number of bytes data.
ENDOBJECT /* SIZEOF = undefined */
-> crc:LONG -> crc of type and data, always follows all chunks !


-> IHDR chunk

OBJECT ihdr
   width:LONG
   height:LONG
   bitdepth:CHAR  -> per sample (8)!
   colortype:CHAR -> 2: color used (rgb).
   cmprmeth:CHAR  -> 0
   filtmeth:CHAR  -> 0
   ilacemeth:CHAR -> 0 (no ilace)
ENDOBJECT

-> IDAT chunk

/* scanlines..
   each scanline is prepended by a zero "filterbyte".
   no alignment required.
*/

-> IEND chunk

/* chunk contains no data. */

