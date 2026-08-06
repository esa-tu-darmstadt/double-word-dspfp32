// DSPFP32: The DSPFP32 consists of a floating-point multiplier and a floating-point adder with separate outputs.
// Versal Prime Series
// Xilinx HDL Language Template, version 2025.1

module dspfp32_add_ip#(
    parameter D_LATENCY = 0,
    parameter C_LATENCY = 0,
    parameter FPOP_LATENCY = 0
) (
    input logic aclk,
    input logic [31:0] d,
    input logic [31:0] c,
    input logic [31:0] pcin,
    input logic [6:0] fpopmode,
    output logic [31:0] fpa_out,
    output logic [31:0] pcout
);

DSPFP32 #(
    // Feature Control Attributes: Data Path Selection
    .A_FPTYPE("B32"),// B16, B32
    .A_INPUT("DIRECT"),// Selects A input source, "DIRECT" (A port) or "CASCADE" (ACIN port)
    .B_INPUT("DIRECT"),// Selects B input source, "DIRECT" (B port) or "CASCADE" (BCIN port)
    .BCASCSEL("B"),// Selects B cascade out data (B, D).
    .B_D_FPTYPE("B32"),// B16, B32
    .PCOUTSEL("FPA"),// Select PCOUT output cascade of DSPFP32 (FPA, FPM)
    .USE_MULT("NONE"),// Select multiplier usage (DYNAMIC, MULTIPLY, NONE)
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
    .ACASCREG(1),// Number of pipeline stages between A/ACIN and ACOUT (0-2)
    .AREG(1),// Pipeline stages for A (0-2)
    .FPA_PREG(1),// Pipeline stages for FPA output (0-1)
    .FPBREG(1),// Pipeline stages for B inputs (0-1)
    .FPCREG(C_LATENCY),// Pipeline stages for C input (0-3)
    .FPDREG(D_LATENCY),// Pipeline stages for D inputs (0-1)
    .FPMPIPEREG(1),// Selects the number of FPMPIPE registers (0-1)
    .FPM_PREG(1),// Pipeline stages for FPM output (0-1)
    .FPOPMREG(FPOP_LATENCY),// Selects the length of the FPOPMODE pipeline (0-3)
    .INMODEREG(1),// Selects the number of FPINMODE registers (0-1)
    .RESET_MODE("SYNC")// Selection of synchronous or asynchronous reset. (ASYNC, SYNC).
) DSPFP32_inst (
    // Cascade outputs: Cascade Ports
    .ACOUT_EXP(),// 8-bit output: A exponent cascade data
    .ACOUT_MAN(),// 23-bit output: A mantissa cascade data
    .ACOUT_SIGN(),// 1-bit output: A sign cascade data
    .BCOUT_EXP(),// 8-bit output: B exponent cascade data
    .BCOUT_MAN(),// 23-bit output: B mantissa cascade data
    .BCOUT_SIGN(),// 1-bit output: B sign cascade data
    .PCOUT(pcout),// 32-bit output: Cascade output
    // Data outputs: Data Ports
    .FPA_INVALID(),// 1-bit output: Invalid flag for FPA output
    .FPA_OUT(fpa_out),// 32-bit output: Adder/accumlator data output in Binary32 format.
    .FPA_OVERFLOW(),// 1-bit output: Overflow signal for adder/accumlator data output
    .FPA_UNDERFLOW(), // 1-bit output: Underflow signal for adder/accumlator data output
    .FPM_INVALID(),// 1-bit output: Invalid flag for FPM output
    .FPM_OUT(),// 32-bit output: Multiplier data output in Binary32 format.
    .FPM_OVERFLOW(),// 1-bit output: Overflow signal for multiplier data output
    .FPM_UNDERFLOW(), // 1-bit output: Underflow signal for multiplier data output
    // Cascade inputs: Cascade Ports
    .ACIN_EXP(8'b0),// 8-bit input: A exponent cascade data
    .ACIN_MAN(23'b0),// 23-bit input: A mantissa cascade data
    .ACIN_SIGN(1'b0),// 1-bit input: A sign cascade data
    .BCIN_EXP(8'b0),// 8-bit input: B exponent cascade data
    .BCIN_MAN(23'b0),// 23-bit input: B mantissa cascade data
    .BCIN_SIGN(1'b0),// 1-bit input: B sign cascade data
    .PCIN(pcin),// 32-bit input: P cascade
    // Control inputs: Control Inputs/Status Bits
    .CLK(aclk),// 1-bit input: Clock
    .FPINMODE(1'b0),// 1-bit input: Controls select for B/D input data mux.
    .FPOPMODE(fpopmode),// 7-bit input: Selects input signals to floating-point adder and input negation.
    // Data inputs: Data Ports
    .A_EXP(8'b0),// 8-bit input: A data exponent
    .A_MAN(23'b0),// 23-bit input: A data mantissa
    .A_SIGN(1'b0),// 1-bit input: A data sign bit
    .B_EXP(8'b0),// 8-bit input: B data exponent
    .B_MAN(23'b0),// 23-bit input: B data mantissa
    .B_SIGN(1'b0),// 1-bit input: B data sign bit
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

module dspfp32_full_ip#(
    parameter A_REGS = 0,
    parameter B_REGS = 0,
    parameter C_REGS = 0,
    parameter D_REGS = 0,
    parameter M_REGS = 0,
    parameter OP_REGS = 0,
    parameter ACIN = 0,
    parameter BCIN = 0,
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
    input logic [1:0] fpinmode,
    input logic [6:0] fpopmode,
    output logic [31:0] fpa_out,
    output logic [31:0] fpm_out,
    output logic [31:0] acout,
    output logic [31:0] bcout,
    output logic [31:0] pcout
);

DSPFP32 #(
    // Feature Control Attributes: Data Path Selection
    .A_FPTYPE("B32"),// B16, B32
    .A_INPUT(ACIN == 1 ? "CASCADE" : "DIRECT"),// Selects A input source, "DIRECT" (A port) or "CASCADE" (ACIN port)
    .B_INPUT(BCIN == 1 ? "CASCADE" : "DIRECT"),// Selects B input source, "DIRECT" (B port) or "CASCADE" (BCIN port)
    .BCASCSEL("B"),// Selects B cascade out data (B, D).
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
    .ACASCREG(A_REGS),// Number of pipeline stages between A/ACIN and ACOUT (0-2)
    .AREG(A_REGS),// Pipeline stages for A (0-2)
    .FPA_PREG(1),// Pipeline stages for FPA output (0-1)
    .FPBREG(B_REGS),// Pipeline stages for B inputs (0-1)
    .FPCREG(C_REGS),// Pipeline stages for C input (0-3)
    .FPDREG(D_REGS),// Pipeline stages for D inputs (0-1)
    .FPMPIPEREG(1),// Selects the number of FPMPIPE registers (0-1)
    .FPM_PREG(1),// Pipeline stages for FPM output (0-1)
    .FPOPMREG(OP_REGS),// Selects the length of the FPOPMODE pipeline (0-3)
    .INMODEREG(1),// Selects the number of FPINMODE registers (0-1)
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
    .FPINMODE(1'b1),// 1-bit input: Controls select for B/D input data mux.
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

module dspfp32_mul_add_ip#(
    parameter A_REGS = 0,
    parameter B_REGS = 0,
    parameter C_REGS = 0,
    parameter D_REGS = 0,
    parameter M_REGS = 0,
    parameter OP_REGS = 0,
    parameter ACIN = 0,
    parameter BCIN = 0,
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
    input logic [1:0] fpinmode,
    input logic [6:0] fpopmode,
    output logic [31:0] fpa_out,
    output logic [31:0] fpm_out,
    output logic [31:0] acout,
    output logic [31:0] bcout,
    output logic [31:0] pcout
);

DSPFP32 #(
    // Feature Control Attributes: Data Path Selection
    .A_FPTYPE("B32"),// B16, B32
    .A_INPUT(ACIN == 1 ? "CASCADE" : "DIRECT"),// Selects A input source, "DIRECT" (A port) or "CASCADE" (ACIN port)
    .B_INPUT(BCIN == 1 ? "CASCADE" : "DIRECT"),// Selects B input source, "DIRECT" (B port) or "CASCADE" (BCIN port)
    .BCASCSEL("B"),// Selects B cascade out data (B, D).
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
    .ACASCREG(A_REGS),// Number of pipeline stages between A/ACIN and ACOUT (0-2)
    .AREG(A_REGS),// Pipeline stages for A (0-2)
    .FPA_PREG(1),// Pipeline stages for FPA output (0-1)
    .FPBREG(B_REGS),// Pipeline stages for B inputs (0-1)
    .FPCREG(C_REGS),// Pipeline stages for C input (0-3)
    .FPDREG(D_REGS),// Pipeline stages for D inputs (0-1)
    .FPMPIPEREG(1),// Selects the number of FPMPIPE registers (0-1)
    .FPM_PREG(1),// Pipeline stages for FPM output (0-1)
    .FPOPMREG(OP_REGS),// Selects the length of the FPOPMODE pipeline (0-3)
    .INMODEREG(1),// Selects the number of FPINMODE registers (0-1)
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
    .FPINMODE(1'b1),// 1-bit input: Controls select for B/D input data mux.
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