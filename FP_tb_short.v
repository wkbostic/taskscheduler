
`timescale  1ns / 1ps

module FP_tb_short;

reg rst;
reg clk, rw;
reg [7:0] addr;
reg [3:0] ctrl;
reg [119:0] data15;
reg [7:0] memory [0:255];
reg CMD_RCVD;
wire [119:0] answer;
integer i;

// wires between modules
wire mode; //0 for read, 1 for write

wire AWREADY;
wire WREADY;
wire BVALID;
wire BRESP;

wire WLAST;
wire RLAST;
wire ARREADY;
wire RVALID;
wire [7:0] RDATA;

wire AWVALID;
wire WVALID;
wire BREADY;
wire [11:0] AWADDR; //storing 12-bit values, depth of 16
wire [11:0] ARADDR;
wire [7:0] WDATA;

wire ARVALID;
wire RREADY;

wire [3:0] state;

localparam CLK_PERIOD = 20;

master m(.CMD_RCVD(CMD_RCVD), .clk(clk), .a_rst(rst), .addr(addr), .ctrl(ctrl), .data15(data15), .rw(rw), .mode(mode), 
    .AWREADY(AWREADY), .WREADY(WREADY), .BVALID(BVALID), .BRESP(BRESP), .ARREADY(ARREADY), .RVALID(RVALID), .RDATA(RDATA), 
    .AWVALID(AWVALID), .WVALID(WVALID), .BREADY(BREADY), .AWADDR(AWADDR), .ARADDR(ARADDR), .WDATA(WDATA), .ARVALID(ARVALID), 
    .RREADY(RREADY), .answer(answer),  .WLAST(WLAST), .RLAST(RLAST), .state(state));
slave s(.clk(clk), .a_rst(rst), .mode(mode), .AWVALID(AWVALID), .WVALID(WVALID), .BREADY(BREADY), .AWADDR(AWADDR), .ARADDR(ARADDR),
    .WDATA(WDATA), .ARVALID(ARVALID), .RREADY(RREADY), .AWREADY(AWREADY), .WREADY(WREADY), .BVALID(BVALID), .BRESP(BRESP), 
    .ARREADY(ARREADY), .RVALID(RVALID), .RDATA(RDATA), .WLAST(WLAST), .RLAST(RLAST));

initial begin : CLK_GENERATOR
    clk = 0;
    forever begin
        #(CLK_PERIOD / 2) clk = ~clk;
    end
end

initial begin
    rst = 1;
    #(2 * CLK_PERIOD) rst = 0;
    for (i = 0; i < 256; i = i + 1) begin
        memory[i] = 0;
    end

    #(2 * CLK_PERIOD)
    CMD_RCVD = 1;
    rw = 1;
    addr = 118;
    ctrl = 12;
    data15 = 120'b000000000000000000000000100110101100101101101111110000100111111110010100011011100011010011101010000011111110011101111101;
    #(5*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[(i*8) +: 7];
        end
    end
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 119;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[119])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[119]);
        $display("answer given: %d",answer);
        end

    CMD_RCVD = 1;
    rw = 1;
    addr = 254;
    ctrl = 1;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011010001;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[(i*8) +: 7];
        end
    end
        
    CMD_RCVD = 1;
    rw = 0;
    addr = 254;
    ctrl = 8;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == {112'b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000,memory[255],memory[254]})begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",{112'b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000,memory[255],memory[254]});
        $display("answer given: %d",answer);
        end
        
        
end


endmodule
