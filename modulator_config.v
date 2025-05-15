module modulator_config #(
	 parameter PHASE_WIDTH = 16,          // 相位累加器宽度
    parameter ROM_ADDR_WIDTH = 8,        // ROM 地址宽度
    parameter OUTPUT_WIDTH = 12          // 输出值位宽
)(
    input mode_sel,  // 0: BPSK, 1: ASK
    input clk, rst,
    input data_in,
	 input [PHASE_WIDTH-1:0] freq_word,
	 input [OUTPUT_WIDTH-1:0] sine_c,
    output wire [OUTPUT_WIDTH:0] mod_out
);
/*
功能：允许选择不同调制方式（如BPSK、ASK、FSK）；

实现：通过控制信号选择不同调制模块路径；

输入：原始数据、伪随机码；

输出：调制信号。
*/

	 
	 
	 
    wire [OUTPUT_WIDTH:0] bpsk_out;
    bpsk_mod #(.OUTPUT_WIDTH(OUTPUT_WIDTH)
	 )bpsk(
		 .clk(clk), 
		 .rst(rst), 
		 .sine_c(sine_c),
		 .data_bit(data_in), 
		 .dac_out(bpsk_out)
	 );
	 
	 wire [OUTPUT_WIDTH:0] ask_out;
	 ask_mod  ask (
		 .clk(clk), 
		 .rst(rst), 
		 .sine_c(sine_c),
		 .data_bit(data_in), 
		 .dac_out(ask_out)
	 );
    


    assign mod_out = (mode_sel == 1'b0) ? bpsk_out :ask_out;
	 
endmodule
