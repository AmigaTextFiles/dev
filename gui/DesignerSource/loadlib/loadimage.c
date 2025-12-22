int ReadImage( struct ProducerNode *pwn, struct IFFHandle *IFF)
{
	struct ImageNode *in;
	long result = 0;
	long error = 0;
	struct ContextNode *pcn;
	struct imagestorehead is;
	long finished = 0;
	UWORD tempstore[256];
	UBYTE *pba;
	long  loop;
	UWORD *pos;
	long count;
	
#ifdef DEBUG
	FPuts(pwn->debug,"Loading Image:\n");
#endif
	
	in = (struct ImageNode *)AllocVec(sizeof(struct ImageNode),MEMF_CLEAR);
	if (in)
		{
		pwn->MemCount += 1;
		AddTail((struct List *)&pwn->ImageList,(struct Node *)in);
		while (((error == 0) || (error == IFFERR_EOC)) && (finished==0) && (result==0))
			{
			error = ParseIFF( IFF, IFFPARSE_RAWSTEP);
	
			pcn = CurrentChunk(IFF);
			
			if (error == IFFERR_EOC )
				if ( (pcn->cn_Type==id_pic1) && (pcn->cn_ID==ID_FORM) )
					finished=1;
			
			if (error ==0 )
				{
				
				if ( (pcn->cn_ID==id_head) && (result==0))
					{
					error = ReadChunkBytes(IFF,&is,sizeof(struct imagestorehead));
					if (error>0)
						{
						error = 0;
						in->in_Width    = is.width;
						in->in_Height   = is.height;
						in->in_Depth    = is.depth;
						in->in_PlanePick = is.planepick;
						in->in_PlaneOnOff = is.planeonoff;
						CopyMem(&is.title[0],&in->in_titlestr[0],68);
						in->in_Label = &in->in_titlestr[1];
						fixstring(&in->in_titlestr[0]);
						if (is.sizedata>0)
							{
							in->in_ImageData = (UBYTE *)AllocVec(is.sizedata,MEMF_CLEAR);
					 		if (in->in_ImageData)
								{
								in->in_SizeAllocated = is.sizedata;
								pwn->MemCount += 1;
								}
							else
								result = 4;
							}
						}
					else
						result = 5;
					}
				
				if ( (pcn->cn_ID==id_data) && (result==0))
					{
					if (in->in_ImageData)
						{
						error = ReadChunkBytes(IFF,in->in_ImageData,in->in_SizeAllocated);
						if (error<0)
							result=5;
						error =0;
						}
					else
						result = 6;
					}
				
				if ( (pcn->cn_ID==id_cmap) && (result==0) )
					{
					count = pcn->cn_Size / 3;
					in->in_ColourMap = AllocVec(count * 2,MEMF_CLEAR);
					if (in->in_ColourMap)
						{
						pwn->MemCount +=1;
						in->in_MapSize = count*2;
						count = pcn->cn_Size;
						if (count>512)
						  count = 512;
						error = ReadChunkBytes(IFF, &tempstore[0], count);
						if (error>0)
							{
							error = 0;
							pos = in->in_ColourMap;
							pba = &tempstore[0];
							for (loop = 0; loop < (pcn->cn_Size/3); loop++)
								{
								*pos = (*pba & 240) << 4;
								pba += 1;
								*pos |=  (*pba & 240);
								pba +=1;
								*pos |=  (*pba & 240) >>4;
								pba +=1;
								pos += 1;
								}
							}
						else
							result = 5;
						}
					else
						result = 4;
					}
				
				}
			
			}

		}
	else
		return 4;
	return result;
}

void FreeImageNode(struct ProducerNode *pwn,struct ImageNode *in)
{
	if (in)
		{
		if ((in->in_ImageData) && (in->in_SizeAllocated>0))
			{
			FreeVec(in->in_ImageData);
			pwn->MemCount -= 1;
			}
		if ((in->in_ColourMap) && (in->in_MapSize>0))
			{
			FreeVec(in->in_ColourMap);
			pwn->MemCount -= 1;
			}
		FreeVec(in);
		pwn->MemCount -= 1;
		}
}