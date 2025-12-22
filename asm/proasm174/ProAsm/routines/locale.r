
;---;  locale.r  ;-------------------------------------------------------------
*
*	****	locale support routines    ****
*
*	Author		Daniel Weber
*	Version		0.90
*	Last Revision	30.03.94
*	Identifier	loc_defined
*       Prefix		loc_	(locale)
*				 ¯¯¯
*	Functions	OpenCatalog, FreeCatalog, GetLocString
*
*	Note		- LocaleBase(pc) must be available or set to zero
*			  if localization impossible (f.e.: for OS2.0 or lower)
*			- LOCALE_START and LOCALE_END must be set, see
*			  GetLocString for detailed information.
*			- Use MakeCat or CatComp to generate a catalog.
*			- The comment mark (;) is used here to store the old
*			  local.r source.
*
*	Flags		loc_A5	- based storage (xxx(a5) used everytime)
*
;------------------------------------------------------------------------------

	IFND	loc_defined
loc_defined	SET	1

;------------------
loc_oldbase	EQU __BASE
	base	loc_base
loc_base:

;------------------
	opt	sto,o+,ow-,q+,qw-		;all optimisations on


;------------------------------------------------------------------------------
*
* OpenCatalog	- open a locale katalog
*
* INPUT:	a0: CatalogName
*		(a5: Base)
*
* RESULT:	d0: Catalog
*		d1: Locale  (ZERO if failed)
*
* NOTE:
*
* A catalog name should be defined as string labled as 'CatalogName'
* (f.e.: CatalogName: dc.b "asx.catalog",0), if no such string is defined
* the assembler may report an error (symbol not found) or OpenCatalogA()
* goes crazy...
*
* OpenCatalog searches for the catalogs in the following places:
*		PROGDIR:Catalogs/languageName/name
*		LOCALE:Catalogs/languageName/name
*
* See the autodocs for more detailed information.
*
;------------------------------------------------------------------------------
	IFD	xxx_OpenCatalog
OpenCatalog:
	movem.l	d7/a0/a1/a6,-(a7)
	moveq	#0,d1
	IFND	loc_A5
;	lea	loc_base(pc),a5
	move.l	LocaleBase(pc),d0		;exist base?
	ELSE
	move.l	LocaleBase(a5),d0
	ENDC
	beq.s	.out
	move.l	a0,d7			;store CatalogName
	move.l	d0,a6
	sub.l	a0,a0
	jsr	-156(a6)		;OpenLocale(name=0) => default locale
;	move.l	d0,Locale(a5)
	move.l	d0,d1
	beq.s	.out			;should not occure (says locale.doc)

	move.l	d0,-(a7)
	move.l	d0,a0
;	lea	CatalogName(pc),a1
	move.l	d7,a1
	sub.l	a2,a2
	jsr	-150(a6)		;OpenCatalogA(locale,name,tagList)
;	move.l	d0,Catalog(a5)		;=>catalog
	move.l	(a7)+,d1

.out:	movem.l	(a7)+,_movemlist
	rts


;Loacle:	dc.l	0		;store the results of OpenLocale
;Catalog:	dc.l	0		;and OpenCatalogA here

	ENDC

;------------------------------------------------------------------------------
*
* FreeCatalog	- Free an opened catalog
*
* INPUT:	d0: Catalog
*		d1: Locale
*		(a5: Base)
*
* NOTE:	No checks are perfomed to test whether the input values are zero or not!
*
;------------------------------------------------------------------------------
	IFD	xxx_FreeCatalog
FreeCatalog:
	movem.l	d7/a0/a1/a6,-(a7)
	IFND	loc_A5
	move.l	LocaleBase(pc),d7
	ELSE
	move.l	LocaleBase(a5),d7
	ENDC
	beq.s	.out
	move.l	d7,a6
	move.l	d1,d7			;store locale
	beq.s	.out
;	move.l	Catalog(pc),a0
	move.l	d0,a0
	jsr	-36(a6)			;CloseCatalog()

;	move.l	Locale(pc),a0
	move.l	d7,a0
	jsr	-42(a6)			;CloseLocale()

.out:	movem.l	(a7)+,_movemlist
	rts
	ENDC

;------------------------------------------------------------------------------
*
* GetString	- get a localized string
*
* INPUT:	d0: Catalog
*		a0: pointer to original string
*		a1: LOCAL_START
*		a2: LOCAL_END
*		(a5: Base)
*
* RESULT:	d0: pointer localized string or originally passed string
*
* NOTES
*
* The returned string is NULL-terminated, and it is READ-ONLY, do NOT modify!
* This string pointer is valid only as long as the catalog remains open.
*
* LOCALE_START and LOCALE_END is an area containing all texts for localization
* f.e.:		LOCALE_START:
*		CancelTxt:	dc.b	"Cancel",0
*		OkTxt:		dc.b	"Ok",0
*		ProAsmPathTxt:	dc.b	"ProAsm path",0
*		<...>
*		LOCALE_END:
*
;------------------------------------------------------------------------------
	IFD	xxx_GetLocString
GetLocString:
	movem.l	d1/d6-a1/a6,-(a7)
	move.l	a0,d6			;store original string
	tst.l	d0
	beq.s	.eout
	IFND	loc_A5
	move.l	LocaleBase(pc),d7
	ELSE
	move.l	LocaleBase(a5),d7
	ENDC
	beq.s	.eout
	move.l	d7,a6
	move.l	d0,d7			;store catalog
;	move.l	Catalog(pc),d0
;	beq.s	.eout

	moveq	#0,d0
	move.l	a0,d1
	exg	a0,a1			;LOCAL_START in a0
;	move.l	a0,a1
;	lea	LOCALE_END(pc),a0
;	cmp.l	a0,d1
	cmp.l	a2,d1
	bgt.s	.eout
;	lea	LOCALE_START(pc),a0
	cmp.l	a0,d1
	blt.s	.eout
	sub.l	a0,d1
	beq.s	.getit


.loop:	tst.b	(a0)+
	bne.s	.ok
	addq.l	#1,d0
.ok:	subq.l	#1,d1
	bne.s	.loop
.getit:	move.l	d7,a0			;Catalog in a0
;	move.l	Catalog(pc),a0
	jsr	-72(a6)			;GetCatalogStr(catalog,strNum,defaultStr)
.out:	movem.l	(a7)+,_movemlist
	rts
.eout:	move.l	d6,d0
	bra.s	.out

	ENDC


;--------------------------------------------------------------------

	base	loc_oldbase
	opt	rcl

;------------------
	ENDIF

 end

