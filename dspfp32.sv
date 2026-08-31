module dsp58_ip#(
    parameter A_REGS = 0,
    parameter B_REGS = 0,
    parameter C_REGS = 0,
    parameter M_REGS = 0
) (
    input logic aclk,
    input logic [33:0] a,
    input logic [23:0] b,
    input logic [57:0] c,
    input logic [8:0] opmode,
    output logic [57:0] p
);

// DSP58: 58-bit Multi-Functional Arithmetic Block
// Versal Prime Series
// Xilinx HDL Language Template, version 2025.1
DSP58 #(
    // Feature Control Attributes: Data Path Selection
    .AMULTSEL("A"),// Selects A input to multiplier (A, AD)
    .A_INPUT("DIRECT"),// Selects A input source, "DIRECT" (A port) or "CASCADE" (ACIN port)
    .B_INPUT("DIRECT"),// Selects B input source, "DIRECT" (B port) or "CASCADE" (BCIN port)
    .BMULTSEL("B"),// Selects B input to multiplier (AD, B)
    .DSP_MODE("INT24"),// Configures DSP to a particular mode of operation. Set to INT24 for legacy mode.
    .PREADDINSEL("A"),// Selects input to pre-adder (A, B)
    .RND(58'h000000000000000),// Rounding Constant
    .USE_MULT("MULTIPLY"),// Select multiplier usage (DYNAMIC, MULTIPLY, NONE)
    .USE_SIMD("ONE58"),// SIMD selection (FOUR12, ONE58, TWO24)
    .USE_WIDEXOR("FALSE"),// Use the Wide XOR function (FALSE, TRUE)
    .XORSIMD("XOR24_34_58_116"),// Mode of operation for the Wide XOR (XOR12_22, XOR24_34_58_116)
    // Pattern Detector Attributes: Pattern Detection Configuration
    .AUTORESET_PATDET("NO_RESET"),// NO_RESET, RESET_MATCH, RESET_NOT_MATCH
    .AUTORESET_PRIORITY("RESET"),// Priority of AUTORESET vs. CEP (CEP, RESET).
    .MASK(58'h0ffffffffffffff),// 58-bit mask value for pattern detect (1=ignore)
    .PATTERN(58'h000000000000000),// 58-bit pattern match for pattern detect
    .SEL_MASK("MASK"),// C, MASK, ROUNDING_MODE1, ROUNDING_MODE2
    .SEL_PATTERN("PATTERN"),// Select pattern value (C, PATTERN)
    .USE_PATTERN_DETECT("NO_PATDET"),// Enable pattern detect (NO_PATDET, PATDET)
    // Programmable Inversion Attributes: Specifies built-in programmable inversion on specific pins
    .IS_ALUMODE_INVERTED(4'b0000),// Optional inversion for ALUMODE
    .IS_CARRYIN_INVERTED(1'b0),// Optional inversion for CARRYIN
    .IS_CLK_INVERTED(1'b0),// Optional inversion for CLK
    .IS_INMODE_INVERTED(5'b00000),// Optional inversion for INMODE
    .IS_NEGATE_INVERTED(3'b000),// Optional inversion for NEGATE
    .IS_OPMODE_INVERTED(9'b000000000),// Optional inversion for OPMODE
    .IS_RSTALLCARRYIN_INVERTED(1'b0),// Optional inversion for RSTALLCARRYIN
    .IS_RSTALUMODE_INVERTED(1'b0),// Optional inversion for RSTALUMODE
    .IS_RSTA_INVERTED(1'b0),// Optional inversion for RSTA
    .IS_RSTB_INVERTED(1'b0),// Optional inversion for RSTB
    .IS_RSTCTRL_INVERTED(1'b0),// Optional inversion for STCONJUGATE_A
    .IS_RSTC_INVERTED(1'b0),// Optional inversion for RSTC
    .IS_RSTD_INVERTED(1'b0),// Optional inversion for RSTD
    .IS_RSTINMODE_INVERTED(1'b0),// Optional inversion for RSTINMODE
    .IS_RSTM_INVERTED(1'b0),// Optional inversion for RSTM
    .IS_RSTP_INVERTED(1'b0),// Optional inversion for RSTP
    // Register Control Attributes: Pipeline Register Configuration
    .ACASCREG(1),// Number of pipeline stages between A/ACIN and ACOUT (0-2)
    .ADREG(1),// Pipeline stages for pre-adder (0-1)
    .ALUMODEREG(1),// Pipeline stages for ALUMODE (0-1)
    .AREG(A_REGS),// Pipeline stages for A (0-2)
    .BCASCREG(1),// Number of pipeline stages between B/BCIN and BCOUT (0-2)
    .BREG(B_REGS),// Pipeline stages for B (0-2)
    .CARRYINREG(1),// Pipeline stages for CARRYIN (0-1)
    .CARRYINSELREG(1),// Pipeline stages for CARRYINSEL (0-1)
    .CREG(C_REGS),// Pipeline stages for C (0-1)
    .DREG(1),// Pipeline stages for D (0-1)
    .INMODEREG(1),// Pipeline stages for INMODE (0-1)
    .MREG(M_REGS),// Multiplier pipeline stages (0-1)
    .OPMODEREG(1),// Pipeline stages for OPMODE (0-1)
    .PREG(1),// Number of pipeline stages for P (0-1)
    .RESET_MODE("SYNC")// Selection of synchronous or asynchronous reset. (ASYNC, SYNC).
) DSP58_inst (
    // Cascade outputs: Cascade Ports
    .ACOUT(),// 34-bit output: A port cascade
    .BCOUT(),// 24-bit output: B cascade
    .CARRYCASCOUT(),// 1-bit output: Cascade carry
    .MULTSIGNOUT(),// 1-bit output: Multiplier sign cascade
    .PCOUT(),// 58-bit output: Cascade output
    // Control outputs: Control Inputs/Status Bits
    .OVERFLOW(),// 1-bit output: Overflow in add/acc
    .PATTERNBDETECT(),// 1-bit output: Pattern bar detect
    .PATTERNDETECT(),// 1-bit output: Pattern detect
    .UNDERFLOW(),// 1-bit output: Underflow in add/acc
    // Data outputs: Data Ports
    .CARRYOUT(),// 4-bit output: Carry
    .P(p),// 58-bit output: Primary data
    .XOROUT(),// 8-bit output: XOR data
    // Cascade inputs: Cascade Ports
    .ACIN(34'b0),// 34-bit input: A cascade data
    .BCIN(24'b0),// 24-bit input: B cascade
    .CARRYCASCIN(1'b0),// 1-bit input: Cascade carry
    .MULTSIGNIN(1'b0),// 1-bit input: Multiplier sign cascade
    .PCIN(58'b0),// 58-bit input: P cascade
    // Control inputs: Control Inputs/Status Bits
    .ALUMODE(4'b0),// 4-bit input: ALU control
    .CARRYINSEL(3'b0),// 3-bit input: Carry select
    .CLK(aclk),// 1-bit input: Clock
    .INMODE(5'b0),// 5-bit input: INMODE control
    .NEGATE(3'b000),// 3-bit input: Negates the input of the multiplier
    .OPMODE(opmode),// 9-bit input: Operation mode
    // Data inputs: Data Ports
    .A(a),// 34-bit input: A data
    .B(b),// 24-bit input: B data
    .C(c),// 58-bit input: C data
    .CARRYIN(1'b0),// 1-bit input: Carry-in
    .D(27'b0),// 27-bit input: D data
    // Reset/Clock Enable inputs: Reset/Clock Enable Inputs
    .ASYNC_RST(1'b0),// 1-bit input: Asynchronous reset for all registers.
    .CEA1(1'b1),// 1-bit input: Clock enable for 1st stage AREG
    .CEA2(1'b1),// 1-bit input: Clock enable for 2nd stage AREG
    .CEAD(1'b1),// 1-bit input: Clock enable for ADREG
    .CEALUMODE(1'b1),// 1-bit input: Clock enable for ALUMODE
    .CEB1(1'b1),// 1-bit input: Clock enable for 1st stage BREG
    .CEB2(1'b1),// 1-bit input: Clock enable for 2nd stage BREG
    .CEC(1'b1),// 1-bit input: Clock enable for CREG
    .CECARRYIN(1'b1),// 1-bit input: Clock enable for CARRYINREG
    .CECTRL(1'b1),// 1-bit input: Clock enable for OPMODEREG and CARRYINSELREG
    .CED(1'b1),// 1-bit input: Clock enable for DREG
    .CEINMODE(1'b1),// 1-bit input: Clock enable for INMODEREG
    .CEM(1'b1),// 1-bit input: Clock enable for MREG
    .CEP(1'b1),// 1-bit input: Clock enable for PREG
    .RSTA(1'b0),// 1-bit input: Reset for AREG
    .RSTALLCARRYIN(1'b0),// 1-bit input: Reset for CARRYINREG
    .RSTALUMODE(1'b0),// 1-bit input: Reset for ALUMODEREG
    .RSTB(1'b0),// 1-bit input: Reset for BREG
    .RSTC(1'b0),// 1-bit input: Reset for CREG
    .RSTCTRL(1'b0),// 1-bit input: Reset for OPMODEREG and CARRYINSELREG
    .RSTD(1'b0),// 1-bit input: Reset for DREG and ADREG
    .RSTINMODE(1'b0),// 1-bit input: Reset for INMODE register
    .RSTM(1'b0),// 1-bit input: Reset for MREG
    .RSTP(1'b0)// 1-bit input: Reset for PREG
);

endmodule

module dspfp32_ip#(
    parameter A_REGS = 0,
    parameter AC_REGS = 0,
    parameter B_REGS = 0,
    parameter C_REGS = 0,
    parameter D_REGS = 0,
    parameter M_REGS = 0,
    parameter OP_REGS = 0,
    parameter ACIN = 0,
    parameter BCIN = 0,
    parameter DCOUT = 0,
    parameter PCOUT_FPA = 0
) (
    input logic aclk,
    input logic [31:0] a,
    input logic [31:0] b,
    input logic [31:0] c,
    input logic [31:0] d,
    input logic [31:0] acin,
    input logic [31:0] bcin,
    input logic [31:0] pcin,
    input logic fpinmode,
    input logic [6:0] fpopmode,
    output logic [31:0] fpa_out,
    output logic [31:0] fpm_out,
    output logic [31:0] acout,
    output logic [31:0] bcout,
    output logic [31:0] pcout
);

// DSPFP32: The DSPFP32 consists of a floating-point multiplier and a floating-point adder with separate outputs.
// Versal Prime Series
// Xilinx HDL Language Template, version 2025.1
DSPFP32 #(
    // Feature Control Attributes: Data Path Selection
    .A_FPTYPE("B32"),// B16, B32
    .A_INPUT(ACIN == 1 ? "CASCADE" : "DIRECT"),// Selects A input source, "DIRECT" (A port) or "CASCADE" (ACIN port)
    .B_INPUT(BCIN == 1 ? "CASCADE" : "DIRECT"),// Selects B input source, "DIRECT" (B port) or "CASCADE" (BCIN port)
    .BCASCSEL(DCOUT == 1 ? "D" : "B"),// Selects B cascade out data (B, D).
    .B_D_FPTYPE("B32"),// B16, B32
    .PCOUTSEL(PCOUT_FPA == 1 ? "FPA" : "FPM"),// Select PCOUT output cascade of DSPFP32 (FPA, FPM)
    .USE_MULT(M_REGS != 0 ? "MULTIPLY" : "NONE"),// Select multiplier usage (DYNAMIC, MULTIPLY, NONE)
    // Programmable Inversion Attributes: Specifies built-in programmable inversion on specific pins
    .IS_CLK_INVERTED(1'b0),// Optional inversion for CLK
    .IS_FPINMODE_INVERTED(1'b0),// Optional inversion for FPINMODE
    .IS_FPOPMODE_INVERTED(7'b0000000), // Optional inversion for FPOPMODE
    .IS_RSTA_INVERTED(1'b0),// Optional inversion for RSTA
    .IS_RSTB_INVERTED(1'b0),// Optional inversion for RSTB
    .IS_RSTC_INVERTED(1'b0),// Optional inversion for RSTC
    .IS_RSTD_INVERTED(1'b0),// Optional inversion for RSTD
    .IS_RSTFPA_INVERTED(1'b0),// Optional inversion for RSTFPA
    .IS_RSTFPINMODE_INVERTED(1'b0),// Optional inversion for RSTFPINMODE
    .IS_RSTFPMPIPE_INVERTED(1'b0),// Optional inversion for RSTFPMPIPE
    .IS_RSTFPM_INVERTED(1'b0),// Optional inversion for RSTFPM
    .IS_RSTFPOPMODE_INVERTED(1'b0),// Optional inversion for RSTFPOPMODE
    // Register Control Attributes: Pipeline Register Configuration
    .ACASCREG(AC_REGS),// Number of pipeline stages between A/ACIN and ACOUT (0-2)
    .AREG(A_REGS),// Pipeline stages for A (0-2)
    .FPA_PREG(1),// Pipeline stages for FPA output (0-1)
    .FPBREG(B_REGS),// Pipeline stages for B inputs (0-1)
    .FPCREG(C_REGS),// Pipeline stages for C input (0-3)
    .FPDREG(D_REGS),// Pipeline stages for D inputs (0-1)
    .FPMPIPEREG(M_REGS == 2 ? 1 : 0),// Selects the number of FPMPIPE registers (0-1)
    .FPM_PREG(M_REGS != 0 ? 1 : 0),// Pipeline stages for FPM output (0-1)
    .FPOPMREG(OP_REGS),// Selects the length of the FPOPMODE pipeline (0-3)
    .INMODEREG(M_REGS != 0 ? 1 : 0),// Selects the number of FPINMODE registers (0-1)
    .RESET_MODE("SYNC")// Selection of synchronous or asynchronous reset. (ASYNC, SYNC).
) DSPFP32_inst (
    // Cascade outputs: Cascade Ports
    .ACOUT_EXP(acout[30:23]),// 8-bit output: A exponent cascade data
    .ACOUT_MAN(acout[22:0]),// 23-bit output: A mantissa cascade data
    .ACOUT_SIGN(acout[31]),// 1-bit output: A sign cascade data
    .BCOUT_EXP(bcout[30:23]),// 8-bit output: B exponent cascade data
    .BCOUT_MAN(bcout[22:0]),// 23-bit output: B mantissa cascade data
    .BCOUT_SIGN(bcout[31]),// 1-bit output: B sign cascade data
    .PCOUT(pcout),// 32-bit output: Cascade output
    // Data outputs: Data Ports
    .FPA_INVALID(),// 1-bit output: Invalid flag for FPA output
    .FPA_OUT(fpa_out),// 32-bit output: Adder/accumlator data output in Binary32 format.
    .FPA_OVERFLOW(),// 1-bit output: Overflow signal for adder/accumlator data output
    .FPA_UNDERFLOW(), // 1-bit output: Underflow signal for adder/accumlator data output
    .FPM_INVALID(),// 1-bit output: Invalid flag for FPM output
    .FPM_OUT(fpm_out),// 32-bit output: Multiplier data output in Binary32 format.
    .FPM_OVERFLOW(),// 1-bit output: Overflow signal for multiplier data output
    .FPM_UNDERFLOW(), // 1-bit output: Underflow signal for multiplier data output
    // Cascade inputs: Cascade Ports
    .ACIN_EXP(acin[30:23]),// 8-bit input: A exponent cascade data
    .ACIN_MAN(acin[22:0]),// 23-bit input: A mantissa cascade data
    .ACIN_SIGN(acin[31]),// 1-bit input: A sign cascade data
    .BCIN_EXP(bcin[30:23]),// 8-bit input: B exponent cascade data
    .BCIN_MAN(bcin[22:0]),// 23-bit input: B mantissa cascade data
    .BCIN_SIGN(bcin[31]),// 1-bit input: B sign cascade data
    .PCIN(pcin),// 32-bit input: P cascade
    // Control inputs: Control Inputs/Status Bits
    .CLK(aclk),// 1-bit input: Clock
    .FPINMODE(fpinmode),// 1-bit input: Controls select for B/D input data mux.
    .FPOPMODE(fpopmode),// 7-bit input: Selects input signals to floating-point adder and input negation.
    // Data inputs: Data Ports
    .A_EXP(a[30:23]),// 8-bit input: A data exponent
    .A_MAN(a[22:0]),// 23-bit input: A data mantissa
    .A_SIGN(a[31]),// 1-bit input: A data sign bit
    .B_EXP(b[30:23]),// 8-bit input: B data exponent
    .B_MAN(b[22:0]),// 23-bit input: B data mantissa
    .B_SIGN(b[31]),// 1-bit input: B data sign bit
    .C(c),// 32-bit input: C data input in Binary32 format.
    .D_EXP(d[30:23]),// 8-bit input: D data exponent
    .D_MAN(d[22:0]),// 23-bit input: D data mantissa
    .D_SIGN(d[31]),// 1-bit input: D data sign bit
    // Reset/Clock Enable inputs: Reset/Clock Enable Inputs
    .ASYNC_RST(1'b0),// 1-bit input: Asynchronous reset for all registers.
    .CEA1(1'b1),// 1-bit input: Clock enable for 1st stage AREG
    .CEA2(1'b1),// 1-bit input: Clock enable for 2nd stage AREG
    .CEB(1'b1),// 1-bit input: Clock enable BREG
    .CEC(1'b1),// 1-bit input: Clock enable for CREG
    .CED(1'b1),// 1-bit input: Clock enable for DREG
    .CEFPA(1'b1),// 1-bit input: Clock enable for FPA_PREG
    .CEFPINMODE(1'b1),// 1-bit input: Clock enable for FPINMODE register
    .CEFPM(1'b1),// 1-bit input: Clock enable for FPM output register.
    .CEFPMPIPE(1'b1),// 1-bit input: Clock enable for FPMPIPE post multiplier register.
    .CEFPOPMODE(1'b1),// 1-bit input: Clock enable for FPOPMODE post multiplier register.
    .RSTA(1'b0),// 1-bit input: Reset for AREG
    .RSTB(1'b0),// 1-bit input: Reset for BREG
    .RSTC(1'b0),// 1-bit input: Reset for CREG
    .RSTD(1'b0),// 1-bit input: Reset for DREG
    .RSTFPA(1'b0),// 1-bit input: Reset for FPA output register
    .RSTFPINMODE(1'b0),// 1-bit input: Reset for FPINMODE register
    .RSTFPM(1'b0),// 1-bit input: Reset for FPM output register
    .RSTFPMPIPE(1'b0),// 1-bit input: Reset for FPMPIPE register
    .RSTFPOPMODE(1'b0)// 1-bit input: Reset for FPOPMODE registers
);

endmodule

module primitive_pipeline #(
    parameter integer WIDTH = 32,
    parameter integer DEPTH = 12
) (
    input wire clk,
    input wire[WIDTH-1:0] din,
    output wire[WIDTH-1:0] dout
);
    (* keep = "true" *)
    (* equivalent_register_removal = "no" *)
    (* shreg_extract = "no" *)
    reg[WIDTH-1:0] pipeline_stages[0 : DEPTH-1];

    always_ff @(posedge clk) begin
        pipeline_stages[0] <= din;
        for(int i = 0; i < DEPTH; i++) begin
            pipeline_stages[i+1] <= pipeline_stages[i];
        end
    end

    assign dout = pipeline_stages[DEPTH-1];
endmodule
