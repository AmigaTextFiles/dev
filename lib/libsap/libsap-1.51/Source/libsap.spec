%define ver 1.51.1
%define rel 1

Summary: emulation library of CPU 6502 and Pokey chip used in Atari XL/XE
Name: libsap
Version: %ver
Release: %rel
Copyright: freeware
Group: System Environment/Libraries
Source: libsap-%{ver}.tar.gz
URL: http://kunik.republika.pl/sap
Packager: Michal Kunikowski <kunik@poczta.onet.pl>
Prefix: /usr/local

%description
SAP Library is a software emulation of CPU 6502 microprocessor and Pokey chip.
Those two chips are used in Atari XL/XE computers. SAP Library is used to
to run programs written in 6502 machine language, programs that are using 
Pokey chip to play tunes and sounds.
  
%prep
%setup

%build
make static

%install
make install

%clean
make uninstall

%files
%defattr(-,root,root)
%doc README LICENSE
/usr/local/lib/libsap.a
/usr/local/include/libsap.h
