 before using it, currently only text is
   supported, but more types can be added in the future.

   Text is stored in plain Amiga ASCII, lines separated by \n characters.
   The last byte is \0.
*/
EXPORT OBJECT mmdinfo
        next:PTR TO mmdinfo     /* next info (currently not supported) */
        reserved:INT            /* 0 */
        type:INT                /* 1 = text, ignore ALL other types */
        length:LONG             /* length of the following data */
/*      UBYTE   data[0]; */     /* Comments may be removed in SAS/C V6 */
ENDOBJECT

/* flags in struct NotationInfo */
EXPORT SET NFLG_FLAT,NFLG_3_4

EXPORT OBJECT notationinfo
        n_of_sharps:CHAR        /* number of #'s (or b's) */
        flags:CHAR              /* flags (see above) */
        trksel[5]:ARRAY OF INT  /* selected track for each preset (-1 = none) */
        trkshow[16]:ARRAY OF CHAR /* which tracks t