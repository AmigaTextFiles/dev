/**********************************************************************

  regex.h -

  $Author: shyouhei $
  $Date: 2007-02-13 08:01:19 +0900 (Tue, 13 Feb 2007) $

  Copyright (C) 1993-2005 Yukihiro Matsumoto

**********************************************************************/

#ifndef REGEX_H
#define REGEX_H

#include "oniguruma.h"

#ifndef ONIG_RUBY_M17N

ONIG_EXTERN OnigEncoding    OnigEncDefaultCharEncoding;

#undef ismbchar
#define ismbchar(c) (mbclen((c)) != 1)
#define mbclen(c)  \
  ONIGENC_MBC_ENC_LEN(OnigEncDefaultCharEncoding, (UChar* )(&c))

#endif /* ifndef ONIG_RUBY_M17N */

#endif /* !REGEX_H */
