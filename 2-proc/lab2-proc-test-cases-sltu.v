//========================================================================
// Test Cases for sltu instruction
//========================================================================
// this file is to be `included by lab2-proc-test-harness.v


//------------------------------------------------------------------------
// Basic tests
//------------------------------------------------------------------------

task init_sltu_basic;
begin
  clear_mem;

  address( c_reset_vector );
  inst( "mfc0 r1, mngr2proc " ); init_src(  32'hffffffff );
  inst( "mfc0 r2, mngr2proc " ); init_src(  32'h00000001 );
  inst( "nop                " );
  inst( "nop                " );
  inst( "nop                " );
  inst( "nop                " );
  inst( "nop                " );
  inst( "sltu r3, r2, r1    " );
  inst( "nop                " );
  inst( "nop                " );
  inst( "nop                " );
  inst( "nop                " );
  inst( "nop                " );
  inst( "mtc0 r3, proc2mngr " ); init_sink( 32'h00000001 );
  inst( "nop                " );
  inst( "nop                " );
  inst( "nop                " );
  inst( "nop                " );
  inst( "nop                " );
  inst( "nop                " );
  inst( "nop                " );

end
endtask

// add more test vectors here

//------------------------------------------------------------------------
// Test Case: sltu basic
//------------------------------------------------------------------------

`VC_TEST_CASE_BEGIN( 1, "sltu basic" )
begin
  init_rand_delays( 0, 0, 0 );
  init_sltu_basic;
  run_test;
end
`VC_TEST_CASE_END

// add more test cases here


