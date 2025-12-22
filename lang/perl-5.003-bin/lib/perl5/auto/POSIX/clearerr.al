# NOTE: Derived from ../../lib/POSIX.pm.  Changes made here will be lost.
package POSIX;

sub clearerr {
    redef "FileHandle::clearerr()";
}

1;
