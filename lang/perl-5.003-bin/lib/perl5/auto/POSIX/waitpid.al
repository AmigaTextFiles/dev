# NOTE: Derived from ../../lib/POSIX.pm.  Changes made here will be lost.
package POSIX;

sub waitpid {
    usage "waitpid(pid, options)" if @_ != 2;
    waitpid($_[0], $_[1]);
}

1;
