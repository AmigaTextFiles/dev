#include <stdio.h>

void ReadVBR(void);

/* VBR Register */
unsigned long VBR;
unsigned long SSP;

void main(void)
{
 printf("ReadVBR V0.01\n");
 ReadVBR();
 printf("\nVBR Registers:\n");
 printf("VBR: %08lx\n",VBR);
 printf("SSP: %08lx\n",SSP);
}
