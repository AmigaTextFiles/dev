readiff _pic3.iff _pic3.raw 320 256 6 AGACOLORS CHUNKY8
echo >makex "		include	'_pic3.i'"
genam GENAM gfx.asm -Ogfx -vc31 -vp=68040/68881/68851
segcrunch gfx /all/_pic3.scr speed 3

readiff _cred1.iff _cred1.raw 320 256 6 AGACOLORS CHUNKY8
echo >makex "		include	'_cred1.i'"
genam GENAM gfx.asm -Ogfx -vc31 -vp=68040/68881/68851
segcrunch gfx /all/_cred1.scr speed 3

readiff _cred2.iff _cred2.raw 320 256 6 AGACOLORS CHUNKY8
echo >makex "		include	'_cred2.i'"
genam GENAM gfx.asm -Ogfx -vc31 -vp=68040/68881/68851
segcrunch gfx /all/_cred2.scr speed 3

readiff _cred3.iff _cred3.raw 320 256 6 AGACOLORS CHUNKY8
echo >makex "		include	'_cred3.i'"
genam GENAM gfx.asm -Ogfx -vc31 -vp=68040/68881/68851
segcrunch gfx /all/_cred3.scr speed 3

readiff _cred4.iff _cred4.raw 320 256 6 AGACOLORS CHUNKY8
echo >makex "		include	'_cred4.i'"
genam GENAM gfx.asm -Ogfx -vc31 -vp=68040/68881/68851
segcrunch gfx /all/_cred4.scr speed 3

readiff _spruch1.iff _spruch1.raw 320 256 6 AGACOLORS CHUNKY8
echo >makex "		include	'_spruch1.i'"
genam GENAM gfx.asm -Ogfx -vc31 -vp=68040/68881/68851
segcrunch gfx /all/_spruch1.scr speed 3

readiff _spruch2.iff _spruch2.raw 320 256 6 AGACOLORS CHUNKY8
echo >makex "		include	'_spruch2.i'"
genam GENAM gfx.asm -Ogfx -vc31 -vp=68040/68881/68851
segcrunch gfx /all/_spruch2.scr speed 3


