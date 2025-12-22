/*
 *	COP.H				by Patrick van Logchem (v912152@si.hhs.nl)
 *	last changed on 10 march 1994
 */

#ifndef COP_H
#define COP_H

extern __asm int leftmouse(void);
extern __asm int rightmouse(void);

extern __asm void setcopper(register __a0 void *);

extern __asm void chopper(
						register __a0 void *,	/* adres first bitplane */
						register __d0 long,		/* offset next bitplane */
						register __a1 void *,	/* adres copperlist mem */
						register __a2 void *,	/* adres y-adres-table  */
						register __a3 void *);	/* adres x-offset-table */

extern __asm void setcolor(
						register __d0 long,		/* x pos */
						register __d1 long,		/* y pos */
						register __d2 short);	/* color pixel RGB8 */

extern __asm short getcolor(
						register __d0 long,		/* x pos */
						register __d1 long);	/* y pos */

extern __asm void mountain(void);

#endif /* COP_H */
