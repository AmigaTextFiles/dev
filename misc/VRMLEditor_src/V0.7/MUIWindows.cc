/*----------------------------------------------------
  MUIWindows.cc
  Version 0.63
  Date: 26 july 1998
  Author: Bodmer Stephan (bodmer2@uni2a.unige.ch)
  Note: All function for MUI objects handling
	STORM-C/GCC Port
-----------------------------------------------------*/
#include <math.h>

#include <datatypes/pictureclass.h>
#include <datatypes/pictureclassext.h>
#include <cybergraphx/cybergraphics.h>
#include <libraries/mui.h>
#include <mui/GLArea_mcc.h>

#include <proto/alib.h>
#include <proto/exec.h>
#include <proto/intuition.h>
#include <proto/graphics.h>
#include <proto/datatypes.h>
#include <proto/muimaster.h>
#include <proto/cybergraphicsnew.h>

#ifdef __GNUC__
#else
// #include <pragmas/muimaster_pragmas.h>
#endif
// #include <mui/Listtree_mcc.h>

#include "MUIWindows.h"

#include "Conversion.h"

extern struct ObjApp *MyApp;
extern SharedVariables sh;
extern struct GLContext glcontext;
// extern GLBases glbases;
/*----------------------------
  Panel window gauge settings
-----------------------------*/

/*
void VRMLShapes::RefreshGauge(VRMLState *st) {
    // puts("==>RefreshGauge");
    ULONG sig;
    if (st==NULL) return;
    SetAttrs((Object *) st->gauge, MUIA_Gauge_Current, st->currentpolygone);
    // puts("Gauge updated");
    // DoMethod((Object *) st->obj->App,MUIM_Application_NewInput,&sig);
    // puts("<==RefreshGauge");
}
*/
/*------------------------------
  LVObject
-------------------------------*/
// Constructeur
/*
LVObject::LVObject(struct ObjApp *o, APTR l, VRMLGroups *gr, SharedVariables *s) {
    g=gr;lv=l;obj=o;sv=s;
}
LVObject::~LVObject() {
    // puts("In LVObject destructor");
}              

// Methods
void LVObject::SetGroup(VRMLGroups *cg) {
    g=cg;
    RefreshHeader();
    Refresh();
}
void LVObject::RefreshHeader() {
    // puts("In RefreshHeader");
*/
    /*
    if (lv==obj->LV_MainNodes) {
	SetAttrs((Object *) obj->TX_MainGroupCurrent,
		 MUIA_Text_Contents,g->GetName(),NULL);
	SetAttrs((Object *) obj->TX_MainGroupType,
		 MUIA_Text_Contents,g->GetTypeName(),NULL);
    }
    else if (lv==obj->LV_MainClipboard) {
	SetAttrs((Object *) obj->TX_MainClipGroupCurrent,
		 MUIA_Text_Contents,g->GetName(),NULL);
	SetAttrs((Object *) obj->TX_MainClipGroupType,
		 MUIA_Text_Contents,g->GetTypeName(),NULL);
    };
    */
/*
}
void LVObject::CompleteEntry(char *temp, VRMLNode *n) {
    strcpy(temp,"");
    if (strcmp(n->GetName(),"NONE")) {
	    strcpy(temp,n->GetName());
	    strcat(temp," ");
    };
    strcat(temp,n->GetTypeName());
    switch (n->type) {
	*/
	/*
	case InfoID:{
			Info_ *i=(Info_ *) n;
			strcat(temp," \"");
			strncat(temp,i->GetString(),100);
			strcat(temp,"\"");
		    };
		    break;
	*/
	/*
	case WWWAnchorID: {
			WWWAnchor *w=(WWWAnchor *) n;
			strcat(temp," \"");
			strcat(temp,w->GetURL());
			strcat(temp,"\"");
			};
			break;
	case WWWInlineID:{
			    WWWInline *w=(WWWInline *) n;
			    strcat(temp," \"");
			    strcat(temp,w->GetURL());
			    strcat(temp,"\"");
			    // printf("Completed:%s\n",temp);
			 };
			 break;
	case USEID:{
			USE *u=(USE *) n;
			strcat(temp," ");
			strcat(temp,u->reference->GetName());
			strcat(temp," (");
			strcat(temp,u->reference->GetTypeName());
			strcat(temp,")");
		   };
		   break;
    };
}
void LVObject::Refresh() {
    VRMLNode *n;
    char temp[255];
    int sel=Selected();
    if (sel<=-1) sel=0;
    // printf("total of nodes:%d\n",total);
    // puts("In Refresh");
    sv->mode=SYSTEM;
    Clear();
    for (int i=0;i<g->Size();i++) {
	n=g->GetChild(i);
	CompleteEntry(temp,n);
	DoMethod((Object *) lv,MUIM_List_InsertSingle,temp,MUIV_List_Insert_Bottom);
    };
    // sv->mode=USER;
    SetAttrs((Object *) lv,MUIA_List_Active,sel, NULL);
    sv->mode=USER;
    // puts("Out of refresh");
}
void LVObject::Clear() {
    DoMethod((Object *) lv,MUIM_List_Clear);
}
int LVObject::Selected() {
    ULONG store=0;
    GetAttr (MUIA_List_Active, (Object *) lv, &store);

    return (int) store;
}
VRMLNode *LVObject::GetSelected() {
    ULONG store;
    struct MUIS_Listtree_TreeNode *tn=NULL;
    GetAttr(MUIA_Listtree_Active, (Object *) lv, &store);
    tn=(struct MUIS_Listtree_TreeNode *) store;
    return (VRMLNode *) tn->tn_User;
}
VRMLNode *LVObject::GetSelectedChild() {
    if (Selected()==-1) return NULL;
    return g->GetChild(Selected());
}
VRMLNode *LVObject::RemoveEntry() {
   sv->mode=SYSTEM;
   if (Selected()==-1) return NULL;
   // printf("LVObject::Remove %d\n",Selected());
   VRMLNode *n=g->RemoveChild(Selected());
   DoMethod((Object *) lv,MUIM_List_Remove,Selected());
   sv->mode=USER;
   return n;
}
void LVObject::InsertEntry(VRMLNode *n) {
    int sel=Selected();
    char temp[255];
    // if (sel==-1) {sel=0;};
    sv->mode=SYSTEM;
    if (n!=NULL) {
	// if (n->type==SeparatorID) {
	//     Group *cg=(Group *) n;
	// };
	// printf("LVObject::InsertEntry:%d\n",sel);
	g->InsertChild(Selected(),n);
	CompleteEntry(temp,n);
	// printf("temp:%s\n",temp);
	DoMethod((Object *) lv,MUIM_List_InsertSingle,temp,sel+1);
	SetAttrs((Object *) lv,MUIA_List_Active,sel+1, NULL);
    };
    sv->mode=USER;
}
void LVObject::MoveUp() {
    int sel=Selected();
    // printf("Sel:%d\n",sel);
    sv->mode=SYSTEM;
    if (sel>0) {
	g->ExchangeChildren(sel,sel-1);
	DoMethod((Object *) lv,MUIM_List_Exchange,MUIV_List_Exchange_Active,MUIV_List_Exchange_Previous);
	SetAttrs((Object *) lv,MUIA_List_Active,sel-1, NULL);
    };
    sv->mode=USER;
}
void LVObject::MoveDown() {
    int sel=Selected();
    // printf("Sel:%d\n",sel);
    sv->mode=SYSTEM;
    if (sel<g->Size()-1) {
	g->ExchangeChildren(sel,sel+1);
	DoMethod((Object *) lv,MUIM_List_Exchange,MUIV_List_Exchange_Active,MUIV_List_Exchange_Next);
	SetAttrs((Object *) lv,MUIA_List_Active,sel+1, NULL);
    };
    sv->mode=USER;
}
void LVObject::Delete() {
    int sel=Selected();
    sv->mode=SYSTEM;
    if(sel!=-1) {
	// puts("In LV.Delete");
	if (g->GetChild(sel)->ref!=0) {
	    MUI_Request (obj->App,obj->WI_Main,0,"Error","Ok",
		     "You can't delete this node\n"
		     "There are some references (USE) attached\n\n"
		     "Delete all references first");
	}
	else {
	    delete g->RemoveChild(sel);
	    DoMethod((Object *) lv,MUIM_List_Remove,MUIV_List_Remove_Active);
	    SetAttrs((Object *) lv,MUIA_List_Active,sel, NULL);
	};
    };
    sv->mode=USER;
}*/
/*---------------------------
  WIAdd
-------------------------------*/
WIAdd::WIAdd() {
    // obj=o;
    strcpy(temp,"NONE");
    mode=0;
}
WIAdd::~WIAdd() {
}
void WIAdd::Mode(int m, VRMLNode *n) {
    mode=m;
    SetAttrs((Object *) MyApp->WI_Add, MUIA_Window_Open, TRUE);
    //-------- Select currrent type ------
    if (n) {
	SetAttrs((Object *) MyApp->LV_AddNode, MUIA_List_Active, (n->ID&63)-1);
	SetAttrs((Object *) MyApp->STR_AddNodeName, MUIA_String_Contents,(ULONG) "NONE");
    };
}
VRMLNode *WIAdd::Ok() {
    ULONG store;
    int what=-1;
    char temp[255];

    GetAttr(MUIA_List_Active, (Object *) MyApp->LV_AddNode, &store);
    what=(int) store;
    GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_AddNodeName, &store);
    strncpy(temp,(char *) store,255);

    // printf("Selected in Addwindow:%d\n",what);
    
    if (what==-1) return NULL;
    switch (what) {
	case 0:return (VRMLNode *) new AsciiText(temp);break;
	case 1:return (VRMLNode *) new Cone(temp);break;
	case 2:return (VRMLNode *) new Coordinate3(temp);break;
	case 3:return (VRMLNode *) new Cube(temp);break;
	case 4:return (VRMLNode *) new Cylinder(temp);break;
	case 5:return (VRMLNode *) new DirectionalLight(temp);break;
	case 6:return (VRMLNode *) new FontStyle(temp);break;
	case 7:return (VRMLNode *) new Group(temp);break;
	case 8:return (VRMLNode *) new IndexedFaceSet(temp);break;
	case 9:return (VRMLNode *) new IndexedLineSet(temp);break;
	case 10:return (VRMLNode *) new VInfo(temp);break;
	case 11:return (VRMLNode *) new LOD(temp);break;
	case 12:return (VRMLNode *) new Material(temp);break;
	case 13:return (VRMLNode *) new MaterialBinding(temp);break;
	case 14:return (VRMLNode *) new MatrixTransform(temp);break;
	case 15:return (VRMLNode *) new Normal(temp);break;
	case 16:return (VRMLNode *) new NormalBinding(temp);break;
	case 17:return (VRMLNode *) new OrthographicCamera(temp);break;
	case 18:return (VRMLNode *) new PerspectiveCamera(temp);break;
	case 19:return (VRMLNode *) new PointLight(temp);break;
	case 20:return (VRMLNode *) new PointSet(temp);break;
	case 21:return (VRMLNode *) new Rotation(temp);break;
	case 22:return (VRMLNode *) new Scale(temp);break;
	case 23:return (VRMLNode *) new Separator(temp);break;
	case 24:return (VRMLNode *) new ShapeHints(temp);break;
	case 25:return (VRMLNode *) new Sphere(temp);break;
	case 26:return (VRMLNode *) new SpotLight(temp);break;
	case 27:return (VRMLNode *) new Switch(temp);break;
	case 28:return (VRMLNode *) new Texture2(temp);break;
	case 29:return (VRMLNode *) new Texture2Transform(temp);break;
	case 30:return (VRMLNode *) new TextureCoordinate2(temp);break;
	case 31:return (VRMLNode *) new Transform(temp);break;
	case 32:return (VRMLNode *) new TransformSeparator(temp);break;
	case 33:return (VRMLNode *) new Translation(temp);break;
	case 34:return (VRMLNode *) new WWWAnchor(temp);break;
	case 35:return (VRMLNode *) new WWWInline(temp);break;
    };
}
/*----------------------------
  - VRML Windows             -
  ----------------------------*/
// MUIWindow
void MUIWindow::InitWindow() {
}
void MUIWindow::DisableMainWindow() {
   SetAttrs ((Object *) MyApp->WI_Main,MUIA_Window_Sleep, TRUE, NULL);
}
void MUIWindow::EnableMainWindow() {
   SetAttrs ((Object *) MyApp->WI_Main,MUIA_Window_Sleep, FALSE, NULL);
}
void MUIWindow::PopUp() {
    // puts("PopUp");
    SetAttrs((Object *) win,MUIA_Window_Open,TRUE);
}
void MUIWindow::PopDown() {
    SetAttrs((Object *) win,MUIA_Window_Open,(BOOL) FALSE);
}
/*--------------------------
  WIAsciiText
----------------------------*/
WIAsciiText::WIAsciiText() {
    // MyApp=o;win=w;sh=s;
    // manip=new AsciiText("COPY");
    manip=NULL;
    // puts("WIAsciiText(x,x,x) constructor");
}
WIAsciiText::~WIAsciiText() {
    // delete manip;
    // puts("WIAsciiText destructor");
}
void WIAsciiText::Set(VRMLNode *n, int w) {
    // puts("WIAsciiText::Set");
    a=(AsciiText *) n;which=w;
    // a->Print();
    manip=(AsciiText *) a->Clone();
    // manip->Copy(n);
    // puts("after copy");
    // manip->Print();
    // a->Print();
    Refresh();
    // RefreshString();
    SetAttrs(MyApp->WI_AsciiText, MUIA_Window_Open, TRUE);
    // PopUp();
}
int WIAsciiText::Selected() {
    ULONG store;
    GetAttr(MUIA_List_Active, (Object *) MyApp->LV_AsciiTextStrings, &store);
    return (int) store;
}
void WIAsciiText::Add() {
    ULONG store;
    StringWidth *sw=new StringWidth("NEW",0.0);
    a->InsertTxt(Selected(),sw);
    Refresh();
}
void WIAsciiText::Delete() {
    if (a->Size()<=1) {
	MUI_Request (MyApp->App,MyApp->WI_AsciiText,0,"Error","Ok",
		     "You can't delete the first entry !");
    }
    else {
	delete (a->RemoveTxt(Selected()));
	Refresh();
    };
}
int WIAsciiText::Ok() {
    delete (manip);
    manip=NULL;
    return which;
}
void WIAsciiText::Cancel() {
    // puts("In cancel");
    // delete (manip);
    // manip=NULL;
    a->Copy(manip);
    delete (manip);
    manip=NULL;
}
void WIAsciiText::Refresh() {
    char temp[255];
    int sel=Selected(),i=0;

    printf("refresh:%d\n",a->Size());
    if (sel==-1) sel=0;
    sh.mode=SYSTEM;
    DoMethod((Object *) MyApp->LV_AsciiTextStrings,MUIM_List_Clear);
    for (i=0;i<a->Size();i++) {
	DoMethod((Object *) MyApp->LV_AsciiTextStrings,MUIM_List_InsertSingle,
		 a->GetTxt(i)->str,MUIV_List_Insert_Bottom);
    };
    SetAttrs((Object *) MyApp->LV_AsciiTextStrings, MUIA_List_Active, sel,NULL);
    SetAttrs((Object *) MyApp->STR_DEFAsciiTextName, MUIA_String_Contents, (ULONG) a->GetName(),NULL);
    ftoa(a->spacing,temp);
    SetAttrs((Object *) MyApp->STR_AsciiTextSpacing, MUIA_String_Contents, (ULONG) temp,NULL);
    /*
    switch (j) {
	case LEFT:i=0;break;
	case CENTER:i=1;break;
	case RIGHT:i=2;break;
    };
    */
    SetAttrs((Object *) MyApp->CY_AsciiTextJustification, MUIA_Cycle_Active, (ULONG) a->justification);
    sh.mode=USER;
    RefreshString();
}
void WIAsciiText::RefreshString() {
    char temp[255];
    ULONG store;

    puts("refreshString");
    sh.mode=SYSTEM;
    DoMethod((Object *) MyApp->LV_AsciiTextStrings,MUIM_List_GetEntry,MUIV_List_GetEntry_Active, &store);
    SetAttrs((Object *) MyApp->STR_AsciiTextString,MUIA_String_Contents,(ULONG)  store, NULL);
    ftoa(a->GetTxt(Selected())->width,temp);
    SetAttrs((Object *) MyApp->STR_AsciiTextWidth,MUIA_String_Contents,(ULONG) temp,NULL);
    sh.mode=USER;
}
void WIAsciiText::ReadValues() {
    ULONG store;
		
    GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_DEFAsciiTextName, &store);
    a->SetName((char *) store);
    GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_AsciiTextSpacing, &store);
    a->spacing=(float) atof((char *) store);
    GetAttr(MUIA_Cycle_Active, (Object *) MyApp->CY_AsciiTextJustification, &store);
    /*
    switch ((int) store) {
	case 0:a->justification=LEFT;break;
	case 1:a->justification=CENTER;break;
	case 2:a->justification=RIGHT;break;
    };
    */
    a->justification=(int) store;
    GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_AsciiTextString, &store);
    strncpy(a->GetTxt(Selected())->str,(char *) store, 255);
    GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_AsciiTextWidth, &store);
    // printf("float:%f\n",(float) store);
    a->GetTxt(Selected())->width=(float) atof ((char *) store);
    Refresh();
}
/*--------------------------
  WICone
----------------------------*/
// Constructeur
WICone::WICone() {
    // MyApp=o;win=w;sh=s;
    //manip=new Cone ("MANIP");
    manip=NULL;
}
WICone::~WICone() {
    // puts ("In Window CONE destructor");
    // delete manip;
}
void WICone::SetDefault() {
    c->bottomRadius=1.0;
    c->height=2.0;
    c->parts=SIDES+BOTTOM;
    Refresh();
}
void WICone::Set (VRMLNode *n, int w) {
    c=(Cone *) n;which=w;
    // manip->Copy(c);
    manip=(Cone *) c->Clone();
    Refresh();
    // PopUp();
    SetAttrs((Object *) MyApp->WI_Cone, MUIA_Window_Open, TRUE);
}
int WICone::Ok() {
    delete (manip);
    return which;
}
void WICone::Cancel() {
    c->Copy(manip);
    delete (manip);
}
void WICone::ReadValues() {
    int p=0;
    BOOL ck;
    ULONG store;

    // puts("In cone ReadValues");
    GetAttr (MUIA_String_Contents, (Object *) MyApp->STR_DEFConeName, &store);
    c->SetName((char *) store);
    GetAttr (MUIA_String_Contents, (Object *) MyApp->STR_ConeBottomRadius, &store);
    c->bottomRadius=(double) atof((char *) store);
    GetAttr (MUIA_String_Contents, (Object *) MyApp->STR_ConeHeight, &store);
    c->height=(double) atof((char *) store);

    GetAttr (MUIA_Selected, (Object *) MyApp->CH_ConeSides, &store);
    ck=(BOOL) store;
    if (ck) p=p+SIDES;
    GetAttr (MUIA_Selected, (Object *) MyApp->CH_ConeBottom, &store);
    ck=(BOOL) store;
    if (ck) p=p+BOTTOM;
    c->parts=p;
}
void WICone::Refresh() {
    int p;
    BOOL ck;
    char temp[25];

    sh.mode=SYSTEM;
    SetAttrs ((Object *) MyApp->STR_DEFConeName,MUIA_String_Contents, (ULONG) c->GetName());
    ftoa(c->bottomRadius,temp);
    SetAttrs ((Object *) MyApp->STR_ConeBottomRadius,MUIA_String_Contents, (ULONG) temp);
    ftoa(c->height,temp);
    SetAttrs ((Object *) MyApp->STR_ConeHeight,MUIA_String_Contents, (ULONG) temp);
    p=c->parts;
    if ((p&1)==1) {ck=TRUE;}
    else {ck=FALSE;};
    SetAttrs ((Object *) MyApp->CH_ConeSides,MUIA_Selected, (ULONG) ck);

    if ((p&4)==4) {ck=TRUE;}
    else {ck=FALSE;};
    SetAttrs ((Object *) MyApp->CH_ConeBottom,MUIA_Selected, (ULONG) ck);
    sh.mode=USER;
}
/*----------------------------
  WICoordinate3
------------------------------*/
WICoordinate3::WICoordinate3() {
  // MyApp=o;win=w;sh=s;
  manip=NULL;
  // manip=new Coordinate3("MANIP");
}
WICoordinate3::~WICoordinate3() {
  // delete manip;
}
int  WICoordinate3::Selected() {
    ULONG store;
    GetAttr(MUIA_Prop_First,MyApp->PR_Coordinate3Index, &store);
    return (int) store;
}
void WICoordinate3::Set(VRMLNode *n, int w) {
    char temp[25];

    c=(Coordinate3 *) n;which=w;
    manip=(Coordinate3 *) c->Clone();
    sh.mode=SYSTEM;
    SetAttrs((Object *) MyApp->STR_DEFCoordinate3Name,MUIA_String_Contents, (ULONG) c->GetName());
    SetAttrs((Object *) MyApp->PR_Coordinate3Index,MUIA_Prop_Entries,(LONG) c->Size());
    SetAttrs((Object *) MyApp->PR_Coordinate3Index,MUIA_Prop_Visible,1);
    SetAttrs((Object *) MyApp->PR_Coordinate3Index,MUIA_Prop_First,0);
    itoa(c->Size(),temp);
    SetAttrs((Object *) MyApp->TX_Coordinate3Num,MUIA_Text_Contents,(ULONG) temp);
    sh.mode=USER;
    Refresh();
    SetAttrs((Object *) MyApp->WI_Coordinate3, MUIA_Window_Open, TRUE);
    // PopUp();
}
void WICoordinate3::Refresh() {
    Vertex3d *cv=NULL;
    char temp[25];

    sh.mode=SYSTEM;
    itoa(Selected(),temp);
    SetAttrs((Object *) MyApp->TX_Coordinate3Index, MUIA_Text_Contents, (ULONG) temp);
    cv=c->GetPoint(Selected());
    printf("x:%f\n",cv->coord[0]);
    ftoa(cv->coord[0],temp);
    printf("x:%f string:%s\n",cv->coord[0],temp);

    SetAttrs((Object *) MyApp->STR_Coordinate3X,MUIA_String_Contents, (ULONG) temp);
    ftoa(cv->coord[1],temp);
    SetAttrs((Object *) MyApp->STR_Coordinate3Y,MUIA_String_Contents, (ULONG) temp);
    ftoa(cv->coord[2],temp);
    SetAttrs((Object *) MyApp->STR_Coordinate3Z,MUIA_String_Contents, (ULONG) temp);
    sh.mode=USER;
}
void WICoordinate3::ReadValues() {
    ULONG store;
    char temp[25];
    Vertex3d *cv=NULL;

    GetAttr (MUIA_String_Contents,(Object *) MyApp->STR_DEFCoordinate3Name, &store);
    c->SetName((char *) store);
    cv=c->GetPoint(Selected());
    GetAttr (MUIA_String_Contents,(Object *) MyApp->STR_Coordinate3X,&store);
    cv->coord[0]=(double) atof((char *) store);
    GetAttr (MUIA_String_Contents,(Object *) MyApp->STR_Coordinate3Y,&store);
    cv->coord[1]=(double) atof((char *) store);
    GetAttr (MUIA_String_Contents,(Object *) MyApp->STR_Coordinate3Z,&store);
    cv->coord[2]=(double) atof((char *) store);
    // printf("%f %f %f\n",x,y,z);
}
int WICoordinate3::Ok() {
    delete (manip);
    return which;
}
void WICoordinate3::Cancel() {
    c->Copy(manip);
    delete manip;
}
void WICoordinate3::Add() {
    char temp[25];

    puts("WICoordinate3::Add");
    sh.mode=SYSTEM;
    c->InsertPoint(Selected(),new Vertex3d(0.0,0.0,0.0));
    puts("Inserted");
    SetAttrs((Object *) MyApp->PR_Coordinate3Index,MUIA_Prop_Entries,(LONG) c->Size());
    itoa(c->Size(),temp);                                      
    SetAttrs((Object *) MyApp->TX_Coordinate3Num,MUIA_Text_Contents, (ULONG) temp);
    sh.mode=USER;
    Refresh();
}
void WICoordinate3::Delete() {
    char temp[25];

    if (c->Size()<=1) {
	MUI_Request (MyApp->App,MyApp->WI_Coordinate3,0,"Error","Ok",
				    "You can't delete the first point !");
    }
    else {
	sh.mode=SYSTEM;
	delete c->RemovePoint(Selected());
	SetAttrs((Object *) MyApp->PR_Coordinate3Index,MUIA_Prop_Entries,(LONG) c->Size());
	itoa(c->Size(),temp);
	SetAttrs((Object *) MyApp->TX_Coordinate3Num,MUIA_Text_Contents, (ULONG) temp);
	sh.mode=USER;
	Refresh();
    };
}
/*--------------------------
  WICube
----------------------------*/
// Constructeur
WICube::WICube() {
    // MyApp=o;win=w;sh=s;
    // manip=new Cube ("MANIP");
    manip=NULL;
}
WICube::~WICube() {
    // puts ("In Window CUBE destructor");
    // delete manip;
}
void WICube::SetDefault() {
    c->width=2.0;
    c->height=2.0;
    c->depth=2.0;
    Refresh();
}
void WICube::Set (VRMLNode *n, int w) {
    c=(Cube *) n;which=w;
    manip=(Cube *) c->Clone();
    Refresh();
    SetAttrs((Object *) MyApp->WI_Cube, MUIA_Window_Open, TRUE);
    // PopUp();
}
int WICube::Ok() {
    delete (manip);
    return which;
}
void WICube::Cancel() {
    c->Copy(manip);
    delete (manip);
}
void WICube::ReadValues() {
    ULONG store=0;

    GetAttr (MUIA_String_Contents, (Object *) MyApp->STR_DEFCubeName, &store);
    c->SetName((char *) store);
    GetAttr (MUIA_String_Contents, (Object *) MyApp->STR_CubeWidth, &store);
    c->width=(double) atof((char *) store);
    GetAttr (MUIA_String_Contents, (Object *) MyApp->STR_CubeHeight, &store);
    c->height=(double) atof((char *) store);
    GetAttr (MUIA_String_Contents, (Object *) MyApp->STR_CubeDepth, &store);
    c->depth=(double) atof((char *) store);
}

void WICube::Refresh() {
    char temp[25];

    sh.mode=SYSTEM;
    SetAttrs ((Object *) MyApp->STR_DEFCubeName,MUIA_String_Contents, (ULONG) c->GetName());
    ftoa(c->width,temp);
    SetAttrs ((Object *) MyApp->STR_CubeWidth,MUIA_String_Contents, (ULONG) temp);
    ftoa(c->height,temp);
    SetAttrs ((Object *) MyApp->STR_CubeHeight,MUIA_String_Contents, (ULONG) temp);
    ftoa(c->depth,temp);
    SetAttrs ((Object *) MyApp->STR_CubeDepth,MUIA_String_Contents, (ULONG) temp);
    sh.mode=USER;
}
/*--------------------------
  WICylinder
----------------------------*/
// Constructeur
WICylinder::WICylinder() {
    // MyApp=o;win=w;sh=s;
    // manip=new Cylinder ("MANIP");
    manip=NULL;
}
WICylinder::~WICylinder() {
    // puts ("In Window CUBE destructor");
    // delete manip;
}
void WICylinder::SetDefault() {
    c->radius=1.0;
    c->height=2.0;
    c->parts=ALL;
    Refresh();
}
void WICylinder::Set (VRMLNode *n, int w) {
    c=(Cylinder *) n;which=w;
    manip=(Cylinder *) c->Clone();
    Refresh();
    SetAttrs((Object *) MyApp->WI_Cylinder,MUIA_Window_Open, TRUE);
    // PopUp();
}
int WICylinder::Ok() {
    delete (manip);
    return which;
}
void WICylinder::Cancel() {
    c->Copy(manip);
    delete manip;
}
void WICylinder::ReadValues() {
    int p=0;
    BOOL ck;
    ULONG store;

    // puts("In cylinder ReadValues");
    GetAttr (MUIA_String_Contents, (Object *) MyApp->STR_DEFCylinderName, &store);
    c->SetName((char *) store);
    GetAttr (MUIA_String_Contents, (Object *) MyApp->STR_CylinderRadius, &store);
    c->radius=(double) atof((char *) store);
    GetAttr (MUIA_String_Contents, (Object *) MyApp->STR_CylinderHeight, &store);
    c->height=(double) atof((char *) store);

    GetAttr (MUIA_Selected, (Object *) MyApp->CH_CylinderSides, &store);
    ck=(BOOL) store;
    if (ck) p=1;
    GetAttr (MUIA_Selected, (Object *) MyApp->CH_CylinderTop, &store);
    ck=(BOOL) store;
    if (ck) p=p+2;
    GetAttr (MUIA_Selected, (Object *) MyApp->CH_CylinderBottom, &store);
    ck=(BOOL) store;
    if (ck) p=p+4;
    c->parts=p;
}
void WICylinder::Refresh() {
    int p;
    BOOL ck;
    char temp[25];

    sh.mode=SYSTEM;
    SetAttrs ((Object *) MyApp->STR_DEFCylinderName,MUIA_String_Contents, (ULONG) c->GetName());
    ftoa(c->radius,temp);
    SetAttrs ((Object *) MyApp->STR_CylinderRadius,MUIA_String_Contents, (ULONG) temp);
    ftoa(c->height,temp);
    SetAttrs ((Object *) MyApp->STR_CylinderHeight,MUIA_String_Contents, (ULONG) temp);
    p=c->parts;
    if ((p&1)==1) {ck=TRUE;}
    else {ck=FALSE;};
    SetAttrs ((Object *) MyApp->CH_CylinderSides,MUIA_Selected,ck);

    if ((p&2)==2) {ck=TRUE;}
    else {ck=FALSE;};
    SetAttrs ((Object *) MyApp->CH_CylinderTop,MUIA_Selected,ck);

    if ((p&4)==4) {ck=TRUE;}
    else {ck=FALSE;};
    SetAttrs ((Object *) MyApp->CH_CylinderBottom,MUIA_Selected,ck);
    sh.mode=USER;
}
/*--------------------------
  WIDirectionalLight
---------------------------*/
WIDirectionalLight::WIDirectionalLight() {
    // MyApp=o;win=w;sh=sh;
    // manip=new DirectionalLight("MANIP");
    manip=NULL;
}
WIDirectionalLight::~WIDirectionalLight() {
    // delete manip;
}
void WIDirectionalLight::Set(VRMLNode *n, int w) {
    dl=(DirectionalLight *) n;
    which=w;
    manip=(DirectionalLight *) dl->Clone();
    Refresh();
    SetAttrs((Object *) MyApp->WI_DirectionalLight, MUIA_Window_Open, TRUE);
}
int WIDirectionalLight::Ok() {
    delete (manip);
    return which;
}
void WIDirectionalLight::Cancel() {
    dl->Copy(manip);
    delete (manip);
}
void WIDirectionalLight::SetDefault() {
    dl->point.Set(0.0,0.0,-1.0,0.0);
    dl->color.Set(1.0,1.0,1.0,1.0);
    dl->intensity=1.0;
    dl->on=1;
    Refresh();
}
void WIDirectionalLight::Refresh() {
    char temp[25];

    sh.mode=SYSTEM;
    SetAttrs((Object *) MyApp->STR_DEFDirectionalLightName, MUIA_String_Contents, (ULONG) dl->GetName());
    ftoa(dl->point.coord[0],temp);
    SetAttrs((Object *) MyApp->STR_DirectionalLightX, MUIA_String_Contents, (ULONG) temp);
    ftoa(dl->point.coord[1],temp);
    SetAttrs((Object *) MyApp->STR_DirectionalLightY, MUIA_String_Contents, (ULONG) temp);
    ftoa(dl->point.coord[2],temp);
    SetAttrs((Object *) MyApp->STR_DirectionalLightZ, MUIA_String_Contents, (ULONG) temp);
    ftoa(dl->color.rgb[0],temp);
    SetAttrs((Object *) MyApp->STR_DirectionalLightR, MUIA_String_Contents, (ULONG) temp);
    ftoa(dl->color.rgb[1],temp);
    SetAttrs((Object *) MyApp->STR_DirectionalLightG, MUIA_String_Contents, (ULONG) temp);
    ftoa(dl->color.rgb[2],temp);
    SetAttrs((Object *) MyApp->STR_DirectionalLightB, MUIA_String_Contents, (ULONG) temp);
    ftoa(dl->intensity,temp);
    SetAttrs((Object *) MyApp->STR_DirectionalLightIntensity, MUIA_String_Contents, (ULONG) temp);
    SetAttrs((Object *) MyApp->CH_DirectionalLightOn, MUIA_Selected, dl->on);
    sh.mode=USER;
}
void WIDirectionalLight::ReadValues() {
    ULONG store;

    GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_DEFDirectionalLightName, &store);
    dl->SetName((char *) store);
    GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_DirectionalLightX, &store);
    dl->point.coord[0]=(double) atof((char *) store);
    GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_DirectionalLightY, &store);
    dl->point.coord[1]=(double) atof((char *) store);
    GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_DirectionalLightZ, &store);
    dl->point.coord[2]=(double) atof((char *) store);
    GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_DirectionalLightR, &store);
    dl->color.rgb[0]=(double) atof((char *) store);
    GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_DirectionalLightG, &store);
    dl->color.rgb[1]=(double) atof((char *) store);
    GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_DirectionalLightB, &store);
    dl->color.rgb[2]=(double) atof((char *) store);
    GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_DirectionalLightIntensity, &store);
    dl->intensity=(double) atof((char *) store);
    GetAttr(MUIA_Selected, (Object *) MyApp->CH_DirectionalLightOn, &store);
    dl->on=(BOOL) store;
}
/*------------------------
  WIFontStyle
--------------------------*/
WIFontStyle::WIFontStyle() {
    // MyApp=o;win=w;sh=sh;
    // manip=new FontStyle("MANIP");
    manip=NULL;
}
WIFontStyle::~WIFontStyle() {
    // delete manip;
}
void WIFontStyle::Set(VRMLNode *n, int w) {
    fs=(FontStyle *) n;which=w;
    manip=(FontStyle *) fs->Clone();
    Refresh();
    SetAttrs((Object *) MyApp->WI_FontStyle, MUIA_Window_Open, TRUE);
}
int WIFontStyle::Ok() {
    delete (manip);
    return which;
}
void WIFontStyle::SetDefault() {
    fs->size=10.0;
    fs->family=FONTFAMILY_SERIF;
    fs->style=FONTSTYLE_NONE;
    Refresh();
}
void WIFontStyle::Cancel() {
    // puts("In FONTSTYLE cancel");
    fs->Copy(manip);
    delete manip;
}
void WIFontStyle::Refresh() {
    char temp[25];
    int f,st=0;
    BOOL ck;

    sh.mode=SYSTEM;
    SetAttrs((Object *) MyApp->STR_DEFFontStyleName, MUIA_String_Contents, (ULONG) fs->GetName());
    ftoa (fs->size,temp);
    SetAttrs((Object *) MyApp->STR_FontStyleSize, MUIA_String_Contents, (ULONG) temp);
    switch (fs->family) {
	case FONTFAMILY_SERIF:f=0;break;
	case FONTFAMILY_SANS:f=1;break;
	case FONTFAMILY_TYPEWRITER:f=2;break;
    };
    SetAttrs((Object *) MyApp->CY_FontStyleFamily, MUIA_Cycle_Active, (ULONG) f);

    st=fs->style;
    if ((st&FONTSTYLE_BOLD)==FONTSTYLE_BOLD) {ck=TRUE;}
    else {ck=FALSE;};
    SetAttrs((Object *) MyApp->CH_FontStyleBold, MUIA_Selected,ck);

    if ((st&FONTSTYLE_ITALIC)==FONTSTYLE_ITALIC) {ck=TRUE;}
    else {ck=FALSE;};
    SetAttrs((Object *) MyApp->CH_FontStyleItalic, MUIA_Selected, (ULONG) ck);
    sh.mode=USER;
}
void WIFontStyle::ReadValues() {
    ULONG store;
    int f,st=0;
    BOOL ck;

    GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_DEFFontStyleName, &store);
    fs->SetName((char *) store);
    GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_FontStyleSize, &store);
    fs->size=(double) atof((char *) store);
    GetAttr(MUIA_Cycle_Active, (Object *) MyApp->CY_FontStyleFamily, &store);
    f=(int) store;
    switch (f) {
	case 0:fs->family=FONTFAMILY_SERIF;break;
	case 1:fs->family=FONTFAMILY_SANS;break;
	case 2:fs->family=FONTFAMILY_TYPEWRITER;break;
    };
    GetAttr(MUIA_Selected, (Object *) MyApp->CH_FontStyleBold, &store);
    ck=(BOOL) store;
    if (ck==1) st=st+1;
    GetAttr(MUIA_Selected, (Object *) MyApp->CH_FontStyleItalic, &store);
    ck=(BOOL) store;
    if (ck==1) st=st+2;
    fs->style=st;
}
/*-----------------------------------------------------------------------
  WIGroups (Group,LOD,Separator,Switch, TransformSeparator, WWWAnchor)
-------------------------------------------------------------------------*/
WIGroups::WIGroups() {
    // MyApp=o;win=w;sh=s;
    win=MyApp->WI_Groups;
    puts("WIGroups constructor");
}
WIGroups::~WIGroups() {
    // puts("WIGroup destructore");
}
void WIGroups::Set(VRMLNode *n, int w) {
    // puts("In WIGroups::Set");
    gr=(VRMLGroups *) n;
    // parent=(VRMLGroups *) p;
    which=w;
    Refresh();
    // DisableMainWindow();
    SetAttrs(MyApp->WI_Groups, MUIA_Window_Open, TRUE);
    // printf("ID:%d\n",gr->ID);
    // printf("SEPARATOR:%d\n",SEPARATOR_1);
    // PopUp();
    // puts("after the popup");
}
int WIGroups::Ok() {
    EnableMainWindow();

    return which;
}

void WIGroups::RefreshLOD() {
    float x,y,z;
    int sel=-1;
    ULONG store=0;
    char temp[25];
    LOD *lod=(LOD *) gr;

    sh.mode=SYSTEM;
    // lod->GetCenter(x,y,z);
    GetAttr(MUIA_Prop_First, (Object *) MyApp->PR_LODRangeIndex, &store);
    sel=(int) store;
    // printf("selcted:%d\n",sel);
    itoa(sel,temp);
    SetAttrs((Object *) MyApp->TX_LODRangeIndex, MUIA_Text_Contents, (ULONG) temp);
    ftoa(lod->GetRange(sel),temp);
    SetAttrs((Object *) MyApp->STR_LODRange, MUIA_String_Contents, (ULONG) temp);
    sh.mode=USER;
}
void WIGroups::ReadValuesLOD() {
    ULONG store;
    float x,y,z;
    int sel=-1;
    char temp[25];
    LOD *lod=(LOD *) gr;

    
    GetAttr(MUIA_Prop_First, (Object *) MyApp->PR_LODRangeIndex, &store);
    sel=(int) store;
    // itoa(lod->Size(),temp);
    // SetAttrs((Object *) MyApp->TX_LODNum, MUIA_Text_Contents, temp);
    GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_LODRange, &store);
    lod->SetRange(sel,(float) atof((char *) store));
}

void WIGroups::Refresh() {
    char temp[25];

    // puts("in refresh");
    // Hide();
    sh.mode=SYSTEM;
    SetAttrs((Object *) MyApp->GR_GroupsLOD, MUIA_ShowMe, FALSE);
    SetAttrs((Object *) MyApp->GR_GroupsSeparator, MUIA_ShowMe, FALSE);
    SetAttrs((Object *) MyApp->GR_GroupsSwitch, MUIA_ShowMe, FALSE);
    SetAttrs((Object *) MyApp->GR_GroupsWWWAnchor, MUIA_ShowMe, FALSE);

    SetAttrs((Object *) MyApp->STR_DEFGroupsName, MUIA_String_Contents, (ULONG) gr->GetName());
    itoa(gr->Size(),temp);
    SetAttrs((Object *) MyApp->TX_GroupsNum, MUIA_Text_Contents, (ULONG) temp);
    if (gr->ID==GROUP_1) {
	SetAttrs((Object *) MyApp->TX_GroupsType, MUIA_Text_Contents, (ULONG) "Group");
    }
    else if (gr->ID==LOD_1) {
	SetAttrs((Object *) MyApp->TX_GroupsType, MUIA_Text_Contents, (ULONG) "LOD");
	SetAttrs((Object *) MyApp->GR_GroupsLOD, MUIA_ShowMe, TRUE);
	LOD *lod=(LOD *) gr;
	SetAttrs((Object *) MyApp->PR_LODRangeIndex,MUIA_Prop_Entries,(LONG) lod->RangeSize());
	SetAttrs((Object *) MyApp->PR_LODRangeIndex,MUIA_Prop_Visible,1);
	SetAttrs((Object *) MyApp->PR_LODRangeIndex,MUIA_Prop_First,0);
	ftoa(lod->center.coord[0],temp);
	SetAttrs((Object *) MyApp->STR_LODCenterX, MUIA_String_Contents, (ULONG) temp);
	ftoa(lod->center.coord[1],temp);
	SetAttrs((Object *) MyApp->STR_LODCenterY, MUIA_String_Contents, (ULONG) temp);
	ftoa(lod->center.coord[2],temp);
	SetAttrs((Object *) MyApp->STR_LODCenterZ, MUIA_String_Contents, (ULONG) temp);
	RefreshLOD();
    }
    else if (gr->ID==SEPARATOR_1) {
	    SetAttrs((Object *) MyApp->TX_GroupsType, MUIA_Text_Contents, (ULONG) "Separator");
	    SetAttrs((Object *) MyApp->GR_GroupsSeparator, MUIA_ShowMe, TRUE);
	    Separator *tp=(Separator *) gr;
	    printf("renderCulling:%d\n",tp->renderCulling);
	    SetAttrs((Object *) MyApp->CY_SeparatorRenderCulling, MUIA_Cycle_Active, tp->renderCulling);
	    // puts("ok2");
    }
    else if (gr->ID==SWITCH_1) {
	    SetAttrs((Object *) MyApp->GR_GroupsSwitch, MUIA_ShowMe, TRUE);
	    SetAttrs((Object *) MyApp->TX_GroupsType, MUIA_Text_Contents, (ULONG) "Switch");
	    Switch *tp=(Switch *) gr;
	    itoa(tp->whichChild,temp);
	    SetAttrs((Object *) MyApp->STR_SwitchWhich, MUIA_String_Contents,(ULONG) temp);
    }
    else if (gr->ID==TRANSFORMSEPARATOR_1) {
	    SetAttrs((Object *) MyApp->TX_GroupsType, MUIA_Text_Contents, (ULONG) "TransformSeparator");
    }
    else if (gr->ID==WWWANCHOR_1) {
	    SetAttrs((Object *) MyApp->GR_GroupsWWWAnchor, MUIA_ShowMe, TRUE);
	    SetAttrs((Object *) MyApp->TX_GroupsType, MUIA_Text_Contents, (ULONG) "WWWAnchor");
	    WWWAnchor *tp=(WWWAnchor *) gr;
	    SetAttrs((Object *) MyApp->STR_WWWAnchorName, MUIA_String_Contents, (ULONG) tp->GetURL());
	    SetAttrs((Object *) MyApp->STR_WWWAnchorDescription, MUIA_String_Contents, (ULONG) tp->GetDescription());
	    SetAttrs((Object *) MyApp->CY_WWWAnchorMap, MUIA_Cycle_Active, tp->map);
    };
    sh.mode=USER;
    // puts("out of refresh");
}
void WIGroups::ReadValues() {
    ULONG store;
    char temp[255];

    // printf("in readvalues:%d\n",gr->ID);
    GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_DEFGroupsName, &store);
    gr->SetName((char *) store);

    if(gr->ID==LOD_1) {
	LOD *tp=(LOD *) gr;
	GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_LODCenterX, &store);
	tp->center.coord[0]=(double) atof((char *) store);
	GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_LODCenterY, &store);
	tp->center.coord[1]=(double) atof((char *) store);
	GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_LODCenterZ, &store);
	tp->center.coord[2]=(double) atof((char *) store);
    }
    else if (gr->ID==SEPARATOR_1) {
	Separator *tp=(Separator *) gr;
	GetAttr(MUIA_Cycle_Active, (Object *) MyApp->CY_SeparatorRenderCulling, &store);
	tp->renderCulling=(int) store;
	// printf("renderCulling:%d\n",tp->renderCulling);
    }
    else if (gr->ID==SWITCH_1) {
	Switch *tp=(Switch *) gr;
	GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_SwitchWhich, &store);
	tp->whichChild=atoi((char *) store);
    }
    else if (gr->ID==TRANSFORMSEPARATOR_1) {
    }
    else if (gr->ID==WWWANCHOR_1) {
	WWWAnchor *tp=(WWWAnchor *) gr;
	GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_WWWAnchorName, &store);
	tp->SetURL((char *) store);
	GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_WWWAnchorDescription, &store);
	tp->SetDescription((char *) store);
	GetAttr(MUIA_String_Contents, (Object *) MyApp->CY_WWWAnchorMap, &store);
	tp->map=(int) store;
    };
}
void WIGroups::Add() {
    ULONG store=0;
    int sel=-1;
    LOD *lod=(LOD *) gr;

    // puts("add");
    sh.mode=SYSTEM;
    GetAttr(MUIA_Prop_First, (Object *) MyApp->PR_LODRangeIndex, &store);
    sel=(int) store;
    lod->InsertRange(sel,0);
    // printf("inserted after position:%d, size:%d\n",sel,lod->RangeSize());
    SetAttrs((Object *) MyApp->PR_LODRangeIndex,MUIA_Prop_Entries,(LONG) lod->RangeSize());
    sh.mode=USER;
}
void WIGroups::Delete() {
    ULONG store=0;
    int sel=-1;
    LOD *lod=(LOD *) gr;

    GetAttr(MUIA_Prop_First, (Object *) MyApp->PR_LODRangeIndex, &store);
    sel=(int) store;
    if (lod->Size()<=1) {
	MUI_Request (MyApp->App,MyApp->WI_Groups,0,"Error","Ok",
				    "You can't delete the first range !");
    }
    else {
	sh.mode=SYSTEM;
	lod->RemoveRange(sel);
	SetAttrs((Object *) MyApp->PR_LODRangeIndex,MUIA_Prop_Entries,(LONG) lod->RangeSize());
	sh.mode=USER;
    };
}
/*--------------------------
  WIIndexedFaceSet
----------------------------*/
WIIndexedFaceSet::WIIndexedFaceSet() {
    // puts("WIIndexedFaceSet constructor"),
    // MyApp=o;win=w;sh=s;
    // manip=new IndexedFaceSet("MANIP");
    manip=NULL;
}
WIIndexedFaceSet::~WIIndexedFaceSet() {
    // delete manip;
}
int WIIndexedFaceSet::Selected() {
    ULONG store;
    GetAttr(MUIA_Prop_First,(Object *) MyApp->PR_IFSIndex, &store);
    return (int) store;
}
int WIIndexedFaceSet::SelectedCoordEntry() {
    ULONG store;
    GetAttr(MUIA_List_Active, (Object *) MyApp->LV_IFSCoordIndex, &store);
    return (int) store;
}
int WIIndexedFaceSet::SelectedMatEntry() {
    ULONG store;
    GetAttr(MUIA_List_Active, (Object *) MyApp->LV_IFSMaterialIndex, &store);
    return (int) store;
}
int WIIndexedFaceSet::SelectedNormalEntry() {
    ULONG store;
    GetAttr(MUIA_List_Active, (Object *) MyApp->LV_IFSNormalIndex, &store);
    return (int) store;
}
int WIIndexedFaceSet::SelectedTextureEntry() {
    ULONG store;
    GetAttr(MUIA_List_Active, (Object *) MyApp->LV_IFSTexIndex, &store);
    return (int) store;
}
void WIIndexedFaceSet::Set(VRMLNode *n, int w) {
    puts("WIIndexedFaceSet::Set");
    char temp[25];which=w;
    ifs=(IndexedFaceSet *) n;
    manip=(IndexedFaceSet *) n->Clone();
    sh.mode=SYSTEM;
    SetAttrs((Object *) MyApp->STR_DEFIFSName,MUIA_String_Contents, (ULONG) ifs->GetName());
    SetAttrs((Object *) MyApp->PR_IFSIndex,MUIA_Prop_Entries,(LONG) ifs->Size());
    SetAttrs((Object *) MyApp->PR_IFSIndex,MUIA_Prop_Visible,1);
    SetAttrs((Object *) MyApp->PR_IFSIndex,MUIA_Prop_First,0);
    itoa(ifs->Size(),temp);
    SetAttrs((Object *) MyApp->TX_IFSNum,MUIA_Text_Contents, (ULONG) temp);
    SetAttrs((Object *) MyApp->CH_IFSMat,MUIA_Selected,(BOOL) ifs->writeMaterialIndex);
    SetAttrs((Object *) MyApp->CH_IFSNormal,MUIA_Selected, (BOOL) ifs->writeNormalIndex);
    SetAttrs((Object *) MyApp->CH_IFSTex,MUIA_Selected, (BOOL) ifs->writeTextureCoordIndex);
    sh.mode=USER;
    Refresh();
    SetAttrs((Object *) MyApp->WI_IFS, MUIA_Window_Open, TRUE);
    // PopUp();
}
void WIIndexedFaceSet::Refresh() {
    ULONG store;
    char temp[25];
    Face *cf;
    int sel=Selected(),i=0;
    int activecoord=SelectedCoordEntry();
    int activemat=SelectedMatEntry();
    int activenormal=SelectedNormalEntry();
    int activetex=SelectedTextureEntry();
    if (activecoord==-1) activecoord=0;
    if (activemat==-1) activemat=0;
    if (activenormal==-1) activenormal=0;
    if (activetex==-1) activetex=0;

    sh.mode=SYSTEM;
    itoa(sel,temp);
    SetAttrs((Object *) MyApp->TX_IFSIndex, MUIA_Text_Contents,(ULONG)  temp);
    DoMethod((Object *) MyApp->LV_IFSCoordIndex,MUIM_List_Clear);
    DoMethod((Object *) MyApp->LV_IFSMaterialIndex,MUIM_List_Clear);
    DoMethod((Object *) MyApp->LV_IFSNormalIndex,MUIM_List_Clear);
    DoMethod((Object *) MyApp->LV_IFSTexIndex,MUIM_List_Clear);
    cf=ifs->GetFace(sel);
    for (i=0;i<cf->coordIndex.Length();i++) {
	itoa(cf->coordIndex.Get(i),temp);
	DoMethod((Object *) MyApp->LV_IFSCoordIndex,MUIM_List_InsertSingle,temp,MUIV_List_Insert_Bottom);
    };
    for (i=0;i<cf->materialIndex.Length();i++) {
	itoa(cf->materialIndex.Get(i),temp);
	DoMethod((Object *) MyApp->LV_IFSMaterialIndex,MUIM_List_InsertSingle,temp,MUIV_List_Insert_Bottom);
    };
    for (i=0;i<cf->normalIndex.Length();i++) {
	itoa(cf->normalIndex.Get(i),temp);
	DoMethod((Object *) MyApp->LV_IFSNormalIndex,MUIM_List_InsertSingle,temp,MUIV_List_Insert_Bottom);
    };
    for (i=0;i<cf->textureCoordIndex.Length();i++) {
	itoa(cf->textureCoordIndex.Get(i),temp);
	DoMethod((Object *) MyApp->LV_IFSTexIndex,MUIM_List_InsertSingle,temp,MUIV_List_Insert_Bottom);
    };
    SetAttrs((Object *) MyApp->LV_IFSCoordIndex,MUIA_List_Active,activecoord, NULL);
    SetAttrs((Object *) MyApp->LV_IFSMaterialIndex,MUIA_List_Active,activemat, NULL);
    SetAttrs((Object *) MyApp->LV_IFSNormalIndex, MUIA_List_Active,activenormal, NULL);
    SetAttrs((Object *) MyApp->LV_IFSTexIndex, MUIA_List_Active,activetex, NULL);
    RefreshValue();
    sh.mode=USER;
}
void WIIndexedFaceSet::RefreshValue() {
    ULONG store;
    sh.mode=SYSTEM;
    DoMethod((Object *) MyApp->LV_IFSCoordIndex,MUIM_List_GetEntry,MUIV_List_GetEntry_Active, &store);
    SetAttrs((Object *) MyApp->STR_IFSValue,MUIA_String_Contents,(ULONG)  store, NULL);
    DoMethod((Object *) MyApp->LV_IFSMaterialIndex,MUIM_List_GetEntry,MUIV_List_GetEntry_Active, &store);
    SetAttrs((Object *) MyApp->STR_IFSMatValue,MUIA_String_Contents,(ULONG)  store, NULL);
    DoMethod((Object *) MyApp->LV_IFSNormalIndex,MUIM_List_GetEntry,MUIV_List_GetEntry_Active, &store);
    SetAttrs((Object *) MyApp->STR_IFSNormalValue,MUIA_String_Contents,(ULONG)  store, NULL);
    DoMethod((Object *) MyApp->LV_IFSTexIndex,MUIM_List_GetEntry,MUIV_List_GetEntry_Active, &store);
    SetAttrs((Object *) MyApp->STR_IFSTexValue,MUIA_String_Contents,(ULONG)  store, NULL);
    sh.mode=USER;
}
void WIIndexedFaceSet::ReadValues() {
    ULONG store;
    char temp[25];
    int value,active;
    Face *cf;

    cf=ifs->GetFace(Selected());
    GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_DEFIFSName, &store);
    ifs->SetName((char *) store);
    
    active=SelectedCoordEntry();
    GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_IFSValue, &store);
    value=atoi((char *) store);
    cf->coordIndex.Set(active,atoi((char *) store));

    active=SelectedMatEntry();
    GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_IFSMatValue, &store);
    value=atoi((char *) store);
    cf->materialIndex.Set(active,atoi((char *) store));

    active=SelectedNormalEntry();
    GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_IFSNormalValue, &store);
    value=atoi((char *) store);
    cf->normalIndex.Set(active,atoi((char *) store));

    active=SelectedTextureEntry();
    GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_IFSTexValue, &store);
    value=atoi((char *) store);
    cf->textureCoordIndex.Set(active,atoi((char *) store));
    Refresh();
}
int WIIndexedFaceSet::Ok() {
    ULONG store;
    ifs->bbox=NOTYET;
    GetAttr(MUIA_Selected, (Object *) MyApp->CH_IFSMat, &store);
    ifs->writeMaterialIndex=(int) store;
    GetAttr(MUIA_Selected, (Object *) MyApp->CH_IFSNormal, &store);
    ifs->writeNormalIndex=(int) store;
    GetAttr(MUIA_Selected, (Object *) MyApp->CH_IFSTex, &store);
    ifs->writeTextureCoordIndex=(int) store;
    delete manip;
    return which;
}
void WIIndexedFaceSet::Cancel() {
    ifs->Copy(manip);
    delete manip;
}
void WIIndexedFaceSet::AddPoint() {
    ULONG store;
    Face *cf=ifs->GetFace(Selected());
    int active=SelectedCoordEntry();
    cf->coordIndex.InsertAfter(active,0);
    Refresh();
}
void WIIndexedFaceSet::DeletePoint() {
    ULONG store;
    Face *cf=ifs->GetFace(Selected());
    if (cf->coordIndex.Length()<=1) {
	MUI_Request (MyApp->App,MyApp->WI_IFS,0,"Error","Ok",
				    "You can't delete the firat point in face !");
    }
    else {
	int active=SelectedCoordEntry();
	cf->coordIndex.RemoveEntry(active);
	Refresh();
    };
}
void WIIndexedFaceSet::AddMat() {
    // puts("In AddMat");
    Face *cf=ifs->GetFace(Selected());
    int active=SelectedMatEntry();
    cf->materialIndex.InsertAfter(active,0);
    Refresh();
}
void WIIndexedFaceSet::DeleteMat() {
    Face *cf=ifs->GetFace(Selected());
    int active=SelectedMatEntry();
    if (active==-1) {
	MUI_Request (MyApp->App,MyApp->WI_IFS,0,"Error","Ok",
				    "No materialIndex to delete");
    }
    else {
	cf->materialIndex.RemoveEntry(active);
	Refresh();
    };
}
void WIIndexedFaceSet::AddNormal() {
    // puts("In AddMat");
    Face *cf=ifs->GetFace(Selected());
    int active=SelectedNormalEntry();
    cf->normalIndex.InsertAfter(active,0);
    Refresh();
}
void WIIndexedFaceSet::DeleteNormal() {
    Face *cf=ifs->GetFace(Selected());
    int active=SelectedNormalEntry();
    if (active==-1) {
	MUI_Request (MyApp->App,MyApp->WI_IFS,0,"Error","Ok",
				    "No normalIndex to delete");
    }
    else {
	cf->normalIndex.RemoveEntry(active);
	Refresh();
    };
}
void WIIndexedFaceSet::AddTexture() {
    // puts("In AddMat");
    Face *cf=ifs->GetFace(Selected());
    int active=SelectedTextureEntry();
    cf->textureCoordIndex.InsertAfter(active,0);
    Refresh();
}
void WIIndexedFaceSet::DeleteTexture() {
    Face *cf=ifs->GetFace(Selected());
    int active=SelectedTextureEntry();
    if (active==-1) {
	MUI_Request (MyApp->App,MyApp->WI_IFS,0,"Error","Ok",
				    "No textureCoordIndex to delete");
    }
    else {
	cf->textureCoordIndex.RemoveEntry(active);
	Refresh();
    };
}
void WIIndexedFaceSet::AddFace() {
    char temp[25];
    Face *cf=new Face();

    cf->coordIndex.Add(0);
    ifs->InsertFace(Selected(),cf);
    SetAttrs((Object *) MyApp->PR_IFSIndex,MUIA_Prop_Entries,(LONG) ifs->Size());
    itoa(ifs->Size(),temp);
    SetAttrs((Object *) MyApp->TX_IFSNum,MUIA_Text_Contents,(ULONG) temp);
    Refresh();
}
void WIIndexedFaceSet::DeleteFace() {
    char temp[25];
    if (ifs->Size()<=1) {
	MUI_Request (MyApp->App,MyApp->WI_IFS,0,"Error","Ok",
				    "You can't delete the first face !");
    }
    else {
	delete (ifs->RemoveFace(Selected()));
	SetAttrs((Object *) MyApp->PR_IFSIndex,MUIA_Prop_Entries,(LONG) ifs->Size());
	itoa(ifs->Size(),temp);
	SetAttrs((Object *) MyApp->TX_IFSNum,MUIA_Text_Contents,(ULONG) temp);
	Refresh();
    };
}
/*------------------------
    WIIndexedLinetSet
-------------------------*/
WIIndexedLineSet::WIIndexedLineSet() {
    // MyApp=o;win=w;sh=s;
    manip=new IndexedLineSet("MANIP");
}
WIIndexedLineSet::~WIIndexedLineSet() {
    delete manip;
}
int WIIndexedLineSet::Selected() {
    ULONG store;
    GetAttr(MUIA_Prop_First,(Object *) MyApp->PR_ILSIndex, &store);
    return (int) store;
}
int WIIndexedLineSet::SelectedCoordEntry() {
    ULONG store;
    GetAttr(MUIA_List_Active, (Object *) MyApp->LV_ILSCoordIndex, &store);
    return (int) store;
}
int WIIndexedLineSet::SelectedMatEntry() {
    ULONG store;
    GetAttr(MUIA_List_Active, (Object *) MyApp->LV_ILSMaterialIndex, &store);
    return (int) store;
}
int WIIndexedLineSet::SelectedNormalEntry() {
    ULONG store;
    GetAttr(MUIA_List_Active, (Object *) MyApp->LV_ILSNormalIndex, &store);
    return (int) store;
}
int WIIndexedLineSet::SelectedTextureEntry() {
    ULONG store;
    GetAttr(MUIA_List_Active, (Object *) MyApp->LV_ILSTexIndex, &store);
    return (int) store;
}
void WIIndexedLineSet::Set(VRMLNode *n, int w) {
    char temp[25];which=w;
    ils=(IndexedLineSet *) n;
    manip->Copy(n);
    sh.mode=SYSTEM;
    SetAttrs((Object *) MyApp->STR_DEFILSName,MUIA_String_Contents,(ULONG) ils->GetName());
    SetAttrs((Object *) MyApp->PR_ILSIndex,MUIA_Prop_Entries,(LONG) ils->Size());
    SetAttrs((Object *) MyApp->PR_ILSIndex,MUIA_Prop_Visible,1);
    SetAttrs((Object *) MyApp->PR_ILSIndex,MUIA_Prop_First,0);
    itoa(ils->Size(),temp);
    SetAttrs((Object *) MyApp->TX_ILSNum,MUIA_Text_Contents,(ULONG) temp);
    SetAttrs((Object *) MyApp->CH_ILSMat,MUIA_Selected,(BOOL) ils->writeMaterialIndex);
    SetAttrs((Object *) MyApp->CH_ILSNormal,MUIA_Selected, (BOOL) ils->writeNormalIndex);
    SetAttrs((Object *) MyApp->CH_ILSTex,MUIA_Selected, (BOOL) ils->writeTextureCoordIndex);
    sh.mode=USER;
    Refresh();
    SetAttrs((Object *) MyApp->WI_ILS, MUIA_Window_Open, TRUE);

}
void WIIndexedLineSet::Refresh() {
    ULONG store;
    char temp[25];
    Face *cf;
    int sel=Selected(),i=0;
    int activecoord=SelectedCoordEntry();
    int activemat=SelectedMatEntry();
    int activenormal=SelectedNormalEntry();
    int activetex=SelectedTextureEntry();
    if (activecoord==-1) activecoord=0;
    if (activemat==-1) activemat=0;
    if (activenormal==-1) activenormal=0;
    if (activetex==-1) activetex=0;

    sh.mode=SYSTEM;
    itoa(sel,temp);
    SetAttrs((Object *) MyApp->TX_ILSIndex, MUIA_Text_Contents, (ULONG) temp);
    DoMethod((Object *) MyApp->LV_ILSCoordIndex,MUIM_List_Clear);
    DoMethod((Object *) MyApp->LV_ILSMaterialIndex,MUIM_List_Clear);
    DoMethod((Object *) MyApp->LV_ILSNormalIndex,MUIM_List_Clear);
    DoMethod((Object *) MyApp->LV_ILSTexIndex,MUIM_List_Clear);
    cf=ils->GetLine(sel);
    for (i=0;i<cf->coordIndex.Length();i++) {
	itoa(cf->coordIndex.Get(i),temp);
	DoMethod((Object *) MyApp->LV_ILSCoordIndex,MUIM_List_InsertSingle,temp,MUIV_List_Insert_Bottom);
    };
    for (i=0;i<cf->materialIndex.Length();i++) {
	itoa(cf->materialIndex.Get(i),temp);
	DoMethod((Object *) MyApp->LV_ILSMaterialIndex,MUIM_List_InsertSingle,temp,MUIV_List_Insert_Bottom);
    };
    for (i=0;i<cf->normalIndex.Length();i++) {
	itoa(cf->normalIndex.Get(i),temp);
	DoMethod((Object *) MyApp->LV_ILSNormalIndex,MUIM_List_InsertSingle,temp,MUIV_List_Insert_Bottom);
    };
    for (i=0;i<cf->textureCoordIndex.Length();i++) {
	itoa(cf->textureCoordIndex.Get(i),temp);
	DoMethod((Object *) MyApp->LV_ILSTexIndex,MUIM_List_InsertSingle,temp,MUIV_List_Insert_Bottom);
    };
    SetAttrs((Object *) MyApp->LV_ILSCoordIndex,MUIA_List_Active,activecoord, NULL);
    SetAttrs((Object *) MyApp->LV_ILSMaterialIndex,MUIA_List_Active,activemat, NULL);
    SetAttrs((Object *) MyApp->LV_ILSNormalIndex, MUIA_List_Active,activenormal, NULL);
    SetAttrs((Object *) MyApp->LV_ILSTexIndex, MUIA_List_Active,activetex, NULL);
    RefreshValue();
    sh.mode=USER;
}
void WIIndexedLineSet::RefreshValue() {
    ULONG store;
    sh.mode=SYSTEM;
    DoMethod((Object *) MyApp->LV_ILSCoordIndex,MUIM_List_GetEntry,MUIV_List_GetEntry_Active, &store);
    SetAttrs((Object *) MyApp->STR_ILSValue,MUIA_String_Contents,(ULONG)  store);
    DoMethod((Object *) MyApp->LV_ILSMaterialIndex,MUIM_List_GetEntry,MUIV_List_GetEntry_Active, &store);
    SetAttrs((Object *) MyApp->STR_ILSMatValue,MUIA_String_Contents,(ULONG)  store);
    DoMethod((Object *) MyApp->LV_ILSNormalIndex,MUIM_List_GetEntry,MUIV_List_GetEntry_Active, &store);
    SetAttrs((Object *) MyApp->STR_ILSNormalValue,MUIA_String_Contents,(ULONG)  store);
    DoMethod((Object *) MyApp->LV_ILSTexIndex,MUIM_List_GetEntry,MUIV_List_GetEntry_Active, &store);
    SetAttrs((Object *) MyApp->STR_ILSTexValue,MUIA_String_Contents,(ULONG)  store);
    sh.mode=USER;
}
void WIIndexedLineSet::ReadValues() {
    ULONG store;
    char temp[25];
    int value,active;
    Face *cf;

    cf=ils->GetLine(Selected());
    GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_DEFILSName, &store);
    ils->SetName((char *) store);

    active=SelectedCoordEntry();
    GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_ILSValue, &store);
    value=atoi((char *) store);
    cf->coordIndex.Set(active,atoi((char *) store));

    active=SelectedMatEntry();
    GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_ILSMatValue, &store);
    value=atoi((char *) store);
    cf->materialIndex.Set(active,atoi((char *) store));

    active=SelectedNormalEntry();
    GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_ILSNormalValue, &store);
    value=atoi((char *) store);
    cf->normalIndex.Set(active,atoi((char *) store));

    active=SelectedTextureEntry();
    GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_ILSTexValue, &store);
    value=atoi((char *) store);
    cf->textureCoordIndex.Set(active,atoi((char *) store));
    Refresh();
}
int WIIndexedLineSet::Ok() {
    ULONG store;
    ils->bbox=NOTYET;
    GetAttr(MUIA_Selected, (Object *) MyApp->CH_IFSMat, &store);
    ils->writeMaterialIndex=(int) store;
    GetAttr(MUIA_Selected, (Object *) MyApp->CH_IFSNormal, &store);
    ils->writeNormalIndex=(int) store;
    GetAttr(MUIA_Selected, (Object *) MyApp->CH_IFSTex, &store);
    ils->writeTextureCoordIndex=(int) store;
    return which;
}
void WIIndexedLineSet::Cancel() {
    ils->Copy(manip);
}
void WIIndexedLineSet::AddPoint() {
    ULONG store;
    Face *cf=ils->GetLine(Selected());
    int active=SelectedCoordEntry();
    cf->coordIndex.InsertAfter(active,0);
    Refresh();
}
void WIIndexedLineSet::DeletePoint() {
    ULONG store;
    Face *cf=ils->GetLine(Selected());
    if (cf->coordIndex.Length()<=1) {
	MUI_Request (MyApp->App,MyApp->WI_ILS,0,"Error","Ok",
				    "You can't delete the firat point in line !");
    }
    else {
	int active=SelectedCoordEntry();
	cf->coordIndex.RemoveEntry(active);
	Refresh();
    };
}
void WIIndexedLineSet::AddMat() {
    // puts("In AddMat");
    Face *cf=ils->GetLine(Selected());
    int active=SelectedMatEntry();
    cf->materialIndex.InsertAfter(active,0);
    Refresh();
}
void WIIndexedLineSet::DeleteMat() {
    Face *cf=ils->GetLine(Selected());
    int active=SelectedMatEntry();
    if (active==-1) {
	MUI_Request (MyApp->App,MyApp->WI_ILS,0,"Error","Ok",
				    "No materialIndex to delete");
    }
    else {
	cf->materialIndex.RemoveEntry(active);
	Refresh();
    };
}
void WIIndexedLineSet::AddNormal() {
    // puts("In AddMat");
    Face *cf=ils->GetLine(Selected());
    int active=SelectedNormalEntry();
    cf->normalIndex.InsertAfter(active,0);
    Refresh();
}
void WIIndexedLineSet::DeleteNormal() {
    Face *cf=ils->GetLine(Selected());
    int active=SelectedNormalEntry();
    if (active==-1) {
	MUI_Request (MyApp->App,MyApp->WI_ILS,0,"Error","Ok",
				    "No normalIndex to delete");
    }
    else {
	cf->normalIndex.RemoveEntry(active);
	Refresh();
    };
}
void WIIndexedLineSet::AddTexture() {
    // puts("In AddMat");
    Face *cf=ils->GetLine(Selected());
    int active=SelectedTextureEntry();
    cf->textureCoordIndex.InsertAfter(active,0);
    Refresh();
}
void WIIndexedLineSet::DeleteTexture() {
    Face *cf=ils->GetLine(Selected());
    int active=SelectedTextureEntry();
    if (active==-1) {
	MUI_Request (MyApp->App,MyApp->WI_ILS,0,"Error","Ok",
				    "No textureCoordIndex to delete");
    }
    else {
	cf->textureCoordIndex.RemoveEntry(active);
	Refresh();
    };
}
void WIIndexedLineSet::AddLine() {
    char temp[25];
    Face *cf=new Face();

    cf->coordIndex.Add(0);
    ils->InsertLine(Selected(),cf);
    SetAttrs((Object *) MyApp->PR_ILSIndex,MUIA_Prop_Entries,(LONG) ils->Size());
    itoa(ils->Size(),temp);
    SetAttrs((Object *) MyApp->TX_ILSNum,MUIA_Text_Contents,(ULONG) temp);
    Refresh();
}
void WIIndexedLineSet::DeleteLine() {
    char temp[25];
    if (ils->Size()<=1) {
	MUI_Request (MyApp->App,MyApp->WI_ILS,0,"Error","Ok",
				    "You can't delete the first face !");
    }
    else {
	delete (ils->RemoveLine(Selected()));
	SetAttrs((Object *) MyApp->PR_ILSIndex,MUIA_Prop_Entries,(LONG) ils->Size());
	itoa(ils->Size(),temp);
	SetAttrs((Object *) MyApp->TX_ILSNum,MUIA_Text_Contents,(ULONG) temp);
	Refresh();
    };
}
/*---------------------
    WIInfo
-----------------------*/
WIInfo::WIInfo() {
    // MyApp=o;win=w;sh=s;
    // manip=new VInfo("MANIP");
    manip=NULL;
}
WIInfo::~WIInfo() {
    // delete manip;
}
void WIInfo::Set(VRMLNode *n, int w) {
    in=(VInfo *) n;which=w;
    manip=(VInfo *) n->Clone();
    Refresh();
    // PopUp();
    SetAttrs((Object *) MyApp->WI_Info, MUIA_Window_Open, TRUE);
}
void WIInfo::Refresh() {
    sh.mode=SYSTEM;
    SetAttrs((Object *) MyApp->STR_DEFInfoName, MUIA_String_Contents, (ULONG) in->GetName());
    SetAttrs((Object *) MyApp->STR_InfoString, MUIA_String_Contents, (ULONG) in->GetString());
    sh.mode=USER;
}
void WIInfo::ReadValues() {
    ULONG store;

    GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_DEFInfoName, &store);
    in->SetName((char *) store);
    GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_InfoString, &store);
    in->SetString((char *) store);
}
int WIInfo::Ok() {
    delete manip;
    return which;
}
void WIInfo::Cancel() {
    in->Copy(manip);
    delete manip;
}
/*-----------------------
  WILOD
------------------------*/
/*
WILOD::WILOD() {
    // MyApp=o;win=w;sh=s;
}
WILOD::~WILOD() {
}
void WILOD::Set(VRMLNode *n, int w) {
    int num;
    char temp[25];

    lod=(LOD *) n;which=w;
    sh.mode=SYSTEM;
    SetAttrs((Object *) MyApp->PR_LODRangeIndex,MUIA_Prop_Entries,(LONG) lod->RangeSize());
    SetAttrs((Object *) MyApp->PR_LODRangeIndex,MUIA_Prop_Visible,1,NULL);
    SetAttrs((Object *) MyApp->PR_LODRangeIndex,MUIA_Prop_First,0,NULL);
    itoa(lod->Size(),temp);
    SetAttrs((Object *) MyApp->TX_LODNum, MUIA_Text_Contents, temp);
    sh.mode=USER;
    Refresh();
    DisableMainWindow();
    PopUp();
}
int WILOD::Selected() {
    ULONG store;
    GetAttr(MUIA_Prop_First,MyApp->PR_LODRangeIndex, &store);
    return (int) store;

    // itoa(index,temp);
    // SetAttrs((Object *) MyApp->TX_LODRangeIndex, MUIA_Text_Contents, temp, NULL);
}
void WILOD::Refresh() {
    float x,y,z;
    char temp[25];

    sh.mode=SYSTEM;
    SetAttrs((Object *) MyApp->STR_DEFLODName, MUIA_String_Contents, lod->GetName(),NULL);
    // lod->GetCenter(x,y,z);
    ftoa(lod->center.coord[0],temp);
    SetAttrs((Object *) MyApp->STR_LODCenterX, MUIA_String_Contents, temp, NULL);
    ftoa(lod->center.coord[1],temp);
    SetAttrs((Object *) MyApp->STR_LODCenterY, MUIA_String_Contents, temp, NULL);
    ftoa(lod->center.coord[2],temp);
    SetAttrs((Object *) MyApp->STR_LODCenterZ, MUIA_String_Contents, temp, NULL);
    itoa(Selected(),temp);
    SetAttrs((Object *) MyApp->TX_LODRangeIndex, MUIA_Text_Contents, temp, NULL);
    ftoa(lod->GetRange(Selected()),temp);
    SetAttrs((Object *) MyApp->STR_LODRange, MUIA_String_Contents, temp, NULL);
    sh.mode=USER;
}
void WILOD::ReadValues() {
    ULONG store;
    float x,y,z;
    char temp[25];

    GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_DEFLODName, &store);
    lod->SetName((char *) store);
    GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_LODCenterX, &store);
    lod->center.coord[0]=atof((char *) store);
    GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_LODCenterY, &store);
    lod->center.coord[1]=atof((char *) store);
    GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_LODCenterZ, &store);
    lod->center.coord[2]=atof((char *) store);
    GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_LODRange, &store);
    lod->SetRange(Selected(),atof((char *) store));
}
void WILOD::Add() {
    sh.mode=SYSTEM;
    lod->InsertRange(Selected(),0);
    SetAttrs((Object *) MyApp->PR_LODRangeIndex,MUIA_Prop_Entries,(LONG) lod->RangeSize());
    sh.mode=USER;
}
void WILOD::Delete() {
    if (lod->Size()<=1) {
	MUI_Request (MyApp->App,MyApp->WI_ILS,0,"Error","Ok",
				    "You can't delete the first range !");
    }
    else {
	sh.mode=SYSTEM;
	lod->RemoveRange(Selected());
	SetAttrs((Object *) MyApp->PR_LODRangeIndex,MUIA_Prop_Entries,(LONG) lod->RangeSize());
	sh.mode=USER;
    };
}
int WILOD::Ok() {
    EnableMainWindow();
    return which;
}
*/
/*-----------------------------------------------
  WIMaterial
------------------------------------------------*/
WIMaterial::WIMaterial() {
    // MyApp=o;win=w;sh=s;
    manip=NULL;
}
WIMaterial::~WIMaterial() {
    // delete manip;
}
/*
void WIMaterial::VRMLToRGB (int r, int g, int b, int& r1, int& g1, int& b1) {
    float rr,gg,bb;
    rr=2.55*(float) r;
    gg=2.55*(float) g;
    bb=2.55*(float) b;
    r1=(int) rr;
    g1=(int) gg;
    b1=(int) bb;
}
void WIMaterial::RGBToULONG (int r, int g, int b, ULONG& ru, ULONG& gu, ULONG& bu) {
    ru=(r<<24);
    gu=(g<<24);
    bu=(b<<24);
}
*/
int WIMaterial::Selected() {
    ULONG store;
    GetAttr(MUIA_Prop_First, (Object *) MyApp->PR_MaterialIndex, &store);
    // printf("selected:%d\n",(int) store);
    return (int) store;
}
void WIMaterial::Set(VRMLNode *n, int w) {
    char temp[25];

    m=(Material *) n;which=w;
    manip=(Material *) m->Clone();
    sh.mode=SYSTEM;
    SetAttrs((Object *) MyApp->STR_DEFMaterialName, MUIA_String_Contents, (ULONG) m->GetName());
    SetAttrs((Object *) MyApp->PR_MaterialIndex,MUIA_Prop_Entries,(LONG) m->Size());
    SetAttrs((Object *) MyApp->PR_MaterialIndex,MUIA_Prop_Visible,1);
    SetAttrs((Object *) MyApp->PR_MaterialIndex,MUIA_Prop_First,0);
    itoa(m->Size(),temp);
    SetAttrs((Object *) MyApp->TX_MaterialNum,MUIA_Text_Contents,(ULONG) temp);
    Refresh();
    SetAttrs((Object *) MyApp->WI_Material,MUIA_Window_Open, TRUE);
    sh.mode=USER;
}
Mat *WIMaterial::GetCurrentMat() {
    return m->GetMaterial(Selected());
}
void WIMaterial::Refresh() {
    float fr,fg,fb,s,t;
    ULONG store;
    int r,g,b;
    char temp[25];
    Mat *cm=NULL;

    // puts("Refresh");
    // DoMethod((Object *) MyApp->AR_MatGLArea, MUIM_GLArea_Redraw);
    sh.mode=SYSTEM;
    itoa(Selected(),temp);
    SetAttrs((Object *) MyApp->TX_MaterialIndex, MUIA_Text_Contents,(ULONG) temp);
    cm=m->GetMaterial(Selected());

    // fr=cm->ambient.rgb[0];
    // fg=cm->ambient.rgb[1];
    // fb=cm->ambient.rgb[2];
    r=(int) floor(cm->ambient.rgb[0]*101);
    g=(int) floor(cm->ambient.rgb[1]*101);
    b=(int) floor(cm->ambient.rgb[2]*101);
    SetAttrs((Object *) MyApp->SL_MaterialAR, MUIA_Numeric_Value, r);
    SetAttrs((Object *) MyApp->SL_MaterialAG, MUIA_Numeric_Value, g);
    SetAttrs((Object *) MyApp->SL_MaterialAB, MUIA_Numeric_Value, b);
    // printf("shininess:%f\n",cm->shininess);

    // fr=cm->diffuse.rgb[0];
    // fg=cm->diffuse.rgb[1];
    // fb=cm->diffuse.rgb[2];
    r=(int) floor(cm->diffuse.rgb[0]*101);
    g=(int) floor(cm->diffuse.rgb[1]*101);
    b=(int) floor(cm->diffuse.rgb[2]*101);
    // printf("refresh this -----d:%d %d %d\n",r,g,b);
    SetAttrs((Object *) MyApp->SL_MaterialDR,MUIA_Numeric_Value, r);
    SetAttrs((Object *) MyApp->SL_MaterialDG,MUIA_Numeric_Value, g);
    SetAttrs((Object *) MyApp->SL_MaterialDB,MUIA_Numeric_Value, b);

    // fr=cm->specular.rgb[0];
    // fg=cm->specular.rgb[1];
    // fb=cm->specular.rgb[2];
    r=(int) floor(cm->specular.rgb[0]*101);
    g=(int) floor(cm->specular.rgb[1]*101);
    b=(int) floor(cm->specular.rgb[2]*101);
    // printf("-----f:%d %d %d\n",r,g,b);
    SetAttrs((Object *) MyApp->SL_MaterialSR, MUIA_Numeric_Value, r);
    SetAttrs((Object *) MyApp->SL_MaterialSG, MUIA_Numeric_Value, g);
    SetAttrs((Object *) MyApp->SL_MaterialSB, MUIA_Numeric_Value, b);

    GetAttr(MUIA_Numeric_Value, (Object *) MyApp->SL_MaterialSR, &store);
    // printf("after the set:%d\n",(int) store);
    // printf("specular:%f %f %f\n",cm->specular.rgb[0],cm->specular.rgb[1],cm->specular.rgb[2]);

    // fr=cm->emissive.rgb[0];
    // fg=cm->emissive.rgb[1];
    // fb=cm->emissive.rgb[2];
    r=(int) floor(cm->emissive.rgb[0]*101);
    g=(int) floor(cm->emissive.rgb[1]*101);
    b=(int) floor(cm->emissive.rgb[2]*101);
    SetAttrs((Object *) MyApp->SL_MaterialER,MUIA_Numeric_Value, r);
    SetAttrs((Object *) MyApp->SL_MaterialEG,MUIA_Numeric_Value, g);
    SetAttrs((Object *) MyApp->SL_MaterialEB,MUIA_Numeric_Value, b);
    // printf("shininess:%f\n",cm->shininess);
    ftoa(cm->shininess/128.0,temp);
    SetAttrs((Object *) MyApp->STR_MaterialShininess,MUIA_String_Contents,(ULONG) temp);
    ftoa(cm->transparency,temp);
    SetAttrs((Object *) MyApp->STR_MaterialTransparency,MUIA_String_Contents,(ULONG) temp);
    ReadAmbient();
    ReadDiffuse();
    ReadSpecular();
    ReadEmissive();
    sh.mode=USER;
}
void WIMaterial::ReadAmbient() {
    double fr,fg,fb;
    ULONG cf[3];
    Mat *cm=NULL;

    // puts("ReadAmbient");
    cm=m->GetMaterial(Selected());
    cf[0]=DoMethod((Object *) MyApp->SL_MaterialAR, MUIM_Numeric_ValueToScale,0,255);
    fr=cf[0]/255.0;
    cf[0]= (cf[0]<<24);

    cf[1]=DoMethod((Object *) MyApp->SL_MaterialAG, MUIM_Numeric_ValueToScale,0,255);
    fg=cf[1]/255.0;
    cf[1]=(cf[1]<<24);

    cf[2]=DoMethod((Object *) MyApp->SL_MaterialAB, MUIM_Numeric_ValueToScale,0,255);
    fb=cf[2]/255.0;
    cf[2]=(cf[2]<<24);

    cm->ambient.Set(fr,fg,fb);
    SetAttrs ((Object *) MyApp->CF_MaterialAmbient,MUIA_Colorfield_RGB, (ULONG) cf);
    // DoMethod((Object *) MyApp->AR_MatGLArea, MUIM_GLArea_Redraw);
}
void WIMaterial::ReadDiffuse() {
    float fr,fg,fb;
    ULONG cf[3];
    Mat *cm=NULL;

    // puts("ReadDiffuse");
    cm=m->GetMaterial(Selected());
    cf[0]=DoMethod((Object *) MyApp->SL_MaterialDR, MUIM_Numeric_ValueToScale,0,255);
    fr=cf[0]/255.0;
    cf[0]= (cf[0]<<24);

    cf[1]=DoMethod((Object *) MyApp->SL_MaterialDG, MUIM_Numeric_ValueToScale,0,255);
    fg=cf[1]/255.0;
    cf[1]=(cf[1]<<24);

    cf[2]=DoMethod((Object *) MyApp->SL_MaterialDB, MUIM_Numeric_ValueToScale,0,255);
    fb=cf[2]/255.0;
    cf[2]=(cf[2]<<24);

    // printf("what i readed f:%f %f %f\n",fr,fg,fb);
    cm->diffuse.Set(fr,fg,fb);
    SetAttrs ((Object *) MyApp->CF_MaterialDiffuse,MUIA_Colorfield_RGB,(ULONG) cf);
    // DoMethod((Object *) MyApp->AR_MatGLArea, MUIM_GLArea_Redraw);
}
void WIMaterial::ReadSpecular() {
    float fr,fg,fb;
    ULONG cf[3];
    Mat *cm=NULL;

    puts("=>ReadSpecular");
    cm=m->GetMaterial(Selected());
    // printf("specular:%f %f %f\n",cm->specular.rgb[0],cm->specular.rgb[1],cm->specular.rgb[2]);
    // GetAttr (MUIA_Numeric_Value, (Object *) MyApp->SL_MaterialSR, &store);
    // r=(int) store;
    cf[0]=DoMethod((Object *) MyApp->SL_MaterialSR, MUIM_Numeric_ValueToScale,0,255);
    fr=cf[0]/255.0;
    cf[0]= (cf[0]<<24);

    // GetAttr (MUIA_Numeric_Value, (Object *) MyApp->SL_MaterialSG, &store);
    // g=(int) store;
    cf[1]=DoMethod((Object *) MyApp->SL_MaterialSG, MUIM_Numeric_ValueToScale,0,255);
    fg=cf[1]/255.0;
    cf[1]=(cf[1]<<24);
    // GetAttr (MUIA_Numeric_Value, (Object *) MyApp->SL_MaterialSB, &store);
    // b=(int) store;
    cf[2]=DoMethod((Object *) MyApp->SL_MaterialSB, MUIM_Numeric_ValueToScale,0,255);
    fb=cf[2]/255.0;
    cf[2]=(cf[2]<<24);
    puts("after the getattr");
    // printf("readead i:%d %d %d\n",r,g,b);
    // fr=(float) r/100.0;
    // fg=(float) g/100.0;
    // fb=(float) b/100.0;
    // printf("--->f:%f %f %f\n",fr,fg,fb);
    cm->specular.Set(fr,fg,fb);
    // printf("in material specular:%f %f %f\n",cm->specular.rgb[0],cm->specular.rgb[1],cm->specular.rgb[2]);
    // VRMLToRGB (r,g,b,r1,g1,b1);
    // RGBToULONG (r1,g1,b1,cf[0],cf[1],cf[2]);
    puts("before the setcolorfield");
    SetAttrs ((Object *) MyApp->CF_MaterialSpecular,MUIA_Colorfield_RGB,(ULONG) cf);
    puts("<=ReadSpecular");
    // DoMethod((Object *) MyApp->AR_MatGLArea, MUIM_GLArea_Redraw);
}
void WIMaterial::ReadEmissive() {
    float fr,fg,fb;
    ULONG cf[3];
    Mat *cm=NULL;

    // puts("ReadEmissive");
    cm=m->GetMaterial(Selected());
    cf[0]=DoMethod((Object *) MyApp->SL_MaterialER, MUIM_Numeric_ValueToScale,0,255);
    fr=cf[0]/255.0;
    cf[0]= (cf[0]<<24);

    cf[1]=DoMethod((Object *) MyApp->SL_MaterialEG, MUIM_Numeric_ValueToScale,0,255);
    fg=cf[1]/255.0;
    cf[1]=(cf[1]<<24);

    cf[2]=DoMethod((Object *) MyApp->SL_MaterialEB, MUIM_Numeric_ValueToScale,0,255);
    fb=cf[2]/255.0;
    cf[2]=(cf[2]<<24);

    cm->emissive.Set(fr,fg,fb);
    SetAttrs ((Object *) MyApp->CF_MaterialEmmisive,MUIA_Colorfield_RGB,(ULONG) cf);
    // DoMethod((Object *) MyApp->AR_MatGLArea, MUIM_GLArea_Redraw);
}
void WIMaterial::ReadValues() {
    float s,t;
    ULONG store;

    puts("ReadValues");
    Mat *cm=m->GetMaterial(Selected());
    GetAttr (MUIA_String_Contents,(Object *) MyApp->STR_DEFMaterialName, &store);
    m->SetName((char *) store);
    GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_MaterialShininess, &store);
    s=(double) atof((char *) store);
    cm->shininess=s*128.0;
    GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_MaterialTransparency, &store);
    t=(double) atof((char *) store);
    cm->transparency=t;
    cm->SetTransparency();
    // DoMethod((Object *) MyApp->AR_MatGLArea, MUIM_GLArea_Redraw);
}
void WIMaterial::SetDefault() {
    Mat *cm=NULL;

    cm=m->GetMaterial(Selected());
    cm->ambient.Set(0.2,0.2,0.2,1.0);
    cm->diffuse.Set(0.8,0.8,0.8,1.0);
    cm->specular.Set(0,0,0,1.0);
    cm->emissive.Set(0,0,0,1.0);
    cm->shininess=0.2*128.0;
    cm->transparency=0.0;
    cm->SetTransparency();
    Refresh();
    DoMethod((Object *) MyApp->AR_MatGLArea, MUIM_GLArea_Redraw);
}
void WIMaterial::Add() {
    char temp[25];

    m->InsertMaterial(Selected(),new Mat());
    SetAttrs((Object *) MyApp->PR_MaterialIndex,MUIA_Prop_Entries,(LONG) m->Size());
    itoa(m->Size(),temp);
    SetAttrs((Object *) MyApp->TX_MaterialNum,MUIA_Text_Contents,(ULONG) temp);
    // Refresh();
}
void WIMaterial::Delete() {
    char temp[25];

    if (m->Size()<=1) {
	MUI_Request (MyApp->App,win,0,"Error","Ok",
				    "You can't delete the firat material !");
    }
    else {
	delete m->RemoveMaterial(Selected());
	SetAttrs((Object *) MyApp->PR_MaterialIndex,MUIA_Prop_Entries,(LONG) m->Size());
	itoa(m->Size(),temp);
	SetAttrs((Object *) MyApp->TX_MaterialNum,MUIA_Text_Contents,(ULONG) temp);
	Refresh();
    };
}
int WIMaterial::Ok() {
    delete (manip);
    return which;
}
void WIMaterial::Cancel() {
    m->Copy(manip);
    delete (manip);
}
void WIMaterial::Clear() {
    manip->Clear();
}
/*------------------------------------------------
  WIMaterialBinding
-------------------------------------------------*/
WIMaterialBinding::WIMaterialBinding() {
    // MyApp=o;win=w;sh=s;
    // manip=new MaterialBinding("MANIP");
    manip=NULL;
}
WIMaterialBinding::~WIMaterialBinding() {
    // delete manip;
}
void WIMaterialBinding::Set(VRMLNode *n, int w) {
    puts("set");
    mb=(MaterialBinding *) n;which=w;
    manip=(MaterialBinding *) n->Clone();
    Refresh();
    // PopUp();
    SetAttrs((Object *) MyApp->WI_MaterialBinding, MUIA_Window_Open, TRUE);
}
void WIMaterialBinding::Refresh() {
    sh.mode=SYSTEM;
    SetAttrs((Object *) MyApp->STR_DEFMaterialBindingName,MUIA_String_Contents,(ULONG) mb->GetName());
    // which=mb->GetBindType();
    SetAttrs((Object *) MyApp->CY_MaterialBinding,MUIA_Cycle_Active,(ULONG) mb->value);
    sh.mode=USER;
}
void WIMaterialBinding::ReadValues() {
    ULONG store;
    GetAttr(MUIA_String_Contents,(Object *) MyApp->STR_DEFMaterialBindingName, &store);
    mb->SetName((char *) store);
    GetAttr(MUIA_Cycle_Active,(Object *) MyApp->CY_MaterialBinding, &store);
    switch ((int) store) {
	case 0:mb->value=BINDING_OVERALL;break;
	case 1:mb->value=BINDING_DEFAULT;break;
	case 2:mb->value=BINDING_PER_PART;break;
	case 3:mb->value=BINDING_PER_PART_INDEXED;break;
	case 4:mb->value=BINDING_PER_FACE;break;
	case 5:mb->value=BINDING_PER_FACE_INDEXED;break;
	case 6:mb->value=BINDING_PER_VERTEX;break;
	case 7:mb->value=BINDING_PER_VERTEX_INDEXED;break;
    };
}
int WIMaterialBinding::Ok() {
    delete manip;
    return which;
}
void WIMaterialBinding::Cancel() {
    mb->Copy(manip);
    delete manip;
}
/*------------------------------
  WIMatrixTransform
-------------------------------*/
WIMatrixTransform::WIMatrixTransform() {
    // MyApp=o;win=w;sh=s;
    // manip=new MatrixTransform("MANIP");
    manip=NULL;
}
WIMatrixTransform::~WIMatrixTransform() {
    // delete manip;
}
void WIMatrixTransform::Set(VRMLNode *n, int w) {
    mt=(MatrixTransform *) n;which=w;
    manip=(MatrixTransform *) n->Clone();
    Refresh();
    SetAttrs((Object *) MyApp->WI_MatrixTransform, MUIA_Window_Open, TRUE);
    // PopUp();
}
void WIMatrixTransform::Refresh() {
    float tab[16];
    char temp[16][25];

    sh.mode=SYSTEM;
    SetAttrs((Object *) MyApp->STR_DEFMatrixTransformName, MUIA_String_Contents, (ULONG) mt->GetName(),NULL);
    mt->GetMatrixv(tab);
    for (int i=0;i<16;i++) {
	ftoa(tab[i],temp[i]);
    };
    SetAttrs((Object *) MyApp->STR_MatrixTransform0, MUIA_String_Contents, (ULONG) temp[0],NULL);
    SetAttrs((Object *) MyApp->STR_MatrixTransform1, MUIA_String_Contents, (ULONG) temp[1],NULL);
    SetAttrs((Object *) MyApp->STR_MatrixTransform2, MUIA_String_Contents, (ULONG) temp[2],NULL);
    SetAttrs((Object *) MyApp->STR_MatrixTransform3, MUIA_String_Contents, (ULONG) temp[3],NULL);
    SetAttrs((Object *) MyApp->STR_MatrixTransform4, MUIA_String_Contents, (ULONG) temp[4],NULL);
    SetAttrs((Object *) MyApp->STR_MatrixTransform5, MUIA_String_Contents, (ULONG) temp[5],NULL);
    SetAttrs((Object *) MyApp->STR_MatrixTransform6, MUIA_String_Contents, (ULONG) temp[6],NULL);
    SetAttrs((Object *) MyApp->STR_MatrixTransform7, MUIA_String_Contents, (ULONG) temp[7],NULL);
    SetAttrs((Object *) MyApp->STR_MatrixTransform8, MUIA_String_Contents, (ULONG) temp[8],NULL);
    SetAttrs((Object *) MyApp->STR_MatrixTransform9, MUIA_String_Contents, (ULONG) temp[9],NULL);
    SetAttrs((Object *) MyApp->STR_MatrixTransform10, MUIA_String_Contents, (ULONG) temp[10],NULL);
    SetAttrs((Object *) MyApp->STR_MatrixTransform11, MUIA_String_Contents, (ULONG) temp[11],NULL);
    SetAttrs((Object *) MyApp->STR_MatrixTransform12, MUIA_String_Contents, (ULONG) temp[12],NULL);
    SetAttrs((Object *) MyApp->STR_MatrixTransform13, MUIA_String_Contents, (ULONG) temp[13],NULL);
    SetAttrs((Object *) MyApp->STR_MatrixTransform14, MUIA_String_Contents, (ULONG) temp[14],NULL);
    SetAttrs((Object *) MyApp->STR_MatrixTransform15, MUIA_String_Contents, (ULONG) temp[15],NULL);
    sh.mode=USER;
}
void WIMatrixTransform::ReadValues() {
    ULONG store;
    float tab[16];
    char temp[16][25];

    GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_DEFMatrixTransformName, &store);
    mt->SetName((char *) store);
    GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_MatrixTransform0, &store);
    tab[0]=(double) atof((char *) store);
    GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_MatrixTransform1, &store);
    tab[1]=(double) atof((char *) store);
    GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_MatrixTransform2, &store);
    tab[2]=(double) atof((char *) store);
    GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_MatrixTransform3, &store);
    tab[3]=(double) atof((char *) store);
    GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_MatrixTransform4, &store);
    tab[4]=(double) atof((char *) store);
    GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_MatrixTransform5, &store);
    tab[5]=(double) atof((char *) store);
    GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_MatrixTransform6, &store);
    tab[6]=(double) atof((char *) store);
    GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_MatrixTransform7, &store);
    tab[7]=(double) atof((char *) store);
    GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_MatrixTransform8, &store);
    tab[8]=(double) atof((char *) store);
    GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_MatrixTransform9, &store);
    tab[9]=(double) atof((char *) store);
    GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_MatrixTransform10, &store);
    tab[10]=(double) atof((char *) store);
    GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_MatrixTransform11, &store);
    tab[11]=(double) atof((char *) store);
    GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_MatrixTransform12, &store);
    tab[12]=(double) atof((char *) store);
    GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_MatrixTransform13, &store);
    tab[13]=(double) atof((char *) store);
    GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_MatrixTransform14, &store);
    tab[14]=(double) atof((char *) store);
    GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_MatrixTransform15, &store);
    tab[15]=(double) atof((char *) store);
    mt->SetMatrixv(tab);
}
int WIMatrixTransform::Ok() {
    delete manip;
    return which;
}
void WIMatrixTransform::SetDefault() {
    float tab[16]={1,0,0,0,
		   0,1,0,0,
		   0,0,1,0,
		   0,0,0,1};
    mt->SetMatrixv(tab);
    Refresh();
}
void WIMatrixTransform::Cancel() {
    mt->Copy(manip);
    delete manip;
}
/*----------------------------------
  WINormal
----------------------------------*/
WINormal::WINormal() {
    // MyApp=o;win=w;sh=s;
    // manip=new Normal("MANIP");
    manip=NULL;
}
WINormal::~WINormal() {
    // delete manip;
}
void WINormal::Set(VRMLNode *n, int w) {
    char temp[25];

    no=(Normal *) n;which=w;
    manip=(Normal *) no->Clone();
    sh.mode=SYSTEM;
    SetAttrs((Object *) MyApp->PR_NormalIndex,MUIA_Prop_Entries,(LONG) no->Size());
    SetAttrs((Object *) MyApp->PR_NormalIndex,MUIA_Prop_Visible,1,NULL);
    SetAttrs((Object *) MyApp->PR_NormalIndex,MUIA_Prop_First,0,NULL);
    itoa(no->Size(),temp);
    SetAttrs((Object *) MyApp->TX_NormalNum, MUIA_Text_Contents, (ULONG) temp);
    sh.mode=USER;
    Refresh();
    // PopUp();
    SetAttrs((Object *) MyApp->WI_Normal, MUIA_Window_Open, TRUE);
}
int WINormal::Selected() {
    ULONG store;
    GetAttr(MUIA_Prop_First, (Object *) MyApp->PR_NormalIndex, &store);
    return (int) store;
}
void WINormal::Refresh() {
    char temp[25];
    Vertex3d *cp;
    sh.mode=SYSTEM;
    cp=no->GetVector(Selected());
    itoa(Selected(),temp);
    SetAttrs((Object *) MyApp->TX_NormalIndex, MUIA_Text_Contents, (ULONG) temp);
    ftoa(cp->coord[0],temp);
    SetAttrs((Object *) MyApp->STR_NormalX, MUIA_String_Contents, (ULONG) temp);
    ftoa(cp->coord[1],temp);
    SetAttrs((Object *) MyApp->STR_NormalY, MUIA_String_Contents, (ULONG) temp);
    ftoa(cp->coord[2],temp);
    SetAttrs((Object *) MyApp->STR_NormalZ, MUIA_String_Contents, (ULONG) temp);
    sh.mode=USER;
}
void WINormal::ReadValues() {
    ULONG store;
    float x,y,z;
    Vertex3d *cp;

    cp=no->GetVector(Selected());
    GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_DEFNormalName, &store);
    no->SetName((char *) store);
    GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_NormalX, &store);
    cp->coord[0]=(double) atof((char *) store);
    GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_NormalY, &store);
    cp->coord[1]=(double) atof((char *) store);
    GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_NormalZ, &store);
    cp->coord[2]=(double) atof((char *) store);
}
void WINormal::Add() {
    no->InsertVector(Selected(),new Vertex3d(0,0,0));
    sh.mode=SYSTEM;
    SetAttrs((Object *) MyApp->PR_NormalIndex,MUIA_Prop_Entries,(LONG) no->Size());
    sh.mode=USER;
    Refresh();
}
void WINormal::Delete() {
    if (no->Size()<=1) {
	MUI_Request (MyApp->App,win,0,"Error","Ok",
		     "You can't delete the firat normal !");
    }
    else {
	  delete no->RemoveVector(Selected());
	  sh.mode=SYSTEM;
	  SetAttrs((Object *) MyApp->PR_NormalIndex,MUIA_Prop_Entries,(LONG) no->Size());
	  sh.mode=USER;
    };
}
int WINormal::Ok() {
    delete manip;
    return which;
}
void WINormal::Cancel() {
    no->Copy(manip);
    delete manip;
}

/*------------------------------------
  WINormalBinding
-------------------------------------*/
WINormalBinding::WINormalBinding() {
    // MyApp=o;win=w;sh=s;
    // manip=new NormalBinding("MANIP");
    manip=NULL;
}
WINormalBinding::~WINormalBinding() {
    // delete manip;
}
void WINormalBinding::Set(VRMLNode *n, int w) {
    nb=(NormalBinding *) n;which=w;
    manip=(NormalBinding *) nb->Clone();
    Refresh();
    // PopUp();
    SetAttrs((Object *) MyApp->WI_NormalBinding, MUIA_Window_Open, TRUE);
}
void WINormalBinding::Refresh() {
    sh.mode=SYSTEM;
    SetAttrs((Object *) MyApp->STR_DEFNormalBindingName,MUIA_String_Contents,(ULONG) nb->GetName(),NULL);
    SetAttrs((Object *) MyApp->CY_NormalBindingValue,MUIA_Cycle_Active,(ULONG) nb->value,NULL);
    sh.mode=USER;
}
void WINormalBinding::ReadValues() {
    ULONG store;
    GetAttr(MUIA_String_Contents,(Object *) MyApp->STR_DEFNormalBindingName, &store);
    nb->SetName((char *) store);
    GetAttr(MUIA_Cycle_Active,(Object *) MyApp->CY_NormalBindingValue, &store);
    switch ((int)store) {
	case 0:nb->value=BINDING_OVERALL;break;
	case 1:nb->value=BINDING_DEFAULT;break;
	case 2:nb->value=BINDING_PER_PART;break;
	case 3:nb->value=BINDING_PER_PART_INDEXED;break;
	case 4:nb->value=BINDING_PER_FACE;break;
	case 5:nb->value=BINDING_PER_FACE_INDEXED;break;
	case 6:nb->value=BINDING_PER_VERTEX;break;
	case 7:nb->value=BINDING_PER_VERTEX_INDEXED;break;
    };
}
int WINormalBinding::Ok() {
    delete manip;
    return which;
}
void WINormalBinding::Cancel() {
    nb->Copy(manip);
    delete manip;
}
/*--------------------------
  WIOrthographicCamera
---------------------------*/
WIOrthographicCamera::WIOrthographicCamera() {
    // MyApp=o;win=w;sh=s;
    manip=new OrthographicCamera("MANIP");
}
WIOrthographicCamera::~WIOrthographicCamera() {
    delete manip;
}
void WIOrthographicCamera::Set(VRMLNode *n, int w) {
    oc=(OrthographicCamera *) n;which=w;
    manip->Copy(oc);
    Refresh();
    PopUp();
}
void WIOrthographicCamera::Refresh() {
    char temp[15];

    sh.mode=SYSTEM;
    SetAttrs((Object *) MyApp->STR_DEFOrthographicCameraName, MUIA_String_Contents, (ULONG) oc->GetName(),NULL);
    // oc->GetPosition(x,y,z);
    ftoa(oc->position.coord[0],temp);
    SetAttrs((Object *) MyApp->STR_OrthographicCameraPosX, MUIA_String_Contents, (ULONG) temp, NULL);
    ftoa(oc->position.coord[1],temp);
    SetAttrs((Object *) MyApp->STR_OrthographicCameraPosY, MUIA_String_Contents, (ULONG) temp, NULL);
    ftoa(oc->position.coord[2],temp);
    SetAttrs((Object *) MyApp->STR_OrthographicCameraPosZ, MUIA_String_Contents, (ULONG) temp, NULL);
    // oc->GetOrientation(x,y,z,a);
    ftoa(oc->orientation.coord[0],temp);
    SetAttrs((Object *) MyApp->STR_OrthographicCameraOY, MUIA_String_Contents, (ULONG) temp, NULL);
    ftoa(oc->orientation.coord[1],temp);
    SetAttrs((Object *) MyApp->STR_OrthographicCameraOY, MUIA_String_Contents, (ULONG) temp, NULL);
    ftoa(oc->orientation.coord[2],temp);
    SetAttrs((Object *) MyApp->STR_OrthographicCameraOZ, MUIA_String_Contents, (ULONG) temp, NULL);
    ftoa(oc->orientation.coord[3],temp);
    SetAttrs((Object *) MyApp->STR_OrthographicCameraOAngle, MUIA_String_Contents, (ULONG) temp, NULL);
    // x=oc->GetFocalDistance();
    ftoa(oc->focalDistance,temp);
    SetAttrs((Object *) MyApp->STR_OrthographicCameraFocal, MUIA_String_Contents, (ULONG) temp, NULL);
    // x=oc->GetHeight();
    ftoa(oc->height,temp);
    SetAttrs((Object *) MyApp->STR_OrthographicCameraHeight, MUIA_String_Contents, (ULONG) temp, NULL);
    sh.mode=USER;
}
void WIOrthographicCamera::ReadValues() {
    ULONG store;

    GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_DEFOrthographicCameraName, &store);
    oc->SetName((char *) store);
    GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_OrthographicCameraPosX, &store);
    oc->position.coord[0]=(double) atof((char *) store);
    GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_OrthographicCameraPosY, &store);
    oc->position.coord[1]=(double) atof((char *) store);
    GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_OrthographicCameraPosZ, &store);
    oc->position.coord[2]=(double) atof((char *) store);
    // oc->SetPosition(x,y,z);
    GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_OrthographicCameraOX, &store);
    oc->orientation.coord[0]=(double) atof((char *) store);
    GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_OrthographicCameraOY, &store);
    oc->orientation.coord[1]=(double) atof((char *) store);
    GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_OrthographicCameraOZ, &store);
    oc->orientation.coord[2]=(double) atof((char *) store);
    GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_OrthographicCameraOAngle, &store);
    oc->orientation.coord[3]=(double) atof((char *) store);
    // oc->SetOrientation(x,y,z,a);
    GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_OrthographicCameraFocal, &store);
    oc->focalDistance=(double) atof((char *) store);
    // oc->SetFocalDistance(a);
    GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_OrthographicCameraHeight, &store);
    oc->height=(double) atof((char *) store);
    // oc->SetHeight(a);
}
int WIOrthographicCamera::Ok() {
    return which;
}
void WIOrthographicCamera::SetDefault() {
    oc->SetDefault();
    Refresh();
}
void WIOrthographicCamera::Cancel() {
    oc->Copy(manip);
}
/*--------------------------
  WIPerspectiveCamera
---------------------------*/
WIPerspectiveCamera::WIPerspectiveCamera() {
    // MyApp=o;win=w;sh=s;
    manip=new PerspectiveCamera("MANIP");
}
WIPerspectiveCamera::~WIPerspectiveCamera() {
    delete manip;
}
void WIPerspectiveCamera::Set(VRMLNode *n, int w) {
    pc=(PerspectiveCamera *) n;which=w;
    manip->Copy(pc);
    Refresh();
    PopUp();
}
void WIPerspectiveCamera::Refresh() {
    char temp[15];
    double dega=(pc->orientation.coord[3]*180.0)/3.1415;
    sh.mode=SYSTEM;
    SetAttrs((Object *) MyApp->STR_DEFPerspectiveCameraName, MUIA_String_Contents, (ULONG) pc->GetName(),NULL);
    ftoa(pc->position.coord[0],temp);
    SetAttrs((Object *) MyApp->STR_PerspectiveCameraX, MUIA_String_Contents, (ULONG) temp, NULL);
    ftoa(pc->position.coord[1],temp);
    SetAttrs((Object *) MyApp->STR_PerspectiveCameraY, MUIA_String_Contents, (ULONG) temp, NULL);
    ftoa(pc->position.coord[2],temp);
    SetAttrs((Object *) MyApp->STR_PerspectiveCameraZ, MUIA_String_Contents, (ULONG) temp, NULL);
    ftoa(pc->orientation.coord[0],temp);
    SetAttrs((Object *) MyApp->STR_PerspectiveCameraOX, MUIA_String_Contents, (ULONG) temp, NULL);
    ftoa(pc->orientation.coord[1],temp);
    SetAttrs((Object *) MyApp->STR_PerspectiveCameraOY, MUIA_String_Contents, (ULONG) temp, NULL);
    ftoa(pc->orientation.coord[2],temp);
    SetAttrs((Object *) MyApp->STR_PerspectiveCameraOZ, MUIA_String_Contents, (ULONG) temp, NULL);
    ftoa(dega,temp);
    SetAttrs((Object *) MyApp->STR_PerspectiveCameraOAngle, MUIA_String_Contents, (ULONG) temp, NULL);
    ftoa(pc->focalDistance,temp);
    SetAttrs((Object *) MyApp->STR_PerspectiveCameraFocal, MUIA_String_Contents, (ULONG) temp, NULL);
    ftoa(pc->height*180.0/3.1415,temp);
    SetAttrs((Object *) MyApp->STR_PerspectiveCameraHeight, MUIA_String_Contents, (ULONG) temp, NULL);
    sh.mode=USER;
}
void WIPerspectiveCamera::ReadValues() {
    ULONG store;

    GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_DEFPerspectiveCameraName, &store);
    pc->SetName((char *) store);
    GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_PerspectiveCameraX, &store);
    pc->position.coord[0]=(double) atof((char *) store);
    GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_PerspectiveCameraY, &store);
    pc->position.coord[1]=(double) atof((char *) store);
    GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_PerspectiveCameraZ, &store);
    pc->position.coord[2]=(double) atof((char *) store);
    GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_PerspectiveCameraOX, &store);
    pc->orientation.coord[0]=(double) atof((char *) store);
    GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_PerspectiveCameraOY, &store);
    pc->orientation.coord[1]=(double) atof((char *) store);
    GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_PerspectiveCameraOZ, &store);
    pc->orientation.coord[2]=(double) atof((char *) store);
    GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_PerspectiveCameraOAngle, &store);
    pc->orientation.coord[3]=(double) atof((char *) store)*3.1415/180.0;
    GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_PerspectiveCameraFocal, &store);
    pc->focalDistance=(double) atof((char *) store);
    GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_PerspectiveCameraHeight, &store);
    pc->height=(double) atof((char *) store)*3.1415/180.0;
}
int WIPerspectiveCamera::Ok() {
    return which;
}
void WIPerspectiveCamera::SetDefault() {
    pc->SetDefault();
    Refresh();
}
void WIPerspectiveCamera::Cancel() {
    pc->Copy(manip);
}
/*--------------------------
  WIPointLight
---------------------------*/
WIPointLight::WIPointLight() {
    // MyApp=o;win=w;sh=sh;
    // manip=new PointLight("MANIP");
    manip=NULL;
}
WIPointLight::~WIPointLight() {
    // delete manip;
}
void WIPointLight::Set(VRMLNode *n, int w) {
    pl=(PointLight *) n;which=w;
    manip=(PointLight *) n->Clone();
    Refresh();
    // PopUp();
    SetAttrs((Object *) MyApp->WI_PointLight, MUIA_Window_Open, TRUE);
}
int WIPointLight::Ok() {
    delete manip;
    return which;
}
void WIPointLight::Cancel() {
    pl->Copy(manip);
    delete manip;
}
void WIPointLight::SetDefault() {
    pl->point.Set(0.0,0.0,1.0,1.0);
    pl->color.Set(1.0,1.0,1.0,1.0);
    pl->intensity=1.0;
    pl->on=1;
    Refresh();
}
void WIPointLight::Refresh() {
    char temp[25];

    sh.mode=SYSTEM;
    SetAttrs((Object *) MyApp->STR_DEFPointLightName, MUIA_String_Contents, (ULONG) pl->GetName());
    ftoa(pl->point.coord[0],temp);
    SetAttrs((Object *) MyApp->STR_PointLightX, MUIA_String_Contents, (ULONG) temp);
    ftoa(pl->point.coord[1],temp);
    SetAttrs((Object *) MyApp->STR_PointLightY, MUIA_String_Contents, (ULONG) temp);
    ftoa(pl->point.coord[2],temp);
    SetAttrs((Object *) MyApp->STR_PointLightZ, MUIA_String_Contents, (ULONG) temp);
    ftoa(pl->color.rgb[0],temp);
    SetAttrs((Object *) MyApp->STR_PointLightR, MUIA_String_Contents, (ULONG) temp);
    ftoa(pl->color.rgb[1],temp);
    SetAttrs((Object *) MyApp->STR_PointLightG, MUIA_String_Contents, (ULONG) temp);
    ftoa(pl->color.rgb[2],temp);
    SetAttrs((Object *) MyApp->STR_PointLightB, MUIA_String_Contents, (ULONG) temp);
    ftoa(pl->intensity,temp);
    SetAttrs((Object *) MyApp->STR_PointLightIntensity, MUIA_String_Contents, (ULONG) temp);
    SetAttrs((Object *) MyApp->CH_PointLightOn, MUIA_Selected, pl->on);
    sh.mode=USER;
}
void WIPointLight::ReadValues() {
    ULONG store;

    GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_DEFPointLightName, &store);
    pl->SetName((char *) store);
    GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_PointLightX, &store);
    pl->point.coord[0]=(double) atof((char *) store);
    GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_PointLightY, &store);
    pl->point.coord[1]=(double) atof((char *) store);
    GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_PointLightZ, &store);
    pl->point.coord[2]=(double) atof((char *) store);
    GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_PointLightR, &store);
    pl->color.rgb[0]=(double) atof((char *) store);
    GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_PointLightG, &store);
    pl->color.rgb[1]=(double) atof((char *) store);
    GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_PointLightB, &store);
    pl->color.rgb[2]=(double) atof((char *) store);
    GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_PointLightIntensity, &store);
    pl->intensity=(double) atof((char *) store);
    GetAttr(MUIA_Selected, (Object *) MyApp->CH_PointLightOn, &store);
    pl->on=(BOOL) store;
}
/*-----------------------------
  WIPointSet
------------------------------*/
WIPointSet::WIPointSet() {
    // MyApp=o;win=w;sh=s;
    // manip=new PointSet("MANIP");
    manip=NULL;
}
WIPointSet::~WIPointSet() {
    // delete manip;
}
void WIPointSet::Set(VRMLNode *n, int w) {
    ps=(PointSet *) n;which=w;
    manip=(PointSet *) ps->Clone();
    Refresh();
    SetAttrs((Object *) MyApp->WI_PointSet, MUIA_Window_Open, TRUE);
    // PopUp();
}
void WIPointSet::Refresh() {
    char temp[25];

    sh.mode=SYSTEM;
    SetAttrs((Object *) MyApp->STR_DEFPointSetName,MUIA_String_Contents, (ULONG) ps->GetName());
    itoa(ps->startIndex,temp);
    SetAttrs((Object *) MyApp->STR_PointSetStartIndex,MUIA_String_Contents,(ULONG) temp);
    itoa(ps->numPoints,temp);
    SetAttrs((Object *) MyApp->STR_PointSetNumPoints,MUIA_String_Contents,(ULONG) temp);
    sh.mode=USER;
}
void WIPointSet::ReadValues() {
    ULONG store;
    GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_DEFPointSetName, &store);
    ps->SetName((char *) store);
    GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_PointSetStartIndex, &store);
    ps->startIndex=atoi((char *) store);
    GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_PointSetNumPoints, &store);
    ps->numPoints=atoi((char *) store);
}
int WIPointSet::Ok() {
    delete manip;
    return which;
}
void WIPointSet::SetDefault() {
    ps->startIndex=0;
    ps->numPoints=-1;
    Refresh();
}
void WIPointSet::Cancel() {
    ps->Copy(manip);
    delete manip;
}
/*------------------------------------------------
  WIRotation
-------------------------------------------------*/
WIRotation::WIRotation() {
    // MyApp=o;win=w;sh=s;
    // manip=new Rotation("MANIP");
    manip=NULL;
}
WIRotation::~WIRotation() {
    // delete manip;
}
void WIRotation::Set(VRMLNode *n, int w) {
    r=(Rotation *) n;which=w;
    manip=(Rotation *) r->Clone();
    Refresh();
    // PopUp();
    SetAttrs((Object *) MyApp->WI_Rotation, MUIA_Window_Open, TRUE);
}
void WIRotation::Refresh() {
    char temp[25];
    double dega=(r->rotation.coord[3]*180.0)/3.1415;
    sh.mode=SYSTEM;
    SetAttrs((Object *) MyApp->STR_DEFRotationName,MUIA_String_Contents,(ULONG) r->GetName(),NULL);
    ftoa(r->rotation.coord[0],temp);
    SetAttrs((Object *) MyApp->STR_RotationX,MUIA_String_Contents,(ULONG) temp,NULL);
    ftoa(r->rotation.coord[1],temp);
    SetAttrs((Object *) MyApp->STR_RotationY,MUIA_String_Contents,(ULONG) temp,NULL);
    ftoa(r->rotation.coord[2],temp);
    SetAttrs((Object *) MyApp->STR_RotationZ,MUIA_String_Contents,(ULONG) temp,NULL);
    ftoa(dega,temp);
    SetAttrs((Object *) MyApp->STR_RotationA,MUIA_String_Contents,(ULONG) temp,NULL);
    sh.mode=USER;
}
void WIRotation::ReadValues() {
    float rx,ry,rz,ra;
    ULONG store;
    GetAttr(MUIA_String_Contents,(Object *) MyApp->STR_DEFRotationName, &store);
    r->SetName((char *) store);
    GetAttr(MUIA_String_Contents,(Object *) MyApp->STR_RotationX, &store);
    rx=(double) atof((char *) store);
    GetAttr(MUIA_String_Contents,(Object *) MyApp->STR_RotationY, &store);
    ry=(double) atof((char *) store);
    GetAttr(MUIA_String_Contents,(Object *) MyApp->STR_RotationZ, &store);
    rz=(double) atof((char *) store);
    GetAttr(MUIA_String_Contents,(Object *) MyApp->STR_RotationA, &store);
    ra=(double) atof((char *) store);
    ra=(ra*3.1415)/180.0;
    r->rotation.Set(rx,ry,rz,ra);
}
void WIRotation::SetDefault() {
    r->rotation.Set(0.0,0.0,1.0,0.0);
    Refresh();
}
int WIRotation::Ok() {
    delete manip;
    return which;
}
void WIRotation::Cancel() {
    r->Copy(manip);
    delete manip;
}
/*------------------------------------------------
  WIScale
-------------------------------------------------*/
WIScale::WIScale() {
    // MyApp=o;win=w;sh=s;
    // manip=new Scale("MANIP");
    manip=NULL;
}
WIScale::~WIScale() {
    // delete manip;
}
void WIScale::Set(VRMLNode *n, int w) {
    s=(Scale *) n;which=w;
    manip=(Scale *) s->Clone();
    Refresh();
    // PopUp();
    SetAttrs((Object *) MyApp->WI_Scale, MUIA_Window_Open, TRUE);
}
void WIScale::Refresh() {
    char temp[25];
    // puts("In Refresh");
    sh.mode=SYSTEM;
    SetAttrs((Object *) MyApp->STR_DEFScaleName,MUIA_String_Contents,(ULONG) s->GetName(),NULL);
    ftoa(s->scaleFactor.coord[0],temp);
    SetAttrs((Object *) MyApp->STR_ScaleX,MUIA_String_Contents,(ULONG) temp,NULL);
    ftoa(s->scaleFactor.coord[1],temp);
    SetAttrs((Object *) MyApp->STR_ScaleY,MUIA_String_Contents,(ULONG) temp,NULL);
    ftoa(s->scaleFactor.coord[2],temp);
    SetAttrs((Object *) MyApp->STR_ScaleZ,MUIA_String_Contents,(ULONG) temp,NULL);
    sh.mode=USER;
}
void WIScale::ReadValues() {
    float sx,sy,sz;
    ULONG store;

    // puts("In Scale.ReadValues");
    GetAttr(MUIA_String_Contents,(Object *) MyApp->STR_DEFScaleName, &store);
    s->SetName((char *) store);
    GetAttr(MUIA_String_Contents,(Object *) MyApp->STR_ScaleX, &store);
    sx=(double) atof((char *) store);
    GetAttr(MUIA_String_Contents,(Object *) MyApp->STR_ScaleY, &store);
    sy=(double) atof((char *) store);
    GetAttr(MUIA_String_Contents,(Object *) MyApp->STR_ScaleZ, &store);
    sz=(double) atof((char *) store);
    s->scaleFactor.Set(sx,sy,sz);
}
void WIScale::SetDefault() {
    s->scaleFactor.Set(1.0,1.0,1.0);
    Refresh();
}
int WIScale::Ok() {
    delete manip;
    return which;
}
void WIScale::Cancel() {
    s->Copy(manip);
    delete manip;
}
/*-----------------------------
  WISeparator
------------------------------*/
/*
WISeparator::WISeparator() {
    // MyApp=o;win=w;sh=s;
}
WISeparator::~WISeparator() {
}
void WISeparator::Set(VRMLNode *n, int w) {
    s=(Separator *) n;which=w;
    Refresh();
    PopUp();
    DisableMainWindow();
}
void WISeparator::Refresh() {
    char temp[25];
    // puts("In Refresh");
    sh.mode=SYSTEM;
    SetAttrs ((Object *) MyApp->STR_DEFSeparatorName, MUIA_String_Contents, s->GetName(),NULL);
    // puts("After DEF");
    itoa(s->Size(),temp);
    SetAttrs ((Object *) MyApp->TX_SeparatorNum, MUIA_Text_Contents,temp);
    // puts("After");
    SetAttrs ((Object *) MyApp->CY_SeparatorRenderCulling,MUIA_Cycle_Active,(LONG) s->renderCulling);
    sh.mode=USER;
}
void WISeparator::ReadValues() {
    ULONG store;
    GetAttr (MUIA_String_Contents, (Object *) MyApp->STR_DEFSeparatorName, &store);
    s->SetName((char *) store);
    GetAttr (MUIA_Cycle_Active, (Object *) MyApp->CY_SeparatorRenderCulling, &store);
    switch ((int) store) {
	case 0:s->renderCulling=AUTO;break;
	case 1:s->renderCulling=ON;break;
	case 2:s->renderCulling=OFF;break;
    };
}
int WISeparator::Ok() {
    // puts("In Separator OK");
    EnableMainWindow();
    return which;
}
*/
/*-------------------------------------------------------
  WIShapeHints
---------------------------------------------------------*/
WIShapeHints::WIShapeHints() {
    // MyApp=o;win=w;sh=s;
    // manip=new ShapeHints("MANIP");
    manip=NULL;
}
WIShapeHints::~WIShapeHints() {
    // delete manip;
}
void WIShapeHints::Set(VRMLNode *n, int w) {
    shi=(ShapeHints *) n;which=w;
    manip=(ShapeHints *) n->Clone();
    Refresh();
    SetAttrs((Object *) MyApp->WI_ShapeHints, MUIA_Window_Open, TRUE);
    // PopUp();
}
void WIShapeHints::Refresh() {
    char temp[25];
    sh.mode=SYSTEM;
    SetAttrs((Object *) MyApp->STR_DEFShapeHintsName, MUIA_String_Contents, (ULONG) shi->GetName());
    SetAttrs((Object *) MyApp->CY_ShapeHintsVertexOrdering, MUIA_Cycle_Active,(LONG) shi->vertexOrdering);
    SetAttrs((Object *) MyApp->CY_ShapeHintsShapeType, MUIA_Cycle_Active, (LONG) shi->shapeType);
    SetAttrs((Object *) MyApp->CY_ShapeHintsFaceType, MUIA_Cycle_Active, (LONG) shi->faceType);
    ftoa(shi->creaseAngle,temp);
    SetAttrs((Object *) MyApp->STR_ShapeHintsCreaseAngle, MUIA_String_Contents, (ULONG) temp);
    sh.mode=USER;
}
void WIShapeHints::ReadValues() {
    ULONG store;
    GetAttr(MUIA_String_Contents,MyApp->STR_DEFShapeHintsName, &store);
    shi->SetName((char *) store);
    GetAttr(MUIA_Cycle_Active,(Object *) MyApp->CY_ShapeHintsVertexOrdering, &store);
    switch ((int) store) {
	case 0:shi->vertexOrdering=UNKNOWN_ORDERING;break;
	case 1:shi->vertexOrdering=CLOCKWISE;break;
	case 2:shi->vertexOrdering=COUNTERCLOCKWISE;break;
    };
    GetAttr(MUIA_Cycle_Active,(Object *) MyApp->CY_ShapeHintsShapeType, &store);
    switch ((int) store) {
	case 0:shi->shapeType=UNKNOWN_SHAPE_TYPE;break;
	case 1:shi->shapeType=SOLID;break;
    };
    GetAttr(MUIA_Cycle_Active, (Object *) MyApp->CY_ShapeHintsFaceType, &store);
    switch ((int) store) {
	case 0:shi->faceType=CONVEX;break;
	case 1:shi->faceType=UNKNOWN_FACE_TYPE;break;
    };
    GetAttr(MUIA_String_Contents,(Object *) MyApp->STR_ShapeHintsCreaseAngle, &store);
    shi->creaseAngle=(float) atof((char *) store);
}
int WIShapeHints::Ok() {
    delete manip;
    return which;
}
void WIShapeHints::SetDefault() {
    shi->vertexOrdering=UNKNOWN_ORDERING;
    shi->shapeType=UNKNOWN_SHAPE_TYPE;
    shi->faceType=CONVEX;
    Refresh();
}
void WIShapeHints::Cancel() {
    shi->Copy(manip);
    delete manip;
}
/*--------------------------------------------
  WISphere
----------------------------------------------*/
WISphere::WISphere() {
    // MyApp=o;win=w;sh=s;
    manip=NULL;
}
WISphere::~WISphere() {
    // delete manip;
}
void WISphere::Set(VRMLNode *n, int w) {
    s=(Sphere *) n;which=w;
    manip=(Sphere *) n->Clone();
    Refresh();
    SetAttrs((Object *) MyApp->WI_Sphere, MUIA_Window_Open, TRUE);
    // PopUp();
}
void WISphere::Refresh() {
    char temp[25];
    sh.mode=SYSTEM;
    SetAttrs((Object *) MyApp->STR_DEFSphereName, MUIA_String_Contents, (ULONG) s->GetName());
    ftoa(s->radius,temp);
    SetAttrs((Object *) MyApp->STR_SphereRadius, MUIA_String_Contents, (ULONG) temp);
    sh.mode=USER;
}
void WISphere::ReadValues() {
    ULONG store;
    GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_DEFSphereName, &store);
    s->SetName((char *) store);
    GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_SphereRadius, &store);
    s->radius=(double) atof((char *) store);
}
void WISphere::SetDefault() {
    s->radius=1.0;
    Refresh();
}
int WISphere::Ok() {
    delete manip;
    return which;
}
void WISphere::Cancel() {
    s->Copy(manip);
    delete manip;
}
/*--------------------------------------------
  WISpotLight
----------------------------------------------*/
WISpotLight::WISpotLight() {
    // MyApp=o;win=w;sh=s;
    // manip=new SpotLight("MANIP");
    manip=NULL;
}
WISpotLight::~WISpotLight() {
    // delete manip;
}
void WISpotLight::Set(VRMLNode *n, int w) {
    sl=(SpotLight *) n;which=w;
    manip=(SpotLight *) n->Clone();
    Refresh();
    // PopUp();
    SetAttrs((Object *) MyApp->WI_SpotLight, MUIA_Window_Open, TRUE);
}
void WISpotLight::Refresh() {
    char temp[25];

    sh.mode=SYSTEM;
    SetAttrs((Object *) MyApp->STR_DEFSpotLightName, MUIA_String_Contents, (ULONG) sl->GetName());
    ftoa(sl->point.coord[0],temp);
    SetAttrs((Object *) MyApp->STR_SpotLightX, MUIA_String_Contents, (ULONG) temp);
    ftoa(sl->point.coord[1],temp);
    SetAttrs((Object *) MyApp->STR_SpotLightY, MUIA_String_Contents, (ULONG) temp);
    ftoa(sl->point.coord[2],temp);
    SetAttrs((Object *) MyApp->STR_SpotLightZ, MUIA_String_Contents, (ULONG) temp);
    ftoa(sl->color.rgb[0],temp);
    SetAttrs((Object *) MyApp->STR_SpotLightR, MUIA_String_Contents, (ULONG) temp);
    ftoa(sl->color.rgb[1],temp);
    SetAttrs((Object *) MyApp->STR_SpotLightG, MUIA_String_Contents, (ULONG) temp);
    ftoa(sl->color.rgb[2],temp);
    SetAttrs((Object *) MyApp->STR_SpotLightB, MUIA_String_Contents, (ULONG) temp);
    ftoa(sl->direction.coord[0],temp);
    SetAttrs((Object *) MyApp->STR_SpotLightDirX, MUIA_String_Contents, (ULONG) temp);
    ftoa(sl->direction.coord[1],temp);
    SetAttrs((Object *) MyApp->STR_SpotLightDirY, MUIA_String_Contents, (ULONG) temp);
    ftoa(sl->direction.coord[2],temp);
    SetAttrs((Object *) MyApp->STR_SpotLightDirZ, MUIA_String_Contents, (ULONG) temp);
    ftoa(sl->cutOffAngle,temp);
    SetAttrs((Object *) MyApp->STR_SpotLightCut, MUIA_String_Contents, (ULONG) temp);
    ftoa(sl->dropOffRate,temp);
    SetAttrs((Object *) MyApp->STR_SpotLightDrop, MUIA_String_Contents, (ULONG) temp);

    ftoa(sl->intensity,temp);
    SetAttrs((Object *) MyApp->STR_SpotLightIntensity, MUIA_String_Contents, (ULONG) temp);
    SetAttrs((Object *) MyApp->CH_SpotLightOn, MUIA_Selected, sl->on);
    sh.mode=USER;
}
void WISpotLight::ReadValues() {
    ULONG store;
    GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_DEFSpotLightName, &store);
    sl->SetName((char *) store);
    GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_SpotLightX, &store);
    sl->point.coord[0]=(double) atof((char *) store);
    GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_SpotLightY, &store);
    sl->point.coord[1]=(double) atof((char *) store);
    GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_SpotLightZ, &store);
    sl->point.coord[2]=(double) atof((char *) store);
    GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_SpotLightR, &store);
    sl->color.rgb[0]=(double) atof((char *) store);
    GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_SpotLightG, &store);
    sl->color.rgb[1]=(double) atof((char *) store);
    GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_SpotLightB, &store);
    sl->color.rgb[2]=(double) atof((char *) store);
    GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_SpotLightDirX, &store);
    sl->direction.coord[0]=(double) atof((char *) store);
    GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_SpotLightDirY, &store);
    sl->direction.coord[1]=(double) atof((char *) store);
    GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_SpotLightDirZ, &store);
    sl->direction.coord[2]=(double) atof((char *) store);
    GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_SpotLightCut, &store);
    sl->cutOffAngle=(float) atof((char *) store);
    GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_SpotLightDrop, &store);
    sl->dropOffRate=(float) atof((char *) store);
    GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_SpotLightIntensity, &store);
    sl->intensity=(float) atof((char *) store);
    GetAttr(MUIA_Selected, (Object *) MyApp->CH_SpotLightOn, &store);
    sl->on=(BOOL) store;
}
void WISpotLight::SetDefault() {
    sl->on=TRUE;
    sl->color.Set(1.0,1.0,1.0,1.0);
    sl->point.Set(0,0,1.0,1.0);
    sl->direction.Set(0,0,-1.0);
    sl->dropOffRate=0;
    sl->cutOffAngle=0.785398;
    Refresh();
}
int WISpotLight::Ok() {
    delete manip;
    return which;
}
void WISpotLight::Cancel() {
    sl->Copy(manip);
    delete manip;
}
/*--------------------------------------------
  WISwitch
----------------------------------------------*/
/*
WISwitch::WISwitch() {
    // MyApp=o;win=w;sh=s;
}
WISwitch::~WISwitch() {
}
void WISwitch::Set(VRMLNode *n, int w) {
    s=(Switch *) n;which=w;
    Refresh();
    DisableMainWindow();
    PopUp();
}
void WISwitch::Refresh() {
    char temp[25];
    // puts("In Refresh");
    sh.mode=SYSTEM;
    SetAttrs ((Object *) MyApp->STR_DEFSwitchName, MUIA_String_Contents, s->GetName(),NULL);
    // puts("After DEF");
    itoa(s->Size(),temp);
    SetAttrs ((Object *) MyApp->TX_SwitchNum, MUIA_Text_Contents,temp);
    // puts("After");
    itoa(s->whichChild,temp);
    SetAttrs ((Object *) MyApp->STR_SwitchWhich, MUIA_String_Contents, temp);
    sh.mode=USER;
}
void WISwitch::ReadValues() {
    ULONG store;
    GetAttr (MUIA_String_Contents, (Object *) MyApp->STR_DEFSwitchName, &store);
    s->SetName((char *) store);
    GetAttr (MUIA_String_Contents, (Object *) MyApp->STR_SwitchWhich, &store);
    s->whichChild=atoi((char *) store);
}
int WISwitch::Ok() {
    EnableMainWindow();
    return which;
}
*/
/*--------------------------------------------
  WITexture2
----------------------------------------------*/
WITexture2::WITexture2() {
    // MyApp=o;win=w;sh=s;
    // manip=new Texture2("MANIP");
    manip=NULL;
}
WITexture2::~WITexture2() {
    // delete manip;
}
void WITexture2::Set(VRMLNode *n, int w) {
    t=(Texture2 *) n;which=w;
    manip=(Texture2 *) t->Clone();
    Refresh();
    // LoadImage();
    puts("in set");
    SetAttrs((Object *) MyApp->WI_Texture2, MUIA_Window_Open, TRUE);
    if (t->image) {
	struct GLImage glimage={t->width,t->height,t->component,t->image},*preview=NULL;

	preview= (struct GLImage *) DoMethod((Object *) MyApp->GLAR_Texture2Preview, MUIM_GLArea_InitImage, "Preview", &glimage, MUIV_GLArea_InitImage_Copy);
	preview= (struct GLImage *) DoMethod((Object *) MyApp->GLAR_Texture2Preview, MUIM_GLArea_ScaleImage, "Preview", preview, 120,80);
	DoMethod((Object *) MyApp->GLAR_Texture2Preview, MUIM_GLArea_Redraw);
	DoMethod((Object *) MyApp->GLAR_Texture2Anim, MUIM_GLArea_InitTexture, "Sample", preview, MUIV_GLArea_EntryType_Image);
	DoMethod((Object *) MyApp->GLAR_Texture2Anim, MUIM_GLArea_Redraw);
    };
    // PopUp();
}
void WITexture2::Refresh() {
    char temp[255];
    int w;

    sh.mode=SYSTEM;
    SetAttrs((Object *) MyApp->STR_DEFTexture2Name, MUIA_String_Contents, (ULONG) t->GetName());
    SetAttrs((Object *) MyApp->STR_PA_Texture2, MUIA_String_Contents, (ULONG) t->GetFileName());
    itoa(t->width,temp);
    printf("t->width:%d %s\n",t->width,temp);
    SetAttrs((Object *) MyApp->TX_Texture2Width, MUIA_Text_Contents, (ULONG) temp);
    itoa(t->height,temp);
    SetAttrs((Object *) MyApp->TX_Texture2Height, MUIA_Text_Contents, (ULONG) temp);
    itoa(t->component, temp);
    SetAttrs((Object *) MyApp->TX_Texture2Component, MUIA_Text_Contents, (ULONG) temp);
    switch (t->wrapS) {
	case TEXTURE2_WRAP_REPEAT:w=0;break;
	case TEXTURE2_WRAP_CLAMP:w=1;break;
    };
    SetAttrs((Object *) MyApp->CY_Texture2WrapS, MUIA_Cycle_Active, (LONG) w);
    switch (t->wrapT) {
	case TEXTURE2_WRAP_REPEAT:w=0;break;
	case TEXTURE2_WRAP_CLAMP:w=1;break;
    };
    SetAttrs((Object *) MyApp->CY_Texture2WrapT, MUIA_Cycle_Active, (LONG) w);
    sh.mode=USER;
}
void WITexture2::ReadValues() {
    ULONG store;

    GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_DEFTexture2Name, &store);
    t->SetName((char *) store);
    GetAttr(MUIA_Cycle_Active, (Object *) MyApp->CY_Texture2WrapS, &store);
    switch ((int) store) {
	case TEXTURE2_WRAP_REPEAT:t->wrapS=TEXTURE2_WRAP_REPEAT;break;
	case TEXTURE2_WRAP_CLAMP:t->wrapS=TEXTURE2_WRAP_CLAMP;break;
    };
    GetAttr(MUIA_Cycle_Active, (Object *) MyApp->CY_Texture2WrapT, &store);
    switch ((int) store) {
	case TEXTURE2_WRAP_REPEAT:t->wrapT=TEXTURE2_WRAP_REPEAT;break;
	case TEXTURE2_WRAP_CLAMP:t->wrapT=TEXTURE2_WRAP_CLAMP;break;
    };
}

void WITexture2::LoadImage() {
    ULONG store=0;
    char temp[255];
    int rep=0;

    puts("loadImage");
    // SetAttrs((Object *) MyApp->WI_Texture2Display, MUIA_Window_Open, FALSE);
    GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_PA_Texture2, &store);
    t->SetFileName((char *) store);
    if (strcmp(t->GetFileName(),"")) {
	rep=t->LoadImage();
	if (rep==0) {
	    MUI_Request (MyApp->App,MyApp->WI_Texture2,0,"Error","Ok",
			     "No filename specifed");
	}
	else if (rep==-1) {
	    MUI_Request (MyApp->App,MyApp->WI_Texture2,0,"Error","Ok",
			 "Not a picture file");
	}
	else {
	    struct GLImage glimage={t->width,t->height,t->component,t->image},*preview=NULL;

	    puts("image loaded succesfully...");
	    Refresh();
	    preview= (struct GLImage *) DoMethod((Object *) MyApp->GLAR_Texture2Preview, MUIM_GLArea_InitImage, "Preview",&glimage, MUIV_GLArea_InitImage_Copy);
	    preview= (struct GLImage *) DoMethod((Object *) MyApp->GLAR_Texture2Preview, MUIM_GLArea_ScaleImage, "Preview", preview, 120,80);
	    DoMethod((Object *) MyApp->GLAR_Texture2Preview, MUIM_GLArea_Redraw);
	    DoMethod((Object *) MyApp->GLAR_Texture2Anim, MUIM_GLArea_InitTexture, "Sample", preview, MUIV_GLArea_EntryType_Image);
	    DoMethod((Object *) MyApp->GLAR_Texture2Anim, MUIM_GLArea_Redraw);
	    // SetAttrs((Object *) MyApp->BT_Texture2Show, MUIA_Disabled, FALSE);
	};
    }
    else {
	/*
	if (t->image) free(t->image);
	t->image=NULL;
	t->width=0;
	t->height=0;
	t->component=0;
	sh.mode=SYSTEM;
	SetAttrs((Object *) MyApp->TX_Texture2Width, MUIA_Text_Contents,(ULONG) "0");
	SetAttrs((Object *) MyApp->TX_Texture2Height, MUIA_Text_Contents, (ULONG) "0");
	SetAttrs((Object *) MyApp->TX_Texture2Component, MUIA_Text_Contents, (ULONG) "0");
	// SetAttrs((Object *) MyApp->BT_Texture2Show, MUIA_Disabled, TRUE);
	sh.mode=USER;
	*/
    };
}

void WITexture2::ShowImage() {
    sh.mode=SYSTEM;
    /*
    SetAttrs((Object *) MyApp->GLAR_Texture2, MUIA_FixWidth, t->width);
    SetAttrs((Object *) MyApp->GLAR_Texture2, MUIA_FixHeight, t->height);
    // DoMethod((Object *) MyApp->App,OM_ADDMEMBER,WI_Texture2Display);
    SetAttrs((Object *) MyApp->WI_Texture2Display, MUIA_Window_Open, TRUE);
    */
    sh.mode=USER;
}

/*
void WITexture2::CloseImage() {
    DoMethod((Object *) MyApp->App,OM_REMMEMBER,WI_Texture2Display);
    MUI_DisposeObject((Object *) WI_Texture2Display);
}
*/
void WITexture2::SetDefault() {
    if (t->image) free(t->image);
    t->image=NULL;
    t->SetFileName("");
    t->wrapS=TEXTURE2_WRAP_REPEAT;
    t->wrapT=TEXTURE2_WRAP_REPEAT;
    t->width=0;
    t->height=0;
    t->component=0;
    Refresh();
}
int WITexture2::Ok() {
    delete (manip);
    DoMethod((Object *) MyApp->GLAR_Texture2Preview, MUIM_GLArea_DeleteImage, "Preview");
    return which;
}
void WITexture2::Cancel() {
    t->Copy(manip);
    DoMethod((Object *) MyApp->GLAR_Texture2Preview, MUIM_GLArea_DeleteImage, "Preview");
    delete manip;
}
/*--------------------------------------------
  WITexture2Transform
----------------------------------------------*/
WITexture2Transform::WITexture2Transform() {
    // MyApp=o;win=w;sh=s;
    // manip=new Texture2Transform("MANIP");
    manip=NULL;
}
WITexture2Transform::~WITexture2Transform() {
    // delete manip;
}
void WITexture2Transform::Set(VRMLNode *n, int w) {
    t=(Texture2Transform *) n;which=w;
    manip=(Texture2Transform *) n->Clone();
    Refresh();
    SetAttrs((Object *) MyApp->WI_Texture2Transform, MUIA_Window_Open, TRUE);
    // PopUp();
}
void WITexture2Transform::Refresh() {
    char temp[25];
    sh.mode=SYSTEM;
    SetAttrs((Object *) MyApp->STR_DEFTexture2TransformName, MUIA_String_Contents, (ULONG) t->GetName());
    ftoa(t->translation.coord[0],temp);
    SetAttrs((Object *) MyApp->STR_Texture2TransformTX,MUIA_String_Contents, (ULONG) temp);
    ftoa(t->translation.coord[1],temp);
    SetAttrs((Object *) MyApp->STR_Texture2TransformTY,MUIA_String_Contents, (ULONG) temp);
    ftoa(t->rotation,temp);
    SetAttrs((Object *) MyApp->STR_Texture2TransformRot,MUIA_String_Contents, (ULONG) temp);
    ftoa(t->scaleFactor.coord[0],temp);
    SetAttrs((Object *) MyApp->STR_Texture2TransformSX,MUIA_String_Contents, (ULONG) temp);
    ftoa(t->scaleFactor.coord[1],temp);
    SetAttrs((Object *) MyApp->STR_Texture2TransformSY,MUIA_String_Contents, (ULONG) temp);
    ftoa(t->center.coord[0],temp);
    SetAttrs((Object *) MyApp->STR_Texture2TransformCenterX,MUIA_String_Contents, (ULONG) temp);
    ftoa(t->center.coord[1],temp);
    SetAttrs((Object *) MyApp->STR_Texture2TransformCenterY,MUIA_String_Contents, (ULONG) temp);
    sh.mode=USER;
}
void WITexture2Transform::ReadValues() {
    ULONG store;
    GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_DEFTexture2TransformName, &store);
    t->SetName((char *) store);
    GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_Texture2TransformTX, &store);
    t->translation.coord[0]=(double) atof((char *) store);
    GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_Texture2TransformTY, &store);
    t->translation.coord[1]=(double) atof((char *) store);
    GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_Texture2TransformRot, &store);
    t->rotation=(double) atof((char *) store);
    GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_Texture2TransformSX, &store);
    t->scaleFactor.coord[0]=(double) atof((char *) store);
    GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_Texture2TransformSY, &store);
    t->scaleFactor.coord[1]=(double) atof((char *) store);
    GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_Texture2TransformCenterX, &store);
    t->center.coord[0]=(double) atof((char *) store);
     GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_Texture2TransformCenterY, &store);
    t->center.coord[1]=(double) atof((char *) store);
}
void WITexture2Transform::SetDefault() {
    t->translation.Set(0,0);
    t->rotation=0;
    t->scaleFactor.Set(1,1);
    t->center.Set(0,0);
    Refresh();
}
int WITexture2Transform::Ok() {
    delete manip;
    return which;
}
void WITexture2Transform::Cancel() {
    t->Copy(manip);
    delete manip;
}
/*--------------------------------------------
  WITextureCoordinate2
----------------------------------------------*/
WITextureCoordinate2::WITextureCoordinate2() {
    // MyApp=o;win=w;sh=s;
    // manip=new TextureCoordinate2("MANIP");
    manip=NULL;
}
WITextureCoordinate2::~WITextureCoordinate2() {
    // delete manip;
}
int  WITextureCoordinate2::Selected() {
    ULONG store;
    GetAttr(MUIA_Prop_First,MyApp->PR_TextureCoordinate2Index, &store);
    return (int) store;
}
void WITextureCoordinate2::Set(VRMLNode *n, int w) {
    char temp[25];
    tc=(TextureCoordinate2 *) n;which=w;
    manip=(TextureCoordinate2 *) n->Clone();
    sh.mode=SYSTEM;
    SetAttrs((Object *) MyApp->STR_DEFTextureCoordinate2Name,MUIA_String_Contents,(ULONG) tc->GetName(),NULL);
    SetAttrs((Object *) MyApp->PR_TextureCoordinate2Index,MUIA_Prop_Entries,(LONG) tc->Size());
    SetAttrs((Object *) MyApp->PR_TextureCoordinate2Index,MUIA_Prop_Visible,1,NULL);
    SetAttrs((Object *) MyApp->PR_TextureCoordinate2Index,MUIA_Prop_First,0,NULL);
    itoa(tc->Size(),temp);
    SetAttrs((Object *) MyApp->TX_TextureCoordinate2Num,MUIA_Text_Contents,(ULONG) temp);
    sh.mode=USER;
    Refresh();
    SetAttrs((Object *) MyApp->WI_TextureCoordinate2, MUIA_Window_Open, TRUE);
    // PopUp();
}
void WITextureCoordinate2::Refresh() {
    Vertex2d *cv=NULL;
    char temp[25];

    sh.mode=SYSTEM;
    itoa(Selected(),temp);
    SetAttrs((Object *) MyApp->TX_TextureCoordinate2Index, MUIA_Text_Contents, (ULONG) temp, NULL);
    cv=tc->GetPoint(Selected());
    ftoa(cv->coord[0],temp);
    SetAttrs((Object *) MyApp->STR_TextureCoordinate2X,MUIA_String_Contents,(ULONG) temp,NULL);
    ftoa(cv->coord[1],temp);
    SetAttrs((Object *) MyApp->STR_TextureCoordinate2Y,MUIA_String_Contents,(ULONG) temp,NULL);
    sh.mode=USER;
}
void WITextureCoordinate2::ReadValues() {
    ULONG store;
    char temp[25];
    Vertex2d *cv=NULL;

    GetAttr (MUIA_String_Contents,(Object *) MyApp->STR_DEFTextureCoordinate2Name, &store);
    tc->SetName((char *) store);
    cv=tc->GetPoint(Selected());
    GetAttr (MUIA_String_Contents,(Object *) MyApp->STR_TextureCoordinate2X,&store);
    cv->coord[0]=(double) atof((char *) store);
    GetAttr (MUIA_String_Contents,(Object *) MyApp->STR_TextureCoordinate2Y,&store);
    cv->coord[1]=(double) atof((char *) store);
}
void WITextureCoordinate2::Add() {
    char temp[25];
    sh.mode=SYSTEM;
    tc->InsertPoint(Selected(),new Vertex2d(0.0,0.0));
    SetAttrs((Object *) MyApp->PR_TextureCoordinate2Index,MUIA_Prop_Entries,(LONG) tc->Size());
    itoa(tc->Size(),temp);                                      
    SetAttrs((Object *) MyApp->TX_TextureCoordinate2Num,MUIA_Text_Contents,(ULONG) temp);
    sh.mode=USER;
    Refresh();
}
void WITextureCoordinate2::Delete() {
    char temp[25];
    if (tc->Size()<=1) {
	MUI_Request (MyApp->App,MyApp->WI_TextureCoordinate2,0,"Error","Ok",
		     "You can't delete the first point !");
    }
    else {
	sh.mode=SYSTEM;
	delete tc->RemovePoint(Selected());
	SetAttrs((Object *) MyApp->PR_TextureCoordinate2Index,MUIA_Prop_Entries,(LONG) tc->Size());
	itoa(tc->Size(),temp);
	SetAttrs((Object *) MyApp->TX_TextureCoordinate2Num,MUIA_Text_Contents,(ULONG) temp);
	sh.mode=USER;
	Refresh();
    };
}
int WITextureCoordinate2::Ok() {
    delete manip;
    return which;
}
void WITextureCoordinate2::Cancel() {
    tc->Copy(manip);
    delete manip;
}
/*------------------------------------------------------------------
  WITransform
-------------------------------------------------------------------*/
WITransform::WITransform() {
    // MyApp=o;win=w;sh=s;
    // manip=new Transform("MANIP");
    manip=NULL;
}
WITransform::~WITransform() {
    delete manip;
}
void WITransform::Set(VRMLNode *n, int w) {
    t=(Transform *) n;which=w;
    // manip->Copy(t);
    manip=(Transform *) n->Clone();
    Refresh();
    // PopUp();
    SetAttrs((Object *) MyApp->WI_Transform, MUIA_Window_Open, TRUE);
}
void WITransform::Refresh() {
    char temp[25];
    double dega=(t->rotation.coord[3]*180.0)/3.1415;
    sh.mode=SYSTEM;
    SetAttrs((Object *) MyApp->STR_DEFTransformName,MUIA_String_Contents,(ULONG) t->GetName(),NULL);
    ftoa(t->translation.coord[0],temp);
    SetAttrs((Object *) MyApp->STR_TTranslationX,MUIA_String_Contents,(ULONG) temp,NULL);
    ftoa(t->translation.coord[1],temp);
    SetAttrs((Object *) MyApp->STR_TTranslationY,MUIA_String_Contents,(ULONG) temp,NULL);
    ftoa(t->translation.coord[2],temp);
    SetAttrs((Object *) MyApp->STR_TTranslationZ,MUIA_String_Contents,(ULONG) temp,NULL);

    ftoa(t->rotation.coord[0],temp);
    SetAttrs((Object *) MyApp->STR_TRotationX,MUIA_String_Contents,(ULONG) temp,NULL);
    ftoa(t->rotation.coord[1],temp);
    SetAttrs((Object *) MyApp->STR_TRotationY,MUIA_String_Contents,(ULONG) temp,NULL);
    ftoa(t->rotation.coord[2],temp);
    SetAttrs((Object *) MyApp->STR_TRotationZ,MUIA_String_Contents,(ULONG) temp,NULL);
    ftoa(dega,temp);
    SetAttrs((Object *) MyApp->STR_TRotationA,MUIA_String_Contents,(ULONG) temp,NULL);

    ftoa(t->scaleFactor.coord[0],temp);
    SetAttrs((Object *) MyApp->STR_TScaleFX,MUIA_String_Contents,(ULONG) temp,NULL);
    ftoa(t->scaleFactor.coord[1],temp);
    SetAttrs((Object *) MyApp->STR_TScaleFY,MUIA_String_Contents,(ULONG) temp,NULL);
    ftoa(t->scaleFactor.coord[2],temp);
    SetAttrs((Object *) MyApp->STR_TScaleFZ,MUIA_String_Contents,(ULONG) temp,NULL);

    ftoa(t->scaleOrientation.coord[0],temp);
    SetAttrs((Object *) MyApp->STR_TScaleOX,MUIA_String_Contents,(ULONG) temp,NULL);
    ftoa(t->scaleOrientation.coord[1],temp);
    SetAttrs((Object *) MyApp->STR_TScaleOY,MUIA_String_Contents,(ULONG) temp,NULL);
    ftoa(t->scaleOrientation.coord[2],temp);
    SetAttrs((Object *) MyApp->STR_TScaleOZ,MUIA_String_Contents,(ULONG) temp,NULL);
    ftoa(t->scaleOrientation.coord[3],temp);
    SetAttrs((Object *) MyApp->STR_TScaleOA,MUIA_String_Contents,(ULONG) temp,NULL);

    ftoa(t->center.coord[0],temp);
    SetAttrs((Object *) MyApp->STR_TCenterX,MUIA_String_Contents,(ULONG) temp,NULL);
    ftoa(t->center.coord[1],temp);
    SetAttrs((Object *) MyApp->STR_TCenterY,MUIA_String_Contents,(ULONG) temp,NULL);
    ftoa(t->center.coord[2],temp);
    SetAttrs((Object *) MyApp->STR_TCenterZ,MUIA_String_Contents,(ULONG) temp,NULL);
    sh.mode=USER;
}
void WITransform::ReadValues() {
    double tx,ty,tz,rx,ry,rz,ra,sx,sy,sz,sox,soy,soz,soa,cx,cy,cz;
    ULONG store;

    GetAttr(MUIA_String_Contents,(Object *) MyApp->STR_DEFTransformName, &store);
    t->SetName((char *) store);
    GetAttr(MUIA_String_Contents,(Object *) MyApp->STR_TTranslationX, &store);
    tx=(double) atof((char *) store);
    GetAttr(MUIA_String_Contents,(Object *) MyApp->STR_TTranslationY, &store);
    ty=(double) atof((char *) store);
    GetAttr(MUIA_String_Contents,(Object *) MyApp->STR_TTranslationZ, &store);
    tz=(double) atof((char *) store);
    t->translation.Set(tx,ty,tz);

    GetAttr (MUIA_String_Contents,(Object *) MyApp->STR_TRotationX, &store);
    rx=(double) atof((char *) store);
    GetAttr (MUIA_String_Contents,(Object *) MyApp->STR_TRotationY ,&store);
    ry=(double) atof((char *) store);
    GetAttr (MUIA_String_Contents,(Object *) MyApp->STR_TRotationZ ,&store);
    rz=(double) atof((char *) store);
    GetAttr (MUIA_String_Contents,(Object *) MyApp->STR_TRotationA, &store);
    ra=(double) atof((char *) store);
    ra=(ra*3.1415)/180.0;
    t->rotation.Set(rx,ry,rz,ra);

    GetAttr(MUIA_String_Contents,(Object *) MyApp->STR_TScaleFX, &store);
    sx=(double) atof((char *) store);
    GetAttr(MUIA_String_Contents,(Object *) MyApp->STR_TScaleFY, &store);
    sy=(double) atof((char *) store);
    GetAttr(MUIA_String_Contents,(Object *) MyApp->STR_TScaleFZ, &store);
    sz=(double) atof((char *) store);
    t->scaleFactor.Set(sx,sy,sz);

    GetAttr (MUIA_String_Contents,(Object *) MyApp->STR_TScaleOX, &store);
    sox=(double) atof((char *) store);
    GetAttr (MUIA_String_Contents,(Object *) MyApp->STR_TScaleOY ,&store);
    soy=(double) atof((char *) store);
    GetAttr (MUIA_String_Contents,(Object *) MyApp->STR_TScaleOZ ,&store);
    soz=(double) atof((char *) store);
    GetAttr (MUIA_String_Contents,(Object *) MyApp->STR_TScaleOA, &store);
    soa=(double) atof((char *) store);
    t->scaleOrientation.Set(sox,soy,soz,soa);

    GetAttr (MUIA_String_Contents,(Object *) MyApp->STR_TCenterX, &store);
    cx=(double) atof((char *) store);
    GetAttr (MUIA_String_Contents,(Object *) MyApp->STR_TCenterY ,&store);
    cy=(double) atof((char *) store);
    GetAttr (MUIA_String_Contents,(Object *) MyApp->STR_TCenterZ ,&store);
    cz=(double) atof((char *) store);
    t->center.Set(cx,cy,cz);
}
void WITransform::SetDefault() {
    t->translation.Set(0,0,0);
    t->rotation.Set(0,0,1,0);
    t->scaleFactor.Set(1,1,1);
    t->scaleOrientation.Set(0,0,1,0);
    t->center.Set(0,0,0);
    Refresh();
}
int WITransform::Ok() {
    delete manip;
    return which;
}
void WITransform::Cancel() {
    t->Copy(manip);
    delete manip;
}
/*--------------------------------------------
  WITransformSeparator
----------------------------------------------*/
/*
WITransformSeparator::WITransformSeparator() {
    // MyApp=o;win=w;sh=s;
}
WITransformSeparator::~WITransformSeparator() {
}
void WITransformSeparator::Set(VRMLNode *n, int w) {
    t=(TransformSeparator *) n;which=w;
    Refresh();
    DisableMainWindow();
    PopUp();
}
void WITransformSeparator::Refresh() {
    char temp[25];
    sh.mode=SYSTEM;
    SetAttrs((Object *) MyApp->STR_DEFTransformSeparatorName,MUIA_String_Contents, t->GetName());
    ftoa(t->Size(),temp);
    SetAttrs((Object *) MyApp->TX_TransformSeparatorNum, MUIA_Text_Contents, temp);
    sh.mode=USER;
}
void WITransformSeparator::ReadValues() {
    ULONG store;
    GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_DEFTransformSeparatorName, &store);
    t->SetName((char *) store);
}
int WITransformSeparator::Ok() {
    EnableMainWindow();
    return which;
}
*/
/*------------------------------------------------
  WITranslation
-------------------------------------------------*/
WITranslation::WITranslation() {
    // MyApp=o;win=w;sh=s;
    // manip=new Translation("MANIP");
    manip=NULL;
}
WITranslation::~WITranslation() {
    // delete manip;
}
void WITranslation::Set(VRMLNode *n, int w) {
    t=(Translation *) n;which=w;
    manip=(Translation *) t->Clone();
    Refresh();
    SetAttrs((Object *) MyApp->WI_Translation, MUIA_Window_Open, TRUE);
}
void WITranslation::Refresh() {
    char temp[255];
    sh.mode=SYSTEM;
    SetAttrs((Object *) MyApp->STR_DEFTranslationName,MUIA_String_Contents,(ULONG) t->GetName(),NULL);
    ftoa(t->translation.coord[0],temp);
    SetAttrs((Object *) MyApp->STR_TranslationX,MUIA_String_Contents,(ULONG) temp,NULL);
    ftoa(t->translation.coord[1],temp);
    SetAttrs((Object *) MyApp->STR_TranslationY,MUIA_String_Contents,(ULONG) temp,NULL);
    ftoa(t->translation.coord[2],temp);
    SetAttrs((Object *) MyApp->STR_TranslationZ,MUIA_String_Contents,(ULONG) temp,NULL);
    sh.mode=USER;
}
void WITranslation::ReadValues() {
    double tx,ty,tz;
    ULONG store;
    GetAttr(MUIA_String_Contents,(Object *) MyApp->STR_DEFTranslationName, &store);
    t->SetName((char *) store);
    GetAttr(MUIA_String_Contents,(Object *) MyApp->STR_TranslationX, &store);
    tx=(double) atof((char *) store);
    GetAttr(MUIA_String_Contents,(Object *) MyApp->STR_TranslationY, &store);
    ty=(double) atof((char *) store);
    GetAttr(MUIA_String_Contents,(Object *) MyApp->STR_TranslationZ, &store);
    tz=(double) atof((char *) store);
    t->translation.Set(tx,ty,tz);
}
void WITranslation::SetDefault() {
    t->translation.Set(0,0,0);
    Refresh();
}
int WITranslation::Ok() {
    delete manip;
    return which;
}
void WITranslation::Cancel() {
    t->Copy(manip);
    delete manip;
}
/*--------------------------------------------
  WIWWWAnchor
----------------------------------------------*/
/*
WIWWWAnchor::WIWWWAnchor() {
    // MyApp=o;win=w;sh=s;
}
WIWWWAnchor::~WIWWWAnchor() {
}
void WIWWWAnchor::Set(VRMLNode *n, int w) {
    www=(WWWAnchor *) n;which=w;
    Refresh();
    DisableMainWindow();
    PopUp();
}
void WIWWWAnchor::Refresh() {
    sh.mode=SYSTEM;
    SetAttrs((Object *) MyApp->STR_DEFWWWAnchorName, MUIA_String_Contents, www->GetName());
    SetAttrs((Object *) MyApp->STR_WWWAnchorName, MUIA_String_Contents, www->GetURL());
    SetAttrs((Object *) MyApp->STR_WWWAnchorDescription, MUIA_String_Contents, www->GetDescription());
    SetAttrs((Object *) MyApp->CY_WWWAnchorMap, MUIA_Cycle_Active, (LONG)  www->map);
    sh.mode=USER;
}
void WIWWWAnchor::ReadValues() {
    ULONG store;
    GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_DEFWWWAnchorName, &store);
    www->SetName((char *) store);
    GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_WWWAnchorName, &store);
    www->SetURL((char *) store);
    GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_WWWAnchorDescription, &store);
    www->SetDescription((char *) store);
    GetAttr(MUIA_Cycle_Active, (Object *) MyApp->CY_WWWAnchorMap, &store);
    switch ((int) store) {
	case 0:www->map=NONE_MAPTYPE;break;
	case 1:www->map=POINT;break;
    };
}
int WIWWWAnchor::Ok() {
    EnableMainWindow();
    return which;
}
*/
/*--------------------------------------------
  WIWWWInline
----------------------------------------------*/
WIWWWInline::WIWWWInline() {
    // MyApp=o;win=w;sh=s;
    // manip=new WWWInline("MANIP");
    manip=NULL;
}
WIWWWInline::~WIWWWInline() {
    // delete manip;
    if (www) delete www;
}
void WIWWWInline::Set(VRMLNode *n, int w) {
    www=(WWWInline *) n;which=w;
    manip=(WWWInline *) n->Clone();
    Refresh();
    SetAttrs((Object *) MyApp->WI_WWWInline, MUIA_Window_Open, TRUE);
}
void WIWWWInline::Refresh() {
    char temp[255];
    sh.mode=SYSTEM;
    // printf("Name:%s\n",www->GetURL());
    SetAttrs((Object *) MyApp->STR_DEFWWWInlineName,MUIA_String_Contents, (ULONG) www->GetName());
    SetAttrs((Object *) MyApp->STR_WWWInlineName,MUIA_String_Contents, (ULONG) www->GetURL());
    ftoa(www->bboxSize.coord[0],temp);
    SetAttrs((Object *) MyApp->STR_WWWInlineBoxSizeX,MUIA_String_Contents, (ULONG) temp);
    ftoa(www->bboxSize.coord[1],temp);
    SetAttrs((Object *) MyApp->STR_WWWInlineBoxSizeY,MUIA_String_Contents, (ULONG) temp);
    ftoa(www->bboxSize.coord[2],temp);
    SetAttrs((Object *) MyApp->STR_WWWInlineBoxSizeZ,MUIA_String_Contents, (ULONG) temp);
    ftoa(www->bboxCenter.coord[0],temp);
    SetAttrs((Object *) MyApp->STR_WWWInlineBoxCenterX,MUIA_String_Contents, (ULONG) temp);
    ftoa(www->bboxCenter.coord[1],temp);
    SetAttrs((Object *) MyApp->STR_WWWInlineBoxCenterY,MUIA_String_Contents, (ULONG) temp);
    ftoa(www->bboxCenter.coord[2],temp);
    SetAttrs((Object *) MyApp->STR_WWWInlineBoxCenterZ,MUIA_String_Contents, (ULONG) temp);
    sh.mode=USER;
}
void WIWWWInline::ReadValues() {
    ULONG store;
    // puts("WWWInline::ReadValues");
    GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_DEFWWWInlineName, &store);
    www->SetName((char *) store);
    GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_WWWInlineName, &store);
    www->SetURL((char *) store);
    GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_WWWInlineBoxSizeX, &store);
    www->bboxSize.coord[0]=(double) atof((char *) store);
    GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_WWWInlineBoxSizeY, &store);
    www->bboxSize.coord[1]=(double) atof((char *) store);
    GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_WWWInlineBoxSizeZ, &store);
    www->bboxSize.coord[2]=(double) atof((char *) store);
    GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_WWWInlineBoxCenterX, &store);
    www->bboxCenter.coord[0]=(double) atof((char *) store);
    GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_WWWInlineBoxCenterY, &store);
    www->bboxCenter.coord[1]=(double) atof((char *) store);
    GetAttr(MUIA_String_Contents, (Object *) MyApp->STR_WWWInlineBoxCenterZ, &store);
    www->bboxCenter.coord[2]=(double) atof((char *) store);
    // printf("Read:%s\n",www->GetURL());
}
void WIWWWInline::SetDefault() {
    puts("WWWInline::SetDefault");
}
int WIWWWInline::Ok() {
    delete manip;
    return which;
}
void WIWWWInline::Cancel() {
    www->Copy(manip);
    delete manip;
}
WWWInline *WIWWWInline::GetInline() {
    return www;
}
/*
void GLContext::Advance() {
    double dx=cos(heading);
    double dz=sin(heading);
    // vpx+=dx*10;tpx=vpx+dx*10;
    // vpz-=dz*10;tpz=vpz-dz*10;
    DrawScene();
}
void GLContext::Backward() {
    double dx=cos(heading);
    double dz=sin(heading);
    // vpx-=dx*10;tpx=vpx+dx*10;
    // vpz+=dz*10;tpz=tpz-dz*10;
    DrawScene();
}
void GLContext::TurnRight() {
    heading-=0.17444;
    double dx=cos(heading);
    double dz=sin(heading);
    // tpx=vpx+dx*10;
    // tpz=vpz-dz*10;
    DrawScene();
}
void GLContext::TurnLeft() {
    heading+=0.17444;
    double dx=cos(heading);
    double dz=sin(heading);
    // tpx=vpx+dx*10;
    // tpz=vpz-dz*10;
    DrawScene();
}
*/

