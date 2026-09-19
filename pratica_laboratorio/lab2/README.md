# Experimento 2: Processador de Máquina de Vender Refrigerante (Projeto RTL)

**Universidade de Brasília (UnB) – Campus Gama (FGA)**

**Professor:** Gilmar Beserra

## Descrição do Projeto

Este projeto consiste no projeto, especificação e implementação em Hardware (FPGA) de uma máquina de vender refrigerantes utilizando uma arquitetura RTL (Register-Transfer Level), dividida em **Bloco de Controle** (FSM) e **Bloco Operacional** (Datapath).

O sistema gerencia o acúmulo do valor de moedas inseridas pelo usuário, compara esse valor acumulado com o custo total configurado para o refrigerante e aciona a liberação do produto assim que o saldo atinge ou ultrapassa o preço exigido, mantendo em memória qualquer valor em excesso.

```
                    +------------------------------------+
              c --->|                                    |---> d
       s (8 bits) ==|   Processador da Máquina de       |
       a (8 bits) ==|     Fornecer Refrigerante          |
                    +------------------------------------+

```

## Especificação do Sistema

### Entrada e Saída (I/O)

* **Detecção de Moeda (`c` - 1 bit):**

  * Entradas acionadas via botão (*Push Button*). Nível lógico `'1'` indica a inserção de uma moeda durante 1 ciclo de clock.

* **Valor da Moeda (`a` - 8 bits):**

  * Vetor de 8 bits configurado via chaves (*Switches*), indicando o valor numérico da moeda inserida.

* **Preço do Refrigerante (`s` - 8 bits):**

  * Vetor de 8 bits configurado via chaves (*Switches*), indicando o custo necessário para comprar 1 refrigerante.

* **Dispensa do Refrigerante (`d` - 1 bit):**

  * Sinal de saída que permanece em nível lógico `'1'` durante 1 ciclo de clock quando o valor acumulado é maior ou igual a `s`. Mapeado em um LED.

* **Displays de 7 Segmentos:**

  * Utilizados para a exibição multiplexada dos valores correntes de `s` (custo) e `a` (moeda inserida).

## Funcionamento

1. **Estrutura Arquitetural (Bloco de Controle + Bloco Operacional):**

   * **Bloco Operacional (Datapath):** Contém um registrador local de 8 bits (`tot`) com sinais de carga (`tot_ld`) e limpeza (`tot_clr`), um somador de 8 bits ($tot + a$) e um comparador de 8 bits que produz o sinal interno `tot_lt_s` ($tot < s$).

   * **Bloco de Controle (FSM):** Gerencia as transições de estados e os sinais de controle do bloco operacional com base nos sinais externos e no resultado do comparador.

2. **Estados da FSM de Controle:**

   * **`Inicio`:** Estado inicial de reset/inicialização. Zera a saída ($d=0$) e limpa o registrador acumulador (`tot_clr = 1`).

   * **`Esperar`:** Estado de repouso e leitura. Aguarda a inserção de uma moeda ($c=1$) mantendo o saldo acumulado.

   * **`Somar`:** Ativado quando $c=1$ e o saldo acumulado ainda é insuficiente ($tot < s$). Habilita a carga no registrador (`tot_ld = 1`), somando o valor de $a$ ao registrador $tot$.

   * **`Fornecer`:** Atingido quando $c=0$ ou $c=1$ e o saldo total é maior ou igual ao custo ($tot \ge s$, ou seja, $tot\_lt\_s = 0$). Seta a saída $d=1$ durante 1 ciclo de clock para dispensar o refrigerante.

3. **Retenção de Troco / Excessos:**

   * Qualquer valor acumulado além do custo exigido $s$ é mantido no registrador `tot` para a próxima compra.

## Etapas do Desenvolvimento
   **Análise e Descrição Textual:** Descrição detalhada dos diagramas da FSM e do Bloco Operacional.

   **Codificação VHDL:** Implementação comportamental ou estrutural integrada (Top-Level, Controle e Datapath).
   
   **Simulação & Testbench:** Validação funcional das transições de estado, acúmulo de saldo e sinal de liberação $d$.
   
   **Mapeamento de Pinos (`.xdc`):** Mapeamento de `s` e `a` nas chaves, `c` no *push button*, `d` em LED e exibição nos displays de 7 segmentos.
   
   **Análise de Timing & Constraints:** Inclusão de restrições de timing (clock de 100 MHz) com identificação do caminho crítico de *setup* e *hold*.
   
   **Síntese, Implementação e Bitstream:** Geração e gravação na placa FPGA Basys3.
   
   **Validação em Hardware:** Demonstração prática do funcionamento na placa Basys3.

## Ferramentas Utilizadas

* **Linguagem de Descrição de Hardware:** VHDL

* **Ambiente de Desenvolvimento / Síntese:** Xilinx Vivado

* **Placa de Desenvolvimento FPGA:** Xilinx Basys 3 (Artix-7)
