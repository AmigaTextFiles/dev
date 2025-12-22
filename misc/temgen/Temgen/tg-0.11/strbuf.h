#ifndef __strbuf_h_
#define __strbuf_h_

struct strbuf;

struct strbuf *new_strbuf( unsigned size, unsigned delta );
void free_strbuf( struct strbuf* );
const char *sb_data( struct strbuf* );

/* s must be 0-terminated ! */
int sb_cat( struct strbuf*, const char *s, unsigned n );
void sb_clear( struct strbuf* );

#endif
