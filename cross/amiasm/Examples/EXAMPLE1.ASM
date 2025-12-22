		; test van het rds directive    (reserve data space)


		.global test
buf             .def 90h

test		.rds  2

		.section testlabel


start 		ldi a,0
		ld a,test
		jrnz start
		ret

		.end
