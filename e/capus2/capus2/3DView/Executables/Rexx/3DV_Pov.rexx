/*=== Test du port Arexx de 3DView ===*/
/*=== Sauve la base de données au format Pov (v0.1) ===*/
/*=== $VER:3DV_Pov.rexx v0.1 © 1994 NasGûl ===*/

Options results
/*=== Verification de port de 3DView ===*/
IF Show('P','3DViewPort')=0 THEN 
    do 
        SAY 'Need 3DViewPort'
        exit
    end
Address '3DViewPort'
'LISTOBJ'
listeobjet=result
'NBRSOBJ'
nobj=result
DO i=0 TO nobj-1
    'GETNUMINFOOBJ 'i
    infoobjet.i=result
end
SAY '/* Liste des objets : 'listeobjet' */'
SAY "/* Nombres d'objets : "nobj'*/'
DO i=0 TO nobj-1
    Parse var infoobjet.i nom.i' 'nbrspts.i' 'nbrsfcs.i' 'adrpts.i' 'adrfcs.i' 'type.i
    SAY '/* Description object : 'infoobjet.i' */'
END
DO i=0 TO nobj-1
    SAY '/* Object n°'i' Nom:'nom.i' */'
    SAY '#declare 'nom.i '='
    SAY 'object {'
    SAY '    union {'
    /*SAY nom.i' 'nbrspts.i' 'nbrsfcs.i' 'adrpts.i' 'adrfcs.i' 'type.i*/
    adrpts=adrpts.i
    nbrspts=nbrspts.i
    Do j=0 To nbrspts-1
        x.j=X2D(C2X(Import(D2C(adrpts),4)))
        y.j=X2D(C2X(Import(D2C(adrpts+4),4)))
        z.j=X2D(C2X(Import(D2C(adrpts+8),4)))
        /*SAY j x.j' 'y.j' 'z.j*/
        adrpts=adrpts+12
    end
    adrfcs=adrfcs.i
    nbrsfcs=nbrsfcs.i
    Do j=0 To nbrsfcs-1
        v1=x2d(c2x(Import(d2c(adrfcs),4)))
        v2=x2d(c2x(Import(d2c(adrfcs+4),4)))
        v3=x2d(c2x(Import(d2c(adrfcs+8),4)))
        SAY '        object{triangle{<'x.v1' 'y.v1' 'z.v1'><'x.v2' 'y.v2' 'z.v2'><'x.v3' 'y.v3' 'z.v3'>}texture{Text_'nom.i'}}'
        adrfcs=adrfcs+12
    end
    SAY '    }'
    SAY '}'
end
exit


