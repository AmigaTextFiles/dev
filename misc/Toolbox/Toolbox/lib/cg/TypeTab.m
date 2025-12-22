INTEGER
# define beginINTEGER(a)	
# define closeINTEGER(a)	
# define readINTEGER(a)		a := IO.ReadI (yyf);
# define writeINTEGER(a)	IO.WriteI (yyf, a, 0);
# define getINTEGER(a)		yyGet (a);
# define putINTEGER(a)		yyPut (a);
# define copyINTEGER(a, b)	
# define equalINTEGER(a, b)	a = b
SHORTINT
# define beginSHORTINT(a)	
# define closeSHORTINT(a)	
# define readSHORTINT(a)	a := IO.ReadI (yyf);
# define writeSHORTINT(a)	IO.WriteI (yyf, a, 0);
# define getSHORTINT(a)		yyGet (a);
# define putSHORTINT(a)		yyPut (a);
# define copySHORTINT(a, b)	
# define equalSHORTINT(a, b)	a = b
LONGINT
# define beginLONGINT(a)	
# define closeLONGINT(a)	
# define readLONGINT(a)		a := IO.ReadI (yyf);
# define writeLONGINT(a)	IO.WriteI (yyf, a, 0);
# define getLONGINT(a)		yyGet (a);
# define putLONGINT(a)		yyPut (a);
# define copyLONGINT(a, b)	
# define equalLONGINT(a, b)	a = b
CARDINAL
# define beginCARDINAL(a)	
# define closeCARDINAL(a)	
# define readCARDINAL(a)	a := IO.ReadI (yyf);
# define writeCARDINAL(a)	IO.WriteI (yyf, a, 0);
# define getCARDINAL(a)		yyGet (a);
# define putCARDINAL(a)		yyPut (a);
# define copyCARDINAL(a, b)	
# define equalCARDINAL(a, b)	a = b
SHORTCARD
# define beginSHORTCARD(a)	
# define closeSHORTCARD(a)	
# define readSHORTCARD(a)	a := IO.ReadI (yyf);
# define writeSHORTCARD(a)	IO.WriteI (yyf, a, 0);
# define getSHORTCARD(a)	yyGet (a);
# define putSHORTCARD(a)	yyPut (a);
# define copySHORTCARD(a, b)	
# define equalSHORTCARD(a, b)	a = b
LONGCARD
# define beginLONGCARD(a)	
# define closeLONGCARD(a)	
# define readLONGCARD(a)	a := IO.ReadI (yyf);
# define writeLONGCARD(a)	IO.WriteI (yyf, a, 0);
# define getLONGCARD(a)		yyGet (a);
# define putLONGCARD(a)		yyPut (a);
# define copyLONGCARD(a, b)	
# define equalLONGCARD(a, b)	a = b
REAL
# define beginREAL(a)		
# define closeREAL(a)		
# define readREAL(a)		a := IO.ReadR (yyf);
# define writeREAL(a)		IO.WriteR (yyf, a, 0, 6, 1);
# define getREAL(a)		yyGet (a);
# define putREAL(a)		yyPut (a);
# define copyREAL(a, b)		
# define equalREAL(a, b)	a = b
LONGREAL
# define beginLONGREAL(a)	
# define closeLONGREAL(a)	
# define readLONGREAL(a)	a := IO.ReadR (yyf);
# define writeLONGREAL(a)	IO.WriteR (yyf, a, 0, 6, 1);
# define getLONGREAL(a)		yyGet (a);
# define putLONGREAL(a)		yyPut (a);
# define copyLONGREAL(a, b)	
# define equalLONGREAL(a, b)	a = b
BOOLEAN
# define beginBOOLEAN(a)	
# define closeBOOLEAN(a)	
# define readBOOLEAN(a)		a := IO.ReadB (yyf);
# define writeBOOLEAN(a)	IO.WriteB (yyf, a);
# define getBOOLEAN(a)		yyGet (a);
# define putBOOLEAN(a)		yyPut (a);
# define copyBOOLEAN(a, b)	
# define equalBOOLEAN(a, b)	a = b
CHAR
# define beginCHAR(a)		
# define closeCHAR(a)		
# define readCHAR(a)		a := IO.ReadC (yyf);
# define writeCHAR(a)		IO.WriteC (yyf, a);
# define getCHAR(a)		yyGet (a);
# define putCHAR(a)		yyPut (a);
# define copyCHAR(a, b)		
# define equalCHAR(a, b)	a = b
BITSET
# define beginBITSET(a)		
# define closeBITSET(a)		
# define readBITSET(a)		yyReadHex (a);
# define writeBITSET(a)		yyWriteHex (a);
# define getBITSET(a)		yyGet (a);
# define putBITSET(a)		yyPut (a);
# define copyBITSET(a, b)	
# define equalBITSET(a, b)	a = b
BYTE
# define beginBYTE(a)		
# define closeBYTE(a)		
# define readBYTE(a)		yyReadHex (a);
# define writeBYTE(a)		yyWriteHex (a);
# define getBYTE(a)		yyGet (a);
# define putBYTE(a)		yyPut (a);
# define copyBYTE(a, b)		
# define equalBYTE(a, b)	a = b
WORD
# define beginWORD(a)		
# define closeWORD(a)		
# define readWORD(a)		yyReadHex (a);
# define writeWORD(a)		yyWriteHex (a);
# define getWORD(a)		yyGet (a);
# define putWORD(a)		yyPut (a);
# define copyWORD(a, b)		
# define equalWORD(a, b)	a = b
ADDRESS
# define beginADDRESS(a)	
# define closeADDRESS(a)	
# define readADDRESS(a)		yyReadHex (a);
# define writeADDRESS(a)	yyWriteHex (a);
# define getADDRESS(a)		yyGet (a);
# define putADDRESS(a)		yyPut (a);
# define copyADDRESS(a, b)	
# define equalADDRESS(a, b)	a = b
tString
# define begintString(a)	
# define closetString(a)	
# define readtString(a)		Strings.ReadL (yyf, a);
# define writetString(a)	Strings.WriteL (yyf, a);
# define gettString(a)		yyGet (a);
# define puttString(a)		yyPut (a);
# define copytString(a, b)	
# define equaltString(a, b)	Strings.IsEqual (a, b)
tStringRef
# define begintStringRef(a)	
# define closetStringRef(a)	
# define readtStringRef(a)	
# define writetStringRef(a)	StringMem.WriteString (yyf, a);
# define gettStringRef(a)	
# define puttStringRef(a)	
# define copytStringRef(a, b)	
# define equaltStringRef(a, b)	a = b
tIdent
# define begintIdent(a)		
# define closetIdent(a)		
# define readtIdent(a)		a := yyReadIdent ();
# define writetIdent(a)		Idents.WriteIdent (yyf, a);
# define gettIdent(a)		yyGetIdent (a);
# define puttIdent(a)		yyPutIdent (a);
# define copytIdent(a, b)	
# define equaltIdent(a, b)	a = b
tText
# define begintText(a)		
# define closetText(a)		
# define readtText(a)		
# define writetText(a)		Texts.WriteText (yyf, a);
# define gettText(a)		
# define puttText(a)		
# define copytText(a, b)	
# define equaltText(a, b)	FALSE
tSet
# define begintSet(a)		
# define closetSet(a)		
# define readtSet(a)		Sets.ReadSet (yyf, a);
# define writetSet(a)		Sets.WriteSet (yyf, a);
# define gettSet(a)		
# define puttSet(a)		
# define copytSet(a, b)		
# define equaltSet(a, b)	Sets.IsEqual (a, b)
tRelation
# define begintRelation(a)	
# define closetRelation(a)	
# define readtRelation(a)	Relations.ReadRelation (yyf, a);
# define writetRelation(a)	Relations.WriteRelation (yyf, a);
# define gettRelation(a)	
# define puttRelation(a)	
# define copytRelation(a, b)	
# define equaltRelation(a, b)	Relations.IsEqual (a, b)
tPosition
# define begintPosition(a)		
# define closetPosition(a)		
# define readtPosition(a)
# define writetPosition(a)	Positions.WritePosition (yyf, a);
# define gettPosition(a)		
# define puttPosition(a)		
# define copytPosition(a, b)		
# define equaltPosition(a, b)	Positions.Compare (a, b) = 0
