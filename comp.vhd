-------------------------------------------
-- MODLO COMPARA DADO  -  Leonardo Chou da Rosa e Luigi Salvatore Bos-Mikich - 10/Junho/23
-------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

entity compara_dado is
  port (
    clock : in std_logic;
    reset : in std_logic;
    dado : in std_logic_vector(7 downto 0);
    pattern : in std_logic_vector(7 downto 0);
    prog : in std_logic;
    habilita : in std_logic;
    match : out std_logic
  );
end compara_dado;

architecture a1 of compara_dado is
  signal padrao : std_logic_vector(7 downto 0) := "00000000";
begin
  check : process (clock, reset)
  begin
    if reset = '1' then -- se reset = 1, reinicia todas as variáveis
      padrao <= "00000000";
      match <= '0';
    end if;
    if clock'event and clock = '1' then -- se prog = 1, o valor de padrão está habilitado para receber o pattern
      if prog = '1' then
        padrao <= pattern;
      end if;
      if habilita = '1' and dado = padrao then -- se habilita = 1 e o dado for igual o padrão estabelecido, match = 1 caso contrário match = 0
        match <= '1';
        else match <= '0';
      end if;
    end if;
  end process check;
end a1;