/* Patch a user selectable file by Hunk, automatically.
   Apply all '020 relevant patches. */

MergeRelocs
ApplyPatch "Libnix.hop"
ApplyPatch "Libnix.hop"
ApplyPatch "Lattice.hop"
ApplyPatch "HCE_NorthC.hop"
ApplyPatch "AmigaE_32a.hop"
ApplyPatch "Dice_206.hop"
ApplyPatch "General020.hop"
ApplyPatch "AmigaLib.hop"
ApplyPatch "Ace_235.hop"
ApplyPatch "Silver_MULU_256.hop"
ApplyPatch "Silver.hop"
ApplyPatch "SASC_6xx.hop"
ApplyPatch "PCQ_12b.hop"
ApplyPatch "OberonII_30.hop"
ApplyPatch "Oberon-A_16.hop"
ApplyPatch "Manx.hop"
ApplyPatch "Asl_Add.hop"
ApplyPatch "Aztec_Fix.hop"
MergeRelocs
Count 'hunks'
do i=0 to hunks-1
	StripZeros i
end
