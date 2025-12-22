//
//
//
//

#include <stdio.h>
#include <errno.h>
#include "pm.h"

//
//
// 001xxxxx -> and/or/xor
// 01mxxmyy -> ld
//
//
//
//
// register coding (8bits case):
//  000 -> A
//  001 -> B
//  010 -> L
//  011 -> H
//  100 -> (XAB+off8)
//  101 -> (XHL)
//  110 -> (XIX)
//  111 -> (XIY)
//  NN is a special case register used with XAB
//
//
// HL/IX/IY    are 16bits registers
// XHL/XIX/XIY are 24bits registers used for referenceing memory
// XAB is a special case of 24bits address register which is constrictured
//     like XAB = (XHL & 0xff0000) | (NN & 0xff00)
//
//
//
// register coding (16bits case):
//  000 -> ba
//  001 -> hl
//  010 -> ix
//  011 -> iy
//  
//
//
//
//
//
//
//
//
//
//
//
//
//

int decode( struct tlcs900d *dd ) {
  unsigned char *b = dd->buffer + dd->pos;
  unsigned char mem;
  unsigned char c;
  int n;

	
	c = *b;
	if (n = decode_fixed(dd)) {
		return n;
	} else {
	    if (c < 0x3f) {
			return decode_3f(dd);
		} else if (c < 0x80) {
			return decode_40_7f(dd);
		} else if (c < 0xa0) {
			return decode_80_9f(dd);
		} else if (c >= 0xce && c < 0xd0) {
			return decode_ce_cf(dd);
		} else if (c < 0xdf) {
			return decode_a0_df(dd);
		} else {
			return decode_e0_ff(dd);
		}
	}
	return 0;
}

//
//
//

int checkrom( struct tlcs900d *dd, int verbose ) {

  // Check for Software Recongnition Code..

  if (dd->len < 0x21b0 || strncmp("NINTENDO",dd->buffer+0x21a4,8)) {
    if (verbose) { printf("Not a PM rom. Base address is %Xh\n",dd->base); }
    return 1;
  } else {
	if (verbose) { printf("This is a PM rom. Base address is %Xh\n",dd->base); }
  }

  // It's a PM rom.. Base offset to 0x00000
  // only if the user has not overridden it..

	if (dd->base != 0x00000 && verbose) {
    	printf("Warning! Base address is %Xh not 00000H\n",dd->base);
	}

  //

#if 0
  if (verbose) {
    printf("The file is a %s PM rom\n",
            dd->buffer[1] == 'C' ? "SNK" : "licensed");

     // Startup address
    printf("ROM code startup address is %Xh\n",get32u(dd->buffer+0x1c));

    // Card ID
    printf("The cart ID is %04Xh\n",get16u(dd->buffer+0x20));

    // Version
    printf("The cart version is %04Xh\n",get16u(dd->buffer+0x22));

    // Name
    printf("The cart name is '%12s'\n",dd->buffer+0x24);

  }

  if (dd->buffer[0x23] == 0 || dd->buffer[0x23] == 0x10 ) {
    if (verbose) {
      printf("The cart is %s compatible\n",
              dd->buffer[0x23] ? "Color" : "Monochrome");
    }
  } else {
    printf("Unknown Compatible System Code %02Xh ??\n",dd->buffer[0x23]);
  }
#endif
  return 0;
}

//
//
//

int loadrom_and_init( char *file, struct tlcs900d *dd ) {

  if (dd->fh = fopen(file,"r+b")) {
    fseek(dd->fh,0,SEEK_END);
    dd->len = ftell(dd->fh);
    fseek(dd->fh,0,SEEK_SET);

    if (dd->buffer = (uint8_t *)malloc(dd->len + dd->space + 16)) {
      if (fread(dd->buffer,1,dd->len,dd->fh) == dd->len) {
        fclose(dd->fh);
        dd->fh = NULL;

        printf("Loaded %d (%Xh) bytes. Extra space is %d bytes.\n\n",
                dd->len,dd->len,dd->space);

        checkrom(dd,0);

        // add some space that user requested..

        dd->len += dd->space;
        return 0;
      } else {
        printf("Error: fread() failed (errno: %d)\n",errno);
        fclose(dd->fh);
        dd->fh = NULL;
      }
    } else {
      printf("Error: malloc() failed (errno: %d)\n",errno);
    }
  } else {
    printf("Error: fopen(%s) failed (errno: %d)\n",file,errno);
  }
  return 1;
}
