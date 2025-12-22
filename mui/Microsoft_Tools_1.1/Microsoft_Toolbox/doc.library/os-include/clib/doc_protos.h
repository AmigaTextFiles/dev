#ifndef LIBRARIES_DOC_H
#include <libraries/doc.h>
#endif


ULONG Doc_init(void);
void Doc_exit(ULONG);
ULONG Doc_load(char*);
ULONG Doc_export_pdf(char*);
ULONG Doc_get_max_pages(void);
char *Doc_get_title(void);
char *Doc_get_subject(void);
char *Doc_get_author(void);
char *Doc_get_company(void);
char *Doc_get_appname(void);
char *Doc_get_manager(void);
char *Doc_get_language(void);
char *Doc_get_keywords(void);
char *Doc_get_comments(void);
char *Doc_get_page(ULONG);









