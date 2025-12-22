#drinc:opdef.g
#drinc:complex.g

proc main()void:
    complex a, b;

    cmplInitialize();
    write("a: ");
    readln(a);
    write("b: ");
    readln(b);
    writeln("a = ", a, ", b = ", b);
    writeln("a + b = ", a + b);
    writeln("a - b = ", a - b);
    writeln("a * b = ", a * b);
    writeln("a / b = ", a / b);
    writeln("a * 2 = ", a * complex(2.0, 0.0));
    writeln("real of a, imag of b = ", cmpl(cmplRe(a), cmplIm(b)));
    writeln("cmplNorm(a) = ", cmplNorm(a));
    writeln("cmplAbs(a) = ", cmplAbs(a));
    writeln("cmplSqrt(a) = ", cmplSqrt(a));
    writeln("cmplArg(a) = ", cmplArg(a));
    writeln("cmplExp(a) = ", cmplExp(a));
    writeln("cmplLog(a) = ", cmplLog(a));
    writeln("cmplSin(a) = ", cmplSin(a));
    writeln("cmplCos(a) = ", cmplCos(a));
    writeln("cmplTan(a) = ", cmplTan(a));
    writeln("cmplAtan(a) = ", cmplAtan(a));
corp;
