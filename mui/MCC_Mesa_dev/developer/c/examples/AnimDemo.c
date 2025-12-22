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

#define PROGNAME "Mesa MCC Animation Demo"

struct Library *MUIMasterBase;
int CXBRK(void) { return(0); }
int _CXBRK(void) { return(0); }
void chkabort(void) {}

Object *app,*win,*group,*child;

struct MUI_CustomClass *cl_animlogo;

GLfloat logo_ankh_points[]=
{ // 0 - 16

                -0.712702,0.331413, 
                -0.145484,0.27033, 
                -0.32983,0.575737, 
                -0.32983, 0.860783, 
                -0.145484, 1.00331, 
                0.095583, 1.04403, 
                0.32247, 0.962587, 
                0.435913, 0.758981, 
                0.350831, 0.535015, 
                0.166487, 0.209249, 
                0.86133, 0.351773, 
                0.86133, -0.075797, 
                0.152308, 0.005645, 
                0.23739, -1.0531,
                -0.32983, -1.03274, 
                -0.159666, 0.026005, 
                -0.854508, -0.035075, 

	// 17-22

                0.0105, 0.453575, 
                -0.131302, 0.718261, 
                -0.046219, 0.840423, 
                0.081404, 0.860783, 
                0.180669, 0.779341, 
                0.138126, 0.616457,

};

long logo_ankh[]=
{
(long)&logo_ankh_points,
// face points
	5,		0,1,9,15,16,
	5,		9,10,11,12,15,
	4,		12,13,14,15,
	5,		1,2,3,18,17,
	4,		3,4,19,18,
	5,		4,5,6,20,19,
	4,		6,7,21,20,
	4,		7,8,22,21,
	4,		8,9,17,22,
	3,		17,9,1,
	0,
// outline points
	18,	0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,0,
	7,		17,22,21,20,19,18,17,
	0,
};

GLfloat logo_spiral_points[]=
{ // 0-15
        -0.981845,-0.757512, 
        -0.543997,0.932429, 
        0.983813, 0.363851, 
        0.424858, -0.931245, 
        -0.478785, -0.489017, 
        0.005643, 0.363851, 
        0.480753, 0.016386, 
        0.070853, -0.394254, 
        -0.068885, -0.236315, 
        0.191959, -0.015201, 
        0.052221, 0.079561, 
        -0.189993, -0.346871, 
        0.238539, -0.583781, 
        0.64844, 0.253294, 
        -0.348363, 0.584965, 
        -0.693053, -0.852276, 
};

long logo_spiral[]=
{
(long)&logo_spiral_points,
// face points
	4,		0,1,14,15,
	4,		1,2,13,14,
	4,		2,3,12,13,
	4,		3,4,11,12,
	4,		4,5,10,11,
	4,		5,6,9,10,
	4,		6,7,8,9,
	0,
// outline points
	17,		0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,0,
	0,
};

GLfloat logo_astronaut_points[]=
{ // 0-12
        0.094788, 0.240857, 
        0.548537, -0.325452, 
        0.179867, -0.150166, 
        0.10424, -0.810859, 
        0.312209, -0.945694, 
        -0.368414, -0.945694, 
        -0.132087, -0.824342, 
        -0.141541, -0.150166, 
        -0.453493, -0.338935, 
        0.000255, 0.227374, 
        -0.160447, 0.44311, 
        0.056975, 0.591429, 
        0.264943, 0.470077, 
// 13-28
        -0.207711,0.308274, 
        -0.38732,0.510527, 
        -0.245524,0.712781, 
        0.066428,0.780198, 
        0.359475, 0.712781, 
        0.472912, 0.497044, 
        0.264943, 0.321758, 
        0.302757, 0.240857, 
        0.548537, 0.348725, 
        0.633615, 0.63188, 
        0.359475, 0.8611, 
        0.066428, 0.942, 
        -0.302242, 0.834133, 
        -0.538571, 0.618396, 
        -0.462945, 0.362208, 
        -0.207711, 0.21389, 
};

long logo_astronaut[]=
{
(long)&logo_astronaut_points,
// face points
	3,		0,1,2,
	4,		3,4,5,6,
	5,		0,9,10,11,12,
	3,		7,8,9,
	6,		0,2,3,6,7,9,

	5,		28,27,26,14,13,
	4,		26,25,15,14,
	4,		25,24,16,15,
	4,		24,23,17,16,
	4,		23,22,18,17,
	5,		22,21,20,19,18,
	0,
// outline points
	14,	0,1,2,3,4,5,6,7,8,9,10,11,12,0,
	17,	28,27,26,25,24,23,22,21,20,19,18,17,16,15,14,13,28,
	0,
};

#define MUIA_animlogo_logo			0xbacafaca
#define MUIA_animlogo_background	0xbacafacb
#define MUIA_animlogo_frontface	0xbacafacc
#define MUIA_animlogo_backface	0xbacafacd
#define MUIA_animlogo_sideface	0xbacaface

struct animlogoData
{
long *logo;
struct Hook drawhook;
struct Library *mesa;
Object *obj;
GLfloat time,time2;
struct MUI_InputHandlerNode ihnode;
long background,front,back,side;
};

#define GETRED(x) (((UBYTE*)&(x))[1]/255.0)
#define GETGREEN(x) (((UBYTE*)&(x))[2]/255.0)
#define GETBLUE(x) (((UBYTE*)&(x))[3]/255.0)

#define GETCOLOR(x) GETRED(x),GETGREEN(x),GETBLUE(x)

long get1(Object *o,ULONG par)
{
ULONG out=0;
GetAttr(par,(void*)o,&out);
return out;
}

struct glFrustumArgs {
		GLdouble le;
		GLdouble ri;
		GLdouble bo;
		GLdouble to;
		GLdouble ne;
		GLdouble fa;
};
#pragma libcall mesamainBase glFrustumA 156 801

#define glFrustum(left,right,bottom,top,near_val,far_val);	\
{	\
struct glFrustumArgs args;	\
	args.le = left;			\
	args.ri = right;			\
	args.bo = bottom;			\
	args.to = top;				\
	args.ne = near_val;		\
	args.fa = far_val;		\
	glFrustumA(&args);		\
}

animlogo_init(struct animlogoData *data)
{
struct Library *mesamainBase=data->mesa;
struct Library *mesadriverBase=get1(data->obj,MUIA_Mesa_DriverBase);
static GLfloat lightpos[]={1,1,-3,0};
AmigaMesaRTLMakeCurrent(get1(data->obj,MUIA_Mesa_Context));

glMatrixMode(GL_PROJECTION);
glLoadIdentity();
glFrustum(-0.4,0.4,-0.4,0.4,1,5);
glTranslatef(0,0,-3);
glMatrixMode(GL_MODELVIEW);

glEnable(GL_LIGHTING);
glEnable(GL_LIGHT0);
glEnable(GL_DEPTH_TEST);
glEnable(GL_COLOR_MATERIAL);
glLightfv(GL_LIGHT0,GL_POSITION,lightpos);
glShadeModel(GL_FLAT);
glEnable(GL_CULL_FACE);
}

void __saveds __asm animlogo_draw(register __a0 struct Hook *h,
		register __a2 long obj,register __a1 long dummy)
{
struct animlogoData *data=h->h_Data;
struct Library *mesamainBase=data->mesa;
int i,n;
long *d;
GLfloat *fl=(GLfloat*)data->logo[0],*p;

glLoadIdentity();
if ((data->time+=7)>360) data->time-=360;
glRotatef(data->time,0,1,0);
if ((data->time2+=3)>360) data->time2-=360;
glRotatef(30*sin(data->time2/57.3),0,0,1);

glClearColor(GETCOLOR(data->background),0);
glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

glDisable(GL_NORMALIZE);
glColor3f(GETCOLOR(data->front));
glNormal3f(0,0,-1);
glCullFace(GL_FRONT);
d=data->logo;
d++;
while (n=*(d++))
	{
	glBegin(GL_POLYGON);
	for (i=0;i<n;i++,d++)
		{
		glVertex3f(fl[2*(*d)],fl[2*(*d)+1],0.1);
		}
	glEnd();
	}


glColor3f(GETCOLOR(data->back));
glCullFace(GL_BACK);
glNormal3f(0,0,1);
d=data->logo;
d++;
while (n=*(d++))
	{
	glBegin(GL_POLYGON);
	for (i=0;i<n;i++,d++)
		{
		glVertex3f(fl[2*(*d)],fl[2*(*d)+1],0);
		}
	glEnd();
	}


glColor3f(GETCOLOR(data->side));
glEnable(GL_NORMALIZE);
while (n=*(d++))
	{
	glBegin(GL_QUAD_STRIP);
	for (i=0;i<n;i++,d++)
		{
		p=fl+2*(*d);
		glVertex3f(p[0],p[1],0);
		glVertex3f(p[0],p[1],0.1);
		glNormal3f(fl[2*(*d)+3]-p[1],p[0]-fl[2*(*d)+2],0);
		}
	glEnd();
	}
glFlush();
}


void __saveds __asm showbiglogo(register __a0 struct Hook *h,
		register __a2 long obj,register __a1 long dummy)
{
struct animlogoData *data=INST_DATA(cl_animlogo->mcc_Class,obj);
DoMethod(group,MUIM_Group_InitChange);
if (child)
	{
	DoMethod(group,OM_REMMEMBER,child);
	MUI_DisposeObject(child);
	}
if (child=NewObject(cl_animlogo->mcc_Class,0,
	ReadListFrame,
	MUIA_Mesa_UseSubtask,1,
	MUIA_animlogo_logo,data->logo,
	MUIA_animlogo_background,0x000088,
	MUIA_animlogo_frontface,0xffff00,
	MUIA_animlogo_backface,0x000000,
	MUIA_animlogo_sideface,0xff0000,
	TAG_END,0))

	DoMethod(group,OM_ADDMEMBER,child);

DoMethod(group,MUIM_Group_ExitChange);
}
struct Hook showbiglogohook={{0,0,},&showbiglogo,0,0};

static ULONG __saveds __asm animlogo_Dispatcher( register __a0 struct IClass *cl,
		register __a2 Object *obj, register __a1 Msg msg )
{
switch( msg->MethodID )
  {
  case OM_NEW:
		{
		struct animlogoData *data;
		ULONG tags[]={AMRTL_RGBAMode,1,TAG_MORE,0};
		tags[3]=((struct opSet*)msg)->ops_AttrList;
//		if (!(obj = (Object *)DoSuperMethodA(cl,obj,msg))) return(0);
		if (!(obj = (Object *)DoSuperMethod(cl,obj,OM_NEW,tags,0))) return(0);
		data = INST_DATA(cl,obj);
		data->obj=obj;
		data->mesa=get1(obj,MUIA_Mesa_Base);
		data->logo=GetTagData(MUIA_animlogo_logo,0,((struct opSet *)msg)->ops_AttrList);
		data->background=GetTagData(MUIA_animlogo_background,0,((struct opSet *)msg)->ops_AttrList);
		data->front=GetTagData(MUIA_animlogo_frontface,0xffff00,((struct opSet *)msg)->ops_AttrList);
		data->back=GetTagData(MUIA_animlogo_backface,0x000000,((struct opSet *)msg)->ops_AttrList);
		data->side=GetTagData(MUIA_animlogo_sideface,0xff0000,((struct opSet *)msg)->ops_AttrList);
		memset(&data->drawhook,0,sizeof(data->drawhook));
		data->drawhook.h_Entry=animlogo_draw;
		data->drawhook.h_Data=data;
		SetAttrs(obj,MUIA_Mesa_DrawHook,&data->drawhook,
			MUIA_Mesa_ResizeHook,MUIV_Mesa_ResizeHook_DefaultViewport,
			TAG_END);
		data->time=0;
		animlogo_init(data);
		return obj;
		}
	case MUIM_Show:
		{
	struct animlogoData *data = INST_DATA(cl, obj);
	data->ihnode.ihn_Object  = obj;
	data->ihnode.ihn_Millis  = 100;
	data->ihnode.ihn_Method  = MUIM_Mesa_Redraw;
	data->ihnode.ihn_Flags   = MUIIHNF_TIMER;
	DoMethod(_app(obj),MUIM_Application_AddInputHandler,&data->ihnode);
		break;
		}
	case MUIM_Hide:
		{
		struct animlogoData *data = INST_DATA(cl,obj);
		DoMethod(_app(obj),MUIM_Application_RemInputHandler,&data->ihnode);
		}
		break;
  }
return( DoSuperMethodA( cl, obj, msg ) );
}

void deleteclass(void)
{
if (cl_animlogo) MUI_DeleteCustomClass( cl_animlogo );
}

int initclass(void)
{
if( !(cl_animlogo = MUI_CreateCustomClass( NULL, MUIC_Mesa, NULL, 
	sizeof( struct animlogoData ), animlogo_Dispatcher ) ) )
return 0;
}

Object *animbutton(char *label,long *logo,struct Hook *h)
{
Object *anim;
Object *o=HGroup,ButtonFrame,
		MUIA_Background,MUII_ButtonBack,
		MUIA_InputMode,MUIV_InputMode_RelVerify,
		Child,anim=NewObject(cl_animlogo->mcc_Class,0,
			MUIA_Mesa_UseSubtask,0,
			MUIA_animlogo_logo,logo,
			MUIA_animlogo_background,0xaaaaaa,
			MUIA_animlogo_frontface,0xffffff,
			MUIA_animlogo_backface,0x0000ff,
			MUIA_animlogo_sideface,0xaaaaaa,
			MUIA_FixWidthTxt,"xxxx",
			MUIA_FixHeightTxt,"\n\n",
			End,
		Child,TextObject,
			MUIA_Text_Contents,label,
			MUIA_Text_PreParse,"\033c",
			End,
		End;
if (h&&o) DoMethod(o,MUIM_Notify,MUIA_Pressed,0,
				anim,2,MUIM_CallHook,h);
return o;
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

if (initclass())
	{
	app = ApplicationObject,
		MUIA_Application_Title      , PROGNAME,
		MUIA_Application_Version    , "$VER: " PROGNAME " 1.0 (28.08.98)",
		MUIA_Application_Copyright  , "©1998, Szymon Ulatowski",
		MUIA_Application_Author     , "Szymon Ulatowski",
		MUIA_Application_Description, "Shows animation in Mesa Class",
		MUIA_Application_Base       , "MESADEMO3",
		SubWindow,win=WindowObject,
			MUIA_Window_Title, PROGNAME,
			MUIA_Window_ID   , 'WIN1',
			WindowContents, group=VGroup,
				Child,HGroup,
					MUIA_Weight,20,
					Child,animbutton("Ankh",logo_ankh,&showbiglogohook),
					Child,animbutton("Spiral",logo_spiral,&showbiglogohook),
					Child,animbutton("Astronaut",logo_astronaut,&showbiglogohook),
					End,
				Child,child=ListviewObject,
					MUIA_Listview_List,FloattextObject,TextFrame,
					MUIA_Background,MUII_TextBack,
					MUIA_Floattext_Text,
						"Bored with plain imagebuttons?\n"
						"What about Mesa 3D animated buttons?!\n\n"
						"Probably it's inefficient to create a new "
						"GL rendering context for such a stupid thing "
						"like a button... but hey, it's a demo!\n\n"
						"Besides this crazy idea of animated buttons "
						"(who knows, maybe they will be standard someday...) "
						"it will show you how to use multiple Mesa objects "
						"in your applications.\n\n"
						"PS. Don't you think MUI is just great? :-)"
						,
					End,
					End,
				End,
			End,
		End;

	if (app)
		{
		DoMethod(win,MUIM_Notify,MUIA_Window_CloseRequest,TRUE,
			app,2,MUIM_Application_ReturnID,MUIV_Application_ReturnID_Quit);

		SetAttrs(win,MUIA_Window_Open,TRUE,0);	

	// VERY standard main loop
		while (DoMethod(app,MUIM_Application_NewInput,&sigs) != MUIV_Application_ReturnID_Quit)
		if (sigs) {sigs = Wait(sigs | SIGBREAKF_CTRL_C); if (sigs & SIGBREAKF_CTRL_C) break;}

		MUI_DisposeObject(app);
		} else puts("MUI can't create application!");
	deleteclass();
	}
else puts("Can't create class! (do you have Mesa.mcc?)");
CloseLibrary(MUIMasterBase);
return 0;
}
