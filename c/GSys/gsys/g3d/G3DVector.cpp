
/* Author Anders Kjeldsen */

#ifndef GVECTORMET
#define GVECTORMET

GVector::GVector()
{
	memset((void*)this, 0, sizeof (class GVector));
}

GVector::GVector(class GVertex *V1, class GVertex *V2)
{
	memset((void*)this, 0, sizeof (class GVector));

	if (V1 && V2)
	{
		DeltaX = V2->X - V1->X;
		DeltaY = V2->Y - V1->Y;
		DeltaZ = V2->Z - V1->Z;
		DeltaU = V2->U - V1->U;
		DeltaV = V2->V - V1->V;

#if OBJ_VTX_L == TRUE
		DeltaW = V2->W - V1->W;
#endif

#if OBJ_VTX_TEX3D == TRUE
		DeltaX = V2->X - V1->TEX3D;
#endif

#if OBJ_VTX_COLOR == TRUE
		DeltaCOLOR.r = V2->COLOR.r - V1->COLOR.r;
		DeltaCOLOR.g = V2->COLOR.g - V1->COLOR.g;
		DeltaCOLOR.b = V2->COLOR.b - V1->COLOR.b;
		DeltaCOLOR.a = V2->COLOR.a - V1->COLOR.a;
#endif

#if OBJ_VTX_SPEC == TRUE
		DeltaSPEC.r = V2->SPEC.r - V1->SPEC.r;
		DeltaSPEC.g = V2->SPEC.g - V1->SPEC.g;
		DeltaSPEC.b = V2->SPEC.b - V1->SPEC.b;
#endif
#if OBJ_VTX_L == TRUE
		DeltaL = V2->L - V1->L;
#endif

	}
}

GVector::GVector(class GVector *V)
{
	memcpy((void*)this, V, sizeof (class GVector));
}

void GVector::PrintfAll()
{
	printf("Vector at $%x:\n", this);
	printf("X: %f ", DeltaX);
	printf("Y: %f ", DeltaY);
	printf("Z: %f.\n", DeltaZ);
}




BOOL GVector::Init(class GVertex *V1, class GVertex *V2)
{
	if (V1 && V2)
	{
		DeltaX = V2->X - V1->X;
		DeltaY = V2->Y - V1->Y;
		DeltaZ = V2->Z - V1->Z;
		DeltaU = V2->U - V1->U;
		DeltaV = V2->V - V1->V;

#if OBJ_VTX_L == TRUE
		DeltaW = V2->W - V1->W;
#endif

#if OBJ_VTX_TEX3D == TRUE
		DeltaX = V2->X - V1->TEX3D;
#endif

#if OBJ_VTX_COLOR == TRUE
		DeltaCOLOR.r = V2->COLOR.r - V1->COLOR.r;
		DeltaCOLOR.g = V2->COLOR.g - V1->COLOR.g;
		DeltaCOLOR.b = V2->COLOR.b - V1->COLOR.b;
		DeltaCOLOR.a = V2->COLOR.a - V1->COLOR.a;
#endif

#if OBJ_VTX_SPEC == TRUE
		DeltaSPEC.r = V2->SPEC.r - V1->SPEC.r;
		DeltaSPEC.g = V2->SPEC.g - V1->SPEC.g;
		DeltaSPEC.b = V2->SPEC.b - V1->SPEC.b;
#endif
#if OBJ_VTX_L == TRUE
		DeltaL = V2->L - V1->L;
#endif

		return TRUE;
	}
	else return FALSE;
}

BOOL GVector::Init(class GVector *V)
{
	if (V)
	{
		memcpy((void*)this, V, sizeof (class GVector));
		return TRUE;
	}
	else return FALSE;
}	


BOOL GVector::DivideByX()
{
	if (DeltaX)
	{
		DeltaY/= DeltaX;
		DeltaZ/= DeltaX;
		DeltaU = DeltaX;
		DeltaV/= DeltaX;

#if OBJ_VTX_TEX3D == TRUE
		DeltaTEX3D/= DeltaX;
#endif

#if OBJ_VTX_W == TRUE
		DeltaW/= DeltaX;
#endif

#if OBJ_VTX_COLOR == TRUE
		DeltaCOLOR.r/= DeltaX;
		DeltaCOLOR.g/= DeltaX;
		DeltaCOLOR.b/= DeltaX;
		DeltaCOLOR.a/= DeltaX;
#endif

#if OBJ_VTX_SPEC == TRUE
		DeltaSPEC.r/= DeltaX;
		DeltaSPEC.g/= DeltaX;
		DeltaSPEC.b/= DeltaX;
#endif

#if OBJ_VTX_L == TRUE
		DeltaL/= DeltaX;
#endif

		DeltaX = 1.0;


		return TRUE;
	}
	else return FALSE;
}


BOOL GVector::DivideByY()
{
	if (DeltaY)
	{
		DeltaX/= DeltaY;
		DeltaZ/= DeltaY;
		DeltaU = DeltaY;
		DeltaV/= DeltaY;

#if OBJ_VTX_TEX3D == TRUE
		DeltaTEX3D/= DeltaY;
#endif

#if OBJ_VTX_W == TRUE
		DeltaW/= DeltaY;
#endif

#if OBJ_VTX_COLOR == TRUE
		DeltaCOLOR.r/= DeltaY;
		DeltaCOLOR.g/= DeltaY;
		DeltaCOLOR.b/= DeltaY;
		DeltaCOLOR.a/= DeltaY;
#endif

#if OBJ_VTX_SPEC == TRUE
		DeltaSPEC.r/= DeltaY;
		DeltaSPEC.g/= DeltaY;
		DeltaSPEC.b/= DeltaY;
#endif

#if OBJ_VTX_L == TRUE
		DeltaL/= DeltaY;
#endif

		DeltaY = 1.0;

		return TRUE;
	}
	else return FALSE;
}

BOOL GVector::DivideByZ()
{
	if (DeltaZ)
	{
		DeltaX/= DeltaZ;
		DeltaY/= DeltaZ;
		DeltaU/= DeltaZ;
		DeltaV/= DeltaZ;

#if OBJ_VTX_TEX3D == TRUE
		DeltaTEX3D/= DeltaZ;
#endif

#if OBJ_VTX_W == TRUE
		DeltaW/= DeltaZ;
#endif

#if OBJ_VTX_COLOR == TRUE
		DeltaCOLOR.r/= DeltaZ;
		DeltaCOLOR.g/= DeltaZ;
		DeltaCOLOR.b/= DeltaZ;
		DeltaCOLOR.a/= DeltaZ;
#endif

#if OBJ_VTX_SPEC == TRUE
		DeltaSPEC.r/= DeltaZ;
		DeltaSPEC.g/= DeltaZ;
		DeltaSPEC.b/= DeltaZ;
#endif

#if OBJ_VTX_L == TRUE
		DeltaL/= DeltaZ;
#endif

		DeltaZ = 1.0;

		return TRUE;
	}
	else return FALSE;
}

BOOL GVector::Multiply(float Const)
{
		DeltaX*= Const;
		DeltaY*= Const;
		DeltaZ*= Const;
		DeltaU*= Const;
		DeltaV*= Const;

#if OBJ_VTX_TEX3D == TRUE
		DeltaTEX3D*= Const;
#endif

#if OBJ_VTX_W == TRUE
		DeltaW*= Const;
#endif

#if OBJ_VTX_COLOR == TRUE
		DeltaCOLOR.r*= Const;
		DeltaCOLOR.g*= Const;
		DeltaCOLOR.b*= Const;
		DeltaCOLOR.a*= Const;
#endif

#if OBJ_VTX_SPEC == TRUE
		DeltaSPEC.r*= Const;
		DeltaSPEC.g*= Const;
		DeltaSPEC.b*= Const;
#endif

#if OBJ_VTX_L == TRUE
		DeltaL*= Const;
#endif

		return TRUE;
}

GVector operator-(class GVector &V1, class GVector &V2)
{
	class GVector Dest;
		Dest.DeltaX = V1.DeltaX - V2.DeltaX;
		Dest.DeltaY = V1.DeltaY - V2.DeltaY;
		Dest.DeltaZ = V1.DeltaZ - V2.DeltaZ;
		Dest.DeltaU = V1.DeltaU - V2.DeltaU;
		Dest.DeltaV = V1.DeltaV - V2.DeltaV;

#if OBJ_VTX_TEX3D == TRUE
		Dest.DeltaTEX3D = V1.DeltaTEX3D - V2.DeltaTEX3D;
#endif

#if OBJ_VTX_W == TRUE
		Dest.DeltaW = V1.DeltaW - V2.DeltaW;
#endif

#if OBJ_VTX_COLOR == TRUE
		Dest.DeltaCOLOR.r = V1.DeltaCOLOR.r - V2.DeltaCOLOR.r;
		Dest.DeltaCOLOR.g = V1.DeltaCOLOR.g - V2.DeltaCOLOR.g;
		Dest.DeltaCOLOR.b = V1.DeltaCOLOR.b - V2.DeltaCOLOR.b;
		Dest.DeltaCOLOR.a = V1.DeltaCOLOR.a - V2.DeltaCOLOR.a;
#endif

#if OBJ_VTX_SPEC == TRUE
		Dest.DeltaSPEC.r = V1.DeltaSPEC.r - V2.DeltaSPEC.r;
		Dest.DeltaSPEC.g = V1.DeltaSPEC.g - V2.DeltaSPEC.g;
		Dest.DeltaSPEC.b = V1.DeltaSPEC.b - V2.DeltaSPEC.b;
#endif

#if OBJ_VTX_L == TRUE
		Dest.DeltaL = V1.DeltaL - V2.DeltaL;
#endif

		return Dest;
}

GVector operator +(class GVector &V1, class GVector &V2)
{
	class GVector Dest;
		Dest.DeltaX = V1.DeltaX + V2.DeltaX;
		Dest.DeltaY = V1.DeltaY + V2.DeltaY;
		Dest.DeltaZ = V1.DeltaZ + V2.DeltaZ;
		Dest.DeltaU = V1.DeltaU + V2.DeltaU;
		Dest.DeltaV = V1.DeltaV + V2.DeltaV;

#if OBJ_VTX_TEX3D == TRUE
		Dest.DeltaTEX3D = V1.DeltaTEX3D + V2.DeltaTEX3D;
#endif

#if OBJ_VTX_W == TRUE
		Dest.DeltaW = V1.DeltaW + V2.DeltaW;
#endif

#if OBJ_VTX_COLOR == TRUE
		Dest.DeltaCOLOR.r = V1.DeltaCOLOR.r + V2.DeltaCOLOR.r;
		Dest.DeltaCOLOR.g = V1.DeltaCOLOR.g + V2.DeltaCOLOR.g;
		Dest.DeltaCOLOR.b = V1.DeltaCOLOR.b + V2.DeltaCOLOR.b;
		Dest.DeltaCOLOR.a = V1.DeltaCOLOR.a + V2.DeltaCOLOR.a;
#endif

#if OBJ_VTX_SPEC == TRUE
		Dest.DeltaSPEC.r = V1.DeltaSPEC.r + V2.DeltaSPEC.r;
		Dest.DeltaSPEC.g = V1.DeltaSPEC.g + V2.DeltaSPEC.g;
		Dest.DeltaSPEC.b = V1.DeltaSPEC.b + V2.DeltaSPEC.b;
#endif

#if OBJ_VTX_L == TRUE
		Dest.DeltaL = V1.DeltaL + V2.DeltaL;
#endif

		return Dest;
}



#endif /* GVECTORMET */