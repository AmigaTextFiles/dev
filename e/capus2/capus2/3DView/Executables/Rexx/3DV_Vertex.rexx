/*=== Test du port Arexx de 3DView ===*/
/*=== Envoi directement les données a VERTEX par le port Arexx ===*/
/*=== $VER:3DV_Vertex.rexx v0.1 © 1994 NasGûl ===*/
/*== trace ?r ==*/
Options results

/*=== Marche pour les 2 version 1.x (VERTEX1) et 2.0 (VERTEXX) ===*/
vertexport=VERTEX1

/*=== Verification du port de 3DView ===*/
IF Show('P','3DViewPort')=0 THEN 
    do 
        SAY 'Need 3DViewPort'
        exit
    end

/*=== Verification du port de VERTEX ===*/
IF Show('P',''vertexport'')=0 THEN
    DO
        SAY 'Need VERTEXX or VERTEX1'
        exit
    end

/*=== On prend les données de 3DView ===*/
Address '3DViewPort'

'LISTOBJ'            /*=== Donne la liste des noms des objets ===*/
listeobjet=result    /*=== Les noms sont séparés par des espaces ===*/

'NBRSOBJ'            /*=== Donne le nombres d'objets de la base ===*/
nobj=result

DO i=0 TO nobj-1
    'GETNUMINFOOBJ 'i      /*=== Donne les informations sur l'objet numéro i   ===*/
    infoobjet.i=result     /*=== Ces informations sont sous la forme suivante: ===*/
end                        /*=== <NomObjet> <NbrsPts> <NbrsFcs> <AdrDataPts> <AdrDataFcs> <TypeObjet> ===*/



DO i=0 TO nobj-1
    /*=== C'est VERTEX qui travaille ===*/
    Interpret 'Address 'vertexport
    /*=== Stockage des données dans des variables séparées ===*/
    Parse var infoobjet.i nom.i' 'nbrspts.i' 'nbrsfcs.i' 'adrpts.i' 'adrfcs.i' 'type.i
    /*=== ATTENTION VERTEX commence la numérotation des sommets a 1 ===*/
    if i=0 then basepts=1
    SAY '/* Description object : 'infoobjet.i' */'
    adrpts=adrpts.i
    nbrspts=nbrspts.i
    Do j=0 To nbrspts-1
        x.j=x2d(c2x(Import(d2c(adrpts),4)))      /*== Lecture des coord. en x ==*/
        y.j=x2d(c2x(Import(d2c(adrpts+4),4)))    /*== Lecture des coord. en y ==*/
        z.j=x2d(c2x(Import(d2c(adrpts+8),4)))    /*== Lecture des coord. en z ==*/
        'VERTEX 'x.j' 'y.j' 'z.j                 /*== On Ajoute le sommet dans VERTEX ==*/
        adrpts=adrpts+12                         /*== prochain point ==*/
    end
    adrfcs=adrfcs.i
    nbrsfcs=nbrsfcs.i
    Do j=0 To nbrsfcs-1
        v1=x2d(c2x(Import(d2c(adrfcs),4)))       /*== Lecture du 1 sommet ==*/
        v2=x2d(c2x(Import(d2c(adrfcs+4),4)))     /*== Lecture du 2 sommet ==*/
        v3=x2d(c2x(Import(d2c(adrfcs+8),4)))     /*== Lecture du 3 sommet ==*/
        /*== si c'est le premier objet on commence les points a 1 ==*/
        if i=0 then 
            do
                'FACE 'v1+1' 'v2+1' 'v3+1
                'EDGE 'v1+1' 'v2+1
                'EDGE 'v2+1' 'v3+1
                'EDGE 'v3+1' 'v1+1
            end
        /*== Sinon on commence a partir des points déjà existants ==*/
        else
            do
                'FACE 'v1+basepts' 'v2+basepts' 'v3+basepts
                'EDGE 'v1+basepts' 'v2+basepts
                'EDGE 'v2+basepts' 'v3+basepts
                'EDGE 'v3+basepts' 'v1+basepts
            end
        adrfcs=adrfcs+12       /*== Face Suivante ==*/
    end
    'SELECT VERTEX 'basepts    /*== On selectionne le dernier point ==*/
    'SELECT CONNECTED'         /*== Plus tous ceux connectés        ==*/
    'NAME 'nom.i               /*== On les nomment ==*/
    'DESELECT ALL'             /*== On deselectionne tous pour le prochain objet ==*/
    basepts=basepts+nbrspts.i
end
/*== c'est fini .. ==*/
exit


