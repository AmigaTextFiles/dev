
/* Author Anders Kjeldsen */

#ifndef GSURFACE
#define GSURFACE

class GSurface
{
public:
	GSurface() {};
	GSurface(STRPTR NAME);
	~GSurface() {};


/* STRUCTURE FROM HERE */

	class GSurface *NextGSurface;

private:

};

#endif /* GSURFACE */