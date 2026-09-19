# Exercícios Teoria

Esses exercícios foram passados pelo professor Dr. Daniel Munoz na disciplina teórica de Eletrônica Digital 2 como introdução às máquinas de estados finitos. 

## Objetivo

Projetar máquinas de estados que sejam capazes de detectar sequências específicas de bits. Caso a palavra binária desejada seja detectada, a saída irá exibir nível lógico alto. Para ativar a saída, é aceita a condição de _overlap_. Isto é, o final de uma sequência de bits pode ser o início da próxima sequência.

A máquina de estados em `fsm_110_101_overlap` pode ativar a saída caso detecte `110` ou `101`. Já a máquina de estados em `FSM_11011_overlap` ativa a saída caso detecte `11011` na sua entrada.

## Metodologia

Ambas as máquinas de estados foram desenvolvidas a partir do seguinte fluxo de trabalho:

1. Diagrama de Estados para organizar as condições de transição de estados
2. Tabela de Transição de Estados para obter os mintermos
3. Mapa de Karnaugh a partir da Tabela de transição de estados para obter as expressões lógicas simplificadas
4. Simulação a nível lógico pra validação das expressões obtidas
