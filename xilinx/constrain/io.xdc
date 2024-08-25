set_property PACKAGE_PIN F17 [get_ports clk]
set_property PACKAGE_PIN R21 [get_ports hdmi_p_co]
set_property IOSTANDARD LVCMOS25 [get_ports clk]
set_property IOSTANDARD TMDS_33 [get_ports hdmi_p_co]
set_property IOSTANDARD TMDS_33 [get_ports hdmi_n_co]
set_property IOSTANDARD TMDS_33 [get_ports {hdmi_p_do[0]}]
set_property IOSTANDARD TMDS_33 [get_ports {hdmi_p_do[1]}]
set_property IOSTANDARD TMDS_33 [get_ports {hdmi_p_do[2]}]
set_property PACKAGE_PIN N18 [get_ports {hdmi_p_do[0]}]
set_property PACKAGE_PIN M21 [get_ports {hdmi_p_do[1]}]
set_property PACKAGE_PIN K25 [get_ports {hdmi_p_do[2]}]

set_property BITSTREAM.CONFIG.UNUSEDPIN Pulldown [current_design]

