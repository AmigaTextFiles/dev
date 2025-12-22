/****h* AmigaTalk/PrimStrs.h [1.9] ************************************
*
* NAME
*    PrimStrs.h
*
* DESCRIPTION
*    These strings describe the primitive functions corresponding to
*    the correct primitive number.
*
* NOTES
*    This header file is ONLY used by Interp.c.
*
*    Primitves 0, 27, 31, 40, 41, 48, 49, 74, 83, 87, 90, 95,
*              139, 144, 147, 166-168  are not used
*
*    $VER: AmigaTalk:Src/PrimStrs.h 1.9 (12-Jan-2002) by J.T Steichen
***********************************************************************
*
*/

PRIVATE char *PrimStrings[] = {
    
    "NoOP",
    "FindObjectClass",
    "FindSuperObject",
    "ClassRespondsToNew",
    "ObjectSize",
    "ObjectHashNum",        // # 5
    "ObjectSameType",
    "ObjectsEqual",
    "ToggleDebug",
    "GeneralityCompare",

    "AddIntegers",          // #10
    "SubIntegers",
    "Int_CharLessThan",     // 12 & 42
    "Int_CharGreaterThan",  // 13 & 43
    "Int_CharLEQ",          // 14 & 44
    "Int_CharGEQ",          // 15 & 45
    "Int_CharEQ",           // 16 & 46
    "Int_CharNEQ",          // 17 & 47
    "MultIntegers",
    "DSlashIntegers",

    "GCDIntegers",          // #20
    "BitAt", 
    "BitOR",
    "BitAND",
    "BitXOR",
    "BitShift",             // #25
    "IntegerRadix",
    "Not Used",
    "DivIntegers",
    "ModulusIntegers",
    
    "DoPrimitive_2Args",    // #30
    "Not Used",
    "RandomFloat",
    "BitInverse",
    "HighBit",
    "RandomNumber",         // #35
    "IntegerToChar",
    "IntegerToString",
    "Factorial",
    "IntegerToFloat",
    
    "Not Used",             // #40
    "Not Used",
    "Int_CharLessThan",     // 12 & 42
    "Int_CharGreaterThan",  // 13 & 43
    "Int_CharLEQ",          // 14 & 44
    "Int_CharGEQ",          // 15 & 45
    "Int_CharEQ",           // 16 & 46
    "Int_CharNEQ",          // 17 & 47
    "Not Used",
    "Not Used",

    "DigitValue",           // #50
    "IsVowel",
    "IsAlpha",
    "IsLower",
    "IsUpper",
    "IsSpace",              // #55
    "IsAlNum",
    "ChangeCase",
    "CharToString",
    "CharToInteger",

    "AddFloats",            // #60
    "SubFloats",
    "FloatLessThan",
    "FloatGreaterThan",
    "FloatLEQ",
    "FloatGEQ",             // #65
    "FloatEQ",
    "FloatNEQ",
    "MultFloats",
    "DivFloats",

    "NaturalLog",           // #70
    "SquareRoot",
    "Floor",
    "Ceiling",
    "Not Used",
    "IntegerPart",          // #75
    "FractionPart",
    "GammaFunc",
    "FloatToString",
    "Exponent",

    "NormalizeRadian",      // #80
    "Sin",
    "Cos",
    "Not Used",
    "ASin",
    "ACos",                 // #85
    "ATan",
    "Not Used",
    "Power",
    "FloatRadixPrint",

    "MiscSymbolOps",        // #90 added on 28-Mar-2002 to Symbol.c
    "SymbolCompare",
    "SymbolToString",
    "SymbolAsString",
    "SymbolPrint",
    "Not Used",             // #95
    "ASCIIValue",
    "NewClass",
    "InstallClass",
    "FindClass",

    "StringLen",            // #100
    "StringCompare",
    "StringCompNoCase",
    "String_Cat",
    "StringAt",
    "StringAtPut",          // #105
    "CopyFromLength",
    "String_Copy",
    "StringAsSymbol",
    "StrPrintString",

    "New_Object",           // #110
    "ObjectAt",
    "ObjectAtPut",
    "ObjectGrow",
    "NewArray",
    "NewString",            // #115
    "NewByteArray",
    "ByteArraySize",
    "ByteArrayAt",
    "ByteArrayAtPut",

    "PrintNOReturn",        // #120
    "Print_Return",
    "FormatError",
    "ErrorPrint",
    "CursesPrim",
    "SystemCall",           // #125
    "PrintAt",
    "BlockReturn",
    "ReferenceError",
    "DoesNotRespond",

    "FileOpen",             // #130
    "FileRead",
    "FileWrite",
    "SetFileMode",
    "GetFileSize",
    "SetFilePosition",      // #135
    "GetFilePosition",
    "HandleClassInfo",      // 137 added on 27-Jan-2002 ClDict.c
    "HandleSupervisor",     // 138 added on 31-Jan-2002 Global.c
    "Not Used",
     
    "BlockExecute",         // #140
    "NewProcessPrim",
    "TerminateProcess",
    "Perform_W_Args",
    "BlockNumArgs",
    "SetProcessState",      // #145
    "GetProcessState",
    "Not Used",
    "BeginAtomicAction",
    "EndAtomicAction",

    "EditClass",            // #150
    "FindSuperClass",
    "GetClassName",
    "ClassNew",
    "PrintMessages",
    "ClassRespondsTo",      // #155
    "ViewClass",
    "ListSubClasses",
    "ClassesInstVars",
    "GetByteCodeArray",

    "GetCurrentTime",       // #160
    "TimeCounter",
    "ClearScreen",
    "GetString",
    "StringToInteger",
    "StringToFloat",        // #165
    "Not Used",
    "Not Used",
    "Not Used",
    "PlotEnv",
    "PlotClear",            // #170  
    "PlotMove",
    "PlotContinue",       
    "PlotPoint",           
    "PlotCircle",
    "PlotBox",              // #175
    "PlotSetPens",         
    "PlotLine",
    "PlotLabel",          
    "PlotLineType",
     
    "HandleScreens",        // #180
    "HandleWindows",      
    "HandleMenus",         
    "HandleGadgets",
    "HandleColors",       
    "HandleRequesters",     // #185     
    "HandleIO",
    "HandleBorders",      
    "HandleIText",         
    "HandleBitMaps",

    "HandleLibraries",      // #190    
    "HandleMsgPorts",      
    "HandleTasks",
    "HandleProcesses",    
    "HandleMemory",        
    "HandleLists",          // #195
    "HandleInterrupts",   
    "HandleSemaphores",    
    "HandleSignals",
    "HandleExceptions",   

    "HandleSimpleGraphs",   // #200  
    "HandleAreas",
    "HandleViewPorts",    
    "HandleViews",         
    "HandlePlayFields",
    "UnusedPrimitive",      // #205    
    "UnusedPrimitive",     
    "HandleLayers",         // #207
    "UnusedPrimitive",    
    "HandleLibIntfc",     

    "HandleDT",             // #210
    "HandleARexx",
    "UnusedPrimitive",     
    "UnusedPrimitive",
    "UnusedPrimitive",    
    "UnusedPrimitive",      // #215     
    "UnusedPrimitive",
    "UnusedPrimitive",    
    "UnusedPrimitive",     
    "HandleIcons",
    
    "HandleAudio",          // #220    
    "HandleClipBoard",     
    "HandleConsoleKeys",
    "HandleGamePort",     
    "HandleParallel",     
    "HandlePrinter",        // #225
    "HandleSCSI",
    "HandleSerial",        
    "UnusedPrimitive",
    "HandleDisk",
             
    "HandleNarrator",       // #230     
    "UnusedPrimitive",
    "UnusedPrimitive",    
    "UnusedPrimitive",     
    "UnusedPrimitive",
    "UnusedPrimitive",      // #235    
    "UnusedPrimitive",     
    "UnusedPrimitive",
    "HandleBoopsi",         // #238    
    "HandleGadTools",
         
    "HandleIFF",            // #240
    "HandleIFF",          
    "HandleIFF",           
    "HandleIFF",
    "HandleIFF",          
    "UnusedPrimitive",      // #245     
    "HandleADosSafe",
    "HandleADosUnSafe",    
    "HandleADosDanger",     
    "HandleADosVD",

    "HandleSystem",         // #250        
    "UnusedPrimitive",     
    "UnusedPrimitive",
    "UnusedPrimitive",    
    "UnusedPrimitive",     
    "UnusedPrimitive"       // #255

};
