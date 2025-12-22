vasm Render_lib.asm -o render.library -m68020 -w -devpac -x -Fhunkexe -I/opt/amigaos-68k/os-include/ -DHAVE_CPUFPU -DCPU60=0 -DCPU40=0 -DCPU20=1 -DUSEFPU=0 -quiet
vasm Render_lib.asm -o render.library_68040 -m68040 -w -devpac -x -Fhunkexe -I/opt/amigaos-68k/os-include/ -DHAVE_CPUFPU -DCPU60=0 -DCPU40=1 -DCPU20=0 -DUSEFPU=1 -quiet
vasm Render_lib.asm -o render.library_68060 -m68040 -w -devpac -x -Fhunkexe -I/opt/amigaos-68k/os-include/ -DHAVE_CPUFPU -DCPU60=1 -DCPU40=0 -DCPU20=0 -DUSEFPU=1 -quiet
vasm Render_lib.asm -o render.library_68060NOFPU -m68020 -w -devpac -x -Fhunkexe -I/opt/amigaos-68k/os-include/ -DHAVE_CPUFPU -DCPU60=1 -DCPU40=0 -DCPU20=0 -DUSEFPU=0 -quiet
