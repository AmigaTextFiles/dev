#include <3d.h>
#include <vecmat.h>

static vm_matrix cscale;    // Clip Space scaling matrix
static vm_matrix camera;    // Camera transformation matrix
static vm_vector campos;    // Camera position vector
static float c_el, c_az;
static float kx, ky;

static float xcenter, ycenter;
static float scale;
static float near_clip;
static int free_point;

static float dist;

void l3_set_camera(float x, float y, float z, float el, float az)
{
	vm_make_camera_mat(&camera, c_el = (float)(el/180.f * M_PI), c_az = (float)(az/180.f*M_PI));
	campos.x = x;
	campos.y = y;
	campos.z = z;
}

void l3_set_camera_pos(float x, float y, float z)
{
	campos.x = x;
	campos.y = y;
	campos.z = z;
}

void l3_move_camera(float delta)
{
	float delta_x = delta * (float)sin((double)c_az);
	float delta_z = delta * (float)cos((double)c_az);

	campos.x += delta_x;
	campos.z += delta_z;
}


void l3_transform_point(vm_vector *op, vm_vector *ip)
{
	vm_vector temp;

	temp.x = ip->x - campos.x;
	temp.y = ip->y - campos.y;
	temp.z = ip->z - campos.z;
	vm_mat_x_vec(op, &camera, &temp);
	op->x *= cscale.a[0][0]; // -
	op->y *= cscale.a[1][1]; // -
}

BOOL l3_check_cell(vm_vector* view, vm_vector* P)
{
/*    vm_vector temp;
	temp.x = P->x - campos.x;
	temp.y = P->y - campos.y;
	temp.z = P->z - campos.z;
	if (vm_vec_dot(view,&temp) < 0) return TRUE;
	else return FALSE;*/
	return l3_check_visible(P, view);
}

void l3_rot_y(vm_vector *v, float angle)
{
	double s = sin(angle * M_PI / 180.0);
	double c = cos(angle * M_PI / 180.0);
	float x,z;

	z = (float)(c*v->z + s*v->x);
	x = (float)(-s*v->z + c*v->x);
	v->x = x;
	v->z = z;
}

BOOL l3_check_visible(vm_vector *P, vm_vector *N)
{
	vm_vector temp;
	temp.x = campos.x - P->x;
	temp.y = campos.y - P->y;
	temp.z = campos.z - P->z;
	if (vm_vec_dot(N,&temp) > 0 ) return TRUE;
	else return FALSE;
}

void l3_set_window(float bx, float by, float width, float height, float near_plane)
{
	//vm_matrix temp;

	if (width<400) dist=512.0;
	else if (width > 400 && width < 700) dist=1024.0;
	else dist=1512.0;

	xcenter = bx + width/2.f;
	ycenter = by + height/2.f;
	near_clip = near_plane;
	vm_mat_identity(&cscale);
	cscale.a[0][0] = dist/width;
	cscale.a[1][1] = dist/height;
	/*vm_mat_x_mat(&temp, &cscale, &camera);
	camera = temp;*/
	kx = width/2.f;
	ky = height/2.f;
}

void l3_code_vertex(vertex* v)
{
	if (v->vec.z > 0.f) v->ccodes = 0; else v->ccodes = CC_BEHIND;
	if (v->vec.x < -v->vec.z)   v->ccodes |= CC_OFF_LEFT;
	if (v->vec.x >  v->vec.z)   v->ccodes |= CC_OFF_RIGHT;
	if (v->vec.y < -v->vec.z)   v->ccodes |= CC_OFF_BOT;
	if (v->vec.y >  v->vec.z)   v->ccodes |= CC_OFF_TOP;
}

static __inline double l3_ct_left(vertex* a, vertex* b)
{
	return -(a->vec.z+a->vec.x)/(b->vec.x-a->vec.x+b->vec.z-a->vec.z);
}

static __inline double l3_ct_right(vertex* a, vertex* b)
{
	return (a->vec.z-a->vec.x)/(b->vec.x-a->vec.x-b->vec.z+a->vec.z);
}

static __inline double l3_ct_top(vertex* a, vertex* b)
{
	return (a->vec.z-a->vec.y)/(b->vec.y-a->vec.y-b->vec.z+a->vec.z);
}

static __inline double l3_ct_bot(vertex* a, vertex* b)
{
	return -(a->vec.z+a->vec.y)/(b->vec.y-a->vec.y+b->vec.z-a->vec.z);
}

void l3_project_vertex(vertex* v)
{
	l3_code_vertex(v);
	if (v->vec.z >= near_clip) {
		float iz = 1.f / v->vec.z;
		v->sx = xcenter + kx*v->vec.x * iz;
		v->sy = ycenter - ky*v->vec.y * iz;
	} else {
		v->sx = xcenter;
		v->sy = ycenter;
	}
}
static void l3_interpolate(int facenum, vertex* o,vertex* a, vertex* b, float t)
{
	o->vec.x = a->vec.x + t*(b->vec.x - a->vec.x);
	o->vec.y = a->vec.y + t*(b->vec.y - a->vec.y);
	o->vec.z = a->vec.z + t*(b->vec.z - a->vec.z);

	o->tcolor.x = a->tcolor.x + t*(b->tcolor.x - a->tcolor.x);
	o->tcolor.y = a->tcolor.y + t*(b->tcolor.y - a->tcolor.y);
	o->tcolor.z = a->tcolor.z + t*(b->tcolor.z - a->tcolor.z);

	if (faces[facenum].type == POLYTYPE_Tex) {
		o->tu = a->tu +t*(b->tu - a->tu);
		o->tv = a->tv +t*(b->tv - a->tv);
	}

	l3_project_vertex(o);
}

#define V(x) vertices[inpt[x]]

int l3_clip_polygon(int **outpt, int facenum, UBYTE codes_or)
{
	int out;
	int p,pt;
	int n = faces[facenum].numedges;
	int *inpt = &(faces[facenum].points[0]);
	static int temp1[30], temp2[30];
	int *op;
	int free_points = MAX_POINTS;

	if (codes_or & CC_OFF_LEFT) {
		op = temp1;
		out = 0; p = n - 1;
		for (pt=0; pt<n; pt++) {
			if (!(V(p).ccodes & CC_OFF_LEFT)) op[out++] = inpt[p];
			if ((V(p).ccodes ^ V(pt).ccodes) & CC_OFF_LEFT) {
				l3_interpolate(facenum, &vertices[free_points++], &vertices[inpt[p]], &vertices[inpt[pt]],
					(float)l3_ct_left(&vertices[inpt[p]], &vertices[inpt[pt]]));
				op[out++] = free_points-1;
			}
			p = pt;
		}
		n=out;
		inpt=op;
	}
	if (codes_or & CC_OFF_RIGHT) {
		if (op == temp2) op = temp1; else op = temp2;
		out = 0; p = n - 1;
		for (pt=0; pt<n; pt++) {
			if (!(V(p).ccodes & CC_OFF_RIGHT)) op[out++] = inpt[p];
			if ((V(p).ccodes ^ V(pt).ccodes) & CC_OFF_RIGHT) {
				l3_interpolate(facenum, &vertices[free_points++], &vertices[inpt[p]], &vertices[inpt[pt]],
					(float)l3_ct_right(&vertices[inpt[p]], &vertices[inpt[pt]]));
				op[out++] = free_points-1;
			}
			p = pt;
		}
		n=out;
		inpt=op;
	}
	if (codes_or & CC_OFF_TOP) {
		if (op == temp2) op = temp1; else op = temp2;
		out = 0; p = n - 1;
		for (pt=0; pt<n; pt++) {
			if (!(V(p).ccodes & CC_OFF_TOP)) op[out++] = inpt[p];
			if ((V(p).ccodes ^ V(pt).ccodes) & CC_OFF_TOP) {
				l3_interpolate(facenum, &vertices[free_points++], &vertices[inpt[p]], &vertices[inpt[pt]],
					(float)l3_ct_top(&vertices[inpt[p]], &vertices[inpt[pt]]));
				op[out++] = free_points-1;
			}
			p = pt;
		}
		n=out;
		inpt=op;
	}
	if (codes_or & CC_OFF_BOT) {
		if (op == temp2) op = temp1; else op = temp2;
		out = 0; p = n - 1;
		for (pt=0; pt<n; pt++) {
			if (!(V(p).ccodes & CC_OFF_BOT)) op[out++] = inpt[p];
			if ((V(p).ccodes ^ V(pt).ccodes) & CC_OFF_BOT) {
				l3_interpolate(facenum, &vertices[free_points++], &vertices[inpt[p]], &vertices[inpt[pt]],
					(float)l3_ct_bot(&vertices[inpt[p]], &vertices[inpt[pt]]));
				op[out++] = free_points-1;
			}
			p = pt;
		}
		n=out;
		inpt=op;
	}
	for (pt=0; pt<n; pt++) {
		if (V(pt).ccodes & CC_BEHIND) {
			return 0;
		}
	}
	*outpt = op;
	return n;
}
