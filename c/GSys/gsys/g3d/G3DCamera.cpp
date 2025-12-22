
/* Author Anders Kjeldsen */

#ifndef GCAMERA_CPP
#define GCAMERA_CPP

#include "g3d/G3DCamera.h"
#include "g3d/G3DMatrix.cpp"
#include "g3d/G3DQuat.cpp"


G3DCamera::G3DCamera()
{
	memset((void *)this, 0, sizeof (class G3DCamera) );
	CamMatrix.SetIdentity();
}


void G3DCamera::SetDirection(float Ax, float Ay, float Az)
{
	MainQuat.Set(Ax, Ay, Az);
	CamMatrix = MainQuat;
}

void G3DCamera::AddDirection(float Ax, float Ay, float Az)
{
	
	DiffQuat.Set(Ax, Ay, Az);
	MainQuat = DiffQuat * MainQuat;
	CamMatrix = MainQuat;
}

#endif /* G3DCAMERA_CPP */