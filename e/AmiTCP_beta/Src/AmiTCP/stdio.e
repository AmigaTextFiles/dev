OPT MODULE, PREPROCESS
OPT EXPORT

MODULE 'dos/stdio',
       'dos/dos'

#define fpos_t LONG

CONST IOFBF=BUF_FULL,
      IONBF=BUF_NONE,
      IOLBF=BUF_LINE

CONST BUFSIZ=512,
      EOF=ENDSTREAMCH,
      FOPEN_MAX=20,
      FILENAME_MAX=64,
      L_TMPNAM=64

CONST SEEK_SET=OFFSET_BEGINNING,
      SEEK_CUR=OFFSET_CURRENT,
      SEEK_END=OFFSET_END

CONST TMP_MAX=999

PROC remove(name) IS Not(DeleteFile(name))

PROC rename(oldname, newname) IS Not(Rename(oldname, newname))

PROC fclose(f) IS Not(Close(f))

PROC fflush(f) IS IF Flush(f) THEN 0 ELSE EOF

PROC setvbuf(fh, buff, type, size) IS SetVBuf(fh, buff, type, size)

-> fprintf is not defined since FPrintf does not exist (use VfPrintf)
-> printf is not defined since Printf does not exist (use VPrintf)

-> sprintf is in net.lib?

#define vfprintf VfPrintf
#define vprintf Vprintf

-> vsprintf is in net.lib?

#define fgetc FgetC

PROC fgets(buf,len,fh) IS Fgets(fh, buf, len)

PROC fputc(c,fh) IS FputC(fh, c)

PROC fputs(str,fh) IS Fputs(fh, str)

#define getc fgetc

PROC getchar() IS getc(stdin)

PROC gets(buf) IS fgets(buf, 1024, stdin)

#define putc fputc

PROC putchar(c) IS putc(c, stdout)

PROC puts(str) IS fputs(str, stdout)

PROC ungetc(c,fh) IS UnGetC(fh, c)

PROC fread(buf,blocklen,blocks,fh) IS Fread(fh, buf, blocklen, blocks)

PROC fwrite(buf,blocklen,blocks,fh) IS Fwrite(fh, buf, blocklen, blocks)

PROC fgetpos(fh, fposp:PTR TO LONG)
  fposp[]:=Seek(fh, 0, OFFSET_CURRENT)
ENDPROC fposp[]=-1

#define fseek Seek

PROC fsetpos(fh, fposp:PTR TO LONG)
ENDPROC IF Seek(fh, fposp[], OFFSET_BEGINNING)=-1 THEN EOF ELSE 0

PROC ftell(fh) IS Seek(fh, 0, OFFSET_CURRENT)

PROC rewind(fh) IS Seek(fh, 0, OFFSET_BEGINNING)

CONST F_OK=0
SET X_OK, W_OK, R_OK

PROC fgetchar() IS fgetc(stdin)

PROC fputchar(c) IS fputc(c, stdout)

PROC setnbf(fh) IS SetVBuf(fh, NIL, BUF_NONE, -1)

#define clrerr clearerr
#define access __access
