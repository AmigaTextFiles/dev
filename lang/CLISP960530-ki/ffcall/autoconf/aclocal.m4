dnl local autoconf macros
dnl Bruno Haible 17.6.1995
dnl Marcus Daniels 31.10.1994
dnl
dnl without AC_MSG_...:   with AC_MSG_... and caching:
dnl   AC_TRY_CPP          CL_CPP_CHECK
dnl   AC_TRY_COMPILE      CL_COMPILE_CHECK
dnl   AC_TRY_LINK         CL_LINK_CHECK
dnl   AC_TRY_RUN          CL_RUN_CHECK - would require cross-compiling support
dnl Usage:
dnl AC_TRY_CPP(INCLUDES,
dnl            ACTION-IF-FOUND [, ACTION-IF-NOT-FOUND])
dnl CL_CPP_CHECK(ECHO-TEXT, CACHE-ID,
dnl              INCLUDES,
dnl              ACTION-IF-FOUND [, ACTION-IF-NOT-FOUND])
dnl AC_TRY_xxx(INCLUDES, FUNCTION-BODY,
dnl            ACTION-IF-FOUND [, ACTION-IF-NOT-FOUND])
dnl CL_xxx_CHECK(ECHO-TEXT, CACHE-ID,
dnl              INCLUDES, FUNCTION-BODY,
dnl              ACTION-IF-FOUND [, ACTION-IF-NOT-FOUND])
dnl
define(CL_CPP_CHECK,
[AC_CACHE_CHECK([for $1],$2,
[AC_TRY_CPP([$3], $2=yes, $2=no)
])
if test [$]$2 = yes; then
  ifelse([$4], , :, [$4])
ifelse([$5], , , [else
  $5
])dnl
fi
])dnl
dnl
define(CL_COMPILE_CHECK,
[AC_CACHE_CHECK([for $1],$2,
[AC_TRY_COMPILE([$3],[$4], $2=yes, $2=no)
])
if test [$]$2 = yes; then
  ifelse([$5], , :, [$5])
ifelse([$6], , , [else
  $6
])dnl
fi
])dnl
dnl
define(CL_LINK_CHECK,
[AC_CACHE_CHECK([for $1],$2,
[AC_TRY_LINK([$3],[$4], $2=yes, $2=no)
])
if test [$]$2 = yes; then
  ifelse([$5], , :, [$5])
ifelse([$6], , , [else
  $6
])dnl
fi
])dnl
dnl
dnl Expands to the "extern ..." prefix used for system declarations.
dnl CL_LANG_EXTERN()
define(CL_LANG_EXTERN,
[extern[]dnl
ifelse(AC_LANG, CPLUSPLUS, [
#ifdef __cplusplus
"C"
#endif
], [ ])dnl
])
dnl
dnl CL_MSG_RESULTPROTO(RESULT-PROTOTYPE-DESCRIPTION)
define(CL_MSG_RESULTPROTO,
[AC_MSG_RESULT(${ac_t}[$1])
])dnl
dnl
dnl CL_PROTO(IDENTIFIER, ACTION-IF-NOT-FOUND, FINAL-PROTOTYPE)
define(CL_PROTO,
[AC_MSG_CHECKING([for $1 declaration])
AC_CACHE_VAL(cl_cv_proto_[$1], $2[
cl_cv_proto_$1="$3"])
cl_cv_proto_$1=`echo "[$]cl_cv_proto_$1" | tr -s ' ' | sed -e 's/( /(/'`
CL_MSG_RESULTPROTO([$]cl_cv_proto_$1)
])dnl
dnl
dnl CL_PROTO_RET(INCLUDES, DECL, CACHE-ID, TYPE-IF-OK, TYPE-IF-FAILS)
define(CL_PROTO_RET,
[AC_TRY_COMPILE([$1]
CL_LANG_EXTERN[$2
], [], $3="$4", $3="$5")
])dnl
dnl
dnl CL_PROTO_TRY(INCLUDES, ANSI-DECL, TRAD-DECL, ACTION-IF-OK, ACTION-IF-FAILS)
define(CL_PROTO_TRY,
[AC_TRY_COMPILE([$1]
CL_LANG_EXTERN
[#ifdef __STDC__
$2
#else
$3
#endif
], [], $4, $5)
])dnl
dnl
dnl CL_PROTO_CONST(INCLUDES, ANSI-DECL, TRAD-DECL, CACHE-ID)
define(CL_PROTO_CONST,
[CL_PROTO_TRY([$1], [$2], [$3], $4="", $4="const")]
)dnl
dnl
dnl CL_SILENT(ACTION)
dnl performs ACTION, with AC_MSG_CHECKING and AC_MSG_RESULT being defined away.
define(CL_SILENT,
[pushdef([AC_MSG_CHECKING],[:])dnl
pushdef([AC_CHECKING],[:])dnl
pushdef([AC_MSG_RESULT],[:])dnl
pushdef([CL_MSG_RESULTPROTO],[:])dnl
$1[]dnl
popdef([CL_MSG_RESULTPROTO])dnl
popdef([AC_MSG_RESULT])dnl
popdef([AC_CHECKING])dnl
popdef([AC_MSG_CHECKING])dnl
])dnl
dnl
AC_DEFUN(CL_AS_UNDERSCORE,
[AC_CACHE_CHECK([for underscore in external names],cl_cv_prog_as_underscore,
[cat > conftest.c <<EOF
int foo() { return 0; }
EOF
${CC-cc} -c conftest.c >/dev/null 2>&1
# check whether nm exists
if (nm conftest.o) >/dev/null 2>&1 ; then
  # use nm to see the assembly language name
  if nm conftest.o | grep _foo >/dev/null 2>&1 ; then
    cl_cv_prog_as_underscore=yes
  else
    cl_cv_prog_as_underscore=no
  fi
else
  # look for the assembly language name in the .s file
  ${CC-cc} -S conftest.c >/dev/null 2>&1
  if grep _foo conftest.s >/dev/null ; then
    cl_cv_prog_as_underscore=yes
  else
    cl_cv_prog_as_underscore=no
  fi
fi
rm -f conftest*
])
if test $cl_cv_prog_as_underscore = yes; then
  AS_UNDERSCORE=true
else
  AS_UNDERSCORE=false
fi
AC_SUBST(AS_UNDERSCORE)dnl
])dnl
dnl
AC_DEFUN(CL_PROG_RANLIB, [AC_CHECK_PROG(RANLIB, ranlib, ranlib, true)])dnl
dnl
AC_DEFUN(CL_PROG_INSTALL,
[dnl This is mostly copied from AC_PROG_INSTALL.
# Find a good install program.  We prefer a C program (faster),
# so one script is as good as another.  But avoid the broken or
# incompatible versions:
# SysV /etc/install, /usr/sbin/install
# SunOS /usr/etc/install
# IRIX /sbin/install
# AIX /bin/install
# AFS /usr/afsws/bin/install, which mishandles nonexistent args
# SVR4 /usr/ucb/install, which tries to use the nonexistent group "staff"
# ./install, which can be erroneously created by make from ./install.sh.
AC_MSG_CHECKING(for a BSD compatible install)
if test -z "$INSTALL"; then
AC_CACHE_VAL(cl_cv_path_install,
[  IFS="${IFS= 	}"; ac_save_ifs="$IFS"; IFS="${IFS}:"
  for ac_dir in $PATH; do
    case "$ac_dir" in
    ''|.|/etc|/usr/sbin|/usr/etc|/sbin|/usr/afsws/bin|/usr/ucb) ;;
    *)
      # OSF1 and SCO ODT 3.0 have their own names for install.
      for ac_prog in ginstall installbsd scoinst install; do
        if test -f $ac_dir/$ac_prog; then
	  if test $ac_prog = install &&
            grep dspmsg $ac_dir/$ac_prog >/dev/null 2>&1; then
	    # AIX install.  It has an incompatible calling convention.
	    # OSF/1 installbsd also uses dspmsg, but is usable.
	    :
	  else
	    cl_cv_path_install="$ac_dir/$ac_prog -c"
	    break 2
	  fi
	fi
      done
      ;;
    esac
  done
  IFS="$ac_save_ifs"
  # As a last resort, use cp.
  test -z "$cl_cv_path_install" && cl_cv_path_install="cp"
])dnl
  INSTALL="$cl_cv_path_install"
fi
dnl We do special magic for INSTALL instead of AC_SUBST, to get
dnl relative paths right. 
AC_MSG_RESULT($INSTALL)
AC_SUBST(INSTALL)dnl
# Use test -z because SunOS4 sh mishandles braces in ${var-val}.
# It thinks the first close brace ends the variable substitution.
test -z "$INSTALL_PROGRAM" && INSTALL_PROGRAM='$(INSTALL)'
AC_SUBST(INSTALL_PROGRAM)dnl
if test -z "$INSTALL_DATA"; then
  case "$INSTALL" in
    cp | */cp ) INSTALL_DATA='$(INSTALL)' ;;
    * )         INSTALL_DATA='$(INSTALL) -m 644' ;;
  esac
fi
AC_SUBST(INSTALL_DATA)dnl
])dnl
dnl
AC_DEFUN(CL_CANONICAL_HOST,
[AC_REQUIRE([AC_PROG_CC]) dnl Actually: AC_REQUIRE([CL_CC_WORKS])
dnl A substitute for AC_CONFIG_AUX_DIR_DEFAULT, so we don't need install.sh.
AC_CACHE_CHECK([host system type],cl_cv_host,
[ac_aux_dir=${srcdir}/$1
ac_config_guess=$ac_aux_dir/config.guess
ac_config_sub=$ac_aux_dir/config.sub
dnl Mostly copied from AC_CANONICAL_HOST.
# Make sure we can run config.sub.
if $ac_config_sub sun4 >/dev/null 2>&1; then :
else AC_MSG_ERROR(can not run $ac_config_sub)
fi
host_alias=$host
case "$host_alias" in
NONE)
  case $nonopt in
  NONE) dnl config.guess needs to compile things
        host_alias=`export CC; $ac_config_guess` ;;
  *)    host_alias=$nonopt ;;
  esac ;;
esac
# Don't fail just because the system is not listed in GNU's database.
if test -n "$host_alias"; then
  host=`$ac_config_sub $host_alias`
else
  host=unknown-unknown-unknown
fi
if test -z "$host" ; then
  host="$host_alias"
fi
cl_cv_host="$host"
])
host="$cl_cv_host"
host_cpu=`echo $host | sed 's/^\(.*\)-\(.*\)-\(.*\)$/\1/'`
host_vendor=`echo $host | sed 's/^\(.*\)-\(.*\)-\(.*\)$/\2/'`
host_os=`echo $host | sed 's/^\(.*\)-\(.*\)-\(.*\)$/\3/'`
AC_SUBST(host)dnl
AC_SUBST(host_cpu)dnl
AC_SUBST(host_vendor)dnl
AC_SUBST(host_os)dnl
])dnl
dnl
AC_DEFUN(CL_CANONICAL_HOST_CPU,
[AC_REQUIRE([CL_CANONICAL_HOST])
if test "$host_cpu" = i486 -o "$host_cpu" = i586; then
  host_cpu=i386
fi
if test "$host_cpu" = hppa1.0 -o "$host_cpu" = hppa1.1; then
  host_cpu=hppa
fi
if test "$host_cpu" = c1 -o "$host_cpu" = c2 -o "$host_cpu" = c32 -o "$host_cpu" = c34 -o "$host_cpu" = c38 -o "$host_cpu" = c4; then
  host_cpu=convex
fi
])dnl
dnl
AC_DEFUN(CL_VOID,
[CL_COMPILE_CHECK([working void], cl_cv_c_void, ,
[void f();
typedef void x; x g();
typedef void* y; y a;
], have_void=1, AC_DEFINE(void,char))dnl
if test -n "$have_void"; then
CL_COMPILE_CHECK([working \"return void\"], cl_cv_c_return_void,
[void f() {} typedef void x; x g() { return f(); }], [],
AC_DEFINE(return_void,[return]))dnl
fi
])dnl
dnl
AC_DEFUN(CL_PCC_STRUCT_RETURN,
[AC_CACHE_CHECK([for pcc non-reentrant struct return convention],cl_cv_c_struct_return_static,
[AC_TRY_RUN([typedef struct { int a; int b; int c; int d; int e; } foo;
foo foofun () { static foo foopi = {3141,5926,5358,9793,2385}; return foopi; }
foo* (*fun) () = (foo* (*) ()) foofun;
main()
{ foo foo1;
  foo* fooptr1;
  foo foo2;
  foo* fooptr2;
  foo1 = foofun(); fooptr1 = (*fun)(&foo1);
  foo2 = foofun(); fooptr2 = (*fun)(&foo2);
  exit(!(fooptr1 == fooptr2 && fooptr1->c == 5358));
}], cl_cv_c_struct_return_static=yes, rm -f core
cl_cv_c_struct_return_static=no,
dnl When cross-compiling, don't assume anything.
dnl There are even weirder return value passing conventions than pcc.
cl_cv_c_struct_return_static="guessing no")
])
case "$cl_cv_c_struct_return_static" in
  *yes) AC_DEFINE(__PCC_STRUCT_RETURN__) ;;
  *no) ;;
esac
])dnl
dnl
AC_DEFUN(CL_SMALL_STRUCT_RETURN,
[AC_CACHE_CHECK([whether small structs are returned in registers],cl_cv_c_struct_return_small,
[AC_TRY_RUN([typedef struct { int x; } foo; int y;
foo foofun () { foo f; f.x = y; return f; }
int (*fun) () = (int (*) ()) foofun;
main()
{ y = 37; if ((*fun)() != 37) exit(1);
  y = 55; if ((*fun)() != 55) exit(1);
  exit(0);
}], cl_cv_c_struct_return_small=yes, rm -f core
cl_cv_c_struct_return_small=no,
dnl When cross-compiling, don't assume anything.
dnl There are even weirder return value passing conventions than pcc.
cl_cv_c_struct_return_small="guessing no")
])
case "$cl_cv_c_struct_return_small" in
  *yes) AC_DEFINE(__SMALL_STRUCT_RETURN__) ;;
  *no) ;;
esac
])dnl
dnl
AC_DEFUN(CL_STDC_HEADERS,
dnl This is AC_STDC_HEADERS from Autoconf 1.2. The AC_STDC_HEADERS from
dnl Autoconf 1.3 fails on 386BSD because it checks for correct ANSI ctype
dnl macros and 386BSD (as well as SGI's /bin/cc from Irix-4.0.5) doesn't
dnl have them. But we don't need them!
dnl The same holds for the mem* functions in <string.h> and SunOS.
[CL_CPP_CHECK([ANSI C header files], cl_cv_header_stdc,
[#include <stdlib.h>
#include <stdarg.h>
#include <string.h>
#include <float.h>
#include <limits.h>], AC_DEFINE(STDC_HEADERS))
])dnl
dnl
AC_DEFUN(CL_STDLIB_H,
[AC_BEFORE([$0], [CL_ABORT])
AC_CHECK_HEADERS(stdlib.h)]
)dnl
dnl
AC_DEFUN(CL_UNISTD_H,
[AC_CHECK_HEADERS(unistd.h)]
)dnl
dnl
AC_DEFUN(CL_OPENFLAGS,
dnl BSD systems require #include <sys/file.h> for O_RDWR etc. being defined.
[AC_BEFORE([$0], [CL_MMAP])
AC_CHECK_HEADERS(sys/file.h)
if test $ac_cv_header_sys_file_h = yes; then
openflags_decl='#if defined(STDC_HEADERS) || defined(HAVE_STDLIB_H)
#include <stdlib.h>
#endif
#ifdef HAVE_UNISTD_H
#include <sys/types.h>
#include <unistd.h>
#endif
#include <fcntl.h>
'
openflags_prog='int x = O_RDWR | O_RDONLY | O_WRONLY | O_CREAT | O_TRUNC;'
CL_COMPILE_CHECK([O_RDWR in fcntl.h], cl_cv_decl_O_RDWR_fcntl_h,
$openflags_decl, $openflags_prog, openflags_ok=1)dnl
if test -z "$openflags_ok"; then
dnl CL_COMPILE_CHECK([O_RDWR in sys/file.h], cl_cv_decl_O_RDWR_sys_file_h,
dnl $openflags_decl[#include <sys/file.h>], $openflags_prog,
AC_DEFINE(NEED_SYS_FILE_H)
dnl openflags_ok=1)dnl
fi
fi
])dnl
dnl
AC_DEFUN(CL_SHM_H,
[AC_BEFORE([$0], [CL_SHMGET])dnl
AC_BEFORE([$0], [CL_SHMAT])dnl
AC_BEFORE([$0], [CL_SHMCTL])dnl
AC_BEFORE([$0], [CL_SHM_RMID])dnl
AC_CHECK_HEADERS(sys/shm.h)
if test $ac_cv_header_sys_shm_h = yes; then
AC_CHECK_HEADERS(sys/ipc.h)
fi
])dnl
dnl
AC_DEFUN(CL_MALLOC,
[CL_PROTO([malloc], [
AC_EGREP_HEADER([void.*\*.*malloc], stdlib.h, malloc_void=1)dnl
if test -z "$malloc_void"; then
AC_TRY_COMPILE([
#ifdef HAVE_STDLIB_H
#include <stdlib.h>
#endif
#ifdef HAVE_UNISTD_H
#include <unistd.h>
#endif
]CL_LANG_EXTERN[void* malloc();], [],
malloc_void=1)
fi
if test -n "$malloc_void"; then
cl_cv_proto_malloc_ret="void*"
else
cl_cv_proto_malloc_ret="char*"
fi
CL_PROTO_TRY([
#ifdef HAVE_STDLIB_H
#include <stdlib.h>
#endif
#ifdef HAVE_UNISTD_H
#include <unistd.h>
#endif
], [$cl_cv_proto_malloc_ret malloc (unsigned int size);],
[$cl_cv_proto_malloc_ret malloc();],
cl_cv_proto_malloc_arg1="unsigned int", cl_cv_proto_malloc_arg1="size_t")
], [extern $cl_cv_proto_malloc_ret malloc ($cl_cv_proto_malloc_arg1);])
AC_DEFINE_UNQUOTED(RETMALLOCTYPE,$cl_cv_proto_malloc_ret)
AC_DEFINE_UNQUOTED(MALLOC_SIZE_T,$cl_cv_proto_malloc_arg1)
])dnl
dnl
AC_DEFUN(CL_FREE,
[CL_PROTO([free], [
CL_PROTO_RET([
#ifdef HAVE_STDLIB_H
#include <stdlib.h>
#endif
#ifdef HAVE_UNISTD_H
#include <unistd.h>
#endif
], [int free();], cl_cv_proto_free_ret, int, void)],
[extern $cl_cv_proto_free_ret free ($cl_cv_proto_malloc_ret);])
AC_DEFINE_UNQUOTED(RETFREETYPE,$cl_cv_proto_free_ret)
])dnl
dnl
AC_DEFUN(CL_ABORT,
[AC_REQUIRE([CL_STDLIB_H])dnl
CL_PROTO([abort], [
CL_PROTO_RET([
#if defined(STDC_HEADERS) || defined(HAVE_STDLIB_H)
#include <stdlib.h>
#endif
#ifdef HAVE_UNISTD_H
#include <unistd.h>
#endif
], [int abort();], cl_cv_proto_abort_ret, int, void)
CL_PROTO_RET([
#if defined(STDC_HEADERS) || defined(HAVE_STDLIB_H)
#include <stdlib.h>
#endif
#ifdef HAVE_UNISTD_H
#include <unistd.h>
#endif
], [$cl_cv_proto_abort_ret abort();], cl_cv_proto_abort_vol, [], [__volatile__])
], [extern $cl_cv_proto_abort_vol $cl_cv_proto_abort_ret abort (void);])
AC_DEFINE_UNQUOTED(RETABORTTYPE,$cl_cv_proto_abort_ret)
AC_DEFINE_UNQUOTED(ABORT_VOLATILE,$cl_cv_proto_abort_vol)
])dnl
dnl
AC_DEFUN(CL_MKDIR,
[AC_BEFORE([$0], [CL_OPEN])
CL_PROTO([mkdir], [
AC_EGREP_HEADER(mode_t, sys/types.h,
dnl mode_t defined. check if it is really used by mkdir() :
CL_PROTO_TRY([
#if defined(STDC_HEADERS) || defined(HAVE_STDLIB_H)
#include <stdlib.h>
#endif
#ifdef HAVE_UNISTD_H
#include <unistd.h>
#endif
#include <sys/types.h>
#include <sys/stat.h>
], [int mkdir (char* path, mode_t mode);], [int mkdir();], mode_t_unneeded=1, )
if test -z "$mode_t_unneeded"; then
CL_PROTO_TRY([
#if defined(STDC_HEADERS) || defined(HAVE_STDLIB_H)
#include <stdlib.h>
#endif
#ifdef HAVE_UNISTD_H
#include <unistd.h>
#endif
#include <sys/types.h>
#include <sys/stat.h>
], [int mkdir (const char* path, mode_t mode);], [int mkdir();], mode_t_unneeded=1, )
fi)dnl
if test -n "$mode_t_unneeded"; then
cl_cv_type_mode_t="mode_t"
else
cl_cv_type_mode_t="int"
fi
dnl Now MODE_T should be correct, check for const:
CL_PROTO_CONST([
#if defined(STDC_HEADERS) || defined(HAVE_STDLIB_H)
#include <stdlib.h>
#endif
#ifdef HAVE_UNISTD_H
#include <unistd.h>
#endif
#include <sys/types.h>
#include <sys/stat.h>
], [int mkdir (char* path, $cl_cv_type_mode_t mode);], [int mkdir();], cl_cv_proto_mkdir_arg1)
], [extern int mkdir ($cl_cv_proto_mkdir_arg1 char*, $cl_cv_type_mode_t);])
AC_DEFINE_UNQUOTED(MODE_T,$cl_cv_type_mode_t)
AC_DEFINE_UNQUOTED(MKDIR_CONST,$cl_cv_proto_mkdir_arg1)
])dnl
dnl
AC_DEFUN(CL_OPEN,
[AC_REQUIRE([CL_MKDIR])dnl defines MODE_T
AC_BEFORE([$0], [CL_FILECHARSET])dnl
CL_PROTO([open], [
for y in 'MODE_T mode' '...'; do
for x in '' 'const'; do
if test -z "$have_open"; then
CL_PROTO_TRY([
#if defined(STDC_HEADERS) || defined(HAVE_STDLIB_H)
#include <stdlib.h>
#endif
#ifdef HAVE_UNISTD_H
#include <unistd.h>
#endif
#include <fcntl.h>
], [int open ($x char* path, int flags, $y);], [int open();], [
cl_cv_proto_open_arg1="$x"
if test "$y" = "..."; then
cl_cv_proto_open_dots=yes
else
cl_cv_proto_open_dots=no
fi
have_open=1])
fi
done
done
if test -z "$cl_cv_proto_open_dots"; then
dnl This actually happens with AIX 3.2.5 cc: cc understands prototypes but
dnl does not define __STDC__. The include files contain a declaration
dnl "int open (const char*, int, ...);" which gives an error against
dnl "int open ();". The right solution would be a macro CL_C_PROTOTYPES.
  cl_cv_proto_open_arg1="const"
  cl_cv_proto_open_dots=yes
fi
[ dnl Mysteriously, we need to quote this once more because of the commas.
if test $cl_cv_proto_open_dots = yes; then
cl_cv_proto_open_args="$cl_cv_proto_open_arg1 char*, int, ..."
else
cl_cv_proto_open_args="$cl_cv_proto_open_arg1 char*, int, $cl_cv_type_mode_t"
fi
]], [extern int open ($cl_cv_proto_open_args);])
AC_DEFINE_UNQUOTED(OPEN_CONST,$cl_cv_proto_open_arg1)
if test $cl_cv_proto_open_dots = yes; then
AC_DEFINE(OPEN_DOTS)
fi
])dnl
dnl
AC_DEFUN(CL_GETPAGESIZE,
[AC_BEFORE([$0], [CL_MPROTECT])
CL_LINK_CHECK([getpagesize], cl_cv_func_getpagesize, , [getpagesize();],
AC_DEFINE(HAVE_GETPAGESIZE)
have_getpagesize=1)dnl
if test -n "$have_getpagesize"; then
CL_PROTO([getpagesize], [
CL_PROTO_RET([
#if defined(STDC_HEADERS) || defined(HAVE_STDLIB_H)
#include <stdlib.h>
#endif
#ifdef HAVE_UNISTD_H
#include <unistd.h>
#endif
], [int getpagesize();], cl_cv_proto_getpagesize_ret, int, size_t)
], [extern $cl_cv_proto_getpagesize_ret getpagesize (void);])
AC_DEFINE_UNQUOTED(RETGETPAGESIZETYPE,$cl_cv_proto_getpagesize_ret)
fi
])dnl
dnl
AC_DEFUN(CL_MACH_VM,
[CL_LINK_CHECK([vm_allocate], cl_cv_func_vm,
 , [vm_allocate(); task_self();],
AC_DEFINE(HAVE_MACH_VM)dnl
)])dnl
dnl
AC_DEFUN(CL_MMAP,
[AC_REQUIRE([CL_OPENFLAGS])dnl
AC_REQUIRE([AC_TYPE_SIZE_T])dnl On AIX, the mmap() prototype references size_t which is undefined.
AC_REQUIRE([AC_TYPE_OFF_T])dnl We use off_t below.
AC_BEFORE([$0], [CL_MUNMAP])AC_BEFORE([$0], [CL_MPROTECT])
AC_CHECK_HEADER(sys/mman.h, , no_mmap=1)dnl
if test -z "$no_mmap"; then
AC_CHECK_FUNC(mmap, , no_mmap=1)dnl
if test -z "$no_mmap"; then
AC_DEFINE(HAVE_MMAP)
CL_PROTO([mmap], [
# Note: gcc2 does not consider
#   void* mmap (void*, size_t, int, int, int, off_t);
#   char* mmap();
# to be an error, if the first declaration comes from a system include file.
CL_PROTO_RET([
#if defined(STDC_HEADERS) || defined(HAVE_STDLIB_H)
#include <stdlib.h>
#endif
#ifdef HAVE_UNISTD_H
#include <unistd.h>
#endif
#include <sys/types.h>
#include <sys/mman.h>
], [void* mmap();], cl_cv_proto_mmap_ret, [void*], [caddr_t])
for y in 'int' 'size_t'; do
for x in 'void*' 'caddr_t'; do
if test -z "$have_mmap_decl"; then
CL_PROTO_TRY([
#if defined(STDC_HEADERS) || defined(HAVE_STDLIB_H)
#include <stdlib.h>
#endif
#ifdef HAVE_UNISTD_H
#include <unistd.h>
#endif
#include <sys/types.h>
#include <sys/mman.h>
], [$cl_cv_proto_mmap_ret mmap ($x addr, $y length, int prot, int flags, int fd, off_t off);],
[$cl_cv_proto_mmap_ret mmap();], [
cl_cv_proto_mmap_arg1="$x"
cl_cv_proto_mmap_arg2="$y"
have_mmap_decl=1])
fi
done
done
], [extern $cl_cv_proto_mmap_ret mmap ($cl_cv_proto_mmap_arg1, $cl_cv_proto_mmap_arg2, int, int, int, off_t);])
AC_DEFINE_UNQUOTED(RETMMAPTYPE,$cl_cv_proto_mmap_ret)
AC_DEFINE_UNQUOTED(MMAP_ADDR_T,$cl_cv_proto_mmap_arg1)
AC_DEFINE_UNQUOTED(MMAP_SIZE_T,$cl_cv_proto_mmap_arg2)
AC_CACHE_CHECK([for working mmap],cl_cv_func_mmap_works, 
[case "$host" in
  i[34]86-*-sysv4*)
    # UNIX_SYSV_UHC_1
    avoid=0x08000000 ;;
  mips-sgi-irix* | mips-dec-ultrix*)
    # UNIX_IRIX, UNIX_DEC_ULTRIX
    avoid=0x10000000 ;;
  rs6000-ibm-aix*)
    # UNIX_AIX
    avoid=0x20000000 ;;
  *)
    avoid=0 ;;
esac
mmap_prog_1='
#if defined(STDC_HEADERS) || defined(HAVE_STDLIB_H)
#include <stdlib.h>
#endif
#ifdef HAVE_UNISTD_H
#include <unistd.h>
#endif
#include <fcntl.h>
#ifdef NEED_SYS_FILE_H
#include <sys/file.h>
#endif
#include <sys/types.h>
#include <sys/mman.h>
]CL_LANG_EXTERN[
#ifdef __STDC__
RETMMAPTYPE mmap (MMAP_ADDR_T addr, MMAP_SIZE_T length, int prot, int flags, int fd, off_t off);
#else
RETMMAPTYPE mmap();
#endif
main () {
'
mmap_prog_2="#define bits_to_avoid $avoid"'
#define my_shift 24
#define my_low   1
#ifdef FOR_SUN4_29
#define my_high  31
#define my_size  32768 /* hope that 32768 is a multiple of the page size */
/* i*32 KB for i=1..31 gives a total of 15.5 MB, which is close to what we need */
#else
#define my_high  64
#define my_size  8192 /* hope that 8192 is a multiple of the page size */
/* i*8 KB for i=1..64 gives a total of 16.25 MB, which is close to what we need */
#endif
 {long i;
#define i_ok(i)  ((i) & (bits_to_avoid >> my_shift) == 0)
  for (i=my_low; i<=my_high; i++)
    if (i_ok(i))
      { caddr_t addr = (caddr_t)(i << my_shift);
/* Check for 8 MB, not 16 MB. This is more likely to work on Solaris 2. */
#if bits_to_avoid
        long size = i*my_size;
#else
        long size = ((i+1)/2)*my_size;
#endif
        if (mmap(addr,size,PROT_READ|PROT_WRITE,flags|MAP_FIXED,fd,0) == (RETMMAPTYPE)-1) exit(1);
    }
#define x(i)  *(unsigned char *) ((i<<my_shift) + (i*i))
#define y(i)  (unsigned char)((3*i-4)*(7*i+3))
  for (i=my_low; i<=my_high; i++) if (i_ok(i)) { x(i) = y(i); }
  for (i=my_high; i>=my_low; i--) if (i_ok(i)) { if (x(i) != y(i)) exit(1); }
  exit(0);
}}
'
AC_TRY_RUN([$mmap_prog_1
  int flags = MAP_ANON | MAP_PRIVATE;
  int fd = -1;
$mmap_prog_2
], have_mmap_anon=1
cl_cv_func_mmap_anon=yes, rm -f core,
: # When cross-compiling, don't assume anything.
)
AC_TRY_RUN([$mmap_prog_1
  int flags = MAP_ANONYMOUS | MAP_PRIVATE;
  int fd = -1;
$mmap_prog_2
], have_mmap_anon=1
cl_cv_func_mmap_anonymous=yes, rm -f core,
: # When cross-compiling, don't assume anything.
)
AC_TRY_RUN([$mmap_prog_1
#ifndef MAP_FILE
#define MAP_FILE 0
#endif
  int flags = MAP_FILE | MAP_PRIVATE;
  int fd = open("/dev/zero",O_RDONLY,0666);
  if (fd<0) exit(1);
$mmap_prog_2
], have_mmap_devzero=1
cl_cv_func_mmap_devzero=yes, rm -f core
retry_mmap=1,
: # When cross-compiling, don't assume anything.
)
if test -n "$retry_mmap"; then
AC_TRY_RUN([#define FOR_SUN4_29
$mmap_prog_1
#ifndef MAP_FILE
#define MAP_FILE 0
#endif
  int flags = MAP_FILE | MAP_PRIVATE;
  int fd = open("/dev/zero",O_RDONLY,0666);
  if (fd<0) exit(1);
$mmap_prog_2
], have_mmap_devzero=1
cl_cv_func_mmap_devzero_sun4_29=yes, rm -f core,
: # When cross-compiling, don't assume anything.
)
fi
if test -n "$have_mmap_anon" -o -n "$have_mmap_devzero"; then
cl_cv_func_mmap_works=yes
else
cl_cv_func_mmap_works=no
fi
])
if test "$cl_cv_func_mmap_anon" = yes; then
AC_DEFINE(HAVE_MMAP_ANON)
fi
if test "$cl_cv_func_mmap_anonymous" = yes; then
AC_DEFINE(HAVE_MMAP_ANONYMOUS)
fi
if test "$cl_cv_func_mmap_devzero" = yes; then
AC_DEFINE(HAVE_MMAP_DEVZERO)
fi
if test "$cl_cv_func_mmap_devzero_sun4_29" = yes; then
AC_DEFINE(HAVE_MMAP_DEVZERO_SUN4_29)
fi
fi
fi
])dnl
dnl
AC_DEFUN(CL_MPROTECT,
[AC_REQUIRE([CL_GETPAGESIZE])dnl
AC_REQUIRE([CL_MMAP])dnl
AC_CHECK_FUNCS(mprotect)dnl
if test $ac_cv_func_mprotect = yes; then
CL_PROTO([mprotect], [
CL_PROTO_CONST([
#if defined(STDC_HEADERS) || defined(HAVE_STDLIB_H)
#include <stdlib.h>
#endif
#ifdef HAVE_UNISTD_H
#include <unistd.h>
#endif
#include <sys/types.h>
#include <sys/mman.h>
], [int mprotect (MMAP_ADDR_T addr, MMAP_SIZE_T len, int prot);],
[int mprotect();], cl_cv_proto_mprotect_arg1)
], [extern int mprotect ($cl_cv_proto_mprotect_arg1 $cl_cv_proto_mmap_arg1, $cl_cv_proto_mmap_arg2, int);])
AC_DEFINE_UNQUOTED(MPROTECT_CONST,$cl_cv_proto_mprotect_arg1)
AC_CACHE_CHECK([for working mprotect],cl_cv_func_mprotect_works, 
[mprotect_prog='
#include <sys/types.h>
/* declare malloc() */
#ifdef HAVE_STDLIB_H
#include <stdlib.h>
#endif
#ifdef HAVE_UNISTD_H
#include <unistd.h>
#endif
#ifndef malloc
]CL_LANG_EXTERN[
#ifdef __STDC__
RETMALLOCTYPE malloc (MALLOC_SIZE_T size);
#else
RETMALLOCTYPE malloc();
#endif
#endif
/* declare getpagesize() and mprotect() */
#include <sys/mman.h>
#ifndef HAVE_GETPAGESIZE
#include <sys/param.h>
#define getpagesize() PAGESIZE
#else
]CL_LANG_EXTERN[
#ifdef __STDC__
RETGETPAGESIZETYPE getpagesize (void);
#else
RETGETPAGESIZETYPE getpagesize();
#endif
#endif
]CL_LANG_EXTERN[
#ifdef __STDC__
int mprotect (MPROTECT_CONST MMAP_ADDR_T addr, MMAP_SIZE_T len, int prot);
#else
int mprotect();
#endif
char foo;
main () {
  unsigned long pagesize = getpagesize();
#define page_align(address)  (char*)((unsigned long)(address) & -pagesize)
'
AC_TRY_RUN([$mprotect_prog
  if ((pagesize-1) & pagesize) exit(1);
  exit(0); }], , no_mprotect=1,
# When cross-compiling, don't assume anything.
no_mprotect=1)
mprotect_prog="$mprotect_prog"'
  char* area = malloc(6*pagesize);
  char* fault_address = area + pagesize*7/2;
'
if test -z "$no_mprotect"; then
AC_TRY_RUN([$mprotect_prog
  if (mprotect(page_align(fault_address),pagesize,PROT_NONE) < 0) exit(0);
  foo = *fault_address; /* this should cause a core dump */
  exit(0); }],
  no_mprotect=1, rm -f core,
: # When cross-compiling, don't assume anything.
)
fi
if test -z "$no_mprotect"; then
AC_TRY_RUN([$mprotect_prog
  if (mprotect(page_align(fault_address),pagesize,PROT_NONE) < 0) exit(0);
  *fault_address = 'z'; /* this should cause a core dump */
  exit(0); }],
  no_mprotect=1, rm -f core,
: # When cross-compiling, don't assume anything.
)
fi
if test -z "$no_mprotect"; then
AC_TRY_RUN([$mprotect_prog
  if (mprotect(page_align(fault_address),pagesize,PROT_READ) < 0) exit(0);
  *fault_address = 'z'; /* this should cause a core dump */
  exit(0); }],
  no_mprotect=1, rm -f core,
: # When cross-compiling, don't assume anything.
)
fi
if test -z "$no_mprotect"; then
AC_TRY_RUN([$mprotect_prog
  if (mprotect(page_align(fault_address),pagesize,PROT_READ) < 0) exit(1);
  if (mprotect(page_align(fault_address),pagesize,PROT_READ|PROT_WRITE) < 0) exit(1);
  *fault_address = 'z'; /* this should not cause a core dump */
  exit(0); }], , no_mprotect=1
rm -f core,
: # When cross-compiling, don't assume anything.
)
fi
if test -z "$no_mprotect"; then
  cl_cv_func_mprotect_works=yes
else
  cl_cv_func_mprotect_works=no
fi
])
if test $cl_cv_func_mprotect_works = yes; then
  AC_DEFINE(HAVE_WORKING_MPROTECT)
fi
fi
])dnl
dnl
AC_DEFUN(CL_CODEEXEC,
[AC_CACHE_CHECK([whether code in malloc'ed memory is executable],cl_cv_codeexec, 
[dnl The test below does not work on host=hppa*-hp-hpux* because on this system
dnl function pointers are actually pointers into(!) a two-pointer struct.
dnl The test below does not work on host=rs6000-*-* because on this system
dnl function pointers are actually pointers to a three-pointer struct.
case "$host_os" in
  hpux*) cl_cv_codeexec="guessing yes" ;;
  *)
case "$host_cpu" in
  # On host=rs6000-*-aix3.2.5 malloc'ed memory is indeed not executable.
  rs6000) cl_cv_codeexec="guessing no" ;;
  *)
AC_TRY_RUN([
#include <sys/types.h>
/* declare malloc() */
#ifdef HAVE_STDLIB_H
#include <stdlib.h>
#endif
#ifdef HAVE_UNISTD_H
#include <unistd.h>
#endif
#ifndef malloc
]CL_LANG_EXTERN[
#ifdef __STDC__
RETMALLOCTYPE malloc (MALLOC_SIZE_T size);
#else
RETMALLOCTYPE malloc();
#endif
#endif
int fun () { return 31415926; }
main ()
{ long size = (char*)&main - (char*)&fun;
  char* funcopy = malloc(size);
  int i;
  for (i = 0; i < size; i++) { funcopy[i] = ((char*)&fun)[i]; }
  exit(!((*(int(*)())funcopy)() == 31415926));
}], cl_cv_codeexec=yes, rm -f core
cl_cv_codeexec=no, cl_cv_codeexec="guessing yes")
  ;;
esac
  ;;
esac
])
case "$cl_cv_codeexec" in
  *yes) AC_DEFINE(CODE_EXECUTABLE) ;;
  *no)  ;;
esac
])dnl
dnl
AC_DEFUN(CL_SHMGET,
[AC_REQUIRE([CL_SHM_H])dnl
AC_BEFORE([$0], [CL_SHM])dnl
if test "$ac_cv_header_sys_shm_h" = yes -a "$ac_cv_header_sys_ipc_h" = yes; then
CL_PROTO([shmget], [
CL_PROTO_TRY([
#if defined(STDC_HEADERS) || defined(HAVE_STDLIB_H)
#include <stdlib.h>
#endif
#ifdef HAVE_UNISTD_H
#include <unistd.h>
#endif
#include <sys/types.h>
#include <sys/ipc.h>
#include <sys/shm.h>
], [int shmget (key_t key, int size, int shmflg);], [int shmget();],
cl_cv_proto_shmget_arg2="int", cl_cv_proto_shmget_arg2="size_t")
], [extern int shmget (key_t, $cl_cv_proto_shmget_arg2, int);])
AC_DEFINE_UNQUOTED(SHMGET_SIZE_T,$cl_cv_proto_shmget_arg2)
fi
])dnl
dnl
AC_DEFUN(CL_SHMAT,
[AC_REQUIRE([CL_SHM_H])dnl
AC_BEFORE([$0], [CL_SHM])dnl
if test "$ac_cv_header_sys_shm_h" = yes -a "$ac_cv_header_sys_ipc_h" = yes; then
CL_PROTO([shmat], [
CL_PROTO_RET([
#if defined(STDC_HEADERS) || defined(HAVE_STDLIB_H)
#include <stdlib.h>
#endif
#ifdef HAVE_UNISTD_H
#include <unistd.h>
#endif
#include <sys/types.h>
#include <sys/ipc.h>
#include <sys/shm.h>
], [void* shmat();],
cl_cv_proto_shmat_ret, [void*], [char*])
CL_PROTO_CONST([
#if defined(STDC_HEADERS) || defined(HAVE_STDLIB_H)
#include <stdlib.h>
#endif
#ifdef HAVE_UNISTD_H
#include <unistd.h>
#endif
#include <sys/types.h>
#include <sys/ipc.h>
#include <sys/shm.h>
], [$cl_cv_proto_shmat_ret shmat (int shmid, $cl_cv_proto_shmat_ret shmaddr, int shmflg);],
[$cl_cv_proto_shmat_ret shmat();], cl_cv_proto_shmat_arg2)
], [extern $cl_cv_proto_shmat_ret shmat (int, $cl_cv_proto_shmat_arg2 $cl_cv_proto_shmat_ret, int);])
AC_DEFINE_UNQUOTED(RETSHMATTYPE,$cl_cv_proto_shmat_ret)
AC_DEFINE_UNQUOTED(SHMAT_CONST,$cl_cv_proto_shmat_arg2)
fi
])dnl
dnl
AC_DEFUN(CL_SHMCTL,
[AC_REQUIRE([CL_SHM_H])dnl
AC_BEFORE([$0], [CL_SHM])dnl
if test "$ac_cv_header_sys_shm_h" = yes -a "$ac_cv_header_sys_ipc_h" = yes; then
CL_PROTO([shmctl], [
CL_PROTO_TRY([
#if defined(STDC_HEADERS) || defined(HAVE_STDLIB_H)
#include <stdlib.h>
#endif
#ifdef HAVE_UNISTD_H
#include <unistd.h>
#endif
#include <sys/types.h>
#include <sys/ipc.h>
#include <sys/shm.h>
], [int shmctl (int shmid, int cmd, struct shmid_ds * buf);], [int shmctl();],
[[[ dnl Mysteriously, we need to quote this three times because of the commas.
cl_cv_proto_shmctl_dots=no
cl_cv_proto_shmctl_args="int, int, struct shmid_ds *"]]],
[[[ dnl Mysteriously, we need to quote this three times because of the commas.
cl_cv_proto_shmctl_dots=yes
cl_cv_proto_shmctl_args="int, int, ..."]]])
], [extern int shmctl ($cl_cv_proto_shmctl_args);])
if test $cl_cv_proto_shmctl_dots = yes; then
  AC_DEFINE(SHMCTL_DOTS)
fi
fi
])dnl
dnl
AC_DEFUN(CL_SHM,
[AC_REQUIRE([CL_SHMGET])dnl
AC_REQUIRE([CL_SHMAT])dnl
AC_REQUIRE([CL_SHMCTL])dnl
AC_BEFORE([$0], [CL_SHM_RMID])dnl
if test "$ac_cv_header_sys_shm_h" = yes -a "$ac_cv_header_sys_ipc_h" = yes; then
# This test is from Marcus Daniels
AC_CACHE_CHECK([for working shared memory],cl_cv_sys_shm_works,
[AC_TRY_RUN([#include <sys/types.h>
#include <sys/ipc.h>
#include <sys/shm.h>
]CL_LANG_EXTERN[
#ifdef __STDC__
int shmget (key_t key, $cl_cv_proto_shmget_arg2 size, int shmflg);
#else
int shmget();
#endif
]CL_LANG_EXTERN[
#ifdef __STDC__
$cl_cv_proto_shmat_ret shmat (int shmid, $cl_cv_proto_shmat_arg2 $cl_cv_proto_shmat_ret shmaddr, int shmflg);
#else
$cl_cv_proto_shmat_ret shmat();
#endif
]CL_LANG_EXTERN[
#ifdef __STDC__
int shmdt ($cl_cv_proto_shmat_arg2 $cl_cv_proto_shmat_ret shmaddr);
#else
int shmdt();
#endif
]CL_LANG_EXTERN[
#ifdef __STDC__
int shmctl ($cl_cv_proto_shmctl_args);
#else
int shmctl();
#endif
/* try attaching a single segment to multiple addresses */
#define segsize 0x10000
#define attaches 128
#define base_addr 0x01000000
main ()
{ int shmid, i; char* addr; char* result;
  if ((shmid = shmget(IPC_PRIVATE,segsize,0400)) < 0) exit(1);
  for (i=0, addr = (char*)0x01000000; i<attaches; i++, addr += segsize)
    { if ((result = shmat(shmid,addr,SHM_RDONLY)) == (char*)(-1)) break; }
  for (i=0, addr = (char*)0x01000000; i<attaches; i++, addr += segsize)
    shmdt(addr);
  shmctl(shmid,IPC_RMID,0);
  exit(result == (char*)(-1));
}], cl_cv_sys_shm_works=yes, cl_cv_sys_shm_works=no,
dnl When cross-compiling, don't assume anything.
cl_cv_sys_shm_works="guessing no")
])
fi
case "$cl_cv_sys_shm_works" in
  *yes) have_shm=1
        AC_DEFINE(HAVE_SHM)
        AC_CHECK_HEADERS(sys/sysmacros.h)
        ;;
  *) ;;
esac
])dnl
dnl
AC_DEFUN(CL_CHAR_UNSIGNED,
[dnl This is mostly copied from AC_C_CHAR_UNSIGNED.
AC_CACHE_CHECK([whether characters are unsigned],ac_cv_c_char_unsigned,
[if test $ac_cv_prog_gcc = yes; then
  # GCC predefines this symbol on systems where it applies.
AC_EGREP_CPP(yes,
[#ifdef __CHAR_UNSIGNED__
  yes
#endif
], ac_cv_c_char_unsigned=yes, ac_cv_c_char_unsigned=no)
else
AC_TRY_RUN(
[/* volatile prevents gcc2 from optimizing the test away on sparcs.  */
#if !defined(__STDC__) || __STDC__ != 1
#define volatile
#endif
main() {
  volatile char c = 255; exit(c < 0);
}], ac_cv_c_char_unsigned=yes, ac_cv_c_char_unsigned=no,
ac_cv_c_char_unsigned="guessing no")
fi])
dnl
if test $ac_cv_prog_gcc = no; then
  # GCC defines __CHAR_UNSIGNED__ by itself, no need to fix up.
  case "$ac_cv_c_char_unsigned" in
    *yes) AC_DEFINE(__CHAR_UNSIGNED__) ;;
    *no) ;;
  esac
fi
])dnl
dnl
