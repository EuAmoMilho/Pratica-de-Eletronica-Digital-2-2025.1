# Experimento 4: Aplicações Multiprocessadas e Interrupções com PicoBlaze

**Universidade de Brasília (UnB) – Campus Gama (FGA)**

**Professor:** Gilmar Beserra

## Descrição do Projeto

Este laboratório aborda o projeto e implementação de sistemas baseados no microprocessador **PicoBlaze (KCPSM6)** em FPGA (Basys 3), dividindo-se em dois projetos práticos:

1. **Projeto 1 (Multiprocessamento/Dual-Core):** Instanciação de dois microcontroladores PicoBlaze atuando de forma independente. O **PicoBlaze 1** executa a soma de duas entradas de 8 bits e converte o resultado para BCD em displays de 7 segmentos. O **PicoBlaze 2** gerencia a rotação de padrões de bits nos LEDs com controle de velocidade, padrão e direção via chaves.
2. **Projeto 2 (Interrupções em Hardware):** Utilização de um único PicoBlaze em conjunto com um temporizador (*Timer*) em hardware. O processador calcula a multiplicação de duas entradas de 8 bits (exibida nos displays de 7 segmentos) enquanto trata interrupções periódicas geradas pelo *Timer* a cada 0,5s, incrementando um contador de interrupções exibido nos 16 LEDs.

```
+---------------------------------------------------------------------------------------+
|                                    PROJETO 1 (DUAL-CORE)                              |
|                                                                                       |
|   sw[15:8] sw[7:0]                                           sw[12:8]                 |
|       |       |                                                  |                    |
|       v       v                                                  v                    |
|  +-----------------+                                    +-----------------+           |
|  |   PicoBlaze 1   |                                    |   PicoBlaze 2   |           |
|  |  (Somador BCD)  |                                    | (Efeito de LEDs)|           |
|  +-----------------+                                    +-----------------+           |
|           |                                                      |                    |
|           v                                                      v                    |
|   Displays 7 Seg.                                            leds[7:0]                |
+---------------------------------------------------------------------------------------+

+---------------------------------------------------------------------------------------+
|                                  PROJETO 2 (INTERRUPÇÃO)                              |
|                                                                                       |
|                                     +--------------+                                  |
|                                     | Hardware     |                                  |
|                                     | Timer (0.5s) |                                  |
|                                     +--------------+                                  |
|                                            |                                          |
|   sw[15:8] sw[7:0]                         | interrupt                                |
|       |       |                            v                                          |
|       v       v                    +---------------+                                  |
|  +-----------------+               |   PicoBlaze   |                                  |
|  | Multiplicador   |               |  (Tratador de |                                  |
|  |    de 8 bits    |               |  Interrupção) |                                  |
|  +-----------------+               +---------------+                                  |
|           |                                |                                          |
|           v                                v                                          |
|   Displays 7 Seg.                      leds[15:0]                                     |
|  (Resultado Mult.)               (Contador Interrupções)                              |
+---------------------------------------------------------------------------------------+
```

## Especificação do Sistema

### Projeto 1: Mapeamento de E/S

* **PicoBlaze 1 (Soma & BCD):**
  * **Entradas (`sw[7:0]` e `sw[15:8]`):** Dois operandos de 8 bits cada.
  * **Saídas:** Displays de 7 segmentos exibindo a soma tratada e convertida em BCD.

* **PicoBlaze 2 (Rotação de LEDs):**
  * **Entradas (`sw[12:8]` / 5 bits total):**
    * **`sw[9:8]` (Padrão - 2 bits):** `00` ("00000001"), `01` ("00000011"), `10` ("00001111"), `11` ("00001101").
    * **`sw[10]` (Direção - 1 bit):** `0` = Esquerda, `1` = Direita.
    * **`sw[12:11]` (Velocidade - 2 bits):** `00` = 1 Hz, `01` = 2 Hz, `10` = 4 Hz, `11` = 8 Hz.
  * **Saídas (`leds[7:0]`):** Animação do padrão selecionado na frequência e direção configuradas.

### Projeto 2: Mapeamento de E/S e Interrupção

* **Entradas (`sw[7:0]` e `sw[15:8]`):** Dois operandos de 8 bits para multiplicação.
* **Entrada de Interrupção (`interrupt`):** Sinal gerado por temporizador em VHDL com estouro a cada 0,5 segundo.
* **Saídas:**
  * **Displays de 7 Segmentos:** Resultado de 16 bits da multiplicação.
  * **LEDs (`leds[15:0]`):** Contador binário de 16 bits incrementado a cada chamada do ISR (Rotina de Serviço de Interrupção).

## Funcionamento

### Projeto 1: Dual-Core Independente

1. **PicoBlaze 1:** Realiza a leitura contínua das entradas de chaves, soma os valores e aplica o algoritmo de conversão Binário para BCD (como o *Double Dabble*) para exibição decimal nos displays.
2. **PicoBlaze 2:** Analisa os seletores de controle (`sw[12:8]`), carrega o padrão de bits correspondente na memória/registrador e executa rotacionamento lógico de bits com tempos de atraso (*delays*) ajustados dinamicamente para bater com as frequências desejadas (1 Hz a 8 Hz).

### Projeto 2: Multiplicação com Interrupção

1. **Loop Principal (Background):** Leitura contínua das chaves `sw[15:8]` e `sw[7:0]`, realização da rotina de multiplicação de 8x8 bits em software e atualização contínua do display de 7 segmentos.
2. **Tratamento de Interrupção (ISR):**
   * A cada 0,5s o temporizador em hardware força o sinal `interrupt = '1'`.
   * O PicoBlaze suspende a execução atual, atende à interrupção, incrementa o registrador acumulador do contador e atualiza `leds[15:0]`.
   * Retorna ao loop principal (`RETURNI ENABLE`) sem corromper as variáveis da multiplicação.

## Etapas do Desenvolvimento

* [x] **Desenvolvimento Assembly (.psm):** Codificação das rotinas para PicoBlaze 1, PicoBlaze 2 e o manipulador de interrupções.
* [x] **Simulação em Software:** Validação lógica das instruções e rotinas de tempo via pBlazeIDE.
* [x] **Geração de Memórias ROM:** Compilação dos arquivos `.psm` com o `kcpsm6.exe` gerando os módulos VHDL contendo o código executável.
* [x] **Módulo Timer em VHDL:** Criação do divisor de clock/temporizador para pulsos de 0,5s.
* [x] **Integração Top Level:** Instanciação e interconexão dos blocos operacionais, controladores e E/S em VHDL.
* [x] **Mapeamento de Pinos (`.xdc`):** Atribuição das chaves, LEDs e barramentos dos displays aos pinos da FPGA Basys 3.
* [x] **Síntese, Implementação e Bitstream:** Compilação no Vivado e teste nos kits do laboratório.

## Ferramentas Utilizadas

* **Linguagem de Descrição de Hardware:** VHDL
* **Linguagem de Montagem:** Assembly KCPSM6 (PicoBlaze)
* **Ambiente de Simulação Assembly:** pBlazeIDE
* **Ambiente de Desenvolvimento / Síntese:** Xilinx Vivado
* **Placa de Desenvolvimento FPGA:** Digilent Basys 3 (Artix-7)
