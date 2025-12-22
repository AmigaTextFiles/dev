/*--------------------------------------------------------
  Conversion.c
  Version 1.21
  Date: 6 january 1998
  Author: BODMER Stephan (bodmer2@uni2a.unige.ch)
  Note: convert float to char and integer to char
-------------------------------------------------------*/
#include <stdio.h>
#include <stdlib.h>
#include <math.h>

#include "Conversion.h"

// int->char
int itoa (int num, char *buff) {
    sprintf(buff,"%d",num);
    return 1;
}

// float->char
int ftoa (float real, char *buff) {
    // printf("float real:%lf\n",real);
    sprintf(buff,"%-.4f",real);
    // printf("After conversion:%s\n",buff);
    return (int) real;
}
// double->char
int dtoa (double real, char *buff) {
    sprintf(buff,"%-.10g",real);
    return 1;
}
// float to 0.2float
float ftof(float real) {
    char temp[25];

    sprintf(temp,"%.2f",real);
    printf("In ftof:%s\n",temp);
    return atof(temp);
}
