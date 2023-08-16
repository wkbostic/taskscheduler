
`timescale  1ns / 1ps

module FP_tb;

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
wire [3:0] state2;

localparam CLK_PERIOD = 20;

master m(.CMD_RCVD(CMD_RCVD), .clk(clk), .a_rst(rst), .addr(addr), .ctrl(ctrl), .data15(data15), .rw(rw), .mode(mode), 
    .AWREADY(AWREADY), .WREADY(WREADY), .BVALID(BVALID), .BRESP(BRESP), .ARREADY(ARREADY), .RVALID(RVALID), .RDATA(RDATA), 
    .AWVALID(AWVALID), .WVALID(WVALID), .BREADY(BREADY), .AWADDR(AWADDR), .ARADDR(ARADDR), .WDATA(WDATA), .ARVALID(ARVALID), 
    .RREADY(RREADY), .answer(answer),  .WLAST(WLAST), .RLAST(RLAST), .state(state));
slave s(.clk(clk), .a_rst(rst), .mode(mode), .AWVALID(AWVALID), .WVALID(WVALID), .BREADY(BREADY), .AWADDR(AWADDR), .ARADDR(ARADDR),
    .WDATA(WDATA), .ARVALID(ARVALID), .RREADY(RREADY), .AWREADY(AWREADY), .WREADY(WREADY), .BVALID(BVALID), .BRESP(BRESP), 
    .ARREADY(ARREADY), .RVALID(RVALID), .RDATA(RDATA), .WLAST(WLAST), .RLAST(RLAST), .state(state2));

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


    #(5 * CLK_PERIOD)

    CMD_RCVD = 1;
    rw = 1;
    addr = 83;
    ctrl = 2;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001101101001111000;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end


    CMD_RCVD = 1;
    rw = 0;
    addr = 83;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[83])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[83]);
        $display("answer given: %d",answer);
        end
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 209;
    ctrl = 14;
    data15 = 120'b000000001111010100100011100111010010110000110011010101111010111110010011010110111000000110000111001010000001110001001000;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 110;
    ctrl = 13;
    data15 = 120'b000000000000000011110010011000111011000011101111100100001111110100100100010100011010101101111100100111011101110011100100;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 133;
    ctrl = 6;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000111000111011011111000011001001001101111011100;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 105;
    ctrl = 4;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == {96'b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000,memory[105],memory[106],memory[107],memory[108]})begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",{memory[105],memory[106],memory[107],memory[108]});
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 117;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[117])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[117]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 29;
    ctrl = 8;
    data15 = 120'b000000000000000000000000000000000000000000000000000000001010011110100111000100101100011110010010011011111001001000110011;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 74;
    ctrl = 10;
    data15 = 120'b000000000000000000000000000000000000000010001001101101011100011010011011000011010110100101100101100000011101110110001100;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 26;
    ctrl = 5;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000001001011010101011010001111000110010000010;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 31;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[31])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[31]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 151;
    ctrl = 7;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000011000101010010100100010010011011111011111000000010001011;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 150;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[150])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[150]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 177;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[177])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[177]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 249;
    ctrl = 7;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000101100000111111010000111110100100011010100000011011101;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 158;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[158])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[158]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 244;
    ctrl = 9;
    data15 = 120'b000000000000000000000000000000000000000000000000111001101010111111011111101110110011111011011101011010000011010110101011;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 247;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[247])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[247]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 186;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[186])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[186]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 62;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[62])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[62]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 208;
    ctrl = 11;
    data15 = 120'b000000000000000000000000000000001011001010111010000101111110000000000101111100111010011100111010011010000000100000000001;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 37;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[37])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[37]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 48;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[48])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[48]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 74;
    ctrl = 3;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010001100000010100010010;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 158;
    ctrl = 3;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000111000111101111001000111;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 80;
    ctrl = 9;
    data15 = 120'b000000000000000000000000000000000000000000000000010101011101100001011011000110010000110000100011001001110100110011010101;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 13;
    ctrl = 5;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000001000110000010101011011101010101101101101;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 68;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[68])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[68]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 165;
    ctrl = 15;
    data15 = 120'b000000000111001101101011010001000001000010110011000000011100001010111111101101010000101101010100110011010000000110101000;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 61;
    ctrl = 8;
    data15 = 120'b000000000000000000000000000000000000000000000000000000001100111011111000100011011111111010000110111101000010111111001010;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 213;
    ctrl = 5;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000000110111011100010110101100001010110101010;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 212;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[212])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[212]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 44;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[44])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[44]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 169;
    ctrl = 1;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001001110;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 109;
    ctrl = 5;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000001010001001101001111110000011001010100101;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 129;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[129])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[129]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 73;
    ctrl = 4;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010111110010010110101110010111000;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 3;
    ctrl = 7;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000001011111010110100010100110111001110101001011110101110001;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 173;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[173])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[173]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 21;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[21])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[21]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 56;
    ctrl = 5;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000001101001001100100001110100001000010011101;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 24;
    ctrl = 3;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000110100011011100111000;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 241;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[241])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[241]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 173;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[173])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[173]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 169;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[169])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[169]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 48;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[48])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[48]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 69;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[69])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[69]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 180;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[180])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[180]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 111;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[111])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[111]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 68;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[68])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[68]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 239;
    ctrl = 11;
    data15 = 120'b000000000000000000000000000000000101001011101000000110001000111001001011111110110100010000011110110000001110010001111001;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 100;
    ctrl = 12;
    data15 = 120'b000000000000000000000000110110001000100010100110010010101101100110100000111101011111111111110101001100111010001100011100;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 154;
    ctrl = 13;
    data15 = 120'b000000000000000011111000101000010000110001100101110010101001100000010010100111110111101101110010100111100011101001101101;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 35;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[35])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[35]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 122;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[122])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[122]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 11;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[11])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[11]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 63;
    ctrl = 11;
    data15 = 120'b000000000000000000000000000000000000100011110100001010010101001111100100111000111000000000001001001110100011001001110010;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 124;
    ctrl = 3;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010010101101110011111010;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 225;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[225])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[225]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 133;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[133])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[133]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 111;
    ctrl = 7;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000011111001100000100001000011011010010100001110111010101000;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 16;
    ctrl = 7;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000011011101010101110100101101010001011100110100100010011101;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 145;
    ctrl = 12;
    data15 = 120'b000000000000000000000000000000010110011110010101000000000001100110011011000000101010010101110001101010000011100111100011;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 239;
    ctrl = 9;
    data15 = 120'b000000000000000000000000000000000000000000000000000111011100011010000110010010010001110000100111101000000010101000010000;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 114;
    ctrl = 15;
    data15 = 120'b110000101001100010011001000100101010101101101111101001001111111100111111001101101101001011111111001001111011100001001000;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 163;
    ctrl = 14;
    data15 = 120'b000000000001101010100100011110101011110111011111011011111001111100110010000000010100100001011010111000010011100010100111;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 49;
    ctrl = 1;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000101110;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 101;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[101])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[101]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 215;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[215])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[215]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 203;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[203])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[203]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 140;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[140])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[140]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 126;
    ctrl = 1;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100110;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 212;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[212])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[212]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 128;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[128])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[128]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 255;
    ctrl = 4;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001111110000001010001000110100001;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 92;
    ctrl = 9;
    data15 = 120'b000000000000000000000000000000000000000000000000001011011110000010000110011111000110101111010000010101010011011011101110;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 25;
    ctrl = 9;
    data15 = 120'b000000000000000000000000000000000000000000000000001001010011001010110110111001100110001000010001000000110000001000101001;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 32;
    ctrl = 15;
    data15 = 120'b011010100001010100000110101110110010000010111110011011011001001001110000110111000001010001011010000011110110111100110111;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 199;
    ctrl = 6;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000101100100110101011001100111101000101011111011010;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 114;
    ctrl = 1;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 236;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[236])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[236]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 225;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[225])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[225]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 231;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[231])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[231]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 163;
    ctrl = 9;
    data15 = 120'b000000000000000000000000000000000000000000000000000001011110111110011110110100011100100001010010011011100001010100100010;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 141;
    ctrl = 8;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000101010101101000001110001011101011101110000011011111010101101000;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 96;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[96])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[96]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 50;
    ctrl = 8;
    data15 = 120'b000000000000000000000000000000000000000000000000000000001010101011010011110111111111001010011010111011010111001100001100;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 193;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[193])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[193]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 15;
    ctrl = 1;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011001101;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 90;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[90])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[90]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 28;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[28])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[28]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 40;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[40])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[40]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 33;
    ctrl = 8;
    data15 = 120'b000000000000000000000000000000000000000000000000000000001110110111110001011100001001011110001101001001111101010110011110;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 142;
    ctrl = 14;
    data15 = 120'b000000000010100101111111011001101100110100011100011111100001101110010101101110110101010101000011101011000001110011100111;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 252;
    ctrl = 11;
    data15 = 120'b000000000000000000000000000000000001001011111110100000101011000100011000001110111011010011011110100111011100100101001111;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 147;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[147])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[147]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 55;
    ctrl = 11;
    data15 = 120'b000000000000000000000000000000001100101001111110000100011000011101100000111111001000101001011111011111001111111100110111;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 104;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[104])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[104]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 85;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[85])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[85]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 130;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[130])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[130]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 137;
    ctrl = 11;
    data15 = 120'b000000000000000000000000000000000100110100010110101100011001000111001011001001000110100110110010101110010011000010110010;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 195;
    ctrl = 10;
    data15 = 120'b000000000000000000000000000000000000000000011011010001101110001000000111100100010001101100100000001000001111100101010000;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 91;
    ctrl = 3;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000110110110100110100110110;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 168;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[168])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[168]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 201;
    ctrl = 10;
    data15 = 120'b000000000000000000000000000000000000000000000110000101110001100101111000101111100110010111110100000001010111100111111110;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 9;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[9])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[9]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 47;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[47])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[47]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 167;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[167])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[167]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 155;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[155])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[155]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 188;
    ctrl = 13;
    data15 = 120'b000000000000000001000011011000001101111010010001110010010010100000111111001101101101110011001110011001010110111110111000;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 157;
    ctrl = 14;
    data15 = 120'b000000001010100100100001010010010000100100100001010100001100101110000011111111010011100101100101000000101011000000100000;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 91;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[91])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[91]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 18;
    ctrl = 2;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011100001110011;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 210;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[210])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[210]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 135;
    ctrl = 10;
    data15 = 120'b000000000000000000000000000000000000000000110110100110010010111011001011001101001000110000101100000000111001110010110001;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 31;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[31])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[31]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 203;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[203])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[203]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 61;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[61])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[61]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 232;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[232])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[232]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 215;
    ctrl = 15;
    data15 = 120'b011110011001101011010011101001101110101111001001111011100000110000010011001111110100110110011011001000110000000110011000;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 146;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[146])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[146]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 234;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[234])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[234]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 197;
    ctrl = 3;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100101000100101001001101;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 44;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[44])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[44]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 96;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[96])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[96]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 20;
    ctrl = 12;
    data15 = 120'b000000000000000000000000100001100000110011011100100111101000010111110101101011110100110110011010100000110000110110110000;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 54;
    ctrl = 11;
    data15 = 120'b000000000000000000000000000000000010000101001110010011011010110011001100100010111001001110111110000010100111001110110101;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 254;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[254])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[254]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 138;
    ctrl = 3;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100001011000110001011111;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 88;
    ctrl = 2;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001101100110010101;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 120;
    ctrl = 13;
    data15 = 120'b000000000000000010010100111011010000100111111001010000100100000010011100010111010111101111010011111110101100100101100010;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 113;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[113])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[113]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 247;
    ctrl = 10;
    data15 = 120'b000000000000000000000000000000000000000010000111010000000111100111100001100100011110100111010100101010110010101111010010;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 152;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[152])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[152]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 115;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[115])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[115]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 111;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[111])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[111]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 162;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[162])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[162]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 130;
    ctrl = 5;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000001001001010111111010101101100100001011001;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 99;
    ctrl = 8;
    data15 = 120'b000000000000000000000000000000000000000000000000000000001110100011010000100011100011011100101101110101010010100001001001;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 195;
    ctrl = 11;
    data15 = 120'b000000000000000000000000000000000000000101100101011110100011000100000000000011101000110000111101100011001010100000111101;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 91;
    ctrl = 9;
    data15 = 120'b000000000000000000000000000000000000000000000000111110101001000100101101100010011010010010010110001011010011111011101010;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 38;
    ctrl = 14;
    data15 = 120'b000000001101111000111110110011010000101000101101000100111110101001110000111110010001101101111010111101011100010011011010;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 58;
    ctrl = 4;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011001111101110011000011000000101;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 231;
    ctrl = 10;
    data15 = 120'b000000000000000000000000000000000000000000001101010010110011000110011101011000010110000010011011010110111010111110011001;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 27;
    ctrl = 15;
    data15 = 120'b010101110100101101110111001001000001000101001001111010010000111011101100010100000011001101100111100110111011101101100011;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 131;
    ctrl = 11;
    data15 = 120'b000000000000000000000000000000001000011111010110110100111010000010001110000110110110110110111000010101010110011000010101;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 225;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[225])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[225]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 227;
    ctrl = 3;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010011110000111011110110;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 225;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[225])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[225]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 130;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[130])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[130]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 124;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[124])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[124]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 173;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[173])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[173]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 176;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[176])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[176]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 15;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[15])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[15]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 98;
    ctrl = 8;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000001001110011111010111111010010011010100011100111001000000010;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 20;
    ctrl = 13;
    data15 = 120'b000000000000000000010110111101110001000000110101100010110101010101111111110101101010001001110010010101001100101010000100;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 20;
    ctrl = 2;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000101011000000101;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 123;
    ctrl = 8;
    data15 = 120'b000000000000000000000000000000000000000000000000000000001011110101111101111000010000001111011100011110010111001101000101;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 240;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[240])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[240]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 18;
    ctrl = 10;
    data15 = 120'b000000000000000000000000000000000000000001011101001101101011011001000000111111100000011100101001010001101100001011010011;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 34;
    ctrl = 8;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000100010011110000110101001110001110100110100110000000100000000101;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 180;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[180])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[180]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 37;
    ctrl = 7;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000010001110101111101001111110110101100011111100100000011011;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 57;
    ctrl = 12;
    data15 = 120'b000000000000000000000000100110100001000101001010000111100110111011100110110110111011101010111010110001110000001010111011;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 194;
    ctrl = 6;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000011111100000111110101100101011011011011111010011;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 150;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[150])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[150]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 148;
    ctrl = 10;
    data15 = 120'b000000000000000000000000000000000000000010110110100011011011010010011011101110111100001000000001011010000110101111000111;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 28;
    ctrl = 4;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000111010101101110001001110011110;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 18;
    ctrl = 6;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000010001001100110111100100000010110001011101101011;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 233;
    ctrl = 1;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001101100;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 92;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[92])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[92]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 22;
    ctrl = 3;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010011111000010100000;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 59;
    ctrl = 4;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011111000110100011010101101010001;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 41;
    ctrl = 8;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000001110110110010101011000011100010011010010011110010110100001011;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 65;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[65])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[65]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 40;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[40])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[40]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 117;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[117])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[117]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 197;
    ctrl = 9;
    data15 = 120'b000000000000000000000000000000000000000000000000100100001111001100011011100011011101001011000001010111001101100011110101;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 159;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[159])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[159]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 116;
    ctrl = 1;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011001101;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 58;
    ctrl = 4;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001010010001101001100100011011011;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 21;
    ctrl = 6;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000111001100100101001100000000110001011011111011110;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 160;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[160])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[160]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 249;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[249])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[249]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 163;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[163])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[163]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 227;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[227])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[227]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 21;
    ctrl = 1;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000111101;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 151;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[151])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[151]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 186;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[186])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[186]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 209;
    ctrl = 1;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000110000;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 183;
    ctrl = 2;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001010101110111001;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 79;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[79])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[79]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 21;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[21])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[21]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 58;
    ctrl = 13;
    data15 = 120'b000000000000000001011100001010100111010000000110000101011111001101001000010011001100001101100101101000011000111100001101;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 84;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[84])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[84]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 190;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[190])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[190]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 60;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[60])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[60]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 47;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[47])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[47]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 243;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[243])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[243]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 17;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[17])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[17]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 209;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[209])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[209]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 142;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[142])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[142]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 130;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[130])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[130]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 59;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[59])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[59]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 151;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[151])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[151]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 210;
    ctrl = 9;
    data15 = 120'b000000000000000000000000000000000000000000000000110001110000100000011111001001010101000010011111111110111100011000011010;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 69;
    ctrl = 1;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000111011;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 74;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[74])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[74]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 1;
    ctrl = 14;
    data15 = 120'b000000001011111000011000010011100010000011101000000000010110110110111100001100101000101011110010001000100010101000000000;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 6;
    ctrl = 3;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000101101001100010001011101;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 167;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[167])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[167]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 165;
    ctrl = 8;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000001111001000110001100101000100011011000110001101111100011110;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 71;
    ctrl = 1;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000010;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 248;
    ctrl = 9;
    data15 = 120'b000000000000000000000000000000000000000000000000101011100001010100111001011000010101011011111101110100010111000111000100;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 31;
    ctrl = 5;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000001100010110010010001000011111011011100010;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 31;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[31])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[31]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 21;
    ctrl = 1;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001010101;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 47;
    ctrl = 2;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100001111100001;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 61;
    ctrl = 11;
    data15 = 120'b000000000000000000000000000000000111000111001101000110011011000110100111100101111110011011011011010001010111111101011000;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 246;
    ctrl = 14;
    data15 = 120'b000000000001111011100010001011011100111110101100111110110010001101000001110100001101101101001011010011010111100011100111;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 60;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[60])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[60]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 136;
    ctrl = 15;
    data15 = 120'b111001001000000101001100100101010001001101011000101101000101010101110110011000101011001011010000110001101000111001101010;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 179;
    ctrl = 14;
    data15 = 120'b000000000011001111011110001010101110111111101100001010100000000100110100100001010100111100010000100111101001110001100011;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 209;
    ctrl = 8;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000001001010111111000010110100100101111100101100100001000011000000;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 198;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[198])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[198]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 237;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[237])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[237]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 86;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[86])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[86]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 254;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[254])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[254]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 49;
    ctrl = 6;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000101011100001111101111100001001010101101000110000;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 142;
    ctrl = 5;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000001111010001101110111111101010000111001000;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 254;
    ctrl = 4;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011110101001101011010010111010011;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 79;
    ctrl = 12;
    data15 = 120'b000000000000000000000000101001010100000010000000011111001000010011101010100000101111101000101010110101101010011110000101;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 85;
    ctrl = 11;
    data15 = 120'b000000000000000000000000000000001101110101010110001010000100011111001011001010100011101010001011001011111001010001011111;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 96;
    ctrl = 9;
    data15 = 120'b000000000000000000000000000000000000000000000000110101001101110100010000101000110010011001111100100001110010001101101110;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 104;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[104])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[104]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 2;
    ctrl = 15;
    data15 = 120'b100000100110000000011110010111011100001101010111000110010010101011111000110111000111001100101000100000111101000010101110;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 47;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[47])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[47]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 102;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[102])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[102]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 153;
    ctrl = 8;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000011011110011100111110000001001011000100001111001011001000000000;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 176;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[176])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[176]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 6;
    ctrl = 12;
    data15 = 120'b000000000000000000000000011011101011111011110111111111101010010101010000011000001100101101010111101010100010010100100011;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 8;
    ctrl = 13;
    data15 = 120'b000000000000000001001011101010000001011100010010010011101110001001000010110101101011110110001101110001111010001001001000;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 167;
    ctrl = 15;
    data15 = 120'b000011100100100100000001000000101010101001101001101110111101011110001111011010011111010010000001110101101111000001111100;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 227;
    ctrl = 7;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000011101100110011001100011000101010001011010111010010001111;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 83;
    ctrl = 11;
    data15 = 120'b000000000000000000000000000000000111010001011100010101010110010000110111101110010110101001000110111100111100010010110000;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 196;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[196])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[196]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 227;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[227])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[227]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 247;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[247])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[247]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 199;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[199])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[199]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 65;
    ctrl = 14;
    data15 = 120'b000000000011101010100011111000000100000110110111111010101011011111110000010000000101110111100000000111001101111111010011;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 48;
    ctrl = 6;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000101101000000011010111110100011010010101010110000;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 102;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[102])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[102]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 255;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[255])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[255]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 20;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[20])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[20]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 188;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[188])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[188]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 251;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[251])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[251]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 41;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[41])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[41]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 83;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[83])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[83]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 123;
    ctrl = 6;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000010000011101011010100010000100011010110011010111;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 119;
    ctrl = 5;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000001111011100110111011010010010101100101110;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 251;
    ctrl = 3;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000110010010111100001000010;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 237;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[237])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[237]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 209;
    ctrl = 4;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011101000001010011111010010011101;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 115;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[115])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[115]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 70;
    ctrl = 1;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000111;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 99;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[99])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[99]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 146;
    ctrl = 1;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001101101;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 8;
    ctrl = 1;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011110000;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 66;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[66])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[66]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 160;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[160])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[160]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 105;
    ctrl = 8;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000010011000001111101001001010011011010001000110111011001011010;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 152;
    ctrl = 4;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011100110101001000011000011000111;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 68;
    ctrl = 14;
    data15 = 120'b000000001110000101001011100001111001000001001001100110011010101001001100010010000011000111110011100111001000111001100101;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 50;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[50])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[50]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 165;
    ctrl = 7;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000110010101010110000110000111100000011010111110000100;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 12;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[12])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[12]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 162;
    ctrl = 11;
    data15 = 120'b000000000000000000000000000000000001100011100001000101101101110010101010001111100011110100001110011101100100001001001001;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 207;
    ctrl = 5;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000001111001111011001111010101100011001100110;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 225;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[225])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[225]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 198;
    ctrl = 11;
    data15 = 120'b000000000000000000000000000000001001000111101100001110010011001100111010110011110100111011110110000010101111111110100011;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 174;
    ctrl = 10;
    data15 = 120'b000000000000000000000000000000000000000001101100010100001100000101000011101011010001110000101000111000011000111010111011;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 188;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[188])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[188]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 114;
    ctrl = 3;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100111010100000110100;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 13;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[13])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[13]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 85;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[85])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[85]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 112;
    ctrl = 13;
    data15 = 120'b000000000000000000111100111000010011001011100001101000101111000000111100010011010100100001110101001110010100001100011101;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 145;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[145])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[145]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 204;
    ctrl = 1;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001101000;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 201;
    ctrl = 11;
    data15 = 120'b000000000000000000000000000000000100001000011010110010010010010101100001011100100110000101010011001110001011001010101010;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 125;
    ctrl = 8;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000111111011010000101011100101111011011101111010010101101101100000;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 195;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[195])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[195]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 121;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[121])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[121]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 177;
    ctrl = 13;
    data15 = 120'b000000000000000010101011001001100010011001110101000001110001100011000000111001111000010000011000100011010101111110000001;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 148;
    ctrl = 1;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011100110;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 225;
    ctrl = 2;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001010000100001101;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 136;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[136])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[136]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 85;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[85])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[85]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 116;
    ctrl = 8;
    data15 = 120'b000000000000000000000000000000000000000000000000000000001001111001001011010010000100010101010010110011111110110010100010;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 69;
    ctrl = 4;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000110101101011110011101111010001;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 5;
    ctrl = 11;
    data15 = 120'b000000000000000000000000000000000010010101011101000100101011111101011101101100111001110000100010100111001111101101011101;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 236;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[236])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[236]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 53;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[53])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[53]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 97;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[97])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[97]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 92;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[92])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[92]);
        $display("answer given: %d",answer);
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
    rw = 0;
    addr = 98;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[98])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[98]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 130;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[130])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[130]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 161;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[161])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[161]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 253;
    ctrl = 13;
    data15 = 120'b000000000000000010110101101101110100011001000100111000110101111010011010101000011110100100101101011011000101010010101010;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 169;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[169])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[169]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 225;
    ctrl = 2;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000101101110110100;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 126;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[126])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[126]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 250;
    ctrl = 5;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000000101100010000001001100100011001000110010;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 27;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[27])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[27]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 39;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[39])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[39]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 54;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[54])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[54]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 210;
    ctrl = 11;
    data15 = 120'b000000000000000000000000000000000001100100011000111001010001010111010100111011110100110001000100000011111000001010010110;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 79;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[79])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[79]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 143;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[143])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[143]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 29;
    ctrl = 12;
    data15 = 120'b000000000000000000000000100100101111111100001010001011010010111111010101100000010111011011000111001100101110111100001011;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 48;
    ctrl = 15;
    data15 = 120'b010010110110001101001101010000111110001000001000010100111000111010100001100110000111111110011111011101110101111101001001;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 212;
    ctrl = 13;
    data15 = 120'b000000000000000011101011001100000000001000010100110111001111000010011111000001011011101111111011111011001100100111001010;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 247;
    ctrl = 11;
    data15 = 120'b000000000000000000000000000000001011101000111010000100000011011011110011001100011001000001001100010001110000010101101011;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 173;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[173])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[173]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 116;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[116])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[116]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 52;
    ctrl = 10;
    data15 = 120'b000000000000000000000000000000000000000001010100110011110101110001111011110111101101001000010000000010001111011011110001;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 5;
    ctrl = 12;
    data15 = 120'b000000000000000000000000110101010101011011111000101111001011001010101011011100011010000000000100100000111010001110001111;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 19;
    ctrl = 14;
    data15 = 120'b000000001100101001111000110011000001111101001110010100110000110100000111001101101011110110001100011010000111100110110100;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 44;
    ctrl = 15;
    data15 = 120'b000001001010000111000111001011010111000000001001101110000100111000010001111000000111000011001000111100100010010001001100;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 38;
    ctrl = 5;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000001110011000100101101110111100011101111001;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 104;
    ctrl = 1;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011011110;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 24;
    ctrl = 3;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011001111000000111001101;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 89;
    ctrl = 7;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000001001010100010110111010110001111110010100110111000001111;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 96;
    ctrl = 7;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000100110000001111101000100100110101000001101000100110;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 132;
    ctrl = 12;
    data15 = 120'b000000000000000000000000001100111101010010111111110100010101100000010110111111001001000110010010101111111000101101101001;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 115;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[115])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[115]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 140;
    ctrl = 1;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011111101;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 188;
    ctrl = 8;
    data15 = 120'b000000000000000000000000000000000000000000000000000000001100111000000010011001001001101011100000111101101001101111011101;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 66;
    ctrl = 14;
    data15 = 120'b000000000110011101001111110001111011111101010111110100101001000001101110110001111100001100010000100110110000010010001110;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 115;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[115])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[115]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 39;
    ctrl = 14;
    data15 = 120'b000000000110000101100010011100000101011101101010100001001001001110101011100010011100011001011100001010110011100010100010;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 7;
    ctrl = 8;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000101001001010101110111000001101010111010001101111110001001011;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 0;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[0])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[0]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 20;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[20])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[20]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 185;
    ctrl = 6;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000111111001111011000001101001100001110110010001010;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 27;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[27])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[27]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 114;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[114])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[114]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 106;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[106])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[106]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 43;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[43])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[43]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 168;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[168])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[168]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 29;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[29])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[29]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 97;
    ctrl = 9;
    data15 = 120'b000000000000000000000000000000000000000000000000101001100110110001111001010010100001100011001000011001110001101100110110;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 58;
    ctrl = 8;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000100100100000100011110111110100001001111111111010001011110111001;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 221;
    ctrl = 13;
    data15 = 120'b000000000000000010000110010000111110001100111100001000011101101101110101111100111101000011101000100110111000001111000100;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 14;
    ctrl = 7;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000010110100010110111111010011011001110111011001110011011101;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 150;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[150])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[150]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 112;
    ctrl = 15;
    data15 = 120'b110001110100100011101010000011100011011101110001000110000110001010001100101010110110100101011001101111101010010100100101;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 132;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[132])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[132]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 163;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[163])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[163]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 25;
    ctrl = 14;
    data15 = 120'b000000001011111100000011001010010110101110001000101001111011011101110011011110110110110011101001011111111111100000011101;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 151;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[151])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[151]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 12;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[12])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[12]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 180;
    ctrl = 5;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000001110011010100110011111111111011110001011;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 17;
    ctrl = 11;
    data15 = 120'b000000000000000000000000000000000001101010011011110100010011010111101010110001001110000100111000000110011000010000110001;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 246;
    ctrl = 2;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000101101001011101;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 105;
    ctrl = 3;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011011101101100000011001;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 25;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[25])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[25]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 184;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[184])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[184]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 194;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[194])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[194]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 119;
    ctrl = 6;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000110101010100001000111001001111100011100101111110;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 182;
    ctrl = 15;
    data15 = 120'b011010110011110110110000111000001111110010001110110011110101110010001100011101111001000011011101110111100111001010000011;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 94;
    ctrl = 9;
    data15 = 120'b000000000000000000000000000000000000000000000000111001001101011100011110111100000011111100110110010010010101110110010110;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 132;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[132])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[132]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 215;
    ctrl = 5;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000000001001101001100111101011111000111000000;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 180;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[180])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[180]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 68;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[68])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[68]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 214;
    ctrl = 14;
    data15 = 120'b000000000100111110001100011001011110001111010010111110010001010001110100011100000001101111000110011110100010111110111011;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 186;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[186])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[186]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 135;
    ctrl = 10;
    data15 = 120'b000000000000000000000000000000000000000010111101010100011111011000101100101000100011001011001001000010000000110100000110;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 213;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[213])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[213]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 18;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[18])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[18]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 144;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[144])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[144]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 22;
    ctrl = 7;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000001100111000110010000001000000101010111100011110110001100;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
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
    rw = 0;
    addr = 130;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[130])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[130]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 201;
    ctrl = 14;
    data15 = 120'b000000001001011101000001101101010101110100101001010011010000111111000011001110101111110010101110111100100111011000001001;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 218;
    ctrl = 3;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000111111001001101011110110;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 243;
    ctrl = 2;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010100010111001;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 73;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[73])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[73]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 255;
    ctrl = 11;
    data15 = 120'b000000000000000000000000000000000100101101001111011000101010001101001101110101010011100010000000001001000010101001000011;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 4;
    ctrl = 15;
    data15 = 120'b011110001111101000011011010100001011110011101111010000010110001011001001100111101111110101010010010011100100110111111011;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 205;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[205])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[205]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 111;
    ctrl = 11;
    data15 = 120'b000000000000000000000000000000001010001000000101001011100110100110010101110111100101001010011100011011110111100011001001;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 76;
    ctrl = 13;
    data15 = 120'b000000000000000000001000001001100000000011101000000101101100000010111001011110111100010111001100111000010111111011111010;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 246;
    ctrl = 4;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000110100010011000111100100010011;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 14;
    ctrl = 13;
    data15 = 120'b000000000000000011010011110100111111001001111000111010010110000111010100011001101011110001001101000000100011101100101010;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 42;
    ctrl = 9;
    data15 = 120'b000000000000000000000000000000000000000000000000001000011110001010001011001001010100101111001000110100011110111101110111;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 199;
    ctrl = 6;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000011101011111110000001111101011001111111011001;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 80;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[80])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[80]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 191;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[191])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[191]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 35;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[35])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[35]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 127;
    ctrl = 6;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000100100100001100010010010000101101010101010101000;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 185;
    ctrl = 11;
    data15 = 120'b000000000000000000000000000000000001001011001001010011000111000101100010110011011011110011010000110010101001101011001101;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 40;
    ctrl = 3;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000110101101100100110000101;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 250;
    ctrl = 2;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000111101;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 37;
    ctrl = 4;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001110001000001000100010101111;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 92;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[92])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[92]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 150;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[150])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[150]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 137;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[137])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[137]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 240;
    ctrl = 13;
    data15 = 120'b000000000000000001010111000100011011100101100101010001111111110010101011000110100111000110111001110011001000010010010111;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 141;
    ctrl = 10;
    data15 = 120'b000000000000000000000000000000000000000011111110110100011000001110111011111010010000001000011000010001000001010101001111;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 78;
    ctrl = 12;
    data15 = 120'b000000000000000000000000101110001110011001101110101101011010001100011110100000010001111110101101101010101110111011110101;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 78;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[78])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[78]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 16;
    ctrl = 13;
    data15 = 120'b000000000000000010011110010100111001010101000111100100011101101010101010010000011010001100111111111000100010101101110110;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 205;
    ctrl = 3;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100011100000100000111100;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 197;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[197])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[197]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 92;
    ctrl = 5;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000001011001101101100010100100010001011000100;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 89;
    ctrl = 5;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000001111111000100100101101001101000011111010;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 12;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[12])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[12]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 97;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[97])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[97]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 191;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[191])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[191]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 87;
    ctrl = 12;
    data15 = 120'b000000000000000000000000111100101101110110000111000110010001110110110010001010010110110000111010101000110111111000110011;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 38;
    ctrl = 4;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000111010111100111010110100100100;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 86;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[86])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[86]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 95;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[95])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[95]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 48;
    ctrl = 1;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011110001;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 1;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[1])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[1]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 114;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[114])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[114]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 212;
    ctrl = 2;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000011100111110;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 107;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[107])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[107]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 44;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[44])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[44]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 55;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[55])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[55]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 239;
    ctrl = 1;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 8;
    ctrl = 13;
    data15 = 120'b000000000000000001101100010101001111111101110011011111110111101100011001101001110100100000110100101111111100000011110111;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 161;
    ctrl = 6;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000100101100100000100110001010011111100111101011000;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 164;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[164])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[164]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 135;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[135])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[135]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 88;
    ctrl = 14;
    data15 = 120'b000000000000100010001101010101100100110010100001001101010011010100010011010011110010110011111011110000000100010110101011;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 14;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[14])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[14]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 245;
    ctrl = 6;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000101000011111001111001110101111001010000110001101;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 126;
    ctrl = 14;
    data15 = 120'b000000001011101010001110110010010101011011100011100010001011100111001101101100111101001100011000101110101001111111001110;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 100;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[100])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[100]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 55;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[55])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[55]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 49;
    ctrl = 1;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011000010;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 248;
    ctrl = 2;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 225;
    ctrl = 15;
    data15 = 120'b110110111000101101000110010011001110000000101011010010100010111101110111100111011001011111111010110100110001101011001011;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 235;
    ctrl = 8;
    data15 = 120'b000000000000000000000000000000000000000000000000000000001001010111110111001111100001000001010111001010110010001110010101;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 248;
    ctrl = 5;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000001001110011100010100101110101000000100110;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 86;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[86])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[86]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 172;
    ctrl = 14;
    data15 = 120'b000000000110010101110101101111001110100000011010101011011110110000010010110001101100001010100110011101010010111100011010;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 6;
    ctrl = 11;
    data15 = 120'b000000000000000000000000000000001000100001100110000011001101110011111010100011101001001000111101010101111000010100011011;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 99;
    ctrl = 9;
    data15 = 120'b000000000000000000000000000000000000000000000000110111101100110110100010000010000111000010000011100110011100001111001100;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 241;
    ctrl = 15;
    data15 = 120'b101001001001001111111000110110110111110101100011100100110001000110011001110010001110100110001110100010100100010101011011;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 52;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[52])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[52]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 106;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[106])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[106]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 61;
    ctrl = 2;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001101101001100101;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 226;
    ctrl = 2;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001100000001100001;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 93;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[93])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[93]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 145;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[145])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[145]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 24;
    ctrl = 8;
    data15 = 120'b000000000000000000000000000000000000000000000000000000001101101010000100100010100000001000010000100000100001111011101111;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 75;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[75])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[75]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 124;
    ctrl = 4;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011011011001110010000111101011100;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 171;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[171])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[171]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 67;
    ctrl = 6;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000001000110000010100110011011000101000001101111010;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 43;
    ctrl = 4;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001101111101110111001101011111000;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 57;
    ctrl = 14;
    data15 = 120'b000000001110110101001000111111010001101000101111000101001111101111001100010000011001111010110110001011101111011110000001;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 254;
    ctrl = 13;
    data15 = 120'b000000000000000000011101011111010100011001100011001000011010001001101001011101111011001111111000001101010101111010100001;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 94;
    ctrl = 13;
    data15 = 120'b000000000000000010110100110100000110100110001100100000100110001100010110011110000011000000111101001010000000001101111100;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 205;
    ctrl = 11;
    data15 = 120'b000000000000000000000000000000000010000111110000001111110010100001001000010011111111010000111100110011110100100100101100;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 158;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[158])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[158]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 72;
    ctrl = 8;
    data15 = 120'b000000000000000000000000000000000000000000000000000000001010010111000001010011010100000001110110010110010110000011111000;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 207;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[207])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[207]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 60;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[60])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[60]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 99;
    ctrl = 2;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001010101100111111;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 40;
    ctrl = 15;
    data15 = 120'b010000000110011001101111001000000100111100101001010011010110101011111100111100100010100110011001000110000110101000011100;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 168;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[168])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[168]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 48;
    ctrl = 15;
    data15 = 120'b110001011011101101010011100010110101010110110100010011001111000110101101010011111011110000100111001111011100110000011100;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 197;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[197])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[197]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 111;
    ctrl = 6;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000010100001010010111100111100101110111001010000111;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 95;
    ctrl = 14;
    data15 = 120'b000000000101100011111000111011000110110000110110100101001111011001101100011110011111110010100011010101110001110000011101;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 44;
    ctrl = 5;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000001010010000101101000000010111000001100110;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 47;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[47])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[47]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 137;
    ctrl = 6;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000001010011111100100010111011100111101100010110101;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 142;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[142])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[142]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 15;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[15])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[15]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 127;
    ctrl = 8;
    data15 = 120'b000000000000000000000000000000000000000000000000000000001011111011000100000100110001100100100010010001100101000000100101;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 123;
    ctrl = 8;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000001101100111000011100000010000011100001100101001010010010101000;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 140;
    ctrl = 13;
    data15 = 120'b000000000000000001011000011000000000000110111010010100011111010011100100100110000110110000011110011001110000100111111100;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 136;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[136])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[136]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 16;
    ctrl = 4;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001101111011111000101000111001011;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 61;
    ctrl = 9;
    data15 = 120'b000000000000000000000000000000000000000000000000111011110000110011011110101001111111111110100010001010001001011000001111;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 65;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[65])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[65]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 60;
    ctrl = 14;
    data15 = 120'b000000000110000011011110010100011100001110000111010000101111001100111000111111000010011100011011110110000000101100111111;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 231;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[231])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[231]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 98;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[98])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[98]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 225;
    ctrl = 7;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000001010001111010111110100111000001100110010111001110010000;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 3;
    ctrl = 1;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000011;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 222;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[222])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[222]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 84;
    ctrl = 4;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001010011000010100011101101101010;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 49;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[49])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[49]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 99;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[99])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[99]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 249;
    ctrl = 4;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001001110010110100100010110010111;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 227;
    ctrl = 1;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000111;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 61;
    ctrl = 15;
    data15 = 120'b111111111001001110100100001010001010110101101011111111100011001101001010100110001101101001011101011100101110101001110110;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 216;
    ctrl = 3;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001101010000010110001111;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 54;
    ctrl = 2;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001010100100101000;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 222;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[222])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[222]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 127;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[127])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[127]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 171;
    ctrl = 13;
    data15 = 120'b000000000000000011011000011101001001101101010000010011001110110111101011010010101000000000011000011001001100000111001100;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 225;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[225])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[225]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 9;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[9])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[9]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 63;
    ctrl = 6;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000011010111100000011101000101110000101011000000010;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 229;
    ctrl = 1;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011101010;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 115;
    ctrl = 1;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000111101;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 196;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[196])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[196]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 102;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[102])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[102]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 120;
    ctrl = 13;
    data15 = 120'b000000000000000000111110111110011000000110011100001101110000000011100011111100110100100000111010000100010110010001010000;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 210;
    ctrl = 10;
    data15 = 120'b000000000000000000000000000000000000000001100001000010100111010111011110011010110111101100110101110100110100011011011110;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 38;
    ctrl = 14;
    data15 = 120'b000000001101011100101101100010010101001111111011110111001001000110000110011110100011101110010110100010111111000100011001;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 156;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[156])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[156]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 20;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[20])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[20]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 74;
    ctrl = 7;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000011110101110111010011100011001110000011000110001000000110;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 163;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[163])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[163]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 194;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[194])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[194]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 47;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[47])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[47]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 55;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[55])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[55]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 84;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[84])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[84]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 47;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[47])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[47]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 82;
    ctrl = 10;
    data15 = 120'b000000000000000000000000000000000000000010110111100010001000111100101100011001100000100101110111010001011101001110100101;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 177;
    ctrl = 11;
    data15 = 120'b000000000000000000000000000000001001001101000110101010011001100010000110101100110110000110110010110110011101010000000000;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 210;
    ctrl = 12;
    data15 = 120'b000000000000000000000000110000100111111100100110101111110101001001101110100011010001011000101001010010111010101111110011;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 254;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[254])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[254]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 18;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[18])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[18]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 181;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[181])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[181]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 95;
    ctrl = 15;
    data15 = 120'b110011110011011101010001011011110011110000100001110010101111110101100010111101110101011000101101111010000001110001110100;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 55;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[55])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[55]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 86;
    ctrl = 8;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000110101110000101011110000111001101101110111011101110111011011101;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 128;
    ctrl = 3;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001100110000001101110011;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 61;
    ctrl = 9;
    data15 = 120'b000000000000000000000000000000000000000000000000010000101010001100111101001100110011001011101011100100111010100011011100;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 164;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[164])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[164]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 218;
    ctrl = 10;
    data15 = 120'b000000000000000000000000000000000000000010001111100001011010010000101001101111111000110110000100011011000011010011100011;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 171;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[171])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[171]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 84;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[84])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[84]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 140;
    ctrl = 4;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010100001011100000001100101010011;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 81;
    ctrl = 1;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100001;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 235;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[235])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[235]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 137;
    ctrl = 14;
    data15 = 120'b000000000000000110111000101011111100101111010110000110000101100000011010111101100110101110011101100000001101111010010110;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 88;
    ctrl = 12;
    data15 = 120'b000000000000000000000000100011011110010011111001010111110001011000110011111000111100111010010100001110100011000011111100;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 158;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[158])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[158]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 37;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[37])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[37]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 200;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[200])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[200]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 18;
    ctrl = 3;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000001100100000110010;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 105;
    ctrl = 3;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001100011101001100101010;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 225;
    ctrl = 11;
    data15 = 120'b000000000000000000000000000000000000011110001011010101000110011010000011010001010000001000010101110000110001000011010110;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 163;
    ctrl = 7;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000011010101011001000101001111101001101010001001001001100010;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 39;
    ctrl = 12;
    data15 = 120'b000000000000000000000000100010000001000000101111001110111000001101000010110010111100000001000100100111100110110100001011;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 242;
    ctrl = 4;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010010111100100110100100000100101;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 43;
    ctrl = 13;
    data15 = 120'b000000000000000010110001010011111000000110001111000011000010110101000110010001000110000010110110111100101100100001000101;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 205;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[205])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[205]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 145;
    ctrl = 15;
    data15 = 120'b010000010011111011101110000111011011101011110010001001111101010101001000111110011011000110100110000011001110100010110101;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 176;
    ctrl = 6;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000100110011000111001100011101001110011101110110001;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 140;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[140])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[140]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 41;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[41])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[41]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 111;
    ctrl = 5;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000000111010001111110010110010110001011001001;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 118;
    ctrl = 10;
    data15 = 120'b000000000000000000000000000000000000000011100100011110101011101000101010011111000111000101000111100001011110011100111001;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 207;
    ctrl = 12;
    data15 = 120'b000000000000000000000000101010001110111101111010100010010001111101001101001110001110000010001011011110100100011001001111;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 60;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[60])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[60]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 60;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[60])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[60]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 21;
    ctrl = 8;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000111010010101111010000000011001101101001000001010010110110001010;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 62;
    ctrl = 12;
    data15 = 120'b000000000000000000000000001110001100111010000101100011111110010010101101100010011011101001001010111111010111111100111000;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 7;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[7])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[7]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 32;
    ctrl = 13;
    data15 = 120'b000000000000000000100100011100110010100000100110100110011011001100000101101001111010100000010101000100111010101110100111;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 188;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[188])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[188]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 248;
    ctrl = 14;
    data15 = 120'b000000000010001001000111010011110011110000110001101111110110011101110100010111100110101011110011011000010001100100100100;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 23;
    ctrl = 9;
    data15 = 120'b000000000000000000000000000000000000000000000000111110010111010110100000000000110000010011011101011101101110100011001110;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 39;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[39])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[39]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 242;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[242])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[242]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 219;
    ctrl = 3;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000111101100000101001010110;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 21;
    ctrl = 15;
    data15 = 120'b001100111011110000001010101010010111101000001010001111101010011110000100111000101111110010001100101001011000101110010110;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 213;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[213])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[213]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 204;
    ctrl = 7;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000010001101111010000100101110011101010010111100110101111;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
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
    addr = 66;
    ctrl = 10;
    data15 = 120'b000000000000000000000000000000000000000001101111111111100111001100101101111100111001111111101011001100010111101010111010;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 233;
    ctrl = 13;
    data15 = 120'b000000000000000000010011000000001110100100100101001010010110100000111001000010001101101101000010000011011000000100110110;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 169;
    ctrl = 8;
    data15 = 120'b000000000000000000000000000000000000000000000000000000001110011100100100000110101010110100000101011000011001110000100111;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 186;
    ctrl = 1;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010011010;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 101;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[101])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[101]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 21;
    ctrl = 8;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000011011111011101011110111001111010001110101011011000100011010100;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 171;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[171])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[171]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 48;
    ctrl = 12;
    data15 = 120'b000000000000000000000000110000101100001010111111111110100000000111100110101001000000010111110100111111111101100100101001;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 28;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[28])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[28]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 105;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[105])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[105]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 217;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[217])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[217]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 108;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[108])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[108]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 186;
    ctrl = 15;
    data15 = 120'b101111000011101001111111010100101010011011011101001100110101101001110011110100001110010001001000001000010001000010000111;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 46;
    ctrl = 14;
    data15 = 120'b000000001111010010111101010110110011111110011011000101101010010001010110010100011010011011000101000000111010111110101001;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 197;
    ctrl = 3;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001010000100011010010101;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 204;
    ctrl = 1;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010111000;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 102;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[102])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[102]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 87;
    ctrl = 14;
    data15 = 120'b000000000001100110111111101000111010011100000101001011001110100100111100001001100110100110000101110100110101101111111100;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 72;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[72])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[72]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 198;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[198])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[198]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 84;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[84])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[84]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 215;
    ctrl = 9;
    data15 = 120'b000000000000000000000000000000000000000000000000111010010011111111000011011000000111111110110111001101010000011110111111;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 198;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[198])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[198]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 218;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[218])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[218]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 142;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[142])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[142]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 249;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[249])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[249]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 120;
    ctrl = 7;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000111000110010101110101111101010000011010010100011110110;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 31;
    ctrl = 8;
    data15 = 120'b000000000000000000000000000000000000000000000000000000001101000010000100111111100010001010011111110101001111001000000110;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 129;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[129])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[129]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 149;
    ctrl = 2;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001010110011001001;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 60;
    ctrl = 14;
    data15 = 120'b000000001010001111100010001101000110010010011100000010101101000101110011101110000100111110100010010010010110100000100011;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 18;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[18])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[18]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 156;
    ctrl = 14;
    data15 = 120'b000000001110100100110010010000110011011011100011011010101010011000011010101001011100010000001010100010110101000001111110;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 251;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[251])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[251]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 225;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[225])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[225]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 63;
    ctrl = 13;
    data15 = 120'b000000000000000011110101011100111110111100100001000111001000001011010100110001110101000111110101100000001100001101101000;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 189;
    ctrl = 1;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 135;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[135])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[135]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 30;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[30])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[30]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 9;
    ctrl = 2;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010101111110;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 207;
    ctrl = 3;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000111101111010001111101110;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 33;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[33])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[33]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 212;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[212])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[212]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 195;
    ctrl = 15;
    data15 = 120'b100101101010011011011000110101101000101101101101000111101001100000101000110011101010100100110011001110100011100101110110;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 99;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[99])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[99]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 216;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[216])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[216]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 211;
    ctrl = 4;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011011101100101100110111010110001;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 199;
    ctrl = 3;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000111011000001110000100011;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 225;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[225])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[225]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 79;
    ctrl = 2;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001100010100101111;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 138;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[138])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[138]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 65;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[65])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[65]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 24;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[24])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[24]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 81;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[81])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[81]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 193;
    ctrl = 10;
    data15 = 120'b000000000000000000000000000000000000000010100010101110011100110001001010010111000100110000100110101100100101101110111101;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 127;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[127])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[127]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 131;
    ctrl = 15;
    data15 = 120'b010101110111001011100111001000111010010100110011011011011100001110101101111010010010001000110101011011001000000111111001;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 107;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[107])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[107]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 59;
    ctrl = 9;
    data15 = 120'b000000000000000000000000000000000000000000000000111011011001000100110111001010110000100000001101011101110101001111101011;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 125;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[125])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[125]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 129;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[129])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[129]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 108;
    ctrl = 15;
    data15 = 120'b010100011000111011001101000110111100100010111100011101101110010101110110010111111010001100110010011110011001111111111110;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 248;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[248])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[248]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 23;
    ctrl = 14;
    data15 = 120'b000000000101011011000110001101010010110111010011001000110000111111100100110011011001110000111000100100111010100111001001;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 63;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[63])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[63]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 215;
    ctrl = 14;
    data15 = 120'b000000001000101011110000000011101100110100100101111101111000010110001111100001001111011100010010110100111011000010001110;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 164;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[164])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[164]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 6;
    ctrl = 1;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001101001;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 234;
    ctrl = 6;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000010010111010011110001001100000111100001111111010;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 249;
    ctrl = 2;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001101000110110110;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 71;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[71])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[71]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 220;
    ctrl = 3;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011011101010101010100010;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 188;
    ctrl = 14;
    data15 = 120'b000000000110101010010110011100110110110110011101011100101000000100000011011000100011101101100011101001011110000000100001;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 126;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[126])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[126]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 102;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[102])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[102]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 113;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[113])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[113]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 22;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[22])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[22]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 70;
    ctrl = 4;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011101010101111111111100101111101;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 223;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[223])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[223]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 205;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[205])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[205]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 40;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[40])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[40]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 143;
    ctrl = 12;
    data15 = 120'b000000000000000000000000011101111001001010110101101101101011010100001011000110110000110001110101000001001011001000101110;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 165;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[165])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[165]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 42;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[42])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[42]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 28;
    ctrl = 13;
    data15 = 120'b000000000000000001010110101101111000011110011110110110110011100011011000010001110011010010100101000011110111001101110001;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 242;
    ctrl = 13;
    data15 = 120'b000000000000000011110101001010011000100001011100001111100011100101001111010010001001001000010111011101010111011101110001;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 255;
    ctrl = 13;
    data15 = 120'b000000000000000010101101111001001011010000010000010001101010111011101001110110110100011100001111010011000001000001011101;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 115;
    ctrl = 7;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000011011100100000000011001111001000110110100010010111011000;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 94;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[94])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[94]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 18;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[18])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[18]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 22;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[22])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[22]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 236;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[236])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[236]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 122;
    ctrl = 9;
    data15 = 120'b000000000000000000000000000000000000000000000000001110100101011101001101100100101010010011000101000100011111001000100000;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 230;
    ctrl = 15;
    data15 = 120'b010011000001110011000111010010000100011110111100001001000101000110101110010101110010000110110001111001101000111110001001;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 242;
    ctrl = 8;
    data15 = 120'b000000000000000000000000000000000000000000000000000000001000100101101011011000110010011010101111101110101111001011110001;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 239;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[239])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[239]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 40;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[40])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[40]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 76;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[76])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[76]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 22;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[22])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[22]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 171;
    ctrl = 8;
    data15 = 120'b000000000000000000000000000000000000000000000000000000001001110101010111001101100001111100010001001010000101111111000101;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 101;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[101])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[101]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 20;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[20])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[20]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 198;
    ctrl = 5;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000000010001011010101000100011111011100100111;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 185;
    ctrl = 6;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000111000000101010111101001001010011101100110101111;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 100;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[100])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[100]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 171;
    ctrl = 11;
    data15 = 120'b000000000000000000000000000000000101000100101001000001001110111001000100010001000001010001001001011001000110000001001111;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 91;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[91])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[91]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 103;
    ctrl = 12;
    data15 = 120'b000000000000000000000000001100111101101001101000001001111110010000011010001011010100100010111101101100111101000000111100;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 219;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[219])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[219]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 99;
    ctrl = 5;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000000101101000100011110111010000001101001011;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 139;
    ctrl = 6;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000100110001101101110110100011000110011011000111100;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 86;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[86])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[86]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 27;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[27])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[27]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 167;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[167])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[167]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 77;
    ctrl = 12;
    data15 = 120'b000000000000000000000000000111101100000100001001011110000111100100100001100110001001000111110011110001011011001001011010;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 244;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[244])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[244]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 126;
    ctrl = 2;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010011111101;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 214;
    ctrl = 15;
    data15 = 120'b000100100001000100100010101100011010110100010010111110010100000111110011000000000110000100101100100110010011010101101011;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 153;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[153])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[153]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 198;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[198])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[198]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 27;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[27])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[27]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 141;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[141])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[141]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 176;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[176])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[176]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 220;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[220])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[220]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 182;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[182])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[182]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 157;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[157])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[157]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 27;
    ctrl = 2;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000101110110111110;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 155;
    ctrl = 5;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000000111001101000001101110001110010100111011;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 183;
    ctrl = 2;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001100011110100100;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 35;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[35])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[35]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 249;
    ctrl = 9;
    data15 = 120'b000000000000000000000000000000000000000000000000011011100011100111001010100101011100110001100010000000111001000000000010;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 154;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[154])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[154]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 56;
    ctrl = 6;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000110011101100000011101010010111110011100001101110;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 10;
    ctrl = 11;
    data15 = 120'b000000000000000000000000000000000101110100000011000110101100010101010010000010000011110111100011001001110100110010011001;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 130;
    ctrl = 15;
    data15 = 120'b111111000010011011110011110000010000011110110001001110101011101111100001110110001100100100011101011000001010011101111011;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 229;
    ctrl = 9;
    data15 = 120'b000000000000000000000000000000000000000000000000000101001001001001001101001000110000110001111001010001100000101110101110;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 207;
    ctrl = 2;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000111011010001000;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 61;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[61])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[61]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 40;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[40])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[40]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 101;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[101])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[101]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 112;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[112])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[112]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 56;
    ctrl = 4;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010011101000111001101010100010110;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 240;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[240])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[240]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 225;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[225])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[225]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 169;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[169])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[169]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 73;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[73])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[73]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 203;
    ctrl = 9;
    data15 = 120'b000000000000000000000000000000000000000000000000101110100010101010010111001010011111100011100001100010100100011100101000;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 172;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[172])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[172]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 221;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[221])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[221]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 64;
    ctrl = 13;
    data15 = 120'b000000000000000011000110000011100101000100010111111111101111010110111100000110011110110010000111000100011000101000111110;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 221;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[221])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[221]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 61;
    ctrl = 5;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000001010100111000001111000110011111001000000;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 41;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[41])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[41]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 246;
    ctrl = 6;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000110111110010001100010010010011001010101010000111;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 170;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[170])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[170]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 123;
    ctrl = 3;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000001100001101111011;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 38;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[38])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[38]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 201;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[201])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[201]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 170;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[170])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[170]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 173;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[173])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[173]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 123;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[123])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[123]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 137;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[137])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[137]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 34;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[34])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[34]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 222;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[222])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[222]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 177;
    ctrl = 15;
    data15 = 120'b100010101010101110000000101100111000101111110111011110010001001001001110100000010010011111000111001110000100100100111010;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 116;
    ctrl = 13;
    data15 = 120'b000000000000000001001001101100110011100101001001100000101101100011001000111000100001111111100010111101010000000101011001;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 254;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[254])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[254]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 245;
    ctrl = 10;
    data15 = 120'b000000000000000000000000000000000000000011110011010111111000011001101101001110010100010110000100001000011100110111010010;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 165;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[165])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[165]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 42;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[42])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[42]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 217;
    ctrl = 7;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000001111100110110110100100000010001000100111001010100000011;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 93;
    ctrl = 8;
    data15 = 120'b000000000000000000000000000000000000000000000000000000001111011001111110001100100111110001010101001000001010111101101110;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 24;
    ctrl = 12;
    data15 = 120'b000000000000000000000000101100010110001110001011010100110000110000011000100111011010001000011101110100101011101001110001;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 106;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[106])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[106]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 117;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[117])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[117]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 117;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[117])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[117]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 172;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[172])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[172]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 6;
    ctrl = 8;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000001100001011111001110100100110011001000101100010100000011010100;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 99;
    ctrl = 11;
    data15 = 120'b000000000000000000000000000000001111100001100001010001111111010001000101011001100011011101010101101101100010101011010100;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 241;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[241])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[241]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 143;
    ctrl = 3;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000101100110001100000010000;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 22;
    ctrl = 9;
    data15 = 120'b000000000000000000000000000000000000000000000000111110001111011010101101011101011000010011101011111010010001000011110011;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 239;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[239])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[239]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 94;
    ctrl = 6;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000111001110000111111011101110001110000011010011;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 153;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[153])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[153]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 234;
    ctrl = 14;
    data15 = 120'b000000001000101110000001111100101101110011010010011001011001001100010110100011111111000011101011010101011101100110101011;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 230;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[230])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[230]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 163;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[163])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[163]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 234;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[234])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[234]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 36;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[36])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[36]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 6;
    ctrl = 14;
    data15 = 120'b000000001000111010101011000001101101001101000110110100101001011110101110110011110101111000011110100110000110011011001101;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 116;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[116])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[116]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 85;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[85])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[85]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 140;
    ctrl = 5;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000101000001111100011111;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 49;
    ctrl = 4;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001010111010111011110111010110011;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 245;
    ctrl = 8;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000011100111011011110000101111011000011101001000001010011001001001;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 170;
    ctrl = 15;
    data15 = 120'b000111000000101111100011101100000011011001100111110000100001011010010100110001011100011010100011111000100011101000111001;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 209;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[209])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[209]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 138;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[138])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[138]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 137;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[137])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[137]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 235;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[235])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[235]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 247;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[247])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[247]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 227;
    ctrl = 7;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000010011000001100110010010100110011101111010000001010100001;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 152;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[152])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[152]);
        $display("answer given: %d",answer);
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
    addr = 76;
    ctrl = 8;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000001000111110010001111100011111000111100010011011101011111101;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 152;
    ctrl = 6;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000011001110110100001111000011000001001111110000010;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 71;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[71])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[71]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 191;
    ctrl = 2;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001101001111111011;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 172;
    ctrl = 1;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001110001;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 248;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[248])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[248]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 149;
    ctrl = 12;
    data15 = 120'b000000000000000000000000101001010110000100100101001101100110011101100001000010000100100110100111001111101111000111111100;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 187;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[187])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[187]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 124;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[124])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[124]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 131;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[131])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[131]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 223;
    ctrl = 7;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000001111010011010111001110110111011000110101011111110010111;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 114;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[114])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[114]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 148;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[148])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[148]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 36;
    ctrl = 8;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000010101111000011001100011100111011101111101001110110110110110100;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 71;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[71])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[71]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 224;
    ctrl = 12;
    data15 = 120'b000000000000000000000000010010001000100011010100111100000100000001101000101001111101011101001100101100110000111111100010;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 12;
    ctrl = 12;
    data15 = 120'b000000000000000000000000011110101111001001101000010101110011100001010100101000000101111101100100001001101011010000001010;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 218;
    ctrl = 11;
    data15 = 120'b000000000000000000000000000000001110011110110011010000011101110110010000100110100101001000011110110001010010001100001010;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 249;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[249])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[249]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 166;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[166])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[166]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 115;
    ctrl = 15;
    data15 = 120'b101111011000011110010011011010101000011000111010001000111101000011101111100111001111010111001101011111011001110000100011;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 205;
    ctrl = 8;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000011100110001101110111111100110110110011110001010010111011010011;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 20;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[20])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[20]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 244;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[244])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[244]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 98;
    ctrl = 11;
    data15 = 120'b000000000000000000000000000000001100110100000000011101110011000100110110110101010101111011111100011100010001001011111011;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 185;
    ctrl = 4;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010110110100111111001010011100010;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 40;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[40])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[40]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 221;
    ctrl = 1;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000010;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 189;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[189])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[189]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 230;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[230])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[230]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 68;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[68])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[68]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 181;
    ctrl = 1;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011111000;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 79;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[79])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[79]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 184;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[184])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[184]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 135;
    ctrl = 1;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001100001;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 204;
    ctrl = 10;
    data15 = 120'b000000000000000000000000000000000000000011001100100111101110010101101101011000011010000101010011001001011001001101110000;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 146;
    ctrl = 14;
    data15 = 120'b000000001101011110110010101110011000001001001101111110001101110101010010010101011110000110010000010110011000111011010011;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 193;
    ctrl = 15;
    data15 = 120'b111101010111001110100100000010011010100110111101000000001111101001110001001010100001100011110001001111010011110011101010;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 149;
    ctrl = 15;
    data15 = 120'b011101110100001111110000000100111000000010111001110110111101000001110001000010010010101011110100011101111011011101101111;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 121;
    ctrl = 12;
    data15 = 120'b000000000000000000000000110010101101010001001100010000001111110011010011000010011000010100001000010110001101100100001011;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 141;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[141])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[141]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 133;
    ctrl = 7;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000010000110110110010011000100110111010100001001100010101111;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 189;
    ctrl = 10;
    data15 = 120'b000000000000000000000000000000000000000010100110100111101110001011111110000011100010001100000111111101000001011001100010;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 215;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[215])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[215]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 128;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[128])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[128]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 149;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[149])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[149]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 124;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[124])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[124]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 112;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[112])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[112]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 165;
    ctrl = 8;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000110000101100010011110100011000001011001010110010110000011100001;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 133;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[133])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[133]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 236;
    ctrl = 4;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010001011011010101001111110110011;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 200;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[200])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[200]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 153;
    ctrl = 12;
    data15 = 120'b000000000000000000000000011111010001110000010000011111110100101011000010011010110001010001011111110100111110001111111101;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 185;
    ctrl = 4;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001001111011110101100100111011100;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 186;
    ctrl = 7;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000001001000000000110110011101110110000110000000111011000000;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 222;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[222])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[222]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 87;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[87])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[87]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 245;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[245])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[245]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 58;
    ctrl = 4;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011110011010101110011110100011011;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 152;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[152])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[152]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 68;
    ctrl = 2;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001001011110011010;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 65;
    ctrl = 13;
    data15 = 120'b000000000000000010011111111100111011011010100011000101101001111110100100111110100010111111111110001100011101100010110010;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 17;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[17])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[17]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 227;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[227])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[227]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 238;
    ctrl = 6;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000011011111111000001111001001110010100101011000101;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 109;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[109])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[109]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 191;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[191])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[191]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 233;
    ctrl = 11;
    data15 = 120'b000000000000000000000000000000000011101011001000010101000110010000010011101010110010000011101011100111000010110010011011;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 95;
    ctrl = 2;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001111010001001100;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 112;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[112])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[112]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 58;
    ctrl = 13;
    data15 = 120'b000000000000000010110111101000000000101101011111100100100111101011111101110010010111001011011111001110011000100011011011;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 159;
    ctrl = 15;
    data15 = 120'b100101001111100011101010110100001000111010010111110011011110011101001001011010001101000011101111101000101101001000010010;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 14;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[14])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[14]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 82;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[82])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[82]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 143;
    ctrl = 15;
    data15 = 120'b001110110000111011001000010000101010101110111111010011010000101100010111111010100110110111001101111110010001011100010110;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 22;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[22])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[22]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 26;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[26])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[26]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 14;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[14])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[14]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 115;
    ctrl = 1;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001111011;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 41;
    ctrl = 4;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011010101101111101001110010001111;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 45;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[45])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[45]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 59;
    ctrl = 4;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001001100110000101111000001000;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 65;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[65])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[65]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 203;
    ctrl = 8;
    data15 = 120'b000000000000000000000000000000000000000000000000000000001101001001001111010001110010000001011100110100011101011110010101;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 48;
    ctrl = 13;
    data15 = 120'b000000000000000000000111000101001011101101000101110000100111101000111001100000011011101010011011101111010101010001101010;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 249;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[249])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[249]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 16;
    ctrl = 15;
    data15 = 120'b011010000000110110010000110110000101011011010110100011000001010111001110100010100101101011110011010111100010101011010010;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 210;
    ctrl = 7;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000001101100000100100110100100010001100010000101100101001011;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 23;
    ctrl = 12;
    data15 = 120'b000000000000000000000000101000001010110111010011001010101000100101010101101011001100110011001110110001011100010100011101;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 107;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[107])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[107]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 211;
    ctrl = 9;
    data15 = 120'b000000000000000000000000000000000000000000000000001101100011100111000000110001100101010001010011011101010001100111000100;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 241;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[241])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[241]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 149;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[149])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[149]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 165;
    ctrl = 8;
    data15 = 120'b000000000000000000000000000000000000000000000000000000001000101011111100011111001110011100101010111100110101101101000110;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 118;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[118])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[118]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 253;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[253])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[253]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 158;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[158])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[158]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 75;
    ctrl = 8;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000111011011001000111010011110111001101110100000011001101111110100;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 58;
    ctrl = 1;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010011110;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 135;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[135])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[135]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 198;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[198])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[198]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 162;
    ctrl = 3;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011111010010110101010010;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 2;
    ctrl = 14;
    data15 = 120'b000000001110011001100000010101011110110110111101100011011001110110100001101110111110010100010011110011110101101001111010;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 28;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[28])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[28]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 99;
    ctrl = 8;
    data15 = 120'b000000000000000000000000000000000000000000000000000000001111000101101000101101111100000011101000001111000001000100100111;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 44;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[44])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[44]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 243;
    ctrl = 10;
    data15 = 120'b000000000000000000000000000000000000000000101000110010111010011011110011001100101111110001100110011011100010111000000111;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 16;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[16])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[16]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 61;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[61])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[61]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 195;
    ctrl = 6;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000100011100111111000101010001111101010100111000011;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 14;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[14])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[14]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 134;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[134])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[134]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 178;
    ctrl = 12;
    data15 = 120'b000000000000000000000000001100011010110111100101101110011101101001111111100001101111001001100110010001111110111001111001;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 78;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[78])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[78]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 198;
    ctrl = 13;
    data15 = 120'b000000000000000010100101101000011111010100111011100101100111000000111110011000111001100100110101011000000001010000110110;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 115;
    ctrl = 10;
    data15 = 120'b000000000000000000000000000000000000000001000101100010001111001010110110011001000000000000011101111101100000010011001110;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 169;
    ctrl = 12;
    data15 = 120'b000000000000000000000000000110000101101001100100101100010001100001011111110001011010001010101011000111110110101001001101;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 43;
    ctrl = 6;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000011010011011001010110101110110010111111001011001;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 27;
    ctrl = 12;
    data15 = 120'b000000000000000000000000100011111111001000000110011010011001000000010011010001111100100101100111100100101110010010000111;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 122;
    ctrl = 13;
    data15 = 120'b000000000000000000111011100000000110000001010100001011000100101111100101001001001000001111100101000100011001101100001011;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 124;
    ctrl = 6;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000100110100010011001000000100001111110111011000010;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 101;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[101])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[101]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 50;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[50])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[50]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 155;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[155])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[155]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 193;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[193])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[193]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 50;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[50])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[50]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 10;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[10])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[10]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 152;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[152])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[152]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 52;
    ctrl = 8;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000001101000011010100000101001011110011001100110100011100111101101;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 88;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[88])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[88]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 186;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[186])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[186]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 21;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[21])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[21]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 42;
    ctrl = 3;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000111011000110110110100011;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 63;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[63])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[63]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 50;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[50])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[50]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 106;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[106])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[106]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 113;
    ctrl = 11;
    data15 = 120'b000000000000000000000000000000000111110000101111100101010111100011111100011100010000011001011001111010101001111001111111;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 255;
    ctrl = 13;
    data15 = 120'b000000000000000010000001100001100000011100110100110010000011000010101110111000100010110111111000111000011010010010111000;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 155;
    ctrl = 11;
    data15 = 120'b000000000000000000000000000000000001111011011110110010010111000011101110010111001000000101000010011100011010001000100000;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 109;
    ctrl = 11;
    data15 = 120'b000000000000000000000000000000001010011101100001000010100101100111011100101100110010101001011011001111110110001010001100;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 175;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[175])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[175]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 137;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[137])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[137]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 96;
    ctrl = 4;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000010111010110010111010110101;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 104;
    ctrl = 9;
    data15 = 120'b000000000000000000000000000000000000000000000000000101011101011101010110000001010011110111100010010110111111000111010011;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 200;
    ctrl = 10;
    data15 = 120'b000000000000000000000000000000000000000001001111111101001110001010000101110101000010110101001111111011111110100010110111;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 3;
    ctrl = 1;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000001;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 120;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[120])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[120]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 209;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[209])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[209]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 174;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[174])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[174]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 177;
    ctrl = 5;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000000100101000111101100111000111000110011001;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 177;
    ctrl = 8;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000111010000011010001000101111010011001110101110000100011101111;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 37;
    ctrl = 13;
    data15 = 120'b000000000000000010001010010111111100110101100101011100010100111111010100100100100000001010111010011100101101010101000010;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 148;
    ctrl = 3;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010111010010000101101010;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 80;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[80])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[80]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 113;
    ctrl = 6;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000100110111000001011011000010110001100100011010110;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 195;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[195])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[195]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 54;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[54])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[54]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 216;
    ctrl = 13;
    data15 = 120'b000000000000000010101111110111100111110011101000001111001110100001101100011110011101100010010101000010011110111100110110;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 77;
    ctrl = 11;
    data15 = 120'b000000000000000000000000000000000101001110110000100001100000000000101011011000100010010011010000101001001101000111001100;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 49;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[49])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[49]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 177;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[177])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[177]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 106;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[106])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[106]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 49;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[49])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[49]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 208;
    ctrl = 15;
    data15 = 120'b000110101111010111101100101101101011100111111001101001100101111110101100000010000101001001010110101000011110011111110100;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 65;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[65])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[65]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 50;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[50])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[50]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 169;
    ctrl = 4;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010101100100010010101110010011011;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 92;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[92])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[92]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 178;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[178])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[178]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 17;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[17])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[17]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 149;
    ctrl = 13;
    data15 = 120'b000000000000000010100011101100001000000101000110110011101000111100010000010111011011110101100100110111000010010010011011;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 169;
    ctrl = 10;
    data15 = 120'b000000000000000000000000000000000000000000011101000101011110001010010010111001010110001101010011000111010101101011111011;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 232;
    ctrl = 15;
    data15 = 120'b110110110100010111101010011111100101100111100101001011101010101111010110010000100101101011011101000100100000101111101110;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 71;
    ctrl = 3;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010100001001101000001101;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 103;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[103])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[103]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 184;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[184])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[184]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 124;
    ctrl = 4;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011110011011101101100101101001000;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 68;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[68])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[68]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 119;
    ctrl = 3;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000111011000101101110011101;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 121;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[121])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[121]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 214;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[214])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[214]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 193;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[193])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[193]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 213;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[213])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[213]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 172;
    ctrl = 3;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000001000110111100;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 176;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[176])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[176]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 31;
    ctrl = 2;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001001010001100010;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 200;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[200])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[200]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 204;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[204])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[204]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 249;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[249])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[249]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 96;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[96])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[96]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 188;
    ctrl = 15;
    data15 = 120'b011011111101110001010010111100000011111100000011011001010100100100011001000010001001111101001111001001100001111101000101;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 175;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[175])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[175]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 145;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[145])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[145]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 46;
    ctrl = 10;
    data15 = 120'b000000000000000000000000000000000000000001111110111000100101010101100111110111001011111011000010011110111000111100101110;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 120;
    ctrl = 10;
    data15 = 120'b000000000000000000000000000000000000000011001111010000010010011000101001111100001110110101110101011001000011101011010001;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 46;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[46])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[46]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 242;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[242])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[242]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 249;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[249])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[249]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 232;
    ctrl = 2;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100001011001000;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 13;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[13])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[13]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 100;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[100])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[100]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 74;
    ctrl = 3;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000110111001000000000001011;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 230;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[230])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[230]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 192;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[192])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[192]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 218;
    ctrl = 4;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000110011011111101111111101110;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 252;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[252])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[252]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 95;
    ctrl = 2;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000110100110110;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 157;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[157])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[157]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 159;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[159])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[159]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 255;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[255])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[255]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 147;
    ctrl = 1;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010001110;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
    
    CMD_RCVD = 1;
    rw = 0;
    addr = 238;
    ctrl = 1;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    if (answer == memory[238])begin
        $display("the answer was correct: %d",answer);
        end
    else
        begin
        $display("the answer was INCORRECT!!");
        $display("tb memory: %d",memory[238]);
        $display("answer given: %d",answer);
        end
        
        
    
    CMD_RCVD = 1;
    rw = 1;
    addr = 224;
    ctrl = 5;
    data15 = 120'b000000000000000000000000000000000000000000000000000000000000000000000000000000000101010011110001001011000001100000111101;
    #(2*CLK_PERIOD) CMD_RCVD = 0;
    #2000
    for (i = 0; i < ctrl; i = i + 1) begin
        if(addr+i<=255) begin
            memory[addr+i] = data15[i*8 +: 7];
        end
    end
    
end


endmodule
