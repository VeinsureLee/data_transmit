module ask_mod#(
    parameter OUTPUT_WIDTH = 12          // 输出值位宽
)(
    input clk,
    input rst,
    input data_bit,             				// 1: 正向，0: 反向
	 input [OUTPUT_WIDTH-1:0] sine_c,      		      // 正弦载波
    output reg [OUTPUT_WIDTH-1:0] dac_out
);

    always @(posedge rst or posedge clk) begin
		if(rst)
			dac_out <=0;
		else
		begin
			  if (data_bit)
					dac_out <= sine_c;
			  else
					dac_out <= 0;
		end
    end

	 
endmodule
