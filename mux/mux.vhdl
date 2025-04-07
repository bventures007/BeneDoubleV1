architecture Behavioral of TFT_MUX is
begin
    -- Multiplex RGB-Daten
    process (SELECT, SAM1_RGB, SAM2_RGB)
    begin
        if SELECT = '0' then
            TFT_RGB <= SAM1_RGB;
        else
            TFT_RGB <= SAM2_RGB;
        end if;
    end process;

    -- Multiplex H-Sync
    process (SELECT, SAM1_HSYNC, SAM2_HSYNC)
    begin
        if SELECT = '0' then
            TFT_HSYNC <= SAM1_HSYNC;
        else
            TFT_HSYNC <= SAM2_HSYNC;
        end if;
    end process;

    -- Multiplex V-Sync
    process (SELECT, SAM1_VSYNC, SAM2_VSYNC)
    begin
        if SELECT = '0' then
            TFT_VSYNC <= SAM1_VSYNC;
        else
            TFT_VSYNC <= SAM2_VSYNC;
        end if;
    end process;

    -- Multiplex Data Enable
    process (SELECT, SAM1_DE, SAM2_DE)
    begin
        if SELECT = '0' then
            TFT_DE <= SAM1_DE;
        else
            TFT_DE <= SAM2_DE;
        end if;
    end process;

    -- Multiplex Pixel Clock
    process (SELECT, SAM1_PCLK, SAM2_PCLK)
    begin
        if SELECT = '0' then
            TFT_PCLK <= SAM1_PCLK;
        else
            TFT_PCLK <= SAM2_PCLK;
        end if;
    end process;

end Behavioral;

