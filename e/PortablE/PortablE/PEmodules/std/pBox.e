/* pBox.e
*/

OPT NATIVE, INLINE

PRIVATE
CLASS box
ENDCLASS
PROC new() OF box IS EMPTY
PUBLIC


PRIVATE
CLASS boxPTR OF box
	data:PTR
ENDCLASS
PUBLIC
PROC BoxPTR(data:PTR) RETURNS box:OWNS PTR TO class
	DEF new:OWNS PTR TO boxPTR
	NEW new.new()
	new.data := data
	box := PASS new
ENDPROC
PROC UnboxPTR(box:PTR TO class) IS IF box THEN box::boxPTR.data ELSE NIL
PROC ReplaceBoxPTR(box:PTR TO class, data:PTR) RETURNS oldData:PTR
	oldData := box::boxPTR.data
	box::boxPTR.data := data
ENDPROC

PRIVATE
CLASS boxARRAY OF box
	data:ARRAY
ENDCLASS
PUBLIC
PROC BoxARRAY(data:ARRAY) RETURNS box:OWNS PTR TO class
	DEF new:OWNS PTR TO boxARRAY
	NEW new.new()
	new.data := data
	box := PASS new
ENDPROC
PROC UnboxARRAY(box:PTR TO class) IS IF box THEN box::boxARRAY.data ELSE NILA
PROC ReplaceBoxARRAY(box:PTR TO class, data:ARRAY) RETURNS oldData:ARRAY
	oldData := box::boxARRAY.data
	box::boxARRAY.data := data
ENDPROC


PRIVATE
CLASS boxSTRING OF box
	data:OWNS STRING
ENDCLASS
PROC end() OF boxSTRING
	END self.data
	SUPER self.end()
ENDPROC
PUBLIC
PROC BoxSTRING(data:OWNS STRING) RETURNS box:OWNS PTR TO class
	DEF new:OWNS PTR TO boxSTRING
	NEW new.new()
	new.data := PASS data
	box := PASS new
ENDPROC
PROC UnboxSTRING(box:PTR TO class) IS IF box THEN box::boxSTRING.data ELSE NILS
PROC ReplaceBoxSTRING(box:PTR TO class, data:OWNS STRING) RETURNS oldData:OWNS STRING
	oldData := PASS box::boxSTRING.data
	box::boxSTRING.data := PASS data
ENDPROC

PRIVATE
CLASS boxLIST OF box
	data:OWNS LIST
ENDCLASS
PROC end() OF boxLIST
	END self.data
	SUPER self.end()
ENDPROC
PUBLIC
PROC BoxLIST(data:OWNS LIST) RETURNS box:OWNS PTR TO class
	DEF new:OWNS PTR TO boxLIST
	NEW new.new()
	new.data := PASS data
	box := PASS new
ENDPROC
PROC UnboxLIST(box:PTR TO class) IS IF box THEN box::boxLIST.data ELSE NILL
PROC ReplaceBoxLIST(box:PTR TO class, data:OWNS LIST) RETURNS oldData:OWNS LIST
	oldData := PASS box::boxLIST.data
	box::boxLIST.data := PASS data
ENDPROC

PRIVATE
CLASS boxVALUE OF box
	data:VALUE
ENDCLASS
PUBLIC
PROC BoxVALUE(data:VALUE) RETURNS box:OWNS PTR TO class
	DEF new:OWNS PTR TO boxVALUE
	NEW new.new()
	new.data := PASS data
	box := PASS new
ENDPROC
PROC UnboxVALUE(box:PTR TO class, nilValue=0) IS IF box THEN box::boxVALUE.data ELSE nilValue
PROC ReplaceBoxVALUE(box:PTR TO class, data:VALUE) RETURNS oldData:VALUE
	oldData := PASS box::boxVALUE.data
	box::boxVALUE.data := PASS data
ENDPROC

PRIVATE
CLASS boxBIGVALUE OF box
	data:BIGVALUE
ENDCLASS
PUBLIC
PROC BoxBIGVALUE(data:BIGVALUE) RETURNS box:OWNS PTR TO class
	DEF new:OWNS PTR TO boxBIGVALUE
	NEW new.new()
	new.data := PASS data
	box := PASS new
ENDPROC
PROC UnboxBIGVALUE(box:PTR TO class, nilValue=0:BIGVALUE) IS IF box THEN box::boxBIGVALUE.data ELSE nilValue
PROC ReplaceBoxBIGVALUE(box:PTR TO class, data:BIGVALUE) RETURNS oldData:BIGVALUE
	oldData := PASS box::boxBIGVALUE.data
	box::boxBIGVALUE.data := PASS data
ENDPROC
