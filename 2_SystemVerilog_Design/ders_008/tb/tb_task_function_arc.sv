module tb_task_function;
  /*
SystemVerilog’ta:

input parametreler: çağrının başında kopyalanır (yani "snapshot" alınır). İçeride değiştirilse bile dışarı etkisi olmaz.

output parametreler: sadece çağrı sonunda dışarıya yansıtılır.


Eğer bir task içinde bekleme (wait) varsa ve input argümanı değişirse, bu değişiklik içeride görülmez çünkü baştaki hali kopyalanmıştır.
*/

endmodule
