
NAME
	CyclicRedundancyCheck -- Check data integrity

SYNOPSIS
	crc = CyclicRedundancyCheck(buffer,length)
	d0                          a0     d0

FUNCTION
	A cyclic redundancy check is a magic number derived from all
	of the bits in a memory buffer and can be used to check whether
	or not that buffer has been corrupted.

	A CRC serves the same purpose as a checksum, but has a much
	lower chance of being right 'by accident', and therefore offers
	a higher degree of confidence in the integrity of the data.

INPUTS
	UBYTE *buffer - This is the address of the first byte of the
		buffer whose CRC you wish to calculate.

	ULONG length - This is the length of that buffer.

RESULT
	ULONG crc - The cyclic redundancy check of the specified buffer.

NOTES
	The details of how this magic number is calculated are private.

SEE ALSO
	
