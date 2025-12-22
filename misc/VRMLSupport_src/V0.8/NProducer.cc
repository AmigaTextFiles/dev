/*-----------------------------------------------------------------
  NProducer.cc
  Version 0.1
  Date: 21 june 1998
  Author: BODMER Stephan (bodmer2@uni2a.unige.ch)
  Note: Create a normal node from Coordinate3 and IndexedFaceSet
------------------------------------------------------------------*/
#include <libraries/mui.h>
#include <math.h>

#include <proto/muimaster.h>
#include <proto/alib.h>

#include "NProducer.h"

NProducer::NProducer(ProduceNormalParams *par, Coordinate3 *c, VRMLNode *n) {
    pn=par;
    c3=c;
    node=n;
    WI_Msg=NULL;GA_Msg=NULL;TX_Msg=NULL;
    if (pn->App) {
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
	    MUIA_Window_RefWindow, pn->RefWindow,
	    WindowContents, GroupObject,
		Child, GA_Msg,
		Child, ScaleObject,
		    MUIA_Scale_Horiz, TRUE,
		End,
		Child, TX_Msg,
	    End,
	End;

	DoMethod((Object *) pn->App,OM_ADDMEMBER,WI_Msg);
    };
}

NProducer::~NProducer() {
    if (pn->App) {
	DoMethod((Object *) pn->App,OM_REMMEMBER,WI_Msg);
	MUI_DisposeObject((Object *) WI_Msg);
    };
}

Normal *NProducer::ProduceNormal() {
    PList<void> *pointlist=new PList<void>();
    VList<int> *flist=NULL;
    Face *cf=NULL,*of=NULL;
    int i=0,j=0,k=0,index=0,count=0,ct=0,numface=0,size=0;
    float a=0;
    Vertex3d fnormal=Vertex3d();
    Vertex3d vnormal=Vertex3d();
    Vertex3d onormal=Vertex3d();
    Normal *normal=new Normal("NONE");
    if (node->ID==INDEXEDFACESET_1) {
	IndexedFaceSet *ifs=(IndexedFaceSet *) node;
	size=ifs->Size();
    }
    else {
	IndexedLineSet *ils=(IndexedLineSet *) node;
	size=ils->Size();
    };
    // puts("in ProduceNormal");
    if (WI_Msg) {
	SetAttrs((Object *) TX_Msg, MUIA_Text_Contents, "Sort all faces attached to a vertex");
	SetAttrs((Object *) GA_Msg, MUIA_Gauge_Current,0);
	SetAttrs((Object *) GA_Msg, MUIA_Gauge_Max,size);
	SetAttrs((Object *) WI_Msg, MUIA_Window_Open, TRUE);
    };

    // puts("After the mui output");

    // Allocation of pointlist
    for (i=0;i<c3->Size();i++) {
	pointlist->Add(new VList<int>());
    };

    // Initialisation of pointlist
    for (i=0;i<size;i++,ct++) {
	if (node->ID==INDEXEDFACESET_1) {
	    IndexedFaceSet *ifs=(IndexedFaceSet *) node;
	    cf=ifs->GetFace(i);
	}
	else {
	    IndexedLineSet *ils=(IndexedLineSet *) node;
	    cf=ils->GetLine(i);
	};
	// cf=pn->ifs->GetFace(i);
	for (j=0;j<cf->coordIndex.Length();j++) {
	    index=cf->coordIndex.Get(j);
	    flist=(VList<int> *) pointlist->Get(index);
	    flist->Add(i);
	};
	if (ct>10) {
	    if (WI_Msg) {
		SetAttrs((Object *) GA_Msg, MUIA_Gauge_Current,i);
	    };
	    ct=0;
	};
    };

    /*
    for (i=0;i<pointlist.Length();i++) {
	flist=(VList<int> *) pointlist.Get(i);
	printf("point %d:",i);
	for (j=0;j<flist->Length();j++) {
	    printf("%d ",flist->Get(j));
	};
	printf("\n");
    };
    */

    if (WI_Msg) {
       SetAttrs((Object *) TX_Msg, MUIA_Text_Contents, "Calculating normals");
       SetAttrs((Object *) GA_Msg, MUIA_Gauge_Current,0);
    };

    // puts("Init passed");
    // For each faces
    for (i=0;i<size;i++,ct++) {
	if (node->ID==INDEXEDFACESET_1) {
	    IndexedFaceSet *ifs=(IndexedFaceSet *) node;
	    cf=ifs->GetFace(i);
	}
	else {
	    IndexedLineSet *ils=(IndexedLineSet *) node;
	    cf=ils->GetLine(i);
	};
	// cf=pn->ifs->GetFace(i);
	cf->normalIndex.ClearList();
	// printf("face %d\n",i);
	if (cf->coordIndex.Length()>2) {
	    onormal=GenerateNormal(c3->GetPoint(cf->coordIndex.Get(0)),
				   c3->GetPoint(cf->coordIndex.Get(1)),
				   c3->GetPoint(cf->coordIndex.Get(2)));
	}
	else {
	    onormal.Set(0,1.0,0);
	};
	// printf("initial normal:%f %f %f\n",onormal.coord[0],onormal.coord[1],onormal.coord[2]);

	// For all points of this face
	for (j=0;j<cf->coordIndex.Length();j++) {
	    index=cf->coordIndex.Get(j);
	    flist=(VList<int> *) pointlist->Get(index);
	    // printf("vertex %d:index %d\n",j,index);
	    vnormal=onormal;
	    // Check all faces for this vertex
	    for (k=0;k<flist->Length();k++) {
		numface=flist->Get(k);
		// printf("numface=%d\n",numface);
		if (numface!=i) {
		    if (node->ID==INDEXEDFACESET_1) {
			IndexedFaceSet *ifs=(IndexedFaceSet *) node;
			of=ifs->GetFace(numface);
		    }
		    else {
			IndexedLineSet *ils=(IndexedLineSet *) node;
			of=ils->GetLine(numface);
		    };
		    // of=pn->ifs->GetFace(numface);

		    if (of->coordIndex.Length()>2) {
			fnormal=GenerateNormal(c3->GetPoint(of->coordIndex.Get(0)),
					       c3->GetPoint(of->coordIndex.Get(1)),
					       c3->GetPoint(of->coordIndex.Get(2)));
			// printf("fnormal:%f %f %f\n",fnormal.coord[0],fnormal.coord[1],fnormal.coord[2]);
			a=FindAngle(vnormal,fnormal);
			if (a<=pn->angle) {
			    // puts("ajout");
			    vnormal.coord[0]+=fnormal.coord[0];
			    vnormal.coord[1]+=fnormal.coord[1];
			    vnormal.coord[2]+=fnormal.coord[2];
			    float norme=FindNorme(vnormal);
			    vnormal.coord[0]=vnormal.coord[0]/norme;
			    vnormal.coord[1]=vnormal.coord[1]/norme;
			    vnormal.coord[2]=vnormal.coord[2]/norme;
			};
		    };
		}; // end if index!=i
	    };
	    // printf("ADDED NORMAL:%f %f %f\n",vnormal.coord[0],vnormal.coord[1],vnormal.coord[2]);
	    normal->AddVector(new Vertex3d(vnormal));
	    cf->normalIndex.Add(count);
	    count++;
	    // vnormal.Set(0,0,0);
	};
	if (ct>10) {
	    // printf("update:%d\n",i);
	    if (WI_Msg) {
		SetAttrs((Object *) GA_Msg, MUIA_Gauge_Current,i);
	    };
	    ct=0;
	};
    };
    if (node->ID==INDEXEDFACESET_1) {
	IndexedFaceSet *ifs=(IndexedFaceSet *) node;
	ifs->writeNormalIndex=1;
    }
    else {
	IndexedLineSet *ils=(IndexedLineSet *) node;
	ils->writeNormalIndex=1;
    };

    delete pointlist;
    if (WI_Msg) {
	SetAttrs((Object *) WI_Msg, MUIA_Window_Open, FALSE);
    };
    return normal;
}

Vertex3d NProducer::GenerateNormal(Vertex3d *point1, Vertex3d *point2, Vertex3d *point3) {
    Vertex3d vec1=Vertex3d(point2->coord[0]-point1->coord[0],
			   point2->coord[1]-point1->coord[1],
			   point2->coord[2]-point1->coord[2]);
    Vertex3d vec2=Vertex3d(point3->coord[0]-point1->coord[0],
			   point3->coord[1]-point1->coord[1],
			   point3->coord[2]-point1->coord[2]);
    Vertex3d normalvec=Vertex3d(
		    vec1.coord[1]*vec2.coord[2]-vec1.coord[2]*vec2.coord[1],
		    vec1.coord[2]*vec2.coord[0]-vec1.coord[0]*vec2.coord[2],
		    vec1.coord[0]*vec2.coord[1]-vec1.coord[1]*vec2.coord[0]
		    );
    float norme=FindNorme(normalvec);
    normalvec.coord[0]=normalvec.coord[0]/norme;
    normalvec.coord[1]=normalvec.coord[1]/norme;
    normalvec.coord[2]=normalvec.coord[2]/norme;
    return normalvec;
}

float NProducer::FindNorme(Vertex3d n) {
    float norme=sqrt(n.coord[0]*n.coord[0]+
		     n.coord[1]*n.coord[1]+
		     n.coord[2]*n.coord[2]);
    return norme;
}

float NProducer::FindAngle(Vertex3d n1, Vertex3d n2) {
    float ta=0,tb=0,tc=0,tt=0,cosa=0,a=0;
    ta=n1.coord[0]*n2.coord[0]+n1.coord[1]*n2.coord[1]+n1.coord[2]*n2.coord[2];
    tb=n1.coord[0]*n1.coord[0]+n1.coord[1]*n1.coord[1]+n1.coord[2]*n1.coord[2];
    tc=n2.coord[0]*n2.coord[0]+n2.coord[1]*n2.coord[1]+n2.coord[2]*n2.coord[2];
    tt=sqrt(tb*tc);
    cosa=ta/tt;
    a=(180.0*acos(cosa))/3.1415;
    // printf("angle:%.4f\n",a);
    return a;
}
