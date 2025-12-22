/*-----------------------------------------------------------------*/
/* Filename : egsgadbox.fd*/
/* Release  : 1.0*/
/**/
/* fd file for egsgadbox.def*/
/**/
/* (c) Copyright 1990/92 VIONA Development*/
/*     All Rights Reserved*/
/**/
/* Author      : Markus van Kempen*/
/* Created     : 14. Jul 1992*/
/* Updated     : 14. Jul 1992*/
/* Updated     : 30. Jul 1992 US*/
/*               10. Jan 1993 US/JSM*/
/**/
/*-----------------------------------------------------------------*/
#pragma libcall EGBBase EB_AllocMemCon 1E 0802
#pragma libcall EGBBase EB_FreeMemCon 24 801
#pragma libcall EGBBase EB_AddFirstSon 2A 9802
#pragma libcall EGBBase EB_AddLastSon 30 9802
#pragma libcall EGBBase EB_MIN 36 1002
#pragma libcall EGBBase EB_MAX 3C 1002
#pragma libcall EGBBase EB_SWidth 42 9802
#pragma libcall EGBBase EB_SMatch 48 29803
#pragma libcall EGBBase EB_CWidth 4E 9202
#pragma libcall EGBBase EB_FindGadget 54 10803
#pragma libcall EGBBase EB_CreateGadContext 5A 109804
#pragma libcall EGBBase EB_DeleteGadContext 60 801
#pragma libcall EGBBase EB_CreateBox 66 43210806
#pragma libcall EGBBase EB_CreateLateBox 6C 32109806
#pragma libcall EGBBase EB_CreateResponseBox 72 32109806
#pragma libcall EGBBase EB_CreateInfoBox 78 210A9806
#pragma libcall EGBBase EB_WriteInfoBox 7E A9803
#pragma libcall EGBBase EB_WriteInfoBoxInt 84 09803
#pragma libcall EGBBase EB_CreateHorizBox 8A 801
#pragma libcall EGBBase EB_CreateVertiBox 90 801
#pragma libcall EGBBase EB_CreateHorizTable 96 801
#pragma libcall EGBBase EB_CreateVertiTable 9C 801
#pragma libcall EGBBase EB_CreateFillBox A2 801
#pragma libcall EGBBase EB_CreateHorizFill A8 10803
#pragma libcall EGBBase EB_CreateVertiFill AE 10803
#pragma libcall EGBBase EB_CreateBorder B4 09803
#pragma libcall EGBBase EB_CreateText BA 9802
#pragma libcall EGBBase EB_CreateCenterText C0 9802
#pragma libcall EGBBase EB_CreateBackBorder C6 09803
#pragma libcall EGBBase EB_CreateFrontBorder CC 09803
#pragma libcall EGBBase EB_CreateButton24 D2 2109805
#pragma libcall EGBBase EB_CreateDoubleBorder D8 09803
#pragma libcall EGBBase EB_CreateMultiText DE 9802
#pragma libcall EGBBase EB_CreateBoxedMultiText E4 9802
#pragma libcall EGBBase EB_CreateArrowGfx EA 0802
#pragma libcall EGBBase EB_NewPri F0 0802
#pragma libcall EGBBase EB_NewMinHeight F6 0802
#pragma libcall EGBBase EB_NewMinWidth FC 0802
#pragma libcall EGBBase EB_NewMaxHeight 102 0802
#pragma libcall EGBBase EB_NewMaxWidth 108 0802
#pragma libcall EGBBase EB_NewFixHeight 10E 801
#pragma libcall EGBBase EB_NewFixWidth 114 801
#pragma libcall EGBBase EB_CreateMaster 11A 10803
#pragma libcall EGBBase EB_CreateActionGadget 120 09803
#pragma libcall EGBBase EB_CreateTextAction 126 109804
#pragma libcall EGBBase EB_CreateBoolGadget 12C 09803
#pragma libcall EGBBase EB_CreateTextBoolean 132 109804
#pragma libcall EGBBase EB_CreateMultiAction 138 109804
#pragma libcall EGBBase EB_CreateMultiActionV 13E 109804
#pragma libcall EGBBase EB_CreateMultiAction2 144 09803
#pragma libcall EGBBase EB_CreateArrow 14A 10803
#pragma libcall EGBBase EB_CreateHorizProp 150 3210805
#pragma libcall EGBBase EB_CreateVertiProp 156 3210805
#pragma libcall EGBBase EB_CreateSuperHorizProp 15C 43210806
#pragma libcall EGBBase EB_CreateSuperVertiProp 162 43210806
#pragma libcall EGBBase EB_CreateStringGadget 168 3210805
#pragma libcall EGBBase EB_CreateNameStringGadget 16E 32109806
#pragma libcall EGBBase EB_CreateIntegerGadget 174 210804
#pragma libcall EGBBase EB_CreateNameIntegerGadget 17A 2109805
#pragma libcall EGBBase EB_CreateRealGadget 180 210804
#pragma libcall EGBBase EB_CreateNameRealGadget 186 2109805
#pragma libcall EGBBase EB_LinkStringGadgets 18C A9803
#pragma libcall EGBBase EB_LinkStringGadgetsID 192 2910805
#pragma libcall EGBBase EB_GetStringData 198 9802
#pragma libcall EGBBase EB_PutStringData 19E A9803
#pragma libcall EGBBase EB_PutIntData 1A4 09803
#pragma libcall EGBBase EB_PutRealData 1AA 43209806
#pragma libcall EGBBase EB_CreateWindow 1B0 10803
#pragma libcall EGBBase EB_CreateMasterWindow 1B6 A9803
#pragma libcall EGBBase EB_CalcMinMax 1BC 801
#pragma libcall EGBBase EB_CalcRealSize 1C2 801
#pragma libcall EGBBase EB_CalcPositions 1C8 10803
#pragma libcall EGBBase EB_CalcGadgetGfx 1CE 9802
#pragma libcall EGBBase EB_ConnectGadgets 1D4 A9803
#pragma libcall EGBBase EB_ProcessGadBoxes 1DA 9802
#pragma libcall EGBBase EB_NewSameSize 1E0 801
#pragma libcall EGBBase EB_CreateButtonGadget 1E6 0802
#pragma libcall EGBBase EB_CreateCheckMarkGadget 1EC 0802
#pragma libcall EGBBase EB_ProcessGadBoxesSize 1F2 109804
#pragma libcall EGBBase EB_CreateGroupBorder 1F8 A09804
