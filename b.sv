  string message = "Merhaba, dunya!";
  string extra_info;

  initial begin
    extra_info = "SystemVerilog";
    message = {message , "\n", extra_info};
    $display("Mesajimiz: %0s", message);
    $display("Uzunluk: %0d", message.len());
    $display("toupper: %0s", message.toupper());
    $display("tolower: %0s", message.tolower());
    $display("compare: %0d", message.compare(extra_info));
    $display("compare: %0s", message.substr(2, 4));
    $display("compare: %0s", message.getc(2));
    message.putc(2, "a");
    $display("compare: %0s", message);
  end
