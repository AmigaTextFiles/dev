/* Patch a user selectable file by Hunk, automatically.
   Apply all '000 and '010 relevant patches. */

MergeRelocs
ApplyPatch "General.hop"
ApplyPatch "Asl_Add.hop"
ApplyPatch "Aztec_Fix.hop"
MergeRelocs
Count 'hunks'
do i=0 to hunks-1
	StripZeros i
end
