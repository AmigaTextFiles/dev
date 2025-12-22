#
# This file is auto-generated. ***ANY*** changes here will be lost
#

package Errno;
use vars qw(@EXPORT_OK %EXPORT_TAGS @ISA $VERSION %errno $AUTOLOAD);
use Exporter ();
use Config;
use strict;

$Config{'myarchname'} eq "m68k-amigaos" or
	die "Errno architecture (m68k-amigaos) does not match executable architecture ($Config{'myarchname'})";

$VERSION = "1.111";
@ISA = qw(Exporter);

@EXPORT_OK = qw(EFAULT ENOSYS ENETDOWN EAFNOSUPPORT ENOEXEC EALREADY
	EMSGSIZE ENOENT ECHILD EDEADLK ENOTBLK EISCONN EEXIST ERANGE
	ECONNABORTED EUSERS EDESTADDRREQ EXDEV ESTALE ELOOP EISDIR
	ERPCMISMATCH ENODEV ESHUTDOWN ECONNREFUSED ENOTTY ESOCKTNOSUPPORT
	EADDRINUSE ENOTEMPTY ESPIPE E2BIG ENOPROTOOPT EFTYPE EREMOTE
	ENETUNREACH EPIPE ENOTDIR ECONNRESET EPROCLIM EFBIG EIO EADDRNOTAVAIL
	EROFS EINVAL ENOTCONN EACCES EAGAIN ENAMETOOLONG ENOSPC EHOSTUNREACH
	ENOBUFS EMFILE EBADF ETXTBSY ENFILE EPFNOSUPPORT EWOULDBLOCK ENOLCK
	EMLINK ENOMEM EINTR ENXIO EDOM ENOTSOCK EBUSY EPROCUNAVAIL
	EPROGUNAVAIL ENETRESET ETIMEDOUT EINPROGRESS EBADRPC EDQUOT
	EPROTONOSUPPORT EPROGMISMATCH ESRCH EPERM EHOSTDOWN EPROTOTYPE
	ETOOMANYREFS EOPNOTSUPP);

%EXPORT_TAGS = (
    POSIX => [qw(
	E2BIG EACCES EADDRINUSE EADDRNOTAVAIL EAFNOSUPPORT EAGAIN EALREADY
	EBADF EBUSY ECHILD ECONNABORTED ECONNREFUSED ECONNRESET EDEADLK
	EDESTADDRREQ EDOM EDQUOT EEXIST EFAULT EFBIG EHOSTDOWN EHOSTUNREACH
	EINPROGRESS EINTR EINVAL EIO EISCONN EISDIR ELOOP EMFILE EMLINK
	EMSGSIZE ENAMETOOLONG ENETDOWN ENETRESET ENETUNREACH ENFILE ENOBUFS
	ENODEV ENOENT ENOEXEC ENOLCK ENOMEM ENOPROTOOPT ENOSPC ENOSYS ENOTBLK
	ENOTCONN ENOTDIR ENOTEMPTY ENOTSOCK ENOTTY ENXIO EOPNOTSUPP EPERM
	EPFNOSUPPORT EPIPE EPROCLIM EPROTONOSUPPORT EPROTOTYPE ERANGE EREMOTE
	EROFS ESHUTDOWN ESOCKTNOSUPPORT ESPIPE ESRCH ESTALE ETIMEDOUT
	ETOOMANYREFS ETXTBSY EUSERS EWOULDBLOCK EXDEV
    )]
);

sub EPERM () { 1 }
sub ENOENT () { 2 }
sub ESRCH () { 3 }
sub EINTR () { 4 }
sub EIO () { 5 }
sub ENXIO () { 6 }
sub E2BIG () { 7 }
sub ENOEXEC () { 8 }
sub EBADF () { 9 }
sub ECHILD () { 10 }
sub EDEADLK () { 11 }
sub ENOMEM () { 12 }
sub EACCES () { 13 }
sub EFAULT () { 14 }
sub ENOTBLK () { 15 }
sub EBUSY () { 16 }
sub EEXIST () { 17 }
sub EXDEV () { 18 }
sub ENODEV () { 19 }
sub ENOTDIR () { 20 }
sub EISDIR () { 21 }
sub EINVAL () { 22 }
sub ENFILE () { 23 }
sub EMFILE () { 24 }
sub ENOTTY () { 25 }
sub ETXTBSY () { 26 }
sub EFBIG () { 27 }
sub ENOSPC () { 28 }
sub ESPIPE () { 29 }
sub EROFS () { 30 }
sub EMLINK () { 31 }
sub EPIPE () { 32 }
sub EDOM () { 33 }
sub ERANGE () { 34 }
sub EWOULDBLOCK () { 35 }
sub EAGAIN () { 35 }
sub EINPROGRESS () { 36 }
sub EALREADY () { 37 }
sub ENOTSOCK () { 38 }
sub EDESTADDRREQ () { 39 }
sub EMSGSIZE () { 40 }
sub EPROTOTYPE () { 41 }
sub ENOPROTOOPT () { 42 }
sub EPROTONOSUPPORT () { 43 }
sub ESOCKTNOSUPPORT () { 44 }
sub EOPNOTSUPP () { 45 }
sub EPFNOSUPPORT () { 46 }
sub EAFNOSUPPORT () { 47 }
sub EADDRINUSE () { 48 }
sub EADDRNOTAVAIL () { 49 }
sub ENETDOWN () { 50 }
sub ENETUNREACH () { 51 }
sub ENETRESET () { 52 }
sub ECONNABORTED () { 53 }
sub ECONNRESET () { 54 }
sub ENOBUFS () { 55 }
sub EISCONN () { 56 }
sub ENOTCONN () { 57 }
sub ESHUTDOWN () { 58 }
sub ETOOMANYREFS () { 59 }
sub ETIMEDOUT () { 60 }
sub ECONNREFUSED () { 61 }
sub ELOOP () { 62 }
sub ENAMETOOLONG () { 63 }
sub EHOSTDOWN () { 64 }
sub EHOSTUNREACH () { 65 }
sub ENOTEMPTY () { 66 }
sub EPROCLIM () { 67 }
sub EUSERS () { 68 }
sub EDQUOT () { 69 }
sub ESTALE () { 70 }
sub EREMOTE () { 71 }
sub EBADRPC () { 72 }
sub ERPCMISMATCH () { 73 }
sub EPROGUNAVAIL () { 74 }
sub EPROGMISMATCH () { 75 }
sub EPROCUNAVAIL () { 76 }
sub ENOLCK () { 77 }
sub ENOSYS () { 78 }
sub EFTYPE () { 79 }

sub TIEHASH { bless [] }

sub FETCH {
    my ($self, $errname) = @_;
    my $proto = prototype("Errno::$errname");
    if (defined($proto) && $proto eq "") {
	no strict 'refs';
        return $! == &$errname;
    }
    require Carp;
    Carp::confess("No errno $errname");
} 

sub STORE {
    require Carp;
    Carp::confess("ERRNO hash is read only!");
}

*CLEAR = \&STORE;
*DELETE = \&STORE;

sub NEXTKEY {
    my($k,$v);
    while(($k,$v) = each %Errno::) {
	my $proto = prototype("Errno::$k");
	last if (defined($proto) && $proto eq "");
	
    }
    $k
}

sub FIRSTKEY {
    my $s = scalar keys %Errno::;
    goto &NEXTKEY;
}

sub EXISTS {
    my ($self, $errname) = @_;
    my $proto = prototype($errname);
    defined($proto) && $proto eq "";
}

tie %!, __PACKAGE__;

1;
__END__

=head1 NAME

Errno - System errno constants

=head1 SYNOPSIS

    use Errno qw(EINTR EIO :POSIX);

=head1 DESCRIPTION

C<Errno> defines and conditionally exports all the error constants
defined in your system C<errno.h> include file. It has a single export
tag, C<:POSIX>, which will export all POSIX defined error numbers.

C<Errno> also makes C<%!> magic such that each element of C<%!> has a non-zero
value only if C<$!> is set to that value, eg

    use Errno;
    
    unless (open(FH, "/fangorn/spouse")) {
        if ($!{ENOENT}) {
            warn "Get a wife!\n";
        } else {
            warn "This path is barred: $!";
        } 
    } 

=head1 AUTHOR

Graham Barr <gbarr@pobox.com>

=head1 COPYRIGHT

Copyright (c) 1997-8 Graham Barr. All rights reserved.
This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

