module stream_source #(
  parameter DW = 8,          // data width
  parameter FN = "dat.hex",  // data file name
  parameter DN = 16,          // data file length
  parameter RND = 50         // ready probability in %
)(
  //system signals
  input               clk,
  input               rst,

  //stream signals
  output reg          vld,
  output [DW-1:0]     dat,
  input wire          rdy
);

wire                  trn;              //data transfer
reg [DW-1:0]          mem [0:DN-1];     //ram
integer               cnt;

integer               seed;

assign trn=vld & rdy;


initial begin
  $readmemh(FN,mem);
  seed=0;
end


always @(posedge clk, posedge rst)
if (rst) begin
  vld <= 0;
  cnt <= 0;
end else begin
  vld <= ($dist_uniform(seed, 0, 99) > RND);
  cnt <= cnt + trn;
end

assign dat = mem[cnt];


endmodule

