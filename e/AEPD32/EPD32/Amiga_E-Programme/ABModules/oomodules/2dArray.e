OPT MODULE

EXPORT SET CHARS,INTS,LONGS

EXPORT OBJECT dd_array
        sizeX,sizeY
        PRIVATE
        elType,elements
        ENDOBJECT

DEF chars:PTR TO CHAR,
    ints:PTR TO INT,
    longs:PTR TO LONG

PROC create(x,y,elType) OF dd_array
    IF (elType <> CHARS) AND
       (elType <> INTS)  AND
       (elType <> LONGS) THEN Throw("2d",-1)
    self.elements:=NewR(x*y*elType)
    self.sizeX:=(x-1)
    self.sizeY:=(y-1)
    self.elType:=elType
    ENDPROC

PROC checkBounds (x,y) OF dd_array
    IF ((x<0) OR (x>self.sizeX)) THEN Throw("2d",-2)
    IF ((y<0) OR (y>self.sizeY)) THEN Throw("2d",-3)
    ENDPROC

PROC offset(x,y) OF dd_array IS ((x*(self.sizeY+1)+y)*self.elType)

PROC set (x,y,value) OF dd_array
    DEF type
    type:=self.elType
    self.checkBounds(x,y)
    SELECT type
        CASE CHARS
            chars:=self.elements
            chars[self.offset(x,y)]:=value
            self.elements:=chars
        CASE INTS
            ints:=self.elements
            ints[self.offset(x,y)]:=value
            self.elements:=ints
        CASE LONGS
            longs:=self.elements
            longs[self.offset(x,y)]:=value
            self.elements:=longs
        ENDSELECT
    ENDPROC

PROC get (x,y) OF dd_array
    DEF type,value
    type:=self.elType
    self.checkBounds(x,y)
    SELECT type
        CASE CHARS
            chars:=self.elements
            value:=chars[self.offset(x,y)]
        CASE INTS
            ints:=self.elements
            value:=ints[self.offset(x,y)]
        CASE LONGS
            longs:=self.elements
            value:=longs[self.offset(x,y)]
        ENDSELECT
    ENDPROC value

PROC size() OF dd_array IS self.sizeX,self.sizeY

PROC type() OF dd_array IS self.elType

PROC end() OF dd_array
    IF self.elements THEN Dispose(self.elements)
    ENDPROC

