
#define JMax 4
#define XOFF 200
#define YOFF 100

typedef struct
{
		TFLOAT px,py,pz;
		joint j;
		Matrix	m;
} kinechain;

typedef struct
{
        TAPTR task;
		Matrix mat1;
		Matrix mat2;
		Matrix mat3;
		joint j;			/* Gelenk */
		TFLOAT v[4];
		TFLOAT tmp[4];
		TFLOAT wink[3];

		GenMatrix gmat1;
		GenMatrix gmat2;
		GenMatrix gmat3;
		GenMatrix gmat4;
		GenMatrix gmat5;

		kinechain kc[JMax];

		TFLOAT ex,ey,ez;	/* Endpunkt */
  
		TBOOL check;
		  
		TFLOAT lenght;
		
		TINT xoff;
		TINT yoff;
		TINT baselength;
		TINT basex;
		TINT basey;
		
		TINT swidth;
		TINT sheight; 
		
} world;

