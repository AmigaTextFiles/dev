program entropak;

{$I "include:utils/stringlib.i"}
{$I "include:reqtools/reqtools.i"}

var
	fileRequestPtr	: FileRequesterPtr;
	fileName	: String;
	myFileListPtr	: FileListPtr;
	myHook		: Hook;

const
	matchPatStr	: string	= "*.doc";

procedure print_files(file_list:FileListPtr;path:string);

begin
	if file_list=NIL then
		return;
	writeln(path,'/',file_list^.Name);
	print_files(file_list^.Next,path)
end;

begin
	filename := allocstring(256);
	reqToolsBase := ReqToolsBasePtrType(OpenLibrary(REQTOOLNAME,37));
	if reqToolsBase<>Nil then begin
		fileRequestPtr := FileRequesterPtr(AllocRequestA(RT_FILEREQ,NIL));
		if fileRequestPtr<>NIL then begin
			fileRequestPtr^.hook := Adr(myhook);
			fileRequestPtr^.flags := FREQF_MULTISELECT+FREQF_PATGAD;
			strcpy(fileRequestPtr^.matchPat,matchPatStr);
			myFileListPtr := FileListPtr(FileRequestA(fileRequestPtr,filename,"Please select input file(s)",NIL));
			if myFileListPtr<>Nil then begin
				print_files(myFileListPtr,fileRequestPtr^.Dir);
				FreeFileList(myFileListPtr)
			end else
				writeln('ERROR - no file(s) selected');
			FreeReqBuffer(fileRequestPtr);
			FreeRequest(fileRequestPtr)
		end else
			writeln('ERROR - could not allocate requester');
		CloseLibrary(LibraryPtr(reqToolsBase))
	end else
		writeln('ERROR - could not open ',REQTOOLNAME,' version ',REQTOOLSVERSION)
end.
