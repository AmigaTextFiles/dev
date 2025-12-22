# NOTE: Derived from ../../lib/POSIX.pm.  Changes made here will be lost.
package POSIX;

sub fsetpos {
    redef "FileHandle::setpos()";
}

1;
