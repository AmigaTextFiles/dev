# $Id: flatzebra-0.1.spec.in,v 1.2 2004/05/02 04:15:55 sarrazip Exp $
# RPM specification file.

# Release number can be specified with rpm --define 'rel SOMETHING' ...
# If no such --define is used, the release number is 1.
#
# Source archive's extension can be specified with rpm --define 'srcext .foo'
# where .foo is the source archive's actual extension.
# To compile an RPM from a .bz2 source archive, give the command
#   rpmbuild -ta --define 'srcext .bz2' flatzebra-0.1.1.tar.bz2
#
%if %{?rel:0}%{!?rel:1}
%define rel 1
%endif
%if %{?srcext:0}%{!?srcext:1}
%define srcext .gz
%endif

Summary: A generic game engine for 2D double-buffering animation
Name: flatzebra
Version: 0.1.1
Release: %{rel}
License: GPL
Group: Amusements/Games
Source: %{name}-%{version}.tar%{srcext}
URL: http://sarrazip.com/dev/burgerspace.html
Packager: Pierre Sarrazin
Prefix: /usr
BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}-root
BuildRequires:	SDL-devel	>= 1.2.4
BuildRequires:	SDL_image-devel	>= 1.2.2
BuildRequires:	SDL_mixer-devel	>= 1.2.4
Requires:	SDL		>= 1.2.4
Requires:	SDL_image	>= 1.2.2
Requires:	SDL_mixer	>= 1.2.4

%description
Generic Game Engine library used by BurgerSpace et al.

%description -l fr
Moteur de jeu générique utilisé par BurgerSpace et al.

%package devel
Summary: C++ header files for the flatzebra library
Group: Development/Libraries
Requires: flatzebra = 0.1.1

%description devel
C++ header files for the flatzebra library.

%description -l fr devel
En-têtes C++ pour la librairie flatzebra.


%prep
%setup -q

%build
%configure
make

%install
rm -fR $RPM_BUILD_ROOT
make DESTDIR=$RPM_BUILD_ROOT install

%clean
rm -fR $RPM_BUILD_ROOT

%post
/sbin/ldconfig

%postun
# If the package reference count is >= 1, then run the ldconfig command.
if [ "$1" -ge "1" ]; then 
	/sbin/ldconfig 
fi

%files
%defattr(-, root, root)
%{_libdir}/lib*.so.*
%doc %{_defaultdocdir}/*

%files devel
%defattr(-, root, root)
%{_includedir}/*
%{_libdir}/lib*.so
%{_prefix}/lib/lib*.la
# (sic) See Fedora documentation re: "More RPM Building Hints"
%{_libdir}/pkgconfig/*
