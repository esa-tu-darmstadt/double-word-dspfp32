#include <ap_axi_sdata.h>
#include <ap_int.h>
#include <ap_float.h>

#define DEGREE 10
#define COEFFICIENTS (DEGREE+1)

#define SELECT 13
#define TWOSUM_BRANCH

typedef ap_float<56, 8> dwdouble;

struct data_t {
	dwdouble a;
	ap_int<72> b;
};

typedef hls::axis<data_t, 0, 0, 0> axis_t;

void hls_polynomial(hls::stream<axis_t> &in, hls::stream<axis_t> &out, 
    dwdouble c0, dwdouble c1, dwdouble c2, dwdouble c3, dwdouble c4, 
    dwdouble c5, dwdouble c6, dwdouble c7, dwdouble c8, dwdouble c9, dwdouble c10) {
 //   #pragma HLS INTERFACE mode=ap_ctrl_none port=return
	#pragma HLS INTERFACE axis port=in
	#pragma HLS INTERFACE axis port=out
	#pragma HLS PIPELINE II=1

    #pragma HLS INTERFACE s_axilite port=c0 bundle=control
    #pragma HLS INTERFACE s_axilite port=c1 bundle=control
    #pragma HLS INTERFACE s_axilite port=c2 bundle=control
    #pragma HLS INTERFACE s_axilite port=c3 bundle=control
    #pragma HLS INTERFACE s_axilite port=c4 bundle=control
    #pragma HLS INTERFACE s_axilite port=c5 bundle=control
    #pragma HLS INTERFACE s_axilite port=c6 bundle=control
    #pragma HLS INTERFACE s_axilite port=c7 bundle=control
    #pragma HLS INTERFACE s_axilite port=c8 bundle=control
    #pragma HLS INTERFACE s_axilite port=c9 bundle=control
    #pragma HLS INTERFACE s_axilite port=c10 bundle=control
    #pragma HLS INTERFACE s_axilite port=return bundle=control

    // read
    axis_t a;
    axis_t b;
    in.read_nb(a);

    // sum
    dwdouble x = a.data.a;
    /*dwdouble c[COEFFICIENTS] = {
        12.21309876501, -3123.12315325121, 41234.1239017, 0.1231589, 0.00001234123,
        12.21309876501, -3123.12315325121, 41234.1239017, 0.1231589, 0.00001234123,
        891.35131
    };*/

    dwdouble c[COEFFICIENTS] = {
        c0, c1, c2, c3, c4, c5, c6, c7, c8, c9, c10
    };

    dwdouble tmp[COEFFICIENTS];
    tmp[0] = c[0];
    for (int i = 1; i < COEFFICIENTS; i++) {
        tmp[i] = c[i] + x * tmp[i-1];
    }
    dwdouble y = tmp[COEFFICIENTS-1];

    // write
    axis_t pkt;
    pkt.data.a = y;
    pkt.data.b = 0;
    pkt.keep = -1;
    pkt.strb = -1;
    pkt.last = 1;
    out.write_nb(pkt);
}
