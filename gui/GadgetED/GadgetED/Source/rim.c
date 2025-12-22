/*----------------------------------------------------------------------*
  rim.c Version 2.3 -  © Copyright 1990-91 Jaba Development

  Author    : Jan van den Baard
  Purpose   : reading routines for IFF ILBM images and ColorMaps
 *----------------------------------------------------------------------*/

extern struct ge_prefs     prefs;
extern struct Screen      *MainScreen;
extern struct MemoryChain  Memory;

/*
 * check to see if there are bit-planes that doesn't contain data
 */
static BOOL check(data,size)
    UBYTE *data;
    ULONG size;
{
    register UBYTE *pointer;
    register UCOUNT counter;

    pointer = data;
    for(counter=0;counter<size;counter++) if(*pointer++) return(TRUE);
    return(FALSE);
}

/*
 * filter out the bit-planes that doesn't contain data
 */
VOID skip_zero_planes(image)
    struct Image *image;
{
    UBYTE depth = 0;
    ULONG plane_size;
    UBYTE  *data, *planes[8], *data1;
    register UCOUNT counter,ptc = 0;

    plane_size = RASSIZE(image->Width,image->Height);
    data       = (UBYTE *)image->ImageData;

    for(counter = 0; counter < image->Depth; counter++)
    {   planes[counter] = (UBYTE *)(data + (counter * plane_size));
        if(check(planes[counter],plane_size)) depth++;
    }

    if(depth == image->Depth) return;
    if(NOT(data1 = (UBYTE *)
      AllocMem((ULONG)depth * plane_size,MEMF_CHIP+MEMF_CLEAR))) return;

    for(counter = 0; counter < image->Depth; counter++)
    {   if(check(planes[counter],plane_size))
        CopyMem((char *)planes[counter],(char *)(data1+(ptc++ * plane_size)),plane_size);
    }
    image->PlanePick = NULL;
    for(counter = 0; counter < depth; counter++ )
    image->PlanePick |= (1 << counter);
    FreeMem(data,(plane_size * image->Depth));
    image->Depth = depth;
    image->ImageData = (USHORT *)data1;
}

/*
 * check to see if the file opened is an IFF ILBM file
 */
static BOOL CheckIFF(file)
    BPTR file;
{
    struct FORMChunk   fchunk;
    char              *str = NULL;

    if(Read(file,(char *)&fchunk,sizeof(struct FORMChunk)) <= 0)
        str = "Error during Image Read !";
    else if(fchunk.fc_Type != 'FORM')
        str = "File is not an IFF FORM !";
    else if(fchunk.fc_SubType != 'ILBM')
        str = "IFF FORM is not an ILBM !";
    if(str)
    {   enable_window();
        Error(str);
        return(FALSE);
    }
 return(TRUE);
}

/*
 * read the IFF ILBM file into memory and if no errors occur
 * return the pointer to an image structure containing the image
 */
struct Image *ReadImage(ilbmname)
    UBYTE  *ilbmname;
{
    struct IFFChunk     ichunk;
    struct BitMapHeader header;
    BPTR                infile = NULL;
    ULONG               length, offset = NULL, unpacked;
    struct Image        *image = NULL;
    ULONG               planes_size,ps;
    COUNT               plane,row;
    BYTE                *s1,i;
    BYTE                *source, *dest, *planedata = NULL, *planes[8], byte, byte1;
    BOOL                GotBODY = FALSE;
    char                *str;

    buisy();
    if(NOT(image = (struct Image *)Alloc(&Memory,(ULONG)sizeof(struct Image))))
    {   str = "Out of memory !";
        goto Err;
    }

    if(NOT(infile = Open((char *)ilbmname,MODE_OLDFILE)))
    {   str = "Can't open IFF file !";
        goto Err;
    }

    if(NOT CheckIFF(infile))
    {   FreeItem(&Memory,image,(long)sizeof(struct Image));
        Close(infile);
        return(NULL);
    }

    while(GotBODY == FALSE)
    {   if(Read(infile,(char *)&ichunk,sizeof(struct IFFChunk)) <= 0)
        {   str = "Error during Image Read !";
        }
        length = ichunk.ic_Length;
        if(length & 1) length++;
        switch(ichunk.ic_Type)
        {    case 'BMHD': if(Read(infile,(char *)&header,length) <= 0)
                          {   str = "Error during Image Read !";
                              goto Err;
                          }

                          image->Width      = header.w;
                          image->Height     = header.h;
                          image->Depth      = header.nPlanes;
                          for(i=0;i<image->Depth;i++)
                               image->PlanePick += (1 << i);
                          image->PlaneOnOff = 0x00;
                          ps = RASSIZE(image->Width,image->Height);
                          planes_size = ps * image->Depth;
                          break;

             case 'BODY': GotBODY = TRUE;
                          if(NOT(planedata = (BYTE *)AllocMem(planes_size,MEMF_CHIP+MEMF_CLEAR)))
                          {   str = "Out of CHIP memory !";
                              goto Err;
                          }

                          for(i=0;i<image->Depth;i++)
                          planes[i] = (BYTE *)(planedata + (i * ps));

                          if(header.compression == 0)
                          {   for(row=0;row<image->Height;row++)
                              {   for(plane=0;plane<image->Depth;plane++)
                                  {   if(Read(infile,(char *)planes[plane]+offset,
                                              bpr(image->Width)) <= 0)
                                      {   str = "Error during Image Read !";
                                          goto Err;
                                      }
                                  }
                                  offset += bpr(image->Width);
                              }
                          }
                          else if(header.compression == 1)
                          {   if(NOT(s1 = source = (BYTE *)AllocMem(length,MEMF_PUBLIC+MEMF_CLEAR)))
                              {   str = "Out of memory !";
                                  goto Err;
                              }

                              if(Read(infile,(char *)source,length) <= 0)
                              {   FreeMem(source,length);
                                  str = "Error during Image Read !";
                                  goto Err;
                              }

                              for(row=0;row<image->Height;row++)
                              {   for(plane=0;plane<image->Depth;plane++)
                                  {   dest = (BYTE *)planes[plane]+offset;
                                      unpacked = bpr(image->Width);
                                      while(unpacked > 0)
                                      {   byte = *source++;
                                          if(byte == 128) {}
                                          else if(byte > 0)
                                          {   byte += 1;
                                              unpacked -= byte;
                                              while(--byte >= 0) *dest++ = *source++;
                                          }
                                          else
                                          {   byte = -byte + 1;
                                              unpacked -= byte;
                                              byte1 = *source++;
                                              while(--byte >= 0) *dest++ = byte1;
                                          }
                                      }
                                  }
                                  offset += bpr(image->Width);
                              }
                              FreeMem(s1,length);
                          }
                          else
                          {   str = "Unknown Image compression !";
                              goto Err;
                          }
                          break;
             default:     Seek(infile,length,OFFSET_CURRENT); break;
        }
    }
    image->ImageData       = (USHORT *)planedata;
    if(prefs.skip_zero_planes) skip_zero_planes(image);

    Close(infile);
    ok();
    return(image);

Err:
    enable_window();
    Error(str);
    if(infile)      Close(infile);
    if(image)       FreeItem(&Memory,image,(long)sizeof(struct Image));
    if(planedata)   FreeMem(planedata,planes_size);
    return(NULL);
}

/*
 * read and set the CMAP of an IFF ILBM file
 */
VOID ReadCMAP(ilbmname)
    UBYTE  *ilbmname;
{
    struct IFFChunk     ichunk;
    BPTR                infile;
    LONG                length;
    register COUNT      reg,i=0;
    BOOL                GotIt = FALSE, GotCMAP = FALSE;
    UBYTE               colors[96],count;

    buisy();
    if(NOT(infile = Open((char *)ilbmname,MODE_OLDFILE)))
    {   enable_window();
        Error("Can't open IFF file !");
        return;
    }

    if(NOT CheckIFF(infile))
    {   Close(infile);
        return;
    }

    while(GotIt == FALSE)
    {    if(Read(infile,(char *)&ichunk,sizeof(struct IFFChunk)) <= 0)
         {   enable_window();
             Error("Error during CMAP read !");
             Close(infile);
             return;
         }
         length = ichunk.ic_Length;
         if(length & 1) length++;
         switch(ichunk.ic_Type)
         {   case 'CMAP': GotCMAP = TRUE;
                          if(Read(infile,(char *)&colors,length) <= 0)
                          {   enable_window();
                              Error("Error during CMAP read !");
                              break;
                          }
                          count = (1 << MainScreen->BitMap.Depth);
                          for(reg=0;reg<count;reg++,i+=3)
                          {    SetRGB4(&MainScreen->ViewPort,
                                       reg,
                                       ((colors[i] >> 4)   & 0x0f),
                                       ((colors[i+1] >> 4) & 0x0f),
                                       ((colors[i+2] >> 4) & 0x0f));
                          }
                          break;
             case 'BODY': GotIt = TRUE; break;
             default:     Seek(infile,length,OFFSET_CURRENT); break;
         }
    }
    Close(infile);
    if(GotCMAP == FALSE)
    {   enable_window();
        Error("No CMAP chunk found !");
    }
    ok();
    return;
}
