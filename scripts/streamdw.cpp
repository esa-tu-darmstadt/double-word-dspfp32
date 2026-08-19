#include <ap_axi_sdata.h>
#include <ap_int.h>
#include <ap_float.h>

#define SELECT 19
#define TWOSUM_BRANCH

typedef ap_float<32, 8> fp32;
typedef double fp64;
typedef ap_float<56, 8> fp56;

// FP64
#if SELECT == 0
    #define OP F32PlusF32
    #define TYPE double
    #define OPERATION(x, y) (((double) a.data.b) + ((double) b.data.b)) // f32 + f32
#elif SELECT == 1
    #define OP F64PlusF32
    #define TYPE double
    #define OPERATION(x, y) ((x.a) + (b.data.c))                        // f64 + f32
#elif SELECT == 2
    #define OP F64PlusF64
    #define TYPE double
    #define OPERATION(x, y) ((x.a) + (y.a))                             // f64 + f64

#elif SELECT == 3
    #define OP F32TimesF32
    #define TYPE double
    #define OPERATION(x, y) (((double) a.data.b) * ((double) b.data.b)) // f32 * f32
#elif SELECT == 4
    #define OP F64TimesF32
    #define TYPE double
    #define OPERATION(x, y) ((x.a) * (b.data.c))                        // f64 * f32
#elif SELECT == 5
    #define OP F64TimesF64
    #define TYPE double
    #define OPERATION(x, y) ((x.a) * (y.a))                             // f64 * f64

// DW
#elif SELECT == 6
    #define OP FPPlusFP
    #define TYPE DW
    #define OPERATION(x, y) iFPPlusFP(x.a.h, y.a.h)
#elif SELECT == 7
    #define OP DWPlusFP
    #define TYPE DW
    #define OPERATION(x, y) iDWPlusFP(x.a, y.a.h)
#elif SELECT == 8
    #define OP DWPlusDW_Sloppy
    #define TYPE DW
    #define OPERATION(x, y) iDWPlusDW_Sloppy(x.a, y.a)
#elif SELECT == 9
    #define OP DWPlusDW_Accurate
    #define TYPE DW
    #define OPERATION(x, y) iDWPlusDW_Accurate(x.a, y.a)

#elif SELECT == 10
    #define OP FPTimesFP
    #define TYPE DW
    #define OPERATION(x, y) iFPTimesFP(x.a.h, y.a.h)
#elif SELECT == 11
    #define OP DWTimesFP_Fast
    #define TYPE DW
    #define OPERATION(x, y) iDWTimesFP_Fast(x.a, y.a.h)
#elif SELECT == 12
    #define OP DWTimesFP_Accurate
    #define TYPE DW
    #define OPERATION(x, y) iDWTimesFP_Accurate(x.a, y.a.h)
#elif SELECT == 13
    #define OP DWTimesDW_Fast
    #define TYPE DW
    #define OPERATION(x, y) iDWTimesDW_Fast(x.a, y.a)

// FP56
#elif SELECT == 14
    #define OP F32PlusF32toFP56
    #define TYPE fp56
    #define OPERATION(x, y) (((fp56) a.data.b) + ((fp56) b.data.b)) // f32 + f32
#elif SELECT == 15
    #define OP F56PlusF32
    #define TYPE fp56
    #define OPERATION(x, y) ((x.a) + (b.data.c))                        // f64 + f32
#elif SELECT == 16
    #define OP F56PlusF56
    #define TYPE fp56
    #define OPERATION(x, y) ((x.a) + (y.a))                             // f64 + f64

#elif SELECT == 17
    #define OP F32TimesF32toFP56
    #define TYPE fp56
    #define OPERATION(x, y) (((fp56) a.data.b) * ((fp56) b.data.b)) // f32 * f32
#elif SELECT == 18
    #define OP F56TimesF32
    #define TYPE fp56
    #define OPERATION(x, y) ((x.a) * (b.data.c))                        // f64 * f32
#elif SELECT == 19
    #define OP F56TimesF56
    #define TYPE fp56
    #define OPERATION(x, y) ((x.a) * (y.a))                             // f64 * f64
#endif

struct DW {
	float h;
	float l;
};

struct data_t {
	TYPE a;
	float b;
	float c;
};

ap_uint<8> get_exponent(float x) {
    union {
        float f;
        ap_uint<32> u;
    } conv;

    conv.f = x;
    return conv.u.range(30, 23);
}

typedef hls::axis<data_t, 0, 0, 0> axis_t;
void stream(hls::stream<axis_t> &in0, hls::stream<axis_t> &in1, hls::stream<axis_t> &out);

// ################################################################
// ##  Helper  ####################################################
// ################################################################

struct DW TwoSum(float a, float b) {
	struct DW res;
#ifdef TWOSUM_BRANCH
    bool sel = get_exponent(a) > get_exponent(b);
	res.h = a + b;
	float z = res.h - (sel ? a : b);
	res.l = (sel ? b : a) - z;
#else
    res.h = a + b;
	float a1 = res.h - b;
	float b1 = res.h - a1;
	float da = a - a1;
	float db = b - b1;
	res.l = da + db;
#endif
	return res;
}

struct DW FastTwoSum(float a, float b) {
	struct DW res;
	res.h = a + b;
	float z = res.h - a;
	res.l = b - z;
	return res;
}

struct DW Split(float x) {
	struct DW res;

    const int t = 22;
    const int SplitS = t ;
    const int SplitC = (1 << SplitS) + 1;

    float p = x * (float) SplitC;
    float q = x - p;
    float x1 = p + q;
    float x2 = x - x1;

    res.h = x1;
    res.l = x2;
    return res;
}

struct DW TwoProd(float a, float b) {
	struct DW res;
    res.h = a * b;
    DW a1 = Split(a);
    DW b1 = Split(b);
    res.l = ((a1.h * b1.h - res.h) + a1.h * b1.l + a1.l * b1.h) + a1.l * b1.l;
	return res;
}

// ################################################################
// ##  Functions###################################################
// ################################################################

struct DW iFPPlusFP(float x, float y) {
    return TwoSum(x, y);
}

struct DW iDWPlusFP(struct DW x, float y) {
    DW s = TwoSum(x.h, y);
    float v = x.l * s.l;
    return FastTwoSum(s.h, v);
}

struct DW iDWPlusDW_Sloppy(struct DW x, struct DW y) {
    DW s = TwoSum(x.h, y.h);
    float v = x.l + y.l;
    float w = s.l + v;
    return FastTwoSum(s.h, w);
}

struct DW iDWPlusDW_Accurate(struct DW x, struct DW y) {
	struct DW s = TwoSum(x.h, y.h);
    struct DW t = TwoSum(x.l, y.l);
    float c = s.l + t.h;
    struct DW v = FastTwoSum(s.h, c);
    float w = t.l + v.l;
    return FastTwoSum(v.h, w);
}

struct DW iFPTimesFP(float x, float y) {
    return TwoProd(x, y);
}

struct DW iDWTimesFP_Fast(struct DW x, float y) {
    DW c = TwoProd(x.h, y);
    float cl2 = x.l * y;
    float cl3 = c.l + cl2;
    return FastTwoSum(c.h, cl3);
}

struct DW iDWTimesFP_Accurate(struct DW x, float y) {
    DW c = TwoProd(x.h, y);
    float cl2 = x.l * y;
    DW t = FastTwoSum(c.h, cl2);
    float tl2 = t.l + c.l;
    return FastTwoSum(t.h, tl2);
}

struct DW iDWTimesDW_Fast(struct DW x, struct DW y) {
    DW c = TwoProd(x.h, y.h);
    float tl1 = x.h * y.h;
    float tl2 = x.l * y.h;
    float cl2 = tl1 + tl2;
    float cl3 = c.l + cl2;
    return FastTwoSum(c.h, cl3);
}

// ################################################################
// ##  Stream  ####################################################
// ################################################################

void OP(hls::stream<axis_t> &in0, hls::stream<axis_t> &in1, hls::stream<axis_t> &out) {
    #pragma HLS INTERFACE mode=ap_ctrl_none port=return
	#pragma HLS INTERFACE axis port=in0
	#pragma HLS INTERFACE axis port=in1
	#pragma HLS INTERFACE axis port=out
	#pragma HLS PIPELINE II=1
    #pragma HLS aggregate variable=in0 compact=bit
    #pragma HLS aggregate variable=in1 compact=bit
    #pragma HLS aggregate variable=out compact=bit

    // read
    axis_t a;
    axis_t b;
    in0.read_nb(a);
    in1.read_nb(b);

    // sum
    data_t fa = a.data;
    data_t fb = b.data;
    TYPE fc = OPERATION(fa, fb);

    // write
    axis_t pkt;
    pkt.data.a = fc;
    pkt.data.b = 0.0;
    pkt.data.c = 0.0;
    pkt.keep = -1;
    pkt.strb = -1;
    pkt.last = 1;
    out.write_nb(pkt);
}
