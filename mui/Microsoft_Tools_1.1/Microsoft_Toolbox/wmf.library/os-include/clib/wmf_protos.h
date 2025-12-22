#ifndef LIBRARIES_DOC_H
#include <libraries/wmf.h>
#endif


ULONG Wmf_init(void);
void Wmf_exit(ULONG);
ULONG Wmf_Load_path(char*);
char *Wmf_get_image(void);
void Wmf_max_size(ULONG);
ULONG Wmf_get_width(void);
ULONG Wmf_get_height(void);
ULONG Wmf_Load_mem(struct data_out*);




