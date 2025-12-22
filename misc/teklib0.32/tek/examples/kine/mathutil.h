/*
 *
 *
 *	Include for Matrixoperations
 *	24.04.2001  Frank Pagels , Teil von MiniGL übernommen
 *
 */

#ifndef _MATRIX_H
#define _MATRIX_H

#include <tek/mem.h>


typedef struct Matrix_t
{
		TFLOAT v[16];
		TINT flags;                  // Matrix flags
		struct Matrix_t *Inverse;   // optional inverse
} Matrix;


typedef struct
{
		TINT	rows;
		TINT	colum;
		TFLOAT	m[20][20];
		TINT	pvt_j[20];
		TINT	pvt_i[20];
} GenMatrix;


#define OF_11 0
#define OF_12 4
#define OF_13 8
#define OF_14 12

#define OF_21 1
#define OF_22 5
#define OF_23 9
#define OF_24 13

#define OF_31 2
#define OF_32 6
#define OF_33 10
#define OF_34 14

#define OF_41 3
#define OF_42 7
#define OF_43 11
#define OF_44 15

/* Struktur für Gelenke */
typedef struct
{
	TFLOAT	theta;
	TINT	d;
	TINT	a;
	TINT	a1;
	TFLOAT	alpha;
} joint;


TVOID MatMultGeneral(Matrix *pA, Matrix *pB, Matrix *pC);
TVOID LoadIdentity(Matrix *pA);
TVOID PrintMatrix(Matrix *pA);
TVOID LoadMatrix(Matrix *pA, const TFLOAT *v);
TFLOAT Determinant(Matrix *pA);
TVOID DoInvert(Matrix *pA, Matrix *pB);
TVOID GetHartenberg(joint *j, Matrix *pA);
TVOID MatMultPoint(Matrix *pA, TFLOAT *v, TFLOAT *tmp);
TVOID InitGenMatrix(GenMatrix *A, TINT row, TINT colum);
TVOID DestroyGenMatrix(GenMatrix *A);
TVOID GenPrintMatrix(GenMatrix *A);
TVOID GenLoadMatrix(Matrix *pA, const TFLOAT *v);
TVOID GenMatTranspose(GenMatrix *A, GenMatrix *B);
TVOID GenMatMultiply(GenMatrix *A, GenMatrix *B, GenMatrix *C);
TVOID GenMatLoadIdentity(GenMatrix *A, TFLOAT a);
TVOID GenMatInvers(GenMatrix *A);
TVOID GenMatCopy(GenMatrix *A,GenMatrix *B);
TVOID GenMatPseudoInvers(GenMatrix *A,GenMatrix *B, GenMatrix *C);
TVOID GenMatSub(GenMatrix *A,GenMatrix *B, GenMatrix *C);
TVOID GenMatAdd(GenMatrix *A,GenMatrix *B, GenMatrix *C);




#endif
