char *file;
void Window1_CloseWindow_Evt(void)
{
    Ep_QuitProgram();
}

void Getfile_CrashFile_GadgetUp_Evt(void)
{
	IDoMethod(gad[GID_Getfile_CrashFile],GFILE_REQUEST,NULL,win[WID_Window1],NULL);
	strcpy(file,Emperor_GetGadgetAttrComplex(gad[GID_Getfile_CrashFile], GETFILE_File));
	printf("the file was %s\n",file);

}

void Getfile_AlertFile_GadgetUp_Evt(void)
{
	IDoMethod(gad[GID_Getfile_AlertFile],GFILE_REQUEST,NULL,win[WID_Window1],NULL);
}

