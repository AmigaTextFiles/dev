#ifndef D5600X_DISASM_H
#define D5600X_DISASM_H


#define LINE_SIZE	256

struct disasm_data
{
	unsigned char *memory;
	char line_buf[LINE_SIZE];
	char *line_ptr;
	char words;
};


/* function prototypes */

int disassemble_opcode(struct disasm_data *d);
void make_masks(void);
void make_masks2(void);

#endif
