OPT MODULE
OPT EXPORT

/*
 * ensure_filepath(file) is a function which sees that all directory
 * components of a prospective filename actually exist, if not it tries
 * to create them. If all went well and the filepath now fully exists,
 * it returns TRUE. If the path up to the file cannot be created, for
 * whatever reason, ensure_filepath() returns FALSE.
 *
 * makedir(dir) does as ensure_filepath(), except it sees the last
 * component not as a file, but a directory, and also creates it.
 *
 * Example:
 * makedir('RAM:a/b/c/d') -> makes RAM:a, RAM:a/b, RAM:a/b/c & RAM:a/b/c/d
 * ensure_filepath('RAM:test/bla/file.txt') -> makes RAM:test & RAM:test/bla
 *
 * NOTES:
 * - makedir() will fail if dir has a trailing slash
 * - ensure_filepath() may return a misleading TRUE if the
 *   final component exists as a file, not a directory.
 */

PROC makedir(dir)
  DEF lock=0
  IF ensure_filepath(dir) THEN UnLock(lock := CreateDir(dir))
ENDPROC (lock<>0)

PROC ensure_filepath(file)
  DEF p, lock
  p := file
  WHILE p[]
    IF p[] = "/"
      p[] := "\0"
      IF (lock := Lock(file, -1)) = 0 THEN lock := CreateDir(file)
      p[] := "/"
      IF lock THEN UnLock(lock) ELSE RETURN FALSE
    ENDIF
    p++
  ENDWHILE
ENDPROC TRUE
