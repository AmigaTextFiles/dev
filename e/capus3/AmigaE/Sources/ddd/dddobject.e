->> EDEVHEADER
/*= © NasGûl ==========================
 ESOURCE dddobject.e
 EDIR    Workbench:AmigaE/Sources/3DView/3DLib
 ECOPT   ERRLINE
 EXENAME dddobject.m
 MAKE    BUILD
 AUTHOR  NasGûl
 TYPE    EMOD
=====================================*/
-><
->> ©/DISTRIBUTION/UTILISATION
/*=====================================

 - TOUTE UTILISATION COMMERCIALE DES CES SOURCES EST
   INTERDITE SANS MON AUTORISATION.

 - TOUTE DISTRIBUTION DOIT ETRE FAITES EN TOTALITE (EXECUTABLES/MODULES E/SOURCES E).

 !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
 !! TOUTE INCLUSION SUR UN CD-ROM EST INTERDITE SANS MON AUTORISATION.!!
 !! SEULES LES DISTRIBUTIONS DE FRED FISH ET AMINET CDROM SONT AUTO-  !!
 !! RISES A DISTRIBUER CES PROGRAMMES/SOURCES.                        !!
 !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

=====================================*/
-><
OPT MODULE
OPT EXPORT
MODULE 'exec/nodes'  -> les objets sont chainés dans une liste Exec (lh).
->> Constantes
->> ID IMAGINE -> chunk propre a Imagine.

CONST ID_FORM=$464F524D
CONST ID_TDDD=$54444444
CONST ID_SIZE=$53495A45
CONST ID_NAME=$4E414D45
CONST ID_PNTS=$504E5453
CONST ID_EDGE=$45444745
CONST ID_FACE=$46414345
-><
->> ID SCULPT  -> chunk propre a Sculpt.
CONST ID_SC3D=$53433344
CONST ID_VERT=$56455254
-><
->> ID 3D2 -> chunk propre a CyberStudio (ATTENTION INT).

CONST ID_3D2=$3D02
CONST ID_3D3D=$3D3D

-><
->> ID_VERTEX -> chunk propre a Vertex.
CONST ID_VR3D=$56523344 -> v1.62 et <.
CONST ID_VE3D=$56453344 -> v1.73 et >.
CONST ID_3DDD=$33444444 -> v2.0 .
-><
->> ID 3Dpro -> chunk propre a 3DPro.

CONST ID_3DPRO=$43533344
-><
->> ID LightWave -> chunk propre a LightWave (non utilisé car non trouvé).

CONST ID_LWOB=$4C574F42
CONST ID_POLS=$504F4C53
-><
->> VUE -> constantes définisant le plan de vue de la base 3D.

ENUM PLAN_XOY,PLAN_XOZ,PLAN_YOZ
-><
->> AXE DE LA BASE -> constantes définisant les axes de la base 3D pour les rotations.

ENUM AXE_X,AXE_Y,AXE_Z
-><
->> MODE DE DESSIN -> Constantes définisant le mode de dessin de la base 3D.

ENUM DRAW_PTS,DRAW_FCS,DRAW_PTSFCS
-><>

->=<<<<<<<<<<<<<<< -> Constantes définisant le format de sauvegarde de la base 3D,
->= CTS SAUVEGARDE -> ainsi que les objets a sauvegarder (base3d.savewhat).
->=<<<<<<<<<<<<<<<
ENUM SAVEOBJ_ALL,SAVEOBJ_SEL,SAVEOBJ_DES
ENUM SAVE_DXF,SAVE_GEO,SAVE_RAY,SAVE_BIN,SAVE_POV1,SAVE_POV2

->=<<<<<<<<<<<<< -> Type d'objets fichiers et primitives calculées.
->= TYPE D'OBJET
->=<<<<<<<<<<<<<
ENUM TYPE_IMAGINE,TYPE_OLDCYBER,TYPE_NEWCYBER,TYPE_SCULPT,TYPE_OLDVERTEX,
     TYPE_NEWVERTEX,TYPE_3DPRO,TYPE_LIGHTWAVE,TYPE_VERTEX2,
     PRIM_TORUS,PRIM_MOEBIUS,PRIM_PLAN,PRIM_TRBL,PRIM_SPHERE,
     PRIM_SPIRALE,PRIM_VAGUES,PRIM_CYLINDRE,PRIM_CONED,PRIM_DOME,
     PRIMD_CUBE,PRIMD_TETRA,PRIMD_OCTA,PRIMD_DODECA,PRIMD_ICOSA,
     PRIMD_OCTATRONQUE,PRIMD_CUBO,TYPE_UNKNOWN
    /*
    Les types de fichier suivent cette règle:
        TYPE_<nom>  type d'objet en fichier
        PRIM_<nom>  type d'objet calculé.
        PRIMD_<nom> type d'objet en données fixe.
    */
->=<<<<<<<<<<<<<<<<<<<<<<<<<<<<
->= CONSTANTE D'ARRET DU DESSIN
->=<<<<<<<<<<<<<<<<<<<<<<<<<<<<
CONST STOP_DRAWING=1
->=<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
->= CONSTANTE POUR LA GENERATION DES FACES ET LA CONVERTION VECTORIELLE
->=<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
CONST FV_INDIRECT=0
CONST FV_DIRECT=1
CONST FV_DOUBLE=2
CONST VECTOR_LIB=0,VECTOR_MOD=1
-><
->> Objets
->=<<<<<<<<
->= OBJECTS
->=<<<<<<<<
->=<<<<<<<<<<<<<<<<<<<<<
->= Structure de la base
->=<<<<<<<<<<<<<<<<<<<<<
->****************************************************************
-> Certaines valeurs sont initialisées lors de l'appel de init3DBase()
-> (voir 3Dload.e<PROC init3DBase()>)
-> ATTENTION certaines valeur sont flottantes d'autres non.
-> les pointeurs suivi de * sont privés,vous pouvez les lire sans prôblème
-> mais si vous faites des changements c'est a vos risques et perils.
-> Les autres servent aux diverses fonctions donc configurable.
->****************************************************************
->> OBJECT base3d
OBJECT base3d
    nbrsobjs:LONG     -> nombres total d'objets.  *
    totalpts:LONG     -> nombres total de points. *
    totalfcs:LONG     -> nombres total de faces.  *
    objlist:LONG      -> adresse de la liste Exec contenant les objets. *
    fctoldcyber:LONG      -> facteur 3D a appliqué lors du chargement d'objet Cyber v1.0 (float)
    fctnewcyber:LONG      ->  "                                          "    Cyber v2.0 (float)
    fct3dpro:LONG     ->  "                                          "    3DPro      (float)
    fctsculpt:LONG    ->  "                                          "    Sculpt     (float)
    fctimagine:LONG   ->  "                                          "    Imagine    (float)
    fctvertex:LONG    ->  "                                          "    Vertex     (float)
    vectorfactor:LONG     -> facteur 3D pour la savegarde en BIN.
    minx:LONG         -> minimum en x de la base 3D                  (float) *
    maxx:LONG         -> maximum en x de la base 3D                  (float) *
    miny:LONG         -> minimum en y de la base 3D                  (float) *
    maxy:LONG         -> maximum en y de la base 3D                  (float) *
    minz:LONG         -> minimum en z de la base 3D                  (float) *
    maxz:LONG         -> maximum en z de la base 3D                  (float) *
    echelle:LONG      -> echelle de représentation                   (float)
    plan:LONG         -> plan de vue (PLAN_XOY,PLAN_YOZ,PLAN_XOZ)
    basecx:LONG       -> centre x de la base 3D                  (float)  *
    basecy:LONG       -> centre y de la base 3D                  (float)  *
    basecz:LONG       -> centre z de la base 3D                  (float)  *
    signex:LONG       -> multiplicateur pour le dessin (1.0 ou -1.0),                (float)
    signey:LONG       -> ceci permet d'inverser le dessin sans toucher au points.    (float)
    signez:LONG       -> (en x y et z).                                              (float)
    format:LONG       -> défini la constante largueur/hauteur            (float)  *
    centrex:LONG      -> centre x de l'ECRAN (dépendant de la résolution).                    *
    centrey:LONG      -> centre y de l'ECRAN (idem)                                           *
    draw_x:LONG       -> Cadre du clipping calculée avec la fonction formatBase3DWithWindow() *
    draw_y:LONG       ->
    draw_w:LONG       ->
    draw_h:LONG       ->
    stopcode:LONG     -> code pour l'arret du dessin
    anglerotation:LONG    -> angle de rotation (pour chaque appel a une rotation).       (float)
    palette:LONG      -> Palette
    rgbpts:INT        -> couleur points
    rgbnormal:INT     -> couleur faces
    rgbselect:INT     -> couleur select
    rgbbounding:INT   -> couleur de l'encadrement
    drawmode:LONG     -> mode de dessin
    saveformat:INT    -> format de sauvegarde (SAVE_DXF,SAVE_GEO,SAVE_RAY,SAVE_BIN).
    savewhat:INT      -> séléction de sauvegarde (SAVEOBJ_ALL,SAVEOBJ_SEL,SAVEOBJ_DES).
    freedata:LONG     -> data pour la libération de la mémoire lors de l'éffacement d'un objet. *
    formatname:PTR TO LONG -> data contenant les noms des formats supportés. *
ENDOBJECT
-><
->=<<<<<<<<<<<<<<<<<<<<<
->= Structure d'un objet
->=<<<<<<<<<<<<<<<<<<<<<
->> OBJECT object3
OBJECT object3d
    obj_node:ln     -> noeud exec (ln.name contient le nom de l'objet sinon objet_<num>.  *
    nbrspts:LONG    -> nombres de points de l'objet.                                      *
    nbrsfcs:LONG    -> nombres de faces de l'objet.                                       *
    datapts:LONG    -> adresse des points.                        *
    datafcs:LONG    -> adresse des faces.                         *
    typeobj:LONG    -> type de l'objet (TYPE_<nom>).                                      *
    objcx:LONG      -> centre de l'objet. (float)                                         *
    objcy:LONG      ->                                    *
    objcz:LONG      ->                                    *
    objminx:LONG    -> objet mini et maxi en x,y,z. (float)                               *
    objmaxx:LONG    ->                                    *
    objminy:LONG    ->                                    *
    objmaxy:LONG    ->                                    *
    objminz:LONG    ->                                    *
    objmaxz:LONG    ->                                    *
    selected:LONG -> objet séléctionné ? (TRUE/FALSE).
    bounded:LONG  -> objet encadré ? (TRUE/FALSE).
ENDOBJECT
-><
->=<<<<<<<<<<<<<<<<<<<<<
->= Structure d'un point
->=<<<<<<<<<<<<<<<<<<<<<
->> OBJECT vertice
OBJECT vertice
      x:LONG        -> flottant.
      y:LONG        -> flottant.
      z:LONG        -> flottant.
ENDOBJECT
-><
->=<<<<<<<<<<<<<<<<<<<<<
->= Structure d'une face
->=<<<<<<<<<<<<<<<<<<<<<
->> OBJECT fc
OBJECT fc
      v1:LONG
      v2:LONG
      v3:LONG
ENDOBJECT
-><
-><
->> Erreurs
CONST ERR3D_NONE=TRUE
ENUM  ERR3D_MEM,
      ERR3D_MATHLIB,
      ERR3D_NOFILE,
      ERR3D_UNKNOWNFILE,
      ERR3D_NODIR,
      ERR3D_CONVVECTOR,
      ERR3D_NOVECTORLIB,
      ERR3D_WRONGPRIMTYPE,
      ERR3D_OPEN
-><
