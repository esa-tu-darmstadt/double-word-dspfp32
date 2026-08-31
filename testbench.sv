`timescale 1ns/1ps

module testbench_top(
);

logic clk;
logic [31:0] test_data [0:1024*20-1];
logic [31:0] vals [0:19];
logic [7:0] valids;

initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

initial begin
    $readmemh("test_data.hex", test_data);
    for (int j = 0; j < 20; j += 1) begin
        vals[j] = 0;
    end
    repeat (32) @(posedge clk);
    for (int i = 0; i < $size(test_data); i += 20) begin
        for (int j = 0; j < 20; j += 1) begin
            vals[j] = test_data[i+j];
        end
        repeat (1) @(posedge clk);
    end
    repeat (32) @(posedge clk);
    $finish;
end

testbench inst (
    .clk(clk),
    .vals(vals),
    .valids(valids)
);

endmodule
