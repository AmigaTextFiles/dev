//
//
//

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>
#include "pm.h"


int decode_40_7f( struct tlcs900d *dd ) {
	unsigned char *b = dd->buffer + dd->pos;
	char buf1[8], buf2[8];
	unsigned char c;
	int ra = getra(b);
	int rb = getrb(b);
	int len = 0;

	// 
	//- movb rb1,rb2          |  40+rb1<<3+rb2     |  rb1 <- rb2                  |
	//- movb rb,[NN+ofs8]     |  44+rb<<3:ofs8     |  rb <-                       |
	//                   |                    |    mem8[HL[23:16]+NN+ofs8]   |
	//- movb rb,[HL]          |  45+rb<<3          |  rb <- mem8[HL]              |
	//- movb rb,[X1]          |  46+rb<<3          |  rb <- mem8[X1]              |
	//- movb rb,[X2]          |  47+rb<<3          |  rb <- mem8[X2]              |
	// movb [X1],rb          |  60+rb             |  mem8[X1] <- rb              |
	// movb [X1],[NN+ofs8]   |  64:ofs8           |  mem8[X1] <-                 |
	//                   |                    |    mem8[HL[23:16]+NN+ofs8]   |
	// movb [HL],rb          |  68+rb             |  mem8[HL] <- rb              |
	// movb [HL],[NN+ofs8]   |  6C:ofs8           |  mem8[HL] <-                 |
	//                   |                    |    mem8[HL[23:16]+NN+ofs8]   |
	// movb [X2],rb          |  70+rb             |  mem8[X2] <- rb              |
	// movb [X2],[NN+ofs8]   |  74:ofs8           |  mem8[X2] <-                 |
	//                   |                    |    mem8[HL[23:16]+NN+ofs8]   |
	// movb [NN+ofs8],rb     |  78+rb:ofs8        | mem8[HL[23:16]+NN+ofs8] <-rb |
	// movb [NN+ofs8],[HL]   |  7D:ofs8           | mem8[HL[23:16]+NN+ofs8] <-   |
	//                   |                    |     mem8[HL]                 |
	// movb [NN+ofs8],[X1]   |  7E:ofs8           | mem8[HL[23:16]+NN+ofs8] <-   |
	//                   |                    |     mem8[X1]                 |
	// movb [NN+ofs8],[X2]   |  7F:ofs8           | mem8[HL[23:16]+NN+ofs8] <-   |
	//                   |                    |     mem8[X2]                 |


	//
	//  01100xxx
	//
	//
	//
	//


	c = b[len++];

	//

	if (c < 0x60) {
		len += retr8_mem(b,dd->ops,rb,ra);
	    if (ra & 0x04) {
			dd->opt = OPT_1_1_0;
		} else {
			dd->opt = OPT_1_0_0;
		}
	} else {
		if (c & 0x04 || (c & 0x78 == 0x78)) {
	 		sprintf(dd->ops,ld_r_mem[(c - 0x60)],b[len++]);
			dd->opt = OPT_1_1_0;
		} else {
			sprintf(dd->ops,ld_r_mem[(c - 0x60)]);
			dd->opt = OPT_1_0_0;
		}
	}

	dd->opf = opcode_names[LD];
	return len;
}

