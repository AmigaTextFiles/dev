/* Procedure to solve
** ax mod v=1 , where x is unknown
** WARNING! This procedure may return negative values!
**
** This algorithm has been taken from Bruce Schneier's "Applied Cryptography:
** Protocols, Algorithms and Source Code in C" and translated to E 3.3a
** by Maciej Plewa (maciejplewa@hotmail.com)
** Please send my your comments, propositions or bug-reports.
*/

PROC extended_euclidian(u, v)
	DEF u1=1, u3, v1=0, v3, q, tn

	u3:=u
	v3:=v

	WHILE v3>0
		q:=u3/v3

		tn:=u1-(v1*q)
		u1:=v1
		v1:=tn

		tn:=u3-(v3*q)
		u3:=v3
		v3:=tn
	ENDWHILE

ENDPROC u1

/* Simple test */

PROC main()
	DEF a, v, x

	a:=35945                 -> try other values
	v:=7474

	x:=extended_euclidian(a, v)

	WriteF('Extended Euclidian: \d*\d mod \d=1\n', a, x, v)

ENDPROC
