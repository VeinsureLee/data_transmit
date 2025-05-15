module data_transmit #(
	 parameter OUTPUT_WIDTH = 12
)(
    input clk,
    input rst,
	 input Data_in,
	 input mode_sel,
	 input [15:0] fcw,
	 output [11:0] mod_out,
	 output [OUTPUT_WIDTH-1:0] sine_c
);

//	parameter N_prbs = 8;
//	wire prbs_out;
//	wire [N_prbs-1:0] prbs;
//	prbs #(.N(N_prbs)) u_prbs(
//		 .clk(clk),
//		 .rst(rst),
//		 .prbs_out(prbs),
//		 .prbs_bit_out(prbs_out)
//	);
//	
//	wire data_code;
//	data_code u_data_code(
//		.data_in(Data_in),   // 输入数据
//		.prbs_in(prbs_out),   // 输入的 PRBS 序列
//		.data_out(data_code)   // 异或后的输出
//	);
	 nco #(
		 .OUTPUT_WIDTH(OUTPUT_WIDTH)          // 输出值位宽
	 ) u_nco(
		 .clk(clk),                      // 时钟信号
		 .rst(rst),                    // 异步复位（高有效）
		 .fcw(fcw),    // 频率控制字
		 .sine_out(sine_c)           // 正弦输出（12位幅度值）
	 );
	
	modulator_config u_mod_config(
		.mode_sel(mode_sel),
		.clk(clk),
		.rst(rst),
		.data_in(Data_in),
		.freq_word(fcw),
		.mod_out(mod_out),
		.sine_c(sine_c)
		
	);
	
	
endmodule
