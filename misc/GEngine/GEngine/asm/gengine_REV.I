 * $Revision Header *** Header built automatically - do not edit! ***********
 *
 *	(C) Copyright 1901 by Soft154i
 *
 *	Name .....: gengine_REV.I
 *	Created ..: Saturday 27-Oct-01 15:43:34
 *	Revision .: 0
 *
 *	Date        Author                 Comment
 *	=========   ====================   ====================
 *	27-Oct-01   Pablo Roldan           Created this file!
 *
 * $Revision Header ********************************************************
REVISION	EQU	0

* gengine_rev.i
*
********************************************************************************************
* gengine_rev.i version file (generated with the ``bumprev'' command)
*******************************************************************************************
VERSION         EQU     1
DATE    MACRO
                dc.b    '27.6.2001'
        ENDM
VERS    MACRO
                dc.b    'GEngine 0.1b'
        ENDM
VSTRING MACRO
                dc.b    'GEngine 0.1b (27.6.2001)',13,10,0
        ENDM
VERSTAG MACRO
                dc.b    0,'$VER: GEngine 0.1b (27.6.2001)',0
        ENDM

