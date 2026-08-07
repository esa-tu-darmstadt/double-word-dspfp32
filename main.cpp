#include <iostream>
#include <iomanip>
#include <fstream>
#include <vector>
#include <cstdint>
#include <random>

struct DW {
    float h;
    float l;
};

static int log_level = 1;

void log0(const char* name) {
    if (log_level != 0) {
        std::cout << name << std::endl;
    }
}

void log1(const char* name, float a) {
    if (log_level != 0) {
        std::cout << name << ": " << a << std::endl;
    }
}

void log2(const char* name, DW a) {
    if (log_level != 0) {
        std::cout << name << ": " << a.h << " " << a.l << std::endl;
    }
}

DW FastTwoSum(float a, float b) {
    DW res;
    res.h = a + b;
    float z = res.h - a;
    res.l = b - z;
    //log1("    a ", a);
    //log1("    b ", b);
    //log1("    rh", res.h);
    //log1("    z ", z);
    //log1("    rl", res.l);
    return res;
}

DW TwoSum(float a, float b) {
    if (fabs(a) > fabs(b)) {
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
    //log1("    SplitC", SplitC);
    //log1("    p", p);
    //log1("    q", q);
    //log1("    x1", x1);
    //log1("    x2", x2);
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
    //log2("  a1", a1);
    //log2("  b1", b1);
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
    float tl2 = t.l + c.l;
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

void write_hex_file(const std::string& filename, const std::vector<float>& data) {
    std::ofstream out(filename);
    for (float fvalue : data) {
        uint32_t ivalue = *((uint32_t*)&fvalue);
        out << std::uppercase
            << std::hex
            << std::setw(8)
            << std::setfill('0')
            << ivalue
            << '\n';
    }
}

int main(int argc, char** argv) {
    if (argc < 2) {
        std::cout << "output path missing" << std::endl;
        return 0;
    }

    std::cout << std::setprecision(15);
    std::random_device rd;
    std::mt19937 gen(rd());
    std::uniform_real_distribution<float> dist(-100000.0f, 100000.0f);

    std::vector<float> values;
    for (uint32_t i = 0; i < 1024; i++) {
        float xh = dist(gen);
        float yh = dist(gen);
        std::uniform_real_distribution<float> dist2(-xh / 10000.0f, xh / 10000.0f);
        std::uniform_real_distribution<float> dist3(-yh / 10000.0f, yh / 10000.0f);
        float xl = dist2(gen);
        float yl = dist3(gen);
        DW x = { xh, xl };
        DW y = { yh, yl };
        DW r0 = FPPlusFP(x, y);
        DW r1 = DWPlusFP(x, y);
        DW r2 = DWPlusDW_Sloppy(x, y);
        DW r3 = DWPlusDW_Accurate(x, y);
        DW r4 = FPTimesFP(x, y);
        DW r5 = DWTimesFP_Fast(x, y);
        DW r6 = DWTimesFP_Accurate(x, y);
        DW r7 = DWTimesDW_Fast(x, y);
        values.push_back(x.h);
        values.push_back(x.l);
        values.push_back(y.h);
        values.push_back(y.l);
        values.push_back(r0.h);
        values.push_back(r0.l);
        values.push_back(r1.h);
        values.push_back(r1.l);
        values.push_back(r2.h);
        values.push_back(r2.l);
        values.push_back(r3.h);
        values.push_back(r3.l);
        values.push_back(r4.h);
        values.push_back(r4.l);
        values.push_back(r5.h);
        values.push_back(r5.l);
        values.push_back(r6.h);
        values.push_back(r6.l);
        values.push_back(r7.h);
        values.push_back(r7.l);
    }
    write_hex_file(argv[1], values);
    return 0;
}
