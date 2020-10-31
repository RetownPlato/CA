//========================================================================
// Integer Multiplier Fixed-Latency Implementation
//========================================================================

`ifndef LAB1_IMUL_INT_MUL_BASE_V
`define LAB1_IMUL_INT_MUL_BASE_V

`include "lab1-imul-msgs.v"
`include "vc-trace.v"
`include "vc-muxes.v"
`include "vc-regs.v"
`include "vc-arithmetic.v"



//======================================================================
// Datapath
//======================================================================
module lab1_imul_IntMulBaseDpath
(
  input  logic                clk,
  input  logic                reset,
 
  // Data signals

  input  lab1_imul_req_msg_t  req_msg,
  input  lab1_imul_resp_msg_t resp_msg,

  // Control signals 
  input  logic                a_reg_en,
  input  logic                b_reg_en,
  input  logic                a_mux_sel,
  input  logic                b_mux_sel,
  input  logic                result_reg_en,
  input  logic                add_mux_sel,
  input  logic                result_mux_sel,
  
  // Data signals
  output logic               b_lsb
)  
  localparam c_nbits = 32;
  
  // A Mux
  
  logic [c_nbits-1:0] a_mux_out;
  logic [c_nbits-1:0] a_lls_out;
    
  vc_Mux2#(c_nbits) a_mux
  (
    .sel   (a_mux_sel),
    .in0   (req_msg.a),
    .in1   (a_lls_out),
    .out   (a_mux_out)
  );
  
  // A register
  
  logic [c_nbits-1:0] a_reg_out;
  
  vc_EnReg#(c_nbits) a_reg
  (
   .clk    (clk),
   .reset  (reset),
   .en     (a_reg_en),
   .d      (a_mux_out),
   .q      (a_reg_out)
  );
  
  // B Mux
  
  logic [c_nbits-1:0] b_rls_out;
  logic [c_nbits-1:0] b_mux_out;
  
  vc_Mux2#(c_nbits) b_mux
  (
    .sel   (b_mux_sel),
    .in0   (req_msg.b),
    .in1   (b_rls_out),
    .out   (b_mux_out)
  );
  
  // B register
  
  logic [c_nbits-1:0] b_reg_out;
  
  vc_EnReg#(c_nbits) b_reg
  (
   .clk    (clk),
   .reset  (reset),
   .en     (b_reg_en),
   .d      (b_mux_out),
   .q      (b_reg_out)
  );
  
  // Result Mux
  
  logic [c_nbits-1:0] add_mux_out;
  
  vc_Mux2#(c_nbits) result_mux
  (
    .sel   (result_mux_sel),
    .in0   (add_mux_out),
    .in1   (32'b0),
    .out   (result_mux_out)
  );
  
  // Result register
  
  logic [c_nbits-1:0] result_reg_out;
  
  vc_EnReg#(c_nbits) result_reg
  (
   .clk    (clk),
   .reset  (reset),
   .en     (result_reg_en),
   .d      (result_mux_out),
   .q      (result_reg_out)
  );
  
  // A LeftLogicalShifter
  
  vc_LeftLogicalShifter
  #(c_nbits,
    1'b1
  )(
    .in    (a_reg_out),
    .shamt (1'b1),
    .out   (a_lls_out)
  );
  
  assign b_lsb = b_reg_out[0];
  
  // B RightLogicalShifter
  
  vc_RightLogicalShifter
  #(
    c_nbits,
    1'b1
  )(
    .in    (b_reg_out),
    .shamt (1'b1),
    .out   (b_rls_out)
  );
  
  // Adder
  
  logic [c_nbits-1:0] adder_out;
  
  vc_SimpleAdder
  #(
    c_nbits
   )(
   .in0    (a_reg_out),
   .in1    (result_reg_out),
   .out    (adder_out)
   )
   
  // Add Mux
  
  vc_Mux2#(c_nbits) add_mux
  (
    .sel   (add_mux_sel),
    .in0   (adder_out),
    .in1   (result_reg_out),
    .out   (add_mux_out)
  );
  
  assign resp_msg = result_reg_out;
     
endmodule


//========================================================================
// Integer Multiplier Fixed-Latency Implementation
//========================================================================

module lab1_imul_IntMulBase
(
  input  logic                clk,
  input  logic                reset,

  input  logic                req_val,
  output logic                req_rdy,
  input  lab1_imul_req_msg_t  req_msg,

  output logic                resp_val,
  input  logic                resp_rdy,
  output lab1_imul_resp_msg_t resp_msg
);

  //----------------------------------------------------------------------
  // Trace request message
  //----------------------------------------------------------------------

  lab1_imul_ReqMsgTrace req_msg_trace
  (
    .clk   (clk),
    .reset (reset),
    .val   (req_val),
    .rdy   (req_rdy),
    .msg   (req_msg)
  );

  // Instantiate datapath and control models here and then connect them
  // together. As a place holder, for now we simply pass input operand
  // A through to the output, which obviously is not correct.



  //----------------------------------------------------------------------
  // Line Tracing
  //----------------------------------------------------------------------

  `ifndef SYNTHESIS

  reg [`VC_TRACE_NBITS_TO_NCHARS(32)*8-1:0] str;

  `VC_TRACE_BEGIN
  begin

    req_msg_trace.trace( trace_str );

    vc_trace.append_str( trace_str, "(" );

    // Add extra line tracing for internal state here

    vc_trace.append_str( trace_str, ")" );

    $sformat( str, "%x", resp_msg );
    vc_trace.append_val_rdy_str( trace_str, resp_val, resp_rdy, str );

  end
  `VC_TRACE_END

  `endif /* SYNTHESIS */

endmodule

`endif /* LAB1_IMUL_INT_MUL_BASE_V */

