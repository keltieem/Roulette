LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

LIBRARY WORK;
USE WORK.ALL;

entity flipflop_stdlogic is
  port   ( clk    : in std_logic;
           resetb : in std_logic;
           D      : in std_logic;
           Q      : out std_logic
         );
end flipflop_stdlogic;

architecture behavioural of flipflop_stdlogic is

begin
  process(clk, resetb)
    begin
    if (resetb = '0') then
       Q<= '0';
    elsif (rising_edge(clk)) then
      Q <= D;
     end if;
   end process;
  
end;

