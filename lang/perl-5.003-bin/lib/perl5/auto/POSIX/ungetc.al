# NOTE: Derived from ../../lib/POSIX.pm.  Changes made here will be lost.
package POSIX;

sub ungetc {
    redef "FileHandle::ungetc()";
}

1;
