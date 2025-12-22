(* REVISION HEADER ×××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××× *
 | 
 | $VER: Demo.mod 1.00 (06.09.94) by Stefan Schulz
 | 
 | Module          : Demo
 | Last Modified   : Tuesday, 06.09.94
 | Author          : Stefan Schulz
 | Actual Revision : 1.00
 | 
 | 
 | Description
 | -----------
 |   - Nonfunctional User Interface as Demonstration
 | 
 | Requirements
 | ------------
 |   - triton.library V1.1
 | 
 | Language
 | --------
 |   - M2Amiga Modula 2 Software Development System
 |     © Copyright by A+L AG, CH-2540 Grenchen
 | 
 | Revision 1.00  \06.09.94\
 |  - initial revision
 |   
 * ×××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××× *)

MODULE Demo2;

(* IMPORTS ********************************************************************** *)

IMPORT	td	: TritonD,
	tl	: TritonL;

IMPORT	A	: Arts,
	ed	: ExecD,
	id	: IntuitionD,
	S	: SYSTEM,
	ud	: UtilityD;

(* ****************************************************************************** *)

(* --- Objects ------------------------------------------------------------------ *)

VAR	App		: td.TrAppPtr;
	Project		: td.TrProjectPtr;

VAR	AppBuffer	: ARRAY [0..3] OF ud.TagItem;
	ProjectBuffer	: ARRAY [0..371] OF ud.TagItem;

TYPE	CatEntries	=
	    (
		(* Working-Modes *)
		 wmknCheckmark,
		 wmknCycle,
		 wmdtCheckmark,
		 wmdtEntry,
		 wmttCheckmark,
		 wmddCheckmark,
		 wmimCheckmark,
		 wmcsCheckmark,
		 wmidCheckmark,
		 wmidSlider,
		 wmstCheckmark,
		 wmstEntry,
		
		(* Source *)
		sGroup,
		sSelected,
		sImageOnly,
		sName,
		
		(* Destination *)
		dGroup,
		dName,
		
		(* Menu *)
		 miOpenIcon,
		 miSaveIcon,
		 miSaveIconAs,
		 miSaveDefault,
		  misdDisk,
		  misdDrawer,
		  misdTool,
		  misdProject,
		  misdGarbage,
		  misdKick,
		 miAbout,
		 miQuit,
		 miDropGoesDest,
		 miDropActivates,
		 miNoIconPos,
		 miSaveInfo,
		 miRequestDest,
		 miLabelO1,
		 miLoadOptions,
		 miSaveOptions,
		 miLoadBrush,
		 miSaveAsBrush,
		 miToolTypes,
		 miDrawerData,
		 miColorSwap,
		 miInformation
	    );

(* --- NameLists for Cycle and Registers ---------------------------------------- *)

TYPE	KindList	= ARRAY [0..5] OF S.ADDRESS;
	SourceList	= ARRAY [0..2] OF S.ADDRESS;

VAR	kindList	:= KindList
	{ S.ADR("Disk"),
	  S.ADR("Drawer"),
	  S.ADR("Tool"),
	  S.ADR("Project"),
	  S.ADR("Garbage"),
	  NIL
	}; (* KindList *)
	
	sourceList	:= SourceList
	{ S.ADR("Normal"),
	  S.ADR("Selected"),
	  NIL
	}; (* SourceList *)


PROCEDURE InitApplication;

 BEGIN
 
 App:= tl.CreateApp
	( S.TAG(AppBuffer,
		td.trcaName,     S.ADR("M2AmigaDemo"),
		td.trcaLongName, S.ADR("M2Amiga Demo Application"),
		td.trcaVersion,  S.ADR("1.0"),
	  ud.tagDone)
	); (* CreateApp *)

 A.Assert(App#NIL, S.ADR("Couldn't create Application!"));
 
 END InitApplication;


PROCEDURE InitProject;

 BEGIN
 
 Project:= tl.OpenProject
	( App,
	  S.TAG(ProjectBuffer,
		td.trwiTitle,    S.ADR("ReIcon V3.00 / Nonfunctional Demo"),
		td.trwiID,       1,
		td.trwiPosition, td.trwpCENTERDISPLAY,
		
		
		td.trmnTitle,	S.ADR("Project"),
		  td.trmnItem,	S.ADR("o_Open Icon..."),
				td.tratID, miOpenIcon,
		  td.trmnItem,	S.ADR("s_Save Icon"),
				td.tratID, miSaveIcon,
		  td.trmnItem,	S.ADR("a_Save Icon as..."),
				td.tratID, miSaveIconAs,
		  td.trmnItem,	S.ADR("Save Default"),
		    td.trmnSub,	S.ADR("Disk"),
				td.tratID, misdDisk,
		    td.trmnSub,	S.ADR("Drawer"),
				td.tratID, misdDrawer,
		    td.trmnSub,	S.ADR("Tool"),
				td.tratID, misdTool,
		    td.trmnSub,	S.ADR("Project"),
				td.tratID, misdProject,
		    td.trmnSub,	S.ADR("Garbage"),
				td.tratID, misdGarbage,
		    td.trmnSub,	S.ADR("Kick / NDOS"),
				td.tratID, misdKick,
		  td.trmnItem,	td.trmnBARLABEL,
		  td.trmnItem,	S.ADR("?_About"),
				td.tratID, miAbout,
		  td.trmnItem,	td.trmnBARLABEL,
		  td.trmnItem,	S.ADR("q_Quit"),
				td.tratID, miQuit,
		
		td.trmnTitle,	S.ADR("Options"),
		  td.trmnItem,	S.ADR("1_Drop goes Destination"),
				td.tratID, miDropGoesDest,
		  td.trmnItem,	S.ADR("2_Drop Activates"),
				td.tratID, miDropActivates,
		  td.trmnItem,	S.ADR("3_No Icon Position"),
				td.tratID, miNoIconPos,
		  td.trmnItem,	S.ADR("4_Save Information"),
				td.tratID, miSaveInfo,
		  td.trmnItem,	S.ADR("5_Request on Destination"),
				td.tratID, miRequestDest,
		  td.trmnItem,	td.trmnBARLABEL,
		  td.trmnItem,	S.ADR("Load Options"),
				td.tratID, miLoadOptions,
		  td.trmnItem,	S.ADR("Save Options"),
				td.tratID, miSaveOptions,
		
		td.trmnTitle,	S.ADR("Images"),
		  td.trmnItem,	S.ADR("Load Brush..."),
				td.tratID, miLoadBrush,
		  td.trmnItem,	S.ADR("Save as Brush..."),
				td.tratID, miSaveAsBrush,
		
		td.trmnTitle,	S.ADR("Pages"),
		  td.trmnItem,	S.ADR("t_ToolTypes"),
				td.tratID, miToolTypes,
		  td.trmnItem,	S.ADR("d_Drawer Data"),
				td.tratID, miDrawerData,
		  td.trmnItem,	S.ADR("c_ColorSwap"),
				td.tratID, miColorSwap,
		  td.trmnItem,	S.ADR("i_Information"),
				td.tratID, miInformation,
		
		(* ··· Main Group ··············································· *)
		td.trgrVert,	td.trgrALIGN+td.trgrEQUALSHARE+td.trgrPROPSPACES,
		td.trobSpace,	td.trstSMALL,
		td.trgrHoriz,	td.trgrEQUALSHARE+td.trgrCENTER+td.trgrPROPSPACES,
		td.trobSpace,	td.trstSMALL,
		
		  (* ··· Mode Group ············································· *)
		  td.trobFrameBox,  NIL,
				    td.tratText,  S.ADR("Mode"),
		  td.trgrVert,	    td.trgrALIGN+td.trgrEQUALSHARE+td.trgrPROPSPACES,
		  td.trobSpace,	    td.trstSMALL,
		  
		    (* ··· Kind Group ··········································· *)
		    td.trgrHoriz,	td.trgrCENTER+td.trgrPROPSHARE,
		      td.trobSpace,	td.trstSMALL,
		      td.trobCheckBox,	NIL,
					td.tratID,   wmknCheckmark,
		      td.trobSpace,	td.trstSMALL,
		      td.trgrVert,	  td.trgrALIGN,
			td.trobSpace,	  td.trstSMALL,
			td.trgrHoriz,	    td.trgrALIGN,
			  td.trobSpace,	    td.trstSMALL,
			  td.trobText,	    NIL,
					    td.tratText, S.ADR("_Kind"),
					    td.tratID,   wmknCheckmark,
			  td.trobSpace,	    td.trstBIG,
			td.trgrEnd,	    NIL,
			td.trobSpace,	  td.trstSMALL,
			td.trobCycle,	  S.ADR(kindList),
					  td.tratID,    wmknCycle,
					  td.tratValue, NIL,
			td.trobSpace,	  td.trstSMALL,
		      td.trgrEnd,	  NIL,
		      td.trobSpace,	td.trstSMALL,
		    td.trgrEnd,		NIL,
		    (* ··· END Kind Group ······································· *)
		    
		    (* ··· Separator ············································ *)
		    td.trobSpace,	td.trstSMALL,
		    td.trgrHoriz,	td.trgrEQUALSHARE+td.trgrCENTER,
		    td.trobSpace,	td.trstSMALL,
		    td.trobLine,	td.trofHORIZ,
		    td.trobSpace,	td.trstSMALL,
		    td.trgrEnd,		NIL,
		    td.trobSpace,	td.trstSMALL,
		    (* ··· END Separator ········································ *)
		    
		    (* ··· Default Tool Group ··································· *)
		    td.trgrHoriz,	td.trgrCENTER+td.trgrPROPSHARE,
		      td.trobSpace,	td.trstSMALL,
		      td.trobCheckBox,	NIL,
					td.tratID,   wmdtCheckmark,
		      td.trobSpace,	td.trstSMALL,
		      td.trgrVert,	  td.trgrALIGN,
			td.trobSpace,	  td.trstSMALL,
			td.trgrHoriz,	    td.trgrALIGN,
			  td.trobSpace,	    td.trstSMALL,
			  td.trobText,	    NIL,
					    td.tratText, S.ADR("De_fault Tool"),
					    td.tratID,   wmdtCheckmark,
			  td.trobSpace,	    td.trstBIG,
			td.trgrEnd,	    NIL,
			td.trobSpace,	  td.trstSMALL,
			td.trobString,	  S.ADR("Command"),
					  td.tratID, wmdtEntry,
			td.trobSpace,	  td.trstSMALL,
		      td.trgrEnd,	  NIL,
		      td.trobSpace,	td.trstSMALL,
		    td.trgrEnd,		NIL,
		    (* ··· END Default Tool Group ······························· *)
		    
		    (* ··· Separator ············································ *)
		    td.trobSpace,	td.trstSMALL,
		    td.trgrHoriz,	td.trgrEQUALSHARE+td.trgrCENTER,
		    td.trobSpace,	td.trstSMALL,
		    td.trobLine,	td.trofHORIZ,
		    td.trobSpace,	td.trstSMALL,
		    td.trgrEnd,		NIL,
		    td.trobSpace,	td.trstSMALL,
		    (* ··· END Separator ········································ *)
		    
		    (* ··· ToolTypes Group ······································ *)
		    td.trgrHoriz,	td.trgrCENTER+td.trgrPROPSHARE,
		      td.trobSpace,	td.trstSMALL,
		      td.trobCheckBox,	NIL,
					td.tratID,   wmttCheckmark,
		      td.trobSpace,	td.trstSMALL,
		      td.trgrVert,	  td.trgrALIGN,
			td.trobSpace,	  td.trstSMALL,
			td.trgrHoriz,	    td.trgrALIGN,
			  td.trobSpace,	    td.trstSMALL,
			  td.trobText,	    NIL,
					    td.tratText, S.ADR("_ToolTypes"),
					    td.tratID,   wmttCheckmark,
			  td.trobSpace,	    td.trstBIG,
			td.trgrEnd,	    NIL,
			td.trobSpace,	  td.trstSMALL,
		      td.trgrEnd,	  NIL,
		    td.trobSpace,	td.trstSMALL,
		    td.trgrEnd,		NIL,
		    (* ··· END ToolTypes Group ·································· *)
		    
		    (* ··· Separator ············································ *)
		    td.trobSpace,	td.trstSMALL,
		    td.trgrHoriz,	td.trgrEQUALSHARE+td.trgrCENTER,
		    td.trobSpace,	td.trstSMALL,
		    td.trobLine,	td.trofHORIZ,
		    td.trobSpace,	td.trstSMALL,
		    td.trgrEnd,		NIL,
		    td.trobSpace,	td.trstSMALL,
		    (* ··· END Separator ········································ *)
		    
		    (* ··· Image Group ·········································· *)
		    td.trgrHoriz,	td.trgrCENTER+td.trgrPROPSHARE,
		      td.trobSpace,	td.trstSMALL,
		      td.trobCheckBox,	NIL,
					td.tratID,   wmimCheckmark,
		      td.trobSpace,	td.trstSMALL,
		      td.trgrVert,	  td.trgrALIGN,
			td.trobSpace,	  td.trstSMALL,
			td.trgrHoriz,	    td.trgrALIGN,
			  td.trobSpace,	    td.trstSMALL,
			  td.trobText,	    NIL,
					    td.tratText, S.ADR("_Image"),
					    td.tratID,   wmimCheckmark,
			  td.trobSpace,	    td.trstBIG,
			td.trgrEnd,	    NIL,
			td.trobSpace,	  td.trstSMALL,
		      td.trgrEnd,	  NIL,
		    td.trobSpace,	td.trstSMALL,
		    td.trgrEnd,		NIL,
		    (* ··· END ToolTypes Group ·································· *)
		    
		    (* ··· Separator ············································ *)
		    td.trobSpace,	td.trstSMALL,
		    td.trgrHoriz,	td.trgrEQUALSHARE+td.trgrCENTER,
		    td.trobSpace,	td.trstSMALL,
		    td.trobLine,	td.trofHORIZ,
		    td.trobSpace,	td.trstSMALL,
		    td.trgrEnd,		NIL,
		    td.trobSpace,	td.trstSMALL,
		    (* ··· END Separator ········································ *)
		    
		    (* ··· Drawer Data Group ···································· *)
		    td.trgrHoriz,	td.trgrCENTER+td.trgrPROPSHARE,
		      td.trobSpace,	td.trstSMALL,
		      td.trobCheckBox,	NIL,
					td.tratID,   wmddCheckmark,
		      td.trobSpace,	td.trstSMALL,
		      td.trgrVert,	  td.trgrALIGN,
			td.trobSpace,	  td.trstSMALL,
			td.trgrHoriz,	    td.trgrALIGN,
			  td.trobSpace,	    td.trstSMALL,
			  td.trobText,	    NIL,
					    td.tratText, S.ADR("_Drawer Data"),
					    td.tratID,   wmddCheckmark,
			  td.trobSpace,	    td.trstBIG,
			td.trgrEnd,	    NIL,
			td.trobSpace,	  td.trstSMALL,
		      td.trgrEnd,	  NIL,
		    td.trobSpace,	td.trstSMALL,
		    td.trgrEnd,		NIL,
		    (* ··· END Drawer Data Group ································ *)
		    
		    (* ··· Separator ············································ *)
		    td.trobSpace,	td.trstSMALL,
		    td.trgrHoriz,	td.trgrEQUALSHARE+td.trgrCENTER,
		    td.trobSpace,	td.trstSMALL,
		    td.trobLine,	td.trofHORIZ,
		    td.trobSpace,	td.trstSMALL,
		    td.trgrEnd,		NIL,
		    td.trobSpace,	td.trstSMALL,
		    (* ··· END Separator ········································ *)
		    
		    (* ··· ImageDepth Group ····································· *)
		    td.trgrHoriz,	td.trgrCENTER+td.trgrPROPSHARE,
		      td.trobSpace,	td.trstSMALL,
		      td.trobCheckBox,	NIL,
					td.tratID,   wmidCheckmark,
		      td.trobSpace,	td.trstSMALL,
		      td.trgrVert,	  td.trgrALIGN,
			td.trobSpace,	  td.trstSMALL,
			td.trgrHoriz,	    td.trgrALIGN,
			  td.trobSpace,	    td.trstSMALL,
			  td.trobText,	    NIL,
					    td.tratText, S.ADR("Ima_ge Depth"),
					    td.tratID,   wmidCheckmark,
			  td.trobSpace,	    td.trstBIG,
			td.trgrEnd,	    NIL,
			td.trobSpace,	  td.trstSMALL,
			td.trobSlider,	  td.trofHORIZ,
					  td.tratID,    wmidSlider,
					  td.tratValue, 3,
					  td.trslMin,   1,
					  td.trslMax,   5,
			td.trobSpace,	  td.trstSMALL,
		      td.trgrEnd,	  NIL,
		    td.trobSpace,	td.trstSMALL,
		    td.trgrEnd,		NIL,
		    (* ··· END ImageDepth Group ································· *)
		    
		    (* ··· Separator ············································ *)
		    td.trobSpace,	td.trstSMALL,
		    td.trgrHoriz,	td.trgrEQUALSHARE+td.trgrCENTER,
		    td.trobSpace,	td.trstSMALL,
		    td.trobLine,	td.trofHORIZ,
		    td.trobSpace,	td.trstSMALL,
		    td.trgrEnd,		NIL,
		    td.trobSpace,	td.trstSMALL,
		    (* ··· END Separator ········································ *)
		    
		    (* ··· Stack Group ·········································· *)
		    td.trgrHoriz,	td.trgrCENTER+td.trgrPROPSHARE,
		      td.trobSpace,	td.trstSMALL,
		      td.trobCheckBox,	NIL,
					td.tratID,   wmstCheckmark,
		      td.trobSpace,	td.trstSMALL,
		      td.trgrVert,	  td.trgrALIGN+td.trgrPROPSHARE,
			td.trobSpace,	  td.trstSMALL,
			td.trgrHoriz,	    td.trgrALIGN+td.trgrPROPSPACES,
			  td.trobText,	    NIL,
					    td.tratText, S.ADR("_Stack"),
					    td.tratID,   wmstCheckmark,
			  td.trobSpace,	    td.trstBIG,
			td.trgrEnd,	    NIL,
			td.trobSpace,	  td.trstSMALL,
			td.trobString,	  S.ADR("4096"),
					  td.tratID,    wmstEntry,
					  td.tratValue, 11,
			td.trobSpace,	  td.trstSMALL,
		      td.trgrEnd,	  NIL,
		    td.trobSpace,	td.trstSMALL,
		    td.trgrEnd,		NIL,
		    (* ··· END Stack Group ······································ *)
		    
		  td.trobSpace,	    td.trstSMALL,
		  td.trgrEnd,	    NIL,
		  (* ··· END Mode Group ········································· *)
		  
		  
		  (* ··· Selection Group ········································ *)
		  td.trgrVert,	    td.trgrALIGN+td.trgrPROPSHARE+td.trgrPROPSPACES,
		  td.trobSpace,	    td.trstSMALL,
		  
		    (* ··· Pages Group ·········································· *)
		    td.trobFrameBox, td.trfbFRAMING,
				     td.tratText, S.ADR("Windows"),
		    td.trgrHoriz,    td.trgrALIGN+td.trgrEQUALSHARE,
		    td.trobSpace,    td.trstSMALL,
		    td.trgrVert,     td.trgrALIGN+td.trgrEQUALSHARE,
		    td.trobSpace,    td.trstSMALL,
		    
		      (* ··· ToolType-Page-Selector ····························· *)
		      td.trgrHoriz,       td.trgrALIGN+td.trgrCENTER,
		      td.trobSpace,       td.trstSMALL,
			td.trobButton,	  td.trbtTEXT,
					  td.tratText,  S.ADR("T_oolTypes"),
					  td.tratID,    miToolTypes,
					  td.tratFlags, td.trbuYRESIZE,
		      td.trobSpace,	  td.trstSMALL,
		      td.trgrEnd,	  NIL,
		      (* ··· END ToolType-Page-Selector ························· *)
		    
		      td.trobSpace,	td.trstSMALL,
		    
		      (* ··· DrawerData-Page-Selector ··························· *)
		      td.trgrHoriz,       td.trgrALIGN+td.trgrCENTER,
		      td.trobSpace,       td.trstSMALL,
			td.trobButton,	  td.trbtTEXT,
					  td.tratText,  S.ADR("D_rawer Data"),
					  td.tratID,    miDrawerData,
					  td.tratFlags, td.trbuYRESIZE,
		      td.trobSpace,	  td.trstSMALL,
		      td.trgrEnd,	  NIL,
		      (* ··· END DrawerData-Page-Selector ······················· *)
		    
		      td.trobSpace,	td.trstSMALL,
		    
		      (* ··· ColorSwap-Page-Selector ···························· *)
		      td.trgrHoriz,       td.trgrALIGN+td.trgrCENTER,
		      td.trobSpace,       td.trstSMALL,
			td.trobButton,	  td.trbtTEXT,
					  td.tratText,  S.ADR("Co_lorSwap"),
					  td.tratID,    miColorSwap,
					  td.tratFlags, td.trbuYRESIZE,
		      td.trobSpace,	  td.trstSMALL,
		      td.trgrEnd,	  NIL,
		      (* ··· END ColorSwap-Page-Selector ························ *)
		    
		      td.trobSpace,	td.trstSMALL,
		    
		      (* ··· Information-Page-Selector ·························· *)
		      td.trgrHoriz,       td.trgrALIGN+td.trgrCENTER,
		      td.trobSpace,       td.trstSMALL,
			td.trobButton,	  td.trbtTEXT,
					  td.tratText,  S.ADR("I_nformation"),
					  td.tratID,    miInformation,
					  td.tratFlags, td.trbuYRESIZE,
		      td.trobSpace,	  td.trstSMALL,
		      td.trgrEnd,	  NIL,
		      (* ··· END Information-Page-Selector ······················ *)
		    
		    td.trobSpace,      td.trstSMALL,
		    td.trgrEnd,	       NIL,
		    td.trobSpace,      td.trstSMALL,
		    td.trgrEnd,	       NIL,
		    (* ··· END Pages Group ······································ *)
		  
		    (* ··· Icon Group ··········································· *)
		    td.trgrHoriz,    td.trgrALIGN+td.trgrEQUALSHARE+td.trgrPROPSPACES,
		    td.trobSpace,    td.trstSMALL,
		      
		      (* ··· Source Group ······································· *)
		      td.trobFrameBox,	td.trfbFRAMING,
					td.tratText, S.ADR("Source"),
		      td.trgrHoriz,	td.trgrALIGN+td.trgrEQUALSHARE+td.trgrPROPSPACES,
		      td.trobSpace,	td.trstSMALL,
		      td.trgrVert,	td.trgrALIGN+td.trgrPROPSHARE+td.trgrPROPSPACES,
		      td.trobSpace,	td.trstSMALL,
		      
			td.trobDropBox,	  NIL,
					  td.tratID, sGroup,
			td.trobSpace,	  td.trstSMALL,
			td.trobCycle,	  S.ADR(sourceList),
					  td.tratID,    sSelected,
					  td.tratValue, 0,
			td.trobSpace,	  td.trstSMALL,
			td.trgrHoriz, 	    td.trgrALIGN+td.trgrPROPSPACES,
			  td.trobCheckBox,  NIL,
					    td.tratID, sImageOnly,
			  td.trobSpace,     td.trstNORMAL,
			  td.trobText,	    NIL,
					    td.tratText, S.ADR("Image Onl_y"),
					    td.tratID,   sName,
			  td.trobSpace,	    td.trstBIG,
			  td.trobSpace,	    td.trstBIG,
			td.trgrEnd,	    NIL,
			td.trobSpace,	  td.trstSMALL,
			td.trobFrameBox,  td.trfbTEXT,
			td.trgrHoriz,	    td.trgrALIGN+td.trgrPROPSPACES,
			  td.trobSpace,	    td.trstBIG,
			  td.trobText,	    NIL,
					    td.tratText, S.ADR("SourceName"),
					    td.tratID,   sName,
			  td.trobSpace,	    td.trstBIG,
			td.trgrEnd,	    NIL,
		      
		      td.trobSpace,	td.trstSMALL,
		      td.trgrEnd,	NIL,
		      td.trobSpace,	td.trstSMALL,
		      td.trgrEnd,	NIL,
		      (* ··· END Source Group ··································· *)
		      
		    td.trobSpace,     td.trstSMALL,
		    
		      (* ··· Destination Group ·································· *)
		      td.trobFrameBox,	td.trfbFRAMING,
					td.tratText, S.ADR("Destination"),
		      td.trgrHoriz,	td.trgrALIGN+td.trgrPROPSPACES,
		      td.trobSpace,	td.trstSMALL,
		      td.trgrVert,	td.trgrALIGN,
		      td.trobSpace,	td.trstSMALL,
		      
			td.trobDropBox,	  NIL,
					  td.tratID, dGroup,
			td.trobSpace,	  td.trstSMALL,
			td.trobFrameBox,  td.trfbTEXT,
			td.trgrHoriz,	    td.trgrALIGN,
			  td.trobSpace,	    td.trstBIG,
			  td.trobText,	    NIL,
					    td.tratText, S.ADR("DestName"),
					    td.tratID,   dName,
			  td.trobSpace,	    td.trstBIG,
			td.trgrEnd,	    NIL,
		      
		      td.trobSpace,	td.trstSMALL,
		      td.trgrEnd,	NIL,
		      td.trobSpace,	td.trstSMALL,
		      td.trgrEnd,	NIL,
		      (* ··· END Destination Group ······························ *)
		      
		    td.trobSpace,     td.trstSMALL,
		    td.trgrEnd,	      NIL,
		    (* ··· END Icon Group ······································· *)
		  
		  td.trobSpace,	    td.trstSMALL,
		  td.trgrEnd,	    NIL,
		  (* ··· END Selection Group ···································· *)
		  
		td.trobSpace,	td.trstSMALL,
		td.trgrEnd,	NIL,
		td.trobSpace,	td.trstSMALL,
		td.trgrEnd,	NIL,
		(* ··· END Main Group ··········································· *)
		
	  ud.tagEnd)
	); (* OpenProject *)
 
 A.Assert(Project#NIL, S.ADR("Couldn't open Project!"));
 
 END InitProject;


VAR	trMsg	: td.TrMessagePtr;
	quit	: BOOLEAN;

BEGIN

InitApplication;
InitProject;

quit:= FALSE;
WHILE	~quit
 DO	(* --- Wait for a Message ----------------------------------------------- *)
	IGNORE tl.Wait( App, 0 );
	
	(* --- Eval Messages as long as one appears ----------------------------- *)
	trMsg:= tl.GetMsg( App );
	WHILE	(trMsg # NIL)
	 DO	(* --- Only take care if it's for our Project ------------------- *)
		IF	(trMsg^.project = Project)
		 THEN	CASE trMsg^.class OF
			 | td.trmsCLOSEWINDOW :
				quit:= TRUE;
			 ELSE	(* unknown code *)
			 END; (* case *)
		 END; (* if *)
		
		(* --- Answer the Message and get next -------------------------- *)
		tl.ReplyMsg( trMsg );
		trMsg:= tl.GetMsg( App );
		
	 END; (* while *)
 END; (* while *)


CLOSE

IF	Project # NIL
 THEN	tl.CloseProject(Project);
	Project:= NIL;
 END;

IF	App # NIL
 THEN	tl.DeleteApp(App);
	App:= NIL;
 END;

END Demo2.
