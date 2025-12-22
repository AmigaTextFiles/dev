/*
 * <one line to give the program's name and a brief idea of what it does.>
 * Copyright (C) 1998  Niels Froehling <Niels.Froehling@Informatik.Uni-Oldenburg.de>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 */

#define	LIBQDISPLAY_CORE
#include "../include/libqdisplay.h"

#define DOT_VEC_DBL(a1, a2, a3, b1, b2, b3) ((vec1D)(a1 * b1 + a2 * b2 + a3 * b3))

vec3D currentSpeed;

staticvar const vec1D nearClip = 0.01, nearCode = 16.0;

/* this sets the viewable part of the buffer */
void set_clip_values(int offsX, int offsY, int sizeX, int sizeY)
{
  int width = actView->viewDim->Width;
  int height = actView->viewDim->Height;

  actView->clipXLow = offsX - 32768;		/* fixed-p? */
  actView->clipXHigh = (sizeX << 16) - 32768;	/* fixed-p? */
  actView->clipYLow = offsY - 32768;		/* fixed-p? */
  actView->clipYHigh = (sizeY << 16) - 32768;	/* fixed-p? */
  actView->projScaleX = (width >> 1);
  actView->projScaleY = ((width >> 1) * height) / (width * 0.75);
  actView->xCenter = -0.5 + (width >> 1);
  actView->yCenter = -0.5 + (height >> 1);
  actView->clipScaleX = 1.0 / (width >> 1);
  actView->clipScaleY = 1.0 / (height >> 1);
  actView->incSpeed = width * (2 / 91.5);
  actView->maxSpeed = width * (2 / 22.5);
  actView->decSpeed = actView->incSpeed * (2 / 1.5);
}

void set_view_info(void)
{
  /* compute rotation matrix */
  if (actView->viewCamera.changedAngles) {
    /*
     * the main matrix is the representation of the three vectors
     * that makes the lokal coordinate-system, called local-axis
     */
    if (!actView->viewCamera.cameraAngles.ty) {
      actView->viewCamera.mainMatrix[0][0] =  cosTable[actView->viewCamera.cameraAngles.tz];
      actView->viewCamera.mainMatrix[0][1] = -sinTable[actView->viewCamera.cameraAngles.tz];
      actView->viewCamera.mainMatrix[0][2] =  0;
      actView->viewCamera.mainMatrix[1][0] =  sinTable[actView->viewCamera.cameraAngles.tz] *  sinTable[actView->viewCamera.cameraAngles.tx];
      actView->viewCamera.mainMatrix[1][1] =  cosTable[actView->viewCamera.cameraAngles.tz] *  sinTable[actView->viewCamera.cameraAngles.tx];
      actView->viewCamera.mainMatrix[1][2] = 						       cosTable[actView->viewCamera.cameraAngles.tx];
      actView->viewCamera.mainMatrix[2][0] =  sinTable[actView->viewCamera.cameraAngles.tz] *  cosTable[actView->viewCamera.cameraAngles.tx];
      actView->viewCamera.mainMatrix[2][1] =  cosTable[actView->viewCamera.cameraAngles.tz] *  cosTable[actView->viewCamera.cameraAngles.tx];
      actView->viewCamera.mainMatrix[2][2] = 						      -sinTable[actView->viewCamera.cameraAngles.tx];

      actView->viewCamera.changedAngles = FALSE;
    }
    else {
      actView->viewCamera.mainMatrix[0][0] =  cosTable[actView->viewCamera.cameraAngles.tz] * 				    cosTable[actView->viewCamera.cameraAngles.ty] + sinTable[actView->viewCamera.cameraAngles.tz] * sinTable[actView->viewCamera.cameraAngles.tx] * sinTable[actView->viewCamera.cameraAngles.ty];
      actView->viewCamera.mainMatrix[0][1] = -sinTable[actView->viewCamera.cameraAngles.tz] * 				    cosTable[actView->viewCamera.cameraAngles.ty] + cosTable[actView->viewCamera.cameraAngles.tz] * sinTable[actView->viewCamera.cameraAngles.tx] * sinTable[actView->viewCamera.cameraAngles.ty];
      actView->viewCamera.mainMatrix[0][2] = 			       cosTable[actView->viewCamera.cameraAngles.tx] *  sinTable[actView->viewCamera.cameraAngles.ty];
      actView->viewCamera.mainMatrix[1][0] =  cosTable[actView->viewCamera.cameraAngles.tz] * 				   -sinTable[actView->viewCamera.cameraAngles.ty] + sinTable[actView->viewCamera.cameraAngles.tz] * sinTable[actView->viewCamera.cameraAngles.tx] * cosTable[actView->viewCamera.cameraAngles.ty];
      actView->viewCamera.mainMatrix[1][1] = -sinTable[actView->viewCamera.cameraAngles.tz] * 				   -sinTable[actView->viewCamera.cameraAngles.ty] + cosTable[actView->viewCamera.cameraAngles.tz] * sinTable[actView->viewCamera.cameraAngles.tx] * cosTable[actView->viewCamera.cameraAngles.ty];
      actView->viewCamera.mainMatrix[1][2] = 			       cosTable[actView->viewCamera.cameraAngles.tx] *  cosTable[actView->viewCamera.cameraAngles.ty];
      actView->viewCamera.mainMatrix[2][0] =  sinTable[actView->viewCamera.cameraAngles.tz] *  cosTable[actView->viewCamera.cameraAngles.tx];
      actView->viewCamera.mainMatrix[2][1] =  cosTable[actView->viewCamera.cameraAngles.tz] *  cosTable[actView->viewCamera.cameraAngles.tx];
      actView->viewCamera.mainMatrix[2][2] = 			      -sinTable[actView->viewCamera.cameraAngles.tx];

      if ((actView->viewCamera.cameraAngles.ty > 1) && (actView->viewCamera.cameraAngles.ty <= 45))
	actView->viewCamera.cameraAngles.ty -= ((actView->viewCamera.cameraAngles.ty - 0) / 6) + 1;
      else if ((actView->viewCamera.cameraAngles.ty >= 315) && (actView->viewCamera.cameraAngles.ty < 359))
	actView->viewCamera.cameraAngles.ty += ((360 - actView->viewCamera.cameraAngles.ty) / 6) + 1;
      else
	actView->viewCamera.cameraAngles.ty = 0;
    }

    __memcpy(actView->viewCamera.viewMatrix, actView->viewCamera.mainMatrix, sizeof(actView->viewCamera.viewMatrix));
    /*
     * the view-matrix is the perspective correction of the main
     * matrix in advance of the screen-ratio
     */
    actView->viewCamera.viewMatrix[0][0] *= actView->projScaleX;
    actView->viewCamera.viewMatrix[0][1] *= actView->projScaleX;
    actView->viewCamera.viewMatrix[0][2] *= actView->projScaleX;
    actView->viewCamera.viewMatrix[1][0] *= actView->projScaleY;
    actView->viewCamera.viewMatrix[1][1] *= actView->projScaleY;
    actView->viewCamera.viewMatrix[1][2] *= actView->projScaleY;
    /*actView->viewCamera.viewMatrix[2][0] *= actView->projScaleZ; */
    /*actView->viewCamera.viewMatrix[2][1] *= actView->projScaleZ; */
    /*actView->viewCamera.viewMatrix[2][2] *= actView->projScaleZ; */

    actView->viewCamera.changedMatrix = TRUE;
  }

  if (actView->viewCamera.changedLocation) {
    /*
     * so (1,0,0) in camera space maps to viewMatrix[0] in world space.
     * thus we multiply on the right by a worldspace vector to transform
     * it to camera space.
     * now, to account for translation, we just subtract the camera
     * Center before multiplying
     */
    actView->viewCamera.translate[0] = actView->viewCamera.cameraLocation[0];
    actView->viewCamera.translate[1] = actView->viewCamera.cameraLocation[1];
    actView->viewCamera.translate[2] = actView->viewCamera.cameraLocation[2];

    if ((currentSpeed[0] != 0) || (currentSpeed[2] != 0)) {
      actView->viewCamera.cameraLocation[0] += -actView->viewCamera.mainMatrix[0][1] * currentSpeed[0];
      actView->viewCamera.cameraLocation[1] +=  actView->viewCamera.mainMatrix[0][0] * currentSpeed[0];
      actView->viewCamera.cameraLocation[2] +=  actView->viewCamera.mainMatrix[1][2] * currentSpeed[2];

      if (currentSpeed[0] > actView->viewCamera.decSpeed)
	currentSpeed[0] -= actView->viewCamera.decSpeed;
      else if (currentSpeed[0] < -actView->viewCamera.decSpeed)
	currentSpeed[0] += actView->viewCamera.decSpeed;
      else
	currentSpeed[0] = 0.0;

      if (currentSpeed[2] > actView->viewCamera.decSpeed)
	currentSpeed[2] -= actView->viewCamera.decSpeed;
      else if (currentSpeed[2] < -actView->viewCamera.decSpeed)
	currentSpeed[2] += actView->viewCamera.decSpeed;
      else
	currentSpeed[2] = 0.0;
    }
    else
      actView->viewCamera.changedLocation = FALSE;					/* release only if we really stop */
  }
}

vec1D dist2_from_viewer(vec1D *in)
{
  vec3D temp;

  VectorSubtract(in, actView->viewCamera.cameraLocation, temp);

  return VectorDist(temp);
}

#if 0								/* this works if IEEE and, sizeof(vec1D) == sizeof(int) */
#define FLOAT_POSITIVE(x)   (*((int *)(&x)) >= 0)
#else
#define FLOAT_POSITIVE(x)   ((x) >= 0)
#endif

/*
 * the view-frustum are four planes that shoot from the camera-point
 * in a direction that is the visible area
 * everything between the four planes (the frustum) is visible
 * this is called frustum-culling
 *
 * we form the four planes with four vectors (-1,0,1), (1,0,1), (0,1,1), (0,-1,1)
 * with the cameras position as origin
 * we use the hesse-normal-form
 *
 * in screen-space the z-coordinate is tht one that goes into the monitor
 * y- and x-coordinate are the same as the screens coordinate, (0,0,0) is exactly
 * in the middle of and on the screen
 */
void compute_view_frustrum(void)
{
  if (actView->viewCamera.changedMatrix) {
    /*
     * why are the normals not normalized? (is the mainMatrix normalized?) the length are sqrt(2) instead of 1
     * what means the dists?
     * what is the direction of the normals (into the screen-space or out of?)?
     */
    actView->viewCamera.planes[0].positive[0] = FLOAT_POSITIVE(
	actView->viewCamera.planes[0].normal[0] = -actView->viewCamera.mainMatrix[0][0] 				      + actView->viewCamera.mainMatrix[2][0]);
    actView->viewCamera.planes[0].positive[1] = FLOAT_POSITIVE(
	actView->viewCamera.planes[0].normal[1] = -actView->viewCamera.mainMatrix[0][1] 				      + actView->viewCamera.mainMatrix[2][1]);
    actView->viewCamera.planes[0].positive[2] = FLOAT_POSITIVE(
	actView->viewCamera.planes[0].normal[2] = -actView->viewCamera.mainMatrix[0][2] 				      + actView->viewCamera.mainMatrix[2][2]);
    actView->viewCamera.planes[1].positive[0] = FLOAT_POSITIVE(
	actView->viewCamera.planes[1].normal[0] =  actView->viewCamera.mainMatrix[0][0] 				      + actView->viewCamera.mainMatrix[2][0]);
    actView->viewCamera.planes[1].positive[1] = FLOAT_POSITIVE(
	actView->viewCamera.planes[1].normal[1] =  actView->viewCamera.mainMatrix[0][1] 				      + actView->viewCamera.mainMatrix[2][1]);
    actView->viewCamera.planes[1].positive[2] = FLOAT_POSITIVE(
	actView->viewCamera.planes[1].normal[2] =  actView->viewCamera.mainMatrix[0][2] 				      + actView->viewCamera.mainMatrix[2][2]);
    actView->viewCamera.planes[2].positive[0] = FLOAT_POSITIVE(
	actView->viewCamera.planes[2].normal[0] = 					 actView->viewCamera.mainMatrix[1][0] + actView->viewCamera.mainMatrix[2][0]);
    actView->viewCamera.planes[2].positive[1] = FLOAT_POSITIVE(
	actView->viewCamera.planes[2].normal[1] = 					 actView->viewCamera.mainMatrix[1][1] + actView->viewCamera.mainMatrix[2][1]);
    actView->viewCamera.planes[2].positive[2] = FLOAT_POSITIVE(
	actView->viewCamera.planes[2].normal[2] = 					 actView->viewCamera.mainMatrix[1][2] + actView->viewCamera.mainMatrix[2][2]);
    actView->viewCamera.planes[3].positive[0] = FLOAT_POSITIVE(
	actView->viewCamera.planes[3].normal[0] = 					-actView->viewCamera.mainMatrix[1][0] + actView->viewCamera.mainMatrix[2][0]);
    actView->viewCamera.planes[3].positive[1] = FLOAT_POSITIVE(
	actView->viewCamera.planes[3].normal[1] = 					-actView->viewCamera.mainMatrix[1][1] + actView->viewCamera.mainMatrix[2][1]);
    actView->viewCamera.planes[3].positive[2] = FLOAT_POSITIVE(
	actView->viewCamera.planes[3].normal[2] = 					-actView->viewCamera.mainMatrix[1][2] + actView->viewCamera.mainMatrix[2][2]);
  }

  if (actView->viewCamera.changedMatrix || actView->viewCamera.changedLocation) {
    /*
     * we move the planes to the cameras position, up to now the distance to
     * the origin is 0 so 
     *  DotProduct(frustumNormal, point) + frustumDistance
     * gives
     *  DotProduct(frustumNormal, point)
     *
     * why do we move it to cameras position?
     * why is the dist not -DotProduct(frustumNormal, point) as it should be?
     * is this correct??? I think the length of the cameras vector must
     * be the distance for all planes[?].dist, and for all equal
     *  VectorLength(cameraLocation)
     */
    actView->viewCamera.planes[0].dist = DotProduct(actView->viewCamera.planes[0].normal, actView->viewCamera.cameraLocation);
    actView->viewCamera.planes[1].dist = DotProduct(actView->viewCamera.planes[1].normal, actView->viewCamera.cameraLocation);
    actView->viewCamera.planes[2].dist = DotProduct(actView->viewCamera.planes[2].normal, actView->viewCamera.cameraLocation);
    actView->viewCamera.planes[3].dist = DotProduct(actView->viewCamera.planes[3].normal, actView->viewCamera.cameraLocation);
  }

  actView->viewCamera.changedMatrix = FALSE;
}

/*
 * we transform the world-axis-vector to the local-axis-vector
 * without take attention to the camera-position
 */
void transform_vector(vec1D *out, vec1D *in)
{
  out[0] = DotProduct(actView->viewCamera.viewMatrix[0], in);
  out[1] = DotProduct(actView->viewCamera.viewMatrix[1], in);
  out[2] = DotProduct(actView->viewCamera.viewMatrix[2], in);
}

/*
 * we transform the world-axis-vector to the local-axis-vector
 * with previous camera-position correction
 */
void transform_point_raw(vec1D *out, vec1D *in)
{
  vec3D temp;

  VectorSubtract(in, actView->viewCamera.translate, temp);
  out[0] = DotProduct(actView->viewCamera.viewMatrix[0], temp);
  out[1] = DotProduct(actView->viewCamera.viewMatrix[1], temp);
  out[2] = DotProduct(actView->viewCamera.viewMatrix[2], temp);
}

staticfnc void project_point(point_3d * p)
{
  if (p->p[2] >= nearClip) {
    double div = 1.0 / p->p[2];

    p->sx = FLOAT_TO_FIX( p->p[0] * div + actView->xCenter);
    p->sy = FLOAT_TO_FIX(-p->p[1] * div + actView->yCenter);
  }
}

staticfnc void code_point(point_3d * p)
{
  if (p->p[2] >= nearCode) {
    /* if point is far enough away, code in 2d from fixedpoint (faster) */
    if (p->sx < actView->clipXLow)
      p->ccodes = CC_OFF_LEFT;
    else if (p->sx > actView->clipXHigh)
      p->ccodes = CC_OFF_RIGHT;
    else
      p->ccodes = 0;
    if (p->sy < actView->clipYLow)
      p->ccodes |= CC_OFF_TOP;
    else if (p->sy > actView->clipYHigh)
      p->ccodes |= CC_OFF_BOT;
  }
  else {
    p->ccodes = (p->p[2] > 0) ? 0 : CC_BEHIND;
    if (p->p[0] * actView->clipScaleX < -p->p[2])
      p->ccodes |= CC_OFF_LEFT;
    if (p->p[0] * actView->clipScaleX >  p->p[2])
      p->ccodes |= CC_OFF_RIGHT;
    if (p->p[1] * actView->clipScaleY >  p->p[2])
      p->ccodes |= CC_OFF_TOP;
    if (p->p[1] * actView->clipScaleY < -p->p[2])
      p->ccodes |= CC_OFF_BOT;
  }
}

void transform_point(point_3d * p, vec1D *v)
{
  transform_point_raw(p->p, v);
  project_point(p);
  code_point(p);
}

void transform_rotated_point(point_3d * p)
{
  project_point(p);
  code_point(p);
}
