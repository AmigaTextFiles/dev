rem $include cars_h

sub cars
	dim shared cars$( 12 )
	q=freefile
	open "cars" for input as q
	for n=0 to 12
		line input#q,cars$(n)
	next
	close q
end sub
