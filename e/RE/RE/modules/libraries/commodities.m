#ifndef LIBRARIES_COMMODITIES_H
#define LIBRARIES_COMMODITIES_H


#ifndef EXEC_TYPES_H
MODULE  'exec/types'
#endif
#ifndef EXEC_PORTS_H
MODULE  'exec/ports'
#endif


#define CxFilter(d)	    CreateCxObj((LONG) CX_FILTER,     (LONG) d,     0)
#define CxSender(port,id)   CreateCxObj((LONG) CX_SEND,       (LONG) port,  (LONG) id)
#define CxSignal(task,sig)  CreateCxObj((LONG) CX_SIGNAL,     (LONG) task,  (LONG) sig)
#define CxTranslate(ie)     CreateCxObj((LONG) CX_TRANSLATE,  (LONG) ie,    0)
#define CxDebug(id)	    CreateCxObj((LONG) CX_DEBUG,      (LONG) id,    0)
#define CxCustom(action,id) CreateCxObj((LONG) CX_CUSTOM,     (LONG)action, (LONG)id)

OBJECT NewBroker

    Version:BYTE   
    Name:PTR TO CHAR
    Title:PTR TO CHAR
    Descr:PTR TO CHAR
    Unique:WORD
    Flags:WORD
    Pri:BYTE
      Port:PTR TO MsgPort
    ReservedChannel:WORD
ENDOBJECT


#define NB_VERSION 5	    

#define CBD_NAMELEN  24
#define CBD_TITLELEN 40
#define CBD_DESCRLEN 40

#define NBU_DUPLICATE 0
#define NBU_UNIQUE    1        
#define NBU_NOTIFY    2        

#define COF_SHOW_HIDE 4


#ifndef COMMODITIES_BASE_H
  
#define CxObj LONG
  
#define CxMsg LONG
#endif

  
#define LONG LONG*PFL)()



#define CX_INVALID	0     
#define CX_FILTER	1     
#define CX_TYPEFILTER	2     
#define CX_SEND	3     
#define CX_SIGNAL	4     
#define CX_TRANSLATE	5     
#define CX_BROKER	6     
#define CX_DEBUG	7     
#define CX_CUSTOM	8     
#define CX_ZERO	9     


#define CXM_IEVENT  (1 << 5)
#define CXM_COMMAND (1 << 6)


#define CXCMD_DISABLE	(15)  
#define CXCMD_ENABLE	(17)  
#define CXCMD_APPEAR	(19)  
#define CXCMD_DISAPPEAR (21)  
#define CXCMD_KILL	(23)  
#define CXCMD_LIST_CHG	(27)  
#define CXCMD_UNIQUE	(25)  

OBJECT InputXpression

    Version:UBYTE	  
    Class:UBYTE	  
    Code:UWORD	  
    CodeMask:UWORD	  
    Qualifier:UWORD   
    QualMask:UWORD	  
    QualSame:UWORD	  
ENDOBJECT
  
#define InputXpression struct IX


#define IX_VERSION 2

#define IXSYM_SHIFT 1	
#define IXSYM_CAPS  2	
#define IXSYM_ALT   4	
#define IXSYM_SHIFTMASK (IEQUALIFIER_LSHIFT OR IEQUALIFIER_RSHIFT)
#define IXSYM_CAPSMASK	(IXSYM_SHIFTMASK OR IEQUALIFIER_CAPSLOCK)
#define IXSYM_ALTMASK	(IEQUALIFIER_LALT OR IEQUALIFIER_RALT)

#define IX_NORMALQUALS	$7FFF	 

#define NULL_IX(ix)   ((ix).ix_Class := IECLASS_NULL)


#define CBERR_OK      0  
#define CBERR_SYSERR  1  
#define CBERR_DUP     2  
#define CBERR_VERSION 3  


#define COERR_ISNULL	 1   
#define COERR_NULLATTACH 2   
#define COERR_BADFILTER  4   
#define COERR_BADTYPE	 8   

#endif 
