module demodulator #(
    parameter OUTPUT_WIDTH = 12,
    parameter ACC_WIDTH = 2 * OUTPUT_WIDTH + 4  // 累加器位宽
)(
    input clk,
    input rst,
    input mode_sel, // 0: BPSK, 1: ASK
    input signed [OUTPUT_WIDTH-1:0] recv_sig,  // 接收到的调制信号
    input [OUTPUT_WIDTH-1:0] sine_c,           // 本地产生的正弦波，用于解调
    output reg data_out                        // 解调后的数据位
);

    wire signed [2*OUTPUT_WIDTH-1:0] mult_result;
    reg signed [ACC_WIDTH-1:0] acc;

    // 将 sine_c 转为 signed 类型
    wire signed [OUTPUT_WIDTH-1:0] sine_signed = sine_c;

    // 相干乘法
    assign mult_result = recv_sig * sine_signed;

    // 简单积分器，用于平均多个采样（可以简化为低通滤波）
    always @(posedge clk or posedge rst) begin
        if (rst)
            acc <= 0;
        else
            acc <= acc + mult_result;
    end

    // 简单的周期判决（实际系统中应使用时钟恢复同步位）
    reg [7:0] sample_count;
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            sample_count <= 0;
            data_out <= 0;
        end else begin
            sample_count <= sample_count + 1;
            if (sample_count == 8'd255) begin // 假设每256周期判决1位
                sample_count <= 0;
                if (mode_sel == 1'b0) begin
                    // BPSK: 判断符号
                    data_out <= (acc >= 0) ? 1'b1 : 1'b0;
                end else begin
                    // ASK: 判断幅度
                    data_out <= (acc >= (1 << (ACC_WIDTH-2))) ? 1'b1 : 1'b0;
                end
                acc <= 0; // 清空积分器
            end
        end
    end

endmodule
