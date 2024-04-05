module syncram_307200x12 #(
    parameter BINFILE = "teste.txt"
)
(
    input         clk,
    input         we,
    input  [11:0] data_i,
    input  [18:0] addr,
    output reg [11:0] data_o
);

    // Variavel RAM (armazena dados)
    reg [11:0]ram[0:307199];

    // Especifica conteudo inicial da RAM
    // a partir da leitura de arquivo usando $readmemb
    initial
    begin : INICIA_RAM
        // leitura do conteudo a partir de um arquivo
        $readmemb(BINFILE, ram);
    end


    //Escrita e leitura sincrona
    always @ (posedge clk)
    begin
        if (we) begin
            ram[addr] <= data_i;
        end
        data_o <= ram[addr];
    end

endmodule
