#include <iostream>
#include <iomanip>

struct DW {
    float h;
    float l;
};

DW FastTwoSum(float a, float b) {
    DW res;
    res.h = a + b;
    float z = res.h - a;
    res.l = b - z;
    return res;
}

DW TwoSum(float a, float b) {
    if (a > b) {
        return FastTwoSum(a, b);
    } else {
        return FastTwoSum(b, a);
    }
}

DW Split(float x) {
    int t = 22;
    int SplitS = t / 2;
    float SplitC = (1 << SplitS) + 1;

    float p = x * SplitC;
    float q = x - p;
    float x1 = p + q;
    float x2 = x - x1;
    //std::cout << "    SplitC: " << SplitC << std::endl;
    //std::cout << "    p: " << p << std::endl;
    //std::cout << "    q: " << q << std::endl;
    //std::cout << "    x1: " << x1 << std::endl;
    //std::cout << "    x2: " << x2 << std::endl;
    DW res;
    res.h = x1;
    res.l = x2;
    return res;
}

DW TwoProd(float a, float b) {
    DW res;
    res.h = a * b;
    DW a1 = Split(a);
    DW b1 = Split(b);
    //std::cout << "  a1: " << a1.h << " " << a1.l << std::endl;
    //std::cout << "  b1: " << b1.h << " " << b1.l << std::endl;
    res.l = ((a1.h * b1.h - res.h) + a1.h * b1.l + a1.l * b1.h) + a1.l * b1.l;
    return res;
}

DW FPPlusFP(DW x, DW y) {
    std::cout << "FPPlusFP(" << std::endl;
    std::cout << "  x: " << x.h << std::endl;
    std::cout << "  y: " << y.h << std::endl;

    DW r = TwoSum(x.h, y.h);
    std::cout << "  r: " << r.h << " " << r.l << std::endl;
    std::cout << ");" << std::endl;
    return r;
}

DW DWPlusFP(DW x, DW y) {
    std::cout << "DWPlusFP(" << std::endl;
    std::cout << "  x: " << x.h << " " << x.l << "," << std::endl;
    std::cout << "  y: " << y.h << std::endl;

    DW s = TwoSum(x.h, y.h);
    std::cout << "  s: " << s.h << " " << s.l << std::endl;
    float v = x.l + s.l;
    std::cout << "  v: " << v << std::endl;
    DW r = FastTwoSum(s.h, v);

    std::cout << "  r: " << r.h << " " << r.l << std::endl;
    std::cout << ");" << std::endl;
    return r;
}

DW DWPlusDW_Sloppy(DW x, DW y) {
    std::cout << "DWPlusDW_Sloppy(" << std::endl;
    std::cout << "  x: " << x.h << " " << x.l << "," << std::endl;
    std::cout << "  y: " << y.h << " " << y.l << "," << std::endl;

    DW s = TwoSum(x.h, y.h);
    std::cout << "  s: " << s.h << " " << s.l << std::endl;
    float v = x.l + y.l;
    std::cout << "  v: " << v << std::endl;
    float w = s.l + v;
    std::cout << "  w: " << w << std::endl;
    DW r = FastTwoSum(s.h, w);

    std::cout << "  r: " << r.h << " " << r.l << std::endl;
    std::cout << ");" << std::endl;
    return r;
}

DW DWPlusDW_Accurate(DW x, DW y) {
    std::cout << "DWPlusDW_Accurate(" << std::endl;
    std::cout << "  x: " << x.h << " " << x.l << "," << std::endl;
    std::cout << "  y: " << y.h << " " << y.l << "," << std::endl;

    DW s = TwoSum(x.h, y.h);
    std::cout << "  s: " << s.h << " " << s.l << std::endl;
    DW t = TwoSum(x.l, y.l);
    std::cout << "  t: " << t.h << " " << t.l << std::endl;
    float c = s.l + t.h;
    std::cout << "  c: " << c << std::endl;
    DW v = FastTwoSum(s.h, c);
    std::cout << "  v: " << v.h << " " << v.l << std::endl;
    float w = t.l + v.l;
    std::cout << "  w: " << w << std::endl;
    DW r = FastTwoSum(v.h, w);

    std::cout << "  r: " << r.h << " " << r.l << std::endl;
    std::cout << ");" << std::endl;
    return r;
}

DW FPTimesFP(DW x, DW y) {
    std::cout << "FPTimesFP(" << std::endl;
    std::cout << "  x: " << x.h << std::endl;
    std::cout << "  y: " << y.h << std::endl;

    DW r = TwoProd(x.h, y.h);

    std::cout << "  r: " << r.h << " " << r.l << std::endl;
    std::cout << ");" << std::endl;
    return r;
}

DW DWTimesFP_Fast(DW x, DW y) {
    std::cout << "DWTimesFP_Fast(" << std::endl;
    std::cout << "  x: " << x.h << " " << x.l << "," << std::endl;
    std::cout << "  y: " << y.h << std::endl;

    DW c = TwoProd(x.h, y.h);
    std::cout << "  c: " << c.h << " " << c.l << std::endl;
    float cl2 = x.l * y.h;
    std::cout << "  cl2: " << cl2 << std::endl;
    float cl3 = c.l + cl2;
    std::cout << "  cl3: " << cl3 << std::endl;
    DW r = FastTwoSum(c.h, cl3);

    std::cout << "  r: " << r.h << " " << r.l << std::endl;
    std::cout << ");" << std::endl;
    return r;
}

DW DWTimesFP_Accurate(DW x, DW y) {
    std::cout << "DWTimesFP_Accurate(" << std::endl;
    std::cout << "  x: " << x.h << " " << x.l << "," << std::endl;
    std::cout << "  y: " << y.h << std::endl;

    DW c = TwoProd(x.h, y.h);
    std::cout << "  c: " << c.h << " " << c.l << std::endl;
    float cl2 = x.l * y.h;
    std::cout << "  cl2: " << cl2 << std::endl;
    DW t = FastTwoSum(c.h, cl2);
    std::cout << "  t: " << t.h << " " << t.l << std::endl;
    float tl2 = t.l * c.l;
    std::cout << "  tl2: " << tl2 << std::endl;
    DW r = FastTwoSum(t.h, tl2);

    std::cout << "  r: " << r.h << " " << r.l << std::endl;
    std::cout << ");" << std::endl;
    return r;
}

DW DWTimesDW_Fast(DW x, DW y) {
    std::cout << "DWTimesDW_Fast(" << std::endl;
    std::cout << "  x: " << x.h << " " << x.l << "," << std::endl;
    std::cout << "  y: " << y.h << " " << y.l << "," << std::endl;

    DW c = TwoProd(x.h, y.h);
    std::cout << "  c: " << c.h << " " << c.l << std::endl;
    float tl1 = x.h * y.l;
    std::cout << "  tl1: " << tl1 << std::endl;
    float tl2 = x.l * y.h;
    std::cout << "  tl2: " << tl2 << std::endl;
    float cl2 = tl1 + tl2;
    std::cout << "  cl2: " << cl2 << std::endl;
    float cl3 = c.l + cl2;
    std::cout << "  cl3: " << cl3 << std::endl;
    DW r = FastTwoSum(c.h, cl3);

    std::cout << "  r: " << r.h << " " << r.l << std::endl;
    std::cout << ");" << std::endl;
    return r;
}

int main(int argc, char** argv) {
    std::cout << std::setprecision(15);

    DW x = { h: 1538.68311, l: 0.000015315 };
    DW y = { h: 198935.1353, l: 0.0016566 };
    FPPlusFP(x, y);
    DWPlusFP(x, y);
    DWPlusDW_Sloppy(x, y);
    DWPlusDW_Accurate(x, y);
    FPTimesFP(x, y);
    DWTimesFP_Fast(x, y);
    DWTimesFP_Accurate(x, y);
    DWTimesDW_Fast(x, y);
    return 0;
}
