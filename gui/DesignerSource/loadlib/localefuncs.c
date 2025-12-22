LibCall void
FreeLocaleStrings(pwn)
__A0 struct ProducerNode *pwn;
{
	struct LocaleNode * ln;
	if (pwn)
		{
		ln = RemHead((struct List *)&pwn->LocaleList);
		while (ln)
			{
			if (ln->ln_String)
				FreeVec(ln->ln_String);
			if (ln->ln_Label)
				FreeVec(ln->ln_Label);
			if (ln->ln_Comment)
				FreeVec(ln->ln_Comment);
			FreeVec(ln);
			ln = RemHead((struct List *)&pwn->LocaleList);
			}
		pwn->LocaleCount = 0;
		}
}

LibCall int
AddLocaleString(pwn,string,labelstring,commentstring)
__A0 struct ProducerNode *pwn;
__A1 char * string;
__D0 char * labelstring;
__D1 char * commentstring;
{
	struct LocaleNode *ln;
	if (pwn==NULL)
		return 0;
	ln = (struct LocaleNode *)AllocVec(sizeof(struct LocaleNode),MEMF_CLEAR);
	if (ln==NULL)
		return 0;
	AddTail( ( struct List *)&pwn->LocaleList, (struct Node *)ln );
	if (labelstring)
		if (strlen(labelstring)>0)
			{
			ln->ln_Label = (struct LocaleNode *)AllocVec(strlen(labelstring)+1,MEMF_CLEAR);
			if (ln->ln_Label==NULL)
				return 0;
			CopyMem(labelstring,ln->ln_Label,strlen(labelstring)+1);
			};
	if (string)
		if (strlen(string)>0)
			{
			ln->ln_String = (struct LocaleNode *)AllocVec(strlen(string)+1,MEMF_CLEAR);
			if (ln->ln_String==NULL)
				return 0;
			CopyMem(string,ln->ln_String,strlen(string)+1);
			};
	if (commentstring)
		if (strlen(commentstring)>0)
			{
			ln->ln_Comment = (struct LocaleNode *)AllocVec(strlen(commentstring)+1,MEMF_CLEAR);
			if (ln->ln_Comment==NULL)
				return 0;
			CopyMem(commentstring,ln->ln_Comment,strlen(commentstring)+1);
			};
	pwn->LocaleCount += 1;
	return 1;
}

LibCall int
WriteLocaleCT(pwn)
__A0 struct ProducerNode *pwn;
{
	char * basename = NULL;
	BPTR destfile;
	long error = 0;
	struct LocaleNode *ln;
	char namebuffer[100];
	long pos;

	if (pwn->LocaleCount == 0)
		return 1;
	
	if (pwn->BaseName != NULL)
		{
		CopyMem(pwn->BaseName,&namebuffer[0],72);
		pos = 0;
		while( namebuffer[pos] != 0 )
			pos += 1;
		if (pos>96)
			pos = 96;
		namebuffer[pos  ] = '.';
		namebuffer[pos+1] = 'c';
		namebuffer[pos+2] = 't';
		namebuffer[pos+3] = 0;
		basename = &namebuffer[0];
		}
	
	if (pwn && basename && (pwn->LocaleCount>0))
		{
		destfile = Open(basename,MODE_NEWFILE);
		if (destfile)
			{
			
			if (error==0)
				error = FPuts(destfile,";Designer Produced empty .ct File : Edit for different languages.\n");
			if (error==0)
				error = FPuts(destfile,";\n##Version ");
			
			if (error==0)
				error = FPuts(destfile,"\n##Codeset 0\n##Language \n");
			
			ln = (struct LocaleNode *)pwn->LocaleList.mlh_Head;
			while (ln->ln_Succ)
				{
				if (error==0)
					error = FPuts(destfile,";\n; ");
				if ((error==0) && ln->ln_Comment)
					error = FPuts(destfile,ln->ln_Comment);
				if (error==0)
					error = FPuts(destfile,"\n; Default : ");
				if ((error==0) && ln->ln_String)
					error = FPuts(destfile,ln->ln_String);
				if (error==0)
					error = FPuts(destfile,"\n");
				if ((error==0) && ln->ln_Label)
					error = FPuts(destfile,ln->ln_Label);
				if (error==0)
					error = FPuts(destfile,"\n\n");
				
				ln = ln->ln_Succ;
				}
			
			if (error==0)
				error = FPuts(destfile,";\n");
			
			Close(destfile);
			if (error)
				return 0;
			return 1;
			}
		}
	return 0;
}

LibCall int
WriteLocaleCD(pwn)
__A0 struct ProducerNode *pwn;
{
	char *basename =NULL;
	struct LocaleNode *ln;
	BPTR destfile;
	long error = 0;
	long pos=0;
	char namebuffer [100];
	
	if (pwn->BaseName != NULL)
		{
		CopyMem(pwn->BaseName,&namebuffer[0],72);
		pos = 0;
		while( namebuffer[pos] != 0 )
			pos += 1;
		if (pos>96)
			pos = 96;
		namebuffer[pos  ] = '.';
		namebuffer[pos+1] = 'c';
		namebuffer[pos+2] = 'd';
		namebuffer[pos+3] = 0;
		basename = &namebuffer[0];
		}
    
    pos = 0;
	
	if (pwn->LocaleCount == 0)
		return 1;
	
	if (pwn && basename && (pwn->LocaleCount>0))
		{
		destfile = Open(basename,MODE_NEWFILE);
		if (destfile)
			{
			
			if (error==0)
				error = FPuts(destfile,";Designer Produced empty .cd File : Do not edit.\n;\n");
			
			ln = (struct LocaleNode *)pwn->LocaleList.mlh_Head;
			while (ln->ln_Succ)
				{
				if (error==0)
					error = FPuts(destfile,";\n;");
				if ((error==0) && ln->ln_Comment)
					error = FPuts(destfile,ln->ln_Comment);
				if (error==0)
					error = FPuts(destfile,"\n");
				if ((error==0) && ln->ln_Label)
					error = FPuts(destfile,ln->ln_Label);
				if (error==0)
					error = FPuts(destfile,"  (//)\n");
				if ((error==0) && ln->ln_String)
					error = FPuts(destfile,ln->ln_String);
				if (error==0)
					error = FPuts(destfile,"\n");
				ln = ln->ln_Succ;
				pos++;
				}
			
			if (error==0)
				error = FPuts(destfile,";\n");
			
			Close(destfile);
			if (error)
				return 0;
			return 1;
			}
		}
	return 0;
}
