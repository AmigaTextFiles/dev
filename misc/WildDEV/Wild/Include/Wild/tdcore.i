
	IFND	WILTDCore
WILTDCore	SET	1

		include	utility/hooks.i
		include	wild/wild.i

		STRUCTURE	WildTDCoreModuleBASE,wm_SIZEOF
			LABEL	wtdm_SIZEOF

_LVOTDCChildToBrother	EQU	-60		; A(B(?))=C(?) A0:A(Child),A1:B(Parent),A2:C(NewBrother)
_LVOTDCBrotherToChild	EQU	-66		; A(?)=C(B(?)) A0:A(Brother),A1:B(Brother,becomes Parent),A2:C(New child)
_LVOTDCRealyze		EQU	-72		; A0:App

; Notes about these structs, WROTE AFTER THE TYPE CONCEPT INTRODUCTION.
; If everything can change, with types, why these are fixed ?
; These are fixed because:
; - i think they are quite good, and won't need to be touched for a quite long time.
; - if also these change, what is fix in wild ? It would became a useless thing:
;   would not offer any standard.
; - the math I want is this.
; - these structs are also used by apps, directly and indireclty. So, if they change,
;   compatibility with the past is loss.
; - I WANT THESE STUPID NAMES TO BE USED BY THE WORLD !!!!! (shell,wire,NEBULA..! how long idiot may the mind of this coder be to call them like that?...)
; But, in fact, it's not true that these are not changeable.
; Soft changings, in fact, like using another math (floating point!?) may be done by
; using a new TYPE of TDCore. Nobody said the 32bit fields must be 16.16 or 32.0 integers. May be single precision floats.
; BUT, also the program calling WILD must know. Maybe using a TYPE flag also with applications.
; BUT, this may be the future. NOW, i don't want to think on.

		STRUCTURE	Vek,0
			LONG	vek_X
			LONG	vek_Y
			LONG	vek_Z
			LABEL	Vek_SIZE

		STRUCTURE	RAC,0
			STRUCT	Rel,Vek_SIZE
			STRUCT	Abs,Vek_SIZE
			STRUCT	Cam,Vek_SIZE
			LABEL	rac_SIZE
	
		STRUCTURE	Ref,0
			STRUCT	ref_O,rac_SIZE
			STRUCT	ref_I,rac_SIZE
			STRUCT	ref_J,rac_SIZE
			STRUCT	ref_K,rac_SIZE
			LABEL	Ref_SIZE
			
		STRUCTURE	Entity,MLN_SIZE
			STRUCT	ent_Ref,Ref_SIZE		
			APTR	ent_Parent			; points to parent entity
			APTR	ent_Tmp			; tmp data, specific for any entity, created freely by tdcores if they need. UNUSED DIRECTLY BY WILD!
			BYTE	ent_Flags
			BYTE	ent_RunTime
			LABEL	Entity_SIZE			

		STRUCTURE	DotEntity,MLN_SIZE		; !! DotEntity may ONLY be child, not parent of nothing !
			STRUCT	den_Pos,Ref_SIZE		; Here there is only O, no i,j,k ! it's a dot !
			APTR	den_Parent
			APTR	den_Tmp
			BYTE	den_Flags
			BYTE	den_RunTime
			LABEL	DotEntity_SIZE	; NOTE: DotEntity&Entity have SAME STRUCT! Only data changes: the Pos has only the ref_O,no more.

	BITDEF	EN,DotEntity,0			; That's a dot entity. 
			
		STRUCTURE	Moving,0
			STRUCT	mov_V,Ref_SIZE
			STRUCT	mov_A,Ref_SIZE
			LABEL	Moving_SIZE
			
		STRUCTURE	Alien,Entity_SIZE
			STRUCT	ali_Sectors,MLH_SIZE			
			LABEL	Alien_SIZE
		
		STRUCTURE	Sphere,0
			STRUCT	sph_Center,Vek_SIZE
			LONG	sph_Radius
			LABEL	Sphere_SIZE
			
		STRUCTURE	Sector,Entity_SIZE
			STRUCT	sec_Shell,MLH_SIZE		; these are all the bspentries!
			STRUCT	sec_Wire,MLH_SIZE		; these are all the edges!
			STRUCT	sec_Nebula,MLH_SIZE		; these are all the points!
			STRUCT	sec_Bounds,Sphere_SIZE
			APTR	sec_Root			; root bspentry (NOT A DOT ONE !!!)
			LABEL	sec_SIZE

; read this flags in ent_flags

	BITDEF	SE,BackFaceTest,4				; hide backfaces ? (to use with solid sectors, mean closed, without holes.)
		
		STRUCTURE	Arena,Alien_SIZE
			STRUCT	are_Aliens,MLH_SIZE
			STRUCT	are_Lights,MLH_SIZE
			STRUCT	are_ViewBounds,Sphere_SIZE	; Fuori da questa sfera, è invisibile l'arena
			STRUCT	are_InitBounds,Sphere_SIZE	; Quando si entra in questa sfera, l'arena viene inizializzata
			STRUCT	are_KillBounds,Sphere_SIZE	; Quando il player esce da questa sfera, l'arena viene tolta dalla memoria (deve essere + grande della init!)
			LABEL	Arena_SIZE

; read this flags in ent_flags

	BITDEF	ARE,Hidden,0					; That is hidden.
	
		STRUCTURE	World,0
			STRUCT	wor_Arenas,MLH_SIZE
			APTR	wor_Player			; Pointer to the player's alien, a SUPERALIEN!
			STRUCT	wor_Textures,MLH_SIZE
			LABEL	World_SIZE						
		
		STRUCTURE	Scene,0
			APTR	sce_World			
			STRUCT	sce_Camera,Ref_SIZE
			APTR	sce_Palette
			LABEL	Scene_SIZE				

		STRUCTURE	BSPEntry,MLN_SIZE
			APTR	bsp_Plus
			APTR	bsp_Minus
			BYTE	bsp_Flags			
			BYTE	bsp_RunTime
			BYTE	bsp_Type	
			BYTE	bsp_SpecFlags		; those are specific flags: Face flags for faces, bmp flags for bmp... 
			APTR	bsp_Tmp
			LABEL	bsp_SIZE

; read those in bsp_Flags
	BITDEF	BSP,DotEntry,0		;That's a dot entry: only 1 point, never split.
	BITDEF	BSP,CustomEntry,1	;For a FAR future: no 1 dot, no 3 dot, what is this?

; read those in bsp_Type	
BSPTY_FACE	EQU	0
BSPTY_BITMAP	EQU	1

; FOR now, NON-Dot entries (and non-Custom, but these are not existant now) MUST
; HAVE THE First 3 pointers to points like face! Are used to calc I,J,K and select
; bsp-order.
		
		STRUCTURE	Face,bsp_SIZE
			APTR	fac_PointA
			APTR	fac_PointB
			APTR	fac_PointC
			APTR	fac_EdgeA
			APTR	fac_EdgeB
			APTR	fac_EdgeC
			APTR	fac_Texture
			BYTE	fac_TXA
			BYTE	fac_TYA
			BYTE	fac_TXB
			BYTE	fac_TYB
			BYTE	fac_TXC
			BYTE	fac_TYC
			LABEL	fac_SIZE

; read those in bsp_SpecFlags

	BITDEF	FAC,NoTexture,0		; no texture for this face: must be drawn as plain coloured.
	BITDEF	FAC,NoShading,1		; no shading for this face: must be drawn as flat illuminated.
	BITDEF	FAC,Bright,2		; this face is wanted to have a fixed full luminance.
	
		
		STRUCTURE	DotEntry,bsp_SIZE	; Any dot entry must have this (to insert in a bsp tree...)
			APTR	dot_Point
			LABEL	dot_SIZE
					
		STRUCTURE	Edge,MLN_SIZE
			APTR	edg_PointA
			APTR	edg_PointB
			BYTE	edg_Flags
			BYTE	edg_RunTime
			BYTE	edg_UseCount		; How many faces use this edge ?
			BYTE	edg_RTUseCount		; To fill this hole, use that.
			APTR	edg_Tmp	
			LABEL	edg_SIZE
				
		STRUCTURE	Point,MLN_SIZE
			STRUCT	pnt_Vek,Vek_SIZE
			LONG	pnt_Color
			BYTE	pnt_Flags
			BYTE	pnt_RunTime
			APTR	pnt_Tmp
			LABEL	pnt_SIZE	
			
		STRUCTURE	Light,MLN_SIZE
			APTR	lig_Point		; Point (from any nebula) of the lightsource
			LONG	lig_Color		; for who uses... (nb: rgb also define the intensity of the light: $7f0000 is half intense than $ff0000)
			WORD	lig_Intensity		; if the engine does not support colorlights, this is used. (0-255) Usually is MAX(R,G,B) or (R+G+B)/3. Depending on your needings,try some values.

; IMPORTANT: To specify an Ambient light, insert the negative Intensity !!!
; If you use a Intensity lighting, this will be added (the ABS value) to any
; face or point you have. If you use a Color lighting, the Color will be added
; with the ABS of intensity to any face or point.

		STRUCTURE	Texture,MLN_SIZE	; in the World's list...
			APTR	tex_Image
			APTR	tex_Raw			; the raw image loaded by the loadtexture routine. ($AARRGGBB 32bit chunky!)
			STRUCT	tex_Hook,h_SIZEOF	; Hook to load or free the texture (in the tex_Raw)
			APTR	tex_UserData
			WORD	tex_SizeX
			WORD	tex_SizeY
			BYTE	tex_Flags
			BYTE	tex_RunTime
			LABEL	tex_SIZE

; The hook's data MUST make the hook able to re-load the texture in any time.

; Textures are loaded in the InitScene, then Draw's InitTexture is called for each,
; and it will do anything wants on the texture loaded, passed by param.
; The texture passed to the InitTexture of draw is filled with: Raw,Size(X&Y),Palette
; InitTexture MUST COPY THE Texture in HIS Image MEM, AND FILL tex_Image,
; This allow it to do everything: converting 24bit to
; 256 colors,remap,distorce,burn, anything.
; Then, the Raw image is freed, so Draw MUST WORK ON the tex_Image copy !!
; Maybe also the palette will be freed. So, tex_Image MUST BE ENOUGH FOR Draw to work!
; May even refer to an internal struct, not an image, because Draw is free to do anything.
; But do!
		
DefAbs		MACRO 	;x,y,z (consts). Abs is x,y,z. Rel&Cam are 0
		dc.l	0,0,0
		dc.l	\1,\2,\3
		dc.l	0,0,0
		ENDM
		
DefRel		MACRO	;x,y,z (consts). Rel is x,y,z. Abs&Cam are 0
		dc.l	\1,\2,\3
		dc.l	0,0,0
		dc.l	0,0,0
		ENDM
							
QuickRefRel	MACRO	;x,y,z (consts). i,j,k are normal versors. (1,0,0 0,1,0 0,0,1)				
		DefRel	\1,\2,\3
		DefRel	1<<16,0,0
		DefRel	0,1<<16,0
		DefRel	0,0,1<<16
		ENDM

QuickRefAbs	MACRO	;x,y,z (consts). i,j,k normal versors. Used to define camera.
		DefAbs	\1,\2,\3
		DefAbs	1<<16,0,0
		DefAbs	0,1<<16,0
		DefAbs	0,0,1<<16
		ENDM	

ListHeader	MACRO	;name,first,last
\1_Head		dc.l	\2
\1_Tail		dc.l	0,\3
		ENDM

DefSector	MACRO	;name,succ,pred,parent	*** OBSOLETE
\1_Succ		EQU	\2			*** OBSOLETE
\1_Pred		EQU	\3			*** Use Make&Link&Pos macros !
\1_Parent	EQU	\4
		ENDM

MakeSector	MACRO	;name,file
		IFND	\1_Made
\1_Made		SET	1
		include	\2
		ENDC
		ENDM

LinkSector	MACRO	;name,succ,pred,parent
		IFD	\1_Made	
		IFND	\1_Linked
\1_Linked	SET	1
\1_Succ		EQU	\2
\1_Pred		EQU	\3
\1_Parent	EQU	\4
		ENDC
		ENDC
		ENDM

PosSector	MACRO	;name,x,y,z
		IFD	\1_Made
		IFND	\1_Positioned
\1_Positioned	SET	1
\1_PosX		EQU	\2
\1_PosY		EQU	\3
\1_PosZ		EQU	\4
		ENDC
		ENDC
		ENDM
		
; How to use these macros, if you do manually:
; FIRST, Make ALL THE SECTORS !
; Then, Link and Pos them as you want.
; You must make all before because on DevPac (and i think all
; other assemblers, but i don't know...) you can't do a 
; EQUate to a forward label.
		
;---------------------------------------------------------------------------------------
; Now there are the definitions of the Type 1 of Tmp buffers. That are the first I
; implement. My first TDCores will use these. If I'll find better things, i'll create
; a type 2,3,4... tmp buffers. The Light, the Broker willl receive this tmps, and they
; will REQUIRE them. That's to make an absolute compatibility but even a possibility
; to expand or totally rewrite in the future.
;---------------------------------------------------------------------------------------

	ENDC