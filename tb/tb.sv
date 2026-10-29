`timescale 1ns/1ps

module tb;
    logic [3:0] a, b;
    logic sel;
    logic [1:0] op;

    logic [3:0] mux_y, alu_y;
    logic eq, lt, gt;

    logic clk, rst, en;
    logic [3:0] d, q;

    integer i, j, k;
    integer checks, failures;
    logic [3:0] expected;
    logic expected_bit;

    mux4 u_mux (
        .a(a), .b(b), .sel(sel), .y(mux_y)
    );

    alu4 u_alu (
        .a(a), .b(b), .op(op), .y(alu_y)
    );

    comparator4 u_cmp (
        .a(a), .b(b), .eq(eq), .lt(lt), .gt(gt)
    );

    register4 u_reg (
        .clk(clk), .rst(rst), .en(en), .d(d), .q(q)
    );

    always #5 clk = ~clk;

    initial begin
        checks  = 0;
        failures = 0;
        clk = 0;
        rst = 0;
        en = 0;
        d = 0;
        a = 0;
        b = 0;
        sel = 0;
        op = 0;

        // Exhaustively test the multiplexer and ALU.
        for (i = 0; i < 16; i = i + 1) begin
            for (j = 0; j < 16; j = j + 1) begin
                a = i;
                b = j;

                for (k = 0; k < 2; k = k + 1) begin
                    sel = k;
                    #1;
                    expected = k ? j : i;
                    checks = checks + 1;
                    if (mux_y !== expected) begin
                        failures = failures + 1;
                        $display("MUX FAIL: a=%h b=%h sel=%b got=%h expected=%h",
                                 a, b, sel, mux_y, expected);
                    end
                end

                for (k = 0; k < 4; k = k + 1) begin
                    op = k;
                    #1;
                    case (k)
                        0: expected = (i + j) & 15;
                        1: expected = (i - j) & 15;
                        2: expected = i & j;
                        3: expected = i | j;
                    endcase
                    checks = checks + 1;
                    if (alu_y !== expected) begin
                        failures = failures + 1;
                        $display("ALU FAIL: a=%h b=%h op=%b got=%h expected=%h",
                                 a, b, op, alu_y, expected);
                    end
                end

                // Check all three comparator outputs independently.
                #1;
                expected_bit = (i == j);
                checks = checks + 1;
                if (eq !== expected_bit) begin
                    failures = failures + 1;
                    $display("CMP EQ FAIL: a=%h b=%h", a, b);
                end

                expected_bit = (i < j);
                checks = checks + 1;
                if (lt !== expected_bit) begin
                    failures = failures + 1;
                    $display("CMP LT FAIL: a=%h b=%h", a, b);
                end

                expected_bit = (i > j);
                checks = checks + 1;
                if (gt !== expected_bit) begin
                    failures = failures + 1;
                    $display("CMP GT FAIL: a=%h b=%h", a, b);
                end
            end
        end

        // Test synchronous reset, enabled write, and hold behavior.
        rst = 1;
        en = 0;
        @(posedge clk);
        #1;
        checks = checks + 1;
        if (q !== 4'h0) begin
            failures = failures + 1;
            $display("REGISTER RESET FAIL: got=%h", q);
        end

        rst = 0;
        en = 1;
        d = 4'hA;
        @(posedge clk);
        #1;
        checks = checks + 1;
        if (q !== 4'hA) begin
            failures = failures + 1;
            $display("REGISTER WRITE FAIL: got=%h", q);
        end

        en = 0;
        d = 4'h5;
        @(posedge clk);
        #1;
        checks = checks + 1;
        if (q !== 4'hA) begin
            failures = failures + 1;
            $display("REGISTER HOLD FAIL: got=%h", q);
        end

        $display("");
        $display("RTL Verification Lab Results");
        $display("----------------------------");
        $display("Total checks: %0d", checks);
        $display("Failures:     %0d", failures);

        if (failures == 0)
            $display("RESULT: PASS");
        else
            $display("RESULT: FAIL");

        $finish;
    end
endmodule
