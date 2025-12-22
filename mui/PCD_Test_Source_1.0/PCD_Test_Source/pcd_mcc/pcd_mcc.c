

/* pcd_mcc*/

 

	#include <clib/debug_protos.h>

    #include <clib/alib_protos.h>
	#include <clib/graphics_protos.h>
	#include <clib/utility_protos.h>
	#include <clib/debug_protos.h>
	#include <clib/muimaster_protos.h>
	#include <proto/dos.h>
	#include <proto/exec.h>
	
	#include <libraries/mui.h>
	#include <proto/cybergraphics.h>
	#include <proto/intuition.h>
	#include <intuition/intuition.h>
    #include <intuition/extensions.h>
    #include <intuition/intuitionbase.h>
    #include <intuition/classusr.h>
	 #include <libraries/cybergraphics.h> 
	 #include <clib/gadtools_protos.h>
	
	/*-----------------------------------*/
	

    /*-----------------------------------*/
    #include "pcd_mcc.h"
    #include "fotochop_mcc.h"






   #define CLASS       MUIC_Pcd
   #define SUPERCLASS  MUIC_Area
 

  



  #include "structs.c"









/*------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------*/



#define DISPATCHERNAME_BEGIN(Name)			\
ULONG Name(void) { Class *cl=(Class*) REG_A0; Msg msg=(Msg) REG_A1; Object *obj=(Object*) REG_A2; switch (msg->MethodID) {

#define DISPATCHER_END } return DoSuperMethodA(cl,obj,msg);}



/*------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------*/

 
   #define UserLibID "$VER: pcd.mcc 01.00 (06.09.18)"
   #define VERSION   01
   #define REVISION  00
   #define MASTERVERSION 21
   #define _Dispatcher Pcd_mcc
   #define LIBQUERYID "PCD"
   #define LIBQUERYDESCRIPTION " Copyright Carsten Siegner"
   
   
   
  
   #include "mui/mccheader.c"
   
  

  

  /*---------------------------------------------------*/
  
   ULONG _strlen(char *in);
   
 

  
  
  
  
  
  /*-----------------------------------------------------*/
  
  ULONG pcd_New(struct IClass *cl,Object *obj,struct opSet *msg);
  ULONG pcd_Dispose(struct IClass *cl,Object *obj,Msg msg);
  ULONG pcd_AskMinMax(struct IClass *cl,Object *obj,struct MUIP_AskMinMax *msg);
  ULONG pcd_Set(struct IClass *cl,Object *obj,Msg msg);
  ULONG pcd_Get(struct IClass *cl,Object *obj,Msg msg);
  ULONG pcd_Draw(struct IClass *cl,Object *obj,struct MUIP_Draw *msg);
  ULONG pcd_Setup(struct IClass *cl,Object *obj,Msg msg);
  ULONG pcd_Cleanup(struct IClass *cl,Object *obj,Msg msg);
  



  /*-----------------------------------------------------*/
  int pcd(int size_nr,struct Data *data);
  unsigned char switch_byte(unsigned char x);




/*-----------------------------------------------------------------------*/


struct Library * CyberGfxBase;


/*------------------------Hier werden die neue Konfigs geladen--------------------------------------*/


ULONG pcd_New(struct IClass *cl,Object *obj,struct opSet *msg)
{
	struct TagItem *tags,*tag;
	
	

	                 obj = DoSuperNew(cl,obj,
					 MUIA_FillArea,TRUE,
					 TAG_MORE,msg->ops_AttrList);


	if (obj != NULL)
	{
        struct Data *data = INST_DATA(cl,obj);
		
		
		   CyberGfxBase = OpenLibrary("cybergraphics.library",0L);
		 
		
	
		data->img = NULL;
		data->ed = NULL;
	    data->size_nr = 0;
		
		 for (tags=((struct opSet *)msg)->ops_AttrList;tag=NextTagItem(&tags);)
	    {
		
		  switch (tag->ti_Tag)
		  {
		     
			   case MUIA_PCD_PATH:
			   {
				CopyMem((APTR)tag->ti_Data,(APTR)data->path,_strlen((char*)tag->ti_Data));
				
				break;
			   }
			   
			    case MUIA_PCD_ED:
			   {
				data->ed = (Object*)tag->ti_Data;
				
				break;
			   }
			   
			    case MUIA_PCD_WIDTH:
			   {
			     data->width = (ULONG)tag->ti_Data;
				 break;
			   } 
			   
			    case MUIA_PCD_HEIGHT:
			   {
			     data->height = (ULONG)tag->ti_Data;
				 break;
			   } 
		   
		       case MUIA_PCD_SIZE_NR:
			   {
			     data->size_nr = (ULONG)tag->ti_Data;
				 break;
			   } 
			   
			 
			   
			
			
			   
			   
			   
			   
		  }
		
	    }
	
	    //KPrintF("Normal: %d Switch: %d\n",10,switch_byte(10));
            
            	     
		 pcd(data->size_nr,data);
		
		
	/*	if(data->ed != NULL)
		{
		   set(data->ed,MUIA_FOTOCHOP_BRUSH_WIDTH,data->width);
		   set(data->ed,MUIA_FOTOCHOP_BRUSH_HEIGHT,data->height);
		
		   DoMethod(data->ed,MUIM_FOTOCHOP_SEND_TO_BRUSH,data->img);   
		}*/
		
		
		
	      
	  
	  
	  
	  
	  return (ULONG)obj;
	}


	
    CoerceMethod(cl,obj,OM_DISPOSE);
	return(0);


	
}


/*----------------------------------------------*/

ULONG pcd_Dispose(struct IClass *cl,Object *obj,Msg msg)
{
	struct Data *data = INST_DATA(cl,obj);
	
	if(data->img != NULL) FreeVec(data->img);		
	
	
	         CloseLibrary(CyberGfxBase);	
          
			
	

	return(DoSuperMethodA(cl,obj,msg));
}


/*-- MUI - Hier wird die Grundgröße angegeben--*/

ULONG pcd_AskMinMax(struct IClass *cl,Object *obj,struct MUIP_AskMinMax *msg)
{
	struct Data *data = INST_DATA(cl,obj);
	

	DoSuperMethodA(cl,obj,msg);

	msg->MinMaxInfo->MinWidth  += data->width;
	msg->MinMaxInfo->DefWidth  += data->width;
	msg->MinMaxInfo->MaxWidth  += data->width;

	msg->MinMaxInfo->MinHeight += data->height;
	msg->MinMaxInfo->DefHeight += data->height;
	msg->MinMaxInfo->MaxHeight += data->height;

	return(0);
}



/*----------------------------------------*/

ULONG pcd_Set(struct IClass *cl,Object *obj,Msg msg)
{
	struct Data *data = INST_DATA(cl,obj);
	struct TagItem *tags,*tag;
	
    
	   
	    for (tags=((struct opSet *)msg)->ops_AttrList;tag=NextTagItem(&tags);)
	    {
		
		  switch (tag->ti_Tag)
		  {
			  
			   case MUIA_PCD_PATH:
			   {
			    
				 CopyMem((APTR)tag->ti_Data,(APTR)data->path,_strlen((char*)tag->ti_Data));
				
                 //KPrintF("Is Anim: %d\n",x);
				 
		        
				 break;
			   }
			   
			 
			 
			  
		  }
		
	    }
    
	return(DoSuperMethodA(cl,obj,msg));
}

/*------------------------------------------*/

ULONG pcd_Get(struct IClass *cl,Object *obj,Msg msg)
{
	struct Data *data = INST_DATA(cl,obj);
	ULONG *store = ((struct opGet *)msg)->opg_Storage;
	
	
    
	switch (((struct opGet *)msg)->opg_AttrID)
	{
		        case MUIA_PCD_PATH:
			   {
			     *store = (ULONG)data->path;
				 break;
			   } 
			   
			    case MUIA_PCD_WIDTH:
			   {
			     *store = (ULONG)data->width;
				 break;
			   } 
			   
			    case MUIA_PCD_HEIGHT:
			   {
			     *store = (ULONG)data->height;
				 break;
			   } 
			   
			 
			   
			   case MUIA_Version:
	           {
	            *store = VERSION; 
	            break;
	           }   
		  
		       case MUIA_Revision:
		       {   
		        *store = REVISION;
		        break;
	           }
     
	}

   
	return(DoSuperMethodA(cl,obj,msg));
}

/*---MUI - Diese Funktion wird jedes mal beim Updaten aufgerufen---*/

ULONG pcd_Draw(struct IClass *cl,Object *obj,struct MUIP_Draw *msg)
{
	struct Data *data = INST_DATA(cl,obj);
	

   
	DoSuperMethodA(cl,obj,msg);
	if (!(msg->flags & MADF_DRAWOBJECT))
		return(0);
		
		      if(data->img)
			  {
	                WritePixelArray(data->img,
					0,
					0,
					data->width * 3,
					_rp(obj),
					_mleft(obj),
					_mtop(obj),
					_mwidth(obj),
					_mheight(obj),
					RECTFMT_RGB);
			  } 

		 
		     
	return(0);
}


/*---------------------------------------------------------*/


/*--------------------Setup----------------------------------*/

ULONG pcd_Setup(struct IClass *cl,Object *obj,Msg msg)
{

struct Data *data = INST_DATA(cl,obj);
	
	
	
	

         
    
	
	
	
	
	
	
 
   

	if (!(DoSuperMethodA(cl,obj,msg)))
    return(FALSE);
	
	return(TRUE);
}

/*----------------------Cleanup------------------------------*/

ULONG pcd_Cleanup(struct IClass *cl,Object *obj,Msg msg)
{
struct Data *data = INST_DATA(cl,obj);
	
	


     
	    	       
	
	
	
	
	
	
	
	
	                
    return(DoSuperMethodA(cl,obj,msg));
}

/*---------------------------------------------------------*/
/*--------------------------------------------------------------*/

























/*------------------------------------------------------------------------*/
/*------------------------------------------------------------------------*/

DISPATCHERNAME_BEGIN(Pcd_mcc)
 
   	    case OM_NEW        : return(pcd_New      (cl,obj,(APTR)msg));
		case OM_DISPOSE    : return(pcd_Dispose  (cl,obj,(APTR)msg));
		case OM_SET        : return(pcd_Set      (cl,obj,(APTR)msg));
		case OM_GET        : return(pcd_Get      (cl,obj,(APTR)msg));

		case MUIM_Setup    : return(pcd_Setup    (cl,obj,(APTR)msg));
		case MUIM_Cleanup  : return(pcd_Cleanup  (cl,obj,(APTR)msg));
		
		case MUIM_AskMinMax: return(pcd_AskMinMax(cl,obj,(APTR)msg));
		case MUIM_Draw     : return(pcd_Draw     (cl,obj,(APTR)msg));
		
		
		

		
DISPATCHER_END
