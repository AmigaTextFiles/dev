/*----------------------------------------------------
  VRML2Saver.cc
  Version 0.1
  Date: 16 june 1998
  Author: BODMER Stephan (bodmer2@uni2a.unige.ch)
  Note: All VRML V1.0 (ascii) output
-----------------------------------------------------*/
#include <libraries/mui.h>

#include <proto/muimaster.h>
#include <proto/intuition.h>
#include <proto/alib.h>

#include "VRML2Saver.h"

VRML2Saver::VRML2Saver(SaveVRMLParams *par) {
    f=NULL;
    lastnode=NULL;
    currentgroup=NULL;
    currentnode=NULL;
    sp=par;
    nb=0;
    puts("VRML2Saver object created");

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
	MUIA_Window_SizeGadget, TRUE,
	MUIA_Window_NoMenus, TRUE,
	MUIA_Window_Open, FALSE,
	MUIA_Window_Width, MUIV_Window_Width_Screen(30),
	MUIA_Window_RefWindow, sp->RefWindow,
	WindowContents, GroupObject,
	    Child, GA_Msg,
	    Child, ScaleObject,
		MUIA_Scale_Horiz, TRUE,
	    End,
	    Child, TX_Msg,
	End,
    End;

    DoMethod((Object *) sp->App,OM_ADDMEMBER,WI_Msg);
}
VRML2Saver::~VRML2Saver() {
    DoMethod((Object *) sp->App,OM_REMMEMBER,WI_Msg);
    MUI_DisposeObject((Object *) WI_Msg);
}
void VRML2Saver::WriteVRML_V2(FILE *fd,VRMLNode *n) {
    f=fd;
    VRMLState state=VRMLState();
    n->Browse(&state);

    SetAttrs((Object *) TX_Msg, MUIA_Text_Contents,(ULONG) "Saving VRML V2.0 utf8 file");
    SetAttrs((Object *) GA_Msg, MUIA_Gauge_Max,state.totalnodes);
    SetAttrs((Object *) GA_Msg, MUIA_Gauge_Current,0);
    SetAttrs((Object *) WI_Msg, MUIA_Window_Open, TRUE);
    // printf("total nodes:%d\n",state.totalnodes);
    SaveNode(n,0);
    SetAttrs((Object *) WI_Msg, MUIA_Window_Open, FALSE);
}
void VRML2Saver::SaveNode(VRMLNode *n,int tab) {
    switch (n->ID) {
	case ASCIITEXT_1:WriteAsciiText((AsciiText *) n,tab);break;
	case CONE_1:WriteCone((Cone *) n, tab);break;
	case COORDINATE3_1:WriteCoordinate3((Coordinate3 *) n, tab);break;
	case CUBE_1:WriteCube((Cube *) n, tab);break;
	case CYLINDER_1:WriteCylinder((Cylinder *) n, tab);break;
	case DIRECTIONALLIGHT_1:WriteDirectionalLight((DirectionalLight *)n, tab);break;
	case FONTSTYLE_1:WriteFontStyle((FontStyle *) n, tab);break;
	case GROUP_1:WriteGroup((Group *) n, tab);break;
	case INDEXEDFACESET_1:WriteIFS((IndexedFaceSet *) n, tab);break;
	case INDEXEDLINESET_1:WriteILS((IndexedLineSet *) n, tab);break;
	case INFO_1:WriteInfo((VInfo *) n, tab);break;
	case LOD_1:WriteLOD((LOD *) n, tab);break;
	case MATERIAL_1:WriteMaterial((Material *) n, tab);break;
	case MATERIALBINDING_1:WriteMaterialBinding((MaterialBinding *) n, tab);break;
	case MATRIXTRANSFORM_1:WriteMatrixTransform((MatrixTransform *) n, tab);break;
	case NORMAL_1:WriteNormal((Normal *) n, tab);break;
	case NORMALBINDING_1:WriteNormalBinding((NormalBinding *) n, tab);break;
	case ORTHOGRAPHICCAMERA_1:WriteOC((OrthographicCamera *) n, tab);break;
	case PERSPECTIVECAMERA_1:WritePC((PerspectiveCamera *) n, tab);break;
	case POINTLIGHT_1:WritePointLight((PointLight *) n, tab);break;
	case POINTSET_1:WritePointSet((PointSet *) n, tab);break;
	case ROTATION_1:WriteRotation((Rotation *) n, tab);break;
	case SCALE_1:WriteScale((Scale *) n, tab);break;
	case SEPARATOR_1:WriteSeparator((Separator *) n, tab);break;
	case SHAPEHINTS_1:WriteShapeHints((ShapeHints *) n, tab);break;
	case SPHERE_1:WriteSphere((Sphere *) n, tab);break;
	case SPOTLIGHT_1:WriteSpotLight((SpotLight *) n, tab);break;
	case SWITCH_1:WriteSwitch((Switch *) n, tab);break;
	case TEXTURE2_1:WriteTexture2((Texture2 *) n, tab);break;
	case TEXTURE2TRANSFORM_1:WriteTexture2Transform((Texture2Transform *) n, tab);break;
	case TEXTURECOORDINATE2_1:WriteTextureCoordinate2((TextureCoordinate2 *) n, tab);break;
	case TRANSFORM_1:WriteTransform((Transform *) n, tab);break;
	case TRANSFORMSEPARATOR_1:WriteTransformSeparator((TransformSeparator *) n, tab);break;
	case TRANSLATION_1:WriteTranslation((Translation *) n, tab);break;
	case WWWANCHOR_1:WriteWWWAnchor((WWWAnchor *) n, tab);break;
	case WWWINLINE_1:WriteWWWInline((WWWInline *) n, tab);break;
	case USE_1:WriteUSE((USE *) n, tab);break;
    };
    nb++;
    // puts("before");
    if (WI_Msg) {
	SetAttrs((Object *) GA_Msg, MUIA_Gauge_Current, nb);
    };
    // printf("nb:%d\n",nb);
    // puts("after");
}

void VRML2Saver::WriteTabs(int t) {
    for (int i=0;i<t;i++) {
	fprintf(f,"\t");
    };
}

/**************
 * VRML Nodes *
 **************/
// AsciiText
void VRML2Saver::WriteAsciiText(AsciiText *a,int tab) {
    int i=0,size=a->Size();
    if (strcmp(a->GetName(),"NONE")) {
	fprintf(f,"DEF %s ",a->GetName());
    };
    fprintf(f,"AsciiText {\n");
    WriteTabs(tab+1);
    fprintf(f,"string ");
    if (size>1) fprintf(f,"[\n");
    for (i=0;i<size;i++) {
	WriteTabs(tab+2);
	fprintf(f,"\"%s\",\n",a->txt.Get(i)->str);
    };
    if (size>1) {
	WriteTabs(tab+1);
	fprintf(f,"       ]\n");
    };
    WriteTabs(tab+1);
    fprintf(f,"spacing %-g\n",a->spacing);
    WriteTabs(tab+1);
    fprintf(f,"justification ");
    switch (a->justification) {
	case JUSTIFICATION_LEFT:fprintf(f,"LEFT\n");break;
	case JUSTIFICATION_CENTER:fprintf(f,"CENTER\n");break;
	case JUSTIFICATION_RIGHT:fprintf(f,"RIGHT\n");break;
    };
    WriteTabs(tab+1);
    fprintf(f,"width ");
    if (size>1) fprintf(f,"[\n");
    for (i=0;i<size;i++) {
	WriteTabs(tab+2);
	fprintf(f,"%-g,\n",a->txt.Get(i)->width);
    };
    if (size>1) {
	WriteTabs(tab+1);
	fprintf(f,"       ]\n");
    };
    WriteTabs(tab);
    fprintf(f,"}\n");
}
// Cone
void VRML2Saver::WriteCone(Cone *c,int tab) {
    WriteTabs(tab);
    if (strcmp(c->GetName(),"NONE")) {
	fprintf(f,"DEF %s ",c->GetName());
    };
    if ((c->bottomRadius!=1)&&(c->height!=2)) {
	fprintf(f,"Cone {\n");
	WriteTabs(tab+1);
	fprintf(f,"parts ");
	if (c->parts==SIDES+BOTTOM) {fprintf (f,"ALL\n");}
	else {
	   fprintf(f,"(");
	   if (c->parts&SIDES==SIDES) {
		fprintf(f,"SIDES");
		// if (parts-SIDES>0) fprintf(f," | ");
	   }
	   else if (c->parts&BOTTOM==BOTTOM) {
		fprintf(f,"BOTTOM");
		// if (parts-BOTTOM-SIDES>0) fprintf(f," | ");
	   };
	   fprintf(f,")\n");
	};
	WriteTabs(tab+1);
	fprintf(f,"bottomRadius %-g\n",c->bottomRadius);
	WriteTabs(tab+1);
	fprintf(f,"height %-g\n",c->height);
	WriteTabs(tab);
	fprintf(f,"}\n");
    }
    else {
	fprintf(f,"Cone {}\n");
    };    
}
// Coordinate3
void VRML2Saver::WriteCoordinate3(Coordinate3 *c,int tab) {
    Vertex3d *cv=NULL;
    int size=c->Size();
    // puts("Writing Coordinate");
    WriteTabs(tab);
    if (strcmp(c->GetName(),"NONE")) {
	fprintf(f,"DEF %s ",c->GetName());
    };
    fprintf(f,"Coordinate3 {\n");
    WriteTabs(tab+1);
    fprintf(f,"point [\n");
    for (int i=0;i<size;i++) {
	WriteTabs(tab+2);
	cv=c->point.Get(i);
	fprintf(f,"%-.4g %-.4g %-.4g,\n",
		cv->coord[0],cv->coord[1],cv->coord[2]);
    };                                      
    WriteTabs(tab+1);
    fprintf(f,"           ]\n");
    WriteTabs(tab);
    fprintf(f,"}\n");
    // puts("Finished");
}
// Cube
void VRML2Saver::WriteCube(Cube *c, int tab) {
    currentnode=(VRMLNode *) c;

    WriteTabs(tab);
    if (strcmp(c->GetName(),"NONE")) {
	fprintf(f,"DEF %s ",c->GetName());
    };
    if ((c->width==2)&&
	(c->height==2)&&
	(c->depth==2)) {
	    fprintf(f,"Cube {}\n");
    }
    else {
	fprintf(f,"Cube {\n");
	WriteTabs(tab+1);
	fprintf(f,"width %-g\n", c->width);
	WriteTabs(tab+1);
	fprintf(f,"height %-g\n", c->height);
	WriteTabs(tab+1);
	fprintf(f,"depth  %-g\n", c->depth);
	WriteTabs(tab);
	fprintf(f,"}\n");
    };
}
// Cylinder
void VRML2Saver::WriteCylinder(Cylinder *c, int tab) {
    WriteTabs(tab);
    if (strcmp(c->GetName(),"NONE")) {
	fprintf(f,"DEF %s ",c->GetName());
    };
    if ((c->radius==1)&&
	(c->height==1)) {fprintf(f,"Cylinder {}\n");}
    else {
	fprintf(f,"Cylinder {\n");
	WriteTabs(tab+1);
	fprintf(f,"parts ");
	if (c->parts==ALL) fprintf (f,"ALL\n");
	else {
	   fprintf(f,"(");
	   if (c->parts&SIDES==SIDES) {
		fprintf(f,"SIDES");
		if (c->parts-SIDES>0) fprintf(f," | ");
	   };
	   if (c->parts&BOTTOM==BOTTOM) {
		fprintf(f,"BOTTOM");
		if(c->parts-BOTTOM-SIDES>0) fprintf(f," | ");
	   };
	   if (c->parts&TOP==TOP) {
		fprintf(f,"TOP");
	   };
	   fprintf(f,")\n");
	};
	WriteTabs(tab+1);
	fprintf(f,"radius %-g\n",c->radius);
	WriteTabs(tab+1);
	fprintf(f,"height %-g\n",c->height);
	WriteTabs(tab);
	fprintf(f,"}\n");
    };    
}
// DirectionalLight
void VRML2Saver::WriteDirectionalLight(DirectionalLight *dl, int tab) {
    WriteTabs(tab);
    if (strcmp(dl->GetName(),"NONE")) {
	fprintf(f,"DEF %s ",dl->GetName());
    };
    fprintf(f,"DirectionalLight {\n");
    WriteTabs(tab+1);
    fprintf(f,"on ");
    if (dl->on==1) {fprintf(f,"TRUE\n");}
    else {fprintf(f,"FALSE\n");};
    WriteTabs(tab+1);
    fprintf(f,"intensity %-g\n",dl->intensity);
    WriteTabs(tab+1);
    fprintf(f,"color %-g %-g %-g\n",dl->color.rgb[0],dl->color.rgb[1],dl->color.rgb[2]);
    WriteTabs(tab+1);
    fprintf(f,"direction %-g %-g %-g\n",dl->point.coord[0],dl->point.coord[1],dl->point.coord[2]);
    WriteTabs(tab);
    fprintf(f,"}\n");
}
// FontStyle
void VRML2Saver::WriteFontStyle(FontStyle *fs, int tab) {
    WriteTabs(tab);
    if (strcmp(fs->GetName(),"NONE")) {
	fprintf(f,"DEF %s ",fs->GetName());
    };
    fprintf(f,"FontStyle {\n");
    WriteTabs(tab+1);
    fprintf(f,"size %-g\n",fs->size);
    WriteTabs(tab+1);
    fprintf(f,"family ");
    switch (fs->family) {
	case FONTFAMILY_SERIF:fprintf(f,"SERIF\n");break;
	case FONTFAMILY_SANS:fprintf(f,"SANS\n");break;
	case FONTFAMILY_TYPEWRITER:fprintf(f,"TYPEWRITER\n");break;
    };
    WriteTabs(tab+1);
    fprintf(f,"style (");
    if (fs->style==FONTSTYLE_NONE) {fprintf(f,"NONE)\n");}
    else {
	if ((fs->style&FONTSTYLE_BOLD)==FONTSTYLE_BOLD) {
		fprintf(f,"BOLD");
		if ((fs->style-FONTSTYLE_BOLD)>0) fprintf(f," | ");
	};
	if ((fs->style&FONTSTYLE_ITALIC)==FONTSTYLE_ITALIC) {
		fprintf(f,"ITALIC");
	};
	fprintf(f,")\n");
     };
     WriteTabs(tab);
     fprintf(f,"}\n");
}
// Group ==> Group
void VRML2Saver::WriteGroup(Group *g, int tab) {
    int i;
    lastnode=g->GetChild(g->Size()-1);
    currentgroup=(VRMLGroups *) g;

    WriteTabs(tab);
    if (strcmp(g->GetName(),"NONE")){
	fprintf(f,"DEF %s Group {\n",g->GetName());
    }
    else {
	fprintf(f,"Group {\n");
    };
    WriteTabs(tab+1);
    fprintf(f,"children [\n");
    for (i=0;i<g->children.Length();i++) {
	SaveNode(g->children.Get(i),tab+2);
	fprintf(f,",\n");
    };
    WriteTabs(tab+1);
    fprintf(f,"]\n");
    WriteTabs(tab);
    fprintf(f,"}\n");
}
// IndexedFaceSet
void VRML2Saver::WriteIFS(IndexedFaceSet *ifs, int tab) {
    int index,i,j,pos;
    int size=ifs->Size();
    WriteTabs(tab);
    Face *cf;
    // puts("Writing IFS");
    if (strcmp(ifs->GetName(),"NONE")) {
	fprintf(f,"DEF %s ",ifs->GetName());
    };
    fprintf(f,"IndexedFaceSet {\n");
    WriteTabs(tab+1);
    fprintf(f,"coordIndex [\n");
    for (i=0;i<size;i++) {
	cf=ifs->faces.Get(i);
	WriteTabs(tab+2);
	for (j=0;j<cf->coordIndex.Length();j++) {
		index=cf->coordIndex.Get(j);
		fprintf(f,"%d,",index);
	};
	fprintf(f,"-1,\n");//     # face %d\n",i);
    };
    WriteTabs(tab+1);
    fprintf(f,"]\n");
    // };
    if (ifs->writeMaterialIndex) {
	pos=0;
	WriteTabs(tab+1);
	fprintf(f,"materialIndex [\n");
	WriteTabs(tab+2);
	for (i=0;i<size;i++) {
	    cf=ifs->faces.Get(i);
	    for (j=0;j<cf->materialIndex.Length();j++) {
		fprintf(f,"%d,",cf->materialIndex.Get(j));
	    };
	    if (cf->materialIndex.Length()>1) {
		fprintf(f,"-1,");
	    };
	    pos++;
	    if (pos>=10) {
		fprintf(f,"\n");
		WriteTabs(tab+2);
		pos=0;
	    };
	};
	fprintf(f,"\n");
	WriteTabs(tab+1);
	fprintf(f,"]\n");
    };
    if (ifs->writeNormalIndex) {
	pos=0;
	WriteTabs(tab+1);
	fprintf(f,"normalIndex [\n");
	WriteTabs(tab+2);
	for (i=0;i<size;i++) {
	    cf=ifs->faces.Get(i);
	    for (j=0;j<cf->normalIndex.Length();j++) {
		fprintf(f,"%d,",cf->normalIndex.Get(j));
	    };
	    if (cf->normalIndex.Length()>1) {
		fprintf(f,"-1,");
	    };
	    pos++;
	    if (pos>=10) {
		fprintf(f,"\n");
		WriteTabs(tab+2);
		pos=0;
	    };
	};
	fprintf(f,"\n");
	WriteTabs(tab+1);
	fprintf(f,"]\n");
    };
    if (ifs->writeTextureCoordIndex) {
	pos=0;
	WriteTabs(tab+1);
	fprintf(f,"textureCoordIndex [\n");
	WriteTabs(tab+2);
	for (i=0;i<size;i++) {
	    cf=ifs->faces.Get(i);
	    for (j=0;j<cf->textureCoordIndex.Length();j++) {
		fprintf(f,"%d,",cf->textureCoordIndex.Get(j));
	    };
	    fprintf(f,"-1,");
	    pos++;
	    if (pos>=5) {
		fprintf(f,"\n");
		WriteTabs(tab+2);
		pos=0;
	    };
	};
	fprintf(f,"]\n");
    };
    WriteTabs(tab);
    fprintf(f,"}\n");
    // puts("Finished");
}
// IndexedLineSet
void VRML2Saver::WriteILS(IndexedLineSet *ils, int tab) {
    int index,i,j,pos;
    int size=ils->Size();
    WriteTabs(tab);
    Face *cf;
    if (strcmp(ils->GetName(),"NONE")) {
	fprintf(f,"DEF %s ",ils->GetName());
    };
    fprintf(f,"IndexedLineSet {\n");
    WriteTabs(tab+1);
    fprintf(f,"coordIndex [\n");
    for (i=0;i<size;i++) {
	cf=ils->faces.Get(i);
	WriteTabs(tab+2);
	for (j=0;j<cf->coordIndex.Length();j++) {
		index=cf->coordIndex.Get(j);
		fprintf(f,"%d,",index);
	};
	fprintf(f,"-1,\n");//    # line %d\n",i);
    };
    WriteTabs(tab+1);
    fprintf(f,"]\n");
    if (ils->writeMaterialIndex) {
	pos=0;
	WriteTabs(tab+1);
	fprintf(f,"materialIndex [\n");
	WriteTabs(tab+2);
	for (i=0;i<size;i++) {
	    cf=ils->faces.Get(i);
	    for (j=0;j<cf->materialIndex.Length();j++) {
		fprintf(f,"%d,",cf->materialIndex.Get(j));
	    };
	    if (cf->materialIndex.Length()>1) {
		fprintf(f,"-1,");
	    };
	    pos++;
	    if (pos>=10) {
		fprintf(f,"\n");
		WriteTabs(tab+2);
		pos=0;
	    };
	};
	fprintf(f,"\n");
	WriteTabs(tab+2);
	fprintf(f,"]\n");
    };
    if (ils->writeNormalIndex) {
	pos=0;
	WriteTabs(tab+1);
	fprintf(f,"normalIndex [\n");
	WriteTabs(tab+2);
	for (i=0;i<size;i++) {
	    cf=ils->faces.Get(i);
	    for (j=0;j<cf->normalIndex.Length();j++) {
		fprintf(f,"%d,",cf->normalIndex.Get(j));
	    };
	    if (cf->normalIndex.Length()>1) {
		fprintf(f,"-1,");
	    };
	    pos++;
	    if (pos>=10) {
		fprintf(f,"\n");
		WriteTabs(tab+2);
		pos=0;
	    };
	};
	fprintf(f,"\n");
	WriteTabs(tab+2);
	fprintf(f,"]\n");
    };
    if (ils->writeTextureCoordIndex) {
	pos=0;
	WriteTabs(tab+1);
	fprintf(f,"textureCoordIndex [\n");
	WriteTabs(tab+2);
	for (i=0;i<size;i++) {
	    cf=ils->faces.Get(i);
	    for (j=0;j<cf->textureCoordIndex.Length();j++) {
		fprintf(f,"%d,",cf->textureCoordIndex.Get(j));
	    };
	    fprintf(f,"-1,");
	    pos++;
	    if (pos>=5) {
		fprintf(f,"\n");
		WriteTabs(tab+2);
		pos=0;
	    };
	};
	fprintf(f,"\n");
	WriteTabs(tab+2);
	fprintf(f,"]\n");
    };
    WriteTabs(tab);
    fprintf(f,"}\n");
}
// Info
void VRML2Saver::WriteInfo(VInfo *in, int tab) {
    WriteTabs(tab);
    if (strcmp(in->GetName(),"NONE")) {
	fprintf(f,"DEF %s ",in->GetName());
    };
    fprintf(f,"Info {\n");
    WriteTabs(tab+1);
    fprintf(f,"string \"%s\"\n",in->GetString());
    WriteTabs(tab);
    fprintf(f,"}\n");
}
// LOD
void VRML2Saver::WriteLOD(LOD *l, int tab) {
    int i,n=0;
    double x,y,z;
    lastnode=l->GetChild(l->Size()-1);
    currentgroup=(VRMLGroups *) l;

    WriteTabs(tab);
    if (strcmp(l->GetName(),"NONE")){
		fprintf(f,"DEF %s ",l->GetName());
    };
    fprintf(f,"LOD {\n");
    WriteTabs(tab+1);
    fprintf(f,"range ");
    if (l->range.Length()>1) fprintf(f,"[\n");
    WriteTabs(tab+2);
    for (i=0;i<l->range.Length();i++) {
	if (n>10) {
		fprintf(f,"\n");
		WriteTabs(tab+2);
		n=0;
	};
	fprintf(f,"%5.2f, ",l->range.Get(i));
	n++;
    };
    WriteTabs(tab+1);
    if (l->range.Length()>1) fprintf(f,"      ]\n");
    WriteTabs(tab+1);
    l->center.Get(x,y,z);
    fprintf(f,"center %-g %-g %-g\n",x,y,z);

    for (i=0;i<l->children.Length();i++) {
	SaveNode(l->children.Get(i),tab+1);
    };
    WriteTabs(tab);
    fprintf(f,"}\n");
}
// Material
void VRML2Saver::WriteMaterial (Material *m, int tab) {
    float r,g,b;
    int i=0;
    int size=m->Size();
    Mat *cm;

    // puts("Writing Material");
    WriteTabs(tab);
    if (strcmp(m->GetName(),"NONE")) {
	fprintf(f,"DEF %s ",m->GetName());
    };
    fprintf(f,"Material {\n");
    WriteTabs(tab+1);
    fprintf(f,"ambientColor [\n");
    for (i=0;i<size;i++) {
	cm=m->material.Get(i);
	WriteTabs(tab+2);
	fprintf(f,"%1.2f %1.2f %1.2f,\n",
	cm->ambient.rgb[0],cm->ambient.rgb[1],cm->ambient.rgb[2]);
    };
    WriteTabs(tab+1);
    fprintf(f,"]\n");
    WriteTabs(tab+1);
    fprintf(f,"diffuseColor [\n");

    for (i=0;i<size;i++) {
	cm=m->material.Get(i);
	WriteTabs(tab+2);
	fprintf(f,"%1.2f %1.2f %1.2f,\n",
	cm->diffuse.rgb[0],cm->diffuse.rgb[1],cm->diffuse.rgb[2]);
    };
    WriteTabs(tab+1);
    fprintf(f,"]\n");
    WriteTabs(tab+1);
    fprintf(f,"specularColor [\n");
    for (i=0;i<size;i++) {
	cm=m->material.Get(i);
	WriteTabs(tab+2);
	fprintf(f,"%1.2f %1.2f %1.2f,\n",
	cm->specular.rgb[0],cm->specular.rgb[1],cm->specular.rgb[2]);
    };
    WriteTabs(tab+1);
    fprintf(f,"]\n");
    WriteTabs(tab+1);
    fprintf(f,"emissiveColor [\n");
    for (i=0;i<size;i++) {
	cm=m->material.Get(i);
	WriteTabs(tab+2);
	fprintf(f,"%1.2f %1.2f %1.2f,\n",
	cm->emissive.rgb[0],cm->emissive.rgb[1],cm->emissive.rgb[2]);
    };
    WriteTabs(tab+1);
    fprintf(f,"]\n");
    WriteTabs(tab+1);
    fprintf(f,"shininess [\n");
    for (i=0;i<size;i++) {
	cm=m->material.Get(i);
	WriteTabs(tab+2);
	fprintf(f,"%1.2f,\n",cm->shininess/128.0);
    };
    WriteTabs(tab+1);
    fprintf(f,"]\n");
    WriteTabs(tab+1);
    fprintf(f,"transparency [\n");
    for (i=0;i<size;i++) {
	cm=m->material.Get(i);
	WriteTabs(tab+2);
	fprintf(f,"%1.2f,\n",cm->transparency);
    };
    WriteTabs(tab+1);
    fprintf(f,"]\n");
    WriteTabs(tab);
    fprintf(f,"}\n");
    // puts("Finished");
}
// MaterialBinding
void VRML2Saver::WriteMaterialBinding(MaterialBinding *mb, int tab) {
    WriteTabs(tab);
    if (strcmp(mb->GetName(),"NONE")) {
	fprintf(f,"DEF %s ",mb->GetName());
    };
    fprintf(f,"MaterialBinding {\n");
    WriteTabs(tab+1);
    fprintf(f,"value ");
    switch (mb->value) {
	case BINDING_DEFAULT:fprintf(f,"DEFAULT\n");break;
	case BINDING_OVERALL:fprintf(f,"OVERALL\n");break;
	case BINDING_PER_PART:fprintf(f,"PER_PART\n");break;
	case BINDING_PER_PART_INDEXED:fprintf(f,"PER_PART_INDEXED\n");break;
	case BINDING_PER_VERTEX:fprintf(f,"PER_VERTEX\n");break;
	case BINDING_PER_VERTEX_INDEXED:fprintf(f,"PER_VERTEX_INDEXED\n");break;
	case BINDING_PER_FACE:fprintf(f,"PER_FACE\n");break;
	case BINDING_PER_FACE_INDEXED:fprintf(f,"PER_FACE_INDEXED\n");break;
    };
    WriteTabs(tab);
    fprintf(f,"}\n");
}
// MatrixTransform
void VRML2Saver::WriteMatrixTransform(MatrixTransform *mt, int tab) {
    float *matrix=mt->matrix;
    WriteTabs(tab);
    if (strcmp(mt->GetName(),"NONE")) {
	fprintf(f,"DEF %s ",mt->GetName());
    };
    fprintf(f,"MatrixTransform {\n");
    WriteTabs(tab+1);
    fprintf(f,"matrix %-.8g %-.8g %-.8g %-.8g\n",
		matrix[0],matrix[1],matrix[2],matrix[3]);
    WriteTabs(tab+1);
    fprintf(f,"       %-.8g %-.8g %-.8g %-.8g\n",
		matrix[4],matrix[5],matrix[6],matrix[7]);
    WriteTabs(tab+1);
    fprintf(f,"       %-.8g %-.8g %-.8g %-.8g\n",
		matrix[8],matrix[9],matrix[10],matrix[11]);
    WriteTabs(tab+1);
    fprintf(f,"       %-.8g %-.8g %-.8g %-.8g\n",
		matrix[12],matrix[13],matrix[14],matrix[15]);
    WriteTabs(tab);
    fprintf(f,"}\n");
}
// Normal
void VRML2Saver::WriteNormal(Normal *no, int tab) {
    int i,n;
    int size=no->Size();
    // float x,y,z;
    Vertex3d *cp;

    WriteTabs(tab);
    if (strcmp(no->GetName(),"NONE")) {
	fprintf(f,"DEF %s ",no->GetName());
    };
    fprintf(f,"Normal {\n");
    WriteTabs(tab+1);
    fprintf(f,"vector ");
    if (size>1) fprintf(f,"[\n");
    for (i=0;i<size;i++) {
	cp=no->vector.Get(i);
	WriteTabs(tab+2);
	fprintf(f,"%5.2f %5.2f %5.2f,\n",cp->coord[0],cp->coord[1],cp->coord[2]);
    };
    WriteTabs(tab+1);
    if (size>1) fprintf(f,"       ]\n");
    WriteTabs(tab);
    fprintf(f,"}\n");
}
// NormalBinding
void VRML2Saver::WriteNormalBinding(NormalBinding *nb, int tab) {
    WriteTabs(tab);
    if (strcmp(nb->GetName(),"NONE")) {
	fprintf(f,"DEF %s ",nb->GetName());
    };
    fprintf(f,"NormalBinding {\n");
    WriteTabs(tab+1);
    fprintf(f,"value ");
    switch (nb->value) {
	case BINDING_DEFAULT:fprintf(f,"DEFAULT\n");break;
	case BINDING_OVERALL:fprintf(f,"OVERALL\n");break;
	case BINDING_PER_PART:fprintf(f,"PER_PART\n");break;
	case BINDING_PER_PART_INDEXED:fprintf(f,"PER_PART_INDEXED\n");break;
	case BINDING_PER_FACE:fprintf(f,"PER_FACE\n");break;
	case BINDING_PER_FACE_INDEXED:fprintf(f,"PER_FACE_INDEXED\n");break;
	case BINDING_PER_VERTEX:fprintf(f,"PER_VERTEX\n");break;
	case BINDING_PER_VERTEX_INDEXED:fprintf(f,"PER_VERTEX_INDEXED\n");break;
   };
   WriteTabs(tab);
   fprintf(f,"}\n");
}
// OrthographicCamera
void VRML2Saver::WriteOC(OrthographicCamera *oc, int tab) {
    WriteTabs(tab);
    if (strcmp(oc->GetName(),"NONE")) {
	fprintf(f,"DEF %s ",oc->GetName());
    };
    fprintf(f,"OrthographicCamera {\n");
    WriteTabs(tab+1);
    fprintf(f,"position %5.2f %5.2f %5.2f\n",
	       oc->position.coord[0],oc->position.coord[1],oc->position.coord[2]);
    WriteTabs(tab+1);
    fprintf(f,"orientation %5.2f %5.2f %5.2f %1.8f\n",
	       oc->orientation.coord[0],oc->orientation.coord[1],oc->orientation.coord[2],
	       oc->orientation.coord[3]);
    WriteTabs(tab+1);
    fprintf(f,"focalDistance %5.2f\n",oc->focalDistance);
    WriteTabs(tab+1);
    fprintf(f,"height %5.2f\n",oc->height);
    WriteTabs(tab);
}
// PerspectiveCamera
void VRML2Saver::WritePC(PerspectiveCamera *pc, int tab) {
    WriteTabs(tab);
    if (strcmp(pc->GetName(),"NONE")) {
	fprintf(f,"DEF %s ",pc->GetName());
    };
    fprintf(f,"PerspectiveCamera {\n");
    WriteTabs(tab+1);
    fprintf(f,"position %5.2f %5.2f %5.2f\n",
	       pc->position.coord[0],pc->position.coord[1],pc->position.coord[2]);
    WriteTabs(tab+1);
    fprintf(f,"orientation %5.2f %5.2f %5.2f %1.8f\n",
	       pc->orientation.coord[0],pc->orientation.coord[1],pc->orientation.coord[2],
	       pc->orientation.coord[3]);
    WriteTabs(tab+1);
    fprintf(f,"focalDistance %5.2f\n",pc->focalDistance);
    WriteTabs(tab+1);
    fprintf(f,"heightAngle %5.2f\n",pc->height);
    WriteTabs(tab);
    fprintf(f,"}\n");
}
// PointLight
void VRML2Saver::WritePointLight(PointLight *pl, int tab) {
    WriteTabs(tab);
    if (strcmp(pl->GetName(),"NONE")) {
	fprintf(f,"DEF %s ",pl->GetName());
    };
    fprintf(f,"PointLight {\n");
    WriteTabs(tab+1);
    fprintf(f,"on ");
    if (pl->on==1) {fprintf(f,"TRUE\n");}
    else {fprintf(f,"FALSE\n");};
    WriteTabs(tab+1);
    fprintf(f,"intensity %5.2f\n",pl->intensity);
    WriteTabs(tab+1);
    fprintf(f,"color %1.2f %1.2f %1.2f\n",pl->color.rgb[0],pl->color.rgb[1],pl->color.rgb[2]);
    WriteTabs(tab+1);
    fprintf(f,"location %5.2f %5.2f %5.2f\n",pl->point.coord[0],pl->point.coord[1],pl->point.coord[2]);
    WriteTabs(tab);
    fprintf(f,"}\n");
}
// PointSet
void VRML2Saver::WritePointSet(PointSet *ps, int tab) {
    WriteTabs(tab);
    if (strcmp(ps->GetName(),"NONE")) {
	fprintf(f,"DEF %s ",ps->GetName());
    };
    fprintf(f,"PointSet {\n");
    WriteTabs(tab+1);
    fprintf(f,"startIndex %d\n",ps->startIndex);
    WriteTabs(tab+1);
    fprintf(f,"numPoints  %d\n",ps->numPoints);
    WriteTabs(tab);
    fprintf(f,"}\n");
}
// Rotation
void VRML2Saver::WriteRotation(Rotation *r, int tab) {
    double x,y,z,a;

    WriteTabs(tab);
    if (strcmp(r->GetName(),"NONE")) {
	fprintf(f,"DEF %s ",r->GetName());
    };
    fprintf(f,"Rotation {\n");
    WriteTabs(tab+1);
    r->rotation.Get(x,y,z,a);
    fprintf(f,"rotation %5.2f %5.2f %5.2f %5.2f\n",x,y,z,a);
    WriteTabs(tab);
    fprintf(f,"}\n");
}
// Scale
void VRML2Saver::WriteScale(Scale *s, int tab) {
    double x,y,z;

    WriteTabs(tab);
    if (strcmp(s->GetName(),"NONE")) {
	fprintf(f,"DEF %s ",s->GetName());
    };
    fprintf(f,"Scale {\n");
    WriteTabs(tab+1);
    s->scaleFactor.Get(x,y,z);
    fprintf(f,"scaleFactor %5.2f %5.2f %5.2f\n",x,y,z);
    WriteTabs(tab);
    fprintf(f,"}\n");
}
// Separator
void VRML2Saver::WriteSeparator (Separator *s, int tab) {
    lastnode=s->GetChild(s->Size()-1);
    currentgroup=(VRMLGroups *) s;

    WriteTabs(tab);
    if (strcmp(s->GetName(),"NONE")) {
	fprintf(f,"DEF %s ",s->GetName());
    };
    fprintf(f,"Transform {\n");
    WriteTabs(tab+1);
    fprintf(f,"children [\n");
    int pos=-1;
    for (int i=pos+1;i<s->Size();i++) {
	SaveNode(s->GetChild(i),tab+2);
	pos=s->FindPosition(currentnode);
	fprintf(f,",\n");
    };
    WriteTabs(tab+1);
    fprintf(f,"]\n");

    WriteTabs(tab);
    fprintf(f,"}\n");
}
// ShapeHints
void VRML2Saver::WriteShapeHints(ShapeHints *sh, int tab) {
    WriteTabs(tab);
    if (strcmp(sh->GetName(),"NONE")) {
	fprintf(f,"DEF %s ",sh->GetName());
    };
    fprintf(f,"ShapeHints {\n");
    WriteTabs(tab+1);
    fprintf(f,"vertexOrdering ");
    switch (sh->vertexOrdering) {
	case UNKNOWN_ORDERING:fprintf(f,"UNKNOWN_ORDERING\n");break;
	case CLOCKWISE:fprintf(f,"CLOCKWISE\n");break;
	case COUNTERCLOCKWISE:fprintf(f,"COUNTERCLOCKWISE\n");break;
    };
    WriteTabs(tab+1);
    fprintf(f,"shapeType ");
    switch (sh->shapeType) {
	case UNKNOWN_SHAPE_TYPE:fprintf(f,"UNKNOWN_SHAPE_TYPE\n");break;
	case SOLID:fprintf(f,"SOLID\n");break;
    };
    WriteTabs(tab+1);
    fprintf(f,"faceType ");
    switch (sh->faceType) {
	case UNKNOWN_FACE_TYPE:fprintf(f,"UNKNOWN_FACE_TYPE\n");break;
	case CONVEX:fprintf(f,"CONVEX\n");break;
    };
    WriteTabs(tab+1);
    fprintf(f,"creaseAngle %5.2f\n",sh->creaseAngle);
    WriteTabs(tab);
    fprintf(f,"}\n");
}
// Sphere
void VRML2Saver::WriteSphere(Sphere *s, int tab) {
    WriteTabs(tab);
    puts("==>WriteSphere");
    if (strcmp(s->GetName(),"NONE")) {
	fprintf(f,"DEF %s ",s->GetName());
    };
    if (s->radius!=1) {
	fprintf(f,"Sphere {\n");
	WriteTabs(tab+1);
	fprintf(f,"radius %4.2f\n", s->radius);
	WriteTabs(tab);
	fprintf(f,"}\n");
    }
    else {
	fprintf(f,"Sphere {}\n");
    };
    puts("<==WriteSphere");
}
// SpotLight
void VRML2Saver::WriteSpotLight(SpotLight *sl, int tab) {
    WriteTabs(tab);
    if (strcmp(sl->GetName(),"NONE")) {
	fprintf(f,"DEF %s ",sl->GetName());
    };
    fprintf(f,"SpotLight {\n");
    WriteTabs(tab+1);
    fprintf(f,"on ");
    if (sl->on==1) {fprintf(f,"TRUE\n");}
    else {fprintf(f,"FALSE\n");};
    WriteTabs(tab+1);
    fprintf(f,"intensity %5.2f\n",sl->intensity);
    WriteTabs(tab+1);
    fprintf(f,"color %1.2f %1.2f %1.2f\n",sl->color.rgb[0],sl->color.rgb[1],sl->color.rgb[2]);
    WriteTabs(tab+1);
    fprintf(f,"location %5.2f %5.2f %5.2f\n",sl->point.coord[0],sl->point.coord[1],sl->point.coord[2]);
    WriteTabs(tab+1);
    fprintf(f,"direction %5.2f %5.2f %5.2f\n",
	       sl->direction.coord[0],sl->direction.coord[1],sl->direction.coord[2]);
    WriteTabs(tab+1);
    fprintf(f,"dropOffRate %5.5f\n",sl->dropOffRate);
    WriteTabs(tab+1);
    fprintf(f,"cutOffAngle %5.5f\n",sl->cutOffAngle);
    WriteTabs(tab);
    fprintf(f,"}\n");
}
// Switch
void VRML2Saver::WriteSwitch(Switch *sw, int tab) {
    int i;
    currentgroup=(VRMLGroups *) sw;
    lastnode=sw->GetChild(sw->Size()-1);
    
    WriteTabs(tab);
    if (strcmp(sw->GetName(),"NONE")){
	fprintf(f,"DEF %s ",sw->GetName());
    };
    fprintf(f,"Switch {\n");
    WriteTabs(tab+1);
    fprintf(f,"whichChild %d\n",sw->whichChild);

    for (i=0;i<sw->children.Length();i++) {
	SaveNode(sw->children.Get(i),tab+1);
    };

    WriteTabs(tab);
    fprintf(f,"}\n");
}
// Texture2
void VRML2Saver::WriteTexture2(Texture2 *t, int tab) {
    WriteTabs(tab);
    int i=0,j=0,cnt=0,value=0;
    UBYTE *cimage=t->image;
    if (strcmp(t->GetName(),"NONE")){
		fprintf(f,"DEF %s ",t->GetName());
    }
    fprintf(f,"Texture2 {\n");
    WriteTabs(tab+1);
    if (!sp->GenTex) {
	fprintf(f,"filename \"%s\"\n",t->GetFileName());
    }
    else {
	fprintf(f,"image %d %d %d\n",t->width,t->height,t->component);
	if (t->image) {
	    WriteTabs(tab+2);
	    for (i=0;i<t->width*t->height;i++) {
		value=0;
		for (j=0;j<t->component;j++) {
		    // printf("0x%x ",value);
		    value= value | *(cimage);
		    if (j<t->component-1) {
			value=(value<<8);
		    };
		    cimage++;
		};
		fprintf(f,"0x%x ",value);
		cnt++;
		if (cnt>4) {
		    fprintf(f,"\n");
		    WriteTabs(tab+2);
		    cnt=0;
		};
	    };
	    fprintf(f,"\n");
	};
    };
    WriteTabs(tab+1);
    fprintf(f,"wrapS ");
    switch (t->wrapS) {
	case TEXTURE2_WRAP_REPEAT:fprintf(f,"REPEAT\n");break;
	case TEXTURE2_WRAP_CLAMP:fprintf(f,"CLAMP\n");break;
    };
    WriteTabs(tab+1);
    fprintf(f,"wrapT ");
    switch (t->wrapT) {
	case TEXTURE2_WRAP_REPEAT:fprintf(f,"REPEAT\n");break;
	case TEXTURE2_WRAP_CLAMP:fprintf(f,"CLAMP\n");break;
    };
    WriteTabs(tab);
    fprintf(f,"}\n");
}
// Texture2Transform
void VRML2Saver::WriteTexture2Transform(Texture2Transform *tt, int tab) {
    double x,y;

    WriteTabs(tab);
    if (strcmp(tt->GetName(),"NONE")){
		fprintf(f,"DEF %s ",tt->GetName());
    }
    fprintf(f,"Texture2Transform {\n");
    WriteTabs(tab+1);
    tt->translation.Get(x,y);
    fprintf(f,"translation %5.2f %5.2f\n",x,y);
    WriteTabs(tab+1);
    fprintf(f,"rotation %1.8f\n",tt->rotation);
    WriteTabs(tab+1);
    tt->scaleFactor.Get(x,y);
    fprintf(f,"scaleFactor %5.2f %5.2f\n",x,y);
    WriteTabs(tab+1);
    tt->center.Get(x,y);
    fprintf(f,"center %5.2f %5.2f\n",x,y);
    WriteTabs(tab);
    fprintf(f,"}\n");
}
// TextureCoordinate2
void VRML2Saver::WriteTextureCoordinate2(TextureCoordinate2 *tc, int tab) {
    int size=tc->Size();
    Vertex2d *cp;
		   
    WriteTabs(tab);
    if (strcmp(tc->GetName(),"NONE")){
		fprintf(f,"DEF %s ",tc->GetName());
    }
    fprintf(f,"TextureCoordinate2 {\n");
    WriteTabs(tab+1);
    fprintf(f,"point ");
    if (size>1) fprintf(f,"[\n");
    for (int i=0;i<size;i++) {
	cp=tc->point.Get(i);
	WriteTabs(tab+2);
	fprintf(f,"%5.2f %5.2f,\n",cp->coord[0],cp->coord[1]);
    };
    WriteTabs(tab+1);
    if (size>1) fprintf(f,"       ]\n");
    WriteTabs(tab);
    fprintf(f,"}\n");
}
// Transform
void VRML2Saver::WriteTransform(Transform *t, int tab) {
    double x,y,z,a;

    WriteTabs(tab);
    if (strcmp(t->GetName(),"NONE")) {
	fprintf(f,"DEF %s ",t->GetName());
    };
    fprintf(f,"Transform {\n");
    WriteTabs(tab+1);
    t->translation.Get(x,y,z);
    fprintf(f,"translation %5.2f %5.2f %5.2f\n",x,y,z);
    WriteTabs(tab+1);
    t->rotation.Get(x,y,z,a);
    fprintf(f,"rotation    %5.2f %5.2f %5.2f %5.2f\n",x,y,z,a);
    WriteTabs(tab+1);
    t->scaleFactor.Get(x,y,z);
    fprintf(f,"scaleFactor %5.2f %5.2f %5.2f\n",x,y,z);
    WriteTabs(tab+1);
    t->scaleOrientation.Get(x,y,z,a);
    fprintf(f,"scaleOrientation %5.2f %5.2f %5.2f %5.2f\n",x,y,z,a);
    WriteTabs(tab+1);
    t->center.Get(x,y,z);
    fprintf(f,"center      %5.2f %5.2f %5.2f\n",x,y,z);
    WriteTabs(tab);
    fprintf(f,"}\n");
}
// TransformSeparator
void VRML2Saver::WriteTransformSeparator(TransformSeparator *ts, int tab) {
    lastnode=ts->GetChild(ts->Size()-1);
    currentgroup=(VRMLGroups *) ts;

    WriteTabs(tab);
    if (!strcmp(ts->GetName(),"NONE")) {
	fprintf(f,"DEF %s TransformSeparator {\n",ts->GetName());
    }
    else {
	fprintf(f,"TransformSeparator {\n");
    };
    for (int i=0;i<ts->Size();i++) {
	SaveNode(ts->children.Get(i),tab+1);
    };
    WriteTabs(tab);
    fprintf(f,"}\n");
}
// Translation
void VRML2Saver::WriteTranslation(Translation *t, int tab) {
    double x,y,z;
    VRMLNode *ln=lastnode;
    VRMLGroups *cg=currentgroup;

    WriteTabs(tab);
    if (strcmp(t->GetName(),"NONE")) {
	fprintf(f,"DEF %s ",t->GetName());
    };
    fprintf(f,"Transform {\n");
    WriteTabs(tab+1);
    t->translation.Get(x,y,z);
    fprintf(f,"translation %5.2f %5.2f %5.2f\n",x,y,z);
    WriteTabs(tab+1);
    fprintf(f,"children [\n");
    int pos=cg->FindPosition((VRMLNode *) t);
    for (int i=pos+1;i<cg->Size();i++) {
	currentnode=cg->GetChild(i);
	SaveNode(currentnode,tab+2);
	if (currentnode==ln) break;
	pos=cg->FindPosition(currentnode);
	WriteTabs(tab+1);
	fprintf(f,",\n");
    };
    WriteTabs(tab+1);
    fprintf(f,"]\n");
    WriteTabs(tab);
    fprintf(f,"}\n");
}
// WWWAchor
void VRML2Saver::WriteWWWAnchor(WWWAnchor *www, int tab) {
    int i=0;
    lastnode=www->GetChild(www->Size()-1);
    currentgroup=(VRMLGroups *) www;

    WriteTabs(tab);
    if (strcmp(www->GetName(),"NONE")) {
	fprintf(f,"DEF %s ",www->GetName());
    };
    fprintf(f,"WWWAnchor {\n");
    WriteTabs(tab+1);
    fprintf(f,"name \"%s\"\n",www->GetURL());
    WriteTabs(tab+1);
    fprintf(f,"description %s\n",www->GetDescription());
    WriteTabs(tab+1);
    fprintf(f,"map ");
    switch (www->map) {
	case MAP_NONE:fprintf(f,"NONE\n");break;
	case MAP_POINT:fprintf(f,"POINT\n");break;
    };

    for (i=0;i<www->children.Length();i++) {
	SaveNode(www->children.Get(i),tab+1);
    };

    WriteTabs(tab);
    fprintf(f,"}\n");
}
// WWWInline
void VRML2Saver::WriteWWWInline(WWWInline *www, int tab) {
    double x,y,z;
    
    if (sp->GenInlines) {
	if (www->in) SaveNode(www->in,tab+1);
    }
    else {
	WriteTabs(tab);
	if (strcmp(www->GetName(),"NONE")) {
	    fprintf(f,"DEF %s ",www->GetName());
	};
	fprintf(f,"WWWInline {\n");
	WriteTabs(tab+1);
	fprintf(f,"name \"%s\"\n",www->GetURL());
	WriteTabs(tab+1);
	www->bboxSize.Get(x,y,z);
	fprintf(f,"bboxSize   %5.2f %5.2f %5.2f\n",x,y,z);
	WriteTabs(tab+1);
	www->bboxCenter.Get(x,y,z);
	fprintf(f,"bboxCenter %5.2f %5.2f %5.2f\n",x,y,z);
	WriteTabs(tab);
	fprintf(f,"}\n");
    };
}

// USE
void VRML2Saver::WriteUSE(USE *u, int tab) {
    WriteTabs(tab);
    if (strcmp(u->GetName(),"NONE")) {
	fprintf(f,"DEF %s ",u->GetName());
    };
    fprintf(f,"USE %s\n",u->reference->GetName());
}
