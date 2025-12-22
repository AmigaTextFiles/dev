# NOTE: Derived from ../../lib/POSIX.pm.  Changes made here will be lost.
package POSIX;

sub fopen {
    redef "FileHandle::open()";
}

1;
