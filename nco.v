module nco #(
    parameter PHASE_WIDTH = 16,          // 相位累加器宽度
    parameter ROM_ADDR_WIDTH = 8,        // ROM 地址宽度
    parameter OUTPUT_WIDTH = 12          // 输出值位宽
)(
    input wire clk,                      // 时钟信号
    input wire rst,                    // 异步复位（高有效）
    input wire [PHASE_WIDTH-1:0] fcw,    // 频率控制字
    output reg [OUTPUT_WIDTH-1:0] sine_out           // 正弦输出（12位幅度值）
);
// 输出信号频率f_out = (fcw * f_clk) / 2^N,其中N是输出位宽
    reg [PHASE_WIDTH-1:0] phase_acc;     // 相位累加器
    wire [ROM_ADDR_WIDTH-1:0] rom_addr;

    // 相位累加
    always @(posedge clk or posedge rst) begin
        if (rst)
            phase_acc <= 0;
        else
            phase_acc <= phase_acc + fcw;
    end

    assign rom_addr = phase_acc[PHASE_WIDTH-1 -: ROM_ADDR_WIDTH];

    // 查表得到正弦值
    wire [OUTPUT_WIDTH-1:0] sine_lut_out;
    sine_lut #(
        .ROM_ADDR_WIDTH(ROM_ADDR_WIDTH),
        .OUTPUT_WIDTH(OUTPUT_WIDTH)
    ) sine_table (
        .addr(rom_addr),
        .data(sine_lut_out)
    );

    // 输出
    always @(posedge clk) begin
        sine_out <= sine_lut_out;
    end

endmodule