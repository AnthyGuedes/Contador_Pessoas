# Contador_Pessoas
stateDiagram-v2
    [*] --> OCIOSO

    %% Fluxo de Entrada (Incrementa)
    OCIOSO --> PESSOA_ENTRANDO : borda_sensor_entrada = '1'
    state PESSOA_ENTRANDO {
        direction LR
        note: Contador + 1
    }
    PESSOA_ENTRANDO --> AGUARDA_ENTRADA : (automático)
    AGUARDA_ENTRADA --> OCIOSO : sensor_entrada = '0'

    %% Fluxo de Saída (Decrementa)
    OCIOSO --> PESSOA_SAINDO : borda_sensor_saida = '1'
    state PESSOA_SAINDO {
        direction LR
        note: Contador - 1
    }
    PESSOA_SAINDO --> AGUARDA_SAIDA : (automático)
    AGUARDA_SAIDA --> OCIOSO : sensor_saida = '0'
