package amiga is

function OpenGraphicsLibrary(VERSION : in integer ) return boolean;
function OpenIntuitionLibrary(VERSION : in integer ) return boolean;
function OpenMUILibrary(VERSION : in integer ) return boolean;
function OpenLocaleLibrary(VERSION : in integer ) return boolean;
procedure CloseGraphicsLibrary;
procedure CloseMUILibrary;
procedure CloseIntuitionLibrary;
procedure CloseLocaleLibrary;

pragma Import ( C, OpenGraphicsLibrary, "OpenGraphicsLibrary");
pragma Import ( C, OpenIntuitionLibrary, "OpenIntuitionLibrary");
pragma Import ( C, OpenMUILibrary, "OpenMUILibrary");
pragma Import ( C, OpenLocaleLibrary, "OpenLocaleLibrary");
pragma Import ( C, CloseGraphicsLibrary, "CloseGraphicsLibrary");
pragma Import ( C, CloseMUILibrary, "CloseMUILibrary");
pragma Import ( C, CloseLocaleLibrary, "CloseLocaleLibrary");
pragma Import ( C, CloseIntuitionLibrary, "CloseIntuitionLibrary");

end amiga;