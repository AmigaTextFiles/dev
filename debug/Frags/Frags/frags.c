/*
 * frags - a replacement for the frags command that will work on more than
 *	512K of memory. In fact, I went ahead and set things up for 16Meg.
 *
 * Note - I'm trying Knuths "literate programming," and attempting to explain
 * what's going on to some unknown audience. He claims this produces fewer
 * bugs. If nothing else, it produces more comments.
 *
 * I'd like to know what others think of the result. You can send (electronic)
 * mail to me as mwm@berkeley.edu, or ucbvax!mwm.
 *
 * Copyright (c) 1987, Mike Meyer
 * All Rights Reserved
 *
 * This code may be freely redistributed, so long as the source is made
 * available, and this notice is left in. You can even sell copies if you
 * want to, if you make the source available complete with this notice.
 */

#include <exec/types.h>
#include <exec/exec.h>
#include <exec/execbase.h>

/*
 * Generic comment on printing - all we're doing is pushing numbers out
 * on standard output, so we don't need the power (and hence size) of
 * printf. We pass the size & count to Print_Count, which will do all
 * the work. The original printfs have been left in place for reference.
 * Print_Count doesn't return anything, so we declare it void.
 */
void Print_Count(long, long) ;
/*
 * Since we need to convert two longs to ASCII, we'll turn that into a
 * subroutine that does all the work. It returns the same thing as
 * Print_Count, and so has the same type.
 */
void Long_To_ASCII(long, char *, int) ;

/*
 * We don't use the arguments, so use _main instead of main. Also, we're
 * not going to return anything, so make _main() a void function.
 */
void
_main() {
	/*
	 * There is a list of headers, each of which describes memory of some
	 * single type. Each header contains a pointer to the list of chunks
	 * of memory that it tracks. hdr will be used to point to each element
	 * in list of headers in turn.
	 */
	register struct MemHeader *hdr ;
	/*
	 * Each header has a list of chunks of memory associated with it.
	 * chunk will be used to point to each chunk of every header.
	 */
	register struct MemChunk *chunk ;
	/*
	 * Each chunk contains the size of the chunk, and a pointer to the
	 * next chunk. This size includes the size & next pointer for that
	 * chunk, but we're going to ignore that. We copy the size to a
	 * register variable for speed.
	 */
	register long	size ;
	/*
	 * SysBase is a pointer to lots of interesting data. For this
	 * program, we're going to get the pointer to the first memory
	 * header structure.
	 */
	extern struct ExecBase *SysBase ;
	/*
	 * The 680[01]0 has a 24 bit address space. For each bit, we're
	 * going to count the number of chunks whose size has that bit
	 * as it's high-order bit. Hence, 24 slots in the array. However,
	 * we're going to have an extra slot for zero-sized chunks, which
	 * shouldn't occur, so the program won't die horribly if they
	 * occur. Thus, we have 25 slots. Chunks of size 2^(N-1) to (2^N)-1
	 * will be counted in slot N. Also, since there can be more than 16
	 * bits of 8-byte chunks, we need longs to hold the counter.
	 * Finally, declare it static so that it will be zero'ed by the
	 * loader.
	 */
	static long Chunk_Count[25] ;
	/*
	 * Given an array, we really need something to index it with. Being
	 * an old FORTRAN hacker, I tend to favor i.
	 */
	register short i ;


	/*
	 * We need to prevent other tasks from changing the memory list
	 * while we're walking it. Forbid() turns off task switching, so
	 * that we are the only task running.
	 */
	Forbid() ;
	/*
	 * There is a standard list structure in AmigaDOS. SysBase contains
	 * a pointer to the list header for the list of memory headers
	 * (MemList), and lh_Head is the first member of that list.
	 */
	hdr = (struct MemHeader *) SysBase -> MemList . lh_Head ;
	/*
	 * Each element in an AmigaDOS list starts with a standard Node
	 * structure, in this case called mh_Node. ln_Succ is the link to
	 * the successor node in this list, and is part of the standard node
	 * structure. Standard lists are a circular doubly-linked, with a
	 * distinguished header/trailer node. This node is distinguished by
	 * having a zero (false) successor. So we stop walking the list when
	 * mh_Node . ln_Succ of hdr is false.
	 */
	while (hdr -> mh_Node . ln_Succ) {
		/*
		 * Chunks are a singly linked list, holding the length of the
		 * chunk and a pointer to the next chunk. The end of the
		 * chunk is denoted by a false pointer. Since the trailer is
		 * not distinguished, we check for chunk itself to be zero,
		 * not for it's successor to be false.
		 *
		 * I suspect that a standard AmigaDOS list wasn't used as that
		 * would have made the smallest possible memory chunk larger.
		 */
		for (chunk = hdr -> mh_First; chunk; chunk = chunk -> mc_Next) {
			/*
			 * The size of the chunk is called mc_Bytes. Save it
			 * in a register for speed.
			 */
			size = chunk -> mc_Bytes ;
			/*
			 * Now, count how many times you can shift size right
			 * before it becomes zero. i right shifts before size
			 * goes to zero will mean that size was between 2^(i-1)
			 * and (2^i)-1 at the start of the loop (unless i is
			 * zero, which means that size was 0), so we want to
			 * increment the Chunk_Count slot i. The special case
			 * for a zero-size chunk just falls out.
			 */
			for (i = 0; size; i += 1) size >>= 1 ;
			Chunk_Count[i] += 1 ;
			}
		/*
		 * Since the successor is non-zero, we need to switch to it,
		 * and then go over the next headers list of chunks.
		 */
		hdr = (struct MemHeader *) hdr -> mh_Node . ln_Succ ;
		}
	/*
	 * We're through playing with the memory list, so we use Permit()
	 * to turn task switching back on. This is called "being polite."
	 */
	Permit() ;
	/*
	 * The zero-length chunks don't fit the standard pattern, so
	 * print their count first. Use the same existence test as the
	 * standard loop, though.
	 */
	if (Chunk_Count[0])
		Print_Count((long) 0, Chunk_Count[0]) ;
/*
		printf("%8ld: %8d\n", (long) 0, Chunk_Count[0]) ;
*/
	/*
	 * Finally, we want to print the results of all this. So, we
	 * let the index (i) iterate over the slots in the chunk counter,
	 * from 1 to 23. Slot 0 has already been handled.
	 */
	for (i = 1; i <= 23; i += 1)
		/* 
		 * If Chunk_Count for this slot is non-zero (true), we
		 * print it. Otherwise, we skip it.
		 */
		if (Chunk_Count[i])
			/*
			 * Chunk_Count[i] contains a count of the number of
			 * chunks of size 2^(i-1) to 2^(i-1). So print 2^(i-1)
			 * and the count for chunks in that size range. Once
			 * again, we need more than 16 bits for possible
			 * sizes, so print it as a long, and cast the size
			 * argument to long.
			 */
			Print_Count(((long) 1) << (i - 1), Chunk_Count[i]) ;
/*
			printf("%8ld: %8d\n",
				((long) 1) << (i - 1), Chunk_Count[i]) ;
*/
	}

/*
 * Print_Count - print the pair of longs in fields of 8 spaces, seperated
 *	by a `:' and terminated by a newline.
 */
void
Print_Count(first, second)
	register long first, second;
	{

	/*
	 * Each long goes into a field 8 wide. We'll need that number 8
	 * in a number of places, so give it a nice name.
	 */
#define	OUTPUT_FIELD_SIZE	8
	/*
	 * The full field to be printed has two fields, plus a colon and
	 * a newline. We need that width in a few places also, so we give
	 * it a name too.
	 */
#define OUTPUT_SIZE	((2 * OUTPUT_FIELD_SIZE) + 1 + 1)
	/*
	 * Finally, we need a place to put the output string. So we declare
	 * a character array of the appropriate size.
	 */
	char	buffer[OUTPUT_SIZE] ;

	/*
	 * Let's do the easy part first, and put in the colon and the
	 * newline. The array is zero-based, so OUTPUT_FIELD_SIZE is
	 * the correct index for the colon (the first character after
	 * the first output field), and OUTPUT_SIZE is one greater than
	 * the index of the last character, so we use OUTPUT_SIZE - 1.
	 */
	buffer[OUTPUT_FIELD_SIZE] = ':' ;
	buffer[OUTPUT_SIZE - 1] = '\n' ;
	/*
	 * Now, we call Long_To_ASCII, which expects a pointer to the
	 * end of the field it's to fill, and the length of the field
	 * it's to fill. It'll put the number in place, and fill the
	 * rest of the field with spaces. See the previous comment for
	 * a discussion of the indices used.
	 */
	Long_To_ASCII(first, &buffer[OUTPUT_FIELD_SIZE - 1],
		OUTPUT_FIELD_SIZE) ;
	Long_To_ASCII(second, &buffer[OUTPUT_SIZE - 2],
		OUTPUT_FIELD_SIZE) ;
	/*
	 * Finally, print the result. Just call Write() with the output
	 * buffer and it's length, telling it to use the Output() stream.
	 */
	Write(Output(), buffer, OUTPUT_SIZE) ;
	}

/*
 * Long_To_ASCII - convert the first argument into an ASCII string ending
 * at the second argument, and fill out the field to the third argument
 * with spaces.
 */
void
Long_To_ASCII(in, out, length)
	register long in;
	register char *out;
	register int length;
	{

	/*
	 * If in is zero, we just put in a single '0'.
	 */
	if (in == 0) {
		*(out--) = '0' ;
		/*
		 * We've put in a digit, so reduce the length by 1.
		 */
		length -= 1 ;
		}
	/*
	 * Otherwise, we need to strip the digits off of in and put them
	 * in the array.
	 */
	else
		while (in != 0) {
			/*
			 * To prevent overflows, we check to make sure
			 * that there's space for this digit. If not,
			 * we just return, with no comment.
			 */
			if (length == 0) return ;
			/*
			 * The current low-order digit is merely in rem 10,
			 * which, if we add it to '0', will be the ASCII
			 * representation of that low-order digit.
			 */
			*(out--) = (in % 10) + '0' ;
			/*
			 * Once again, we've put in a digit, so we reduce
			 * length.
			 */
			length -= 1  ;
			/*
			 * Since we've got in's low order digit, we want
			 * the next lower order digit to be in place for
			 * the next loop iteration. This can be done by
			 * dividing in by 10.
			 */
			in /= 10 ;
			}
	/*
	 * Now, for however much length is left, we put a space in out,
	 * and nudge out to the next space.
	 */
	while (length-- != 0)
		*(out--) = ' ' ;
	}

/*
 * To cut down on memory useage, we provide a stub for a routine pulled
 * in by the default startup code in _main. This code cleans up
 * dynamically allocated memory, which we don't need. So we flush the code
 * here. By making this a smallcode, smalldata program, turning off stack 
 * checking (nothing recursive, and only three routines, so who needs it?),
 * and adding this, I've reduced the size of frags to 1644 bytes. Since the
 * original frags is 1964 bytes long, I'm happy. Just out of curiosity, I'd
 * like to know how large a binary Manx 3.4 produces.
 */
void
MemCleanup() {}

