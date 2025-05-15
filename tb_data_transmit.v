`timescale 1ns / 100ps

module tb_data_transmit();

reg clk;
reg rst;
reg Data_in;
reg mode_sel;
reg [15:0] fcw = 16'h1999;  // 65536 / 10 ≈ 6553 (0x1999)，载波周期约为100ns
wire [11:0] mod_out;
wire [11:0] sine_c;
wire [11:0] sine_c2;
initial begin
	 clk = 1;
    rst = 1;
	 Data_in = 0;
	 mode_sel = 0;
    #10;
    rst = 0;    
	 Data_in = 1;
	 #600
	 Data_in = 0;
	 #600
	 Data_in = 1;
	 #600
    Data_in = 0;
	 
	 #600
	 mode_sel = 1;
	 Data_in = 1;
	 #600
	 Data_in = 0;
	 #600
	 Data_in = 1;
	 #600
    Data_in = 0;
	 
    #600
	 $finish;
    
end

always #5 clk = ~clk;
data_transmit u_data_transmit(
	 .clk(clk),
	 .rst(rst),
	 .Data_in(Data_in),
	 .mode_sel(mode_sel),
	 .fcw(fcw),
	 .mod_out(mod_out),
	 .sine_c(sine_c)
);

nco u_nco(
		 .clk(clk),                      // 时钟信号
		 .rst(rst),                    // 异步复位（高有效）
		 .fcw(fcw),    // 频率控制字
		 .sine_out(sine_c2)           // 正弦输出（12位幅度值）
	 );
endmodule