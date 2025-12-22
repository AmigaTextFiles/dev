

#ifdef X3J11
typedef void	*pointer;		/* generic pointer type */
pointer alloca (unsigned);		/* returns pointer to storage */
#else
typedef char	*pointer;		/* generic pointer type */
pointer alloca ();			/* returns pointer to storage */
#endif /* X3J11 */


