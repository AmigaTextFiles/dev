IMPLEMENTATION MODULE Classes ;

FROM SYSTEM IMPORT ADDRESS ;
IMPORT I := Intuition{36} ;

PROCEDURE INST_DATA( cl : IClassPtr ; o : ADDRESS ) : ADDRESS ;
BEGIN RETURN o+cl^.cl_InstOffset ;
END INST_DATA ;

PROCEDURE SIZEOF_INSTANCE( cl : IClassPtr ) : LONGINT ;
BEGIN RETURN ( cl^.cl_InstOffset + cl^.cl_InstSize + SIZE( _Object ) )
END SIZEOF_INSTANCE ;

PROCEDURE _OBJ( o : ADDRESS ) : _ObjectPtr ;
BEGIN RETURN o
END _OBJ ;

PROCEDURE BASEOBJECT( _obj : ADDRESS ) : _ObjectPtr ;
BEGIN RETURN _ObjectPtr( _obj+SIZE(_Object) )
END BASEOBJECT ;

PROCEDURE _OBJECT( o : ADDRESS ) : _ObjectPtr ;
BEGIN RETURN _ObjectPtr( o-SIZE(_Object) )
END _OBJECT ;

PROCEDURE OCLASS( o : _ObjectPtr ) : IClassPtr ;
BEGIN RETURN o^.o_Class
END OCLASS ;

BEGIN I.Intuition_BEGIN( VERSION )
END Classes.
