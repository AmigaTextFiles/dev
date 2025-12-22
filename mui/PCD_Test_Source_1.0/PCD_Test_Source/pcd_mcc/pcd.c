/* PCD*/

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
	 
	 #include "pcd.h"
	
	 
	 
	 #include "structs.c"

int pcd(int size_nr,struct Data *data)
{
 int th = 0,x = -1,m = 0;
 struct PCD_IMAGE img;
	
	

 KPrintF("%s\n",data->path);
          
     th = pcd_open(&img,data->path);
	 if(th > -1)
	 {
		int rot = 0,max = 0,left = 0,top = 0,width = 0,height = 0;
       		 
		 KPrintF("Filesize: %d\n",img.size);
        rot = pcd_get_rot(&img,th);		
        max = pcd_get_maxres(&img);	
        if(size_nr == 0) m = max;
		else m = size_nr;		 
		 
		 KPrintF("Rot: %d\n",rot);
		 KPrintF("Maxres: %d\n",max);

          if(pcd_select(&img,m,th,0,1,rot,&left,&top,&width,&height) == 0)
		  {			  
		    unsigned char* pic = (unsigned char*)AllocVec(sizeof(unsigned char) * width * height * 3,MEMF_ANY | MEMF_CLEAR);

           
  	       KPrintF("Number of thumbnails: %d\n",th);
		   KPrintF("top: %d left: %d width: %d height: %d\n",top,left,width,height);	  
			  
			if(pcd_decode(&img) == 0)
			{  
			  if(pcd_get_image(&img,pic,PCD_TYPE_RGB,0) == 0)
			  {
				 data->width = (ULONG)width;
				 data->height = (ULONG)height; 
				  
			      data->img = (unsigned char*)AllocVec(sizeof(unsigned char) * width * height * 3,MEMF_ANY | MEMF_CLEAR);
                  CopyMem(pic,data->img,width * height * 3);
				  
				  
				  
               x = 1;
			  }	  
			}  
		   FreeVec(pic);	  
		  }
          else KPrintF("Fehler: %s\n",pcd_errmsg);		  
	
	 pcd_close(&img);	 
     }   

return x;
}