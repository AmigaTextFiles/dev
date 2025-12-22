/*-------------------------------------------
  VRMLParser.cc
  Version: 0.39
  Date: 24 august 1998
  Author: BODMER Stephan (bodmer@uni2a.unige.ch)
  Note: Object to Parse a VRML V1.0 file
----------------------------------------------*/
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

#include <dos/dosextens.h>
#include <libraries/mui.h>

#include <proto/muimaster.h>
#include <proto/dos.h>
#include <proto/alib.h>

#include "VRMLParser.h"

// NodeName
NodeName::NodeName() {
    strcpy(def,"");
    node=NULL;
}
NodeName::NodeName(char *d, VRMLNode *n) {
    strncpy(def,d,255);node=n;
}
NodeName::~NodeName() {
}
// NameServer
NameServer::NameServer()
    :deflist() {
    // puts("NameServer constructor");
}
NameServer::~NameServer() {
    // puts("NodeNames destructor");
}
int NameServer::Set (char *name, VRMLNode *n) {
    int found=0;
    NodeName *cnn=NULL;

    if (!strcmp(name,"NONE")) {return 0;};

    for (int i=0;i<deflist.Length();i++) {
	cnn=deflist.Get(i);
	if (!strcmp(cnn->def,name)) {
	    strncpy(cnn->def,name,255);
	    cnn->node=n;
	    // puts("Replaced");
	    return 1;
	};
    };
    deflist.Add(new NodeName(name,n));
    return 1;
}
VRMLNode *NameServer::Get (char *name) {
    for (int i=0;i<deflist.Length();i++) {
	if (!strcmp(deflist.Get(i)->def,name)) {
	    return deflist.Get(i)->node;
	};
    };
    return NULL;
}
void NameServer::Add (NodeName *nn) {
    deflist.Add(nn);
}
void NameServer::Clear() {
    deflist.ClearList();
}
void NameServer::Print() {
    NodeName *cnn=NULL;

    printf("%d Names in server\n",deflist.Length());
    for (int i=0;i<deflist.Length();i++) {
	cnn=deflist.Get(i);
	printf("Name:%s\n",cnn->def);
    };
}


// -------------------------------------------
// VRMLParser Constructor
//-------------------------------------------
VRMLParser::VRMLParser(LoadVRMLParams *par)
    :ns(),state() {
    // puts("In VRMLParser constructor");
    /*
    state.nb=NULL;state.mb=NULL;
    state.n=NULL;state.m=NULL;
    state.c3=NULL;state.tc2=NULL;
    */
    Size=0;Pos=0;line=1;
    mg=NULL;
    Lst=NULL;
    lp=par;

    GA_Msg = GaugeObject,
	GaugeFrame,
	MUIA_HelpNode, "GA_Msg",
	MUIA_FixHeight, 10,
	MUIA_Gauge_Horiz, TRUE,
	MUIA_Gauge_Max, 100,
    End;

    TX_Msg = TextObject,
	MUIA_Background, MUII_TextBack,
	MUIA_Frame, MUIV_Frame_Text,
	MUIA_Text_Contents, "",
	MUIA_Text_SetMin, TRUE,
    End;

    WI_Msg = WindowObject,
	MUIA_Window_Title, "Messages",
	// MUIA_Window_ID, MAKE_ID('2', 'W', 'I', 'N'),
	MUIA_Window_CloseGadget, FALSE,
	MUIA_Window_SizeGadget, FALSE,
	MUIA_Window_NoMenus, TRUE,
	MUIA_Window_Open, FALSE,
	MUIA_Window_Width, MUIV_Window_Width_Screen(30),
	MUIA_Window_RefWindow, lp->RefWindow,
	WindowContents, GroupObject,
	    Child, GA_Msg,
	    Child, ScaleObject,
		MUIA_Scale_Horiz, TRUE,
	    End,
	    Child, TX_Msg,
	End,
    End;

    DoMethod((Object *) lp->App,OM_ADDMEMBER,WI_Msg);
}
VRMLParser::~VRMLParser() {
    // puts("In VRMLParser destructor");
    DoMethod((Object *) lp->App,OM_REMMEMBER,WI_Msg);
    MUI_DisposeObject((Object *) WI_Msg);
}

// PUBLIC Methods
//-----------------------------------
// Load the whole structure
VRMLGroups *VRMLParser::LoadVRML_V1 (char *filename) {
    char temp[1000],defname[255];
    int maxlen=0,pathlen=0,i=0;

    strcpy(defname,"ROOT");
    Pos=0;Size=0;line=1;

    // puts("===>VRMLParser::LoadVRML_V1");
    // strcpy(dir,"");
    maxlen=strlen(filename);
    pathlen=strlen(PathPart(filename));

    // printf("filename:%s len:%d\n",maxlen);
    // printf("Pathpart:%s len:%d\n",PathPart(filename),pathlen);
    // strncpy(dir,filename,maxlen-pathlen-1);
    // strcpy(dir,PathPart(filename));
    //----------- strncpy doesn't work corectly !!!
    for (i=0;i<maxlen-pathlen;i++) {
	dir[i]=filename[i];
    };
    dir[i]='\0';
    // strncpy(dir,filename,maxlen-pathlen);
    // strcat(dir,"TEST");
    // printf("dir:%s len:%d\n",dir,strlen(dir));
    fd=fopen(filename,"r");
    if (fd==NULL) {
	// puts("Error opening file");
	return NULL;
    };
    SetAttrs((Object *) TX_Msg, MUIA_Text_Contents, "Loading VRML V1.0 ascii file");
    SetAttrs((Object *) GA_Msg, MUIA_Gauge_Current,0);
    SetAttrs((Object *) GA_Msg, MUIA_Gauge_Max,1);
    SetAttrs((Object *) WI_Msg, MUIA_Window_Open, TRUE);
    Size=fseek(fd,0,SEEK_END);
    Size=ftell(fd);
    // printf("Size of file:%d\n",Size);

    Lst=(char *) malloc(Size);
    rewind(fd);
    fread(Lst,1,Size,fd);

    SetAttrs((Object *) TX_Msg, MUIA_Text_Contents, "Parsing VRML V1.0 world");
    SetAttrs((Object *) GA_Msg, MUIA_Gauge_Max, Size);

    // Begin the VRMLFile init
    if (lp->pfd!=NULL) {
	// puts("pfd not NULL");
	if (lp->msgtype==ALLMSG) {
	    fprintf(lp->pfd,"**** BEGIN OF PARSING ****\n");
	};
    };

    // puts("Begin parsing");
    NextWord(temp);
    if (!strcmp(temp,"DEF")) {
	NextWord(defname);
	NextWord(temp);
    };

    if (!strcmp(temp,"Group")) {
	mg=(VRMLGroups *) ReadGroupNode(defname);
    }
    else if (!strcmp(temp,"LOD")) {
	mg=(VRMLGroups *) ReadLODNode(defname);
    }
    else if (!strcmp(temp,"Separator")) {
	mg=(VRMLGroups *) ReadSeparatorNode(defname);
    }
    else if (!strcmp(temp,"Switch")) {
	mg=(VRMLGroups *) ReadSwitchNode(defname);
    }
    else if (!strcmp(temp,"TransformSeparator")) {
	mg=(VRMLGroups *) ReadTransformSeparatorNode(defname);
    }
    else if (!strcmp(temp,"WWWAnchor")) {
	mg=(VRMLGroups *) ReadWWWAnchorNode(defname);
    }
    else {
	if (lp->pfd) {
		fprintf(lp->pfd,"ERROR Line:%d->First node is not a grouping node\n",line);
	};
    };
    // puts("Hors du root");
    free (Lst);
    // delete Lst;

    if (lp->pfd!=NULL) {
	if (lp->msgtype==ALLMSG) {
	    fprintf(lp->pfd,"**** END ****\n");
	};
    };
    // puts("<===VRMLParser::LoadVRML_V1");
    fclose(fd);
    SetAttrs((Object *) WI_Msg, MUIA_Window_Open, FALSE);
    return mg;
}

// PRIVATE methods
//----------------
// Print errors ?
void VRMLParser::KeywordNotFound(char *key) {
    if (lp->pfd) {
	fprintf(lp->pfd,"ERROR Line:%d->unknow keyword %s\n",line,key);
    };
}

// ReadComment
void VRMLParser::ReadComment() {
    char c=Lst[Pos];
    if (lp->pfd) {
	if (lp->msgtype==ALLMSG) {
		fprintf(lp->pfd,"%d:Read a Comment\n",line);
	};
    };
    while ((c!='\n')&&
	   (c!='\r')) {
	    Pos++;
	    c=Lst[Pos];
	    if (Pos>=Size) break;
	    // printf("char:%c ascii:%d\n",c,c);
    };
    line++;
    Pos++;
}

// NextWord
// Parse the loaded file
int VRMLParser::NextWord(char *temp) {
    char c;
    int i=0;

    while (1) {
	if (Pos>=Size) {
		strcpy(temp,"}");
		break;
	};
	c=Lst[Pos];
	// printf("%c",c);

	// skip space char an other
	if ((c==' ')||
	    // (c==9)||
	    (c=='\t')||
	    (c=='\n')||
	    (c=='\r')||
	    (c==',')||
	    (c=='|')||
	    (c=='(')||
	    (c==')')||
	    (c=='{')) {
	    Pos++;
	    if ((c=='\n')||
		(c=='\r')) line++;
	    continue;
	};

	// string found
	if (c=='"') {
	    // puts("trouve guillmet");
	    Pos++;
	    c=Lst[Pos];
	    while (c!='"') {
		temp[i]=c;
		Pos++;i++;
		c=Lst[Pos];
	    };
	    temp[i]='\0';
	    Pos++;
	    break;
	}
	else if (c=='#') {
	    ReadComment();
	    continue;
	}
	else if (c==']') {
	    strcpy(temp,"]");
	    Pos++;
	    break;
	}
	else if (c=='[') {
	    strcpy(temp,"[");
	    Pos++;
	    break;
	}
	else if (c=='}') {
	    strcpy(temp,"}");
	    Pos++;
	    break;
	};

	// puts("Other");
	while((c!=' ')&&
	      (c!='\t')&&
	      (c!='\n')&&
	      (c!='\r')&&
	      (c!='\0')&&
	      (c!=',')&&
	      (c!='[')&&
	      (c!=']')&&
	      (c!='(')&&
	      (c!=')')&&
	      (c!='|')&&
	      (c!='}')&&
	      (c!='"')) {
		// puts("IN LOOP");
		temp[i]=c;
		i++;Pos++;
		c=Lst[Pos];
		if (Pos>=Size) break;
	};
	temp[i]='\0';
	break;
    };
    // printf("Next WORD returned:%s\n",temp);
    // SetAttrs((Object *) obj->GA_Msg, MUIA_Gauge_Current, Pos);
    return 0;
}

/*******************************
 * Init the VRMLNode Structure *
 * MAIN Method                 *
 *******************************/
/**************************
 * Reading all nodes      *
 **************************/
//ReadGroupNodes
VRMLNode *VRMLParser::ReadGroupNodes(char *temp, char *newdefname) {
	VRMLNode *n=NULL;

	// puts("=>Groups");
	if (!strcmp(temp,"AsciiText")) {
	    n=ReadAsciiTextNode(newdefname);
	}
	else if (!strcmp(temp,"Cone")) {
	    n=ReadConeNode(newdefname);
	}
	else if (!strcmp(temp,"Coordinate3")) {
	    n=ReadCoordinate3Node(newdefname);
	}
	else if (!strcmp(temp,"Cube")) {
	    n=ReadCubeNode(newdefname);
	}
	else if (!strcmp(temp,"Cylinder")) {
	    n=ReadCylinderNode(newdefname);
	}
	else if (!strcmp(temp,"DirectionalLight")) {
	    n=ReadDirectionalLightNode(newdefname);
	}
	else if (!strcmp(temp,"FontStyle")) {
	    n=ReadFontStyleNode(newdefname);
	}
	else if (!strcmp(temp,"Group")) {
	    n=ReadGroupNode(newdefname);
	}
	else if (!strcmp(temp,"IndexedFaceSet")) {
	    n=ReadIndexedFaceSetNode(newdefname);
	}
	else if (!strcmp(temp,"IndexedLineSet")) {
	    n=ReadIndexedLineSetNode(newdefname);
	}
	else if (!strcmp(temp,"Info")) {
	    n=ReadInfoNode(newdefname);
	}
	else if (!strcmp(temp,"LOD")) {
	    n=ReadLODNode(newdefname);
	}
	else if (!strcmp(temp,"Material")) {
	    n=ReadMaterialNode(newdefname);
	}
	else if (!strcmp(temp,"MaterialBinding")) {
	    n=ReadMaterialBindingNode(newdefname);
	}
	else if (!strcmp(temp,"MatrixTransform")) {
	    n=ReadMatrixTransformNode(newdefname);
	}
	else if (!strcmp(temp,"Normal")) {
	    n=ReadNormalNode(newdefname);
	}
	else if (!strcmp(temp,"NormalBinding")) {
	    n=ReadNormalBindingNode(newdefname);
	}
	else if (!strcmp(temp,"OrthographicCamera")) {
	    n=ReadOrthographicCameraNode(newdefname);
	}
	else if (!strcmp(temp,"PerspectiveCamera")) {
	    n=ReadPerspectiveCameraNode(newdefname);
	}
	else if (!strcmp(temp,"PointLight")) {
	    n=ReadPointLightNode(newdefname);
	}
	else if (!strcmp(temp,"PointSet")) {
	    n=ReadPointSetNode(newdefname);
	}
	else if (!strcmp(temp,"Rotation")) {
	    n=ReadRotationNode(newdefname);
	}
	else if (!strcmp(temp,"Scale")) {
	    n=ReadScaleNode(newdefname);
	}
	else if (!strcmp(temp,"Separator")) {
	    n=ReadSeparatorNode(newdefname);
	}
	else if (!strcmp(temp,"ShapeHints")) {
	    n=ReadShapeHintsNode(newdefname);
	}
	else if (!strcmp(temp,"Sphere")) {
	    n=ReadSphereNode(newdefname);
	}
	else if (!strcmp(temp,"SpotLight")) {
	    n=ReadSpotLightNode(newdefname);
	}
	else if (!strcmp(temp,"Switch")) {
	    n=ReadSwitchNode(newdefname);
	}
	else if (!strcmp(temp,"Texture2")) {
	    n=ReadTexture2Node(newdefname);
	}
	else if (!strcmp(temp,"Texture2Transform")) {
	    n=ReadTexture2TransformNode(newdefname);
	}
	else if (!strcmp(temp,"TextureCoordinate2")) {
	    n=ReadTextureCoordinate2Node(newdefname);
	}
	else if (!strcmp(temp,"Transform")) {
	    n=ReadTransformNode(newdefname);
	}
	else if (!strcmp(temp,"TransformSeparator")) {
	    n=ReadTransformSeparatorNode(newdefname);
	}
	else if (!strcmp(temp,"Translation")) {
	    n=ReadTranslationNode(newdefname);
	}
	else if (!strcmp(temp,"WWWAnchor")) {
	    n=ReadWWWAnchorNode(newdefname);
	}
	else if (!strcmp(temp,"WWWInline")) {
	    n=ReadWWWInlineNode(newdefname);
	}
	else if (!strcmp(temp,"USE")) {
	    n=ReadUSENode(newdefname);
	}
	else {
	    KeywordNotFound(temp);
	};
	// puts("Return n");
	if (GA_Msg) {
	    SetAttrs((Object *) GA_Msg, MUIA_Gauge_Current, Pos);
	};
	// puts("<=Groups::return");
	return n;
}
//-------------------
// ReadAsciiTextNode
//-------------------
VRMLNode *VRMLParser::ReadAsciiTextNode(char *name) {
    char temp[255];
    AsciiText *a;
    int out=0,max=0,i=0;
    VList<MyString> string;
    VList<float> width;

    if (lp->pfd) {
	if (lp->msgtype==ALLMSG) {
		fprintf(lp->pfd,"AsciiText found at line:%d\n",line);
	};
    };
    a=new AsciiText(name);
    NextWord(temp);
    while ((strcmp(temp,"}"))&&
	   (strcmp(temp,"{}"))) {
	if (!strcmp(temp,"string")) {
	    NextWord(temp);
	    if (!strcmp(temp,"[")) {out=0;NextWord(temp);}
	    else {out=1;};
	    while (1) {
		string.Add(MyString(temp));
		if (out) break;
		NextWord(temp);
		if (!strcmp(temp,"]")) break;
	    };
	}
	else if (!strcmp(temp,"spacing")) {
	    NextWord(temp);
	    a->spacing=(float) atof(temp);
	}
	else if (!strcmp(temp,"justification")) {
	    NextWord(temp);
	    if (!strcmp(temp,"LEFT")) {a->justification=JUSTIFICATION_LEFT;}
	    else if (!strcmp(temp,"CENTER")) {a->justification=JUSTIFICATION_CENTER;}
	    else if (!strcmp(temp,"RIGHT")) {a->justification=JUSTIFICATION_RIGHT;}
	    else {KeywordNotFound(temp);};
	}
	else if (!strcmp(temp,"width")) {
	    NextWord(temp);
	    if (!strcmp(temp,"[")) {out=0;NextWord(temp);}
	    else {out=1;};
	    int count=0;
	    while (1) {
		width.Add((float) atof(temp));
		if (out) break;
		NextWord(temp);
		if (!strcmp(temp,"]")) break;
	    };
	}
	else {
	    KeywordNotFound(temp);
	};
	NextWord(temp);
    };
    max=string.Length();
    if (width.Length()>max) {max=width.Length();};

    // complete Lists
    for (i=0;i<max-string.Length();i++) {
	string.Add(MyString("NONE"));
    };
    for (i=0;i<max-width.Length();i++) {
	width.Add(0);
    };

    // Create Txt
    for (i=0;i<max;i++) {
	StringWidth *sw=new StringWidth(string.Get(i).str,width.Get(i));
	a->AddTxt(sw);
    };
    if (lp->pfd) {
	if (lp->msgtype==ALLMSG) {
		fprintf(lp->pfd,"%d string\n",a->Size());
	};
    };

    return (VRMLNode *) a;
}
//--------------
// ReadConeNode
//--------------
VRMLNode *VRMLParser::ReadConeNode(char *name) {
    char temp[255];
    Cone *c;
    float r=1.0,h=2.0;
    int p=SIDES+BOTTOM;

    // puts(">In ReadConeNode");
    if (lp->pfd) {
	if (lp->msgtype==ALLMSG) {
		fprintf(lp->pfd,"%d:Cone found\n",line);
	};
    };
    c=new Cone(name);
    NextWord(temp);
    while ((strcmp(temp,"}"))&&
	   (strcmp(temp,"{}"))) {
	if (!strcmp(temp,"bottomRadius")) {
	    NextWord(temp);
	    c->bottomRadius=(double) atof(temp);
	}
	else if(!strcmp(temp,"height")) {
	    NextWord(temp);
	    c->height=(double) atof(temp);
	}
	else if(!strcmp(temp,"parts")) {
	    NextWord(temp);
	    // printf("Word in parts:%s\n",temp);
	    if (!strcmp(temp,"ALL")) {p=SIDES+BOTTOM;NextWord(temp);continue;};
	    p=0;
	    while ((!strcmp(temp,"SIDES"))||
		   (!strcmp(temp,"BOTTOM"))) {
		    // puts("In loop");
		    if (!strcmp(temp,"SIDES")) {
			// puts("SIDES found");
			p=p+SIDES;
		    }
		    else if(!strcmp(temp,"BOTTOM")) {
			// puts("BOTTOM found");
			p=p+BOTTOM;
		    };
		    NextWord(temp);
	    };
	    c->parts=p;
	    continue;
	}
	else {
	    KeywordNotFound(temp);
	}; // end if
	NextWord(temp);
    }; // end while
    return (VRMLNode *) c;
}
//---------------------
// ReadCoordinate3Node
//---------------------
VRMLNode *VRMLParser::ReadCoordinate3Node (char *name) {
    char temp[255],num[255];
    int out=0,cpt=0;
    Coordinate3 *co=NULL;
    double xyz[3]={0.0,0.0,0.0};
    double x,y,z;

    // puts(">In ReadCoordinate3Node");
    if (lp->pfd) {
	if (lp->msgtype==ALLMSG) {
		fprintf(lp->pfd,"%d:Coordinate3 found ",line);
	};
    };

    co=new Coordinate3(name);
    NextWord(temp);
    if (!strcmp(temp,"{}")) return (VRMLNode *) co;
    while (strcmp(temp,"}")) {
	if(!strcmp(temp,"point")) {
	    // puts ("point keyword found");
	    NextWord(temp);
	    if (!strcmp(temp,"[")) {out=0;NextWord(temp);}
	    else {out=1;};
	    while (1) {
		// sprintf(num,"%.4g",atof(temp));
		xyz[0]=(double) atof(temp);
		// x=(double) atof(temp);
		// xyz[0]=x;
		// printf("temp:%s double:%-.10g x:%f xyz[0]:%f\n",temp,atof(temp),x,xyz[0]);
		// perror("ERROR:");
		// sscanf(temp,"%f",&xyz[0]);
		// xyz[0]=strtod(temp,NULL);
		NextWord(temp);
		// sprintf(num,"%.4g",atof(temp));
		// y=(double) atof(temp);
		// xyz[1]=y;
		xyz[1]=(double) atof(temp);
		// printf("temp:%s double:%-.10g x:%f xyz[0]:%f\n",temp,atof(temp),y,xyz[1]);
		// sscanf(temp,"%f",&xyz[1]);
		// xyz[1]=strtod(temp,NULL);
		NextWord(temp);
		// sprintf(num,"%.4g",atof(temp));
		xyz[2]=(double) atof(temp);
		// z=(double) atof(temp);
		// sscanf(temp,"%f",&xyz[2]);
		// xyz[2]=strtod(temp,NULL);
		// printf("Value x:%f y:%f z:%f\n",xyz[0],xyz[1],xyz[2]);
		// strcat(temp,"");
		// printf("temp:%s atof:%f Value x:%f y:%f z:%f\n",temp,atof(temp),x,y,z);
		co->AddPoint(new Vertex3d(xyz));
		if (out) break;
		NextWord(temp);
		if (!strcmp(temp,"]")) break;

		if (cpt>100) {
		    if (GA_Msg) {
			SetAttrs((Object *) GA_Msg, MUIA_Gauge_Current, Pos);
		    };
		    cpt=0;
		};
		cpt++;
	    };
	}
	else {
	    KeywordNotFound(temp);
	};
	NextWord(temp);
    }; // end while
    if (lp->pfd) {
	if (lp->msgtype==ALLMSG) {
		fprintf(lp->pfd,"[%d points]\n",co->Size());
	};
    };
    // puts("Out of the loop");
    // strcpy(temp,"-3.14343254354");
    // printf("last temp:%s atof:%f\n",temp,atof(temp));
    state.c3=co;
    return (VRMLNode *) co;
}
//--------------
// ReadCubeNode
//--------------
VRMLNode *VRMLParser::ReadCubeNode(char *name) {
    char temp[255];
    Cube *c=NULL;
    float w=2.0,h=2.0,d=2.0;

    // puts("=>VRMLPArser::Cube");
    if (lp->pfd) {
	if (lp->msgtype==ALLMSG) {
		fprintf(lp->pfd,"%d:Cube found\n",line);
	};
    };

    c=new Cube(name);
    NextWord(temp);
    while ((strcmp(temp,"}"))&&
	   (strcmp(temp,"{}"))) {
	if (!strcmp(temp,"width")) {
	    NextWord(temp);
	    c->width=(double) atof(temp);
	}
	else if (!strcmp(temp,"height")) {
	    NextWord(temp);
	    c->height=(double) atof(temp);
	}
	else if (!strcmp(temp,"depth")) {
	    NextWord(temp);
	    c->depth=(double) atof(temp);
	}
	else {
	    KeywordNotFound(temp);
	};
	NextWord(temp);
    } // end while
    // c->Print();
    // puts("<=VRMLParser::Cube");
    return (VRMLNode *) c;
}
//------------------
// ReadCylinderNode
//------------------
VRMLNode *VRMLParser::ReadCylinderNode(char *name) {
    char temp[255];
    Cylinder *c=NULL;
    float r=1.0,h=2.0;
    int p=ALL;

    // puts(">In ReadCylinderNode");
    if (lp->pfd) {
	if (lp->msgtype==ALLMSG) {
		fprintf(lp->pfd,"%d:Cylinder found\n",line);
	};
    };

    c=new Cylinder(name);
    NextWord(temp);
    if (!strcmp(temp,"{}")) return c;
    while ((strcmp(temp,"}"))&&
	   (strcmp(temp,"{}"))) {
	if (!strcmp(temp,"radius")) {
	    NextWord(temp);
	    c->radius=(double) atof(temp);
	}
	else if(!strcmp(temp,"height")) {
	    NextWord(temp);
	    c->height=(double) atof(temp);
	}
	else if(!strcmp(temp,"parts")) {
	    NextWord(temp);
	    if (!strcmp(temp,"ALL")) {p=ALL;NextWord(temp);continue;};
	    // printf("Word in parts:%s\n",temp);
	    p=0;
	    while ((!strcmp(temp,"SIDES"))||
		   (!strcmp(temp,"TOP"))||
		   (!strcmp(temp,"BOTTOM"))) {
		   if(!strcmp(temp,"SIDES")) {p=p+SIDES;}
		   else if(!strcmp(temp,"TOP")) {p=p+TOP;}
		   else if(!strcmp(temp,"BOTTOM")) {p=p+BOTTOM;};
		   NextWord(temp);
	    };
	    c->parts=p;
	    continue;
	}
	else {
	    KeywordNotFound(temp);
	}; // end if
	NextWord(temp);
    }; // end while
    return (VRMLNode *) c;
}
//--------------------------
// ReadDirectionalLightNode
//--------------------------
VRMLNode *VRMLParser::ReadDirectionalLightNode(char *name) {
    char temp[255];
    DirectionalLight *dl;

    // puts(">In ReadDirectionalNode");
    if (lp->pfd) {
	if (lp->msgtype==ALLMSG) {
		fprintf(lp->pfd,"%d:DirectionalLight found\n",line);
	};
    };
    dl=new DirectionalLight(name);
    NextWord(temp);
    if (!strcmp(temp,"{}")) return (VRMLNode *) dl;
    while (strcmp(temp,"}")) {
	if (!strcmp(temp,"direction")) {
	    NextWord(temp);
	    dl->point.coord[0]=(double) atof(temp);
	    NextWord(temp);
	    dl->point.coord[1]=(double) atof(temp);
	    NextWord(temp);
	    dl->point.coord[2]=(double) atof(temp);
	    // dl->SetPoint(x,y,z);
	}
	else if(!strcmp(temp,"on")) {
	    NextWord(temp);
	    if (!strcmp(temp,"TRUE")) {
		dl->on=1;
	    }
	    else {
		dl->on=0;
	    };
	}
	else if(!strcmp(temp,"intensity")) {
	    NextWord(temp);
	    dl->intensity=(float) atof(temp);
	}
	else if(!strcmp(temp,"color")) {
	    NextWord(temp);
	    dl->color.rgb[0]=(float) atof(temp);
	    NextWord(temp);
	    dl->color.rgb[1]=(float) atof(temp);
	    NextWord(temp);
	    dl->color.rgb[2]=(float) atof(temp);
	}
	else {
	    KeywordNotFound(temp);
	}; // end if
	NextWord(temp);
    }; // end while }
    return (VRMLNode *) dl;
}
//---------------
// ReadFontStyle
//---------------
VRMLNode *VRMLParser::ReadFontStyleNode(char *name) {
    char temp[255];
    FontStyle *fs;
    int st=0;

    if (lp->pfd) {
	if (lp->msgtype==ALLMSG) {
		fprintf(lp->pfd,"%d:FontStyle found\n",line);
	};
    };
    fs=new FontStyle(name);
    NextWord(temp);
    while ((strcmp(temp,"}"))&&
	   (strcmp(temp,"{}"))) {
	    if (!strcmp(temp,"size")) {
		NextWord(temp);
		fs->size=(float) atof(temp);
	    }
	    else if (!strcmp(temp,"family")) {
		NextWord(temp);
		if (!strcmp(temp,"SERIF")) {fs->family=FONTFAMILY_SERIF;}
		else if (!strcmp(temp,"SANS")) {fs->family=FONTFAMILY_SANS;}
		else if (!strcmp(temp,"TYPEWRITER")) {fs->family=FONTFAMILY_TYPEWRITER;}
		else {KeywordNotFound(temp);};
	    }
	    else if (!strcmp(temp,"style")) {
		NextWord(temp);
		// printf("Found:%s\n",temp);
		if (!strcmp(temp,"NONE")) {st=FONTSTYLE_NONE;NextWord(temp);continue;};
		while ((!strcmp(temp,"BOLD"))||
		       (!strcmp(temp,"ITALIC"))) {
			// printf("In loop found:%s\n",temp);
			if(!strcmp(temp,"BOLD")) {
			    // puts("Bold recon");
			    st=st+FONTSTYLE_BOLD;
			}
			else if(!strcmp(temp,"ITALIC")) {
			    // puts("Italic recon");
			    st=st+FONTSTYLE_ITALIC;
			};
			NextWord(temp);
		};
		fs->style=st;
		continue;
	    }
	    else {
	       KeywordNotFound(temp);
	    };
	    NextWord(temp);
     };
     return (VRMLNode *) fs;
}
//--------------
// ReadGroupNode
//--------------
VRMLNode *VRMLParser::ReadGroupNode(char *name) {
    char temp[50],newdefname[50];
    VRMLNode *n;
    Group *g;

    // printf(">In ReadGroupNode:%s\n",name);
    if (lp->pfd) {
	if (lp->msgtype==ALLMSG) {
		fprintf(lp->pfd,"%d:Group found\n",line);
	};
    };

    strcpy(temp,"");strcpy(newdefname,"NONE");
    g=new Group(name); // Construction of Group
    NextWord(temp); // Read the first word after the Group keyword
    // printf("%s\n",temp);
    while ((strcmp(temp,"}"))&&
	   (Pos<Size)) {
	// NextWord(temp);
	if (!strcmp(temp,"DEF")) {
		NextWord(temp);
		strcpy(newdefname,temp);
		NextWord(temp);
	};
	// printf("Envoi a ReadGroupNodes:%s\n",temp);
	n=ReadGroupNodes(temp,newdefname);
	if (n!=NULL) {
	    g->AddChild(n);
	    ns.Set(newdefname,n);
	}
	else {
	    if (lp->pfd) {
	       fprintf(lp->pfd,"ERROR: Cannot parse %s node\n",temp);
	    };
	};
	strcpy(newdefname,"NONE");
	NextWord(temp);
    }; // end while
    // puts("Hors du group");
    return (VRMLNode *) g;
}
//------------------------
// ReadIndexedFaceSetNode
//------------------------
VRMLNode *VRMLParser::ReadIndexedFaceSetNode (char *name) {
    char temp[255];
    IndexedFaceSet *ifs;
    int index,j=0,i,out=0;
    int maxc=0,maxm=0,maxn=0,maxtc=0;
    // puts(">In ReadIndexedFaceSetNode");
    if (lp->pfd) {
	if (lp->msgtype==ALLMSG) {
	    fprintf(lp->pfd,"%d:IndexedFaceSet found ",line);
	};
    };
    ifs=new IndexedFaceSet (name);
    NextWord(temp);
    if (!strcmp(temp,"{}")) return (VRMLNode *) ifs;
    while (strcmp(temp,"}")) {
	if (!strcmp(temp,"coordIndex")) {
	    if (state.c3) {
		maxc=state.c3->Size();
	    };
	    NextWord(temp);
	    if (!strcmp(temp,"[")) {out=0;NextWord(temp);}
	    else {out=1;};
	    while (1) {
		Face *ftemp=new Face();
		index=atoi(temp);
		while (index!=-1) {
		   if (lp->pfd) {
		    if (index>maxc) {
			fprintf(lp->pfd,"ERROR line:%d->A coordIndex is out of current context\n",line);
		    };
		   };
		   ftemp->coordIndex.Add(index);
		   NextWord(temp);
		   if (!strcmp(temp,"]")) {
		       out=1;
		       break;
		   };
		   index=atoi(temp);
		};
		// puts("Face added");
		ifs->AddFace(ftemp);
		if (out) break;
		NextWord(temp);
		if (!strcmp(temp,"]")) break;
	    }; // End while ]
	    // puts("Finished reading coordIndex");
	}
	else if (!strcmp(temp,"materialIndex")) {
	    ifs->writeMaterialIndex=TRUE;
	    if (state.m) {maxm=state.m->Size();};
	    NextWord(temp);
	    if (!strcmp(temp,"[")) {out=0;NextWord(temp);}
	    else {out=1;};
	    i=0;
	    while (1) {
		Face *cf=ifs->GetFace(i);
		index=atoi(temp);
		if (cf!=NULL) {
			if ((state.mb!=NULL)&&
			    (state.mb->value==BINDING_PER_VERTEX_INDEXED)) {
			    while (index!=-1) {
				if (lp->pfd) {
				    if (index>maxc) {
					fprintf(lp->pfd,"ERROR line:%d->A materialIndex is out of current context\n",line);
				    };
				};
				cf->materialIndex.Add(index);
				NextWord(temp);
				index=atoi(temp);
			    };
			}
			else {
			    if (lp->pfd) {
				if (index>maxc) {
				    fprintf(lp->pfd,"ERROR line:%d->A coordIndex is out of current context\n",line);
				};
			    };
			    cf->materialIndex.Add(index);
			};
		}
		else {
		  if (lp->pfd) {
		    fprintf(lp->pfd,"ERROR: In IndexedFaceSet a materialIndex is"
			    " declared for a non existant face, line:%d\n",line);
		  };
		};
		if (out) break;
		NextWord(temp);
		i++;
		if (!strcmp(temp,"]")) break;
	    }; // End while ]
	}
	else if (!strcmp(temp,"normalIndex")) {
	    ifs->writeNormalIndex=TRUE;
	    if (state.n) {maxn=state.n->Size();};
	    NextWord(temp);
	    if (!strcmp(temp,"[")) {out=0;NextWord(temp);}
	    else {out=1;};
	    i=0;
	    while (1) {
		Face *cf=ifs->GetFace(i);
		index=atoi(temp);
		if (cf!=NULL) {
			if ((state.nb!=NULL)&&
			    (state.nb->value==BINDING_PER_VERTEX_INDEXED)||
			    (state.nb->value==BINDING_DEFAULT)) {
			    while (index!=-1) {
				if (lp->pfd) {
				    if (index>maxn) {
					fprintf(lp->pfd,"ERROR line:%d->A normalIndex is out of current context\n",line);
				    };
				};
				cf->normalIndex.Add(index);
				NextWord(temp);
				if (!strcmp(temp,"}")) break;
				index=atoi(temp);
			    };
			}
			else {
			    if (lp->pfd) {
				if (index>maxn) {
				    fprintf(lp->pfd,"ERROR line:%d->A normalIndex is out of current context\n",line);
				};
			    };
			    cf->normalIndex.Add(index);
			};
		}
		else {
		  if (lp->pfd) {
		    fprintf(lp->pfd,"ERROR: In IndexedFaceSet a normalIndex is"
			    " declared for a non existant face, line:%d\n",line);
		  };
		};
		if (out) break;
		NextWord(temp);
		i++;
		if (!strcmp(temp,"]")) break;
	    };
	}
	else if (!strcmp(temp,"textureCoordIndex")) {
	    ifs->writeTextureCoordIndex=TRUE;
	    if (state.tc2) {maxtc=state.tc2->Size();};
	    NextWord(temp);
	    if (!strcmp(temp,"[")) {out=0;NextWord(temp);}
	    else {out=1;};
	    i=0;
	    while (1) {
		Face *cf=ifs->GetFace(i);
		if (cf!=NULL) {
		    index=atoi(temp);
		    while (index!=-1) {
			if (lp->pfd) {
			    if (index>maxtc) {
				fprintf(lp->pfd,"ERROR line:%d->A textureCoordIndex is out of current context\n",line);
			    };
			};
			cf->textureCoordIndex.Add(index);
			NextWord(temp);
			index=atoi(temp);
		    };
		}
		else {
		  if (lp->pfd) {
		    fprintf(lp->pfd,"ERROR: In IndexedFaceSet a textureCoordIndex is"
			    " declared for a non existant face, line:%d\n",line);
		  };
		};
		if (out) break;
		NextWord(temp);
		i++;
		if (!strcmp(temp,"]")) break;
	    };
	}
	else {
	    KeywordNotFound(temp);
	}; // end if materialIndex,coordIndex
	NextWord(temp);
    }; // end while }
    // puts("Finished reading");
    if (lp->pfd) {
	if (lp->msgtype==ALLMSG) {
	   fprintf(lp->pfd,"[%d faces]\n",ifs->Size());
	};
    };
    return (VRMLNode *) ifs;
}
//------------------------
// ReadIndexedLineSetNode
//------------------------
VRMLNode *VRMLParser::ReadIndexedLineSetNode (char *name) {
    char temp[255];
    IndexedLineSet *ils;
    int index,j=0,i,out=0;
    int maxc=0,maxm=0,maxn=0,maxtc=0;

    if (lp->pfd) {
	if (lp->msgtype==ALLMSG) {
	    fprintf(lp->pfd,"%d:IndexedLineSet found ",line);
	};
    };
    ils=new IndexedLineSet (name);
    NextWord(temp);
    if (!strcmp(temp,"{}")) return (VRMLNode *) ils;
    while (strcmp(temp,"}")) {
	if (!strcmp(temp,"coordIndex")) {
	    if (state.c3) {maxc=state.c3->Size();};
	    NextWord(temp);
	    if (!strcmp(temp,"[")) {out=0;NextWord(temp);}
	    else {out=1;};
	    while (1) {
		Face *ftemp=new Face();
		index=atoi(temp);
		while (index!=-1) {
		   if (lp->pfd) {
		    if (index>maxc) {
			fprintf(lp->pfd,"ERROR line:%d->A coordIndex is out of current context\n",line);
		    };
		   };
		   ftemp->coordIndex.Add(index);
		   NextWord(temp);
		   if (!strcmp(temp,"]")) {
		       // puts("] found without -1");
		       out=1;
		       break;
		   };
		   index=atoi(temp);
		};
		ils->AddLine(ftemp);
		if (out) break;
		NextWord(temp);
		if (!strcmp(temp,"]")) break;
	    }; // End while ]
	    // puts("Finished reading coordIndex");
	}
	else if (!strcmp(temp,"materialIndex")) {
	    ils->writeMaterialIndex=TRUE;
	    if (state.m) {maxm=state.m->Size();};
	    NextWord(temp);
	    if (!strcmp(temp,"[")) {out=0;NextWord(temp);}
	    else {out=1;};
	    i=0;
	    while (1) {
		Face *cf=ils->GetLine(i);
		index=atoi(temp);
		if (cf!=NULL) {
			if ((state.mb!=NULL)&&
			    (state.mb->value==BINDING_PER_VERTEX_INDEXED)) {
			    while (index!=-1) {
				if (lp->pfd) {
				    if (index>maxc) {
					fprintf(lp->pfd,"ERROR line:%d->A materialIndex is out of current context\n",line);
				    };
				};
				cf->materialIndex.Add(index);
				NextWord(temp);
				index=atoi(temp);
			    };
			}
			else {
			    if (lp->pfd) {
				if (index>maxc) {
				    fprintf(lp->pfd,"ERROR line:%d->A coordIndex is out of current context\n",line);
				};
			    };
			    cf->materialIndex.Add(index);
			};
		}
		else {
		  if (lp->pfd) {
		    fprintf(lp->pfd,"ERROR line:%d->In IndexedLineSet a materialIndex is"
			    " declared for a non existant line\n",line);
		  };
		};
		if (out) break;
		NextWord(temp);
		i++;
		if (!strcmp(temp,"]")) break;
	    }; // End while ]
	}
	else if (!strcmp(temp,"normalIndex")) {
	    ils->writeNormalIndex=TRUE;
	    if (state.n) {maxn=state.n->Size();};
	    NextWord(temp);
	    if (!strcmp(temp,"[")) {out=0;NextWord(temp);}
	    else {out=1;};
	    i=0;
	    while (1) {
		Face *cf=ils->GetLine(i);
		index=atoi(temp);
		if (cf!=NULL) {
			if ((state.nb!=NULL)&&
			    (state.nb->value==BINDING_PER_VERTEX_INDEXED)||
			    (state.nb->value==BINDING_DEFAULT)) {
			    while (index!=-1) {
				if (lp->pfd) {
				    if (index>maxn) {
					fprintf(lp->pfd,"ERROR line:%d->A normalIndex is out of current context\n",line);
				    };
				};
				cf->normalIndex.Add(index);
				NextWord(temp);
				index=atoi(temp);
			    };
			}
			else {
			    if (lp->pfd) {
				if (index>maxn) {
				    fprintf(lp->pfd,"ERROR line:%d->A normalIndex is out of current context\n",line);
				};
			    };
			    cf->normalIndex.Add(index);
			};
		}
		else {
		  if (lp->pfd) {
		    fprintf(lp->pfd,"ERROR: In IndexedLineSet a normalIndex is"
			    " declared for a non existant face, line:%d\n",line);
		  };
		};
		if (out) break;
		NextWord(temp);
		i++;
		if (!strcmp(temp,"]")) break;
	    };
	}
	else if (!strcmp(temp,"textureCoordIndex")) {
	    ils->writeTextureCoordIndex=TRUE;
	    if (state.tc2) {maxtc=state.tc2->Size();};
	    NextWord(temp);
	    if (!strcmp(temp,"[")) {out=0;NextWord(temp);}
	    else {out=1;};
	    i=0;
	    while (1) {
		Face *cf=ils->GetLine(i);
		if (cf!=NULL) {
		    index=atoi(temp);
		    while (index!=-1) {
			if (lp->pfd) {
			    if (index>maxtc) {
				fprintf(lp->pfd,"ERROR line:%d->A textureCoordIndex is out of current context\n",line);
			    };
			};
			cf->textureCoordIndex.Add(index);
			NextWord(temp);
			index=atoi(temp);
		    };
		}
		else {
		  if (lp->pfd) {
		    fprintf(lp->pfd,"ERROR line:%d->In IndexedLineSet a textureCoordIndex is"
			    " declared for a non existant line\n",line);
		  };
		};
		if (out) break;
		NextWord(temp);
		i++;
		if (!strcmp(temp,"]")) break;
	    };
	}
	else {
	    KeywordNotFound(temp);
	}; // end if materialIndex,coordIndex
	NextWord(temp);
    }; // end while }
    // puts("Finished reading");
    if (lp->pfd) {
	if (lp->msgtype==ALLMSG) {
	   fprintf(lp->pfd,"[%d lines]\n",ils->Size());
	};
    };
    return (VRMLNode *) ils;
}
//------------------
// ReadInfoNode
//------------------
VRMLNode *VRMLParser::ReadInfoNode(char *name) {
   char temp[1000];
   VInfo *info;

   // puts("In ReadInfoNode");
   if (lp->pfd) {
	if (lp->msgtype==ALLMSG) {
	   fprintf(lp->pfd,"%d:Info found\n",line);
	};
   };
   info=new VInfo(name);
   NextWord(temp);
   if (!strcmp(temp,"{}")) {return (VRMLNode *) info;};
   while (strcmp(temp,"}")) {
	// printf("In loop:%s\n",temp);
	if (!strcmp(temp,"string")) {
		// printf("Found string\n");
		NextWord(temp);
		// printf("Found %s\n",temp);
		info->SetString(temp);
	};
	NextWord(temp);
   };
   return (VRMLNode *) info;
}
//----------------
// ReadLODNode
//----------------
VRMLNode *VRMLParser::ReadLODNode(char *name) {
    char temp[255],newdefname[25];
    float x,y,z;
    int out=0;
    VRMLNode *n;
    LOD *l;

    // puts(">In ReadLODNode");
   if (lp->pfd) {
	if (lp->msgtype==ALLMSG) {
	   fprintf(lp->pfd,"%d:LOD found\n",line);
	};
   };

    strcpy(temp,""); strcpy(newdefname,"NONE");
    l=new LOD(name); // Construction of LOD
    NextWord(temp); // Read the first word after the Separator keyword
    if (!strcmp(temp,"{}")) return l;
    while ((strcmp(temp,"}"))&&
	   (Pos<Size)) {
	if (!strcmp(temp,"DEF")) {
		NextWord(temp);
		strcpy(newdefname,temp);
		NextWord(temp);
	};
	if (!strcmp(temp,"range")) {
		NextWord(temp);
		if (!strcmp(temp,"[")) {out=0;NextWord(temp);}
		else {out=1;};
		while (1) {
		    x=(float) atof(temp);
		    l->AddRange(x);
		    if (out) break;
		    NextWord(temp);
		    if (!strcmp(temp,"]")) break;
		};
		NextWord(temp);
		continue;
	}
	else if (!strcmp(temp,"center")) {
		NextWord(temp);
		l->center.coord[0]=(double) atof(temp);
		NextWord(temp);
		l->center.coord[1]=(double) atof(temp);
		NextWord(temp);
		l->center.coord[2]=(double) atof(temp);
		NextWord(temp);
		continue;
	};
	// printf("Envoi a ReadGroupNodes:%s\n",temp);
	n=ReadGroupNodes(temp,newdefname);
	if (n!=NULL) {
		l->AddChild(n);
		ns.Set(newdefname,n);
	}
	else {
		KeywordNotFound(temp);
	};
	strcpy(newdefname,"NONE");
	NextWord(temp);
    }; // end while
    // puts("Hors du LOD");
    return (VRMLNode *) l;
}
//------------------
// ReadMaterialNode
//------------------
VRMLNode *VRMLParser::ReadMaterialNode(char *name) {
    char temp[255];
    Material *m;
    float r,g,b;
    int type=-1,out=0,max,i;

    #ifdef __GNUC__
    VList<Color4f> al=VList<Color4f>();
    VList<Color4f> dl=VList<Color4f>();
    VList<Color4f> sl=VList<Color4f>();
    VList<Color4f> el=VList<Color4f>();
    VList<float> shin=VList<float>();
    VList<float> tr=VList<float>();
    #else
    VList<Color4f> al();
    VList<Color4f> dl();
    VList<Color4f> sl();
    VList<Color4f> el();
    VList<float> shin();
    VList<float> tr();
    #endif
    // puts("=>In ReadMaterialNode");
    if (lp->pfd) {
	if (lp->msgtype==ALLMSG) {
	   fprintf(lp->pfd,"%d:Material found ",line);
	};
    };

    m=new Material (name);
    NextWord(temp);
    if (!strcmp(temp,"{}")) return (VRMLNode *) m;
    while (strcmp(temp,"}")) {
	// puts("In loop");
	if (!strcmp(temp,"diffuseColor")) {type=0;}
	else if (!strcmp(temp,"ambientColor")) {type=1;}
	else if (!strcmp(temp,"specularColor")) {type=2;}
	else if (!strcmp(temp,"emissiveColor")) {type=3;}
	else if (!strcmp(temp,"shininess")) {type=4;}
	else if (!strcmp(temp,"transparency")) {type=5;}
	else {type=-1;};
	if ((type==0)||(type==1)||(type==2)||(type==3)) {
	    // puts("keyword found");
	    // printf("KEYWORD=%s\n",temp);
	    NextWord(temp);
	    // printf("Word=%s\n",temp);
	    if (!strcmp(temp,"[")) {out=0;NextWord(temp);}
	    else {out=1;};
	    while (1) {
		r=(float) atof(temp);
		NextWord(temp);
		g=(float) atof(temp);
		NextWord(temp);
		b=(float) atof(temp);
		if (type==0) {dl.Add(Color4f(r,g,b,1.0));}
		else if (type==1) {al.Add(Color4f(r,g,b,1.0));}
		else if (type==2) {sl.Add(Color4f(r,g,b,1.0));}
		else if (type==3) {el.Add(Color4f(r,g,b,1.0));};
		if (out) break;
		NextWord(temp);
		if (!strcmp(temp,"]")) break;
	    }; // End while ]
	}
	else if ((type==4)||(type==5)) {
	    NextWord(temp);
	    if (!strcmp(temp,"[")) {out=0;NextWord(temp);}
	    else {out=1;};
	    while (1) {
		r=(float) atof(temp);
		if (type==4) {shin.Add(r);}
		else if (type==5) {tr.Add(r);};
		if (out) break;
		NextWord(temp);
		if (!strcmp(temp,"]")) break;
	    }; // End while ]
	}
	else {
		KeywordNotFound(temp);
	}; // end if specular,ambient,diffuse,emmisive,shiniess,transparency
	NextWord(temp);
    }; // end while }

    max=al.Length();
    if (dl.Length()>max) max=dl.Length();
    if (al.Length()>max) max=al.Length();
    if (sl.Length()>max) max=sl.Length();
    if (el.Length()>max) max=el.Length();
    if (shin.Length()>max) max=shin.Length();
    if (tr.Length()>max) max=tr.Length();

    int ddl=max-dl.Length();
    int dal=max-al.Length();
    int dsl=max-sl.Length();
    int del=max-el.Length();
    int dshin=max-shin.Length();
    int dtr=max-tr.Length();

    for (i=0;i<ddl;i++) {
	dl.Add(Color4f((float)0.8,(float) 0.8,(float)0.8,1.0));
    };
    for (i=0;i<dal;i++) {
	al.Add(Color4f((float)0.2,(float)0.2,(float)0.2,1.0));
    };
    for (i=0;i<dsl;i++) {
	sl.Add(Color4f((float)0.0,(float)0.0,(float)0.0,1.0));
    };
    for (i=0;i<del;i++) {
	el.Add(Color4f((float)0.0,(float)0.0,(float)0.0,1.0));
    };
    for (i=0;i<dshin;i++) {
	shin.Add(0.2);
    };
    for (i=0;i<dtr;i++) {
	tr.Add(0.0);
    };

    for (i=0;i<max;i++) {
	Mat *nm=new Mat(al.Get(i),dl.Get(i),sl.Get(i),el.Get(i),shin.Get(i),tr.Get(i));
	nm->SetTransparency();
	m->AddMaterial(nm);
    };
    if (lp->pfd) {
	if (lp->msgtype==ALLMSG) {
	   fprintf(lp->pfd," [%d materials]\n",m->Size());
	};
    };

    // puts("<=end of material parsing");
    state.m=m;
    return (VRMLNode *) m;
}
//-------------------------
// ReadMaterialBindingNode
//-------------------------
VRMLNode *VRMLParser::ReadMaterialBindingNode(char *name) {
    char temp[255];
    MaterialBinding *mb;

    // puts(">In ReadMaterialBindingNode");
    if (lp->pfd) {
	if (lp->msgtype==ALLMSG) {
	   fprintf(lp->pfd,"%d:MaterialBinding found\n",line);
	};
    };

    mb=new MaterialBinding (name);
    NextWord(temp);
    if (!strcmp(temp,"{}")) return (VRMLNode *) mb;
    while (strcmp(temp,"}")) {
	    if(!strcmp(temp,"value")) {
		NextWord(temp);
		if (!strcmp(temp,"OVERALL")) {mb->value=BINDING_OVERALL;}
		else if(!strcmp(temp,"DEFAULT")) {mb->value=BINDING_DEFAULT;}
		else if(!strcmp(temp,"PER_PART")) {mb->value=BINDING_PER_PART;}
		else if(!strcmp(temp,"PER_PART_INDEXED")) {mb->value=BINDING_PER_PART_INDEXED;}
		else if(!strcmp(temp,"PER_FACE")) {mb->value=BINDING_PER_FACE;}
		else if(!strcmp(temp,"PER_FACE_INDEXED")) {mb->value=BINDING_PER_FACE_INDEXED;}
		else if(!strcmp(temp,"PER_VERTEX")) {mb->value=BINDING_PER_VERTEX;}
		else if(!strcmp(temp,"PER_VERTEX_INDEXED")) {mb->value=BINDING_PER_VERTEX_INDEXED;}
		else {KeywordNotFound(temp);};
	    };
	    NextWord(temp);
    }; // end while }
    // puts("end of materialbinding");
    state.mb=mb;
    return (VRMLNode *) mb;
}
//---------------------
// ReadMatrixTransform
//---------------------
VRMLNode *VRMLParser::ReadMatrixTransformNode(char *name) {
   char temp[255];
   float m[16];
   int i=0;
   MatrixTransform *mt;

   // puts("In ReadMatrixTransform");
   if (lp->pfd) {
	if (lp->msgtype==ALLMSG) {
	   fprintf(lp->pfd,"%d:MatrixTransform found\n",line);
	};
   };

   mt=new MatrixTransform(name);
   NextWord(temp);
   if (!strcmp(temp,"{}")) return (VRMLNode *) mt;
   while (strcmp(temp,"}")) {
	if (!strcmp(temp,"matrix")) {
		// puts("matrix found");
		for (i=0;i<16;i++) {
			NextWord(temp);
			m[i]=(double) atof(temp);
			// printf("found %d:%f\n",i,m[i]);
		};
		mt->SetMatrixv(m);
	}
	else {
		KeywordNotFound(temp);
	};
	NextWord(temp);
   };
   return (VRMLNode *) mt;
}
//-------------------
// ReadNormalNode
//-------------------
VRMLNode *VRMLParser::ReadNormalNode(char *name) {
   char temp[255];
   float x,y,z;
   int out;
   Normal *n;

   if (lp->pfd) {
	if (lp->msgtype==ALLMSG) {
	   fprintf(lp->pfd,"%d:Normal found ",line);
	};
   };

   n=new Normal(name);
   NextWord(temp);
   if (!strcmp(temp,"{}")) return (VRMLNode *) n;
   while (strcmp(temp,"}")) {
	if (!strcmp(temp,"vector")) {
		NextWord(temp);
		if (!strcmp(temp,"[")) {out=0;NextWord(temp);}
		else {out=1;};
		while (1) {
			x=(double) atof(temp);
			NextWord(temp);
			y=(double) atof(temp);
			NextWord(temp);
			z=(double) atof(temp);
			n->AddVector(new Vertex3d(x,y,z));
			if (out) break;
			NextWord(temp);
			if (!strcmp(temp,"]")) break;
		};
	 }
	 else {
		KeywordNotFound(temp);
	 };
	 NextWord(temp);
   };
   state.n=n;
   if (lp->pfd) {
	if (lp->msgtype==ALLMSG) {
	   fprintf(lp->pfd,"[%d normals]\n",n->Size());
	};
   };
   return (VRMLNode *) n;
}
//-----------------------
// ReadNormalBindingNode
//-----------------------
VRMLNode *VRMLParser::ReadNormalBindingNode(char *name) {
   char temp[255];
   NormalBinding *nb;

   if (lp->pfd) {
	if (lp->msgtype==ALLMSG) {
	   fprintf(lp->pfd,"%d:NormalBinding found\n",line);
	};
   };
   nb=new NormalBinding (name);
   NextWord(temp);
   if (!strcmp(temp,"{}")) return (VRMLNode *) nb;
   while (strcmp(temp,"}")) {
	    if(!strcmp(temp,"value")) {
		NextWord(temp);
		if (!strcmp(temp,"OVERALL")) {nb->value=BINDING_OVERALL;}
		else if(!strcmp(temp,"DEFAULT")) {nb->value=BINDING_DEFAULT;}
		else if(!strcmp(temp,"PER_PART")) {nb->value=BINDING_PER_PART;}
		else if(!strcmp(temp,"PER_PART_INDEXED")) {nb->value=BINDING_PER_PART_INDEXED;}
		else if(!strcmp(temp,"PER_FACE")) {nb->value=BINDING_PER_FACE;}
		else if(!strcmp(temp,"PER_FACE_INDEXED")) {nb->value=BINDING_PER_FACE_INDEXED;}
		else if(!strcmp(temp,"PER_VERTEX")) {nb->value=BINDING_PER_VERTEX;}
		else if(!strcmp(temp,"PER_VERTEX_INDEXED")) {nb->value=BINDING_PER_VERTEX_INDEXED;}
		else {KeywordNotFound(temp);};
	    };
	    NextWord(temp);
    }; // end while }
    state.nb=nb;
    return (VRMLNode *) nb;
}
//------------------------
// OrthographicCameraNode
//------------------------
VRMLNode *VRMLParser::ReadOrthographicCameraNode(char *name) {
   char temp[255];
   OrthographicCamera *o;

   if (lp->pfd) {
	if (lp->msgtype==ALLMSG) {
	   fprintf(lp->pfd,"%d:OrthographicCamera found\n",line);
	};
   };

   o=new OrthographicCamera(name);
   NextWord(temp);
   if (!strcmp(temp,"{}")) return (VRMLNode *) o;
   while (strcmp(temp,"}")) {
	if (!strcmp(temp,"position")) {
		NextWord(temp);
		o->position.coord[0]=(double) atof(temp);
		NextWord(temp);
		o->position.coord[1]=(double) atof(temp);
		NextWord(temp);
		o->position.coord[2]=(double) atof(temp);
	}
	else if (!strcmp(temp,"orientation")) {
		NextWord(temp);
		o->orientation.coord[0]=(double) atof(temp);
		NextWord(temp);
		o->orientation.coord[1]=(double) atof(temp);
		NextWord(temp);
		o->orientation.coord[2]=(double) atof(temp);
		NextWord(temp);
		o->orientation.coord[3]=(double) atof(temp);
	}
	else if (!strcmp(temp,"focalDistance")) {
		NextWord(temp);
		o->focalDistance=(float) atof(temp);
	}
	else if (!strcmp(temp,"height")) {
		NextWord(temp);
		o->height=(float) atof(temp);
	}
	else {
		KeywordNotFound(temp);
	};
	NextWord(temp);
   };
   return (VRMLNode *) o;
}
//------------------------
// PerspectiveCameraNode
//------------------------
VRMLNode *VRMLParser::ReadPerspectiveCameraNode(char *name) {
   char temp[255];
   PerspectiveCamera *p;

   if (lp->pfd) {
	if (lp->msgtype==ALLMSG) {
	   fprintf(lp->pfd,"%d:PerspectiveCamera found\n",line);
	};
   };

   p=new PerspectiveCamera(name);
   NextWord(temp);
   if (!strcmp(temp,"{}")) return (VRMLNode *) p;
   while (strcmp(temp,"}")) {
	if (!strcmp(temp,"position")) {
		NextWord(temp);
		p->position.coord[0]=(double) atof(temp);
		NextWord(temp);
		p->position.coord[1]=(double) atof(temp);
		NextWord(temp);
		p->position.coord[2]=(double) atof(temp);
	}
	else if (!strcmp(temp,"orientation")) {
		NextWord(temp);
		p->orientation.coord[0]=(double) atof(temp);
		NextWord(temp);
		p->orientation.coord[1]=(double) atof(temp);
		NextWord(temp);
		p->orientation.coord[2]=(double) atof(temp);
		NextWord(temp);
		p->orientation.coord[3]=(double) atof(temp);
	}
	else if (!strcmp(temp,"focalDistance")) {
		NextWord(temp);
		p->focalDistance=(float) atof(temp);
	}
	else if (!strcmp(temp,"heightAngle")) {
		NextWord(temp);
		p->height=(float) atof(temp);
	}
	else {
		KeywordNotFound(temp);
	};
	NextWord(temp);
   };
   return (VRMLNode *) p;
}
//--------------------------
// ReadPointLightNode
//--------------------------
VRMLNode *VRMLParser::ReadPointLightNode(char *name) {
    char temp[255];
    PointLight *pl;

    // puts(">In ReadPointLightNode");
    if (lp->pfd) {
	if (lp->msgtype==ALLMSG) {
	   fprintf(lp->pfd,"%d:PointLight found\n",line);
	};
    };

    pl=new PointLight(name);
    NextWord(temp);
    if (!strcmp(temp,"{}")) return (VRMLNode *) pl;
    while (strcmp(temp,"}")) {
	if (!strcmp(temp,"location")) {
	    NextWord(temp);
	    pl->point.coord[0]=(double) atof(temp);
	    NextWord(temp);
	    pl->point.coord[1]=(double) atof(temp);
	    NextWord(temp);
	    pl->point.coord[2]=(double) atof(temp);
	}
	else if(!strcmp(temp,"on")) {
	    NextWord(temp);
	    if (!strcmp(temp,"TRUE")) {
		pl->on=1;
	    }
	    else {
		pl->on=0;
	    };
	}
	else if(!strcmp(temp,"intensity")) {
	    NextWord(temp);
	    pl->intensity=(float) atof(temp);
	}
	else if(!strcmp(temp,"color")) {
	    NextWord(temp);
	    pl->color.rgb[0]=(float) atof(temp);
	    NextWord(temp);
	    pl->color.rgb[1]=(float) atof(temp);
	    NextWord(temp);
	    pl->color.rgb[2]=(float) atof(temp);
	}
	else {
		KeywordNotFound(temp);
	}; // end if
	NextWord(temp);
    }; // end while }
    return (VRMLNode *) pl;
}
//-------------------
// ReadPointSetNode
//-------------------
VRMLNode *VRMLParser::ReadPointSetNode(char *name) {
    char temp[255];
    int num;
    PointSet *ps;

    if (lp->pfd) {
	if (lp->msgtype==ALLMSG) {
	   fprintf(lp->pfd,"%d:PointSet found\n",line);
	};
    };
    ps=new PointSet(name);
    NextWord(temp);
    if (!strcmp(temp,"{}")) return (VRMLNode *) ps;
    while (strcmp(temp,"}")) {
	if (!strcmp(temp,"startIndex")) {
		NextWord(temp);
		num=atoi(temp);
		ps->startIndex=num;
	}
	else if (!strcmp(temp,"numPoints")) {
		NextWord(temp);
		num=atoi(temp);
		ps->numPoints=num;
	}
	else {
		KeywordNotFound(temp);
	};
	NextWord(temp);
    };
    return (VRMLNode *) ps;
}
//------------------
// ReadRotationNode
//------------------
VRMLNode *VRMLParser::ReadRotationNode (char *name) {
    char temp[255];
    Rotation *r;
    float x,y,z,angle;

    // puts(">In ReadRotationNode");
    if (lp->pfd) {
	if (lp->msgtype==ALLMSG) {
	   fprintf(lp->pfd,"%d:Rotation found\n",line);
	};
    };

    r=new Rotation(name);
    NextWord(temp);
    if (!strcmp(temp,"{}")) return (VRMLNode *) r;
    while (strcmp(temp,"}")) {
	if (!strcmp(temp,"rotation")) {
	    NextWord(temp);
	    x=(double) atof(temp);
	    NextWord(temp);
	    y=(double) atof(temp);
	    NextWord(temp);
	    z=(double) atof(temp);
	    NextWord(temp);
	    angle=(double) atof(temp);
	    r->rotation.Set(x,y,z,angle);
	}
	else {
		KeywordNotFound(temp);
	}; // end if
	NextWord(temp);
    }; // end while }
    return (VRMLNode *) r;
}
//---------------
// ReadScaleNode
//---------------
VRMLNode *VRMLParser::ReadScaleNode (char *name) {
    char temp[255];
    Scale *s;
    float x,y,z;

    // puts(">In ReadScaleNode");
    if (lp->pfd) {
	if (lp->msgtype==ALLMSG) {
	   fprintf(lp->pfd,"%d:Scale found\n",line);
	};
    };

    s=new Scale(name);
    NextWord(temp);
    if (!strcmp(temp,"{}")) return (VRMLNode *) s;
    while (strcmp(temp,"}")) {
	if (!strcmp(temp,"scaleFactor")) {
	    NextWord(temp);
	    x=(double) atof(temp);
	    NextWord(temp);
	    y=(double) atof(temp);
	    NextWord(temp);
	    z=(double) atof(temp);
	    s->scaleFactor.Set(x,y,z);
	}
	else {
		KeywordNotFound(temp);
	}; // end if
	NextWord(temp);
    }; // end while }
    return (VRMLNode *) s;
}
//-------------------
// ReadSeparatorNode
//-------------------
VRMLNode *VRMLParser::ReadSeparatorNode(char *name) {
    char temp[255],newdefname[25];
    VRMLState st=VRMLState();
    VRMLNode *n;
    Separator *s;

    // puts(">In ReadSeparatorNode");
    st=state;
    if (lp->pfd) {
	if (lp->msgtype==ALLMSG) {
		fprintf(lp->pfd,"%d:Separator found\n",line);
	};
    };
    strcpy(temp,"");strcpy(newdefname,"NONE");
    s=new Separator(name); 
    NextWord(temp);
    if (!strcmp(temp,"{}")) return s;
    while ((strcmp(temp,"}"))&&
	   (Pos<Size)) {
	// NextWord(temp);
	if (!strcmp(temp,"DEF")) {
		NextWord(temp);
		strcpy(newdefname,temp);
		NextWord(temp);
	};
	if (!strcmp(temp,"renderCulling")) {
		// printf("RenderCulling found");
		NextWord(temp);
		if (!strcmp(temp,"AUTO")) {s->renderCulling=CULLING_AUTO;}
		else if (!strcmp(temp,"ON")) {s->renderCulling=CULLING_ON;}
		else if (!strcmp(temp,"OFF")) {s->renderCulling=CULLING_OFF;}
		else {KeywordNotFound(temp);};
		NextWord(temp);
		continue;
	};
	// printf("Envoi a ReadGroupNodes:%s\n",temp);
	n=ReadGroupNodes(temp,newdefname);
	// puts("Sorti de ReadGroupNodes");
	
	if (n!=NULL) {
	    s->AddChild(n);
	    ns.Set(newdefname,n);
	}
	else {
	   if (lp->pfd) {
	     fprintf(lp->pfd,"ERROR line:%d->Cannot parse %s\n",line,temp);
	   };
	};
	// puts("Child added"),
	strcpy(newdefname,"NONE");
	NextWord(temp);
    }; // end while
    // puts("Hors du Separator");
    state=st;
    return (VRMLNode *) s;
}
//--------------------
// ReadShapeHintsNode
//--------------------
VRMLNode *VRMLParser::ReadShapeHintsNode(char *name) {
   char temp[50];
   float val;
   ShapeType st;
   FaceType ft;
   VertexOrder vo;
   ShapeHints *sh;

   // puts("In ReadShapeHints");
   if (lp->pfd) {
	if (lp->msgtype==ALLMSG) {
	   fprintf(lp->pfd,"%d:ShapeHints found\n",line);
	};
   };

   sh=new ShapeHints(name);
   NextWord(temp);
   // printf("temp:%s\n",temp);
   if (!strcmp(temp,"{}")) return (VRMLNode *) sh;
   while (strcmp(temp,"}")) {
	if (!strcmp(temp,"vertexOrdering")) {
		// puts("vertexOrdering found");
		NextWord(temp);
		if (!strcmp(temp,"UNKNOWN_ORDERING")) {
			sh->vertexOrdering=UNKNOWN_ORDERING;
		}
		else if (!strcmp(temp,"CLOCKWISE")) {
			sh->vertexOrdering=CLOCKWISE;
		}
		else if (!strcmp(temp,"COUNTERCLOCKWISE")) {
			sh->vertexOrdering=COUNTERCLOCKWISE;
		}
		else {KeywordNotFound(temp);};
		// else {continue;};
	}
	else if (!strcmp(temp,"shapeType")) {
		NextWord(temp);
		if (!strcmp(temp,"UNKNOWN_SHAPE_TYPE")) {
			sh->shapeType=UNKNOWN_SHAPE_TYPE;
		}
		else if (!strcmp(temp,"SOLID")) {
			sh->shapeType=SOLID;
		}
		else {KeywordNotFound(temp);};
		//else {continue;};
	}
	else if (!strcmp(temp,"faceType")) {
		NextWord(temp);
		if (!strcmp(temp,"UNKNOWN_FACE_TYPE")) {
			sh->faceType=UNKNOWN_FACE_TYPE;
		}
		else if (!strcmp(temp,"CONVEX")) {
			sh->faceType=CONVEX;
		}
		else {KeywordNotFound(temp);};
		//else {continue;};
	}
	else if (!strcmp(temp,"creaseAngle")) {
		NextWord(temp);
		val=(float) atof(temp);
		sh->creaseAngle=val;
	}
	else {KeywordNotFound(temp);};
	NextWord(temp);
   };
   // puts("Out ReadShapeHints");
   return (VRMLNode *) sh;
}
//----------------
// ReadSphereNode
//----------------
VRMLNode *VRMLParser::ReadSphereNode(char *name) {
    char temp[255];
    Sphere *sp;
		 
    // puts(">In ReadSphereNode");
    if (lp->pfd) {
	if (lp->msgtype==ALLMSG) {
	   fprintf(lp->pfd,"%d:Sphere found\n",line);
	};
    };

    sp=new Sphere(name);
    NextWord(temp);
    while ((strcmp(temp,"}"))&&
	   (strcmp(temp,"{}"))) {
	if (!strcmp(temp,"radius")) {
	    NextWord(temp);
	    sp->radius=(double) atof(temp);
	}
	else {KeywordNotFound(temp);};
	NextWord(temp);
    } // end while
    return (VRMLNode *) sp;
}
//--------------------------
// ReadSpotLightNode
//--------------------------
VRMLNode *VRMLParser::ReadSpotLightNode(char *name) {
    char temp[255];
    SpotLight *sl;

    // puts(">In ReadSpotLightNode");
    if (lp->pfd) {
	if (lp->msgtype==ALLMSG) {
	   fprintf(lp->pfd,"%d:SpotLight found\n",line);
	};
    };

    sl=new SpotLight(name);
    NextWord(temp);
    if (!strcmp(temp,"{}")) return (VRMLNode *) sl;
    while (strcmp(temp,"}")) {
	if (!strcmp(temp,"location")) {
	    NextWord(temp);
	    sl->point.coord[0]=(double) atof(temp);
	    NextWord(temp);
	    sl->point.coord[1]=(double) atof(temp);
	    NextWord(temp);
	    sl->point.coord[2]=(double) atof(temp);
	}
	else if (!strcmp(temp,"direction")) {
	    NextWord(temp);
	    sl->direction.coord[0]=(double) atof(temp);
	    NextWord(temp);
	    sl->direction.coord[1]=(double) atof(temp);
	    NextWord(temp);
	    sl->direction.coord[2]=(double) atof(temp);
	}
	else if(!strcmp(temp,"on")) {
	    NextWord(temp);
	    if (!strcmp(temp,"TRUE")) {
		sl->on=1;
	    }
	    else {
		sl->on=0;
	    };
	}
	else if(!strcmp(temp,"intensity")) {
	    NextWord(temp);
	    sl->intensity=(float) atof(temp);
	}
	else if(!strcmp(temp,"color")) {
	    NextWord(temp);
	    sl->color.rgb[0]=(float) atof(temp);
	    NextWord(temp);
	    sl->color.rgb[1]=(float) atof(temp);
	    NextWord(temp);
	    sl->color.rgb[2]=(float) atof(temp);
	}
	else if(!strcmp(temp,"dropOffRate")) {
	    NextWord(temp);
	    sl->dropOffRate=(float) atof(temp);
	}
	else if(!strcmp(temp,"cutOffAngle")) {
	    NextWord(temp);
	    sl->cutOffAngle=(float) atof(temp);
	}
	else {KeywordNotFound(temp);}; // end if
	NextWord(temp);
    }; // end while }
    return (VRMLNode *) sl;
}
//------------------
// ReadSwitchNode
//-----------------
VRMLNode *VRMLParser::ReadSwitchNode(char *name) {
    char temp[255],newdefname[25];
    VRMLNode *n;
    Switch *s;

    // puts(">In ReadSeparatorNode");
    if (lp->pfd) {
	if (lp->msgtype==ALLMSG) {
	   fprintf(lp->pfd,"%d:Switch found\n",line);
	};
    };
    strcpy(temp,"");strcpy(newdefname,"NONE");
    s=new Switch(name); 
    NextWord(temp);
    if (!strcmp(temp,"{}")) return s;
    while ((strcmp(temp,"}"))&&
	   (Pos<Size)) {
	// NextWord(temp);
	if (!strcmp(temp,"DEF")) {
		NextWord(temp);
		strcpy(newdefname,temp);
		NextWord(temp);
	};
	if (!strcmp(temp,"whichChild")) {
		// printf("whichChild found");
		NextWord(temp);
		s->whichChild=atoi(temp);
		NextWord(temp);
		continue;
	};
	// printf("Envoi a ReadGroupNodes:%s\n",temp);
	n=ReadGroupNodes(temp,newdefname);
	
	if (n!=NULL) {
	    s->AddChild(n);
	    ns.Set(newdefname,n);
	}
	else {
	    if (lp->pfd) {
	       fprintf(lp->pfd,"ERROR line:%d->Cannot parse %s\n",line,temp);
	    };
	};
	strcpy(newdefname,"NONE");
	NextWord(temp);
    }; // end while
    // puts("Hors du Switch");
    return (VRMLNode *) s;
}
//-------------------
// ReadTexture2Node
//-------------------
VRMLNode *VRMLParser::ReadTexture2Node(char *name) {
  char temp[255],temp2[255];
  UBYTE *cimage=NULL;
  int i=0,j=0,value=0,mask=0,cpt=0;
  Texture2 *t=NULL;

  if (lp->pfd) {
	if (lp->msgtype==ALLMSG) {
	   fprintf(lp->pfd,"%d:Texture2 found\n",line);
	};
  };

  t=new Texture2(name);
  NextWord(temp);
  if (!strcmp(temp,"{}")) return (VRMLNode *) t;
  while (strcmp(temp,"}")) {
	if (!strcmp(temp,"filename")) {
		NextWord(temp);
		strcpy(temp2,dir);
		AddPart(temp2,temp,255);
		t->SetFileName(temp2);
		// printf("filename found:%s\n",t->GetFileName());
		if (strcmp(temp,"")) {
		    if (lp->pfd) {
			if (lp->msgtype==ALLMSG) {
			    fprintf(lp->pfd,"Loading image:%s via datatypes\n",t->GetFileName());
			};
		    };
		    if (t->LoadImage()==1) {
			if (lp->pfd) {
			    if (lp->msgtype==ALLMSG) {
				fprintf(lp->pfd,"Success !\n");
			    };
			};
		    }
		    else {
			if (lp->pfd) {
			    fprintf(lp->pfd,"ERROR reading texture file (not an image or file not found)\n");
			};
		    };
		};
		t->SetFileName(temp);
	}
	else if (!strcmp(temp,"image")) {
		NextWord(temp);
		t->width=atoi(temp);
		NextWord(temp);
		t->height=atoi(temp);
		NextWord(temp);
		t->component=atoi(temp);
		if (lp->pfd) {
		    if (lp->msgtype==ALLMSG) {
			fprintf(lp->pfd,"inline image found width:%d height:%d component:%d !\n",t->width,t->height,t->component);
		    };
		};
		if (t->width!=0) {
		    if (t->image) free(t->image);
		    t->image=(UBYTE *) malloc(t->width*t->height*t->component);
		    cimage=t->image;
		    for (i=0;i<t->width*t->height;i++) {
			NextWord(temp);
			sscanf(temp,"%i",&value);
			// value=(int) atoi("0xff");
			// printf("cimage:%d %s\n",value,temp);
			mask=(0xff<<((t->component-1)*8));
			for (j=t->component;j>0;j--) {
			    *(cimage)= (value & mask)>>((j-1)*8);
			    mask=(mask>>8);
			    cimage++;
			};
			// printf("image:%d\n",atoi(temp)),
			// t->image[i]=atoi(temp);
			// printf("image:%d\n",t->image[i]);
			if (cpt>100) {
			    if (GA_Msg) {
				SetAttrs((Object *) GA_Msg, MUIA_Gauge_Current, Pos);
			    };
			    cpt=0;
			};
			cpt++;
		    };
		};
	}
	else if (!strcmp(temp,"wrapS")) {
		NextWord(temp);
		if (!strcmp(temp,"REPEAT")) {t->wrapS=TEXTURE2_WRAP_REPEAT;}
		else if (!strcmp(temp,"CLAMP")) {t->wrapS=TEXTURE2_WRAP_CLAMP;};
	}
	else if (!strcmp(temp,"wrapT")) {
		NextWord(temp);
		if (!strcmp(temp,"REPEAT")) {t->wrapT=TEXTURE2_WRAP_REPEAT;}
		else if (!strcmp(temp,"CLAMP")) {t->wrapT=TEXTURE2_WRAP_CLAMP;};
	}
	else {KeywordNotFound(temp);};
	NextWord(temp);
  };
  return (VRMLNode *) t;
}
//-----------------------------
// ReadTexture2TransformNode
//-----------------------------
VRMLNode *VRMLParser::ReadTexture2TransformNode(char *name) {
  char temp[255];
  Texture2Transform *t;

  if (lp->pfd) {
	if (lp->msgtype==ALLMSG) {
	   fprintf(lp->pfd,"%d:Texture2Transform found\n",line);
	};
  };

  t=new Texture2Transform(name);
  NextWord(temp);
  if (!strcmp(temp,"{}")) return (VRMLNode *) t;
  while (strcmp(temp,"}")) {
	if (!strcmp(temp,"translation")) {
		NextWord(temp);
		t->translation.coord[0]=(double) atof(temp);
		NextWord(temp);
		t->translation.coord[1]=(double) atof(temp);
	}
	else if (!strcmp(temp,"rotation")) {
		NextWord(temp);
		t->rotation=(double) atof(temp);
	}
	else if (!strcmp(temp,"scaleFactor")) {
		NextWord(temp);
		t->scaleFactor.coord[0]=(double) atof(temp);
		NextWord(temp);
		t->scaleFactor.coord[1]=(double) atof(temp);
	}                                       
	else if (!strcmp(temp,"center")) {
		NextWord(temp);
		t->center.coord[0]=(double) atof(temp);
		NextWord(temp);
		t->center.coord[1]=(double) atof(temp);
	}
	else {KeywordNotFound(temp);};
	NextWord(temp);
  };
  return (VRMLNode *) t;
}
//-----------------------------
// ReadTextureCoordinate2Node
//------------------------------
VRMLNode *VRMLParser::ReadTextureCoordinate2Node(char *name) {
  char temp[255];
  int out;
  float x,y;
  TextureCoordinate2 *tc;

  if (lp->pfd) {
	if (lp->msgtype==ALLMSG) {
	   fprintf(lp->pfd,"%d:TextureCoordinate2 found ",line);
	};
  };

  tc=new TextureCoordinate2(name);
  NextWord(temp);
  if (!strcmp(temp,"{}")) return (VRMLNode *) tc;
  while (strcmp(temp,"}")) {
	if (!strcmp(temp,"point")) {
	    NextWord(temp);
	    if (!strcmp(temp,"[")) {out=0;NextWord(temp);}
	    else {out=1;};
	    while (1) {
		x=(double) atof(temp);
		NextWord(temp);
		y=(double) atof(temp);
		tc->AddPoint(new Vertex2d(x,y));
		if (out) break;
		NextWord(temp);
		if (!strcmp(temp,"]")) break;
	    };
	}
	else {KeywordNotFound(temp);};
	NextWord(temp);
  };
  if (lp->pfd) {
	if (lp->msgtype==ALLMSG) {
	   fprintf(lp->pfd,"[%d points]\n",tc->Size());
	};
  };
  state.tc2=tc;
  return (VRMLNode *) tc;
}
//-------------------
// ReadTransformNode
//-------------------
VRMLNode *VRMLParser::ReadTransformNode (char *name) {
    char temp[255];
    Transform *t;
    float x,y,z,angle;
    int type=-1;

    // puts(">In ReadTransformNode");
    if (lp->pfd) {
	if (lp->msgtype==ALLMSG) {
		fprintf(lp->pfd,"%d:Transform found\n",line);
	};
    };

    t=new Transform(name);
    NextWord(temp);
    if (!strcmp(temp,"{}")) return (VRMLNode *) t;
    while (strcmp(temp,"}")) {
	if (!strcmp(temp,"translation")) {type=0;}
	else if (!strcmp(temp,"scaleFactor")) {type=1;}
	else if (!strcmp(temp,"scaleOrientation")) {type=2;}
	else if (!strcmp(temp,"rotation")) {type=3;}
	else if (!strcmp(temp,"center")) {type=4;}
	else {KeywordNotFound(temp);type=-1;};

	if (type!=-1) {
		// printf("Word=%s\n",temp);
		NextWord(temp);
		x=(double) atof(temp);
		NextWord(temp);
		y=(double) atof(temp);
		NextWord(temp);
		z=(double) atof(temp);
		if ((type==2)||
		    (type==3)) {
			NextWord(temp);
			angle=(double) atof(temp);
		};
		if (type==0) {t->translation.Set(x,y,z);}
		else if (type==1) {t->scaleFactor.Set(x,y,z);}
		else if (type==2) {t->scaleOrientation.Set(x,y,z,angle);}
		else if (type==3) {t->rotation.Set(x,y,z,angle);}
		else if (type==4) {t->center.Set(x,y,z);};
	} // end if type!=-1
	NextWord(temp);
    }; // end while }
    return (VRMLNode *) t;
}
//---------------------------
// ReadTransformSeparatorNode
//----------------------------
VRMLNode *VRMLParser::ReadTransformSeparatorNode(char *name) {
    char temp[255],newdefname[25];
    VRMLNode *n;
    TransformSeparator *ts;

    // puts(">In ReadTransformSeparatorNode");
    if (lp->pfd) {
	if (lp->msgtype==ALLMSG) {
		fprintf(lp->pfd,"%d:TransformSeparator found\n",line);
	};
    };

    strcpy(temp,""); strcpy(newdefname,"NONE");
    ts=new TransformSeparator(name); // Construction of Group
    NextWord(temp); // Read the first word after the Group keyword
    while ((strcmp(temp,"}"))&&
	   (Pos<Size)) {
	// NextWord(temp);
	if (!strcmp(temp,"DEF")) {
		NextWord(temp);
		strcpy(newdefname,temp);
		NextWord(temp);
	};
	// printf("Envoi a ReadGroupNodes:%s\n",temp);
	n=ReadGroupNodes(temp,newdefname);
	
	if (n!=NULL) {
	    ts->AddChild(n);
	    ns.Set(newdefname,n);
	}
	else {
	   if (lp->pfd) {
	     fprintf(lp->pfd,"ERROR line:%d->Cannot parse %s\n",line,temp);
	   };
	};
	strcpy(newdefname,"NONE");
	NextWord(temp);
    }; // end while
    // puts("Hors du group");
    return (VRMLNode *) ts;
}
//-------------------
// ReadTranslationNode
//-------------------
VRMLNode *VRMLParser::ReadTranslationNode (char *name) {
    char temp[255];
    Translation *t;
		
    // puts(">In ReadTranslationNode");
    if (lp->pfd) {
	if (lp->msgtype==ALLMSG) {
	   fprintf(lp->pfd,"%d:Translation found\n",line);
	};
    };

    t=new Translation(name);
    NextWord(temp);
    if (!strcmp(temp,"{}")) return (VRMLNode *) t;
    while (strcmp(temp,"}")) {
	if (!strcmp(temp,"translation")) {
	    // puts("translation found");
	    NextWord(temp);
	    t->translation.coord[0]=(double) atof(temp);
	    NextWord(temp);
	    t->translation.coord[1]=(double) atof(temp);
	    NextWord(temp);
	    t->translation.coord[2]=(double) atof(temp);
	}
	else {KeywordNotFound(temp);}; // end if
	NextWord(temp);
	// printf("After the translation:%s\n",temp);
    }; // end while }
    // puts("Out of ReadTranslationNode");
    return (VRMLNode *) t;
}
//---------------------
// ReadWWWAnchorNode
//---------------------
VRMLNode *VRMLParser::ReadWWWAnchorNode(char *name) {
    char temp[255],newdefname[25];
    VRMLNode *n=NULL;
    WWWAnchor *wa=NULL;

    // puts(">In ReadWWWAnchorNode");
    if (lp->pfd) {
	if (lp->msgtype==ALLMSG) {
		fprintf(lp->pfd,"%d:WWWAnchor found\n",line);
	};
    };
    strcpy(temp,""); strcpy(newdefname,"NONE");
    wa=new WWWAnchor(name);
    NextWord(temp); // Read the first word after the Separator keyword
    if (!strcmp(temp,"{}")) return (VRMLNode *) wa;
    while ((strcmp(temp,"}"))&&
	   (Pos<Size)) {
	if (!strcmp(temp,"DEF")) {
		NextWord(temp);
		strcpy(newdefname,temp);
		NextWord(temp);
	};
	if (!strcmp(temp,"name")) {
		NextWord(temp);
		wa->SetURL(temp);
		NextWord(temp);
		continue;
	}
	else if (!strcmp(temp,"description")) {
		NextWord(temp);
		wa->SetDescription(temp);
		NextWord(temp);
		continue;
	}
	else if (!strcmp(temp,"map")) {
		NextWord(temp);
		if (!strcmp(temp,"NONE")) {
			wa->map=MAP_NONE;
		}
		else if (!strcmp(temp,"POINT")) {
			wa->map=MAP_POINT;
		}
		else {KeywordNotFound(temp);};
		NextWord(temp);
		continue;
	};
	// printf("Envoi a ReadGroupNodes:%s\n",temp);
	n=ReadGroupNodes(temp,newdefname);
	
	if (n!=NULL) {
	    wa->AddChild(n);
	    ns.Set(newdefname,n);
	}
	else {
	   if (lp->pfd) {
	      fprintf(lp->pfd,"ERROR line:%d->Cannot parse %s\n",line,temp);
	   };
	};
	strcpy(newdefname,"NONE");
	NextWord(temp);
    }; // end while
    return (VRMLNode *) wa;
}
//-------------------
// ReadWWWInlineNode
//-------------------
VRMLNode *VRMLParser::ReadWWWInlineNode(char *name) {
  char temp[255];
  float x,y,z;
  WWWInline *wi;
  FILE *fd;

  if (lp->pfd) {
	if (lp->msgtype==ALLMSG) {
	   fprintf(lp->pfd,"%d:WWWInline found\n",line);
	};
  };

  wi=new WWWInline(name);
  NextWord(temp);
  if (!strcmp(temp,"{}")) return (VRMLNode *) wi;
  while (strcmp(temp,"}")) {
	if (!strcmp(temp,"name")) {
		// puts("name found");
		NextWord(temp);
		// printf("found:%s\n",temp);
		wi->SetURL(temp);
		// printf("found:%s\n",wi->GetURL());
	}
	else if (!strcmp(temp,"bboxSize")) {
		NextWord(temp);
		x=(double) atof(temp);
		NextWord(temp);
		y=(double) atof(temp);
		NextWord(temp);
		z=(double) atof(temp);
		wi->bboxSize.Set(x,y,z);
	}
	else if (!strcmp(temp,"bboxCenter")) {
		NextWord(temp);
		x=(double) atof(temp);
		NextWord(temp);
		y=(double) atof(temp);
		NextWord(temp);
		z=(double) atof(temp);
		wi->bboxCenter.Set(x,y,z);
	}
	else {KeywordNotFound(temp);};
	NextWord(temp);
  };

  // puts("Hors du ReadWWWINlineNode");
  if (lp->resolve) {
	VRMLParser inl=VRMLParser(lp);
	if (lp->pfd) {
	    if (lp->msgtype==ALLMSG) {
	       fprintf(lp->pfd,"Resolving inline->%s\n",wi->GetURL());
	    };
	};
	// GetCurrentDirName(temp,255);
	// AddPart(temp,wi->GetURL(),255);
	// printf("dir:%s\n",dir);
	// printf("file:%s\n",wi->GetURL());
	strcpy(temp,dir);
	AddPart(temp,wi->GetURL(),255);
	// printf("INLINE:%s\n",temp);
	fd=fopen(temp,"r");
	if (fd) {
	    wi->in=inl.LoadVRML_V1(temp);
	    if (lp->pfd) {
		if (wi->in==NULL) {
		  fprintf(lp->pfd,"ERROR Somthing wrong when parsing inline file\n");
		}
		else {
		   if (lp->msgtype==ALLMSG) {
		     fprintf(lp->pfd,"Inline resolved with success\n"
			     "Back to parent world\n");
		   };
		};
	    };
	}
	else {
	    if (lp->pfd) {
		fprintf(lp->pfd,"ERROR Cannot find inline file\n");
	    };
	};
	// delete inl;
  };
  return (VRMLNode *) wi;
}

//-----
// USE
//-----
VRMLNode *VRMLParser::ReadUSENode(char *name) {
   char temp[255];
   VRMLNode *n;
   USE *u;

   // puts(">In ReadUSENode");
   if (lp->pfd) {
	if (lp->msgtype==ALLMSG) {
	   fprintf(lp->pfd,"%d:USE keyword found\n",line);
	};
   };

   u=new USE("NONE");
   // puts("Before SetuseNode");
   NextWord(temp);
   // printf("USE node:%s\n",temp);
   // ns.Print();
   n=ns.Get(temp);

   if (n!=NULL) {
       n->ref++;
       u->reference=n;
   }
   else {
	 // puts("usename not found");
	 return NULL;
   };
   // u->SetUsedName(temp);
   return (VRMLNode *) u;
}
