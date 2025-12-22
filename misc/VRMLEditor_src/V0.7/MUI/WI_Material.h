
#include <inline/exec.h>
#include <libraries/mui.h>
#include <exec/memory.h>


struct ObjWI_Material
{
	APTR	WI_Material;
	APTR	STR_DEFMaterialName;
	APTR	TX_MaterialNum;
	APTR	GR_MatPreview;
	APTR	TX_MaterialIndex;
	APTR	PR_MaterialIndex;
	APTR	BT_MaterialAdd;
	APTR	BT_MaterialDelete;
	APTR	SL_MaterialAR;
	APTR	SL_MaterialAG;
	APTR	SL_MaterialAB;
	APTR	CF_MaterialAmbient;
	APTR	SL_MaterialDR;
	APTR	SL_MaterialDG;
	APTR	SL_MaterialDB;
	APTR	CF_MaterialDiffuse;
	APTR	SL_MaterialSR;
	APTR	SL_MaterialSG;
	APTR	SL_MaterialSB;
	APTR	CF_MaterialSpecular;
	APTR	SL_MaterialER;
	APTR	SL_MaterialEG;
	APTR	SL_MaterialEB;
	APTR	CF_MaterialEmmisive;
	APTR	STR_MaterialShininess;
	APTR	STR_MaterialTransparency;
	APTR	BT_MaterialOk;
	APTR	BT_MaterialDefault;
	APTR	BT_MaterialCancel;
	char *	STR_TX_MaterialNum;
	char *	STR_TX_MaterialIndex;
};

extern struct ObjWI_Material * CreateWI_Material(void);
extern void DisposeWI_Material(struct ObjWI_Material *);
