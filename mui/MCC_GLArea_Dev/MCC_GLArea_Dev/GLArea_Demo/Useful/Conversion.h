/*---------------------------------------
  Conversion.h
  Version 1.21
  Date: 6 january 1998
  Author: BODMER Stephan (bodmer2@uni2a.unige.ch)
  Note: convert float to char and integer to char
------------------------------------------*/
#ifdef __cplusplus
extern "C" {
#endif
int itoa (int num, char *buff);
int ftoa (float real, char *buff);
int dtoa (double real, char *buff);
float ftof(float real);

#ifdef __cplusplus
}
#endif
