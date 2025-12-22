
; make_all.bat
delete /lib/Amiga_m68k/#? quiet
delete /lib/Amiga_PPC/#? quiet
delete /lib/MorphOS/#? quiet

failat 21
make -f make_m68k_large clean
failat 10
make -f make_m68k_large
make -f make_m68k_small clean
make -f make_m68k_small
make -f make_MorphOS_large clean
make -f make_morphos_large
make -f make_morphos_small clean
make -f make_morphos_small
make -f make_ppc_amiga_large clean
make -f make_ppc_amiga_large
make -f make_ppc_amiga_small clean
make -f make_ppc_amiga_small

