LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

LIBRARY WORK;
USE WORK.ALL;

entity flipflop_unsigned is
  generic( k : integer);
  port   ( clk    : in std_logic;
           resetb : in std_logic;
           D      : in unsigned (k-1 downto 0);
           Q      : out unsigned (k-1 downto 0)
         );
end flipflop_unsigned;

architecture behavioural of flipflop_unsigned is

begin
  process(clk, resetb)
    begin
    if (resetb = '0') then
       Q<= (others =>'0');
    elsif (rising_edge(clk)) then
      Q <= D;
     end if;
   end process;
     
  
end;
