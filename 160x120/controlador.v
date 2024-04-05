//----------------------------------------------------------------------
// Controlador VGA usando uma memoria, resolucao de 160x120 pixels
// Autor: Joao Victor Carvalho
//
// A saida da imagem tem 640x480 pixels mas a resolucao tem apenas 160x120 
// isso e feito repetindo pixels
//
// por uma questao de clareza os intervalos sao sempre representados 
// incluindo seus extremos
//
// o divisor de clock e provido por uma biblioteca da Altera
//----------------------------------------------------------------------


//---------------------------------------------------------------------
// informacoes sobre as janelas de tempo horizontais:
//
// 0 a 95 reservado para sincronizacao 
// 96 a 144 reservado para front porch horizontal
// 145 a 783 reservado para a imagem
// 784 a 799 reservado para back porch horizontal
//----------------------------------------------------------------------
// informacoes sobre as janelas de tempo verticais:
//
// 0 a 1 reservado para a sincronizacao
// 2 a 35 reservado para front porch vertical
// 36 a 514 reservado para a imagem
// 515 a 525 reservado para back porch vertical
//----------------------------------------------------------------------



module controlador(
	input clk,   // 50 MHz

    //valores de saida VGA
	output hsync,             // sinal de sincronizacao horizontal
	output vsync,	            // sinal de sincronizacao vertical
	output [3:0] red,         // cor vermelha
	output [3:0] green,       // cor verde
    output [3:0] blue         // cor azul
);
    //fios relevantes
    wire readmem;               //indica quando tem ou nao imagem
    wire [11:0] entrada_cor;    //conecta cores com a memoria

    //registradores de endereco
    reg [14:0] RAM_addr;    //endereco total da memoria
    reg [7:0]  addr_x;       //parcela horizontal da memoria
    reg [14:0] addr_y;      //parcela vertical da memoria

    //registradores para a posicao
    reg [9:0] cont_x = 0 ;  //posicao horizontal do canhao na tela
    reg [9:0] cont_y = 0;   //posicao vertical do canhao na tela 
	
    //instaciacao da memoria
    syncram_19200x12 mem(
        .clk(clk),
        .we(1'b0),
        .data_i(12'b000000000000),
        .addr(RAM_addr),
        .data_o(entrada_cor)
    );

//----------------------------------------------------------------------
// Divisor de Clock
//----------------------------------------------------------------------

    //sinais para divisor de clock
    reg reset = 0;
	wire clk25MHz;

	//instanciacao do divisor de clock
    //transforma o clock de 50MHz em 25MHz
	ip ip1(
		.areset(reset),
		.inclk0(clk),
		.c0(clk25MHz),
		.locked()
		);

    // o divisor de clock nao foi feito por mim, eh de autoria da Altera

//----------------------------------------------------------------------
// Parte Assincrona
//----------------------------------------------------------------------

	always @(posedge clk25MHz) begin

        //Contador Horizontal
        if (cont_x < 799)
            cont_x <= cont_x + 1;
        else
            cont_x <= 0;

        //Contador Vertical
        if (cont_x == 799) begin
            if (cont_y < 525)
                cont_y <= cont_y + 1;
            else
                cont_y <= 0;
        end

        //Endereco horizontal
        if (cont_x>= 145 && cont_x <= 783) begin
            if(cont_x[0] == 0 && cont_x[1] == 1)
                addr_x <= addr_x + 1;
        end
        if (cont_x == 0|| cont_x == 784) begin
            addr_x <= 0;
        end

        //Endereco vertical
        if (cont_y >= 36 && cont_y <= 514) begin
            if (cont_x == 784) begin
                if (cont_y[0] == 0 && cont_y[1] == 0)
                    addr_y <= addr_y + 160; 
            end
        end
        if (cont_y == 515 || cont_y == 0) begin
            addr_y <= 0;
        end

        //Enederecos juntos
        //eh importante notar que as somas comecam um clock adiantadas
        if ((cont_y >= 36 && cont_y <= 514) && (cont_x >= 144 && cont_x <= 783)) begin
            RAM_addr <= addr_x + addr_y;
        end else begin
            RAM_addr <= 0;
	    end

    end


//----------------------------------------------------------------------
// PARTE SINCRONA
//----------------------------------------------------------------------

    // gerando as saidas de sincronizacao
    assign hsync = (cont_x >= 0 && cont_x <= 95) ? 1:0;  // hsync fica em alto de 0 a 95
    assign vsync = (cont_y >= 0 && cont_y <= 1) ? 1:0;   // hsync fica em alto de 0 a 1

    //'trava' de saida
    // a imagem so deve ser transmitida no produto cartesiano: [145, 783] X [36, 514]
    assign readmem = ((cont_x >= 145 && cont_x <= 783) && (cont_y >= 36 && cont_y <= 514)) ? 1:0;

    //atribuicao das saidas de cor
    //fora da regiao da imagem os sinais de cor DEVEM ser 0
    assign blue   [3:0] = readmem ? entrada_cor [3:0]     : 4'b0000;
    assign green  [3:0] = readmem ? entrada_cor [7:4]     : 4'b0000;
    assign red    [3:0] = readmem ? entrada_cor [11:8]    : 4'b0000;
    
endmodule
