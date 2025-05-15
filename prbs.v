module prbs #(
    parameter N = 8
)(
    input clk,
    input rst,
    output reg prbs_bit_out,
	 output reg [N-1:0] prbs_out
);

    reg [N-1:0] lfsr;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            lfsr <= {N{1'b1}};  // 非全0初始值，例如全部为1
            prbs_bit_out <= 0;
        end else begin
            // 假设使用 x^7 + x^6 + 1 作为本源多项式
            lfsr <= {lfsr[N-2:0], lfsr[6] ^ lfsr[5]};
            prbs_bit_out <= lfsr[N-2];  // 输出的是 feedback 前的最高位
				prbs_out <= lfsr;
        end
    end

endmodule
