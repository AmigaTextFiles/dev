IMPLEMENTATION MODULE GetFile;

(*
 * -------------------------------------------------------------------------
 *
 *	:Module.	GetFile
 *	:Contents.	interface to JaBa's GetFile-BOOPSI-Object

 *	:Author.	Reiner Nix
 *	:Address.	Geranienhof 2, 5000 Köln 71 Seeberg
 *	:Address.	rbnix@pool.informatik.rwth-aachen.de
 *	:Language.	Modula-2
 *	:Translator.	M2Amiga A-L V3.3d
 *	:History.	this interface is a direct descendent from the oberon interface
 *	:History.	GetFile.mod v1.0 by Kai Bolay [kai] 09-Apr-93
 *	:Imports.	bases.o, boopsi.o 
 *	:Usage.		import module and link with »-l fullpath/bases.o -l fullpath/boopsi.o«
 * -------------------------------------------------------------------------
 *)

 
(*
 * --- Environment for GetFile gadget -------------------------------------------
 * This module gives access to the boopsi gadget Getfile.
 *
 * You requiere the object files 'boopsi.o' and 'bases.o'.
 *
 * Link this module using the 'l' option to specify the additional
 * object modules:
 * (Assuming a program 'Test' wich uses this module 'GetFile'.)
 *
 *  m2l  -lboopsi.o  -lbases.o  Test
 *
 *
 * In 'boopsi.o' the GetFile gadget is defined. The gadget is initialized
 * calling the routine '_initGadget'.
 *
 * The result is a pointer to the created class. It is stored in
 * 'GetFileClass' for your own use.
 *
 * Using '_initGadget' requieres already set basepointers of intuition,
 * graphics, utility and gadtools libraries.
 * Because it is impossible to define extern labels with intern M2Amiga
 * Assembler we need the additional object file 'bases.o' doing the job.
 *
 * ------------------------------------------------------------------------------
 *)

FROM	SYSTEM		IMPORT	ASSEMBLE;
FROM	IntuitionL	IMPORT	FreeClass;

IMPORT	IntuitionL;
IMPORT	GraphicsL;
IMPORT	UtilityL;
IMPORT	GadToolsL;


VAR	dummy		:BOOLEAN;


BEGIN
ASSEMBLE
(
	XREF	_IntuitionBase, _GfxBase, _UtilityBase, _GadToolsBase
	XREF	_initGet

	MOVE.L	IntuitionL(A4),	_IntuitionBase
	MOVE.L	GraphicsL(A4),	_GfxBase
	MOVE.L	UtilityL(A4),	_UtilityBase
	MOVE.L	GadToolsL(A4),	_GadToolsBase

	JSR	_initGet
	MOVE.L	D0,		GetFileClass(A4)
	END
)

CLOSE
IF GetFileClass # NIL THEN
  dummy := FreeClass (GetFileClass);
  GetFileClass := NIL
  END
END GetFile.
