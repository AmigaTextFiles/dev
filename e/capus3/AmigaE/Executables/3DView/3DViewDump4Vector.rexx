/*=== Test du port Arexx de 3DView ===*/
/*=== © NasGûl ===*/
Options results
/*Numeric Digits 4*/
/*=== Verification de port de 3DView ===*/
IF Show('P','3DVIEW')=0 THEN
    do
	SAY 'Need 3DVIEW'
	exit
    end
Address '3DVIEW'
'LOCKGUI'
'BASE3DINFO'
base=result
Parse var base nbrsobjs' 'totalpts' 'totalfcs
IF nbrsobjs~==0 Then
    Do i=0 TO nbrsobjs-1
	OBJECT3DINFO i
	o=result
	Parse Var o objpts' 'objfcs' 'adrpts' 'adrfcs' 'objname' 'objtype
	SAY objname':=newVectorObject(0,'
	SAY '           'objpts','
	SAY '           'objfcs','

	Do j=0 To objpts-1
	    OBJPTSDATA i j
	    data=result
	    x=Word(result,1)/10
	    y=Word(result,2)/10
	    z=Word(result,3)/10
	    Parse Var x rx'.'p
	    Parse Var y ry'.'p
	    Parse Var z rz'.'p

	    IF j=0 Then
		SAY '            ['rx','ry','rz','
	    Else
		Do
		    IF j=objpts-1 Then
			SAY '             'rx','ry','rz']:INT,'
		    Else
			SAY '            'rx','ry','rz','
		End
	end

	color=1
	Do j=0 To objfcs-1
	    OBJFCSDATA i j
	    v1=Word(result,1)
	    v2=Word(result,2)
	    v3=Word(result,3)
	    IF j=objfcs-1 Then
		say '            'v3','v2','v1','color',[3,'v1','v2','v2','v3','v3','v1']:INT,0]:face)'
	    Else
		Do
		    IF j=0 Then
			say '            ['v3','v2','v1','color',[3,'v1','v2','v2','v3','v3','v1']:INT,0,'
		    Else
			say '            'v3','v2','v1','color',[3,'v1','v2','v2','v3','v3','v1']:INT,0,'
	    IF color=1 Then
		color=2
	    Else
		color=1
	end
    End
'UNLOCKGUI'
exit

