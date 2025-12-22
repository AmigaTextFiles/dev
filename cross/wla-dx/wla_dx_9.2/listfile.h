
#ifndef __LISTFILE_H
#define __LISTFILE_H

int listfile_collect(void);
int listfile_block_write(FILE *f, struct section_def *s);

#endif
