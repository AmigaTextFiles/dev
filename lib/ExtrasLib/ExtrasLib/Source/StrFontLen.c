#include <extras/math.h>
#define __USE_SYSBASE
#include <strings.h>
#include <stdio.h>
#include <stdlib.h>
#include <graphics/text.h>
#include <clib/extras_protos.h>

#include <extras/ext_text.h>
#include <string.h>
#include <tagitemmacros.h>
#include <math.h>

#include <proto/graphics.h>
#include <proto/utility.h>

#define DEBUG
#include <debug.h>

/****** extras.lib/gui_StrFontLen ******************************************
*
*   NAME
*       gui_StrFontLen - get the pixel length of a string.
*
*   SYNOPSIS
*       length=gui_StrFontLen(Font, Str)
*
*       LONG gui_StrFontLen(struct TextFont *,STRPTR);
*
*   FUNCTION
*       This function returns the number of pixels a string
*       would occupy if rendered in the specified Font.
*
*   INPUTS
*       Font - struct TextFont * previously opened by 
*              OpenFont() or OpenDiskFont().
*       Str - a pointer to a null terminated string.
*
*   RESULT
*       the pixel length of the string or 0 if either parameter
*       is NULL.
*
******************************************************************************
*
*/

LONG gui_StrFontLen (struct TextFont *Font, STRPTR Str)
{
  return(gui_StrLength(SL_TextFont ,Font,
            SL_String   ,Str,
            TAG_DONE));
}


/****** extras.lib/gui_StrLength ******************************************
*
*   NAME
*       gui_StrLength -- Get the pixel length of a string.
*
*   SYNOPSIS
*       Len = gui_StrLength(Tags)
*       
*       LONG gui_StrLength(Tag, ... );
*
*   FUNCTION
*       Find the length of a given string.  If multiple strings
*       are given, returns the longest length.
*
*   INPUTS
*       Tags 
*         SL_TextFont - (struct TextFont *)The font the string will
*           be rendered in. (required)
*         SL_IgnoreChars - (STRPTR) Null terminated string of characters
*           to ignore from the length calculation, useful for underscores
*           in gadget text, etc.
*         SL_String - (STRPTR) String to size.
*
*   RESULT
*       Length in pixels of longest string.
*
*   EXAMPLE
*         *find length of button text without the "_" 
*         len= gui_StrLength(SL_TextFont     ,TF,
*                        SL_String       ,"_Button",
*                        SL_IgnoreChars  ,"_",
*                        TAG_DONE);
*
*         * find maximum length of red, green and blue without "_"
*         len= gui_StrLength(SL_TextFont     ,TF,
*                        SL_String       ,"_Red",
*                        SL_String       ,"_Green",
*                        SL_String       ,"_Blue",
*                        SL_IgnoreChars  ,"_",
*                        TAG_DONE);
*
*   NOTES
*
*   BUGS
*
*   SEE ALSO
*
******************************************************************************
*
*/

LONG gui_StrLength (Tag Tags, ... )
{
  struct RastPort rp;
  STRPTR str,ignore,cstr;
  struct TextFont   *tf;
  struct TextExtent tex;
  struct TagItem *taglist,*tag,*tstate;
  LONG l,l2=0,c;
 
//  DKP("StrLength GfxBase=%8lx  UtilityBase=%8lx\n",GfxBase,UtilityBase);
    
  taglist=(struct TagItem *)&Tags;
  
  tf=(struct TextFont *)GetTagData(SL_TextFont,0,taglist);
  ignore=(STRPTR)GetTagData(SL_IgnoreChars,0,taglist);
  
  
  if(!tf)
    return(0);


  InitRastPort(&rp);
  SetFont(&rp,tf);

  ProcessTagList(taglist,tag,tstate)
  {
    if(tag->ti_Tag==SL_String)
    {
      l=0;
      if(str=(STRPTR)tag->ti_Data)
      {
        cstr=0;
        if(ignore)
        {
          if(cstr=AllocVec(strlen(str)+1,0))
          { // Copy str to cstr, skipping chars in "ignore"
            c=0;
            while(*str)
            {
              if(!strchr(ignore,*str))
              {
                cstr[c]=*str;
                c++;
              }
              str++;
            }
            cstr[c]=0;
            str=cstr;
          }
        }
//        l=TextLength(&rp,str,strlen(str));
//        DKP("String %s\n",str);
        TextExtent(&rp,str,strlen(str),&tex);

        l=tex.te_Extent.MaxX-tex.te_Extent.MinX+1;        
        
//        printf("%40.40s  tex.Width:%7d tex.MinX:%7d tex.MaxX:%7d  l:%7d\n",str,tex.te_Width,tex.te_Extent.MinX,tex.te_Extent.MaxX,l);
        FreeVec(cstr);  // Safe to call with NULL
        
      }
      l2=max(l,l2);
    }
  }
  return(l2);
}

/*
LONG StrLength (Tag Tags, ... )
{
  struct RastPort rp;
  STRPTR str,ignore;
  struct TextFont *tf;
  struct TagItem *taglist,*tag,*tstate;
  LONG l,l2=0,c,ilen=0,kset=0,kern=0,firstkern=0;
  UBYTE s;
    
  taglist=(struct TagItem *)&Tags;
  
  tf=(struct TextFont *)GetTagData(SL_TextFont,0,taglist);
  if(ignore=(STRPTR)GetTagData(SL_IgnoreChars,0,taglist))
    ilen=strlen(ignore);
  
  
  if(!tf)
    return(0);


  InitRastPort(&rp);
  SetFont(&rp,tf);

  ProcessTagList(taglist,tag,tstate)
  {
    if(tag->ti_Tag==SL_String)
    {
      l=0;
      if(str=(STRPTR)tag->ti_Data)
      {
        if(tf->tf_Flags & FPF_PROPORTIONAL)
        {
          UBYTE s,lo,hi,add;
          lo=tf->tf_LoChar;
          hi=tf->tf_HiChar;
          
          while(*str)
          {
            add=TRUE;
            s=*str;
            
            if(s>=lo && s<=hi)
              s-=lo;
            else
              s=hi-lo+1;
              
            for(c=0;c<ilen;c++)
            {
              if(s==ignore[c]) 
                add=FALSE;
            }
            
            
            
            if(add)
            {
//        kprintf("%lc - Added\n",s);
              kern=((WORD *)tf->tf_CharKern)[s];
              l+=((WORD *)tf->tf_CharSpace)[s]+ kern ;
              if(!kset)
              {
                kset=1;
                firstkern=kern;
              }
            }
            else
            {
//        kprintf("%lc - Ignored\n",s);
            }
            str++;
          }
          
          l=l-firstkern;
        }
        else
        {
          UBYTE c,add;
          WORD xsize;
          
          xsize=tf->tf_XSize;
          while(*str)
          {
            s=*str;
            add=TRUE;
      
            for(c=0;c<ilen;c++)
            {
              if(s==ignore[c]) 
                add=FALSE;
            }
            
            if(add)
            {
//        kprintf("%lc - Added\n",s);
              l+=xsize;
            }
            else
            {
//        kprintf("%lc - Ignored\n",s);
            } 
            str++;
          }
        } 
      }
      l=abs(l);
      l2=max(l,l2);
    }
  }
  return(l2);
}

*/