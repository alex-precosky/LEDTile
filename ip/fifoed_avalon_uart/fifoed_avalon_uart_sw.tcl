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
# altera_avalon_uart_driver.tcl
#

# Create a new driver
create_driver fifoed_avalon_uart_driver

# Associate it with some hardware known as "altera_avalon_uart"
set_sw_property hw_class_name fifoed_avalon_uart

# The version of this driver
set_sw_property version 13.2

# This driver may be incompatible with versions of hardware less
# than specified below. Updates to hardware and device drivers
# rendering the driver incompatible with older versions of
# hardware are noted with this property assignment.
#
# Multiple-Version compatibility was introduced in version 7.1;
# prior versions are therefore excluded.
set_sw_property min_compatible_hw_version 13.1

# Initialize the driver in alt_sys_init()
set_sw_property auto_initialize true

# Location in generated BSP that above sources will be copied into
set_sw_property bsp_subdirectory drivers

# Interrupt properties: This driver supports both legacy and enhanced
# interrupt APIs, as well as ISR preemption.
#set_sw_property isr_preemption_supported true
set_sw_property supported_interrupt_apis "legacy_interrupt_api enhanced_interrupt_api"


#
# Source file listings...
#

# C/C++ source files
add_sw_property c_source HAL/src/fifoed_avalon_uart_fd.c
add_sw_property c_source HAL/src/fifoed_avalon_uart.c

# Include files
add_sw_property include_source HAL/inc/fifoed_avalon_uart.h
add_sw_property include_source HAL/inc/fifoed_avalon_uart_fd.h
add_sw_property include_source inc/fifoed_avalon_uart_regs.h

# This driver supports HAL & UCOSII BSP (OS) types
add_sw_property supported_bsp_type HAL
add_sw_property supported_bsp_type UCOSII

# Add the following per_driver configuration option to the BSP:
#  o Type of setting (boolean_define_only translates to "either
#    emit a #define if true, or don't if false"). Useful for
#    source code with "#ifdef" style build-options.
#  o Generated file to write to (public_mk_define -> public.mk)
#  o Name of setting for use with bsp command line settings tools
#    (enable_small_driver). This name will be combined with the
#    driver class to form a settings hierarchy to assure unique
#    settings names
#  o '#define' in driver code (and therefore string in generated
#     makefile): "ALTERA_AVALON_UART_SMALL", which means: "emit
#     CPPFLAGS += ALTERA_AVALON_UART_SMALL in generated makefile
#  o Default value (if the user doesn't specify at BSP creation): false
#    (which means: 'do not emit above CPPFLAGS string in generated makefile)
#  o Description text
add_sw_setting boolean_define_only public_mk_define enable_small_driver FIFOED_AVALON_UART_SMALL false "Small-footprint (polled mode) driver"

# Add per-driver configuration option for optional IOCTL functionality in
# UART driver.
add_sw_setting boolean_define_only public_mk_define enable_ioctl FIFOED_AVALON_UART_USE_IOCTL false "Enable driver ioctl() support. This feature is not compatible with the 'small' driver; ioctl() support will not be compiled if either the UART 'enable_small_driver' or HAL 'enable_reduced_device_drivers' settings are enabled."

# End of file
