module tb_strings;

  string message = "Merhaba, dunya!";
  string extra_info;

  initial begin
    extra_info = "SystemVerilog";

    message = {message, "\n", extra_info};

    $display("Message : %0s", message);
    $display("Message : %0s", message.toupper());
    $display("Message : %0s", message.tolower());
    message.putc(2, "Z");
    $display("Message : %0s", message.getc(2));

  end
endmodule
