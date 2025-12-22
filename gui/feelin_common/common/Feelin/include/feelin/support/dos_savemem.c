///dos_savemem
void dos_savemem(APTR Memory, uint32 Length, STRPTR Header)
{
	STRPTR name = IFEELIN F_StrNew(NULL, "%s-0x%08lx", Header, Memory);

	if (name)
	{
		BPTR file = IDOS_ Open(name, MODE_NEWFILE);

		if (file)
		{
			IDOS_ Write(file, Memory, Length);

			IDOS_ Close(file);
		}

		IFEELIN F_Dispose(name);
	}
}
//+
