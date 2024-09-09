--------------------------------------
-- TRABALHO TP3 - Leonardo Chou da Rosa e Luigi Salvatore Bos-Mikich - 10/Junho/23
--------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

--------------------------------------
-- Entidade
--------------------------------------
entity tp3 is
  port (
    clock : in std_logic;
    reset : in std_logic;
    din : in std_logic;
    prog : in std_logic_vector(2 downto 0);
    padrao : in std_logic_vector(7 downto 0);
    alarme : out std_logic;
    numero : out std_logic_vector(1 downto 0);
    dout : out std_logic
  );
end entity;

--------------------------------------
-- Arquitetura
--------------------------------------
architecture tp3 of tp3 is
  type state is (idle, buscando, bloqueio, zerar, comp_data_1, comp_data_2, comp_data_3, comp_data_4);
  signal EA, PE : state;
  signal numero_int : std_logic_vector(1 downto 0) := "00";
  signal data : std_logic_vector(7 downto 0) := "00000000";
  signal alarme_int : std_logic;
  signal found : std_logic;
  signal match : std_logic_vector(3 downto 0);
  signal sel : std_logic_vector(3 downto 0);
  signal program : std_logic_vector(3 downto 0);

begin
  -- REGISTRADOR DE DESLOCAMENTO QUE RECEBE O FLUXO DE ENTRADA
  -- Para cada ciclo de clock, os valores já armazenados no vetor "data" são alocados uma posição para a frente e o valor novo "din" é armazenado no final do vetor "data"
  process (clock)
  begin
    if clock'event and clock = '1' then
      data (6 downto 0) <= data (7 downto 1);
      data (7) <= din;
    end if;
  end process;

  -- 4 PORT MAPS PARA OS ompara_dado  

  comp_1 : entity work.compara_dado
    port map
    (
      clock => clock,
      reset => reset,
      dado => data,
      prog => program(0),
      habilita => sel(0),
      pattern => padrao,
      match => match(0)
    );
  comp_2 : entity work.compara_dado
    port map
    (
      clock => clock,
      reset => reset,
      dado => data,
      prog => program(1),
      habilita => sel(1),
      pattern => padrao,
      match => match(1)
    );
  comp_3 : entity work.compara_dado
    port map
    (
      clock => clock,
      reset => reset,
      dado => data,
      prog => program(2),
      habilita => sel(2),
      pattern => padrao,
      match => match(2)
    );
  comp_4 : entity work.compara_dado
    port map
    (
      clock => clock,
      reset => reset,
      dado => data,
      prog => program(3),
      habilita => sel(3),
      pattern => padrao,
      match => match(3)
    );

  found <= '1' when match /= "0000" else -- o valor de found somente é igual a 1 quando o valor de match for diferente de "0000" ("0000" é o valor de match quando nenhum compara_dado é acionado)
    '0';

  --  registradores para ativar as comparações

  process (clock, reset)
  begin
    if reset = '1' or EA = zerar then -- se o circuito for reiniciado, zera os valores
      sel <= "0000";
      program <= "0000";
    elsif clock'event and clock = '1' then -- se houver um evento de clock
      if EA = comp_data_1 then -- se o estado atual for comp_data_1, ativa o sinal sel e habilita a comparação com o primeiro comp_data
        sel(0) <= '1';
        program <= "0001";
      elsif EA = comp_data_2 then -- se o estado atual for comp_data_2, ativa o sinal sel e habilita a comparação com o segundo comp_data
        sel(1) <= '1';
        program <= "0010";
      elsif EA = comp_data_3 then -- se o estado atual for comp_data_3, ativa o sinal sel e habilita a comparação com o terceiro comp_data
        sel(2) <= '1';
        program <= "0100";
      elsif EA = comp_data_4 then -- se o estado atual for comp_data_4, ativa o sinal sel e habilita a comparação com o quarto comp_data
        sel(3) <= '1';
        program <= "1000";
      end if;
    end if;
  end process;

  --  registrador para o alarme interno

  process (clock, reset)
  begin
    if reset = '1' then -- se reset = 1, zera o valor do alarme
      alarme_int <= '0';
    elsif clock'event and clock = '1' then -- se houver evento de clock
      if EA = buscando then -- se o estado atual for buscando, então o valor do alarme é o valor de "found", que indica se houve um match com os comp_data ou não
        alarme_int <= found;
      elsif EA = zerar or prog = "110" then -- se o programa zerar ou prog for "110" (6), então o alarme zera
        alarme_int <= '0';
      end if;
    end if;
  end process;

  -- MAQUINA DE ESTADOS (FSM)
  
  process (clock) 
  begin
    if clock'event and clock = '1' then -- se há evento de clock, o estado atual recebe o estado futuro
      EA <= PE;
    end if;
  end process;

  process (EA, match, prog)
  begin
    if EA = idle then -- se o estado atual for "idle"
      if prog = "000" then -- se prog for "000", não faz nada
        PE <= idle;
      end if;
      if prog = "001" then -- se prog for "001", configura o comp_data_1
        PE <= comp_data_1;
      end if;
      if prog = "010" then -- se prog for "010", configura o comp_data_2
        PE <= comp_data_2;
      end if;
      if prog = "011" then -- se prog for "011", configura o comp_data_3
        PE <= comp_data_3;
      end if;
      if prog = "100" then -- se prog for "100", configura o comp_data_4
        PE <= comp_data_4;
      end if;
      if prog = "101" then -- se prog for "101", entra no estado buscando
        PE <= buscando;
      end if;
      if prog = "111" then -- se prog for "111", zera o circuito
        PE <= zerar;
      end if; -- o comando "110" (6) está ausente pois ele só pode ser ativado quando o programa estiver no estado "bloqueio"
    end if;

    if EA = comp_data_1 then -- se o estado atual for o de programar o comp_data_1, o seu próximo estado será idle
      PE <= idle;
    end if;
    if EA = comp_data_2 then -- se o estado atual for o de programar o comp_data_2, o seu próximo estado será idle
      PE <= idle;
    end if;
    if EA = comp_data_3 then -- se o estado atual for o de programar o comp_data_3, o seu próximo estado será idle
      PE <= idle;
    end if;
    if EA = comp_data_4 then -- se o estado atual for o de programar o comp_data_4, o seu próximo estado será idle
      PE <= idle;
    end if;

    if EA = buscando then -- se o estado for buscando
      if match /= "0000" then -- se houver match, entra no estado bloqueio
        PE <= bloqueio;
      else
        if prog = "111" then -- se o programa pedir para zerar, cancela a busca e zera os valores
          PE <= zerar;
        else -- se nada mais for pedido, continua buscando
          PE <= buscando; 
        end if;
      end if;
    end if;

    if EA = bloqueio then -- se o estado atual for bloqueio
      if prog = "110" then -- se prog for "110" (6), volta para o estado buscando
        PE <= buscando;
      else
        if prog = "111" then -- se prog for "111", zera os valores
          PE <= zerar;
        else
          PE <= bloqueio; -- se nada mais for pedido, continua buscando
        end if;
      end if;
    end if; -- o estado bloqueio só pode deixar de bloqueiar se prog virar "110" ou "111", que sáo os instantes onde o usuário habilita novamente a busca

    if EA = zerar then -- se o estado atual for zerar, o seu próximo estado será idle
      PE <= idle;
    end if;
    
  end process;

  -- SAIDAS
  alarme <= alarme_int; -- a saída do alarme é alarme_int
  dout <= din when EA /= bloqueio else '0'; -- dout é o valor de din, mas se o estado atual for bloqueio, ele vira 0 (bloqueia os dados)
  numero <= "00" when match(0) = '1' else -- numero mostra "00" quando match(0) for '1' (o primeiro compara_dado foi ativado)
    "01" when match(1) = '1' else -- numero mostra "01" quando match(1) for '1' (o segundo compara_dado foi ativado)
    "10" when match(2) = '1' else -- numero mostra "10" quando match(2) for '1' (o terceiro compara_dado foi ativado)
    "11" when match(3) = '1'; -- numero mostra "11" quando match(3) for '1' (o quarto compara_dado foi ativado)

end architecture;