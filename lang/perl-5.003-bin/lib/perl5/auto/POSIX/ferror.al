# NOTE: Derived from ../../lib/POSIX.pm.  Changes made here will be lost.
package POSIX;

sub ferror {
    redef "FileHandle::error()";
}

1;
