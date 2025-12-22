#ifndef POWERPC_POWERPC_H
#define POWERPC_POWERPC_H
#ifndef EXEC_TYPES_H
MODULE  'exec/types'
#endif
#ifndef EXEC_LIBRARIES_H
MODULE  'exec/libraries'
#endif
#define POWERPCNAME 'powerpc.library'
OBJECT PPCBase
 
	 LibNode:Library
	SysLib:LONG
	DosLib:LONG
	SegList:LONG
	NearBase:LONG
	Flags:UBYTE
	DosVer:UBYTE
ENDOBJECT


#define HINFO_TAGS            (TAG_USER+$103000)
#define HINFO_ALEXC_HIGH      (HINFO_TAGS+0)     
#define HINFO_ALEXC_LOW       (HINFO_TAGS+1)     

#define SCHED_TAGS            (TAG_USER+$104000)
#define SCHED_REACTION        (SCHED_TAGS+0)     

#define GETINFO_TAGS    (TAG_USER+$102000)
#define GETINFO_CPU     (GETINFO_TAGS+0)   
#define GETINFO_PVR     (GETINFO_TAGS+1)   
#define GETINFO_ICACHE  (GETINFO_TAGS+2)   
#define GETINFO_DCACHE  (GETINFO_TAGS+3)   
#define GETINFO_PAGETABLE (GETINFO_TAGS+4)   
#define GETINFO_TABLESIZE (GETINFO_TAGS+5)   
#define GETINFO_BUSCLOCK (GETINFO_TAGS+6)   
#define GETINFO_CPUCLOCK (GETINFO_TAGS+7)   
#define GETINFO_CPULOAD (GETINFO_TAGS+8)   
#define GETINFO_SYSTEMLOAD (GETINFO_TAGS+9) 

#define CACHEB_ON_UNLOCKED      0
#define CACHEB_ON_LOCKED        1
#define CACHEB_OFF_UNLOCKED     2
#define CACHEB_OFF_LOCKED       3
#define CACHEF_ON_UNLOCKED      (1<<0)
#define CACHEF_ON_LOCKED        (1<<1)
#define CACHEF_OFF_UNLOCKED     (1<<2)
#define CACHEF_OFF_LOCKED       (1<<3)
#define CPUB_603   4
#define CPUB_603E  8
#define CPUB_604   12
#define CPUB_604E  16
#define CPUB_620   20
#define CPUF_603  (1<<4)
#define CPUF_603E (1<<8)
#define CPUF_604  (1<<12)
#define CPUF_604E (1<<16)
#define CPUF_620  (1<<20)
OBJECT PPCArgs
 
	Code:LONG          
	Offset:LONG        
	Flags:LONG         
	Stack:LONG         
	StackSize:LONG     
	Regs[15]:LONG      
	->FRegs[8]:DOUBLE     
	FRegs[16]:LONG     
ENDOBJECT


#define PPF_ASYNC   (1<<0) 
#define PPF_LINEAR  (1<<1) 
#define PPF_THROW   (1<<2) 

#define PPERR_SUCCESS  0 
#define PPERR_ASYNCERR 1 
#define PPERR_WAITERR  2 

#define PPREG_D0 0
#define PPREG_D1 1
#define PPREG_D2 2
#define PPREG_D3 3
#define PPREG_D4 4
#define PPREG_D5 5
#define PPREG_D6 6
#define PPREG_D7 7
#define PPREG_A0 8
#define PPREG_A1 9
#define PPREG_A2 10
#define PPREG_A3 11
#define PPREG_A4 12
#define PPREG_A5 13
#define PPREG_A6 14
#define PPREG_FP0 0
#define PPREG_FP1 1
#define PPREG_FP2 2
#define PPREG_FP3 3
#define PPREG_FP4 4
#define PPREG_FP5 5
#define PPREG_FP6 6
#define PPREG_FP7 7
#ifndef POWERPCLIB_V7 
		      
		      

#define CACHE_DCACHEOFF    1
#define CACHE_DCACHEON     2
#define CACHE_DCACHELOCK   3
#define CACHE_DCACHEUNLOCK 4
#define CACHE_DCACHEFLUSH  5
#define CACHE_ICACHEOFF    6
#define CACHE_ICACHEON     7
#define CACHE_ICACHELOCK   8
#define CACHE_ICACHEUNLOCK 9
#define CACHE_ICACHEINV    10
#define CACHE_DCACHEINV    11

#define HW_TRACEON              1             
#define HW_TRACEOFF             2             
#define HW_BRANCHTRACEON        3             
#define HW_BRANCHTRACEOFF       4             
#define HW_FPEXCON              5             
#define HW_FPEXCOFF             6             
#define HW_SETIBREAK            7             
#define HW_CLEARIBREAK          8             
#define HW_SETDBREAK            9             
#define HW_CLEARDBREAK          10            

#define HW_AVAILABLE      -1              
#define HW_NOTAVAILABLE    0              

#define PPCSTATEB_POWERSAVE     0              
#define PPCSTATEB_APPACTIVE     1              
#define PPCSTATEB_APPRUNNING    2              
#define PPCSTATEF_POWERSAVE     (1<<0)
#define PPCSTATEF_APPACTIVE     (1<<1)
#define PPCSTATEF_APPRUNNING    (1<<2)

#define FPB_EN_OVERFLOW    0        
#define FPB_EN_UNDERFLOW   1        
#define FPB_EN_ZERODIVIDE  2        
#define FPB_EN_INEXACT     3        
#define FPB_EN_INVALID     4        
#define FPB_DIS_OVERFLOW   5        
#define FPB_DIS_UNDERFLOW  6        
#define FPB_DIS_ZERODIVIDE 7        
#define FPB_DIS_INEXACT    8        
#define FPB_DIS_INVALID    9        
#define FPF_EN_OVERFLOW    (1<<0)
#define FPF_EN_UNDERFLOW   (1<<1)
#define FPF_EN_ZERODIVIDE  (1<<2)
#define FPF_EN_INEXACT     (1<<3)
#define FPF_EN_INVALID     (1<<4)
#define FPF_DIS_OVERFLOW   (1<<5)
#define FPF_DIS_UNDERFLOW  (1<<6)
#define FPF_DIS_ZERODIVIDE (1<<7)
#define FPF_DIS_INEXACT    (1<<8)
#define FPF_DIS_INVALID    (1<<9)
#define FPF_ENABLEALL      $0000001f   
#define FPF_DISABLEALL     $000003e0   

#define EXCATTR_TAGS    (TAG_USER+$101000)
#define EXCATTR_CODE    (EXCATTR_TAGS+0)   
#define EXCATTR_DATA    (EXCATTR_TAGS+1)   
#define EXCATTR_TASK    (EXCATTR_TAGS+2)   
#define EXCATTR_EXCID   (EXCATTR_TAGS+3)   
#define EXCATTR_FLAGS   (EXCATTR_TAGS+4)   
#define EXCATTR_NAME    (EXCATTR_TAGS+5)   
#define EXCATTR_PRI     (EXCATTR_TAGS+6)   



#define EXCB_GLOBAL       0        
#define EXCB_LOCAL        1        
#define EXCB_SMALLCONTEXT 2        
#define EXCB_LARGECONTEXT 3        
#define EXCB_ACTIVE       4        
#define EXCF_GLOBAL       (1<<0)
#define EXCF_LOCAL        (1<<1)
#define EXCF_SMALLCONTEXT (1<<2)
#define EXCF_LARGECONTEXT (1<<3)
#define EXCF_ACTIVE       (1<<4)

#define EXCB_MCHECK   2              
#define EXCB_DACCESS  3              
#define EXCB_IACCESS  4              
#define EXCB_INTERRUPT 5             
#define EXCB_ALIGN    6              
#define EXCB_PROGRAM  7              
#define EXCB_FPUN     8              
#define EXCB_TRACE    13             
#define EXCB_PERFMON  15             
#define EXCB_IABR     19             
#define EXCF_MCHECK   (1<<2)
#define EXCF_DACCESS  (1<<3)
#define EXCF_IACCESS  (1<<4)
#define EXCF_INTERRUPT (1<<5)
#define EXCF_ALIGN    (1<<6)
#define EXCF_PROGRAM  (1<<7)
#define EXCF_FPUN     (1<<8)
#define EXCF_TRACE    (1<<13)
#define EXCF_PERFMON  (1<<15)
#define EXCF_IABR     (1<<19)

OBJECT EXCContext
 
	ExcID:LONG       
	UNION UPC

		SRR0:LONG    
		PC:LONG
	ENDUNION 
	SRR1:LONG        
	DAR:LONG         
	DSISR:LONG       
	CR:LONG          
	CTR:LONG         
	LR:LONG          
	XER:LONG         
	FPSCR:LONG       
	GPR[32]:LONG     
	->FPR[32]:DOUBLE    
	FPR[64]:LONG
ENDOBJECT

OBJECT XContext
 
	ExcID:LONG      
	R3:LONG         
ENDOBJECT

#define EXCRETURN_NORMAL 0       
#define EXCRETURN_ABORT  1       
				 
#endif 
#endif
