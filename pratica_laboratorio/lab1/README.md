# Experimento 1: Controlador de Tráfego com FSM (Máquina de Mealy)

**Universidade de Brasília (UnB) – Campus Gama (FGA)**

**Professor:** Gilmar Beserra

## Descrição do Projeto

Este projeto consiste no projeto, especificação e implementação em Hardware (FPGA) de um controlador de tráfego para uma estrada estreita de montanha, onde só é possível a passagem de um veículo por vez.

O sistema utiliza uma **Máquina de Estados Finitos de Mealy (FSM)** para gerenciar o acesso de veículos em ambos os sentidos (Esquerda $\rightarrow$ Direita e Direita $\rightarrow$ Esquerda), priorizando a segurança, prevenindo colisões e evitando que múltiplos carros entrem simultaneamente.

```
       D6                      D2                  D3             S2 D5
 [<=] [  ] --------------------||------------------||------------- [  ] [<=]
           \ C1                                                 C2 /
 ====[S1]==========================================================[S1]====
 [=>] [  ] --------------------||------------------||------------- [  ] [=>]
       D1                      D2                  D3                D4

```

## Especificação do Sistema

### Entrada e Saída (I/O)

* **Detectores de Presença (Entradas `D1` a `D6`):**

  * Assumem nível lógico `'1'` quando um veículo é detectado.

  * `D1`, `D2`, `D3`, `D4`: Sentido Esquerda $\rightarrow$ Direita.

  * `D5`, `D3`, `D2`, `D6`: Sentido Direita $\rightarrow$ Esquerda.

* **Cancelas (Saídas `C1` e `C2`):**

  * Abrem quando em nível lógico `'1'` e fecham em `'0'`.

* **Semáforos (Saídas `S1` e `S2`):**

  * Verde quando em nível lógico `'1'` e Vermelho quando em `'0'`.

## Funcionamento

1. **Estado de Repouso (Sem tráfego):**

   * Cancelas `C1` e `C2` permanecem **fechadas** (`0`).

   * Semáforos `S1` e `S2` permanecem **vermelhos** (`0`).

2. **Fluxo Esquerda** $\rightarrow$ **Direita:**

   * Ao detectar veículo em `D1`, o semáforo `S1` fica verde (`1`) e a cancela `C1` abre (`1`).

   * **Comportamento Mealy:** Assim que o veículo abandona `D1` (mesmo antes de passar totalmente por `C1`), `S1` retorna imediatamente para **vermelho** (`0`) para evitar a entrada de um segundo veículo colado.

   * Ao passar por `D2`, a cancela `C1` se fecha (`0`).

   * Ao atingir `D3`, a cancela `C2` se abre (`1`) para saída.

   * Ao cruzar `D4`, a cancela `C2` fecha (`0`), retornando ao estado de repouso.

3. **Fluxo Direita** $\rightarrow$ **Esquerda:**

   * Análogo ao fluxo inverso utilizando `D5`, `S2`, `C2`, `D3`, `D2`, `C1` e `D6`.

4. **Prioridade e Concorrência:**

   * Se chegarem veículos simultaneamente em ambos os lados, a **prioridade é do sentido Esquerda** $\rightarrow$ **Direita** (`D1`).

   * Se um veículo tentar entrar enquanto outro ocupa a estrada, ele deve aguardar a liberação completa do trecho estreito.

## Etapas do Desenvolvimento

* \[x\] **Diagrama de Estados:** Projetar o grafo da FSM com transições e saídas associadas aos estados e entradas (Mealy).

* \[x\] **Codificação VHDL:** Descrição do circuito sintetizável.

* \[x\] **Simulação & Testbench:** Validação temporal do comportamento via simulação funcional.

* \[x\] **Mapeamento de Pinos (`.xdc`):** Associação das entradas aos *Switches/Buttons* e saídas aos *LEDs* da placa FPGA.

* \[x\] **Síntese e Implementação:** Geração do arquivo `.bit` (bitstream) utilizando a ferramenta Xilinx Vivado.

* \[x\] **Validação em Hardware:** Teste e demonstração do protótipo em placa FPGA.

## Ferramentas Utilizadas

* **Linguagem de Descrição de Hardware:** VHDL

* **Ambiente de Desenvolvimento / Síntese:** Xilinx Vivado

* **Placa de Desenvolvimento FPGA:** *(Especificar o modelo, ex: Basys 3 / Nexys A7)*
