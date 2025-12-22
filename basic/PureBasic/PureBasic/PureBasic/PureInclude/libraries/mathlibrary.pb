;#ifndef LIBRARIES_MATHLIBRARY_H
;#define LIBRARIES_MATHLIBRARY_H
;/*
;**  $VER: mathlibrary.h 1.6 (13.7.90)
;**  Includes Release 40.15
;**
;**  Data structure returned by OpenLibrary of:
;**  mathieeedoubbas.library,mathieeedoubtrans.library
;**  mathieeesingbas.library,mathieeesingtrans.library
;**
;**  (C) Copyright 1987-1993 Commodore-AMIGA, Inc.
;**      All Rights Reserved
;*/

IncludePath   "PureInclude:"
XIncludeFile "exec/libraries.pb"

Structure MathIEEEBase
  MathIEEEBase_LibNode.Library
  MathIEEEBase_reserved.b[18]
  *MathIEEEBase_TaskOpenLib.l
  *MathIEEEBase_TaskCloseLib.l
  ;  This structure may be extended in the future
EndStructure

;
;* Math resources may need To know when a program opens OR closes this
;* library. The functions TaskOpenLib AND TaskCloseLib are called when
;* a task opens OR closes this library. They are initialized To point To
;* local initialization pertaining To 68881 stuff If 68881 resources
;* are found. To override the Default the vendor must provide appropriate
;* hooks in the MathIEEEResource. If specified, these will be called
;* when the library initializes.
;*/
