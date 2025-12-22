int ReadLocale( struct ProducerNode *pwn, struct IFFHandle *IFF)
{
	long result = 0;
	long error = 0;
	struct ContextNode *pcn;
	struct localestore ls;
	struct localenodestore lns;
	long finished = 0;
	long nodecount=0;

#ifdef DEBUG
	FPuts(pwn->debug, "Load locale \n");
#endif
	
	error = ReadChunkBytes(IFF, &ls, sizeof(struct localestore));
	if (error>0)
		{
		CopyMem(&ls.getstring[0], &pwn->getstringstr[0],72);
		fixstring(&pwn->getstringstr[0]);
		pwn->GetString = &pwn->getstringstr[1];
		CopyMem(&ls.builtinlanguage[0], &pwn->builtinlang[0],72);
		fixstring(&pwn->builtinlang[0]);
		pwn->BuiltInLanguage = &pwn->builtinlang[1];
		CopyMem(&ls.basename[0], &pwn->basenamestr[0],72);
		fixstring(&pwn->basenamestr[0]);
		pwn->BaseName = &pwn->basenamestr[1];
		pwn->LocaleVersion = ls.version;
		nodecount = ls.numberofnodes;
		
		while( (nodecount>0) && (result==0) )
			{
			error = ParseIFF(IFF, IFFPARSE_RAWSTEP);
    		pcn = CurrentChunk(IFF);
    		if ( (error == 0) || (error == IFFERR_EOC) )
    			{
    			if ( (pcn->cn_Type == id_loca) && (pcn->cn_ID == id_loci) && (error==0))
    				{
    				nodecount -=1;
    				error = ReadChunkBytes(IFF, &lns, sizeof(struct localenodestore));
    				if (error>0)
    					{
    					error = 0;
    					fixstring(&lns.labl[0]);
    					fixstring(&lns.comment[0]);
    					fixstring(&lns.str[0]);
    					AddLocaleString(pwn, &lns.str[1], &lns.labl[1], &lns.comment[1] );
    					}
    				else
    					result = 5;
    				}
    			}
    		else
    			result = 6;
			}
		}
	else
		result = 5;
	return result;
}

