/*
   * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *
 * 'qdev' -  A library that helps in Amiga related software development
 * by Burnt Chip Dominators
 *
 * txt_nocomment.h
 *
 * --- LICENSE --------------------------------------------------------
 *
 * Following  contents covered by the  BSIPM  license not to be used in
 * commercial products nor redistributed separately nor modified by the
 * 3-rd parties other than mentioned in the license and under the terms
 * prior to recipient status.
 *
 * A  copy  of  the  BSIPM  document  and/or  source  code  along  with
 * commented modifications and/or separate changelog should be included
 * in this archive.
 *
 * NO WARRANTY OF ANY KIND APPLIES. ALL THE RISK AS TO THE QUALITY  AND
 * PERFORMANCE  OF  THIS  SOFTWARE  IS  WITH  YOU. SEE THE 'BLACK SALLY
 * IMITABLE PACKAGE MARK' DOCUMENT FOR MORE DETAILS.
 *
 * --- VERSION --------------------------------------------------------
 *
 * $VER: i-txt_nocomment.h 1.02 (26/12/2010)
 * AUTH: megacz
 *
 * --- COMMENT --------------------------------------------------------
 *
 * This is the header file only!
 *
   * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
*/

#ifndef ___NOCOMMENT_H_INCLUDED___
#define ___NOCOMMENT_H_INCLUDED___

#define QDEV_TXT_PRV_TRACKCHARS()             \
  case '\x2F': /* Slash       = '/'  */       \
  {                                           \
    if (posreg[1] == '\x2F')                  \
    {                                         \
      if (flags & QDEV_TXT_NC_F_CPP)          \
      {                                       \
        goto ___reswitch;                     \
      }                                       \
    }                                         \
    else                                      \
    {                                         \
      goto ___reswitch;                       \
    }                                         \
  }                                           \
  case '\x23': /* Hash        = '#'  */       \
  {                                           \
    if (*posreg == '\x23')                    \
    {                                         \
      if (flags & QDEV_TXT_NC_F_UNI)          \
      {                                       \
        goto ___reswitch;                     \
      }                                       \
    }                                         \
  }                                           \
  case '\x3B': /* Semicolon   = ';'  */       \
  {                                           \
    if (*posreg == '\x3B')                    \
    {                                         \
      if (flags & QDEV_TXT_NC_F_AMI)          \
      {                                       \
        goto ___reswitch;                     \
      }                                       \
    }                                         \
  }

#define QDEV_TXT_PRV_SKIPCHARS()              \
  case '\x09': /* Tab         = '\t' */       \
  case '\x0A': /* Linefeed    = '\n' */       \
  case '\x0D': /* Carriage r. = '\r' */       \
  case '\x20': /* Space       = ' '  */       \
  case '\x22': /* Double q.   = '"'  */       \
  case '\x27': /* Single q.   = '''  */

#define QDEV_TXT_PRV_SKIPCTRL()               \
  case 0x01:                                  \
  case 0x02:                                  \
  case 0x03:                                  \
  case 0x04:                                  \
  case 0x05:                                  \
  case 0x06:                                  \
  case 0x07:                                  \
  case 0x08:                                  \
  case 0x0B:                                  \
  case 0x0C:                                  \
  case 0x0E:                                  \
  case 0x0F:                                  \
  case 0x10:                                  \
  case 0x11:                                  \
  case 0x12:                                  \
  case 0x13:                                  \
  case 0x14:                                  \
  case 0x15:                                  \
  case 0x16:                                  \
  case 0x17:                                  \
  case 0x18:                                  \
  case 0x19:                                  \
  case 0x1A:                                  \
  case 0x1B:                                  \
  case 0x1C:                                  \
  case 0x1D:                                  \
  case 0x1E:                                  \
  case 0x1F:                                  \
  case 0x80:                                  \
  case 0x81:                                  \
  case 0x82:                                  \
  case 0x83:                                  \
  case 0x84:                                  \
  case 0x85:                                  \
  case 0x86:                                  \
  case 0x87:                                  \
  case 0x88:                                  \
  case 0x89:                                  \
  case 0x8A:                                  \
  case 0x8B:                                  \
  case 0x8C:                                  \
  case 0x8D:                                  \
  case 0x8E:                                  \
  case 0x8F:                                  \
  case 0x90:                                  \
  case 0x91:                                  \
  case 0x92:                                  \
  case 0x93:                                  \
  case 0x94:                                  \
  case 0x95:                                  \
  case 0x96:                                  \
  case 0x97:                                  \
  case 0x98:                                  \
  case 0x99:                                  \
  case 0x9A:                                  \
  case 0x9B:                                  \
  case 0x9C:                                  \
  case 0x9D:                                  \
  case 0x9E:                                  \
  case 0x9F:

#define QDEV_TXT_PRV_CSECHARS(f, r, t, d, l)  \
  case '\x2F': /* Slash       = '/'  */       \
  {                                           \
    if (!(flags & QDEV_TXT_NC_F_NCC))         \
    {                                         \
      if ((* f strreg) == '\x2A')             \
      {                                       \
               /* Asterisk    = '*'  */       \
        l:                                    \
        while ((f strreg d endreg)    &&      \
               (*strreg != '\x2A'));          \
        if ((*strreg == '\x2A')       &&      \
            (f strreg d endreg)       &&      \
            (*strreg != '\x2F'))              \
        {                                     \
          r strreg;                           \
          goto l;                             \
        }                                     \
      }                                       \
      else                                    \
      {                                       \
        return t strreg;                      \
      }                                       \
      break;                                  \
    }                                         \
  }

#endif /* ___NOCOMMENT_H_INCLUDED___ */
