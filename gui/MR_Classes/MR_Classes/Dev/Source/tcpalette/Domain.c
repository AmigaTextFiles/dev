#include "private.h"

ULONG gad_Domain(Class *C, struct Gadget *Gad, struct gpDomain *D)
{
  struct GadData *gdata=0; 
  
  if(Gad) gdata=INST_DATA(C, Gad);
 
  D->gpd_Domain.Left=0;
  D->gpd_Domain.Top=0;

  switch(D->gpd_Which)
  {
    case GDOMAIN_NOMINAL:
      if(gdata)
      {
        D->gpd_Domain.Width =sqrt(gdata->Pens) * 12 + 8;
        D->gpd_Domain.Height=sqrt(gdata->Pens) * 12 + 8;
      }
      else
      {
        D->gpd_Domain.Width=100;
        D->gpd_Domain.Height=50;
      }
      break;
      
    case GDOMAIN_MAXIMUM:
      D->gpd_Domain.Width=16000;
      D->gpd_Domain.Height=16000;
      break;
    
    case GDOMAIN_MINIMUM:
    default:
      if(gdata)
      {
        D->gpd_Domain.Width =sqrt(gdata->Pens) * 8 + 8;
        D->gpd_Domain.Height=sqrt(gdata->Pens) * 8 + 8;
      }
      else
      {
        D->gpd_Domain.Width=  50;
        D->gpd_Domain.Height= 50;
      }
      break;

  }
  return(1);
}
