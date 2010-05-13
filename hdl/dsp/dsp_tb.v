module dsp_tb();


localparam DN=16;
localparam DW=16;
localparam RND=50;

//system signals
reg clk;
reg rst;

//stream signals
wire          vld;
wire [DW-1:0] dat;
wire          rdy;
integer       cnt;
wire	      trn;

assign trn = vld & rdy;

// request for a dumpfile
initial begin
  $dumpfile("dsp.vcd");
  $dumpvars(0, dsp_tb);
end

// clock generation
initial    clk <= 1'b1;
always  #5 clk <= ~clk;

// reset generation
initial begin
  rst = 1'b1;
  repeat (2) @ (posedge clk); #1;
  rst = 1'b0;
end


always @(posedge clk, posedge rst)
if(rst) begin
    cnt <= 0;
end else begin
    cnt <= cnt + trn;
end

always @(posedge clk)
if((cnt==DN))
  $finish();


stream_source#(
  .DW(DW),
  .RND(RND)
)stream_source_i(
  .clk(clk),
  .rst(rst),
  .vld(vld),
  .dat(dat),
  .rdy(rdy)
);


stream_drain#(
  .DW(DW),
  .RND(RND)
)stream_drain_i(
  .clk(clk),
  .rst(rst),
  .vld(vld),
  .dat(dat),
  .rdy(rdy)
);

endmodule