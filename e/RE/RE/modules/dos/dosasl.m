#ifndef DOS_DOSASL_H
#define DOS_DOSASL_H

#ifndef EXEC_LIBRARIES_H
MODULE  'exec/libraries'
#endif
#ifndef EXEC_LISTS_H
MODULE  'exec/lists'
#endif
#ifndef DOS_DOS_H
MODULE  'dos/dos'
#endif

OBJECT AnchorPath
 
	 	Base:PTR TO AChain	
#define	ap_First ap_Base
	 	Last:PTR TO AChain	
#define ap_Current ap_Last
	BreakBits:LONG	
	FoundBreak:LONG	
	Flags:BYTE	
	Reserved:BYTE
	Strlen:WORD	
#define	ap_Length ap_Flags	
		 Info:FileInfoBlock
	Buf[1]:UBYTE	
	
ENDOBJECT

#define	APB_DOWILD	0	
#define APF_DOWILD	1
#define	APB_ITSWILD	1	
#define APF_ITSWILD	2	
				
				
				
#define	APB_DODIR	2	
#define APF_DODIR	4	
				
				
#define	APB_DIDDIR	3	
#define APF_DIDDIR	8
#define	APB_NOMEMERR	4	
#define APF_NOMEMERR	16
#define	APB_DODOT	5	
#define APF_DODOT	32	
#define APB_DirChanged	6	
#define APF_DirChanged	64	
#define APB_FollowHLinks 7	
#define APF_FollowHLinks 128	
OBJECT AChain
 
	  Child:PTR TO AChain
	  Parent:PTR TO AChain
	Lock:LONG
	  Info:FileInfoBlock
	Flags:BYTE
	String[1]:UBYTE	
ENDOBJECT

#define	DDB_PatternBit	0
#define	DDF_PatternBit	1
#define	DDB_ExaminedBit	1
#define	DDF_ExaminedBit	2
#define	DDB_Completed	2
#define	DDF_Completed	4
#define	DDB_AllBit	3
#define	DDF_AllBit	8
#define	DDB_Single	4
#define	DDF_Single	16

#define P_ANY		$80	
#define P_SINGLE	$81	
#define P_ORSTART	$82	
#define P_ORNEXT	$83	
#define P_OREND	$84	
#define P_NOT		$85	
#define P_NOTEND	$86	
#define P_NOTCLASS	$87	
#define P_CLASS	$88	
#define P_REPBEG	$89	
#define P_REPEND	$8A	
#define P_STOP		$8B	

#define COMPLEX_BIT	1	
#define EXAMINE_BIT	2	

#define ERROR_BUFFER_OVERFLOW	303	
#define ERROR_BREAK		304	
#define ERROR_NOT_EXECUTABLE	305	
#endif 
