/*	Public domain	*/

typedef struct m_int_vector {
	Uint n;
	int *v;
} M_IntVector;

/* Begin generated block */
__BEGIN_DECLS
extern DECLSPEC M_IntVector *M_IntVectorNew(Uint);
extern DECLSPEC void M_IntVectorSet(M_IntVector *, int);
extern DECLSPEC void M_IntVectorCopy(const M_IntVector *, M_IntVector *);
extern DECLSPEC void M_IntVectorFree(M_IntVector *);
extern DECLSPEC void M_IntVectorAddv(M_IntVector *, const M_IntVector *);
extern DECLSPEC void M_IntVectorSubv(M_IntVector *, const M_IntVector *);
extern DECLSPEC void M_IntVectorScalev(M_IntVector *, M_Real);
extern DECLSPEC void M_IntVectorResize(M_IntVector *, Uint);
extern DECLSPEC void M_IntVectorPrint(const M_IntVector *);
__END_DECLS
/* Close generated block */
