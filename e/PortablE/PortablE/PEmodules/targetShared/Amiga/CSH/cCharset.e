/* cCharset.e 30-05-2016
	Amiga-specific implementation.
*/

OPT PREPROCESS, POINTER
OPT NATIVE		->for MorphOS
MODULE 'dos', 'locale', 'exec'
MODULE 'diskfont'	->for AmigaOS4
MODULE 'keymap'		->for MorphOS

PRIVATE
CONST DEBUG = FALSE
PUBLIC

PROC infoSystemCharset() RETURNS charset:ARRAY OF CHAR IS cachedCharset

PROC new()
	cachedCharset := infoSystemCharset_dynamic()
ENDPROC

PRIVATE
->NOTE: Amiga implementation inspired by "init.c" from codesets.library, as well as other suggestions.
PROC infoSystemCharset_dynamic() RETURNS charset:ARRAY OF CHAR
	DEF table:ARRAY OF mapping, defaultLocale:PTR TO locale
	DEF i, row:PTR TO mapping, language:OWNS STRING
	#ifdef pe_TargetOS_AmigaOS4
	DEF codeset
	#endif
	
	->language from Locale:Catalogs  (and other sources)
	->charset  from Locale:Languages (or "init.c" when multi-choice)
	->oldCode  from "init.c" from codesets.library
	->newCode  from http://en.wikipedia.org/wiki/ISO_3166-1_alpha-3
	table := [
	->	language      langLen  charset        oldCode    newCode     (country)
		'bosanski',   STRLEN,  'ISO-8859-2',  "BA\0\0",  "BIH\0",	->Bosnia
		'català',     STRLEN,  'ISO-8859-15', "E\0\0\0", "ESP\0",	->Catalan language, same codes as Spain
		'czech',      STRLEN,  'ISO-8859-2',  "CZ\0\0",  "CZE\0",	->Czech Republic
		'dansk',      STRLEN,  'ISO-8859-15', "DK\0\0",  "DNK\0",	->Denmark
		'deutsch',    STRLEN,  'ISO-8859-15', "D\0\0\0", "DEU\0",	->Germany
		'english',    STRLEN,  'ISO-8859-15', "GB\0\0",  "GBR\0",	->United Kingdom
		'esperanto',  STRLEN,  'ISO-8859-3',  0,         0,			->Esperanto language
		'eesti',      STRLEN,  'ISO-8859-15', "EE\0\0",  "EST\0",	->Estonia
		'èe¹tina',    STRLEN,  'ISO-8859-2',  "CZ\0\0",  "CZE\0",	->Czech Republic (in MorphOS 2.0)
		'español',    STRLEN,  'ISO-8859-15', "E\0\0\0", "ESP\0",	->Spain
		'français',   STRLEN,  'ISO-8859-15', "F\0\0\0", "FRA\0",	->France
		'gaeilge',    STRLEN,  'ISO-8859-15', 0,         0,			->Irish language
		'galego',     STRLEN,  'ISO-8859-15', "E\0\0\0", "ESP\0",	->Galician language, same codes as Spain
		'greek',      STRLEN,  'ISO-8859-7',  "GR\0\0",  "GRC\0",	->Greece
		'hrvatski',   STRLEN,  'ISO-8859-2',  "HR\0\0",  "HRV\0",	->Croatia
		'italiano',   STRLEN,  'ISO-8859-15', "I\0\0\0", "ITA\0",	->Italy
		'lietuvi',    STRLEN,  'ISO-8859-13', "LT\0\0",  "LTU\0",	->Lithuania
		'magyar',     STRLEN,  'ISO-8859-2',  "HU\0\0",  "HUN\0",	->Hungary
		'nederlands', STRLEN,  'ISO-8859-15', "NL\0\0",  "NLD\0",	->Netherlands
		'norsk',      STRLEN,  'ISO-8859-15', "N\0\0\0", "NOR\0",	->Norway
		'polski',     STRLEN,  'ISO-8859-2',  "PL\0\0",  "POL\0",	->Poland
		'português',  STRLEN,  'ISO-8859-15', "PT\0\0",  "PRT\0",	->Portugal
		'russian',    STRLEN,  'Amiga-1251',  "RU\0\0",  "RUS\0",	->Russian Federation
		'slovak',     STRLEN,  'ISO-8859-2',  "SK\0\0",  "SVK\0",	->Slovakia
		'slovensko',  STRLEN,  'ISO-8859-2',  "SI\0\0",  "SVN\0",	->Slovenia
		'srpski',     STRLEN,  'ISO-8859-2',  "RS\0\0",  "SRB\0",	->Serbia
		'suomi',      STRLEN,  'ISO-8859-1',  "FIN\0",   "FIN\0",	->Finland
		'svenska',    STRLEN,  'ISO-8859-15', "S\0\0\0", "SWE\0",	->Sweden
		'türkçe',     STRLEN,  'ISO-8859-9',  "TR\0\0",  "TUR\0",	->Turkey
		NILA,         0,       NILA,          0,         0
	]:mapping
	
	->try the default locale's codeset, needs AmigaOS4 procedures, suggested by broadblues on amigans.net
	->NOTE: This seems to work better than other guesses below.
	#ifdef pe_TargetOS_AmigaOS4
		IF localebase := OpenLibrary('locale.library', 0)
			IF diskfontbase := OpenLibrary('diskfont.library', 0)
				IF defaultLocale := OpenLocale(NILA)
					codeset := defaultLocale.codeset
					IF codeset = 0 THEN codeset := 4	->CodeSet specifies the code set required by this locale. Before V50, this value was always 0. Since V50, this is the IANA charset number (see L:CharSets/character-sets). For compatibility, 0 should be handled as equal to 4, both meaning ISO-8859-1 Latin1.
					charset := ObtainCharsetInfo(DFCS_NUMBER, codeset, DFCS_MIMENAME) !!ARRAY OF CHAR	->OS4-specific
					CloseLocale(defaultLocale)
				ENDIF
				CloseLibrary(diskfontbase)
			ENDIF
			CloseLibrary(localebase)
			IF DEBUG ; IF charset ; Print('infoSystemCharset(); locale.codeset; charset = "\s"\n', charset) ; charset := NILA ; ENDIF ; ENDIF
			IF charset THEN RETURN
		ENDIF
	#endif
	
	->try system default charset for AmigaOS4, suggested by tboeckel on amigans.net
	#ifdef pe_TargetOS_AmigaOS4
		IF diskfontbase := OpenLibrary('diskfont.library', 0)
			charset := ObtainCharsetInfo(DFCS_NUMBER, GetDiskFontCtrl(DFCTRL_CHARSET), DFCS_MIMENAME) !!ARRAY OF CHAR	->OS4-specific
			IF DEBUG ; IF charset ; Print('infoSystemCharset(); diskfont; charset = "\s"\n', charset) ; charset := NILA ; ENDIF ; ENDIF
			CloseLibrary(diskfontbase)
		ENDIF
		IF charset THEN RETURN
	#endif
	
	->try keymap for MorphOS v2.x or later, inspired by "init.c" from codesets.library
	#ifdef pe_TargetOS_MorphOS
		IF keymapbase := OpenLibrary('keymap.library', 51)
			IF (keymapbase.revision >= 4) OR (keymapbase.version > 51)
				{
				//handle AmiDevCpp with ancient MOS includes
				#ifndef GetKeyMapCodepage
				#define GetKeyMapCodepage(__p0) LP1(78, CONST_STRPTR , GetKeyMapCodepage, CONST struct KeyMap *, __p0, a0, , KEYMAP_BASE_NAME, 0, 0, 0, 0, 0, 0)
				#endif
				}
				charset := NATIVE {GetKeyMapCodepage(} NIL {)} ENDNATIVE !!CONST_STRPTR
				CloseLibrary(keymapbase)
				IF DEBUG ; IF charset ; Print('infoSystemCharset(); keymap; charset = "\s"\n', charset) ; charset := NILA ; ENDIF ; ENDIF
				IF charset THEN RETURN
			ENDIF
		ENDIF
	#endif
	
	->try two local env variables
	END newCharset
	NEW newCharset[100]
	
	IF GetVar('CodePage', newCharset, StrMax(newCharset), 0) >= 0
		charset := newCharset
		IF DEBUG ; IF charset ; Print('infoSystemCharset(); CodePage var; charset = "\s"\n', charset) ; charset := NILA ; ENDIF ; ENDIF
		IF NOT DEBUG THEN RETURN
		
	ELSE IF GetVar('Charset', newCharset, StrMax(newCharset), 0) >= 0
		charset := newCharset
		IF DEBUG ; IF charset ; Print('infoSystemCharset(); Charset var; charset = "\s"\n', charset) ; charset := NILA ; ENDIF ; ENDIF
		IF NOT DEBUG THEN RETURN
	ENDIF
	
	END newCharset
	
	->guess using the default locale's country code
	IF localebase := OpenLibrary('locale.library', 0)
		IF defaultLocale := OpenLocale(NILA)
			i := 0
			REPEAT
				row := table[i++]
				IF row.language THEN IF (row.oldCode = defaultLocale.countrycode) OR (row.newCode = defaultLocale.countrycode) THEN charset := row.charset
			UNTIL (charset <> NILA) OR (row.language = NILA)
			CloseLocale(defaultLocale)
		ENDIF
		CloseLibrary(localebase)
		IF DEBUG ; IF charset ; Print('infoSystemCharset(); locale.countrycode; charset = "\s"\n', charset) ; charset := NILA ; ENDIF ; ENDIF
		IF charset THEN RETURN
	ENDIF
	
	->guess using the default locale's language
	IF localebase := OpenLibrary('locale.library', 0)
		IF defaultLocale := OpenLocale(NILA)
			i := 0
			REPEAT
				row := table[i++]
				IF row.language THEN IF StrCmpNoCase(defaultLocale.languagename, row.language, row.langLen) THEN charset := row.charset	->matches e.g. "english" to "english.language"
			UNTIL (charset <> NILA) OR (row.language = NILA)
			CloseLocale(defaultLocale)
		ENDIF
		CloseLibrary(localebase)
		IF DEBUG ; IF charset ; Print('infoSystemCharset(); locale.languagename; charset = "\s"\n', charset) ; charset := NILA ; ENDIF ; ENDIF
		IF charset THEN RETURN
	ENDIF
	
	->guess using the Language env variable
	NEW language[100]
	IF GetVar('Language', language, StrMax(language), 0) >= 0
		i := 0
		REPEAT
			row := table[i++]
			IF row.language THEN IF StrCmpNoCase(language, row.language) THEN charset := row.charset
		UNTIL (charset <> NILA) OR (row.language = NILA)
	ENDIF
	IF DEBUG ; IF charset ; Print('infoSystemCharset(); Language var; charset = "\s"\n', charset) ; charset := NILA ; ENDIF ; ENDIF
	END language
	IF charset THEN RETURN
	
	->fall-back to the charset originally used by AmigaDOS (1.x), according to Wikipedia
	charset := 'ISO-8859-1'
FINALLY
	IF exception THEN END newCharset
ENDPROC

DEF cachedCharset:ARRAY OF CHAR, newCharset:OWNS STRING

OBJECT mapping
	language:ARRAY OF CHAR	->language name used by catalogue files
	langLen
	charset:ARRAY OF CHAR
	oldCode:QUAD			->Old .country files used a mixture of car license plate codes and Alpha-3 names
	newCode:QUAD			->New .country files use ISO-3166 Alpha-3 names
ENDOBJECT
PUBLIC
