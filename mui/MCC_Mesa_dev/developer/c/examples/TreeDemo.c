#include <stdio.h>
#include <ctype.h>
#include <stdlib.h>
#include <math.h>
#include <proto/intuition.h>
#include <proto/dos.h>
#include <proto/muimaster.h>
#include <libraries/mui.h>
#include <GL/gl.h>
#include <GL/glu.h>
#include <GL/mesadriver.h>
#include <utility/hooks.h>

#include <mui/mesa_mcc.h>

#define PROGNAME "Mesa MCC Tree Demo"

struct Library *MUIMasterBase;
int CXBRK(void) { return(0); }
int _CXBRK(void) { return(0); }
void chkabort(void) {}

AmigaMesaRTLContext ctx;

Object *app,*win,*mesa,*nu_grow,*nu_zoom,*nu_branch,*nu_shorten,
	*nu_twist,*nu_bend,*nu_fan,*nu_grav,*te_stat;

struct MUI_CustomClass *cl_rotmesa;
#define _between(a,x,b) ((x)>=(a) && (x)<=(b))
#define _isinobject(x,y) (_between(_mleft(obj),(x),_mright(obj)) && _between(_mtop(obj),(y),_mbottom(obj)))

float tree_twist,tree_bend,tree_fan,tree_gravity,tree_shorten,
	tree_leafsize;
int tree_branch,tree_depth,tree_fast;

struct rotmesaData
{float rot_x,rot_y; int pressed;} *rmd;

long get1(Object *o,ULONG par)
{
ULONG out=0;
GetAttr(par,(void*)o,&out);
return out;
}

static ULONG __saveds __asm rotmesa_Dispatcher( register __a0 struct IClass *cl,
		register __a2 Object *obj, register __a1 Msg msg )
{
switch( msg->MethodID )
  {
  case OM_NEW:
		{
		struct rotmesaData *data;
		if (!(obj = (Object *)DoSuperMethodA(cl,obj,msg))) return(0);
		data = INST_DATA(cl,obj);
		data->rot_x=20; data->rot_y=30;
		data->pressed=0;
		rmd=data;
		return obj;
		}

	case MUIM_HandleInput:
		{
		struct rotmesaData *data;
		struct MUIP_HandleInput *m=msg;
		static long startx,starty;
		data = INST_DATA(cl,obj);
		if (m->imsg) switch(m->imsg->Class)
	{
	case IDCMP_MOUSEBUTTONS:
      if ((m->imsg->Code==SELECTDOWN)
			&&(_isinobject(m->imsg->MouseX,m->imsg->MouseY)))
       {
		startx=m->imsg->MouseX;
		starty=m->imsg->MouseY;
		data->pressed=1;
		MUI_RequestIDCMP(obj,IDCMP_MOUSEMOVE);
       }
       else if (data->pressed)
		{
		MUI_RejectIDCMP(obj,IDCMP_MOUSEMOVE);
		data->pressed=0;
		}
      break;
   case IDCMP_MOUSEMOVE:
		data->rot_y+=m->imsg->MouseX-startx;
		data->rot_x+=m->imsg->MouseY-starty;
		startx=m->imsg->MouseX;
		starty=m->imsg->MouseY;
		DoMethod(obj,MUIM_Mesa_Redraw);
      break;
	}
		}
	break;

	case MUIM_Setup:
		if (!DoSuperMethodA(cl,obj,msg)) return(FALSE);
		MUI_RequestIDCMP(obj,IDCMP_MOUSEBUTTONS);
		return TRUE;

	case MUIM_Cleanup:
		MUI_RejectIDCMP(obj,IDCMP_MOUSEBUTTONS);
		if (!DoSuperMethodA(cl,obj,msg)) return(FALSE);
		break;
  }
return( DoSuperMethodA( cl, obj, msg ) );
}

#define CYL_SLICES 8
void DrawYCylinder(float r,float h)
{
GLfloat a,x,z;
glBegin(GL_QUAD_STRIP);
for (a=0;a<6.2831;a+=6.283/CYL_SLICES)
	{
	glNormal3f(x=cos(a),0,z=sin(a));
	glVertex3f(r*x,0,r*z);
	glVertex3f(r*x,h,r*z);
	}
glEnd();
}

int DrawTree(float size,int depth)
{
int i;
static GLfloat m[16];
glGetFloatv(GL_MODELVIEW_MATRIX,m);
//printf("[%g %g %g]    Z %g %g %g  X %g %g %g\n",m[4],m[5],m[6],m[0],m[1],m[2],m[8],m[9],m[10]);
//glColor3f(fabs(m[4]),fabs(m[5]),fabs(m[6]));
if (tree_gravity>0)
	{
	glRotatef(-tree_gravity*m[9],1,0,0);
	glRotatef(tree_gravity*m[1],0,0,1);
	}

if (tree_fast) 
	{
	glBegin(GL_LINES);
	glVertex3f(0,0,0);
	glVertex3f(0,size,0);
	glEnd();
	if (depth<2) return;
	}
else
{
if (depth>0)
	{
	glColor3f(1.0,0.4,0.2);
	DrawYCylinder(size/20,size);
	}
else 
	{
	glColor3f(0.1,0.8,0.1);
	glBegin(GL_TRIANGLES);
	glNormal3f(0,0,1);
	glVertex3f(0,0,0);
	glVertex3f(-tree_leafsize,3*tree_leafsize,-tree_leafsize);
	glVertex3f(tree_leafsize,2*tree_leafsize,tree_leafsize);
	glEnd();
	}
}
if (depth<1) return 0;
glTranslatef(0,size,0);
{
float branch_angle=2*tree_fan/(tree_branch-1);
glRotatef(tree_twist,0,1,0);
glRotatef(tree_bend-tree_fan,0,0,1);
size*=tree_shorten;
if (CheckSignal(SIGBREAKF_CTRL_C)) 
	{
	tree_fast=1;
	glDisable(GL_LIGHTING);
	glColor3f(1,0.5,0);
	}
for (i=0;i<tree_branch;i++)
	{
	glPushMatrix();
//	if (DrawTree(size,depth-1-abs(i-(tree_branch/2)))) { glPopMatrix(); return 1;}
	DrawTree(size,depth-1-abs(i-(tree_branch/2)));
	glPopMatrix();
	glRotatef(branch_angle,0,0,1);
	}
}
return 0;
}

void __saveds __asm DrawScene(register __a0 struct Hook *h,
		register __a2 long obj,register __a1 long data)
{
float zoom=get1(nu_zoom,MUIA_Numeric_Value)/100.0;
glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

glMatrixMode(GL_PROJECTION);
glLoadIdentity();
glFrustum(-zoom,zoom,-zoom,zoom,1,10);
glTranslatef(0,0,-3);
glRotatef(rmd->rot_x,1,0,0);
glRotatef(rmd->rot_y,0,1,0);
glMatrixMode(GL_MODELVIEW);

glLoadIdentity();

glEnable(GL_LIGHTING);

tree_twist=get1(nu_twist,MUIA_Numeric_Value);
tree_bend=get1(nu_bend,MUIA_Numeric_Value);
tree_fan=get1(nu_fan,MUIA_Numeric_Value);
tree_gravity=get1(nu_grav,MUIA_Numeric_Value);
tree_shorten=get1(nu_shorten,MUIA_Numeric_Value)/100.0;

tree_branch=get1(nu_branch,MUIA_Numeric_Value);

tree_depth=get1(nu_grow,MUIA_Numeric_Value);
tree_leafsize=0.2*pow(tree_shorten,tree_depth);
tree_fast=0;

glTranslatef(0,-0.8,0);
glPushMatrix();
DrawTree(0.5,tree_depth);
glPopMatrix();

glColor3f(0.4,0.3,0.3);
glBegin(tree_fast?GL_LINE_LOOP:GL_QUADS);
glNormal3f(0,0,1);
glVertex3f(-1,0,-1);
glVertex3f(-1,0,1);
glVertex3f(1,0,1);
glVertex3f(1,0,-1);
glEnd();

glFlush();
}

struct Hook drawscene_hook={{0,0},DrawScene,0,0};


void CreateMesaObject(void)
{
ULONG tags[]={AMRTL_RGBAMode,1,TAG_DONE};

if( !(cl_rotmesa = MUI_CreateCustomClass( NULL, MUIC_Mesa, NULL, 
	sizeof( struct rotmesaData ), rotmesa_Dispatcher ) ) )
return 0;

if (!(mesa=NewObject(cl_rotmesa->mcc_Class,0,
			ReadListFrame,
			MUIA_Mesa_Tags,tags,
			MUIA_Mesa_UseSubtask,TRUE,
			MUIA_Mesa_Base,mesamainBase,
			MUIA_Mesa_DrawHook,&drawscene_hook,
			MUIA_Mesa_ResizeHook,MUIV_Mesa_ResizeHook_DefaultViewport,
			End))
	{
	PrintFault(IoErr(),"Can't create Mesa.mcc object");
	}
else
	{
	GetAttr(MUIA_Mesa_Context,(void*)mesa,(ULONG*)&ctx);
	AmigaMesaRTLMakeCurrent(ctx);
{
GLfloat white[] = { 1.0, 1.0, 1.0, 1.0 };
GLfloat black[] = { 0.0, 0.0, 0.0, 0.0 };
GLfloat lightpos[] = { 4.0, 8.0, 3.0, 0.0 };
GLfloat light_ambient[]= {0.3, 0.3, 0.3, 1.0 };

glClearColor(0.6,0.7,0.8,0);
glEnable(GL_COLOR_MATERIAL);
glLightfv(GL_LIGHT0, GL_SPECULAR, black);
glLightfv(GL_LIGHT0, GL_POSITION, lightpos);
glLightfv(GL_LIGHT0, GL_AMBIENT, light_ambient);
glEnable(GL_LIGHTING);
glEnable(GL_LIGHT0);
glEnable(GL_DEPTH_TEST);
}	
	}
return 0;
}


Object *mySlider(char *label,int min,int max,int val)
{
return SliderObject,
		MUIA_Numeric_Min,min,
		MUIA_Numeric_Max,max,
		MUIA_Numeric_Format,label,
		MUIA_Numeric_Value,val,
		End;
}

////////////////////      MAIN      ///////////////////////

int main(void)
{
ULONG sigs = 0;
MUIMasterBase=OpenLibrary(MUIMASTER_NAME,MUIMASTER_VMIN);
if (!MUIMasterBase) 
	{
	puts("Can't open muimaster.library!");	// what a shame...
	return 10;
	}

CreateMesaObject();
if (mesa)
	{
	app = ApplicationObject,
		MUIA_Application_Title      , PROGNAME,
		MUIA_Application_Version    , "$VER: " PROGNAME " 1.0 (28.08.98)",
		MUIA_Application_Copyright  , "©1998, Szymon Ulatowski",
		MUIA_Application_Author     , "Szymon Ulatowski",
		MUIA_Application_Description, "Mesa Class 'Tree' Demo",
		MUIA_Application_Base       , "MESADEMO2",
		SubWindow,win=WindowObject,
			MUIA_Window_Title, PROGNAME,
			MUIA_Window_ID   , 'WIN1',
			WindowContents, HGroup,
				Child,mesa,	// mesa object is here!
				Child,BalanceObject,End,
				Child,VGroup,
					MUIA_Weight,25,
					Child,nu_zoom=mySlider("Zoom:%ld",10,100,60),
					Child,HVSpace,
					Child,nu_grow=mySlider("Grow:%ld",0,9,3),
					Child,nu_shorten=mySlider("Shorten:%ld%%",50,90,75),
					Child,nu_branch=mySlider("Branch:%ld",2,5,2),
					Child,nu_twist=mySlider("Twist:%ld",0,100,0),
					Child,nu_bend=mySlider("Bend:%ld",-40,40,0),
					Child,nu_fan=mySlider("Fan:%ld",0,100,30),
					Child,nu_grav=mySlider("Gravity:%ld",0,100,0),
					Child,HVSpace,
					Child,te_stat=TextObject,TextFrame,
							MUIA_Background,MUII_TextBack,
							End,
					End,
				End,
			End,
		End;

	if (app)
		{
		DoMethod(win,MUIM_Notify,MUIA_Window_CloseRequest,TRUE,
			app,2,MUIM_Application_ReturnID,MUIV_Application_ReturnID_Quit);

	// every control sends MUIM_Mesa_Redraw

		DoMethod(nu_zoom,MUIM_Notify,MUIA_Numeric_Value,MUIV_EveryTime,mesa,1,MUIM_Mesa_Redraw);
		DoMethod(nu_grow,MUIM_Notify,MUIA_Numeric_Value,MUIV_EveryTime,mesa,1,MUIM_Mesa_Redraw);
		DoMethod(nu_twist,MUIM_Notify,MUIA_Numeric_Value,MUIV_EveryTime,mesa,1,MUIM_Mesa_Redraw);
		DoMethod(nu_bend,MUIM_Notify,MUIA_Numeric_Value,MUIV_EveryTime,mesa,1,MUIM_Mesa_Redraw);
		DoMethod(nu_fan,MUIM_Notify,MUIA_Numeric_Value,MUIV_EveryTime,mesa,1,MUIM_Mesa_Redraw);
		DoMethod(nu_grav,MUIM_Notify,MUIA_Numeric_Value,MUIV_EveryTime,mesa,1,MUIM_Mesa_Redraw);
		DoMethod(nu_branch,MUIM_Notify,MUIA_Numeric_Value,MUIV_EveryTime,mesa,1,MUIM_Mesa_Redraw);
		DoMethod(nu_shorten,MUIM_Notify,MUIA_Numeric_Value,MUIV_EveryTime,mesa,1,MUIM_Mesa_Redraw);

	// display state will be shown in status field
		DoMethod(mesa,MUIM_Notify,MUIA_Mesa_Display,MUIV_Mesa_Display_OK,
			te_stat,3,MUIM_Set,MUIA_Text_Contents,"OK");
		DoMethod(mesa,MUIM_Notify,MUIA_Mesa_Display,MUIV_Mesa_Display_Unable,
			te_stat,3,MUIM_Set,MUIA_Text_Contents,"Unable");
		DoMethod(mesa,MUIM_Notify,MUIA_Mesa_Display,MUIV_Mesa_Display_Waiting,
			te_stat,3,MUIM_Set,MUIA_Text_Contents,"Waiting");

		SetAttrs(win,MUIA_Window_Open,TRUE,0);	

	// VERY standard main loop
		while (DoMethod(app,MUIM_Application_NewInput,&sigs) != MUIV_Application_ReturnID_Quit)
		if (sigs) {sigs = Wait(sigs | SIGBREAKF_CTRL_C); if (sigs & SIGBREAKF_CTRL_C) break;}

		MUI_DisposeObject(app);
		} else puts("MUI can't create application!\n");
	}
if (cl_rotmesa) MUI_DeleteCustomClass( cl_rotmesa );
CloseLibrary(MUIMasterBase);
return 0;
}
