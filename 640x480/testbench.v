`timescale 1ns/1ns

module testbench;

  // Definicao de constantes
  parameter CLK_PERIOD = 40; // Periodo de Clock em nano segundos

  // Declaracao de sinais
    	reg clk;
  	wire o_hsync;       // sincronizacao horizontal
	wire o_vsync;	    // sincronizacao vertical
	wire [3:0] o_red;   // cor vermelha
	wire [3:0] o_green; // cor verde
    	wire [3:0] o_blue;  // cor azul;

  // Instanciacao do DUT
 controlador dut (
    	.clk(clk),
    	.o_hsync(o_hsync),          // sincronizacao horizontal
	.o_vsync(o_vsync),	        // sincronizacao vertical
	.o_red(o_red),              // cor vermelha
	.o_green(o_green),          // cor verde
    	.o_blue(o_blue)             // cor azul
);

  // Geracao do clock
  always #((CLK_PERIOD/2)) clk = ~clk;

  // Geracao de estimulo
  initial begin
    // inicia o clock
    clk = 1;

    // loop do Testbench
    repeat (200) begin
      #CLK_PERIOD;
    end
  end
endmodule
