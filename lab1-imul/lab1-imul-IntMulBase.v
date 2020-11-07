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
  input  logic                a_mux_sel,
  input  logic                b_mux_sel,
  input  logic                result_reg_en,
  input  logic                add_mux_sel,
  input  logic                result_mux_sel,
  
  // Data signals
  output logic                b_lsb
 );
 
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
  logic [c_nbits-1:0] result_mux_out;
  
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
  )alls(
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
  )brls(
    .in    (b_reg_out),
    .shamt (1'b1),
    .out   (b_rls_out)
  );
  
  // Adder
  
  logic [c_nbits-1:0] adder_out;
  
  vc_SimpleAdder
  #(
    c_nbits
   )adder(
   .in0    (a_reg_out),
   .in1    (result_reg_out),
   .out    (adder_out)
   );
   
   
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
// Control
//========================================================================

module lab1_imul_IntMulBaseCtrl
(
  input  logic                clk,
  input  logic                reset,
  
  // Dataflow signals
  
  input  logic                req_val,
  output logic                req_rdy,
  output logic                resp_val,
  input  logic                resp_rdy,
  
  // Control signals
  
  output logic                a_reg_en,
  output logic                b_reg_en,
  output logic                result_reg_en,
  output logic                a_mux_sel,
  output logic                b_mux_sel,
  output logic                result_mux_sel,
  output logic                add_mux_sel,
  
  // Data signals
  input  logic                b_lsb
);

  //-----------------------------------------------------------------------
  // State Definitions
  //-----------------------------------------------------------------------
  
  localparam STATE_IDLE = 2'd0;
  localparam STATE_CALC = 2'd1;
  localparam STATE_DONE = 2'd2;
  
  //----------------------------------------------------------------------
  // State 
  //----------------------------------------------------------------------
  
  logic [1:0] state_reg;
  logic [1:0] state_next;
  logic [5:0] counter;
  
  always @( posedge clk ) begin
    if ( reset ) begin
      state_reg <= STATE_IDLE;
      counter <= 0;
    end
    else begin
      state_reg <= state_next;
      if ( state_reg == STATE_CALC ) begin
         counter <= counter + 1;
      end
    end
  end
  
  //----------------------------------------------------------------------
  // State Transittions
  //----------------------------------------------------------------------
  
  logic req_go;
  logic resp_go;
  logic is_calc_done;
  
  assign req_go        = req_val  && req_rdy;
  assign resp_go       = resp_val && resp_rdy;
  assign is_calc_done  = counter  == 6'd32;
  
  always @(*) begin
  
    state_next = state_reg;
    
    case ( state_reg )
      
      STATE_IDLE: if ( req_go )        state_next = STATE_CALC;
      STATE_CALC: if ( is_calc_done )  state_next = STATE_DONE;
      STATE_DONE: if ( resp_go )       state_next = STATE_IDLE;
      
    endcase
    
  end
  
  //---------------------------------------------------------------------
  // State Outputs
  //---------------------------------------------------------------------
  
  localparam a_x        = 1'dx;
  localparam a_lls      = 1'd0;
  localparam a_ld       = 1'd1;
  
  localparam b_x        = 1'dx;
  localparam b_rls      = 1'd0;
  localparam b_ld       = 1'd1;
  
  localparam add_x      = 1'dx;
  localparam add_add    = 1'd0;
  localparam add_result = 1'd1;

  localparam result_x    = 1'dx;
  localparam result_add  = 1'd0;
  localparam result_zero = 1'd1;
   
  task cs
  (
    input logic cs_req_rdy,
    input logic cs_resp_val,
    input logic cs_a_mux_sel,
    input logic cs_a_reg_en,
    input logic cs_b_mux_sel,
    input logic cs_b_reg_en,
    input logic cs_result_mux_sel,
    input logic cs_result_reg_en,
    input logic cs_add_mux_sel
  );
  begin
    req_rdy        = cs_req_rdy;
    resp_val       = cs_resp_val;
    a_reg_en       = cs_a_reg_en;
    b_reg_en       = cs_b_reg_en;
    result_reg_en  = cs_result_reg_en;
    a_mux_sel      = cs_a_mux_sel;
    b_mux_sel      = cs_b_mux_sel;
    result_mux_sel = cs_result_mux_sel;
    add_mux_sel    = cs_add_mux_sel;
  end
  endtask
  
  // Labels for Mealy transistions
   
  logic do_add;
  logic do_shift;
  
  assign do_add   = (counter < 6'd32) && (b_lsb == 1'b1);
  assign do_shift = (counter < 6'd32) && (b_lsb == 1'b0);
   
  // Set outputs using a control signal "table"
  
  always @(*) begin
    cs( 0, 0, a_x, 0, b_x, 0, add_x, 0 );
    case ( state_reg )
    //                           req resp a mux a b mux b add mux  add
    //                           rdy val  sel  en sel  en  sel     en
      STATE_IDLE:                 cs( 1, 0, a_ld,  1, b_ld,  1, add_zero, 1);
      STATE_CALC: if ( do_add   ) cs( 0, 0, a_lls, 1, b_rls, 1, add_add,  1);
             else if ( do_shift ) cs( 0, 0, a_lls, 1, b_rls, 1, add_add,  1);
      STATE_DONE:                 cs( 0, 1, a_x,   0, b_x,   0, add_x,    0);
    endcase
  end
  
  //---------------------------------------------------------------------
  // Assertions
  //---------------------------------------------------------------------
  
  `ifndef SYNTHESIS
  always @( posedge clk ) begin
    if ( !reset ) begin
      `VC_ASSERT_NOT_X( req_val );
      `VC_ASSERT_NOT_X( req_rdy );
      `VC_ASSERT_NOT_X( resp_val );
      `VC_ASSERT_NOT_X( resp_rdy );
      `VC_ASSERT_NOT_X( a_reg_en );
      `VC_ASSERT_NOT_X( b_reg_en );
      `VC_ASSERT_NOT_X( result_reg_en );
    end
  end
  `endif /* SYNTHESIS */
  

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
  
  //----------------------------------------------------------------------
  // Control and Status Signals
  //----------------------------------------------------------------------
  
  // Control signals
  
  logic                      a_reg_en;
  logic                      b_reg_en;
  logic                      result_reg_en;
  logic                      a_mux_sel;
  logic                      b_mux_sel;
  logic                      result_mux_sel;
  logic                      add_mux_sel;
  
  // Data signals
  
  logic                      b_lsb;

  //======================================================================
  // Control Unit
  //======================================================================
  
  lab1_imul_IntMulBaseCtrl ctrl
  (
    .*
  );
  
  //======================================================================
  // Datapath
  //======================================================================
  
  lab1_imul_IntMulBaseDpath dpath
  (
    .*
  );


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

