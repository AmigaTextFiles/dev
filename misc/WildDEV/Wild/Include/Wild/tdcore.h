#ifndef	WILD_TDCORE_H
#define	WILD_TDCORE_H

struct Vek
{
 LONG	vek_X;
 LONG	vek_Y;
 LONG	vek_Z;
};

struct RAC
{
 struct Vek	Rel;
 struct Vek	Abs;
 struct Vek	Cam;
};

struct Ref
{
 struct RAC	ref_O;
 struct RAC	ref_I;
 struct RAC	ref_J;
 struct RAC	ref_K;
};

struct WildEntity
{
 struct MinNode		ent_Node;
 struct Ref		ent_Ref;
 struct WildEntity	*ent_Parent;
 ULONG			*ent_Tmp;
 UBYTE			ent_Flags;
 UBYTE			ent_RunTime;
};

#define ENF_DotEntity	0x01

struct WildAlien
{
 struct	WildEntity	ali_Entity;
 struct MinList		ali_Sectors;
};

struct WildSphere
{
 struct Vek		sph_Center;
 ULONG			sph_Radius;
};

struct WildSector
{
 struct WildEntity	sec_Entity;
 struct MinList		sec_Shell;
 struct MinList		sec_Wire;
 struct MinList		sec_Nebula;
 struct WildSphere	sec_Bounds;
 struct WildBSPEntry	*sec_Root;
};

#define SEF_BackFaceTest	0x10

struct WildArena
{
 struct WildAlien	are_Alien;
 struct MinList		are_Aliens;
 struct MinList		are_Lights;
 struct	WildSphere	are_ViewBounds;
 struct	WildSphere	are_InitBounds;
 struct	WildSphere	are_KillBounds;
 struct MinList		are_Doing;		/* Actions in progress... */
};

#define ARF_Hidden		0x01;

struct WildWorld
{
 struct	MinList		wor_Arenas;
 struct WildAlien	*wor_Player;
 struct MinList		wor_Textures;
};

struct WildScene
{
 struct WildWorld	*sce_World;
 struct Ref		sce_Camera;
 ULONG			*sce_Palette;
};

struct WildBSPEntry
{
 struct MinNode		bsp_Node;
 struct WildBSPEntry	*bsp_Plus;
 struct WildBSPEntry	*bsp_Minus;
 UBYTE			bsp_Flags;
 UBYTE			bsp_RunTime;
 UBYTE			bsp_Type;
 UBYTE			bsp_SpecFlags;
 struct BspTmp		*bsp_Tmp;
};

struct WildFace
{
 struct WildBSPEntry	fac_BSP;
 struct WildPoint	*fac_PointA;
 struct WildPoint	*fac_PointB;
 struct WildPoint	*fac_PointC;
 struct WildEdge	*fac_EdgeA;
 struct WildEdge	*fac_EdgeB;
 struct WildEdge	*fac_EdgeC;
 struct WildTexture	*fac_Texture;
 UBYTE			fac_TXA;
 UBYTE			fac_TYA;
 UBYTE			fac_TXB;
 UBYTE			fac_TYB;
 UBYTE			fac_TXC;
 UBYTE			fac_TYC;
};

#define BSPTY_FACE	0
#define BSPTY_BITMAP	1

struct WildEdge
{
 struct MinNode		edg_Node;
 struct WildPoint	*edg_PointA;
 struct WildPoint	*edg_PointB;
 UBYTE			edg_Flags;
 UBYTE			edg_RunTime;
 UBYTE			edg_UseCount;
 UBYTE			edg_RTUseCount;
 struct EdgeTmp		*edg_Tmp;
};

struct WildPoint
{
 struct MinNode		pnt_Node;
 struct Vek		pnt_Vek;
 ULONG			pnt_Color;
 UBYTE			pnt_Flags;
 UBYTE			pnt_RunTime;
 struct PointTmp	*pnt_Tmp;
};

struct WildLight
{
 struct MinNode		lig_Node;
 struct WildPoint	*lig_Point;
 ULONG			lig_Color;
 UWORD			lig_Intensity;
};

struct WildTexture
{
 struct MinNode		tex_Node;
 UBYTE			*tex_Image;
 UBYTE			*tex_Raw;
 struct Hook		tex_Hook;
 ULONG			tex_UserData;
 UWORD			tex_SizeX;
 UWORD			tex_SizeY;
 UBYTE			tex_Flags;
 UBYTE			tex_RunTime;
};

/* about anim, should be a separate thing:
no ali_Doing ! changes all includes, a caos !
and not clear. Better a Doing list of all in the world, but not now. */

#endif
