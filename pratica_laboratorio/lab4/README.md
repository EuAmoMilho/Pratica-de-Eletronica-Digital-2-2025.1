# Tutorial e Implementação do Microprocessador PicoBlaze (KCPSM6)

**Universidade de Brasília (UnB) – Campus Gama (FGA)**

**Professor:** Gilmar Beserra

## Descrição do Projeto

Este projeto consiste na instanciação, configuração e execução do microprocessador embedded **PicoBlaze (KCPSM6)** em uma placa FPGA Xilinx (Basys 3). 

O sistema utiliza um código em linguagem Assembly (.psm) compilado para uma memória ROM de instruções em VHDL, integrada a um módulo *Top Level*. O programa lê o estado de 8 chaves de entrada, realiza operações lógicas/aritméticas de manipulação de bits e exibe o resultado processado em 8 LEDs.

## Especificação do Sistema

### Mapeamento de Portas de E/S (Assembly/Hardware)

* **Entradas (`switches` - Endereço `01h`):**
  * Leitura do vetor de 8 bits fornecido pelas chaves da placa.
  * Mapeado para o registrador `s0` via instrução `INPUT s0, SWITCHES`.

* **Saídas (`leds` - Endereço `02h`):**
  * Escrita do vetor de 8 bits nos LEDs através do barramento de saída `out_port`.
  * Atualizado via instrução `OUTPUT s1, LEDS` quando qualificado por `write_strobe` e `port_id`.

### Operação Lógica do Código Assembly

1. **Leitura:** Armazena o valor das chaves em `s0`, duplicando-o nos registradores `s1` e `s2`.
2. **Máscara (AND):**
   * `s1` retém os bits `[2:0]` (`07h` / `0000 0111`).
   * `s2` retém os bits `[5:3]` (`38h` / `0011 1000`).
3. **Deslocamento (Shift):** Aplica três instruções `SR0` (Shift Right with 0) em `s2`, movendo os bits `[5:3]` para as posições `[2:0]`.
4. **Soma & Exibição:** Executa `ADD s1, s2` e envia o resultado para os LEDs (`OUTPUT s1, LEDS`).
5. **Loop Infinito:** Salta de volta para a rotina via `JUMP soma`.

## Fluxo de Trabalho e Compilação

1. **Escrita em Assembly:** Criação do arquivo de código fonte `.psm` com as instruções do KCPSM6.
2. **Assembler (KCPSM6.exe):** Processamento do `.psm` e do arquivo de gabarito `ROM_form.vhd` para gerar a memória de instruções sintetizável `.vhd` (ex: `somador.vhd`).
3. **Integração no Vivado:**
   * Instanciação dos componentes `kcpsm6` e `somador` no arquivo de *Top Level*.
   * Criação dos processos de decodificação de endereços de porta para `in_port` e `out_port`.

## Etapas do Desenvolvimento

* [x] **Escrita do Código Assembly (.psm):** Implementação da rotina de manipulação de bits e soma.
* [x] **Geração da ROM de Instruções:** Compilação do arquivo `.psm` via `kcpsm6.exe` gerando o arquivo `.vhd`.
* [x] **Projeto Top Level VHDL:** Instanciação do processador e da ROM com interconexão de sinais.
* [x] **Lógica de Leitura/Escrita de Portas:** Implementação dos processos `input_ports` e `output_ports`.
* [x] **Mapeamento de Pinos (`.xdc`):** Associação dos sinais `clk`, `switches` e `leds` à FPGA Basys 3.
* [x] **Síntese, Implementação e Bitstream:** Geração do arquivo de programação.
* [x] **Validação em Hardware:** Teste do fluxo completo de execução no kit de desenvolvimento.

## Ferramentas Utilizadas

* **Linguagem de Montagem / HDL:** Assembler KCPSM6 / VHDL
* **Ambiente de Desenvolvimento / Síntese:** Xilinx Vivado
* **Processador Soft-Core:** Xilinx PicoBlaze (KCPSM6)
* **Placa de Desenvolvimento FPGA:** Digilent Basys 3 (Artix-7)
