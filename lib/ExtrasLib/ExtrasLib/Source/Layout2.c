#include <clib/extras/layoutgt_protos.h>
#include <clib/extras_protos.h>
#include <extras/layoutgt.h>

union Decode
{
  ULONG Long;
  struct
  {
    BYTE Type, Code;
    WORD Word;
  } Decode;
};


WORD LG_FigureLeftEdge(struct LG_Control *Con, ULONG Code, struct IBox *Bounds,struct lg_DimInfo *Data)
{
  struct LG_GadgetIndex *gi;
  union Decode command;
  WORD word,w,h,retval;
  BYTE code;

  command.Long=Code;
  word=command.Decode.Word;
  code=command.Decode.Code;
  
  retval=word;
  
//  le =Bounds->Left;
//  te =Bounds->Top;
  w  =Bounds->Width;
  h  =Bounds->Height ;
  
  switch(command.Decode.Type)
  {
    case 1:
      switch(command.Decode.Code)
      {
        case 0: // LG_REL_RIGHT
          retval=(w + word);
          break;
        case 4: // LG_REL_CELL_LEFTEDGE
          if(Data)
            if(Data->CellsHoriz)
              retval=((word * Bounds->Width + Data->GapHoriz)/Data->CellsHoriz);
          break;         
      }
      break;
    case 2: // LG_REL_LEFTOF
      if(gi=LG_GetGI(Con,word))
      {
        retval=(gi->gi_Rect.MinX+code);
      }
      break;
    case 6: // LG_REL_RIGHTOF
      if(gi=LG_GetGI(Con,word))
      {
        retval=(gi->gi_Rect.MaxX+code);
      }
      break;      
  }
  return(retval);
}



WORD LG_FigureWidth(struct LG_Control *Con, ULONG Code, struct IBox *Bounds, WORD LeftEdge, struct lg_DimInfo *Data)
{
  struct LG_GadgetIndex *gi;
  union Decode command;
  WORD word,w,h,retval;
  BYTE code;

  command.Long=Code;
  word=command.Decode.Word;
  code=command.Decode.Code;
  
  retval=word;
  
//  le =Bounds->Left;
//  te =Bounds->Top;
  w  =Bounds->Width;
  h  =Bounds->Height ;
  
  switch(command.Decode.Type)
  {
    case 1:
      switch(command.Decode.Code)
      {
        case 1: // LG_REL_WIDTH
          retval=(w + word);    
          break;
        case 6: // LG_REL_CELL_WIDTH
          if(Data)
            if(Data->CellsHoriz)
              retval=((word * (Bounds->Width + Data->GapHoriz))/Data->CellsHoriz - Data->GapHoriz);
          else
            retval=(Bounds->Width);
          break;          
      }
      break;
    case 2: // LG_REL_LEFTOF
      if(gi=LG_GetGI(Con,word))
      {
        retval=gi->gi_Rect.MinX + code - LeftEdge;
      }
      break;
    case 4: // LG_REL_WIDTHOF
      if(gi=LG_GetGI(Con,word))
      {
        retval=(gi->gi_Rect.MaxX-gi->gi_Rect.MinX + code);
      }
      break;      
    case 6: // LG_REL_RIGHTOF
      if(gi=LG_GetGI(Con,word))
      {
        retval=(gi->gi_Rect.MaxX+code) - LeftEdge;
      }
      break;      
  }
  return(retval);
}


WORD LG_FigureTopEdge(struct LG_Control *Con, ULONG Code, struct IBox *Bounds,struct lg_DimInfo *Data)
{
  struct LG_GadgetIndex *gi;
  union Decode command;
  WORD word,w,h,retval;
  BYTE code;

  command.Long=Code;
  word=command.Decode.Word;
  code=command.Decode.Code;
  
  retval=word;
  
//  le =Bounds->Left;
//  te =Bounds->Top;
  w  =Bounds->Width;
  h  =Bounds->Height ;
  
  switch(command.Decode.Type)
  {
    case 1:
      switch(command.Decode.Code)
      {
        case 2: // LG_REL_BOTTOM
          retval=(h + word);
          break;
        case 5: // LG_RELCELL_TOPEDGE
          if(Data)
            if(Data->CellsVert)
              retval=((word * Bounds->Height+ Data->GapVert)/Data->CellsVert);
          break;
      }
      break;
    case 3: // LG_REL_TOPOF
      if(gi=LG_GetGI(Con,word))
      {
        retval=(gi->gi_Rect.MinY+code);
      }
      break;
    case 7: // LG_REL_BOTTOMOF
      if(gi=LG_GetGI(Con,word))
      {
        retval=(gi->gi_Rect.MaxY+code);
      }
      break;      
  }
  return(retval);
}


WORD LG_FigureHeight(struct LG_Control *Con, ULONG Code, struct IBox *Bounds,WORD TopEdge, struct lg_DimInfo *Data)
{
  struct LG_GadgetIndex *gi;
  union Decode command;
  WORD word,w,h,retval;
  BYTE code;

  command.Long=Code;
  word=command.Decode.Word;
  code=command.Decode.Code;
  
  retval=word;
  
//  le =Bounds->Left;
//  te =Bounds->Top;
  w  =Bounds->Width;
  h  =Bounds->Height ;
  
  switch(command.Decode.Type)
  {
    case 1:
      switch(command.Decode.Code)
      {
        case 3: // LG_REL_HEIGHT
          retval=(h + word);    
          break;
        case 7: // LG_REL_CELL_HEIGHT
          if(Data)
            if(Data->CellsVert)
              retval=((word * (Bounds->Height + Data->GapVert))/Data->CellsVert - Data->GapVert);
            else
              retval=(Bounds->Width);
          break;          
      }
      break;
    case 3: // LG_REL_TOPOF
      if(gi=LG_GetGI(Con,word))
      {
        retval=(gi->gi_Rect.MinY+code) - TopEdge;
      }
      break;
    case 5: // LG_REL_HEIGHTOF
      if(gi=LG_GetGI(Con,word))
      {
        retval=(gi->gi_Rect.MaxY-gi->gi_Rect.MinY+code);
      }
      break;      
    case 7: // LG_REL_BOTTOMOF
      if(gi=LG_GetGI(Con,word))
      {
        retval=(gi->gi_Rect.MaxY+code) - TopEdge;
      }
      break;      
  }
  return(retval);
}












