int ReadAllCode(struct ProducerNode *pwn, struct IFFHandle *IFF)
{
	long result = 0;
	long error = 0;
	struct codestore cs;

#ifdef DEBUG
	FPuts(pwn->debug, "Loading code\n");	
#endif

	error = ReadChunkBytes(IFF, &cs, sizeof(struct codestore));
	if (error>0)
		{
		if (cs.fileversion>CurrentDesignerFileVersion)
			result = 9;
		if (cs.fileversion<CurrentDesignerFileVersion)
			result = 8;
		if (result ==0)
			{
			CopyMem(cs.ProcedureOptions, pwn->ProcedureOptions, 50);
			CopyMem(cs.CodeOptions     , pwn->CodeOptions, 20);
			CopyMem(cs.OpenLibs        , pwn->OpenLibs, 30);
			CopyMem(cs.VersionLibs     , pwn->VersionLibs, 120);
			CopyMem(cs.AbortOnFailLibs , pwn->AbortOnFailLibs, 30);
			CopyMem(cs.includeextra    , pwn->IncludeExtra, 256);
			pwn->pn_Includes = &pwn->IncludeExtra[1];
			fixstring(&pwn->IncludeExtra[0]);
			pwn->FileVersion = cs.fileversion;

#ifdef DEBUG
	FPuts(pwn->debug, "  Version = ");
	FPutC(pwn->debug, '0'+cs.fileversion);
	FPuts(pwn->debug, "\n");
#endif

			}
		}
	else
		result = 5;
	
	return result;
}
