
/* Author Anders Kjeldsen */

#ifndef G3DOBJECT_H
#define G3DOBJECT_H

#include "ggraphics/GScreen.h"
#include "g3d/G3DPolygon.h"
#include "g3d/G3DQuat.h"

class G3DObject
{
public:

	GObject() {};
	GObject(STRPTR FileName);
	~GObject() {};

	void MakeMatrix() {};
	
	void ClipPolygons(class GScreen *GScreen);	// this parameter is temp only!
	void Rotate(class G3DCamera *GCamera);
	void SortPolygons();
	void DrawPolygons();

	void SetDirection(float Ax, float Ay, float Az);	// Jumps
	void AddDirection(float Ax, float Ay, float Az);	// Rotates

	void SetAngles(float Ax, float Ay, float Az)
	{
		Anglex = Ax;
		Angley = Ay;
		Anglez = Az;
	}
	void AddAngles(float Ax, float Ay, float Az)
	{
		Anglex+= Ax;
		Angley+= Ay;
		Anglez+= Az;
	}

	void SetPosition(double px, double py, double pz);
	void AddPosition(double px, double py, double pz);

	void SetGScreen(class GScreen *s) { GScreen = s; };

/* STRUCTURE FROM HERE */

	class GScreen *GScreen;	/* The screen used to draw stuff */
	class G3DPolygon *GPolygons;		/* Triangles */

	class G3DQuat ObjQuat;
	class G3DQuat DiffQuat;

	double AxisX, AxisY, AxisZ;
	float Anglex, Angley, Anglez;

/* STRUCTURE TO HERE */

private:

};

#endif /* G3DOBJECT */
