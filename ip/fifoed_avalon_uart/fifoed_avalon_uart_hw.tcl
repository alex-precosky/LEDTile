#/*
# * Copyright (c) 2014, Altera Corporation <www.altera.com>
# * All rights reserved.
# *
# * Redistribution and use in source and binary forms, with or without
# * modification, are permitted provided that the following conditions are met:
# * - Redistributions of source code must retain the above copyright
# *   notice, this list of conditions and the following disclaimer.
# * - Redistributions in binary form must reproduce the above copyright
# *   notice, this list of conditions and the following disclaimer in the
# *   documentation and/or other materials provided with the distribution.
# * - Neither the name of the Altera Corporation nor the
# *   names of its contributors may be used to endorse or promote products
# *   derived from this software without specific prior written permission.
# *
# * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
# * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# * DISCLAIMED. IN NO EVENT SHALL ALTERA CORPORATION BE LIABLE FOR ANY
# * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
# * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
# */
package require -exact qsys 12.0
source $env(QUARTUS_ROOTDIR)/../ip/altera/sopc_builder_ip/common/embedded_ip_hwtcl_common.tcl
# +-----------------------------------
# | 
# | fifoed_avalon_uart "FIFOed UART (RS-232 serial port)13.1" v13.1
# | null 2009.05.22.08:44:31
# | 
# |
#  22 May 2009  CJR Added the ability to detect the clock frequency.
#  22 May 2009  CJR Added add_file in the generation phase.
#  26 May 2009  CJR Added timout functionality
#  13 May 2010  CJR Added timestamp and error in fifo functinality
#  27 Jan 2014  CJR upded to make compatible with the latest qsys. 
#   4 Sep 2014  CJR GUI clean up
# +-----------------------------------


#-------------------------------------------------------------------------------
# module properties
#-------------------------------------------------------------------------------

set_module_property NAME fifoed_avalon_uart
set_module_property DISPLAY_NAME "FIFOed UART (RS-232 serial port)13.2"
set_module_property VERSION 13.2
set_module_property DESCRIPTION "Modified Altera Avalon UART with FIFOs and other added features."
set_module_property GROUP "Interface Protocols/Serial"
set_module_property AUTHOR {Altera Corporation/cruben}
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property INTERNAL false
set_module_property HIDE_FROM_SOPC true
#set_module_property EDITABLE false
set_module_property VALIDATION_CALLBACK validate
set_module_property ELABORATION_CALLBACK elaborate


# generation fileset

add_fileset quartus_synth QUARTUS_SYNTH sub_quartus_synth
add_fileset sim_verilog SIM_VERILOG sub_sim_verilog
add_fileset sim_vhdl SIM_VHDL sub_sim_vhdl

# links to documentation

add_documentation_link {Data Sheet} {http://www.altera.com/literature/hb/nios2/n2cpu_nii51010.pdf}

#-------------------------------------------------------------------------------
# module parameters
#-------------------------------------------------------------------------------

# parameters

add_parameter baud INTEGER 
set_parameter_property baud DEFAULT_VALUE {115200}
set_parameter_property baud DISPLAY_NAME {Baud rate (bps)}
set_parameter_property baud ALLOWED_RANGES {5000000 2000000 921600 460800 230400 115200 57600 38400 31250 28800 19200 14400 9600 4800 2400 1200 300}
set_parameter_property baud AFFECTS_GENERATION {1}
set_parameter_property baud HDL_PARAMETER {0}
set_parameter_property baud DESCRIPTION "Selects the default baud rate for the uart"

add_parameter dataBits INTEGER
set_parameter_property dataBits DEFAULT_VALUE {8}
set_parameter_property dataBits DISPLAY_NAME {Data bits}
set_parameter_property dataBits ALLOWED_RANGES {7 8 9 10}
set_parameter_property dataBits AFFECTS_GENERATION {1}
set_parameter_property dataBits HDL_PARAMETER {0}
set_parameter_property dataBits DESCRIPTION "Number of databit default is 8"

add_parameter fixedBaud BOOLEAN
set_parameter_property fixedBaud DEFAULT_VALUE {true}
set_parameter_property fixedBaud DISPLAY_NAME "Fixed baud rate ( no software control)"
set_parameter_property fixedBaud DESCRIPTION {Baud rate cannot be changed by software (Divisor register is not writable)}
set_parameter_property fixedBaud AFFECTS_GENERATION {1}
set_parameter_property fixedBaud HDL_PARAMETER {0}


add_parameter parity STRING
set_parameter_property parity DEFAULT_VALUE {NONE}
set_parameter_property parity DISPLAY_NAME {Parity}
set_parameter_property parity ALLOWED_RANGES {NONE EVEN ODD PROGRAMMABLE}
set_parameter_property parity DESCRIPTION  "This can be set to None, Even, Odd, and Programmable. If set to programmable, then bit 14 and 15 of the Control register are enabled to change the parity on the fly. Control_reg\[14\] is Odd parity, Control_reg\[15\] is Even parity. Both set is undefined."
set_parameter_property parity AFFECTS_GENERATION {1}
set_parameter_property parity HDL_PARAMETER {0}

add_parameter simCharStream STRING
set_parameter_property simCharStream DISPLAY_NAME {Contents}
set_parameter_property simCharStream VISIBLE {0}
set_parameter_property simCharStream DISPLAY_HINT {rows:6}
set_parameter_property simCharStream AFFECTS_GENERATION {1}
set_parameter_property simCharStream HDL_PARAMETER {0}
set_parameter_property simCharStream DESCRIPTION "Chars to be sent to the uart upon simulation startup"

add_parameter simInteractiveInputEnable BOOLEAN
set_parameter_property simInteractiveInputEnable DEFAULT_VALUE {false}
set_parameter_property simInteractiveInputEnable DISPLAY_NAME {Interactive stimulus window}
set_parameter_property simInteractiveInputEnable VISIBLE {0}
set_parameter_property simInteractiveInputEnable DESCRIPTION {Create ModelSim alias to open an interactive stimulus window}
set_parameter_property simInteractiveInputEnable AFFECTS_GENERATION {1}
set_parameter_property simInteractiveInputEnable HDL_PARAMETER {0}


add_parameter simInteractiveOutputEnable BOOLEAN
set_parameter_property simInteractiveOutputEnable DEFAULT_VALUE {false}
set_parameter_property simInteractiveOutputEnable DISPLAY_NAME {Streaming output window}
set_parameter_property simInteractiveOutputEnable VISIBLE {0}
set_parameter_property simInteractiveOutputEnable DESCRIPTION {Create ModelSim alias to open streaming output window}
set_parameter_property simInteractiveOutputEnable AFFECTS_GENERATION {1}
set_parameter_property simInteractiveOutputEnable HDL_PARAMETER {0}


add_parameter simTrueBaud BOOLEAN
set_parameter_property simTrueBaud DEFAULT_VALUE {false}
set_parameter_property simTrueBaud DISPLAY_NAME {Option}
set_parameter_property simTrueBaud VISIBLE {0}
set_parameter_property simTrueBaud ALLOWED_RANGES {{false:Accelerated (Use divisor = 2)} {true:Actual (Use true baud divisor)}}
set_parameter_property simTrueBaud AFFECTS_GENERATION {1}
set_parameter_property simTrueBaud HDL_PARAMETER {0}
set_parameter_property simTrueBaud DESCRIPTION "If enabled the baudrate will be the actual, if not enalbed the baued will be the clock/2"

add_parameter stopBits INTEGER
set_parameter_property stopBits DEFAULT_VALUE {1}
set_parameter_property stopBits DISPLAY_NAME {Stop bits}
set_parameter_property stopBits ALLOWED_RANGES {1 2}
set_parameter_property stopBits AFFECTS_GENERATION {1}
set_parameter_property stopBits HDL_PARAMETER {0}
set_parameter_property stopBits DESCRIPTION "Number of stopbits asserted after a byte has been transmitted"

add_parameter syncRegDepth INTEGER
set_parameter_property syncRegDepth DEFAULT_VALUE {2}
set_parameter_property syncRegDepth DISPLAY_NAME {Synchronizer stages}
set_parameter_property syncRegDepth ALLOWED_RANGES {2 3 4 5}
set_parameter_property syncRegDepth AFFECTS_GENERATION {1}
set_parameter_property syncRegDepth HDL_PARAMETER {0}
set_parameter_property syncRegDepth DESCRIPTION "Nunmber Synchronizer stages used to synchronize the asynchrnous inputs"

add_parameter useCtsRts BOOLEAN 
set_parameter_property useCtsRts DEFAULT_VALUE {false}
set_parameter_property useCtsRts DISPLAY_NAME {Include CTS/RTS}
set_parameter_property useCtsRts DESCRIPTION "Include CTS/RTS pins and control register bits"
set_parameter_property useCtsRts AFFECTS_GENERATION {1}
set_parameter_property useCtsRts HDL_PARAMETER {0}

add_parameter useEopRegister BOOLEAN  
set_parameter_property useEopRegister DEFAULT_VALUE {false}
set_parameter_property useEopRegister DISPLAY_NAME {Include end-of-packet}
set_parameter_property useEopRegister DESCRIPTION {Include end-of-packet register}
set_parameter_property useEopRegister AFFECTS_GENERATION {1}
set_parameter_property useEopRegister HDL_PARAMETER {0}

add_parameter useRelativePathForSimFile BOOLEAN
set_parameter_property useRelativePathForSimFile DEFAULT_VALUE {false}
set_parameter_property useRelativePathForSimFile DISPLAY_NAME {useRelativePathForSimFile}
set_parameter_property useRelativePathForSimFile VISIBLE {0}
set_parameter_property useRelativePathForSimFile AFFECTS_GENERATION {1}
set_parameter_property useRelativePathForSimFile HDL_PARAMETER {0}
set_parameter_property useRelativePathForSimFile DESCRIPTION ""

add_parameter use_status_bit_clear BOOLEAN false ""
set_parameter_property use_status_bit_clear DISPLAY_NAME "Clear inidividual status bit"
set_parameter_property use_status_bit_clear UNITS None
#set_parameter_property use_status_bit_clear GROUP "Configuration"
set_parameter_property use_status_bit_clear DESCRIPTION "you can clear individual status register bits by writting a 1 to those bit positions. Bits that can be individually cleared are tx_overrun,framing_error, break_detect,rx_overrun, parrity_error, tx_overrun, gap_timeout, eop. "
set_parameter_property use_status_bit_clear AFFECTS_ELABORATION false

add_parameter use_tx_fifo BOOLEAN false ""
set_parameter_property use_tx_fifo DISPLAY_NAME "Include transmit FIFOs"
set_parameter_property use_tx_fifo UNITS None
#set_parameter_property use_tx_fifo GROUP "TX FIFO usage"
set_parameter_property use_tx_fifo AFFECTS_ELABORATION true
set_parameter_property use_tx_fifo DESCRIPTION " If selected this option turns on the generation of the Tx FIFOs.  If you do not include FIFOs you will generate a standard Nios UART"

add_parameter fifo_size_tx INTEGER 8 ""
set_parameter_property fifo_size_tx DISPLAY_NAME "TX FIFO depth (words): "
set_parameter_property fifo_size_tx UNITS None
set_parameter_property fifo_size_tx ALLOWED_RANGES {2 4 8 16 32 64 128 256 512 1024 2048 4096 8192}
#set_parameter_property fifo_size_tx GROUP "TX FIFO usage"
set_parameter_property fifo_size_tx DESCRIPTION "Number of entries allowed in the TX FIFO"
set_parameter_property fifo_size_tx AFFECTS_ELABORATION true

add_parameter tx_fifo_LE BOOLEAN false ""
set_parameter_property tx_fifo_LE DISPLAY_NAME "Build FIFOs from LEs"
set_parameter_property tx_fifo_LE UNITS None
#set_parameter_property tx_fifo_LE GROUP "TX FIFO usage"
set_parameter_property tx_fifo_LE AFFECTS_ELABORATION false
set_parameter_property tx_fifo_LE DESCRIPTION "Don't use memory blocks for FIFO use LEs instead."

add_parameter tx_IRQ_Threshold INTEGER 1 ""
set_parameter_property tx_IRQ_Threshold DISPLAY_NAME "TX IRQ Threshold (words): "
set_parameter_property tx_IRQ_Threshold UNITS None
set_parameter_property tx_IRQ_Threshold ALLOWED_RANGES {1:8191}
#set_parameter_property tx_IRQ_Threshold GROUP "TX FIFO usage"
set_parameter_property tx_IRQ_Threshold DESCRIPTION "When the number of chars stored in the tx fifo is equal to or less than this amount the TRDY IRQ will be asserted. Setting to 1 will disable this feature. "
set_parameter_property tx_IRQ_Threshold AFFECTS_ELABORATION true


add_parameter use_rx_fifo BOOLEAN false ""
set_parameter_property use_rx_fifo DISPLAY_NAME "Include receive  FIFOs"
set_parameter_property use_rx_fifo UNITS None
#set_parameter_property use_rx_fifo GROUP "RX FIFO usage"
set_parameter_property use_rx_fifo DESCRIPTION " If selected this option turns on the generation of the Rx FIFOs.  If you do not include FIFOs you will generate a standard Nios UART"
set_parameter_property use_rx_fifo AFFECTS_ELABORATION true


add_parameter fifo_size_rx INTEGER 8 ""
set_parameter_property fifo_size_rx DISPLAY_NAME "RX FIFO depth (words): "
set_parameter_property fifo_size_rx UNITS None
set_parameter_property fifo_size_rx ALLOWED_RANGES {2 4 8 16 32 64 128 256 512 1024 2048 4096 8192}
#set_parameter_property fifo_size_rx GROUP "RX FIFO usage"
set_parameter_property fifo_size_rx DESCRIPTION "Number of entries allowed in the RX FIFO"
set_parameter_property fifo_size_rx AFFECTS_ELABORATION true

add_parameter rx_fifo_LE BOOLEAN false ""
set_parameter_property rx_fifo_LE DISPLAY_NAME "Build FIFOs from LEs"
set_parameter_property rx_fifo_LE UNITS None
#set_parameter_property rx_fifo_LE GROUP "RX FIFO usage"
set_parameter_property rx_fifo_LE DESCRIPTION "USE LE instead of Memory blocks for the RX FIFO"
set_parameter_property rx_fifo_LE AFFECTS_ELABORATION false

add_parameter rx_IRQ_Threshold INTEGER 1 ""
set_parameter_property rx_IRQ_Threshold DISPLAY_NAME "RX IRQ Threshold (words): "
set_parameter_property rx_IRQ_Threshold UNITS None
set_parameter_property rx_IRQ_Threshold ALLOWED_RANGES {1:8191}
#set_parameter_property rx_IRQ_Threshold GROUP "RX FIFO usage"
set_parameter_property rx_IRQ_Threshold DESCRIPTION "The RRDY IRQ will be asserted once there is at least this number of chars in the rx FIFO. (Setting to 1 will disable this feature)"
set_parameter_property rx_IRQ_Threshold AFFECTS_ELABORATION true

add_parameter fifo_export_used BOOLEAN false ""
set_parameter_property fifo_export_used DISPLAY_NAME "Export FIFO used signals "
set_parameter_property fifo_export_used UNITS None
#set_parameter_property fifo_export_used GROUP "FIFO Exorts"
set_parameter_property fifo_export_used DESCRIPTION "Export the FIFO used signals"
set_parameter_property fifo_export_used AFFECTS_ELABORATION true

#add_parameter Has_IRQ BOOLEAN true ""
#set_parameter_property Has_IRQ DISPLAY_NAME "Connect the IRQ to the avalon fabric"
#set_parameter_property Has_IRQ UNITS None
#set_parameter_property Has_IRQ GROUP "MISC"
#set_parameter_property Has_IRQ DESCRIPTION "This should be normally checked"
#set_parameter_property Has_IRQ AFFECTS_ELABORATION true

add_parameter hw_cts BOOLEAN false ""
set_parameter_property hw_cts DISPLAY_NAME "Create hardware CTS input ( only valid with fifos) "
set_parameter_property hw_cts UNITS None
#set_parameter_property hw_cts GROUP "MISC"
set_parameter_property hw_cts DESCRIPTION "Create hardware CTS - software not involved."
set_parameter_property hw_cts AFFECTS_ELABORATION true

add_parameter trans_pin BOOLEAN false ""
set_parameter_property trans_pin DISPLAY_NAME "Create hardware which asserts only when uart is transmiting.  usefull for RS485"
set_parameter_property trans_pin UNITS None
#set_parameter_property trans_pin GROUP "MISC"
set_parameter_property trans_pin DESCRIPTION "Creates a signal that asserts when the uart is transmitting. Intended for RS485"
set_parameter_property trans_pin AFFECTS_ELABORATION true


add_parameter use_timout BOOLEAN false "If character in the input fifo but no other chars have been recieve for the period described below the interrupt will fire"
set_parameter_property use_timout DISPLAY_NAME "Enable Rx Timeout "
set_parameter_property use_timout UNITS None
#set_parameter_property use_timout GROUP "RX FIFO usage"
set_parameter_property use_timout DESCRIPTION "If character in the input fifo but no other chars have been recieve for the period described below the interrupt will fire"
set_parameter_property use_timout AFFECTS_ELABORATION false

add_parameter timeout_value INTEGER 4 "IF 4 was select and there were a char in the rx fifo and no new char has been in 4 characters periods then the rx_interrupt will fire"
set_parameter_property timeout_value DISPLAY_NAME "     Timeout in Character periods."
set_parameter_property timeout_value UNITS None
#conter is only 5 bits so can't go larger than 31
set_parameter_property timeout_value ALLOWED_RANGES {1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31}
#set_parameter_property timeout_value GROUP "RX FIFO usage"
set_parameter_property timeout_value DESCRIPTION "Timeout in Character periods."
set_parameter_property timeout_value AFFECTS_ELABORATION false

add_parameter use_gap_detection BOOLEAN false "If no chars have been recieve for the period described below the interrupt will fire"
set_parameter_property use_gap_detection DISPLAY_NAME "Enable Rx Gap detection "
set_parameter_property use_gap_detection UNITS None
#set_parameter_property use_gap_detection GROUP "RX FIFO usage"
set_parameter_property use_gap_detection DESCRIPTION "If no chars have been recieve for specified number of char lengths the interrupt will fire"
set_parameter_property use_gap_detection AFFECTS_ELABORATION false

add_parameter gap_value INTEGER 4 "IF 4 was select and there were nocharacters recieved for  4 characters periods then the rx_gap irq will fire"
set_parameter_property gap_value DISPLAY_NAME "     Timeout in Character periods."
set_parameter_property gap_value UNITS None
#conter is only 5 bits so can't go larger than 31
set_parameter_property gap_value ALLOWED_RANGES {1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31}
#set_parameter_property gap_value GROUP "RX FIFO usage"
set_parameter_property gap_value DESCRIPTION "number of chars to wait before issuing a gap timeout."
set_parameter_property gap_value AFFECTS_ELABORATION false

# time stamp stuff
add_parameter use_timestamp BOOLEAN false "FIFO will be added to accomodate the extra data."
set_parameter_property use_timestamp DISPLAY_NAME "Enable Timestamp register"
set_parameter_property use_timestamp UNITS None
#set_parameter_property use_timestamp GROUP "RX FIFO usage"
set_parameter_property use_timestamp DESCRIPTION "This adds an additional FIFO to the uart and register which contains a timestamp for each Character that is received.  This timestamp can be internally generated and is incremented at the rate of Baudrate/8 or can be supplied externally. The fifo does not change when it is read.  So reading it 50 times will yield the same results. The value is only popped off the FIFO when the RXDATA register is read. In this way they always remain in sync.  If you using the option you will need to rewrite the RX driver so that you can do the appropriate things with this data.  The default driver does nothing with this register"
set_parameter_property use_timestamp AFFECTS_ELABORATION true

add_parameter use_ext_timestamp BOOLEAN false "Siganls will be exported to allow user logic to drive the fifo input"
set_parameter_property use_ext_timestamp DISPLAY_NAME "Use external logic for timestamp. Internal is  the baudrate/8"
set_parameter_property use_ext_timestamp UNITS None
#set_parameter_property use_ext_timestamp GROUP "RX FIFO usage"
set_parameter_property use_ext_timestamp DESCRIPTION "This exports the timestamp input signals so an external source can provide the value. If not selected the internal source is used and increments at the rate of  Baudrate/8"
set_parameter_property use_ext_timestamp AFFECTS_ELABORATION true


add_parameter timestamp_width INTEGER 8 "Width of the counter and fifo associated with the timestamp"
set_parameter_property timestamp_width DISPLAY_NAME "Width of timestamp fifo and register."
set_parameter_property timestamp_width UNITS None
set_parameter_property timestamp_width ALLOWED_RANGES {8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31}
#set_parameter_property timestamp_width GROUP "RX FIFO usage"
set_parameter_property timestamp_width DESCRIPTION ""
set_parameter_property timestamp_width AFFECTS_ELABORATION true

#error bits in fifo

add_parameter export_handshake BOOLEAN false "Export hanshake "
set_parameter_property export_handshake DISPLAY_NAME "Export davataavalible and readyfordata as a conduit"
set_parameter_property export_handshake UNITS None
#set_parameter_property export_handshake GROUP "MISC"
set_parameter_property export_handshake DESCRIPTION "Export davataavalible and readyfordata as a conduit"
set_parameter_property export_handshake AFFECTS_ELABORATION true


add_parameter add_error_bits BOOLEAN false "Theses will be bits 10-13. "
set_parameter_property add_error_bits DISPLAY_NAME "Enable PE, FE, BRK, ROE, GAP, RxEMPTY fifo data"
set_parameter_property add_error_bits UNITS None
#set_parameter_property add_error_bits GROUP "RX FIFO usage"
set_parameter_property add_error_bits DESCRIPTION " This option adds these status bits to the RxData register. Without this feature it would be very difficult to determine where these various error or flagged conditions occurred. All you would know is that they did occurred but not know where.  "
set_parameter_property add_error_bits AFFECTS_ELABORATION false


add_parameter driver_pass_error_bits BOOLEAN false "Allows your local code to interpret these bits and driver will nothing with them."
set_parameter_property driver_pass_error_bits DISPLAY_NAME "     Driver: Pass error bits with data bits."
set_parameter_property driver_pass_error_bits UNITS None
#set_parameter_property driver_pass_error_bits GROUP "RX FIFO usage"
set_parameter_property driver_pass_error_bits DESCRIPTION "The intent is that would instruct the driver to pass the error bits on to the application when a getchar is called.  However this will not be complete as of this version. This touches a lot of code this will be left to a future release"
set_parameter_property driver_pass_error_bits AFFECTS_ELABORATION false

# system info parameters

add_parameter clockRate LONG
set_parameter_property clockRate DEFAULT_VALUE {0}
set_parameter_property clockRate DISPLAY_NAME {clockRate}
set_parameter_property clockRate VISIBLE {0}
set_parameter_property clockRate AFFECTS_GENERATION {1}
set_parameter_property clockRate HDL_PARAMETER {0}
set_parameter_property clockRate SYSTEM_INFO {clock_rate clk}
set_parameter_property clockRate SYSTEM_INFO_TYPE {CLOCK_RATE}
set_parameter_property clockRate SYSTEM_INFO_ARG {clk}

# derived parameters

add_parameter baudError FLOAT
set_parameter_property baudError DEFAULT_VALUE {0.0}
set_parameter_property baudError DISPLAY_NAME {Baud error}
set_parameter_property baudError DERIVED {1}
set_parameter_property baudError AFFECTS_GENERATION {1}
set_parameter_property baudError HDL_PARAMETER {0}

add_parameter parityFisrtChar STRING
set_parameter_property parityFisrtChar DEFAULT_VALUE {N}
set_parameter_property parityFisrtChar DISPLAY_NAME {parityFisrtChar}
set_parameter_property parityFisrtChar VISIBLE {0}
set_parameter_property parityFisrtChar DERIVED {1}
set_parameter_property parityFisrtChar AFFECTS_GENERATION {1}
set_parameter_property parityFisrtChar HDL_PARAMETER {0}



#-------------------------------------------------------------------------------
# module GUI
#-------------------------------------------------------------------------------

# display group
add_display_item {} {Basic settings} GROUP
add_display_item {} {Baud rate} GROUP
add_display_item {} {TX FIFO usage} GROUP
add_display_item {} {RX FIFO usage} GROUP
add_display_item {} {MISC} GROUP

# group parameter
add_display_item {Basic settings} parity PARAMETER
add_display_item {Basic settings} dataBits PARAMETER
add_display_item {Basic settings} stopBits PARAMETER
add_display_item {Basic settings} syncRegDepth PARAMETER
add_display_item {Basic settings} useCtsRts PARAMETER
add_display_item {Basic settings} hw_cts PARAMETER
add_display_item {Basic settings} useEopRegister PARAMETER

add_display_item {Baud rate} baud PARAMETER
add_display_item {Baud rate} baudError PARAMETER
add_display_item {Baud rate} fixedBaud PARAMETER

add_display_item {TX FIFO usage} use_tx_fifo PARAMETER
add_display_item {TX FIFO usage} fifo_size_tx PARAMETER
add_display_item {TX FIFO usage} tx_IRQ_Threshold PARAMETER
add_display_item {TX FIFO usage} tx_fifo_LE PARAMETER

add_display_item {RX FIFO usage} use_rx_fifo PARAMETER
add_display_item {RX FIFO usage} fifo_size_rx PARAMETER
add_display_item {RX FIFO usage} rx_IRQ_Threshold PARAMETER
add_display_item {RX FIFO usage} rx_fifo_LE PARAMETER
add_display_item {RX FIFO usage} use_timout PARAMETER
add_display_item {RX FIFO usage} timeout_value PARAMETER
add_display_item {RX FIFO usage} use_gap_detection PARAMETER
add_display_item {RX FIFO usage} gap_value PARAMETER
add_display_item {RX FIFO usage} use_timestamp PARAMETER
add_display_item {RX FIFO usage} use_ext_timestamp PARAMETER
add_display_item {RX FIFO usage} timestamp_width PARAMETER
add_display_item {RX FIFO usage} rx_fifo_LE PARAMETER
add_display_item {RX FIFO usage} rx_fifo_LE PARAMETER

add_display_item {MISC} fifo_export_used PARAMETER
add_display_item {MISC} trans_pin PARAMETER
add_display_item {MISC} export_handshake PARAMETER
add_display_item {MISC} add_error_bits PARAMETER
add_display_item {MISC} driver_pass_error_bits PARAMETER
add_display_item {MISC} use_status_bit_clear PARAMETER


#set_parameter_property use_tx_fifo GROUP "TX FIFO usage"
#set_parameter_property tx_IRQ_Threshold GROUP "TX FIFO usage"
#set_parameter_property fifo_size_tx GROUP "TX FIFO usage"
#set_parameter_property use_rx_fifo GROUP "RX FIFO usage"
#set_parameter_property fifo_size_rx GROUP "RX FIFO usage"
#set_parameter_property rx_fifo_LE GROUP "RX FIFO usage"
#set_parameter_property rx_IRQ_Threshold GROUP "RX FIFO usage"
set_parameter_property fifo_export_used GROUP "MISC"
set_parameter_property hw_cts GROUP "MISC"
set_parameter_property trans_pin GROUP "MISC"
#set_parameter_property use_timout GROUP "RX FIFO usage"
#set_parameter_property timeout_value GROUP "RX FIFO usage"
#set_parameter_property use_gap_detection GROUP "RX FIFO usage"
#set_parameter_property gap_value GROUP "RX FIFO usage"
#set_parameter_property use_timestamp GROUP "RX FIFO usage"
#set_parameter_property use_ext_timestamp GROUP "RX FIFO usage"
#set_parameter_property timestamp_width GROUP "RX FIFO usage"
set_parameter_property export_handshake GROUP "MISC"
set_parameter_property add_error_bits GROUP "RX FIFO usage"
set_parameter_property driver_pass_error_bits GROUP "RX FIFO usage"
set_parameter_property use_status_bit_clear GROUP "MISC"
#-------------------------------------------------------------------------------
# module validation
#-------------------------------------------------------------------------------
proc calculateMinBaud { systemClock } {
  if { !$systemClock } {
    return 0
  }
  
  return [ expr int(ceil(double($systemClock)/double(65535)))]
}

proc calculateDivisorBits { divisor } {
  if {$divisor == 1} {
    return 1	
  } else {
    return [ expr ceil(log($divisor)/log(2.0))]
  }
}

proc calculateDivisor { systemClock myBaud } {
  if { !$systemClock } {
    return 1
  }
  
  set divisor [ expr round( double($systemClock)/double($myBaud) )]
  return $divisor
}

proc calculateActualBaud { systemClock myBaud } {
  return [ expr double($systemClock)/double([calculateDivisor $systemClock $myBaud])]
}

proc calculateBaudError { systemClock myBaud } {
  if { !$systemClock } {
    return 0 
  }	

  set actualBaud [ expr [calculateActualBaud $systemClock $myBaud] ]
  set baudDiff [ expr abs($actualBaud - $myBaud) ]
  set calculatedError [ expr ( 100.0*$baudDiff )/ $myBaud ]
  
  return $calculatedError
}

proc roundBaudError { calculatedError } {
  if { $calculatedError < 0.01 } {
    return 0.01
  }
  return [ expr double( round(($calculatedError*100.0)/100.0) ) ]
}

#
#  validate function ---------------------------------------------------------------------
#
proc validate {} {
	# read user and system info parameter
	set baud [ get_parameter_value baud ]
	set clockRate [ get_parameter_value clockRate ]
      	set dataBits [ get_parameter_value dataBits ]
	set fixedBaud [ proc_get_boolean_parameter fixedBaud ]
	set parity [ get_parameter_value parity ]
	set simCharStream [ get_parameter_value simCharStream ]
	set simInteractiveInputEnable [ proc_get_boolean_parameter simInteractiveInputEnable ]
	set simInteractiveOutputEnable [ proc_get_boolean_parameter simInteractiveOutputEnable ]
	set simTrueBaud [ proc_get_boolean_parameter simTrueBaud ]
	set stopBits [ get_parameter_value stopBits ]
	set syncRegDepth [ get_parameter_value syncRegDepth ]
	set useCtsRts [ proc_get_boolean_parameter useCtsRts ]
	set useEopRegister [ proc_get_boolean_parameter useEopRegister ]
	set useRelativePathForSimFile [ proc_get_boolean_parameter useRelativePathForSimFile ]
	
	# validate parameter and update derived parameter
	set baudError [ get_parameter_value baudError ]
	set parityFisrtChar [ get_parameter_value parityFisrtChar ]
	
	# GUI parameter enabling and disabling

	if  { [get_parameter_value "use_rx_fifo"] }  {
	  set_parameter_property fifo_size_rx ENABLED true
	  set_parameter_property fifo_export_used ENABLED true
	  set_parameter_property rx_IRQ_Threshold ENABLED true
	  set_parameter_property use_timout ENABLED true
	  set_parameter_property use_gap_detection ENABLED true
	  set_parameter_property gap_value ENABLED true
	  set_parameter_property rx_fifo_LE ENABLED true
	  set_parameter_property use_timestamp ENABLED true
	  if  { [get_parameter_value "use_timestamp"] }  {
	      set_parameter_property use_ext_timestamp ENABLED true
	      set_parameter_property timestamp_width ENABLED true 
	      } else {
	      set_parameter_property use_ext_timestamp ENABLED false
	      set_parameter_property timestamp_width ENABLED false
	  }
	  set_parameter_property add_error_bits ENABLED true
	  if  { [get_parameter_value "add_error_bits"] }  {
	      set_parameter_property driver_pass_error_bits ENABLED true
	      } else {
	      set_parameter_property driver_pass_error_bits ENABLED false
	  }
	} else {
	  set_parameter_property fifo_size_rx ENABLED false
	  set_parameter_property fifo_export_used ENABLED false
	  set_parameter_property rx_IRQ_Threshold ENABLED false
	  set_parameter_property use_timout ENABLED false
	  set_parameter_property use_gap_detection ENABLED false
	  set_parameter_property gap_value ENABLED false
	  set_parameter_property rx_fifo_LE ENABLED false
	  set_parameter_property use_timestamp ENABLED false
	  set_parameter_property use_ext_timestamp ENABLED false
	  set_parameter_property timestamp_width ENABLED false
	  set_parameter_property add_error_bits ENABLED false
	  set_parameter_property driver_pass_error_bits ENABLED false
      #    set_parameter_value use_timout false
	}

      if  { [get_parameter_value "use_tx_fifo"] }  {
	set_parameter_property fifo_size_tx ENABLED true
	set_parameter_property tx_IRQ_Threshold ENABLED true
      } else {
	set_parameter_property fifo_size_tx ENABLED false
	set_parameter_property tx_IRQ_Threshold ENABLED false
      }

      if  { [get_parameter_value "use_timout"] }  {
	set_parameter_property timeout_value ENABLED true
      } else {
	set_parameter_property timeout_value ENABLED false
      }
	if  { [get_parameter_value "use_gap_detection"] }  {
	set_parameter_property gap_value ENABLED true
      } else {
	set_parameter_property gap_value ENABLED false
      }


      # Get the current value of parameters we care about
      set rx [get_parameter_value fifo_size_rx]
      set tx [get_parameter_value fifo_size_tx]
      set rx_IRQ [get_parameter_value rx_IRQ_Threshold]
      set tx_IRQ [get_parameter_value tx_IRQ_Threshold]
      set parity [ get_parameter_value parity ]

      if { [get_parameter_value "use_rx_fifo"]  &&  [ expr $rx_IRQ > ($rx -1 ) ] } {
	send_message error "rx_IRQ_Threshold must be at least one less than rx fifo size"
	}
      if { [get_parameter_value "use_tx_fifo"]  &&  [ expr $tx_IRQ > ($tx -1 ) ] } {
	send_message error "tx_IRQ_Threshold must be at least one less than tx fifo size"
	}
      if { $clockRate > 0 } {
	    # Validate baud error too large warning
	    if { [calculateBaudError $clockRate $baud] >= 3.0 } {
	      send_message warning "Baud error too large, UART may not function"	
	    }
	    
	    #Validate baud rate too low error
	    set divisor [ calculateDivisor $clockRate $baud ]
	    set minBaud [ calculateMinBaud $clockRate ]           	    
	      if { [calculateDivisorBits $divisor] > 24 } {   
	      send_message error "Baud rate too low, must be at least $minBaud bps"
	    }
					  
	} else {
	  send_message warning "No Baud rate validation because the clock rate is unknown"		
	}
	
    # update Baud error display
	set baudError [ roundBaudError [calculateBaudError $clockRate $baud] ]
    
	# embedded software assignments
	set parityFisrtChar [ string index $parity "0" ]
	set_module_assignment embeddedsw.CMacro.BAUD $baud
	set_module_assignment embeddedsw.CMacro.DATA_BITS $dataBits
	set_module_assignment embeddedsw.CMacro.FIXED_BAUD $fixedBaud
	set_module_assignment embeddedsw.CMacro.PARITY "'$parityFisrtChar'"
	set_module_assignment embeddedsw.CMacro.STOP_BITS $stopBits
	set_module_assignment embeddedsw.CMacro.SYNC_REG_DEPTH $syncRegDepth
	set_module_assignment embeddedsw.CMacro.USE_CTS_RTS $useCtsRts
	set_module_assignment embeddedsw.CMacro.USE_EOP_REGISTER $useEopRegister
	set_module_assignment embeddedsw.CMacro.SIM_TRUE_BAUD $simTrueBaud
	set_module_assignment embeddedsw.CMacro.SIM_CHAR_STREAM "\"$simCharStream\""
	set_module_assignment embeddedsw.CMacro.FREQ $clockRate	
	set_module_assignment embeddedsw.CMacro.USE_TX_FIFO [proc_get_boolean_parameter "use_tx_fifo"] 
	set_module_assignment embeddedsw.CMacro.TX_FIFO_SIZE [get_parameter_value "fifo_size_tx"]
	set_module_assignment embeddedsw.CMacro.TX_FIFO_LE [proc_get_boolean_parameter "tx_fifo_LE"] 
	set_module_assignment embeddedsw.CMacro.TX_IRQ_THRESHOLD  [get_parameter_value "tx_IRQ_Threshold"]
	set_module_assignment embeddedsw.CMacro.USE_RX_FIFO [proc_get_boolean_parameter "use_rx_fifo"] 
	set_module_assignment embeddedsw.CMacro.RX_FIFO_SIZE [get_parameter_value "fifo_size_rx"]
	set_module_assignment embeddedsw.CMacro.RX_FIFO_LE [proc_get_boolean_parameter "rx_fifo_LE"] 
	set_module_assignment embeddedsw.CMacro.RX_IRQ_THRESHOLD  [get_parameter_value "rx_IRQ_Threshold"]
	set_module_assignment embeddedsw.CMacro.USE_TIMESTAMP [proc_get_boolean_parameter "use_timestamp"] 
	set_module_assignment embeddedsw.CMacro.ADD_ERROR_BITS [proc_get_boolean_parameter "add_error_bits"] 
	set_module_assignment embeddedsw.CMacro.FIFO_EXPORT_USED [proc_get_boolean_parameter "fifo_export_used"] 
      #  set_module_assignment embeddedsw.CMacro.HAS_IRQ [proc_get_boolean_parameter "Has_IRQ"]
	set_module_assignment embeddedsw.CMacro.UHW_CTS [proc_get_boolean_parameter "hw_cts"] 
	set_module_assignment embeddedsw.CMacro.TRANSMIT_PIN [proc_get_boolean_parameter "trans_pin"] 
	set_module_assignment embeddedsw.CMacro.USE_RX_TIMEOUT [proc_get_boolean_parameter "use_timout"] 
	set_module_assignment embeddedsw.CMacro.TIMEOUT_VALUE  [get_parameter_value "timeout_value"]
	set_module_assignment embeddedsw.CMacro.USE_GAP_DETECTION [proc_get_boolean_parameter "use_gap_detection"] 
	set_module_assignment embeddedsw.CMacro.GAP_VALUE  [get_parameter_value "gap_value"]
	set_module_assignment embeddedsw.CMacro.USE_EXT_TIMESTAMP [proc_get_boolean_parameter "use_ext_timestamp"] 
	set_module_assignment embeddedsw.CMacro.TIMESTAMP_WIDTH  [get_parameter_value "timestamp_width"]
	set_module_assignment embeddedsw.CMacro.ADD_ERROR_BITS [proc_get_boolean_parameter "add_error_bits"] 
	set_module_assignment embeddedsw.CMacro.PASS_ERROR_BITS [proc_get_boolean_parameter "driver_pass_error_bits"] 
	set_module_assignment embeddedsw.CMacro.USE_STATUS_BIT_CLEAR [proc_get_boolean_parameter "use_status_bit_clear"] 
      
  
 
 # Device tree parameters
	set_module_assignment embeddedsw.dts.vendor "altr"
	set_module_assignment embeddedsw.dts.group "serial"
	set_module_assignment embeddedsw.dts.name "uart"
	set_module_assignment embeddedsw.dts.compatible "altr,uart-1.0"
	set_module_assignment {embeddedsw.dts.params.current-speed} $baud
	set_module_assignment {embeddedsw.dts.params.clock-frequency} $clockRate
	 
	# update derived parameter

	set_parameter_value baudError $baudError
	set_parameter_value parityFisrtChar $parityFisrtChar
 
}

#-------------------------------------------------------------------------------
# module elaboration
#-------------------------------------------------------------------------------

proc elaborate {} {

	# read parameter

	set baud [ get_parameter_value baud ]
	set baudError [ get_parameter_value baudError ]
	set clockRate [ get_parameter_value clockRate ]
	set dataBits [ get_parameter_value dataBits ]
	set fixedBaud [ proc_get_boolean_parameter fixedBaud ]
	set parity [ get_parameter_value parity ]
	set simCharStream [ get_parameter_value simCharStream ]
	set simInteractiveInputEnable [ proc_get_boolean_parameter simInteractiveInputEnable ]
	set simInteractiveOutputEnable [ proc_get_boolean_parameter simInteractiveOutputEnable ]
	set simTrueBaud [ proc_get_boolean_parameter simTrueBaud ]
	set stopBits [ get_parameter_value stopBits ]
	set syncRegDepth [ get_parameter_value syncRegDepth ]
	set useCtsRts [ proc_get_boolean_parameter useCtsRts ]
	set useEopRegister [ proc_get_boolean_parameter useEopRegister ]
	set useRelativePathForSimFile [ proc_get_boolean_parameter useRelativePathForSimFile ]


# interfaces

	add_interface clk clock sink
	set_interface_property clk clockRate {0.0}
	set_interface_property clk externallyDriven {0}
	add_interface_port clk clk clk Input 1

	add_interface reset reset sink
	set_interface_property reset associatedClock {clk}
	set_interface_property reset synchronousEdges {DEASSERT}
	add_interface_port reset reset_n reset_n Input 1
	
	
	add_interface s1 avalon slave
	set_interface_property s1 addressAlignment {NATIVE}
	set_interface_property s1 addressGroup {0}
	set_interface_property s1 addressSpan {16}
	set_interface_property s1 addressUnits {WORDS}
	set_interface_property s1 alwaysBurstMaxBurst {0}
	set_interface_property s1 associatedClock {clk}
	set_interface_property s1 associatedReset {reset}
	set_interface_property s1 bitsPerSymbol {8}
	set_interface_property s1 burstOnBurstBoundariesOnly {0}
	set_interface_property s1 burstcountUnits {WORDS}
	set_interface_property s1 constantBurstBehavior {0}
	set_interface_property s1 explicitAddressSpan {0}
	set_interface_property s1 holdTime {0}
	set_interface_property s1 interleaveBursts {0}
	set_interface_property s1 isBigEndian {0}
	set_interface_property s1 isFlash {0}
	set_interface_property s1 isMemoryDevice {0}
	set_interface_property s1 isNonVolatileStorage {0}
	set_interface_property s1 linewrapBursts {0}
	set_interface_property s1 maximumPendingReadTransactions {0}
	set_interface_property s1 minimumUninterruptedRunLength {1}
	set_interface_property s1 printableDevice {1}
	set_interface_property s1 readLatency {0}
	set_interface_property s1 readWaitStates {1}
	set_interface_property s1 readWaitTime {1}
	set_interface_property s1 registerIncomingSignals {0}
	set_interface_property s1 registerOutgoingSignals {0}
	set_interface_property s1 setupTime {0}
	set_interface_property s1 timingUnits {Cycles}
	set_interface_property s1 transparentBridge {0}
	set_interface_property s1 wellBehavedWaitrequest {0}
	set_interface_property s1 writeLatency {0}
	set_interface_property s1 writeWaitStates {1}
	set_interface_property s1 writeWaitTime {1}

	add_interface_port s1 address address Input 4
	add_interface_port s1 begintransfer begintransfer Input 1
	add_interface_port s1 chipselect chipselect Input 1
	add_interface_port s1 read_n read_n Input 1
	add_interface_port s1 write_n write_n Input 1
	add_interface_port s1 writedata writedata Input 32
	add_interface_port s1 readdata readdata Output 32
	#add_interface_port s1 dataavailable dataavailable Output 1
	#add_interface_port s1 readyfordata readyfordata Output 1

	
	if { $useEopRegister } { 
	    add_interface_port s1 endofpacket endofpacket Output 1
	} 
	set_interface_assignment s1 embeddedsw.configuration.isPrintableDevice {1}

	add_interface external_connection conduit conduit
	add_interface_port external_connection rxd export Input 1
	add_interface_port external_connection txd export Output 1	
	if { $useCtsRts  } {
	    add_interface_port external_connection cts_n export Input 1
	    add_interface_port external_connection rts_n export Output 1
	}

	add_interface irq interrupt sender
	set_interface_property irq associatedAddressablePoint {s1}
	set_interface_property irq associatedClock {clk}
	set_interface_property irq associatedReset {reset}
	set_interface_property irq irqScheme {NONE}

	add_interface_port irq irq irq Output 1
	
	add_interface handshake conduit end
	add_interface_port handshake readyfordata readyfordata Output 1
	add_interface_port handshake dataavailable dataavailable Output 1
	if  { [get_parameter_value "export_handshake"] }  {
	set_port_property dataavailable termination false
	set_port_property readyfordata termination false
	} else {
	set_port_property dataavailable termination true
	set_port_property readyfordata termination true
	}


	if  { [get_parameter_value "fifo_export_used"] }  {
	#expr log(1000)/log(10)
	    add_interface fifo_used conduit end
	    set tx_fifo_address_bits [expr {int( 1 + (log ( [ get_parameter_value "fifo_size_tx" ] ) / log(2) ) ) } ]
	    set rx_fifo_address_bits [expr {int( 1 + (log ( [ get_parameter_value "fifo_size_rx" ] ) / log(2) ) ) } ]
	    add_interface_port fifo_used rxused export Output $rx_fifo_address_bits
	    add_interface_port fifo_used txused export Output  $tx_fifo_address_bits
	}
	
	if {  [get_parameter_value "hw_cts"] } {
	    add_interface_port external_connection cts_n export Input 1
	}
	if  { [get_parameter_value "trans_pin"] }   {
	    add_interface_port external_connection transmitting export Output 1
	}
	if { [get_parameter_value "use_timestamp"] && [get_parameter_value "use_ext_timestamp"] }  {
	    add_interface_port external_connection timestamp_in export Input [get_parameter_value "timestamp_width"]
	}
	
 }


#-------------------------------------------------------------------------------
# module generation
#-------------------------------------------------------------------------------
# generate
proc generate {output_name output_directory rtl_ext simgen} {
	global env
	set QUARTUS_ROOTDIR         "$env(QUARTUS_ROOTDIR)"
#	set component_directory     "fifoed_altera_avalon_uart"
	set component_directory     [pwd]
	set component_config_file   "$output_directory/${output_name}_component_configuration.pl"


send_message info "Starting FIFOed UART Generation at $component_directory"

	set baud [ get_parameter_value baud ]
	set baudError [ get_parameter_value baudError ]
	set clockRate [ get_parameter_value clockRate ]
	set dataBits [ get_parameter_value dataBits ]
	set fixedBaud [ proc_get_boolean_parameter fixedBaud ]
	set parity [ get_parameter_value parity ]
	set simCharStream [ get_parameter_value simCharStream ]
	set simInteractiveInputEnable [ proc_get_boolean_parameter simInteractiveInputEnable ]
	set simInteractiveOutputEnable [ proc_get_boolean_parameter simInteractiveOutputEnable ]
	set simTrueBaud [ proc_get_boolean_parameter simTrueBaud ]
	set stopBits [ get_parameter_value stopBits ]
	set syncRegDepth [ get_parameter_value syncRegDepth ]
	set useCtsRts [ proc_get_boolean_parameter useCtsRts ]
	set useEopRegister [ proc_get_boolean_parameter useEopRegister ]
	set useRelativePathForSimFile [ proc_get_boolean_parameter useRelativePathForSimFile ]

	set parityFisrtChar [ get_parameter_value parityFisrtChar ]
	
	# prepare config file
	set component_config    [open $component_config_file "w"]

  # new to the fifoed uart. 

	set  use_tx_fifo [proc_get_boolean_parameter use_tx_fifo] 
	set  use_rx_fifo [proc_get_boolean_parameter use_rx_fifo] 
  
	set  fifo_export_used [proc_get_boolean_parameter fifo_export_used] 
	set  hw_cts [proc_get_boolean_parameter hw_cts]
	set  trans_pin [proc_get_boolean_parameter trans_pin] 
	set  fifo_size_tx [get_parameter_value fifo_size_tx]
	set  fifo_size_rx [get_parameter_value fifo_size_rx]
	set  use_timout [proc_get_boolean_parameter use_timout] 
	if  { [proc_get_boolean_parameter use_rx_fifo ] == 0 } { 
	  set use_timout 0 };
	set  timeout_value [get_parameter_value timeout_value]
	set  rx_IRQ_Threshold [get_parameter_value rx_IRQ_Threshold]
	set  tx_IRQ_Threshold [get_parameter_value tx_IRQ_Threshold]
	set  rx_fifo_LE [proc_get_boolean_parameter rx_fifo_LE] 
	set  tx_fifo_LE [proc_get_boolean_parameter tx_fifo_LE] 
	set gap_value [get_parameter_value gap_value]
	set  use_gap_detection [proc_get_boolean_parameter use_gap_detection] 
	if  { [proc_get_boolean_parameter use_rx_fifo ]== 0 } {
	    set use_gap_detection 0 };
	set use_timestamp [proc_get_boolean_parameter use_timestamp] 
	set use_ext_timestamp [proc_get_boolean_parameter use_ext_timestamp]
	set timestamp_width  [get_parameter_value timestamp_width]
	set add_error_bits  [proc_get_boolean_parameter add_error_bits] 
	set use_status_bit_clear  [proc_get_boolean_parameter use_status_bit_clear] 
	set fifo_export_used  [proc_get_boolean_parameter fifo_export_used] 


  
	puts $component_config "# ${output_name} Component Configuration File"
	puts $component_config "return {"

	puts $component_config "\tbaud			=> $baud,"
	puts $component_config "\tdata_bits		=> $dataBits,"
	puts $component_config "\tfixed_baud		=> $fixedBaud,"
	puts $component_config "\tparity		=> \"$parityFisrtChar\","
	puts $component_config "\tstop_bits		=> $stopBits,"
	puts $component_config "\tsync_reg_depth	=> $syncRegDepth,"
	puts $component_config "\tuse_cts_rts		=> $useCtsRts,"
	puts $component_config "\tuse_eop_register	=> $useEopRegister,"
	puts $component_config "\tsim_true_baud		=> $simTrueBaud,"
	puts $component_config "\tsim_char_stream	=> \"$simCharStream\","
	puts $component_config "\trelativepath		=> 1,"
	puts $component_config "\tsystem_clk_freq	=> $clockRate,"
# new stuff	
	puts $component_config "\tuse_tx_fifo		=> $use_tx_fifo,"
	puts $component_config "\tuse_rx_fifo		=> $use_rx_fifo,"
	puts $component_config "\thw_cts		=> $hw_cts,"
	puts $component_config "\ttrans_pin	=> $trans_pin,"
	puts $component_config "\tfifo_size_tx	=> $fifo_size_tx,"
	puts $component_config "\tfifo_size_rx	=> $fifo_size_rx,"
	puts $component_config "\tuse_timout	=> $use_timout,"
	puts $component_config "\ttimeout_value	=> $timeout_value,"
	puts $component_config "\trx_IRQ_Threshold	=> $rx_IRQ_Threshold,"
	puts $component_config "\ttx_IRQ_Threshold	=> $tx_IRQ_Threshold,"
	puts $component_config "\trx_fifo_LE	=> $rx_fifo_LE,"
	puts $component_config "\ttx_fifo_LE	=> $tx_fifo_LE,"
	puts $component_config "\tgap_value	=> $gap_value,"
	puts $component_config "\tuse_gap_detection	=> $use_gap_detection,"
	puts $component_config "\tuse_timestamp	=> $use_timestamp,"
	puts $component_config "\tuse_ext_timestamp	=> $use_ext_timestamp,"
	puts $component_config "\ttimestamp_width	=> $timestamp_width,"
	puts $component_config "\tadd_error_bits	=> $add_error_bits,"
	puts $component_config "\tuse_status_bit_clear	=> $use_status_bit_clear,"
	puts $component_config "\tfifo_export_used	=> $fifo_export_used,"

	puts $component_config "};"
	close $component_config
#	these line are for debug only. 
#	file copy -force $component_config_file /data/cruben/fifoed_uart_config.pl
#running outside of qsys
#exec /tools/acds/13.1.4/182/linux32/quartus/linux/perl/bin/perl -I /tools/acds/13.1.4/182/linux32/quartus/linux/perl/lib -I /tools/acds/13.1.4/182/linux32/quartus/sopc_builder/bin/europa -I /tools/acds/13.1.4/182/linux32/quartus/sopc_builder/bin/perl_lib -I /tools/acds/13.1.4/182/linux32/quartus/sopc_builder/bin -I /tools/acds/13.1.4/182/linux32/quartus/../ip/altera/sopc_builder_ip/common -I /data/cruben/my_components/FIFOed_avalon_uart13.1/fifoed_avalon_uart -- /data/cruben/my_components/FIFOed_avalon_uart13.1/fifoed_avalon_uart/generate_rtl.pl --name=small_standard_qsys_14_fuart_0 --dir=/data/cruben --quartus_dir=/tools/acds/13.1.4/182/linux32/quartus --verilog --config=/data/cruben/fifoed_uart_config.pl  --do_build_sim=0 

	# generate rtl
	proc_generate_component_rtl  "$component_config_file" "$component_directory" "$output_name" "$output_directory" "$rtl_ext" "$simgen"
	proc_add_generated_files "$output_name" "$output_directory" "$rtl_ext" "$simgen"



}

