#Copyright (C)2001-2010 Altera Corporation
#Any megafunction design, and related net list (encrypted or decrypted),
#support information, device programming or simulation file, and any other
#associated documentation or information provided by Altera or a partner
#under Altera's Megafunction Partnership Program may be used only to
#program PLD devices (but not masked PLD devices) from Altera.  Any other
#use of such megafunction design, net list, support information, device
#programming or simulation file, or any other related documentation or
#information is prohibited for any other purpose, including, but not
#limited to modification, reverse engineering, de-compiling, or use with
#any other silicon devices, unless such use is explicitly licensed under
#a separate agreement with Altera or a megafunction partner.  Title to
#the intellectual property, including patents, copyrights, trademarks,
#trade secrets, or maskworks, embodied in any such megafunction design,
#net list, support information, device programming or simulation file, or
#any other related documentation or information provided by Altera or a
#megafunction partner, remains with Altera, the megafunction partner, or
#their respective licensors.  No other licenses, including any licenses
#needed under any third party's intellectual property, are provided herein.
#Copying or modifying any file, or portion thereof, to which this notice
#is attached violates this copyright.




use Getopt::Long;
use europa_all;
use em_fifoed_uart_qsys;
use embedded_ip_generate_common;
use strict;

$| = 1;     # Always flush stderr






{
    my $infos = process_args();
    my $project = prepare_project($infos);
    

    my $Options = &copy_of_hash($infos);

    my $module = $project->top();
    
    &make_uart($project, $Options, $module);

# it is nice to able to print out all the parameters so here is a nifty way to do that    
    my $parameters_message = join('', (map {"   --$_=$Options->{$_}\n"} sort keys %$Options));
   $module->comment("Generation parameters:\n" . $parameters_message );
    
    $project->output();


   
    exit(0);
}

