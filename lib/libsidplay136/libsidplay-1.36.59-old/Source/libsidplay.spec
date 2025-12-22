Name: libsidplay
Summary: Commodore 64 music player and SID chip emulator library
Epoch: 0
Version: 1.36.59
Release: 1
Source: libsidplay-%{version}.tgz
Icon: sidplay.xpm
Group: System Environment/Libraries
URL: http://www.geocities.com/SiliconValley/Lakes/5147/
License: GPL
BuildRoot: %{_tmppath}/%{name}-buildroot
Prefix: %{_prefix}

%description
This library provides the Sound Interface Device (SID) chip emulator
engine that is used by music player programs like SIDPLAY. With it
you can play musics from Commodore 64 (or compatible) programs.

%package devel
Summary: Header files for compiling apps that use libsidplay.
Group: System Environment/Libraries
Requires: %{name} = %{epoch}:%{version}-%{release}

%description devel
This package contains the header files for compiling applications
that use libsidplay.

%prep
%setup -q

%build
%ifarch i386 i486 i586 i686 athlon
CXXFLAGS="$RPM_OPT_FLAGS" ./configure --prefix=%{_prefix} --enable-optfixpoint --enable-optendian
%endif
%ifnarch i386 i486 i586 i686 athlon
CXXFLAGS="$RPM_OPT_FLAGS" ./configure --prefix=%{_prefix}
%endif
make

%install
rm -rf %{buildroot}
mkdir -p %{buildroot}
make DESTDIR=%{buildroot} install

%clean
rm -rf %{buildroot}

%post -p /sbin/ldconfig

%postun -p /sbin/ldconfig

%files
%defattr(-,root,root)
%{_libdir}/libsidplay*.so.*
%exclude %{_libdir}/*.la

%files devel
%defattr(-,root,root)
%doc AUTHORS COPYING DEVELOPER
%doc src/fastforward.txt src/format.txt src/mixing.txt src/mpu.txt src/panning.txt
%{_includedir}/sidplay
%{_libdir}/libsidplay.so
%{_libdir}/libsidplay.a
