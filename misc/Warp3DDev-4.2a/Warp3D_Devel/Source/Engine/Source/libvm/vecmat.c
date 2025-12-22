#include <math.h>
#include <stdio.h>
#include "vecmat.h"

void vm_mat_x_mat(vm_matrix* out, vm_matrix* a, vm_matrix* b)
{
	int i,j;
	for (i=0; i<3; i++) {
		for (j=0; j<3; j++) {
			out->a[i][j] = a->a[i][0] * b->a[0][j] +
						   a->a[i][1] * b->a[1][j] +
						   a->a[i][2] * b->a[2][j];
		}
	}
}

void vm_make_camera_mat(vm_matrix *cam, float el, float az)
{

	float
		sinel = (float)sin(el),
		cosel = (float)cos(el),
		sinaz = (float)sin(az),
		cosaz = (float)cos(az);

	vm_mat_set(cam,
		cosaz,
		0.0,
		-sinaz,
		-sinel*sinaz,
		cosel,
		-sinel*cosaz,
		cosel*sinaz,
		sinel,
		cosel*cosaz);
}

