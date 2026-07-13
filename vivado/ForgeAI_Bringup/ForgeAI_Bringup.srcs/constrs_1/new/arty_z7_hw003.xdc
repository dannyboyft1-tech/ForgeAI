##====================================================
## ForgeAI
## Hardware Milestone: HW-003 Register Demo
## Board: Digilent Arty Z7-20
## Device: xc7z020clg400-1
##====================================================


##----------------------------------------------------
## 125 MHz System Clock
##----------------------------------------------------

set_property PACKAGE_PIN H16 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]

create_clock -name sys_clk -period 8.000 -waveform {0.000 4.000} [get_ports clk]


##----------------------------------------------------
## Push Buttons
##----------------------------------------------------

## BTN0 - Load register
set_property PACKAGE_PIN D19 [get_ports btn0]
set_property IOSTANDARD LVCMOS33 [get_ports btn0]

## BTN1 - Reset
set_property PACKAGE_PIN D20 [get_ports btn1]
set_property IOSTANDARD LVCMOS33 [get_ports btn1]


##----------------------------------------------------
## Slide Switches
##----------------------------------------------------

## SW0
set_property PACKAGE_PIN M20 [get_ports {sw[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sw[0]}]

## SW1
set_property PACKAGE_PIN M19 [get_ports {sw[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sw[1]}]


##----------------------------------------------------
## LEDs
##----------------------------------------------------

## LED0
set_property PACKAGE_PIN R14 [get_ports {led[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[0]}]

## LED1
set_property PACKAGE_PIN P14 [get_ports {led[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[1]}]

## LED2
set_property PACKAGE_PIN N16 [get_ports {led[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[2]}]

## LED3
set_property PACKAGE_PIN M14 [get_ports {led[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[3]}]