# NOTE: Derived from ../../lib/POSIX.pm.  Changes made here will be lost.
package POSIX;

sub fgetpos {
    redef "FileHandle::getpos()";
}

1;
