
/* A lot of ripped stuff */

#ifndef G3DQUAT_CPP
#define G3DQUAT_CPP

#include "g3d/G3DQuat.h"

GQuat::GQuat(float rx, float ry, float rz)
{
	Set(rx, ry, rz);
}

GQuat::GQuat()
{
	Set(0.0, 0.0, 0.0);

/*
	x = 0.0;
	y = 0.0;
	z = 0.0;
	w = 1.0;
*/

}

void G3DQuat::Set(float rx, float ry, float rz)
{
	float hyaw		= -rz*.5f;
	float hpitch	= -ry*.5f;
	float hroll		= -rx*.5f;

	float cosYaw = cos(hyaw);
	float sinYaw = sin(hyaw);

	float cosPitch = cos(hpitch);
	float sinPitch = sin(hpitch);

	float cosRoll = cos(hroll);
	float sinRoll = sin(hroll);

	x = sinRoll * cosPitch * cosYaw - cosRoll * sinPitch * sinYaw;
	y = cosRoll * sinPitch * cosYaw + sinRoll * cosPitch * sinYaw;
	z = cosRoll * cosPitch * sinYaw - sinRoll * sinPitch * cosYaw;
	w = cosRoll * cosPitch * cosYaw + sinRoll * sinPitch * sinYaw;
}

void G3DQuat::Set()
{
	memset((void*)this, 0, sizeof (class G3DQuat) );
}

/*
GQuat G3DQuat::operator*(class G3DQuat &a, class Quat &b)
{
	float Ax = a.x;	// ---
	float Ay = a.y;	// --|--
	float Az = a.z;	// --|-|--
	float Aw = a.w;	// - | | |
			// | | | |
	float Bx = b.x;	// - | | |
	float By = b.y;	// --|-|-|
	float Bz = b.z;	// --|--
	float Bw = b.w;	// ---

	QQuat d;
	d.x = Aw*Bx + Ax*Bw + Ay*Bz - Az*By;
	d.y = Aw*By + Ay*Bw + Az*Bx - Ax*Bz;
	d.z = Aw*Bz + Az*Bw + Ax*By - Ay*Bx;
	d.w = Aw*Bw - Ax*Bx - Ay*By - Az*Bz;

	return(d);
}
*/

/*
void G3DQuat::operator*(class G3DQuat &b)
{
	float Ax = x;	// ---
	float Ay = y;	// --|--
	float Az = z;	// --|-|--
	float Aw = w;	// - | | |
			// | | | |
	float Bx = b.x;	// - | | |
	float By = b.y;	// --|-|-|
	float Bz = b.z;	// --|--
	float Bw = b.w;	// ---

	x = Aw*Bx + Ax*Bw + Ay*Bz - Az*By;
	y = Aw*By + Ay*Bw + Az*Bx - Ax*Bz;
	z = Aw*Bz + Az*Bw + Ax*By - Ay*Bx;
	w = Aw*Bw - Ax*Bx - Ay*By - Az*Bz;

}
*/

GQuat operator*(class G3DQuat &a, class G3DQuat &b)
{
	float Ax = a.x;	// ---
	float Ay = a.y;	// --|--
	float Az = a.z;	// --|-|--
	float Aw = a.w;	// - | | |
			// | | | |
	float Bx = b.x;	// - | | |
	float By = b.y;	// --|-|-|
	float Bz = b.z;	// --|--
	float Bw = b.w;	// ---

	GQuat d;
	d.x = Aw*Bx + Ax*Bw + Ay*Bz - Az*By;
	d.y = Aw*By + Ay*Bw + Az*Bx - Ax*Bz;
	d.z = Aw*Bz + Az*Bw + Ax*By - Ay*Bx;
	d.w = Aw*Bw - Ax*Bx - Ay*By - Az*Bz;

	return(d);
}

void G3DQuat::PrintfAll()
{
	printf("X: %f Y: %f Z: %f W: %f \n", x, y, z, w);
}

#endif /* G3DQUAT_CPP */