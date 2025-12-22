# NOTE: Derived from ../../lib/POSIX.pm.  Changes made here will be lost.
package POSIX;

sub fdopen {
    redef "FileHandle::new_from_fd()";
}

1;
