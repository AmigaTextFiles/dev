/*
 * fakeiconv - simulates libiconv API
 * version 0.1 by megacz@usa.com
*/



#include <sys/types.h>
#include <stdlib.h>
#include <string.h>

#undef wchar_t
#define wchar_t unsigned int



typedef unsigned int state_t;
typedef void* iconv_t;
typedef struct conv_struct *conv_t;

struct mbtowc_funcs {
  int (*xxx_mbtowc) (conv_t conv, wchar_t *pwc, unsigned char const *s, int n);
};

struct wctomb_funcs {
  int (*xxx_wctomb) (conv_t conv, unsigned char *r, wchar_t wc, int n);
  int (*xxx_reset) (conv_t conv, unsigned char *r, int n);
};

struct conv_struct {
  int iindex;
  struct mbtowc_funcs ifuncs;
  state_t istate;
  int oindex;
  struct wctomb_funcs ofuncs;
  int oflags;
  state_t ostate;
  int transliterate;
};

iconv_t libiconv_open (const char* tocode, const char* fromcode)
{
  struct conv_struct *cd;


  if ((cd = (struct conv_struct *)malloc(sizeof(struct conv_struct))) == NULL)
  {
    return (iconv_t)-1;
  }

  cd->iindex = 0;

  cd->oindex = 0;

  cd->oflags = 0;

  cd->transliterate = 0;

  memset(&cd->istate, '\0', sizeof(state_t));

  memset(&cd->ostate, '\0', sizeof(state_t));

  memset(&cd->ifuncs, '\0', sizeof(struct mbtowc_funcs));

  memset(&cd->ofuncs, '\0', sizeof(struct wctomb_funcs));

  return (iconv_t)cd;
}

size_t libiconv (iconv_t icd,
              const char* * inbuf, size_t *inbytesleft,
              char* * outbuf, size_t *outbytesleft)
{
  size_t result = 0;
  const unsigned char* inptr;
  size_t inleft = *inbytesleft;
  unsigned char* outptr;
  size_t outleft = *outbytesleft;


  if ((inbuf != NULL && outbuf != NULL))
  {
    inptr = (const unsigned char*) *inbuf;

    outptr = (unsigned char*) *outbuf;

    while (inleft > 0)
    {
      *outptr++ = *inptr++;

      inleft--;

      outleft--;
    }

    *inbuf = (const char*) inptr;

    *inbytesleft = inleft;

    *outbuf = (char*) outptr;

    *outbytesleft = outleft;
  }

  return result;
}

int libiconv_close (iconv_t icd)
{
  conv_t cd = (conv_t)icd;


  if ((icd != (iconv_t)-1) && 
      (icd != (iconv_t)0))
  {
    free(cd);
  }

  return 0;
}
