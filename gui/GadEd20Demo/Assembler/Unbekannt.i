; Erstellt mit GadEd V2.0
; Geschrieben von Michael Neumann und Thomas Patschinski


; Proc00-Requester
; Gadget Lables

Proc00GadEdGadget000                     EQU 0
Proc00GadEdGadget001                     EQU 1
Proc00GadEdGadget002                     EQU 2
Proc00GadEdGadget003                     EQU 3
Proc00GadEdGadget004                     EQU 4
Proc00GadEdGadget005                     EQU 5
Proc00GadEdGadget006                     EQU 6
Proc00GadEdGadget007                     EQU 7
Proc00GadEdGadget008                     EQU 8
Proc00GadEdGadget009                     EQU 9
Proc00GadEdGadget010                     EQU 10
Proc00GadEdGadget011                     EQU 11
Proc00GadEdGadget012                     EQU 12
Proc00GadEdGadget013                     EQU 13
Proc00GadEdGadget014                     EQU 14
Proc00GadEdGadget015                     EQU 15
Proc00GadEdGadget016                     EQU 16
Proc00GadEdGadget017                     EQU 17
Proc00GadEdGadget018                     EQU 18
Proc00GadEdGadget019                     EQU 19
Proc00GadEdGadget020                     EQU 20
Proc00GadEdGadget021                     EQU 21
Proc00GadEdGadget022                     EQU 22
Proc00GadEdGadget023                     EQU 23
Proc00GadEdGadget024                     EQU 24
Proc00GadEdGadget025                     EQU 25
Proc00GadEdGadget026                     EQU 26
Proc00GadEdGadget027                     EQU 27

; Menü Lables

Proc00GadEdTitel000                      EQU 0
Proc00GadEdItem000                       EQU 0
Proc00GadEdItem001                       EQU 2
Proc00GadEdItem002                       EQU 3
Proc00GadEdItem003                       EQU 5
Proc00GadEdTitel001                      EQU 1
Proc00GadEdItem004                       EQU 0
Proc00GadEdItem005                       EQU 1
Proc00GadEdItem006                       EQU 2
Proc00GadEdTitel002                      EQU 2
Proc00GadEdItem007                       EQU 0
Proc00GadEdSub000                        EQU 0
Proc00GadEdSub001                        EQU 2
Proc00GadEdItem008                       EQU 1
Proc00GadEdItem009                       EQU 2
Proc00GadEdItem010                       EQU 3
Proc00GadEdItem011                       EQU 5
Proc00GadEdItem012                       EQU 6
Proc00GadEdTitel003                      EQU 3
Proc00GadEdItem013                       EQU 0
Proc00GadEdItem014                       EQU 1
Proc00GadEdItem015                       EQU 3
Proc00GadEdSub002                        EQU 0
Proc00GadEdSub003                        EQU 1

; Proc01-Requester
; Gadget Lables

Proc01GadEdGadget000                     EQU 0
Proc01GadEdGadget001                     EQU 1
Proc01GadEdGadget002                     EQU 2
Proc01GadEdGadget003                     EQU 3
Proc01GadEdGadget004                     EQU 4
Proc01GadEdGadget005                     EQU 5
Proc01GadEdGadget006                     EQU 6
Proc01GadEdGadget007                     EQU 7
Proc01GadEdGadget008                     EQU 8
Proc01GadEdGadget009                     EQU 9
Proc01GadEdGadget010                     EQU 10
Proc01GadEdGadget011                     EQU 11
Proc01GadEdGadget012                     EQU 12
Proc01GadEdGadget013                     EQU 13
Proc01GadEdGadget014                     EQU 14
Proc01GadEdGadget015                     EQU 15
Proc01GadEdGadget016                     EQU 16
Proc01GadEdGadget017                     EQU 17
Proc01GadEdGadget018                     EQU 18
Proc01GadEdGadget019                     EQU 19
Proc01GadEdGadget020                     EQU 20
Proc01GadEdGadget021                     EQU 21
Proc01GadEdGadget022                     EQU 22
Proc01GadEdGadget023                     EQU 23
Proc01GadEdGadget024                     EQU 24
Proc01GadEdGadget025                     EQU 25
Proc01GadEdGadget026                     EQU 26
Proc01GadEdGadget027                     EQU 27

; Menü Lables

Proc01GadEdTitel000                      EQU 0
Proc01GadEdItem000                       EQU 0
Proc01GadEdItem001                       EQU 2
Proc01GadEdItem002                       EQU 3
Proc01GadEdItem003                       EQU 5
Proc01GadEdTitel001                      EQU 1
Proc01GadEdItem004                       EQU 0
Proc01GadEdItem005                       EQU 1
Proc01GadEdItem006                       EQU 2
Proc01GadEdTitel002                      EQU 2
Proc01GadEdItem007                       EQU 0
Proc01GadEdSub000                        EQU 0
Proc01GadEdSub001                        EQU 2
Proc01GadEdItem008                       EQU 1
Proc01GadEdItem009                       EQU 2
Proc01GadEdItem010                       EQU 3
Proc01GadEdItem011                       EQU 5
Proc01GadEdItem012                       EQU 6
Proc01GadEdTitel003                      EQU 3
Proc01GadEdItem013                       EQU 0
Proc01GadEdItem014                       EQU 1
Proc01GadEdItem015                       EQU 3
Proc01GadEdSub002                        EQU 0
Proc01GadEdSub003                        EQU 1

		XREF	Liste_0
		XREF	Liste_1
		XREF	ListViewList00_0
		XREF	ListViewList00_1
		XREF	Men
		XREF	Menu00
		XREF	G0
		XREF	GPtrs00


		XREF	InitUnbekannt

		XREF	RefreshProc00
		XREF	InitProc00Mask
		XREF	GetProc00GPtr
		XREF	CloseProc00Mask
		XREF	RefreshProc01
		XREF	InitProc01Mask
		XREF	GetProc01GPtr
		XREF	CloseProc01Mask

		XREF	FreeUnbekannt
