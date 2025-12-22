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
#include <GL/glut.h>
#include <GL/mesadriver.h>
#include <utility/hooks.h>

#include <mui/mesa_mcc.h>

#define PROGNAME "Mesa MCC Demo"

struct Library *MUIMasterBase;
int CXBRK(void) { return(0); }
int _CXBRK(void) { return(0); }
void chkabort(void) {}

AmigaMesaRTLContext ctx;

Object *app,*win,*mesa,*ch_li0,*sl_li0,*ch_li1,*sl_li1,
	*ra_object,*ch_smooth,*cy_li0,*cy_li1,*te_stat;

char* object_names[]={"Cube","Cone","Sphere","Torus","Teapot",0};
char* color_names[]={
		"White \033I[2:ffffffff,ffffffff,ffffffff]",
		"Red \033I[2:ffffffff,00000000,00000000]",
		"Green  \033I[2:00000000,ffffffff,00000000]",
		"Blue \033I[2:00000000,00000000,ffffffff]",
		"Yellow \033I[2:ffffffff,ffffffff,00000000]",
		"Purple \033I[2:ffffffff,00000000,ffffffff]",
		"Cyan \033I[2:00000000,ffffffff,ffffffff]",0};

long get1(Object *o,ULONG par)
{
ULONG out=0;
GetAttr(par,(void*)o,&out);
return out;
}


#define ROT_X 20
#define ROT_Y 30


/*
	This function is called when mesa object has to be refreshed.
	In this demo it will be executed by subtask.
	All dirty work (creating/removing tasks, safe data access)
	is done by Mesa.mcc
	The only important thing when using subtasks is EVERY OBJECT HAS
	TO USE DIFFERENT LIBRARY BASES

*/

void __saveds __asm DrawScene(register __a0 struct Hook *h,
		register __a2 long obj,register __a1 long data)
{
static GLfloat light_position[] = { 1.3, 1.3, 1.3, 0.0 };
static GLfloat light_colors[][4] =
{{ 1.0, 1.0, 1.0, 0.0 },
 { 1.0, 0.0, 0.0, 0.0 },
 { 0.0, 1.0, 0.0, 0.0 },
 { 0.0, 0.0, 1.0, 0.0 },
 { 1.0, 1.0, 0.0, 0.0 },
 { 1.0, 0.0, 1.0, 0.0 },
 { 0.0, 1.0, 1.0, 0.0 },};

glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
glLoadIdentity();
glTranslatef(0,0,-10);
glRotatef(ROT_X,1,0,0);
glRotatef(ROT_Y,0,1,0);

glDisable(GL_LIGHTING);
if (get1(ch_li0,MUIA_Selected))
	{
	GLfloat a=(get1(sl_li0,MUIA_Numeric_Value)-ROT_Y)/57.3,*color;
	glEnable(GL_LIGHT0);
	light_position[0]=1.7*sin(a);
	light_position[2]=1.7*cos(a);
	glLightfv(GL_LIGHT0, GL_POSITION, light_position);
	color=light_colors[get1(cy_li0,MUIA_Cycle_Active)];
	glLightfv(GL_LIGHT0, GL_DIFFUSE, color);
	glColor3fv(color);
	glBegin(GL_POINTS);
	glVertex3fv(light_position);
	glEnd();
	}
else	glDisable(GL_LIGHT0);

if (get1(ch_li1,MUIA_Selected))
	{
	GLfloat a=(get1(sl_li1,MUIA_Numeric_Value)-ROT_Y)/57.3,*color;
	glEnable(GL_LIGHT1);
	light_position[0]=1.7*sin(a);
	light_position[2]=1.7*cos(a);
	glLightfv(GL_LIGHT1, GL_POSITION, light_position);
	color=light_colors[get1(cy_li1,MUIA_Cycle_Active)];
	glLightfv(GL_LIGHT1, GL_DIFFUSE, color);
	glColor3fv(color);
	glBegin(GL_POINTS);
	glVertex3fv(light_position);
	glEnd();
	}
else	glDisable(GL_LIGHT1);

glEnable(GL_LIGHTING);

if (CheckSignal(SIGBREAKF_CTRL_C))
/*
	Main task signals, that new Redraw request has been received
	(eg. because of parameter change).
	This means our drawing is probably obsolete at this moment.

	We could now:

	1.Abort the function
	 - Mesa will call it again from the begining (so it will be
		more recent). The user won't see anything until that next
		function will call glFlush at the end

	2.Ignore the signal
	 - User will see our drawing and the next image (more recent
		and maybe more important) would start later

	3.Draw something quick
	 - We could draw a simplified version so the user would still
		have an idea what's going on and on the other hand, it
		will not delay the next image (not much)

	In this example we use approach #3 and draw wireframe version
	of our objects.
*/
switch(get1(ra_object,MUIA_Radio_Active))
	{
	case 0: glutWireCube (1.2); break;
	case 1: glutWireCone(1.0,2.0,20,3); break;
	case 2: glutWireSphere(1.2,20,8); break;
	case 3: glutWireTorus(0.3,1.2,8,20); break;
	case 4: glutWireTeapot(1.0); break;
	}
else
/*
	Draw full quality version
*/
switch(get1(ra_object,MUIA_Radio_Active))
	{
	case 0: glutSolidCube (1.2); break;
	case 1: glutSolidCone(1.0,2.0,20,3); break;
	case 2: glutSolidSphere(1.2,20,8); break;
	case 3: glutSolidTorus(0.3,1.2,8,20); break;
	case 4: glutSolidTeapot(1.0); break;
	}

glFlush();
}

struct Hook drawscene_hook={{0,0},DrawScene,0,0};


/* 
	Create our Mesa object and initialize the context.
*/
void CreateMesaObject(void)
{
ULONG tags[]={AMRTL_RGBAMode,1,TAG_DONE};
if (!(mesa=MesaObject,
			ReadListFrame,
			MUIA_Mesa_Tags,tags,

			MUIA_Mesa_UseSubtask,TRUE,
//	Mesa spawns a new task to render the image
//	Without that, MUI would wait each time mesa object redraws itself

			MUIA_Mesa_Base,mesamainBase,
//	In this simple example program we create only one mesa object,
//	so we can use global mesamainBase (and mesadriverBase)

			MUIA_Mesa_DrawHook,&drawscene_hook,
//	Our scene drawing routine

			MUIA_Mesa_ResizeHook,MUIV_Mesa_ResizeHook_DefaultViewport,
//	Mesa will automaticaly set default viewport size
//	ie. call glViewport(0,0,Width,Height)

			End))
	{
	PrintFault(IoErr(),"Can't create Mesa.mcc object");
		// object can't be created
		// maybe IoErr() can explain that...
	}
else
	{
	GetAttr(MUIA_Mesa_Context,(void*)mesa,(ULONG*)&ctx);
	// get the context created for our new mesa object
	AmigaMesaRTLMakeCurrent(ctx);
	// we have only one object and one context
	// so this call is sufficient for entire program:
	// all subsequent GL functions will use this context



	// OpenGL context initialization
	// it could work on any OpenGL implementation...
{
GLfloat white[] = { 1.0, 1.0, 1.0, 1.0 };
GLfloat mat_shininess[] = { 50.0 };
GLfloat mat_ambient[]= {0.5, 0.5, 0.5, 1.0 };
GLfloat quad_atten[3]={0.25, 0.0, 1/60.0 };
glClearColor(0,0,0,0);
glMaterialfv(GL_FRONT, GL_SPECULAR, white);
glMaterialfv(GL_FRONT, GL_SHININESS, mat_shininess);
glMaterialfv(GL_FRONT, GL_AMBIENT, mat_ambient);

glLightfv(GL_LIGHT0, GL_SPECULAR, white);
glLightfv(GL_LIGHT1, GL_SPECULAR, white);

glEnable(GL_LIGHTING);
glEnable(GL_LIGHT0);
glEnable(GL_LIGHT1);
glEnable(GL_DEPTH_TEST);

glPointSize(8.0);
glEnable(GL_POINT_SMOOTH);
glPointParameterfvEXT(GL_DISTANCE_ATTENUATION_EXT,quad_atten);
glMatrixMode(GL_PROJECTION);
glLoadIdentity();
glFrustum(-1,1,-1,1,5,20);
glMatrixMode(GL_MODELVIEW);

}	
	}
return 0;
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
		MUIA_Application_Version    , "$VER: " PROGNAME " 1.1 (28.08.98)",
		MUIA_Application_Copyright  , "©1998, Szymon Ulatowski",
		MUIA_Application_Author     , "Szymon Ulatowski",
		MUIA_Application_Description, "Mesa MUI Custom Class Demo",
		MUIA_Application_Base       , "MESADEMO",
		SubWindow,win=WindowObject,
			MUIA_Window_Title, PROGNAME,
			MUIA_Window_ID   , 'WIN1',
			WindowContents, VGroup,
				Child,HGroup,
					Child,sl_li0=Slider(-180,180,-30),
					Child,ch_li0=CheckMark(1),
					Child,cy_li0=Cycle(color_names),
					End,
				Child,HGroup,
					Child,sl_li1=Slider(-180,180,30),
					Child,ch_li1=CheckMark(1),
					Child,cy_li1=Cycle(color_names),
					End,
				Child,HGroup,
					Child,mesa,	// mesa object is here!
					Child,VGroup,
						MUIA_Weight,10,
						Child,HVSpace,
						Child,ra_object=Radio("Object",object_names),
						Child,HVSpace,
						Child,HVSpace,
						Child,te_stat=TextObject,TextFrame,
								MUIA_Background,MUII_TextBack,
								End,
						End,
					End,
				End,
			End,
		End;

	if (app)
		{
		DoMethod(win,MUIM_Notify,MUIA_Window_CloseRequest,TRUE,
			app,2,MUIM_Application_ReturnID,MUIV_Application_ReturnID_Quit);

		SetAttrs(cy_li0,MUIA_Cycle_Active,1);
		SetAttrs(cy_li1,MUIA_Cycle_Active,0);

	// every control sends MUIM_Mesa_Redraw

		DoMethod(ch_li0,MUIM_Notify,MUIA_Selected,MUIV_EveryTime,mesa,1,MUIM_Mesa_Redraw);
		DoMethod(ch_li1,MUIM_Notify,MUIA_Selected,MUIV_EveryTime,mesa,1,MUIM_Mesa_Redraw);
		DoMethod(sl_li0,MUIM_Notify,MUIA_Numeric_Value,MUIV_EveryTime,mesa,1,MUIM_Mesa_Redraw);
		DoMethod(sl_li1,MUIM_Notify,MUIA_Numeric_Value,MUIV_EveryTime,mesa,1,MUIM_Mesa_Redraw);
		DoMethod(ch_smooth,MUIM_Notify,MUIA_Selected,MUIV_EveryTime,mesa,1,MUIM_Mesa_Redraw);
		DoMethod(ra_object,MUIM_Notify,MUIA_Radio_Active,MUIV_EveryTime,mesa,1,MUIM_Mesa_Redraw);
		DoMethod(cy_li0,MUIM_Notify,MUIA_Cycle_Active,MUIV_EveryTime,mesa,1,MUIM_Mesa_Redraw);
		DoMethod(cy_li1,MUIM_Notify,MUIA_Cycle_Active,MUIV_EveryTime,mesa,1,MUIM_Mesa_Redraw);

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
CloseLibrary(MUIMasterBase);
return 0;
}
