module bpsk_mod#(
    parameter OUTPUT_WIDTH = 12          // 输出值位宽
)(
    input clk,
    input rst,
    input data_bit,             // 1: 正向，0: 反向
	 input [OUTPUT_WIDTH-1:0] sine_c,      		      // 正弦载波
    output reg [OUTPUT_WIDTH-1:0] dac_out
);

    always @(posedge rst or posedge clk) begin
		if(rst)
			dac_out <= 0;
		else
		begin
		  // 用 2's 补码实现反转
		  if (data_bit)
				dac_out <= sine_c;
		  else
				dac_out <= ~sine_c + 1;  // 取反加一，相当于 -sin
		end
    end

endmodule
