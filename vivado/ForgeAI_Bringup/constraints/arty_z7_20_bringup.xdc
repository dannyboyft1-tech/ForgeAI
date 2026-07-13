## 125 MHz system clock
set_property -dict { PACKAGE_PIN H16 IOSTANDARD LVCMOS33 } [get_ports clk]
create_clock -add -name sys_clk_pin -period 8.000 -waveform {0 4} [get_ports clk]

## LED0
set_property -dict { PACKAGE_PIN R14 IOSTANDARD LVCMOS33 } [get_ports led0]