# NOTE: Derived from ../../lib/POSIX.pm.  Changes made here will be lost.
package POSIX;

sub rand {
    unimpl "rand() is non-portable, use Perl's rand instead";
}

1;
