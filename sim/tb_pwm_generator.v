`timescale  1ns/1ns

module  tb_pwm_generator();

    reg     sys_clk     ;
    reg     sys_rst_n   ;
    
    reg     key_1       ;
    wire    pwm_out;
    
pwm_generator 
#(
    .PERIOD (20'd50),
    .DUTY_1 (20'd25),
    .DUTY_2 (20'd10)
)
pwm_generator_inst
(   
    .sys_clk   (sys_clk)  ,        //系统时钟50Mh
    .sys_rst_n (sys_rst_n)  ,        //全局复位
    .key_1(key_1),

    .pwm_out   (pwm_out)          // PWM 输出信号
);    

initial begin
    sys_clk    = 1'b1;
    sys_rst_n <= 1'b0;
    key_1     <= 1'b1;
    #20
    sys_rst_n <= 1'b1;  
    #1000
    key_1     <= 1'b0;
    #20000000
    key_1     <= 1'b1;
    #10000000
    key_1     <= 1'b0;
    #20000000
    key_1     <= 1'b1;
    #10000000
    $stop;
    
    
  
end

//sys_clk:模拟系统时钟，每10ns电平翻转一次，周期为20ns，频率为50Mhz
always #10 sys_clk = ~sys_clk;

endmodule