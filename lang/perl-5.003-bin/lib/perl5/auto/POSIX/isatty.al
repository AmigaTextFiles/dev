# NOTE: Derived from ../../lib/POSIX.pm.  Changes made here will be lost.
package POSIX;

sub isatty {
    usage "isatty(filehandle)" if @_ != 1;
    -t $_[0];
}

1;
