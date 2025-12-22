Examples: GTCardFile CardFile SBox FileRequest GTMultiReq EditListTest
	echo "Examples made"
GTCardFile: GTCardFile.o i:GTRequest.o
	dcc GTCardFile.o i:GTRequest.o -o GTCardFile
GTCardFile.o: GTCardFile.c
	dcc GTCardFile.c -c -o GTCardFile.o
CardFile.o: CardFile.c
	dcc CardFile.c -c -o CardFile.o
CardFile:  CardFile.o i:IGRequest.o
	dcc CardFile.o i:IGRequest.o -o CardFile
SBox:  SBox.o i:IGRequest.o
	dcc SBox.o i:IGRequest.o -chip -o SBox
SBox.o:  SBox.c
	dcc SBox.c -c -o SBox.o
FileRequest:  FileRequest.o i:IGFR.o i:IGRequest.o
	dcc FileRequest.o i:IGRequest.o i:IGFR.o -oFileRequest
FileRequest.o: FileRequest.c
	dcc FileRequest.c -c -o FileRequest.o
GTMultiReq.o: GTMultiReq.c
	dcc GTMultiReq.c -c -o GTMultiReq.o
GTMultiReq: GTMultiReq.o i:GTRequest.o
	dcc GTMultiReq.o i:GTRequest.o -o GTMultiReq
EditListTest: EditListTest.o i:ListViewKind.o i:EditList.o i:GTRequest.o
	dcc EditListTest.o i:ListViewKind.o i:EditList.o i:GTRequest.o -o EditListTest
EditListTest.o: EditListTest.c
	dcc EditListTest.c -c -o EditListTest.o


