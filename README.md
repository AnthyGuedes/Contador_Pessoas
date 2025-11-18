# Contador_Pessoas

## Integrantes

Arthur de Souza Spironello 
Anthony da Silva Guedes

## Objetivo do Circuito

O objetivo principal deste circuito é desenvolver, com linguagem VHDL no ambiente Vivado , um Mini Controlador Digital para simular um Contador de Pessoas (Entrada e Saída). O sistema utiliza sinais de sensores para determinar se a contagem deve ser incrementada ou decrementada. O projeto aplica os conceitos de Flip-flops e Contadores Binários para armazenamento e manipulação do valor, e uma Máquina de Estados Finitos (FSM) para gerenciar a lógica de passagem e garantir que cada pessoa seja contada apenas uma vez. A contagem final é exibida de forma decodificada.

## Diagrama de Estados 


## Fluxo de Operação

Início-> O circuito começa no estado OCIOSO (repouso) e está zerado (reset).

Detecção e Ação-> No momento em que um sensor é acionado (entrada ou saída), o sistema transiciona do OCIOSO para o estado de Ação.

Contagem-> Neste estado de Ação, o contador binário soma (+1) ou subtrai (-1) o valor, dependendo do sensor ativado.

Proteção (AGUARDA)-> Imediatamente após a contagem, a FSM entra em um estado de Espera (AGUARDA).

Ciclo Completo-> O sistema fica preso neste estado de Espera até que o sensor seja totalmente liberado (volte a zero). Somente após essa liberação, o sistema retorna ao estado OCIOSO, garantindo que a passagem de uma única pessoa resulte em apenas uma contagem.

Saída-> O valor atualizado do contador é constantemente convertido e exibido nos displays de 7 segmentos, e os sinais de vazio e capacidade_maxima são atualizados.

## |Prints das Simulações|

<img width="1286" height="592" alt="SIMULATION VIVADO " src="https://github.com/user-attachments/assets/4f8313cd-067f-4d9f-af4c-e61082d38ac2" />


## Cloncusão 
Este projeto permitiu a aplicação prática da implementação de uma **Máquina de Estados Finitos (FSM)** em VHDL para controlar um sistema sequencial. Alguns pontos interessantes são a integração do contador binário com a lógica de proteção, garantir que a FSM passasse corretamente pelos estados de **Espera (`AGUARDA`)** para evitar **contagens duplicadas**, uma etapa importante na durante o projeto.
