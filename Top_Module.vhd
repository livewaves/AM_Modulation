library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Top_Module is

    Port ( 
				Clock 			: in  STD_LOGIC;
				Output_Signal	: out	signed	(9 downto 0)
			);
			
end Top_Module;

architecture Behavioral of Top_Module is

	constant	Coefficient				:	signed 				(7 downto 0)				:=	to_signed(26,8);
	signal	DDS_Sin_310KHz				:	std_logic_vector	(9 downto 0)				:=	(others=>'0');
	signal	DDS_Cos_85Hz				:	std_logic_vector	(6 downto 0)				:=	(others=>'0');
	signal	Product_85Hz				:	signed				(14 downto 0)				:=	(others=>'0');
	signal	Product_310KHz				:	signed				(18 downto 0)				:=	(others=>'0');
	signal	Product_85Hz_Plus_One		:	signed				(8 downto 0)				:=	(others=>'0');
	signal	Output_Signal_Int			:	signed				(9 downto 0)				:=	(others=>'0');

	COMPONENT Cos_85Hz
	  PORT (
		 clk : IN STD_LOGIC;
		 cosine : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
	  );
	END COMPONENT;

	COMPONENT Sin_310KHz
	  PORT (
		 clk : IN STD_LOGIC;
		 sine : OUT STD_LOGIC_VECTOR(9 DOWNTO 0)
	  );
	END COMPONENT;

begin

	Cos_85Hz_Inst : Cos_85Hz
	  PORT MAP (
		 clk 		=> Clock,
		 cosine 	=> DDS_Cos_85Hz
	  );

	Sin_310KHz_Inst : Sin_310KHz
	  PORT MAP (
		 clk 		=> Clock,
		 sine 	=> DDS_Sin_310KHz
	  );

	Output_Signal						<=	Output_Signal_Int;
	
	process(Clock)
	begin
	
		if rising_edge(Clock) then
		
			Product_85Hz				<=	Coefficient * signed(DDS_Cos_85Hz);
			Product_85Hz_Plus_One		<=	Product_85Hz(14 downto 6) + to_signed(128,9);
			Product_310KHz				<=	Product_85Hz_Plus_One * signed(DDS_Sin_310KHz);
			Output_Signal_Int			<=	Product_310KHz(18 downto 9);
		
		end if;
	
	end process;

end Behavioral;