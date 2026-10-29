// RTL Verification Lab
// Educational 4-bit combinational and sequential modules.

module mux4 (
    input  logic [3:0] a,
    input  logic [3:0] b,
    input  logic       sel,
    output logic [3:0] y
);
    always_comb begin
        y = sel ? b : a;
    end
endmodule

module alu4 (
    input  logic [3:0] a,
    input  logic [3:0] b,
    input  logic [1:0] op,
    output logic [3:0] y
);
    always_comb begin
        case (op)
            2'b00: y = a + b;
            2'b01: y = a - b;
            2'b10: y = a & b;
            2'b11: y = a | b;
            default: y = 4'b0000;
        endcase
    end
endmodule

module comparator4 (
    input  logic [3:0] a,
    input  logic [3:0] b,
    output logic       eq,
    output logic       lt,
    output logic       gt
);
    always_comb begin
        eq = (a == b);
        lt = (a < b);
        gt = (a > b);
    end
endmodule

module register4 (
    input  logic       clk,
    input  logic       rst,
    input  logic       en,
    input  logic [3:0] d,
    output logic [3:0] q
);
    always_ff @(posedge clk) begin
        if (rst)
            q <= 4'b0000;
        else if (en)
            q <= d;
    end
endmodule
