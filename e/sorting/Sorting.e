;/*
	ec sorting.e
	sorting
	quit
	
		
   Some sporting routines in E...
   translated by Will Harwood, 147800.97@swansea.ac.uk 11/03/98.
   
	We've just started looking into some sorting routines in Pascal/Prolog (UGH!) at
	uni (Big O et al), so I thought that by way of a diversion I'd write a translation
	of the three main ones covered in E. THESE HAVE BEEN OPTIMISED IN NO WAY! I thought
	it was important to retain clarity so as to aid understanding of how they work,
	which is really very simple if you are prepared to sit down and have a butchers.
   
   Yes, bubble-sort has been included, but only by way of showing what an AWFUL sorting
   algorithm it is. Nevertheless, it still keeps popping up in program after program...
   
   These are all on the Public Domain etc. I urge people to UNDERSTAND how they work,
   rather than dumping the code in where it is needed, and to use quicksort!

	If I've made any horrible mistakes, or you just want some clarification on these
	procedures then don't hestitate to e-mail me. I check my e-mail pretty much daily,
	so if you don't receive an answer in a couple of days then its a fair bet that either
	the network has started playing silly buggers again, or it's the holidays. So try again.

	I hope someone finds this useful.	   
   
Notes on algorithms:
   
   I did some (highly rudimentry!) testing by way of an example of their relative
   merits:
   
   Nos. to sort		Bubblesort				Mergesort				Quicksort **
	(Random)				Time	Iterations		Time	Iterations		Time	Iterations

		5					0		7					0		10					0		7          
	  10					0		33					0		20					0		13
	 100					29		2379				0		200				0		129
	1000						n/a	*				8		2000				5		1367
  10000						n/a	*				99		20000				69		13593
  50000						n/a	*				573	100000			403	68151


	*: The program ran out of stack and crashed! I raised the stack to 100K, but got bored
	   before it had finished the computation...
	**: This is the best possible example for quicksort because it is about as random
	    an input as the computer's Rnd function can get. With a more ordered list, mergesort
	    easily outdoes quicksort (try this out!)

	Big-O
	
		bubblesort=O(n!)
		mergesort=O(nlogn)
		quicksort=O(nlogn), worst case O(n^2)


	Which is best?
	
		Quicksort, in *almost* all occasions. Anything beats bubblesort by a mile, and
	for random arrays quicksort is both faster than mergesort, and doesn't require an
	extra array. However, if the array you want to sort is already fairly ordered
	then quicksort can be very slow indeed.

*/

CONST MAX=100		/* don't put >100 for bubblesort unless you are some sort of masochist */

DEF temp:PTR TO LONG

PROC main()
	DEF array:PTR TO LONG, n
	
	NEW array[MAX], temp[MAX]	/* allocate two arrays of LONG, MAX in length */
	IF (array=NIL) OR (temp=NIL) THEN CleanUp(0)
	
	FOR n:=0 TO MAX-1			/* fill the array with some random numbers */
		array[n]:=Rnd(MAX)
	ENDFOR

	bubblesort(array, 0, MAX-1)		/* sorted */
	-> mergesort(array, 0, MAX-1)
	-> quicksort(array, 0, MAX-1)

   FOR n:=0 TO MAX-1 DO PrintF('\d; ', array[n])		/* print out the sorted array */
   PrintF('\n')

	END array[MAX], temp[MAX]     /* free the two arrays */

ENDPROC

/*-------------------------------------------------------------------- quicksort */
PROC partition(array:PTR TO LONG, first, last)
	DEF splitv, up, down, i
	splitv:=array[first]
	up:=first
	down:=last
	REPEAT
		WHILE (array[up]<=splitv) AND (up<last) DO INC up
		WHILE (array[down]>splitv) AND (down>first) DO DEC down
		IF up<down
			i:=array[up]
			array[up]:=array[down]
			array[down]:=i
		ENDIF
	UNTIL up>=down
	i:=array[first]
	array[first]:=array[down]
	array[down]:=i
ENDPROC down
	

PROC quicksort(array:PTR TO LONG, first, last)
	DEF index
	IF first<last
		index:=partition(array, first, last)
		quicksort(array, first, index-1)
		quicksort(array, index+1, last)
	ENDIF
ENDPROC


/*-------------------------------------------------------------------- mergesort */

PROC mergesort(array:PTR TO LONG, first, last)
	DEF m
	IF first<last
		m:=(first+last)/2
		mergesort(array, first, m)
		mergesort(array, m+1, last)
		merge(array, first, m, last)
	ENDIF    
ENDPROC

PROC merge(array:PTR TO LONG, first, mid, last)
	DEF nextleft, nextright, i 
	nextleft:=first
	nextright:=mid+1
	i:=first
	WHILE (nextleft<=mid) AND (nextright<=last)
		IF array[nextleft]<array[nextright]
			temp[i]:=array[nextleft]
			INC i
			INC nextleft
		ELSE
			temp[i]:=array[nextright]
			INC i
			INC nextright
		ENDIF
	ENDWHILE

	WHILE nextleft<=mid
		temp[i]:=array[nextleft]
		INC i
		INC nextleft
	ENDWHILE
	
	WHILE nextright<=last
		temp[i]:=array[nextright]
		INC i
		INC nextright
	ENDWHILE

	FOR i:=first TO last DO array[i]:=temp[i] 
ENDPROC


/*-------------------------------------------------------------------- bubblesort */

PROC bubblesort(array:PTR TO LONG, first, max)
	DEF n, i
	FOR n:=first TO max-1
		IF array[n]>array[n+1]
			i:=array[n]
			array[n]:=array[n+1]
			array[n+1]:=i
			bubblesort(array, first, max-1)
		ENDIF
	ENDFOR
ENDPROC

