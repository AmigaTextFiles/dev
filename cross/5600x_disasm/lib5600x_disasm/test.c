/*
 * Copyright (c) 1998 Miloslaw Smyk
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 * 3. All advertising materials mentioning features or use of this software
 *    must display the following acknowledgement:
 *      This product includes software developed by Miloslaw Smyk
 * 4. The name of the author may not be used to endorse or promote products
 *    derived from this software without specific prior written permission
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
 * IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
 * OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
 * IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
 * NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
 * THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#include <stdio.h>
#include <stdlib.h>

#include "5600x_disasm.h"

int main(int argc, char *argv[])
{
	struct disasm_data dis, *d = &dis;
	char mem[6];
	unsigned char *memory;
	unsigned char *data;
	FILE *fh;
	fpos_t size;
	int advance;


	if(argc < 2)
	{
		printf("Need name of a file with DSP code as the argument!\n");
		exit(5);
	}

	/* initialize the library. This is REQUIRED! */
	make_masks();
	make_masks2();

	if(fh = fopen(argv[1], "r"))
	{
		/* get the code's size */

		if(fseek(fh, 0, SEEK_END))
			exit(10);
		else
		{
			fgetpos(fh, &size);
			rewind(fh);
		}

		if(memory = data = malloc(size))
		{
			/* read the entire file into memory */

			if(fread(data, size, 1, fh) == 1)
			{
				/* important part begins here */

				while(memory - data < size)
				{
					/* The library needs 24-bit words, so we have to throw away
					** upper 8 bits of every instruction's code. Since disassembly
					** processes up to two words per step, we need to prepare
					** two words. */

					memcpy(mem, memory + 1, 3);
					memcpy(mem + 3, memory + 5, 3);

					/* tell the library where is the data to disassemble */
					d->memory = mem;

					/* call the line-disassembly routine and note how many
					** words to advance forwards */

					advance = disassemble_opcode(d);

					/* display disassembled line */
					printf("%04x:\t%s\n", (memory - data) / 4, d->line_buf);

					/* advance code pointer */
					memory += advance * 4;
				}
			}

			free(data);
		}
		else
			exit(10);

		fclose(fh);
	}
}
