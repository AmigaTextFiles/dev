{ ConvBrush.i - ConvBrush support file }

{ Some structures and definitions I need. }

type
    ArpFileReq = record
	fr_Hail : string;
	fr_File : string;
	fr_Dir : string;
	fr_Window : ^WindowPtr;
	fr_FuncFlags : byte;
	fr_reserved1 : byte;
	fr_Function : address;
	fr_reserved2 : integer;
    end;
    ArpFileReqPtr = ^ArpFileReq;

    FileRequester = record
	fr_Reserved1 : address;
	fr_File : string;
	fr_Drawer : string;
	fr_Reserved2 : address;
	fr_Reserved3,fr_Reserved4 : byte;
	fr_Reserved5 : address;
	fr_LeftEdge,fr_TopEdge,fr_Width,fr_Height : short;
	fr_Reserved6 : short;
	fr_NumArgs : integer;
	fr_ArgList : address;
	fr_UserData : address;
	fr_Reserved7,fr_Reserved8 : address;
	fr_Pattern : address;
    end;
    FileRequesterPtr = ^FileRequester;

const
    TAG_DONE		 = $00000000;
    ASLFR_TitleText	 = $80080001;
    ASLFR_Window	 = $80080002;
    ASLFR_InitialFile	 = $80080008;
    ASLFR_InitialDrawer	 = $80080009;
    ASLFR_InitialPattern = $8008000A;
    ASLFR_Flags1	 = $80080014;
    ASLFR_SleepWindow	 = $8008002B;
    ASLFR_RejectIcons	 = $8008003C;
    FILF_SAVE		 = $20;

function FileRequest(ArpFReq : ArpFileReqPtr) : address;
    external;

function AllocFileRequest : FileRequesterPtr;
    external;

procedure FreeFileRequest(FReq : FileRequesterPtr);
    external;

function AslRequest(FReq : FileRequesterPtr; TagList : ^integer) : address;
    external;

procedure _RefreshGList(Gadgets : GadgetPtr; Window : WindowPtr;
			Requester : RequesterPtr; NumGad : integer);
    external;

procedure _AddGadget(Window : WindowPtr; Gadgets : GadgetPtr; Pos : integer);
    external;

