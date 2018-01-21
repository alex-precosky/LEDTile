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
#*/
#
# altera_avalon_uart_lwhal_sw.tcl
#

# Create a new driver
create_driver fifoed_avalon_uart_lwhal_driver

# Associate it with some hardware known as "altera_avalon_uart"
set_sw_property hw_class_name fifoed_avalon_uart

# The version of this driver
set_sw_property version 13.1

# This driver may be incompatible with versions of hardware less
# than specified below. Updates to hardware and device drivers
# rendering the driver incompatible with older versions of
# hardware are noted with this property assignment.
#
# Multiple-Version compatibility was introduced in version 7.1;
# prior versions are therefore excluded.
set_sw_property min_compatible_hw_version 13.1

# Location in generated BSP that above sources will be copied into
set_sw_property bsp_subdirectory drivers

#
# Source file listings...
#

# C/C++ source files
add_sw_property c_source LWHAL/src/fifoed_avalon_uart_lwhal_putchar.c

# Include files
add_sw_property include_source LWHAL/inc/fifoed_avalon_uart_lwhal.h
add_sw_property include_source inc/fifoed_avalon_uart_regs.h

# This driver supports LWHAL (OS) types
add_sw_property supported_bsp_type LWHAL

# End of file
