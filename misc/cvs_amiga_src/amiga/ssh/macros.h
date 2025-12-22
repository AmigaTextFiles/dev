/*
 * Common macros for Blowfish, DES and IDEA
 *
 */

#ifndef _MACROS_H
#define _MACROS_H

/****************************************************************************/

#define GET_32BIT_LSB_FIRST(cp) \
  (((unsigned long)(unsigned char)(cp)[0]) | \
  ((unsigned long)(unsigned char)(cp)[1] << 8) | \
  ((unsigned long)(unsigned char)(cp)[2] << 16) | \
  ((unsigned long)(unsigned char)(cp)[3] << 24))

#define PUT_32BIT_LSB_FIRST(cp, value) do { \
  (cp)[0] = (value); \
  (cp)[1] = (value) >> 8; \
  (cp)[2] = (value) >> 16; \
  (cp)[3] = (value) >> 24; } while (0)

#define GET_32BIT_MSB_FIRST(cp) \
  (((unsigned long)(unsigned char)(cp)[3]) | \
  ((unsigned long)(unsigned char)(cp)[2] << 8) | \
  ((unsigned long)(unsigned char)(cp)[1] << 16) | \
  ((unsigned long)(unsigned char)(cp)[0] << 24))

#define PUT_32BIT_MSB_FIRST(cp, value) do { \
  (cp)[3] = (value); \
  (cp)[2] = (value) >> 8; \
  (cp)[1] = (value) >> 16; \
  (cp)[0] = (value) >> 24; } while (0)

#define GET_16BIT(cp) (((unsigned long)(unsigned char)(cp)[0] << 8) | \
		       ((unsigned long)(unsigned char)(cp)[1]))

/****************************************************************************/

#ifndef TRUE
#define TRUE (0==0)
#endif /* TRUE */

#ifndef FALSE
#define FALSE (0!=0)
#endif /* FALSE */

/****************************************************************************/

#endif /* _MACROS_H */
