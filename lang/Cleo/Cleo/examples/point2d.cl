program Essai_struct;

var
    pnt1, pnt3 : Point3d;
    pnt2 : Point2d;
    color : rgb;

begin
    pnt1.x := 10.1;
    pnt1.y := 20.2;
    pnt1.z := 30.3;

    pnt2.x := 40.4;
    pnt2.y := 50.5;

    pnt3 := pnt1 ;

    color.r := 255;
    color.g := 120;
    color.b := 20;

    writeln(' POINT3D:          z=', pnt1.z, ' y=', pnt1.y,' x=', pnt1.x);
    writeln(' POINT2D:          x=', pnt2.x,' y=', pnt2.y);
    writeln(' POINT3D No2:      z=', pnt3.z, ' y=', pnt3.y,' x=', pnt3.x);
    writeln(' COLOR:            r= ', color.r, ' g=',color.g, ' b=',color.b);

end.