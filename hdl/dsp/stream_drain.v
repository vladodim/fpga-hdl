module stream_drain #(
  parameter DW = 8,          // data width
  parameter FN = "out.hex",  // data file name
  parameter DN = 16,          // data file length
  parameter RND = 50         // ready probability in %
)(
  //system signals
  input               clk,
  input               rst,

  //stream signals
  input               vld,
  input [DW-1:0]      dat,
  output reg          rdy
);

wire                  trn;              //data transfer
reg [DW-1:0]          mem [0:DN-1];     //ram
integer               fp;               //file pointer
integer               seed;



assign trn=vld & rdy;

initial begin
  fp=$fopen(FN,"w");
  seed=3;
end


always @(posedge clk)
if(trn) begin
  $fdisplay(fp, "%h",dat);
end


always @(posedge clk,posedge rst)
if(rst) begin
  rdy <= 0;
end else begin
  rdy <= ($dist_uniform(seed, 0, 99) > RND);
end

endmodule