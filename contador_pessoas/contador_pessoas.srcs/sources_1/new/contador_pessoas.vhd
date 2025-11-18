library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity contador_pessoas is
    Port ( 
        clk              : in  STD_LOGIC;                      -- Clock do sistema
        reset            : in  STD_LOGIC;                      -- Reset assíncrono
        sensor_entrada   : in  STD_LOGIC;                      -- Sensor de entrada
        sensor_saida     : in  STD_LOGIC;                      -- Sensor de saída
        contagem         : out STD_LOGIC_VECTOR(7 downto 0);   -- Contador de pessoas (0-255)
        capacidade_maxima: out STD_LOGIC;                      -- Indicador de capacidade máxima
        vazio            : out STD_LOGIC;                      -- Indicador de ambiente vazio
        display_unidade  : out STD_LOGIC_VECTOR(6 downto 0);   -- Display 7 segmentos (unidades)
        display_dezena   : out STD_LOGIC_VECTOR(6 downto 0)    -- Display 7 segmentos (dezenas)
    );
end contador_pessoas;

architecture Behavioral of contador_pessoas is
    
    -- Constantes
    constant MAX_PESSOAS : integer := 99;  -- Capacidade máxima
    
    -- Sinais internos para o contador
    signal contador_interno : unsigned(7 downto 0) := (others => '0');
    
    -- Máquina de Estados Finitos (FSM)
    type tipo_estado is (OCIOSO, PESSOA_ENTRANDO, AGUARDA_ENTRADA, PESSOA_SAINDO, AGUARDA_SAIDA);
    signal estado_atual, proximo_estado : tipo_estado := OCIOSO;
    
    -- Flip-flops para detecção de borda (edge detection)
    signal sensor_entrada_anterior  : STD_LOGIC := '0';
    signal sensor_saida_anterior    : STD_LOGIC := '0';
    signal borda_sensor_entrada     : STD_LOGIC := '0';
    signal borda_sensor_saida       : STD_LOGIC := '0';
    
    -- Sinais para divisor de clock (debouncing)
    signal divisor_clk : unsigned(19 downto 0) := (others => '0');
    signal clk_1hz     : STD_LOGIC := '0';
    
    -- Sinais auxiliares
    signal unidade, dezena : integer range 0 to 9 := 0;
    
    -- Função para converter número em display 7 segmentos
    -- Segmentos: (a, b, c, d, e, f, g)
    function para_7seg(digito : integer range 0 to 9) return STD_LOGIC_VECTOR is
    begin
        case digito is
            when 0 => return "1000000"; -- 0
            when 1 => return "1111001"; -- 1
            when 2 => return "0100100"; -- 2
            when 3 => return "0110000"; -- 3
            when 4 => return "0011001"; -- 4
            when 5 => return "0010010"; -- 5
            when 6 => return "0000010"; -- 6
            when 7 => return "1111000"; -- 7
            when 8 => return "0000000"; -- 8
            when 9 => return "0010000"; -- 9
            when others => return "1111111";
        end case;
    end function;

begin

    -- Processo: Divisor de Clock para debouncing (gera clock mais lento)
    process(clk, reset)
    begin
        if reset = '1' then
            divisor_clk <= (others => '0');
            clk_1hz <= '0';
        elsif rising_edge(clk) then
            divisor_clk <= divisor_clk + 1;
            -- Para simulação: usar divisor_clk(10) 
            -- Para FPGA real: usar divisor_clk(19) para ~1Hz com clock de 100MHz
            clk_1hz <= divisor_clk(10); 
        end if;
    end process;

    -- Processo: Detecção de borda para os sensores (Flip-flops tipo D)
    process(clk, reset)
    begin
        if reset = '1' then
            sensor_entrada_anterior  <= '0';
            sensor_saida_anterior    <= '0';
            borda_sensor_entrada     <= '0';
            borda_sensor_saida       <= '0';
        elsif rising_edge(clk) then
            -- Armazena estado anterior
            sensor_entrada_anterior  <= sensor_entrada;
            sensor_saida_anterior    <= sensor_saida;
            
            -- Detecta borda de subida (transição 0->1)
            borda_sensor_entrada <= sensor_entrada and (not sensor_entrada_anterior);
            borda_sensor_saida   <= sensor_saida and (not sensor_saida_anterior);
        end if;
    end process;

    -- Processo: Lógica da Máquina de Estados Finitos (FSM)
    -- Registrador de estados (Flip-flops)
    process(clk, reset)
    begin
        if reset = '1' then
            estado_atual <= OCIOSO;
        elsif rising_edge(clk) then
            estado_atual <= proximo_estado;
        end if;
    end process;

    -- Lógica combinacional da FSM (próximo estado)
    process(estado_atual, borda_sensor_entrada, borda_sensor_saida, contador_interno, sensor_entrada, sensor_saida)
    begin
        proximo_estado <= estado_atual; -- Estado padrão
        
        case estado_atual is
            
            when OCIOSO =>
                -- Estado de espera
                if borda_sensor_entrada = '1' and contador_interno < MAX_PESSOAS then
                    proximo_estado <= PESSOA_ENTRANDO;
                elsif borda_sensor_saida = '1' and contador_interno > 0 then
                    proximo_estado <= PESSOA_SAINDO;
                end if;
            
            when PESSOA_ENTRANDO =>
                -- Pessoa detectada entrando
                proximo_estado <= AGUARDA_ENTRADA;
            
            when AGUARDA_ENTRADA =>
                -- Aguarda sensor desativar antes de voltar ao OCIOSO
                if sensor_entrada = '0' then
                    proximo_estado <= OCIOSO;
                end if;
            
            when PESSOA_SAINDO =>
                -- Pessoa detectada saindo
                proximo_estado <= AGUARDA_SAIDA;
            
            when AGUARDA_SAIDA =>
                -- Aguarda sensor desativar antes de voltar ao OCIOSO
                if sensor_saida = '0' then
                    proximo_estado <= OCIOSO;
                end if;
                
        end case;
    end process;

    -- Processo: Contador Binário (incremento/decremento)
    process(clk, reset)
    begin
        if reset = '1' then
            contador_interno <= (others => '0');
        elsif rising_edge(clk) then
            case estado_atual is
                when PESSOA_ENTRANDO =>
                    -- Incrementa contador (pessoa entra)
                    if contador_interno < MAX_PESSOAS then
                        contador_interno <= contador_interno + 1;
                    end if;
                    
                when PESSOA_SAINDO =>
                    -- Decrementa contador (pessoa sai)
                    if contador_interno > 0 then
                        contador_interno <= contador_interno - 1;
                    end if;
                    
                when others =>
                    contador_interno <= contador_interno; -- Mantém valor
            end case;
        end if;
    end process;

    -- Processo: Separação de unidades e dezenas
    process(contador_interno)
        variable contagem_temp : integer;
    begin
        contagem_temp := to_integer(contador_interno);
        dezena <= contagem_temp / 10;
        unidade <= contagem_temp mod 10;
    end process;

    -- Atribuições de saída (lógica combinacional)
    contagem <= std_logic_vector(contador_interno);
    
    -- Indicador de capacidade máxima
    capacidade_maxima <= '1' when contador_interno >= MAX_PESSOAS else '0';
    
    -- Indicador de ambiente vazio
    vazio <= '1' when contador_interno = 0 else '0';
    
    -- Display de 7 segmentos (unidades e dezenas)
    display_unidade <= para_7seg(unidade);
    display_dezena  <= para_7seg(dezena);

end Behavioral;