   /*-> (C) 1990 Allen I. Holub                                                */
   /* HASH.H	Header required by the hash functions in /src/tools/hash.c */
#ifndef HASH__H
#define HASH__H

typedef struct BUCKET
{
    struct BUCKET	  *next;
    struct BUCKET	 **prev;

} BUCKET;


typedef struct  hash_tab_
{
    int	     size     ;		/* Max number of elements in table	 */
    int	     numsyms  ;		/* number of elements currently in table */
	unsigned (*hash)(void *);		/* hash function			 */
	int	     (*cmp)(void *,void *) ;  	/* comparison funct, cmp(name,bucket_p); */
    BUCKET   *table[1];		/* First element of actual hash table	 */

} HASH_TAB;

#ifdef __cplusplus
extern "C" {
#endif

extern HASH_TAB *maketab( unsigned maxsym, unsigned (*hash)(void *), int(*cmp)(void *,void *) );
extern void     *newsym(size_t size  );
extern void	freesym( void *sym );
extern void     *addsym( HASH_TAB *tabp, void *sym  );
extern void 	*findsym( HASH_TAB *tabp, void *sym  );
extern void     *nextsym( HASH_TAB *tabp, void *last );
extern void	delsym( HASH_TAB *tabp, void *sym  );
extern int ptab(HASH_TAB *tabp, void(*prnt)(void *,void *), void *par, int srt);
extern unsigned hash_add( unsigned char *name );	/* in hashadd.c */
extern unsigned hash_pjw( unsigned char *name );	/* in hashpjw.c */

#ifdef __cplusplus
}
#endif

#endif
