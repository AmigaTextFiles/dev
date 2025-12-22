
/* Author Anders Kjeldsen */

#ifndef GCAMERA_H
#define GCAMERA_H

#include "g3d/G3DMatrix.h"
#include "g3d/G3DQuat.h"

class G3DCamera
{
public:
	G3DCamera();
	~G3DCamera() {};

	void SetDirection(float Ax, float Ay, float Az);	// Jumps
	void AddDirection(float Ax, float Ay, float Az);	// Rotates
	void MoveForward(float Speed) {} ;

	float GetAxisX() { return AxisX; };
	float GetAxisY() { return AxisY; };
	float GetAxisZ() { return AxisZ; };

	GQuat MainQuat;		// Quat containing new direction and roll/pitch.
	GQuat DiffQuat;		// Quat made from rotation-difference
	GMatrix CamMatrix;	// Matrix ..

	float AxisX, AxisY, AxisZ;		// X, Y, Z
//	float XAngle, YAngle, ZAngle;	// X, Y, Z
	
private:

};

#endif /* GCAMERA_H */

