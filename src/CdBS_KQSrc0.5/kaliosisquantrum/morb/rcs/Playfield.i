head	0.7;
access;
symbols;
locks
	MORB:0.7; strict;
comment	@* @;


0.7
date	97.09.09.00.11.15;	author MORB;	state Exp;
branches;
next	0.6;

0.6
date	97.09.08.16.44.39;	author MORB;	state Exp;
branches;
next	0.5;

0.5
date	97.09.01.13.25.43;	author MORB;	state Exp;
branches;
next	0.4;

0.4
date	97.08.31.12.58.09;	author MORB;	state Exp;
branches;
next	0.3;

0.3
date	97.08.31.12.49.10;	author MORB;	state Exp;
branches;
next	0.2;

0.2
date	97.08.22.18.35.17;	author MORB;	state Exp;
branches;
next	0.1;

0.1
date	97.08.22.15.21.16;	author MORB;	state Exp;
branches;
next	0.0;

0.0
date	97.08.22.15.00.33;	author MORB;	state Exp;
branches;
next	;


desc
@Jeu à la beast avec des scrolls partout
RCS for GoldED · Initial login date: Aujourd'hui
@


0.7
log
@Ait sacrifié le sprite 7 sur l'autel du dieu ddfstart. Ait obtenu 16 pixels en récompense. (à gauche)
@
text
@*
* CdBSian Obviously Universal & Interactive Nonsense (COUIN)
* (Absurdité CdBSienne Manifestement Universelle et Interactive)
* ©1997, CdBS Software (MORB)
* Equates & structures for playfield stuff
* $Id: Playfield.i 0.6 1997/09/08 16:44:39 MORB Exp MORB $
*

NbPlanes           = 4

TileWidth          = 1       ; Width of a tile in words
TileHeight         = 16      ; Height of a tile
TileSizeSh         = 7       ; log2(TileWidth*2*TileHeight*NbPlanes)
NbHorTile          = BufferWidth/(TileWidth*2)
NbVerTile          = BufferHeight/TileHeight

MaxMapWidth        = 4096    ; Max. width of map in words

HMargin            = 4       ; Num. extra colmuns of tiles
VMargin            = 4       ; Num. extra rows of tiles

LineSize           = BufferWidth*NbPlanes
BufferWidth        = 40+(TileWidth*HMargin*2)
BufferHeight       = 256+(TileHeight*VMargin)
BufBpSize          = BufferWidth*BufferHeight+MaxMapWidth*2
BufferSize         = BufBpSize*NbPlanes

DataFetchWidth     = 44
Modulo             = BufferWidth*NbPlanes-DataFetchWidth

RMapSize           = NbHorTile*NbVerTile*2
RTblSize           = NbHorTile*NbVerTile*12+4

**** La structure playfield permet de définir une zone qui scrolle avec
**** des blocs, et sur laquelle se trouvent des sprites
**** (une pour chaque plan de scroll)

         rsreset
Playfield          rs.b      0
pf_TilesBank       rs.l      1         ; Pointeur sur les données gfx des
                                       ; blocs
pf_Sprites         rs.l      1         ; Pointeur sur une structure
                                       ; spritesheader (une seule pour
                                       ; le moment)
pf_Map             rs.l      1         ; Pointeur sur la map
pf_OMapAddr        rs.l      1
pf_CMapAddr        rs.l      1         ; Adresse de la position courante
                                       ; du coin supérieur gauche de la map
pf_Width           rs.l      1         ; Largeur de la map
pf_Height          rs.l      1         ; Hauteur de la map
pf_MaxX            rs.l      1
pf_MaxY            rs.l      1
pf_X               rs.l      1         ; Position du coin supérieur gauche
pf_Y               rs.l      1         ; de l'écran par rapport à la map
                                       ; (en pixels SHires)
pf_iX              rs.l      1
pf_iY              rs.l      1
pf_LastX           rs.l      1         ; Position
pf_LastY           rs.l      1         ; précédente
pf_HShift          rs.l      1
pf_DeltaX          rs.l      1
pf_DeltaY          rs.l      1

pf_X16             rs.l      1         ; Position/16 de la map
pf_Y16             rs.l      1         ;
pf_BufY16          rs.l      1         ; Position de départ verticale du
                                       ; buffer bitmap en nombre de tiles

pf_WrapPos         rs.l      1         ; Ordonnée du wrap par rapport au
                                       ; haut de l'écran

pf_BpPtrs          rs.l      1         ; Adresse dans la copperliste des
                                       ; pointeurs bitplanes
pf_BpWPtrs         rs.l      1         ; Idem wrap
pf_WPosPtr         rs.l      1         ; Idem position du wrap

pf_BitmapOffset    rs.l      1
pf_VBitmapOffset   rs.l      1
pf_WBitmapOffset   rs.l      1
pf_MaxBmOffset     rs.l      1

pf_WorkOfst        rs.l      1         ; Bitmap de travail courante
pf_DispOfst        rs.l      1         ; Bitmap affichée
pf_BlitWorkOfst    rs.l      1         ; Bitmap de travail blitter
pf_CpuWorkOfst     rs.l      1         ; Bitmap de travail cpu
pf_Bitmaps         rs.l      3
pf_ClearBuffer     rs.l      1

pf_RefreshTbls     rs.l      3
pf_RefreshPtrs     rs.l      3

pf_LeftRightFlag   rs.b      1
pf_UpDownFlag      rs.b      1

pf_LeftCount       rs.w      1
pf_RightCount      rs.w      1
pf_UpCount         rs.w      1
pf_DownCount       rs.w      1
pf_LBmOffset       rs.l      1
pf_LMapAddr        rs.l      1
pf_LWBmOffset      rs.l      1
pf_LMBmOffset      rs.l      1
pf_RBmOffset       rs.l      1
pf_RMapAddr        rs.l      1
pf_RWBmOffset      rs.l      1
pf_RMBmOffset      rs.l      1
pf_UBmOffset       rs.l      1
pf_UMapAddr        rs.l      1
pf_DBmOffset       rs.l      1
pf_DMapAddr        rs.l      1

pf_Size            rs.b      0

**** La structure spritesheader permet de définir un ensemble de sprites
**** qui sont affichés sur un certain playfield, mais dont la position
**** peut dépendre d'un playfield différent (Hihihi)
**** Cela permet de squatter le playfield du fond pour afficher des sprites
**** qui seront considérés comme faisant partie de l'avant-plan
**** (comme dans BeastII). Ca permet de piquer des couleurs au plan du fond,
**** qui en a besoin de moins que le plan de devant.

         rsreset
SpritesHeader      rs.b      0
sh_First           rs.l      1         ; Pointeur sur le premier sprite
sh_Playfield       rs.l      1         ; Pointeur sur le playfield auquel
                                       ; les positions sont relatives
sh_PosOfst         rs.l      1         ; Offset de la position à mettre
                                       ; à jour
sh_Size            rs.b      0

**** Structure de sprite
**** La position est stockée de manière étrange :
**** Il existe deux structures SpritePos, soit deux paires de coordonnées.
**** L'une d'entre elle correspond à la position d'affichage et est
**** bloquée tant que tous les sprites n'ont pas été redessinés.
**** L'autre correspond à la position actuelle du sprite, qui est mise à
**** jour 50 fois par secondes, même si le rafraîchissement dure plus
**** d'une vbl. Lorsque le rafraîchissement est terminé, on échange les
**** deux paires de coordonnées, en inversant le bit 4 de sh_PosOfst.
**** Ce système permet aux sprites de conserver une vitesse de déplacement
**** constante, quelle que soit la fréquence à laquelle ils sont
**** rafraîchis.

         rsreset
SpritePos          rs.b      0
spp_X              rs.l      1
spp_Y              rs.l      1
spp_Data           rs.l      1         ; Pointeur sur SpriteData de l'image
                                       ; courante
spp_Padding        rs.l      1
spp_Size           rs.b      0

         rsreset
Sprite             rs.b      0
sp_Next            rs.l      1         ; Pointeur sur le sprite suivant
sp_Prev            rs.l      1         ; Pointeur sur le sprite précédent
sp_LastPosOfst     rs.l      1
sp_Pos             rs.b      spp_Size*2
sp_Size            rs.b      0

         rsreset
SpriteData         rs.b      0
spd_Bitmap         rs.l      1         ; Pointeur sur la bitmap
spd_Mask           rs.l      1         ; Masque
spd_WWidth         rs.l      1         ; Largeur en mots
spd_Width          rs.l      1         ; Largeur
spd_Height         rs.l      1         ; Hauteur
spd_Hx             rs.l      1         ; Coordonnées du hot point relatives
spd_Hy             rs.l      1         ; au coin supérieur gauche du sprite
spd_Size           rs.b      0
@


0.6
log
@Quelques modifs pour le scroll parallaxe.
@
text
@d6 1
a6 1
* $Id: Playfield.i 0.5 1997/09/01 13:25:43 MORB Exp MORB $
d23 1
a23 1
BufferWidth        = 36+(TileWidth*HMargin*2)
d28 1
a28 1
DataFetchWidth     = 40
@


0.5
log
@Modifs pour triple buffer
@
text
@d6 1
a6 1
* $Id: Playfield.i 0.4 1997/08/31 12:58:09 MORB Exp MORB $
d9 1
a9 1
NbPlanes           = 5
d60 3
d72 5
d82 1
d87 1
d89 2
a90 11
;pf_CDispBitmap     rs.l      1
;pf_CWorkBitmap     rs.l      1

pf_RMapOffset      rs.l      1
pf_RefreshTblPtr   rs.l      1

pf_DispRefreshMap  rs.l      1
pf_DispRefreshTbl  rs.l      1

pf_WorkRefreshMap  rs.l      1
pf_WorkRefreshTbl  rs.l      1
@


0.4
log
@Ajout d'encore quelques merdasses dans les structures de sprite
@
text
@d5 2
a6 2
* Equates & structures
* $Id: Playfield.i 0.3 1997/08/31 12:49:10 MORB Exp MORB $
d74 7
a80 4
pf_ODispBitmap     rs.l      1
pf_OWorkBitmap     rs.l      1
pf_CDispBitmap     rs.l      1
pf_CWorkBitmap     rs.l      1
d123 1
a127 2
sh_First           rs.l      1         ; Pointeur sur le premier sprite
                                       ; de la liste
d138 1
a138 1
**** deux paires de coordonnées, en inversant le bit 3 de sh_PosOfst.
@


0.3
log
@Deux trois modifs sur les sprites
@
text
@d6 1
a6 1
* $Id: Playfield.i 0.2 1997/08/22 18:35:17 MORB Exp MORB $
d124 2
d152 3
a155 1
sp_CurrentPos      rs.b      spp_Size
@


0.2
log
@Changement RCS ($Id)
@
text
@d6 1
a6 1
* $Id$
d80 2
a82 1
pf_DispRMapPtr     rs.l      1
d84 1
a84 1
pf_DispRTblPtr     rs.l      1
a85 1
pf_WorkRMapPtr     rs.l      1
a86 1
pf_WorkRTblPtr     rs.l      1
d122 2
a123 1
sh_PosOfst         rs.l      1
d151 1
@


0.1
log
@Première version machinchose
@
text
@d2 1
a2 1
* CdBSian Obviously Universal & Interactive Nonsense (COUIN) v0.0
d6 1
a6 2
* $Revision$
* $Date$
@


0.0
log
@*** empty log message ***
@
text
@d6 2
@
