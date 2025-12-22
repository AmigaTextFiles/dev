
/* Author Anders Kjeldsen */

#ifndef GVERTEX
#define GVERTEX


class GVertex
{
public:
	GVertex();
	~GVertex() {};
	
	void PrintfAll();

// OBSOLETE (Don't use in the future!)
	BOOL CopyVertex(class GVertex *Destination);
	BOOL AddVector(class GVector *Source);
// OBSOLETE END

// USE THESE
	BOOL DivideByX();
	BOOL DivideByY();
	BOOL DivideByZ();
	void operator=(GVertex &b);

/*
	GVertex operator *(GVertex &V1, float t)
	GVertex operator -(class GVertex &V1, class GVertex &V2)
	GVertex operator +(class GVertex &V1, class GVertex &V2)
*/

        float	X;
	float	Y;
	double	Z;
#ifdef OBJ_VTX_W
	float	W;
#endif

	float		U, V; 

#ifdef OBJ_VTX_TEX3D
	float		TEX3D;
#endif

#ifdef OBJ_VTX_COLOR
	W3D_Color 	COLOR;
#endif

#ifdef OBJ_VTX_SPEC
	W3D_ColorRGB 	SPEC;
#endif

#ifdef OBJ_VTX_L
	float		L;
#endif


private:

};

#endif /* GVERTEX */