module tb_cmd_args;

  integer seed;
  reg     verbose;

  initial begin
    // Get numeric seed from command line
    if (!$value$plusargs("SEED=%d", seed)) begin
      seed = 0;  // Default seed
    end

    // Check for +VERBOSE flag
    if ($test$plusargs("VERBOSE")) begin
      verbose = 1;
      $display("Verbose mode is ON.");
    end else begin
      verbose = 0;
    end

    $display("Simulation Seed = %0d", seed);
    #10 $finish;
  end

endmodule
