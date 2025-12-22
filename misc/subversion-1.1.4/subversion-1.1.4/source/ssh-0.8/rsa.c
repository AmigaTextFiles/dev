/*
 * RSA implementation just sufficient for ssh client-side
 * initialisation step
 *
 * Rewritten for more speed by Joris van Rantwijk, Jun 1999.
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "ssh.h"
#include "rsa.h"

typedef uint16_t *Bignum;

#if defined TESTMODE || defined RSADEBUG

#ifndef DLVL
#define DLVL 10000
#endif

#define debug(x) bndebug(#x,x)

static int level = 0;

static void 
bndebug (char *name, Bignum b)
{
  int i;
  int w = 50 - level - strlen (name) - 5 * b[0];

  if (level >= DLVL)
    return;

  if (w < 0)
    w = 0;

  printf ("%*s%s%*s", level, "", name, w, "");

  for (i = b[0]; i > 0; i--)
    printf (" %04x", b[i]);

  printf ("\n");
}

#define dmsg(x) do {if(level<DLVL){printf("%*s",level,"");printf x;}} while(0)
#define enter(x) do { dmsg(x); level += 4; } while(0)
#define leave(x) do { level -= 4; dmsg(x); } while(0)

#else

#define debug(x)
#define dmsg(x)
#define enter(x)
#define leave(x)

#endif /* TESTMODE || RSADEBUG */

static Bignum 
newbn (int length)
{
  Bignum b;

  b = malloc ((length + 1) * sizeof (uint16_t));
  if (b != NULL)
    b[0] = length;

  return b;
}

static void 
freebn (Bignum b)
{
  if (b != NULL)
    free (b);
}

/*
 * Compute c = a * b.
 * Input is in the first len words of a and b.
 * Result is returned in the first 2*len words of c.
 */
static void 
bigmul (uint16_t *a, uint16_t *b, uint16_t *c, int len)
{
  int i, j;
  uint32_t ai, t;

  for (j = len - 1; j >= 0; j--)
    c[j + len] = 0;

  for (i = len - 1; i >= 0; i--)
  {
    ai = a[i];

    t = 0;

    for (j = len - 1; j >= 0; j--)
    {
      t += ai * (uint32_t) b[j];
      t += (uint32_t) c[i + j + 1];

      c[i + j + 1] = (uint16_t) t;

      t = t >> 16;
    }

    c[i] = (uint16_t) t;
  }
}

/*
 * Compute a = a % m.
 * Input in first 2*len words of a and first len words of m.
 * Output in first 2*len words of a (of which first len words will be zero).
 * The MSW of m MUST have its high bit set.
 */
static void 
bigmod (uint16_t *a, uint16_t *m, int len)
{
  uint16_t m0, m1;
  unsigned int h;
  int i, k;

  /* Special case for len == 1 */
  if (len == 1)
  {
    a[1] = (((long) a[0] << 16) + a[1]) % m[0];
    a[0] = 0;

    return;
  }

  m0 = m[0];
  m1 = m[1];

  for (i = 0; i <= len; i++)
  {
    uint32_t t;
    unsigned int q, r, c;

    if (i == 0)
    {
      h = 0;
    }
    else
    {
      h = a[i - 1];
      a[i - 1] = 0;
    }

    /* Find q = h:a[i] / m0 */
    t = ((uint32_t) h << 16) + a[i];
    q = t / m0;
    r = t % m0;

    /* Refine our estimate of q by looking at
       h:a[i]:a[i+1] / m0:m1 */
    t = (long) m1 *(long) q;

    if (t > ((uint32_t) r << 16) + a[i + 1])
    {
      q--;
      t -= m1;
      r = (r + m0) & 0xffff; /* overflow? */

      if (r >= (uint32_t) m0 && t > ((uint32_t) r << 16) + a[i + 1])
        q--;
    }

    /* Substract q * m from a[i...] */
    c = 0;

    for (k = len - 1; k >= 0; k--)
    {
      t = (long) q *(long) m[k];
      t += c;
      c = t >> 16;

      if ((uint16_t) t > a[i + k])
        c++;

      a[i + k] -= (uint16_t) t;
    }

    /* Add back m in case of borrow */
    if (c != h)
    {
      t = 0;

      for (k = len - 1; k >= 0; k--)
      {
        t += m[k];
        t += a[i + k];
        a[i + k] = (uint16_t) t;
        t = t >> 16;
      }
    }
  }
}

/*
 * Compute (base ^ exp) % mod.
 * The base MUST be smaller than the modulus.
 * The most significant word of mod MUST be non-zero.
 * We assume that the result array is the same size as the mod array.
 */
static int
modpow (Bignum base, Bignum exp, Bignum mod, Bignum result)
{
  uint16_t *a, *b, *n, *m;
  int mshift;
  int mlen, i, j;
  int error = -1;

  mlen = mod[0];

  /* Allocate m and n of size mlen */
  m = malloc (mlen * sizeof (uint16_t));
  n = malloc (mlen * sizeof (uint16_t));

  /* Allocate a and b of size 2*mlen. */
  a = malloc (2 * mlen * sizeof (uint16_t));
  b = malloc (2 * mlen * sizeof (uint16_t));

  if (m == NULL || n == NULL || a == NULL || b == NULL)
    goto out;

  /* Copy mod to m */
  /* We use big endian internally */
  for (j = 0; j < mlen; j++)
    m[j] = mod[mod[0] - j];

  /* Shift m left to make msb bit set */
  for (mshift = 0; mshift < 15; mshift++)
  {
    if ((m[0] << mshift) & 0x8000)
      break;
  }

  if (mshift)
  {
    for (i = 0; i < mlen - 1; i++)
      m[i] = (m[i] << mshift) | (m[i + 1] >> (16 - mshift));

    m[mlen - 1] = m[mlen - 1] << mshift;
  }

  /* Copy base to n */
  i = mlen - base[0];

  for (j = 0; j < i; j++)
    n[j] = 0;

  for (j = 0; j < base[0]; j++)
    n[i + j] = base[base[0] - j];

  /* Set a = 1 */
  for (i = 0; i < 2 * mlen; i++)
    a[i] = 0;

  a[2 * mlen - 1] = 1;

  /* Skip leading zero bits of exp. */
  i = 0;
  j = 15;

  while (i < exp[0] && (exp[exp[0] - i] & (1 << j)) == 0)
  {
    j--;
    if (j < 0)
    {
      i++;
      j = 15;
    }
  }

  /* Main computation */
  while (i < exp[0])
  {
    while (j >= 0)
    {
      bigmul (a + mlen, a + mlen, b, mlen);
      bigmod (b, m, mlen);

      if ((exp[exp[0] - i] & (1 << j)) != 0)
      {
        bigmul (b + mlen, n, a, mlen);
        bigmod (a, m, mlen);
      }
      else
      {
        uint16_t *t;

        t = a;
        a = b;
        b = t;
      }

      j--;
    }

    i++;

    j = 15;
  }

  /* Fixup result in case the modulus was shifted */
  if (mshift)
  {
    for (i = mlen - 1; i < 2 * mlen - 1; i++)
      a[i] = (a[i] << mshift) | (a[i + 1] >> (16 - mshift));

    a[2 * mlen - 1] = a[2 * mlen - 1] << mshift;

    bigmod (a, m, mlen);

    for (i = 2 * mlen - 1; i >= mlen; i--)
      a[i] = (a[i] >> mshift) | (a[i - 1] << (16 - mshift));
  }

  /* Copy result to buffer */
  for (i = 0; i < mlen; i++)
    result[result[0] - i] = a[i + mlen];

  error = 0;

 out:

  /* Free temporary arrays */

  if (a != NULL)
  {
    memset(a,0,2 * mlen);
    free (a);
  }

  if (b != NULL)
  {
    memset(b,0,2 * mlen);
    free (b);
  }

  if (m != NULL)
  {
    memset(m,0,mlen);
    free (m);
  }

  if (n != NULL)
  {
    memset(n,0,mlen);
    free (n);
  }

  return(error);
}

void
freekey(R_RSAKey * key)
{
  if(key != NULL)
  {
    freebn(key->exponent);
    key->exponent = NULL;

    freebn(key->modulus);
    key->modulus = NULL;
  }
}

int 
makekey (uint8_t *data, R_RSAKey * key, uint8_t **keystr)
{
  uint8_t *p = data;
  Bignum bn[2] = { NULL,NULL };
  int i, j;
  int w, b;
  int result = -1;

  key->bits = 0;
  for (i = 0; i < 4; i++)
    key->bits = (key->bits << 8) + *p++;

  for (j = 0; j < 2; j++)
  {
    w = 0;

    for (i = 0; i < 2; i++)
      w = (w << 8) + *p++;

    key->bytes = b = (w + 7) / 8; /* bits -> bytes */
    w = (w + 15) / 16; /* bits -> words */

    bn[j] = newbn (w);
    if(bn[j] == NULL)
    {
      freebn(bn[0]);
      freebn(bn[1]);

      goto out;
    }

    if (keystr)
      *keystr = p; /* point at key string, second time */

    for (i = 1; i <= w; i++)
      bn[j][i] = 0;

    for (i = b; i--;)
    {
      uint8_t byte = *p++;

      if (i & 1)
        bn[j][1 + i / 2] |= byte << 8;
      else
        bn[j][1 + i / 2] |= byte;
    }

    debug (bn[j]);
  }

  key->exponent = bn[0];
  key->modulus = bn[1];

  result = p - data;

 out:

  return (result);
}

int
rsaencrypt (uint8_t *data, int length, R_RSAKey * key)
{
  Bignum b1, b2;
  int w, i;
  uint8_t *p;
  int error = -1;

  debug (key->exponent);

  memmove (data + key->bytes - length, data, length);

  data[0] = 0;
  data[1] = 2;

  for (i = 2; i < key->bytes - length - 1; i++)
  {
    do
    {
      data[i] = rand () % 256;
    }
    while (data[i] == 0);
  }

  data[key->bytes - length - 1] = 0;

  w = (key->bytes + 1) / 2;

  b1 = newbn (w);
  b2 = newbn (w);

  if(b1 == NULL || b2 == NULL)
    goto out;

  p = data;

  for (i = 1; i <= w; i++)
    b1[i] = 0;

  for (i = key->bytes; i--;)
  {
    uint8_t byte = *p++;

    if (i & 1)
      b1[1 + i / 2] |= byte << 8;
    else
      b1[1 + i / 2] |= byte;
  }

  debug (b1);

  if(modpow (b1, key->exponent, key->modulus, b2) < 0)
    goto out;

  debug (b2);

  p = data;

  for (i = key->bytes; i--;)
  {
    uint8_t b;

    if (i & 1)
      b = b2[1 + i / 2] >> 8;
    else
      b = b2[1 + i / 2] & 0xFF;

    *p++ = b;
  }

  error = 0;

 out:

  freebn (b1);
  freebn (b2);

  return(error);
}

#ifdef TESTMODE

static int 
rsastr_len (R_RSAKey * key)
{
  Bignum md, ex;

  md = key->modulus;
  ex = key->exponent;

  return 4 * (ex[0] + md[0]) + 10;
}

static void 
rsastr_fmt (char *str, R_RSAKey * key)
{
  Bignum md, ex;
  int len = 0, i;

  md = key->modulus;
  ex = key->exponent;

  for (i = 1; i <= ex[0]; i++)
  {
    sprintf (str + len, "%04x", ex[i]);
    len += strlen (str + len);
  }

  str[len++] = '/';

  for (i = 1; i <= md[0]; i++)
  {
    sprintf (str + len, "%04x", md[i]);
    len += strlen (str + len);
  }

  str[len] = '\0';
}

#ifndef NODDY
#define p1 10007
#define p2 10069
#define p3 10177
#else
#define p1 3
#define p2 7
#define p3 13
#endif

uint16_t P1[2] = {1, p1};
uint16_t P2[2] = {1, p2};
uint16_t P3[2] = {1, p3};
uint16_t bigmod[5] = {4, 0, 0, 0, 32768U};
uint16_t mod[5] = {4, 0, 0, 0, 0};
uint16_t a[5] = {4, 0, 0, 0, 0};
uint16_t b[5] = {4, 0, 0, 0, 0};
uint16_t c[5] = {4, 0, 0, 0, 0};
uint16_t One[2] = {1, 1};
uint16_t Two[2] = {1, 2};

int 
main (void)
{
  modmult (P1, P2, bigmod, a);
  debug (a);
  modmult (a, P3, bigmod, mod);
  debug (mod);

  sub (P1, One, a);
  debug (a);
  sub (P2, One, b);
  debug (b);
  modmult (a, b, bigmod, c);
  debug (c);
  sub (P3, One, a);
  debug (a);
  modmult (a, c, bigmod, b);
  debug (b);

  modpow (Two, b, mod, a);
  debug (a);

  return 0;
}

#endif
