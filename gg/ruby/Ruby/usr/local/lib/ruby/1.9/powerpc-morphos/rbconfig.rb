
# This file was created by mkconfig.rb when ruby was built.  Any
# changes made to this file will be lost the next time ruby is built.

module RbConfig
  RUBY_VERSION == "1.9.0" or
    raise "ruby lib version (1.9.0) doesn't match executable version (#{RUBY_VERSION})"

  TOPDIR = File.dirname(__FILE__).chomp!("/lib/ruby/1.9/powerpc-morphos")
  DESTDIR = '' unless defined? DESTDIR
  CONFIG = {}
  CONFIG["DESTDIR"] = DESTDIR
  CONFIG["INSTALL"] = "/bin/install -c"
  CONFIG["prefix"] = (TOPDIR || DESTDIR + "/usr/local")
  CONFIG["EXEEXT"] = ""
  CONFIG["ruby_install_name"] = "ruby"
  CONFIG["RUBY_INSTALL_NAME"] = "ruby"
  CONFIG["RUBY_SO_NAME"] = "ruby"
  CONFIG["SHELL"] = "/bin/sh"
  CONFIG["PATH_SEPARATOR"] = ":"
  CONFIG["PACKAGE_NAME"] = ""
  CONFIG["PACKAGE_TARNAME"] = ""
  CONFIG["PACKAGE_VERSION"] = ""
  CONFIG["PACKAGE_STRING"] = ""
  CONFIG["PACKAGE_BUGREPORT"] = ""
  CONFIG["exec_prefix"] = "$(prefix)"
  CONFIG["bindir"] = "$(exec_prefix)/bin"
  CONFIG["sbindir"] = "$(exec_prefix)/sbin"
  CONFIG["libexecdir"] = "$(exec_prefix)/libexec"
  CONFIG["datadir"] = "$(prefix)/share"
  CONFIG["sysconfdir"] = "$(prefix)/etc"
  CONFIG["sharedstatedir"] = "$(prefix)/com"
  CONFIG["localstatedir"] = "$(prefix)/var"
  CONFIG["libdir"] = "$(exec_prefix)/lib"
  CONFIG["includedir"] = "$(prefix)/include"
  CONFIG["oldincludedir"] = "/usr/include"
  CONFIG["infodir"] = "$(prefix)/info"
  CONFIG["mandir"] = "$(prefix)/man"
  CONFIG["build_alias"] = ""
  CONFIG["host_alias"] = ""
  CONFIG["target_alias"] = ""
  CONFIG["ECHO_C"] = "\\c"
  CONFIG["ECHO_N"] = ""
  CONFIG["ECHO_T"] = ""
  CONFIG["LIBS"] = "-lpthread -ldl -lm "
  CONFIG["MAJOR"] = "1"
  CONFIG["MINOR"] = "9"
  CONFIG["TEENY"] = "0"
  CONFIG["build"] = "powerpc-unknown-morphos"
  CONFIG["build_cpu"] = "powerpc"
  CONFIG["build_vendor"] = "unknown"
  CONFIG["build_os"] = "morphos"
  CONFIG["host"] = "powerpc-unknown-morphos"
  CONFIG["host_cpu"] = "powerpc"
  CONFIG["host_vendor"] = "unknown"
  CONFIG["host_os"] = "morphos"
  CONFIG["target"] = "powerpc-unknown-morphos"
  CONFIG["target_cpu"] = "powerpc"
  CONFIG["target_vendor"] = "unknown"
  CONFIG["target_os"] = "morphos"
  CONFIG["CC"] = "gcc"
  CONFIG["CFLAGS"] = "-g -O2"
  CONFIG["LDFLAGS"] = ""
  CONFIG["CPPFLAGS"] = ""
  CONFIG["OBJEXT"] = "o"
  CONFIG["CXX"] = "g++"
  CONFIG["CXXFLAGS"] = "-g -O2"
  CONFIG["CPP"] = "gcc -E"
  CONFIG["EGREP"] = "grep -E"
  CONFIG["GNU_LD"] = "yes"
  CONFIG["CPPOUTFILE"] = "-o conftest.i"
  CONFIG["OUTFLAG"] = "-o "
  CONFIG["RANLIB"] = "ranlib"
  CONFIG["AR"] = "ar"
  CONFIG["AS"] = "as"
  CONFIG["ASFLAGS"] = ""
  CONFIG["NM"] = ""
  CONFIG["WINDRES"] = ""
  CONFIG["DLLWRAP"] = ""
  CONFIG["OBJDUMP"] = ""
  CONFIG["LN_S"] = "ln -s"
  CONFIG["SET_MAKE"] = ""
  CONFIG["INSTALL_PROGRAM"] = "$(INSTALL)"
  CONFIG["INSTALL_SCRIPT"] = "$(INSTALL)"
  CONFIG["INSTALL_DATA"] = "$(INSTALL) -m 644"
  CONFIG["RM"] = "rm -f"
  CONFIG["CP"] = "cp"
  CONFIG["MAKEDIRS"] = "mkdir -p"
  CONFIG["ALLOCA"] = ""
  CONFIG["DLDFLAGS"] = ""
  CONFIG["ARCH_FLAG"] = ""
  CONFIG["STATIC"] = ""
  CONFIG["CCDLFLAGS"] = " -fPIC"
  CONFIG["LDSHARED"] = "ld"
  CONFIG["LDSHAREDXX"] = ""
  CONFIG["DLEXT"] = "so"
  CONFIG["DLEXT2"] = ""
  CONFIG["LIBEXT"] = "a"
  CONFIG["LINK_SO"] = ""
  CONFIG["LIBPATHFLAG"] = " -L'%1$-s'"
  CONFIG["RPATHFLAG"] = " -Wl,-R'%1$-s'"
  CONFIG["LIBPATHENV"] = "LD_LIBRARY_PATH"
  CONFIG["TRY_LINK"] = ""
  CONFIG["STRIP"] = "strip"
  CONFIG["EXTSTATIC"] = ""
  CONFIG["setup"] = "Setup"
  CONFIG["MINIRUBY"] = "./miniruby$(EXEEXT)"
  CONFIG["PREP"] = "miniruby$(EXEEXT)"
  CONFIG["RUNRUBY"] = "$(MINIRUBY) $(srcdir)/runruby.rb --extout=$(EXTOUT) --"
  CONFIG["EXTOUT"] = ".ext"
  CONFIG["ARCHFILE"] = ""
  CONFIG["RDOCTARGET"] = "install-doc"
  CONFIG["XCFLAGS"] = " -DRUBY_EXPORT"
  CONFIG["XLDFLAGS"] = " -L."
  CONFIG["LIBRUBY_LDSHARED"] = "ld"
  CONFIG["LIBRUBY_DLDFLAGS"] = ""
  CONFIG["rubyw_install_name"] = ""
  CONFIG["RUBYW_INSTALL_NAME"] = ""
  CONFIG["LIBRUBY_A"] = "lib$(RUBY_SO_NAME)-static.a"
  CONFIG["LIBRUBY_SO"] = "lib$(RUBY_SO_NAME).so.$(MAJOR).$(MINOR).$(TEENY)"
  CONFIG["LIBRUBY_ALIASES"] = "lib$(RUBY_SO_NAME).so"
  CONFIG["LIBRUBY"] = "$(LIBRUBY_A)"
  CONFIG["LIBRUBYARG"] = "$(LIBRUBYARG_STATIC)"
  CONFIG["LIBRUBYARG_STATIC"] = "-l$(RUBY_SO_NAME)-static"
  CONFIG["LIBRUBYARG_SHARED"] = "-Wl,-R -Wl,$(libdir) -L$(libdir) -L. "
  CONFIG["SOLIBS"] = ""
  CONFIG["DLDLIBS"] = " -lc"
  CONFIG["ENABLE_SHARED"] = "no"
  CONFIG["MAINLIBS"] = ""
  CONFIG["COMMON_LIBS"] = ""
  CONFIG["COMMON_MACROS"] = ""
  CONFIG["COMMON_HEADERS"] = ""
  CONFIG["EXPORT_PREFIX"] = ""
  CONFIG["MAKEFILES"] = "Makefile"
  CONFIG["arch"] = "powerpc-morphos"
  CONFIG["sitearch"] = "powerpc-morphos"
  CONFIG["sitedir"] = "$(prefix)/lib/ruby/site_ruby"
  CONFIG["configure_args"] = "'--enable-frame-address' '==with-static-linked-ext' 'CC=gcc'"
  CONFIG["NROFF"] = "/bin/false"
  CONFIG["MANTYPE"] = "man"
  CONFIG["BASERUBY"] = "ruby"
  CONFIG["ruby_version"] = "$(MAJOR).$(MINOR)"
  CONFIG["rubylibdir"] = "$(libdir)/ruby/$(ruby_version)"
  CONFIG["archdir"] = "$(rubylibdir)/$(arch)"
  CONFIG["sitelibdir"] = "$(sitedir)/$(ruby_version)"
  CONFIG["sitearchdir"] = "$(sitelibdir)/$(sitearch)"
  CONFIG["topdir"] = File.dirname(__FILE__)
  MAKEFILE_CONFIG = {}
  CONFIG.each{|k,v| MAKEFILE_CONFIG[k] = v.dup}
  def RbConfig::expand(val, config = CONFIG)
    val.gsub!(/\$\$|\$\(([^()]+)\)|\$\{([^{}]+)\}/) do |var|
      if !(v = $1 || $2)
	'$'
      elsif key = config[v = v[/\A[^:]+(?=(?::(.*?)=(.*))?\z)/]]
	pat, sub = $1, $2
	config[v] = false
	RbConfig::expand(key, config)
	config[v] = key
	key = key.gsub(/#{Regexp.quote(pat)}(?=\s|\z)/n) {sub} if pat
	key
      else
	var
      end
    end
    val
  end
  CONFIG.each_value do |val|
    RbConfig::expand(val)
  end
end
Config = RbConfig # compatibility for ruby-1.8.4 and older.
CROSS_COMPILING = nil unless defined? CROSS_COMPILING
