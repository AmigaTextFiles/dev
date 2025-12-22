Procedure ToggleWildStar;

begin
	If State then
		{ enable wildstar }
		pDosLibrary(DOSBase)^.dl_Root^.rn_Flags := pDosLibrary(DOSBase)^.dl_Root^.rn_Flags | RNF_WILDSTAR;
end;
