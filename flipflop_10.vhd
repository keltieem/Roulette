LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

LIBRARY WORK;
USE WORK.ALL;

entity flipflop_10 is
  port   ( clk    : in std_logic;
           resetb : in std_logic;
           D      : in unsigned (11 downto 0);
           Q      : out unsigned (11 downto 0)
         );
end flipflop_10;

architecture behavioural of flipflop_10 is

begin
  process(clk, resetb)
    begin
    if (resetb = '0') then
       Q<= "000000100000";
    elsif (clk = '0') then
      Q <= D;
    end if;
 end process;
     
  
end;

