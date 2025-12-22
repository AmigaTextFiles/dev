;This doesn't work for some reason...

 draco complex.d
 blink                  complex.r     lib drlib:drio.lib+drlib:draco.lib+drlib:dos.lib+drlib:exec.lib+drlib:mathieeedoubbas.lib+drlib:mathieeedoubtrans.lib+drlib:complex.lib to complex     smallcode
 draco complexTest.d
 blink drlib:drstartf.o+complexTest.r lib drlib:drio.lib+drlib:draco.lib+drlib:dos.lib+drlib:exec.lib+drlib:mathieeedoubbas.lib+drlib:mathieeedoubtrans.lib+drlib:complex.lib to complexTest smallcode
 delete #?.r
