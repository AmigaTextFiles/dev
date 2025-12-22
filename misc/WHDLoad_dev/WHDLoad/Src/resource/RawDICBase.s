
* $Id: RawDICBase.s 1.1 2004/01/20 00:31:42 wepl Exp wepl $

	INCDIR	Includes:
	INCLUDE UserSymbols.i
	INCLUDE	RawDIC.i

	dc.l		name
	dc.b		BYTESYM
	ByteSymbol	<rawdic_ReadTrack>,rawdic_ReadTrack
	ByteSymbol	<rawdic_NextSync>,rawdic_NextSync
	ByteSymbol	<rawdic_NextMFMword>,rawdic_NextMFMword
	ByteSymbol	<rawdic_SaveFile>,rawdic_SaveFile
	ByteSymbol	<rawdic_SaveDiskFile>,rawdic_SaveDiskFile
	ByteSymbol	<rawdic_AppendFile>,rawdic_AppendFile
	ByteSymbol	<rawdic_Reserved>,rawdic_Reserved
	ByteSymbol	<rawdic_DMFM_STANDARD>,rawdic_DMFM_STANDARD
	dc.b		ENDBASE
name	dc.b		'RawDIC Base',0
	EVEN

