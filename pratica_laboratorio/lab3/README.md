# Experimento 3: Processador para Cálculo de Média de Vetor (Projeto RTL com Memória ROM)

**Universidade de Brasília (UnB) – Campus Gama (FGA)**

**Professor:** Gilmar Beserra

## Descrição do Projeto

Este projeto consiste no projeto, especificação e implementação em Hardware (FPGA) de um processador digital em arquitetura RTL (Register-Transfer Level) para calcular a média aritmética de 16 elementos de 16 bits armazenados em uma memória ROM assíncrona ($16 \times 16$ bits).

O sistema é dividido em um **Bloco Operacional** (Datapath com registradores, somador, deslocador rígido e gerador de endereços) e um **Bloco de Controle** (FSM), utilizando um arquivo `.coe` gerado no IP Catalog do Vivado para inicializar o conteúdo da memória. O resultado final do cálculo é exibido nos displays de 7 segmentos da placa FPGA.

```
                  +-----------------------------------+
        start --->|                                   |---> ready
                  |   Processador RTL para Cálculo   |
                  |       de Média em Memória         |===> média (16 bits)
 M_dados (16 bits)==|   (Interface com Memória ROM)     |===> M_end (4 bits)
                  +-----------------------------------+

```

## Especificação do Sistema

### Entrada e Saídas (I/O)

* **Controle de Início (`start` - 1 bit):**

  * Entrada ativada via botão (*Push Button*) ou chave (*Switch*) que dispara o ciclo de leitura da memória e processamento da média.

* **Sinal de Conclusão (`ready` - 1 bit):**

  * Saída indicando que o cálculo foi finalizado e o valor da média está disponível para leitura. Mapeado em um LED.

* **Interface com Memória ROM:**

  * **`M_end` (4 bits):** Endereço gerado pelo datapath para selecionar a posição da memória ($i + 25$).

  * **`M_dados` (16 bits):** Dado de 16 bits fornecido pela memória ROM assíncrona imediatamente após a atualização do endereço.

* **Saída Média (`média` - 16 bits):**

  * Valor final calculado correspondente à soma acumulada dividida por 16 (deslocamento de 4 bits à direita: `>>4`). Exibido nos displays de 7 segmentos.

## Funcionamento

1. **Estrutura Arquitetural (Bloco de Controle + Bloco Operacional):**

   * **Bloco Operacional (Datapath):**
     * Registrador de índice `i` com sinais `i_ld` e `i_clr`, incrementador (`+1`) e comparador (`i_lt16`) para verificação de limite do laço ($i < 16$).
     * Gerador de endereço de memória: $M\_end = i + 25$.
     * Registrador de dados `a` com `a_ld` e `a_clr` para ler $M\_dados$.
     * Registrador acumulador `soma` com `s_ld` e `s_clr` conectado a um somador de 16/20 bits ($soma + a$).
     * Operador de deslocamento rígido (`>>4`) para realizar a divisão inteira por 16.
     * Registrador de saída `média` com `média_ld` e `média_clr`.

   * **Bloco de Controle (FSM):**
     * Controla os sinais de habilitação (`*_ld`) e limpeza (`*_clr`) dos registradores, iterando pelos 16 elementos da ROM até que $i < 16$ torne-se falso ($i\_lt16 = 0$).

2. **Cálculo e Ciclos de Clock:**

   * A cada iteração do laço, a FSM acessa o endereço da ROM, armazena o dado no registrador `a`, acumula a soma no registrador `soma` e incrementa o ponteiro `i`.
   * Após 16 iterações, o valor contido no registrador `soma` passa pelo deslocador de 4 bits à direita (`>>4`), e o resultado é armazenado no registrador `média`, acionando a saída `ready = 1`.

## Etapas do Desenvolvimento

* [x] **Análise e Esboço da FSM:** Descrição textual e diagramação da FSM e Datapath, calculando a quantidade exata de ciclos de clock para processar os 16 elementos.

* [x] **Geração do IP de Memória ROM:** Criação da ROM assíncrona $16 \times 16$ no IP Catalog do Vivado, inicializada com o arquivo de coeficientes (`.coe`) contendo dados aleatórios de 16 bits.

* [x] **Codificação VHDL do Bloco Operacional:** Implementação em VHDL do Datapath (registradores, somadores, deslocador e comparador).

* [x] **Codificação VHDL do Bloco de Controle:** Implementação da FSM em VHDL para orquestrar o sequenciamento dos sinais do Datapath.

* [x] **Integração do Top-Level & Simulação:** Conexão dos blocos (Controle, Operacional e Memória ROM) e validação funcional completa via Testbench.

* [x] **Mapeamento de Pinos (`.xdc`):** Associação do sinal `start` a botão/chave, saída `ready` a LED e resultado `média` aos displays de 7 segmentos.

* [x] **Síntese, Análise RTL e Implementação:** Análise do esquemático RTL, checagem de timing/caminho crítico e geração do arquivo `.bit` (bitstream).

* [x] **Validação em Hardware:** Demonstração do funcionamento prático na placa FPGA Basys3.

## Ferramentas Utilizadas

* **Linguagem de Descrição de Hardware:** VHDL

* **Ambiente de Desenvolvimento / Síntese:** Xilinx Vivado (IP Catalog / RTL Analysis)

* **Placa de Desenvolvimento FPGA:** Xilinx Basys 3 (Artix-7)
