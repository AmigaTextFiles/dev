MODULE 'dos/dos', 'dos/doshunks'

OBJECT hunk
  type
  offset
  reloc_type
  reloc_offset
ENDOBJECT

DEF fh, hunks:PTR TO hunk

PROC main()
  DEF filename=NIL, rdargs
  IF rdargs := ReadArgs('FILE/A', {filename}, NIL)
    IF fh := Open(filename, MODE_OLDFILE)
      mainpart()
      Close(fh)
    ENDIF
    FreeArgs(rdargs)
  ENDIF
ENDPROC

PROC mainpart() HANDLE
  DEF n, lo, hi, hunk, hunklen

  IF get() <> HUNK_HEADER THEN RETURN PrintF('no HUNK_HEADER\n')
  IF get() <> 0           THEN RETURN PrintF('hunk_name not 0\n')

  -> read basic facts of hunk
  PrintF('\d hunks in file\nHunks \d to \d are directly loaded\n',
    n := get(), lo := get(), hi := get()
  )

  -> get hunk memory requirements
  PrintF('Hunk memory requirements:\n')
  FOR n := lo TO hi DO PrintF('hunk \z\d[2]: \d[8] bytes of \s mem\n', n,
    Shl((hunk := get()) AND $1fffffff, 2),
    IF hunk AND HUNKF_FAST THEN (
      IF hunk AND HUNKF_CHIP THEN get() BUT 'CUSTOM' ELSE 'FAST'
    ) ELSE (
      IF hunk AND HUNKF_CHIP THEN 'CHIP' ELSE 'ANY '
    )
  )


  NEW hunks[n]

  PrintF('\nHunk scan:\n')
  FOR n := lo TO hi
    hunks[n].type := hunk := (get() AND $1fffffff)

    IF ((hunk <> HUNK_CODE) AND (hunk <> HUNK_DATA) AND
        (hunk <> HUNK_BSS)  AND (hunk <> HUNK_DEBUG))
      RETURN PrintF('hunk \z\d[2]: Unknown hunk \s ($\h)\n',
        n, hunkname(hunk), hunk)
    ENDIF

    hunklen := Shl(get(), 2)
    hunks[n].offset := here()

    PrintF('hunk \z\d[2]: \l\s[12] ($\h) offset \d, \d bytes length\n',
      n, hunkname(hunk), hunk, hunks[n].offset, hunklen
    )

    IF (hunk <> HUNK_BSS) THEN skip(hunklen)

    hunks[n].reloc_type := hunk := get()
    SELECT hunk
    CASE HUNK_RELOC32; hunk := 3
    CASE HUNK_RELOC16; hunk := 2
    CASE HUNK_RELOC8;  hunk := 1
    CASE HUNK_END;     hunk := 0
    DEFAULT; skip(-4); hunk := 0
    ENDSELECT

    IF hunk > 0
       hunks[n].reloc_offset := here()
       REPEAT
         IF (hunklen := get()) <> 0 THEN skip(Shl(hunklen,hunk-1)+4)
       UNTIL hunklen = 0
    ENDIF

    IF get() <> HUNK_END THEN skip(-4)
  ENDFOR

  PrintF('\nReloc dump:\n')
  FOR n := lo TO hi
    hunk := hunks[n].reloc_type
    SELECT hunk
    CASE HUNK_RELOC32; goto(hunks[n].reloc_offset); print_reloc(n, {get})
    CASE HUNK_RELOC16; goto(hunks[n].reloc_offset); print_reloc(n, {get16})
    CASE HUNK_RELOC8;  goto(hunks[n].reloc_offset); print_reloc(n, {get8})
    ENDSELECT
  ENDFOR

EXCEPT
ENDPROC

PROC print_reloc(thishunk, getproc)
  DEF n, hunk, offset, h, off2, x
  IF (n := get()) = 0 THEN RETURN
  hunk := get()
  FOR x := 1 TO n
    offset := getproc()
    h := here()
    goto(hunks[thishunk].offset+offset)
    off2 := getproc()
    goto(h)
    PrintF(
      'hunk \z\r\d[2] : $\z\r\h[8] -> hunk \z\r\d[2] : $\z\r\h[8]\n',
      thishunk, offset, hunk, off2
    )
    IF CtrlC() THEN Raise()
  ENDFOR
  print_reloc(thishunk, getproc)
ENDPROC


PROC get()
  DEF x=0; IF Read(fh, {x}, 4) < 0 THEN Raise()
ENDPROC x

PROC get16()
  DEF x=0; IF Read(fh, {x}+2, 2) < 0 THEN Raise()
ENDPROC x

PROC get8()
  DEF x=0; IF Read(fh, {x}+3, 1) < 0 THEN Raise()
ENDPROC x


PROC skip(x) IS Seek(fh, x, OFFSET_CURRENT)
PROC here() IS Seek(fh, 0, OFFSET_CURRENT)
PROC goto(x) IS Seek(fh, x, OFFSET_BEGINNING)

PROC hunkname(hunk) IS
  IF (hunk < HUNK_UNIT) OR (hunk > HUNK_ABSRELOC16) THEN '???' ELSE ListItem([
    'HUNK_UNIT', 'HUNK_NAME', 'HUNK_CODE', 'HUNK_DATA', 'HUNK_BSS',
    'HUNK_RELOC32', 'HUNK_RELOC16', 'HUNK_RELOC8', 'HUNK_EXT',
    'HUNK_SYMBOL', 'HUNK_DEBUG', 'HUNK_END', 'HUNK_HEADER', '???',
    'HUNK_OVERLAY', 'HUNK_BREAK', 'HUNK_DREL32', 'HUNK_DREL16',
    'HUNK_DREL8', 'HUNK_LIB', 'HUNK_INDEX', 'HUNK_RELOC32SHORT',
    'HUNK_RELRELOC32', 'HUNK_ABSRELOC16'
  ], hunk-HUNK_UNIT)
