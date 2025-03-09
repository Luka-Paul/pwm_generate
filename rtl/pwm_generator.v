module  pwm_generator
#(
    parameter       PERIOD      =   30'd10_00000, //PWM 周期计数值，用于控制频率,此时为1000Hz
    parameter       DUTY_1      =   30'd80_0000, //PWM 占空比计数值，用于控制占空比，此时为50%
    parameter       DUTY_2      =   30'd10_0000 
)
(
    input       wire        sys_clk     ,        //系统时钟50Mh
    input       wire        sys_rst_n   ,        //全局复位
    
    input       wire        key_1       ,        //按键按下输出占空比为20的波形,不按下就是50
    
    output      reg         pwm_out             // PWM 输出信号
);

reg      [15:0]    counter;                //计数器
wire               key_flag_1;               //表示占空比的转换
reg       [15:0]          duty;
wire             key_press;

//计数器赋值
always@(posedge sys_clk or negedge sys_rst_n)
    begin
        if(sys_rst_n == 1'b0)
            begin
                counter <= 16'd0    ;
            end
        else if(counter == PERIOD - 1'b1)   
            begin
                counter <= 16'd0    ;
            end
        else
            begin
                counter <= counter + 1'b1   ;
            end
    end

key_filter  key_1_inst
(
    .sys_clk    (sys_clk    ),  //系统时钟50Mhz
    .sys_rst_n  (sys_rst_n  ),  //全局复位
    .key_in     (key_1     ),  //按键输入信号

    .key_flag   (key_flag_1      ),   //key_flag为1时表示按键有效，0表示按键无效
    .key_press (key_press)
);


//赋值duty
always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        duty <= DUTY_1;
    else if(key_flag_1 && key_press)
        duty <= DUTY_2;
    else if(key_flag_1 && !key_press)
        duty <= DUTY_1;


//PWM输出
always@(posedge sys_clk or negedge sys_rst_n)
    begin
        if(sys_rst_n == 1'b0)
            begin
                pwm_out <= 16'd0    ;
            end          
        else if(counter < duty)
            pwm_out <= 1'b1;
        else
            pwm_out <= 1'b0;
    end
    
endmodule