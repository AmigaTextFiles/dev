
/* Author Anders Kjeldsen */

#ifndef GVERTEXMET
#define GVERTEXMET

GVertex::GVertex()
{
	memset((void*)this, 0, sizeof (class GVertex));
}

void GVertex::PrintfAll()
{
	printf("Vertex at $%x:\t", this);
	printf("X: %f ", X);
	printf("Y: %f ", Y);
	printf("Z: %f.\n", Z);
}

BOOL GVertex::CopyVertex(GVertex *Destination)
{
	if (Destination)
	{
		memcpy((APTR)Destination, (APTR)this, sizeof (class GVertex));
		return TRUE;
	}
	else return FALSE;
}


BOOL GVertex::AddVector(class GVector *Source)
{
	if (Source)
	{
		X+=Source->DeltaX;
		Y+=Source->DeltaY;
		Z+=Source->DeltaZ;
		U+=Source->DeltaU;
		V+=Source->DeltaV;

#if OBJ_VTX_TEX3D == TRUE
		TEX3D+=Source->DeltaTEX3D;
#endif

#if OBJ_VTX_W == TRUE
		W+=Source->DeltaW;
#endif

#if OBJ_VTX_COLOR == TRUE
		COLOR.r+=Source->DeltaCOLOR.r;
		COLOR.g+=Source->DeltaCOLOR.g;
		COLOR.b+=Source->DeltaCOLOR.b;
		COLOR.a+=Source->DeltaCOLOR.a;
#endif

#if OBJ_VTX_SPEC == TRUE
		SPEC.r+=Source->DeltaSPEC.r;
		SPEC.g+=Source->DeltaSPEC.g;
		SPEC.b+=Source->DeltaSPEC.b;
#endif

#if OBJ_VTX_L == TRUE
		L+=Source->DeltaL;
#endif

		return TRUE;
	}
	else return FALSE;
}


GVertex operator +(class GVertex &V1, class GVertex &V2)
{
	GVertex dest;
//	if (V1 && V2)
//	{
		dest.X = V1.X + V2.X;
		dest.Y = V1.Y + V2.Y;
		dest.Z = V1.Z + V2.Z;
		dest.U = V1.U + V2.U;
		dest.V = V1.V + V2.V;

#if OBJ_VTX_TEX3D == TRUE
		dest.TEX3D = V1.TEX3D + V2.TEX3D;
#endif

#if OBJ_VTX_W == TRUE
		dest.W = V1.W + V2.W;
#endif

#if OBJ_VTX_COLOR == TRUE
		dest.COLOR.r = V1.COLOR.r + V2.COLOR.r;
		dest.COLOR.g = V1.COLOR.g + V2.COLOR.g;
		dest.COLOR.b = V1.COLOR.b + V2.COLOR.b;
		dest.COLOR.a = V1.COLOR.a + V2.COLOR.a;
#endif

#if OBJ_VTX_SPEC == TRUE
		dest.SPEC.r = V1.SPEC.r + V2.SPEC.r;
		dest.SPEC.g = V1.SPEC.g + V2.SPEC.g;
		dest.SPEC.b = V1.SPEC.b + V2.SPEC.b;
#endif

#if OBJ_VTX_L == TRUE
		dest.L = V1.L + V2.L;
#endif
//	}
	return dest;
}

GVertex operator -(class GVertex &V1, class GVertex &V2)
{
	GVertex dest;
//	if (V1 && V2)
//	{
		dest.X = V1.X - V2.X;
		dest.Y = V1.Y - V2.Y;
		dest.Z = V1.Z - V2.Z;
		dest.U = V1.U - V2.U;
		dest.V = V1.V - V2.V;

#if OBJ_VTX_TEX3D == TRUE
		dest.TEX3D = V1.TEX3D - V2.TEX3D;
#endif

#if OBJ_VTX_W == TRUE
		dest.W = V1.W - V2.W;
#endif

#if OBJ_VTX_COLOR == TRUE
		dest.COLOR.r = V1.COLOR.r - V2.COLOR.r;
		dest.COLOR.g = V1.COLOR.g - V2.COLOR.g;
		dest.COLOR.b = V1.COLOR.b - V2.COLOR.b;
		dest.COLOR.a = V1.COLOR.a - V2.COLOR.a;
#endif

#if OBJ_VTX_SPEC == TRUE
		dest.SPEC.r = V1.SPEC.r - V2.SPEC.r;
		dest.SPEC.g = V1.SPEC.g - V2.SPEC.g;
		dest.SPEC.b = V1.SPEC.b - V2.SPEC.b;
#endif

#if OBJ_VTX_L == TRUE
		dest.L = V1.L - V2.L;
#endif
//	}
	return dest;
}

GVertex operator *(GVertex &V1, float t)
{
	GVertex dest;

	dest.X = V1.X * t;
	dest.Y = V1.Y * t;
	dest.Z = V1.Z * t;
	dest.U = V1.U * t;
	dest.V = V1.V * t;

#if OBJ_VTX_TEX3D == TRUE
	dest.TEX3D = V1.TEX3D * t;
#endif

#if OBJ_VTX_W == TRUE
	dest.W = V1.W * t;
#endif

#if OBJ_VTX_COLOR == TRUE
	dest.COLOR.r = V1.COLOR.r * t;
	dest.COLOR.g = V1.COLOR.g * t;
	dest.COLOR.b = V1.COLOR.b * t;
	dest.COLOR.a = V1.COLOR.a * t;
#endif

#if OBJ_VTX_SPEC == TRUE
	dest.SPEC.r = V1.SPEC.r * t;
	dest.SPEC.g = V1.SPEC.g * t;
	dest.SPEC.b = V1.SPEC.b * t;
#endif

#if OBJ_VTX_L == TRUE
	dest.L = V1.L * t;
#endif
	return dest;
}

BOOL GVertex::DivideByX()
{
	if (X)
	{
		Y/= X;
		Z/= X;
		U = X;
		V/= X;

#if OBJ_VTX_TEX3D == TRUE
		TEX3D/= X;
#endif

#if OBJ_VTX_W == TRUE
		W/= X;
#endif

#if OBJ_VTX_COLOR == TRUE
		COLOR.r/= X;
		COLOR.g/= X;
		COLOR.b/= X;
		COLOR.a/= X;
#endif

#if OBJ_VTX_SPEC == TRUE
		SPEC.r/= X;
		SPEC.g/= X;
		SPEC.b/= X;
#endif

#if OBJ_VTX_L == TRUE
		L/= X;
#endif

		X = 1.0;

		return TRUE;
	}
	else return FALSE;
}


BOOL GVertex::DivideByY()
{
	if (Y)
	{
		X/= Y;
		Z/= Y;
		U = Y;
		V/= Y;

#if OBJ_VTX_TEX3D == TRUE
		TEX3D/= Y;
#endif

#if OBJ_VTX_W == TRUE
		W/= Y;
#endif

#if OBJ_VTX_COLOR == TRUE
		COLOR.r/= Y;
		COLOR.g/= Y;
		COLOR.b/= Y;
		COLOR.a/= Y;
#endif

#if OBJ_VTX_SPEC == TRUE
		SPEC.r/= Y;
		SPEC.g/= Y;
		SPEC.b/= Y;
#endif

#if OBJ_VTX_L == TRUE
		L/= Y;
#endif

		Y = 1.0;

		return TRUE;
	}
	else return FALSE;
}

BOOL GVertex::DivideByZ()
{
	if (Z)
	{
		X/= Z;
		Y/= Z;
		U/= Z;
		V/= Z;

#if OBJ_VTX_TEX3D == TRUE
		TEX3D/= Z;
#endif

#if OBJ_VTX_W == TRUE
		W/= Z;
#endif

#if OBJ_VTX_COLOR == TRUE
		COLOR.r/= Z;
		COLOR.g/= Z;
		COLOR.b/= Z;
		COLOR.a/= Z;
#endif

#if OBJ_VTX_SPEC == TRUE
		SPEC.r/= Z;
		SPEC.g/= Z;
		SPEC.b/= Z;
#endif

#if OBJ_VTX_L == TRUE
		L/= Z;
#endif

		Z = 1.0;

		return TRUE;
	}
	else return FALSE;
}


void GVertex::operator=(GVertex &b)
{
//	memcpy((void*)this, &b, sizeof (class GVertex));
		X = b.X;
		Y = b.Y;
		Z = b.Z;
		U = b.U;
		V = b.V;

#if OBJ_VTX_TEX3D == TRUE
		TEX3D = b.TEX3D;
#endif

#if OBJ_VTX_W == TRUE
		W = b.W;
#endif

#if OBJ_VTX_COLOR == TRUE
		COLOR.r = b.COLOR.r;
		COLOR.g = b.COLOR.g;
		COLOR.b = b.COLOR.b;
		COLOR.a = b.COLOR.a;
#endif

#if OBJ_VTX_SPEC == TRUE
		SPEC.r = b.SPEC.r;
		SPEC.g = b.SPEC.g;
		SPEC.b = b.SPEC.b;
#endif

#if OBJ_VTX_L == TRUE
		L = b.L;
#endif

}

#endif /* GVERTEXMET */
