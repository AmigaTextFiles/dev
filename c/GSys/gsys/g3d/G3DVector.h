
/* Author Anders Kjeldsen */

#ifndef GVECTOR
#define GVECTOR

/* Ok, VECTOR might not be the best word to use */

class GVector
{
public:
	GVector();
	GVector(class GVertex *V1, class GVertex *V2);
	GVector(class GVector *V);
	~GVector() {};

	void PrintfAll();

	BOOL Init(class GVertex *V1, class GVertex *V2);
	BOOL Init(class GVector *V);

//	operator +(class GVector *V1, class GVector V2);
//	BOOL SubVector(class GVector *V);

	BOOL DivideByX();
	BOOL DivideByY();
	BOOL DivideByZ();
	
	BOOL Multiply(float Const);

//	void UpdateVertex(GVertex *Vert);

	float	DeltaX;
	float	DeltaY;
	double	DeltaZ;

#ifdef OBJ_VTX_W
	float	DeltaW;
#endif
	float	DeltaU, DeltaV;

#ifdef OBJ_VTX_TEX3D
	float	DeltaTEX3D;
#endif

#ifdef OBJ_VTX_COLOR
	W3D_Color DeltaCOLOR;
#endif

#ifdef OBJ_VTX_SPEC
	W3D_ColorRGB DeltaSPEC;
#endif

#ifdef OBJ_VTX_L
	float	DeltaL;
#endif

private:
};


#endif /* GVECTOR */