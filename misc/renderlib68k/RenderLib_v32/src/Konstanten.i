
	IFND	KONSTANTEN_I
KONSTANTEN_I		SET	1

;========================================================================

;------------------------------------------------------------------------
;
;		Rendern
;
;------------------------------------------------------------------------

HAM8_THRESHOLD		EQU	1000	;22

;------------------------------------------------------------------------
;
;		Speicherverwaltung
;
;------------------------------------------------------------------------

RMH_PUDSIZE		EQU	16384	; Größe der public pool puddles

NODESPERBLOCK		EQU	510	; Anzahl Knoten pro Speicherblock

;------------------------------------------------------------------------
;
;		Histogramm
;
;------------------------------------------------------------------------

NUMCOLORS_NOT_DEFINED	EQU	$ffffffff	; Anzahl Farben im Histogramm
						; ist nicht bekannt. (Z.B.
						; nach Hinzufügen zu einem
						; TurboHistogramm)


;------------------------------------------------------------------------
;
;		Farbquantisierung
;
;		Diese Konstanten stellen Faktoren für die
;		Farbgewichtung dar. Mit ihrer Hilfe kann man den
;		Algorithmus an die Farbrezeption des menschlichen
;		Auges anpassen. Grün wird am besten aufgelöst,
;		Blau am schlechtesten. Experimentieren.
;
;------------------------------------------------------------------------

DEFAULT_GREENWEIGHT	EQU	1
DEFAULT_REDWEIGHT	EQU	1
DEFAULT_BLUEWEIGHT	EQU	1




;------------------------------------------------------------------------
;
;		diverse Programm-Konstanten
;
;------------------------------------------------------------------------

HSTYPEB_TURBO		EQU	4
PALMODE_SORTMASK	EQU	$000f

HSCONVTYPE_TURBO	EQU	0
HSCONVTYPE_TABLE	EQU	1
HSCONVTYPE_TREE		EQU	2
HSCONVTYPE_PACKED	EQU	3

;========================================================================

	ENDC
