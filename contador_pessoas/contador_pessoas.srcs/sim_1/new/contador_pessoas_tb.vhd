library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity contador_pessoas_tb is
end contador_pessoas_tb;

architecture Behavioral of contador_pessoas_tb is
    
    component contador_pessoas is
        Port ( 
            clk              : in  STD_LOGIC;
            reset            : in  STD_LOGIC;
            sensor_entrada   : in  STD_LOGIC;
            sensor_saida     : in  STD_LOGIC;
            contagem         : out STD_LOGIC_VECTOR(7 downto 0);
            capacidade_maxima: out STD_LOGIC;
            vazio            : out STD_LOGIC
        );
    end component;
    
    signal clk              : STD_LOGIC := '0';
    signal reset            : STD_LOGIC := '0';
    signal sensor_entrada   : STD_LOGIC := '0';
    signal sensor_saida     : STD_LOGIC := '0';
    signal contagem         : STD_LOGIC_VECTOR(7 downto 0);
    signal capacidade_maxima: STD_LOGIC;
    signal vazio            : STD_LOGIC;
    
    constant periodo_clk : time := 10 ns;
    
begin

    uut: contador_pessoas port map (
        clk              => clk,
        reset            => reset,
        sensor_entrada   => sensor_entrada,
        sensor_saida     => sensor_saida,
        contagem         => contagem,
        capacidade_maxima=> capacidade_maxima,
        vazio            => vazio
    );
    
    -- Geração do clock
    processo_clk: process
    begin
        clk <= '0';
        wait for periodo_clk/2;
        clk <= '1';
        wait for periodo_clk/2;
    end process;
    
    -- Processo de estímulo
    processo_estimulo: process
    begin
        -- Reset inicial
        reset <= '1';
        wait for 200 ns;
        reset <= '0';
        wait for 200 ns;
        
        -- ===== PESSOA 1 ENTRANDO =====
        report "TESTE: Pessoa 1 entrando...";
        sensor_entrada <= '1';
        wait for 500 ns;  -- Sensor detecta presença
        sensor_entrada <= '0';
        wait for 1000 ns; -- Aguarda processamento
        
        -- ===== PESSOA 2 ENTRANDO =====
        report "TESTE: Pessoa 2 entrando...";
        sensor_entrada <= '1';
        wait for 500 ns;
        sensor_entrada <= '0';
        wait for 1000 ns;
        
        -- ===== PESSOA 3 ENTRANDO =====
        report "TESTE: Pessoa 3 entrando...";
        sensor_entrada <= '1';
        wait for 500 ns;
        sensor_entrada <= '0';
        wait for 1000 ns;
        
        report "ESTADO: 3 pessoas dentro";
        wait for 2000 ns;
        
        -- ===== PESSOA 1 SAINDO =====
        report "TESTE: Pessoa 1 saindo...";
        sensor_saida <= '1';
        wait for 500 ns;
        sensor_saida <= '0';
        wait for 1000 ns;
        
        report "ESTADO: 2 pessoas dentro";
        wait for 2000 ns;
        
        -- ===== PESSOA 4 ENTRANDO =====
        report "TESTE: Pessoa 4 entrando...";
        sensor_entrada <= '1';
        wait for 500 ns;
        sensor_entrada <= '0';
        wait for 1000 ns;
        
        -- ===== PESSOA 5 ENTRANDO =====
        report "TESTE: Pessoa 5 entrando...";
        sensor_entrada <= '1';
        wait for 500 ns;
        sensor_entrada <= '0';
        wait for 1000 ns;
        
        report "ESTADO FINAL: 4 pessoas dentro";
        wait for 2000 ns;
        
        -- ===== TESTE: Todas saindo =====
        report "TESTE: Todas as pessoas saindo...";
        for i in 1 to 4 loop
            sensor_saida <= '1';
            wait for 500 ns;
            sensor_saida <= '0';
            wait for 1000 ns;
        end loop;
        
        report "ESTADO FINAL: 0 pessoas (vazio deve estar em 1)";
        wait for 2000 ns;
        
        report "=== SIMULACAO COMPLETA ===";
        wait;
    end process;

end Behavioral;