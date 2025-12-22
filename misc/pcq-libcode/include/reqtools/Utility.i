{

Pascal translation of the Utility /Hooks and /Tags by Richard Waspe.

Original C headers Copyright Commodore Business Machines

fiddled by Michael Glew 1992
}

Type
	Hook	= Record
		h_MinNode	: MinNode;
		h_Entry		: ^Integer;
		h_SubEntry	: ^Integer;
		h_Data		: Address
	End;
	HookPtr	= ^Hook;

	Tag	= Integer;

	TagItem	= Record
		ti_Tag	: Tag;
		ti_Data	: Integer
	End;
	TagItemPtr	= ^TagItem;

Const
	TAG_DONE	= 0;
	TAG_END		= 0;
	TAG_IGNORE	= 1;
	TAG_MORE	= 2;
	TAG_SKIP	= 3;
	TAG_USER	= $80000000;
	TAGFILTER_AND	= 0;
	TAGFILTER_NOT	= 1;
