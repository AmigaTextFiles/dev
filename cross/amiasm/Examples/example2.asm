		; example of local symbols


		.section sec1
counter         .def 84h

loadcounter1	ldi counter,1     ; uses the counter of section sec 1
		ret

		.section sec2
counter         .rds 1

loadcounter2	ldi counter,2     ; uses the counter of section sec2
		ret

		.end
