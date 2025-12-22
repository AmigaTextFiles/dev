*
* CdBSian Obviously Universal & Interactive Nonsense (COUIN)
* (Absurdité CdBSienne Manifestement Universelle et Interactive)
* ©1997-1998, CdBS Software (MORB)
* Equates & structures for playfield stuff
* $Id: Playfield.i 0.7 1997/09/09 00:11:15 MORB Exp MORB $
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
