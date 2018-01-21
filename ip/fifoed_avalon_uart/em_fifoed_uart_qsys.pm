#Copyright (C)2001-2014 Altera Corporation
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

















































































































































































































































































use e_std_synchronizer;
use filename_utils;  # This is for to Perlcopy 'uart.pl'
use europa_all;      # This imports the entire Eurpoa object-library.
use strict;          # This spanks you when you're naughty.  That's






















  
  my $baud;
  my $data_bits;
  my $fixed_baud;
  my $parity;
  my $stop_bits;
  my $sync_reg_depth;
  my $use_cts_rts;
  my $use_eop_register;
  my $sim_true_baud;
  my $sim_char_stream;
  my $relativepath;
  
  my $baud_divisor_constant;
  my $divisor_bits;
  my $clock_freq;
  my $num_control_reg_bits;
  my $num_status_reg_bits;
  my $module_name;
  my $interactive_in;
  my $interactive_out;
  my $tx_module_name;
  my $rx_module_name;
  my $reg_module_name;
  my $log_module_name;
  
  my $log_file;
  my $rx_source_module_name;
  my $sim_char_file;
  my $stream_length;
  my $char_data_file;
  my $char_mutex_file; 
  my $mutex_file_size;
  
# new for fifoed uart
	my $use_tx_fifo;
	my $use_rx_fifo;
	my $hw_cts;
	my $trans_pin;
	my $fifo_size_tx;
	my $fifo_size_rx;
	my $use_timout;
	my $timeout_value;
	my $rx_IRQ_Threshold;
	my $tx_IRQ_Threshold;
	my $rx_fifo_LE;
	my $tx_fifo_LE;
	my $gap_value;
	my $use_gap_detection;
	my $use_timestamp;
	my $use_ext_timestamp;
	my $add_error_bits;
	my $use_status_bit_clear;
	my $timestamp_width;
	my $fifo_export_used;











sub Validate_Uart_Options
{
  my ($Options, $project) = (@_);
  





































  &validate_parameter ({hash    => $Options,
                        name    => "fixed_baud",
                        type    => "boolean",
                        default => 1,
                       });



























  &validate_parameter ({hash    => $Options,
                        name    => "use_cts_rts",
                        type    => "boolean",
                        default => 0,
                       });
































  &validate_parameter ({hash    => $Options,
                        name    => "use_eop_register",
                        type    => "boolean",
                        default => 0,
                       });












# modified to allow the number 10
  &validate_parameter ({hash      => $Options,
                        name      => "data_bits",
                        type      => "integer",
                        allowed   => [7, 8, 9, 10],
                        default   => 8,
                       });














  &validate_parameter ({hash      => $Options,
                        name      => "stop_bits",
                        type      => "integer",
                        allowed   => [1, 2],
                        default   => 2,
                       });



































  &validate_parameter ({hash      => $Options,
                        name      => "parity",
                        type      => "string",
                        allowed   => ["S0", "S1", "E", "O", "N", "P"],
                        default   => "N",
                       });




  &validate_parameter ({hash      => $Options,
                        name      => "sync_reg_depth",
                        type      => "integer",
                        allowed   => [2, 3, 4, 5],
                        default   => 2,
                        message   => "invalid synchronizer depth", 
                       });






#  &validate_parameter ({hash      => $Options,
#                        name      => "baud",
#                        type      => "integer",
#                        allowed   => [   300,
#                                        1200,
#                                        2400,
#                                        4800,
#                                        9600,
#                                       14400,
#                                       19200,
#                                       28800,
#                                       38400,
#                                       57600,
#                                      115200,],
#                        default  =>   115200,
#                        severity => "warning",
#                       });

  &validate_parameter ({hash      => $Options,
                        name      => "baud",
                        type      => "integer",
                       });

  &validate_parameter ({hash      => $Options,
                        name      => "clock_freq",
                        type      => "integer",
                       });

























  &validate_parameter ({hash      => $Options,
                        name      => "sim_true_baud",
                        type      => "boolean",
                        default   => "0",
                       });
                       
   &validate_parameter ({hash      => $Options,
                        name      => "use_rx_fifo",
                        type      => "boolean",
                        default   => "0",
                       });
  &validate_parameter ({hash      => $Options,
                        name      => "use_tx_fifo",
                        type      => "boolean",
                        default   => "0",
                       });
  &validate_parameter ({hash      => $Options,
                        name      => "rx_fifo_LE",
                        type      => "boolean",
                        default   => "0",
                       });
  &validate_parameter ({hash      => $Options,
                        name      => "tx_fifo_LE",
                        type      => "boolean",
                        default   => "0",
                       });
&validate_parameter ({hash      => $Options,
                        name      => "hw_cts",
                        type      => "boolean",
                        default   => "0",
                       });
  &validate_parameter ({hash      => $Options,
                        name      => "fifo_size_tx",
						type      => "integer",
                        allowed   => [   2,
                                         4,
                                        8,
                                        16,
                                        32,
                                        64,
                                       128,
                                       256,
                                       512,
                                       1024,
                                       2048,
                                      4096,
									  8192,],
                        default  =>   16,
                        severity => "warning",

                       });
    &validate_parameter ({hash      => $Options,
                        name      => "fifo_size_rx",
						type      => "integer",
                        allowed   => [   2,
                                         4,
                                        8,
                                        16,
                                        32,
                                        64,
                                       128,
                                       256,
                                       512,
                                       1024,
                                       2048,
                                      4096,
									  8192,],
                        default  =>   16,
                        severity => "warning",

                       });
  &validate_parameter ({hash      => $Options,
                        name      => "fifo_export_used",
                        type      => "boolean",
                        default   => "0",
                       });




  $Options->{baud_divisor_constant} =
    int ( ($Options->{clock_freq} / $Options->{baud}) + 0.5);

  $Options->{divisor_bits} = 
      &Bits_To_Encode ($Options->{baud_divisor_constant});


  if (!$Options->{fixed_baud}) {
    $Options->{divisor_bits} = max ($Options->{divisor_bits}, 32);
  }

  &validate_parameter ({hash    => $Options,
                        name    => "divisor_bits",
                        type    => "integer",
                        range   => [1,32],
                        message => "cannot make desired baud rate from clock",
                       });

  $Options->{num_control_reg_bits} = 16;
  #  ($Options->{use_cts_rts} | $Options->{use_eop_register}) ? 14 : 14 ;




 #changed to add in the threshold bit.
  $Options->{num_status_reg_bits} =  15;


  $baud = $Options->{baud};
  $data_bits = $Options->{data_bits};
  $fixed_baud = $Options->{fixed_baud};
  $parity = $Options->{parity};
  $stop_bits = $Options->{stop_bits};
  $sync_reg_depth = $Options->{sync_reg_depth};
  $use_cts_rts = $Options->{use_cts_rts};
  $use_eop_register = $Options->{use_eop_register};
  $sim_true_baud = $Options->{sim_true_baud};
  $sim_char_stream = $Options->{sim_char_stream};
  $relativepath = $Options->{relativepath};
  
  $baud_divisor_constant = $Options->{baud_divisor_constant};
  $divisor_bits = $Options->{divisor_bits};
  $clock_freq = $Options->{clock_freq};
  $num_control_reg_bits = $Options->{num_control_reg_bits};
  $num_status_reg_bits = $Options->{num_status_reg_bits};
#enw for fifoed uart
  $use_tx_fifo = $Options->{use_tx_fifo};
  $use_rx_fifo = $Options->{use_rx_fifo};
  $hw_cts = $Options->{hw_cts};
  $trans_pin = $Options->{trans_pin};
  $fifo_size_tx = $Options->{fifo_size_tx};
  $fifo_size_rx = $Options->{fifo_size_rx};
  $use_timout = $Options->{use_timout};
  $timeout_value = $Options->{timeout_value};
  $rx_IRQ_Threshold = $Options->{rx_IRQ_Threshold};
  $tx_IRQ_Threshold = $Options->{tx_IRQ_Threshold};
  $rx_fifo_LE = $Options->{rx_fifo_LE};
  $tx_fifo_LE = $Options->{tx_fifo_LE};
  $gap_value = $Options->{gap_value};
  $use_gap_detection = $Options->{use_gap_detection};
  $use_timestamp = $Options->{use_timestamp};
  $use_ext_timestamp = $Options->{use_ext_timestamp};
  $add_error_bits = $Options->{add_error_bits};
  $use_status_bit_clear = $Options->{use_status_bit_clear};
  $timestamp_width = $Options->{timestamp_width};
  $fifo_export_used = $Options->{fifo_export_used};

  return 1;
}
















sub Setup_Input_Stream
{
  my ($Options, $project) = (@_);

  if (($sim_char_file   ne "") &&
      ($sim_char_stream ne "")) {
    &ribbit
      ("Cannot set 'sim_char_stream' parameter when using 'sim_char_file'");
  }

  my $char_stream = $sim_char_stream;

  if ($sim_char_file ne "") {
    $char_stream = "";
    open (CHARFILE, "< $sim_char_file")
      or &ribbit ("Cannot open input-file $sim_char_file ($!)");
    while (<CHARFILE>) {
      $char_stream .= $_;
    }
    close CHARFILE;
  }




  my $newline      = "\n";
  my $cr           = "\n";
  my $double_quote = "\"";
  


  $char_stream =~ s/\\n\\r/\n/sg;
  
  $char_stream     =~ s/\\n/$newline/sg;
  $char_stream     =~ s/\\r/$cr/sg;
  $char_stream     =~ s/\\\"/$double_quote/sg;

  my $crlf = "\n\r";
  $char_stream =~ s/\n/$crlf/smg;

  $stream_length = length ($char_stream);
  
  $char_data_file = $module_name . "_input_data_stream.dat";
  $char_mutex_file = $module_name . "_input_data_mutex.dat";

  my $sim_dir_name = $project->simulation_directory();
  &Create_Dir_If_Needed($sim_dir_name);

  open (DATFILE, "> $sim_dir_name/$char_data_file") 
    or &ribbit ("couldn't open $sim_dir_name/$char_data_file ($!)");

  my $addr = 0;
  foreach my $char (split (//, $char_stream)) {
    printf DATFILE "\@%X\n", $addr; 
    printf DATFILE "%X\n", ord($char);
    $addr++;
  }

  printf DATFILE "\@%X\n", $addr;
  printf DATFILE "%X\n", 0;

  close DATFILE;

  open (MUTFILE, "> $sim_dir_name/$char_mutex_file") 
   or &ribbit ("couldn't open $sim_dir_name/$char_mutex_file ($!)");
  

  if ($interactive_in)
  { # force user to use interactive window if selected by making mutex 0
      printf MUTFILE "0\n";
  }
  else
  { # set up proper stream file size in Mutex:
      printf MUTFILE "%X\n", $addr;
  }

  close MUTFILE;
  $mutex_file_size = $addr;
}


































sub make_uart
{
  my ($project, $Options, $module) = (@_);
  
  $module_name = $module->name();
  my $clock_freq = $Options->{system_clk_freq};
  $clock_freq || &ribbit ("Couldn't find Clock frequency\n");
  $Options->{clock_freq} = $Options->{system_clk_freq};






  &Validate_Uart_Options ($Options, $project);





  return if $project->_software_only();







  $tx_module_name  = $module_name . "_tx";
  $rx_module_name  = $module_name . "_rx";
  $reg_module_name = $module_name . "_regs";


  my $tx_module  = &make_uart_tx  ($Options);
  my $rx_module  = &make_uart_rx  ($Options);
  my $reg_module = &make_uart_regs($Options);







  my $marker = e_default_module_marker->new ($module);
  $module->add_attribute (altera_attribute => "-name SYNCHRONIZER_IDENTIFICATION OFF");





  e_assign->add(["clk_en", 1]);

  e_instance->add ({module => $tx_module });
  e_instance->add ({module => $rx_module });
  e_instance->add ({module => $reg_module});

 




  e_avalon_slave->add ({name => "s1"});

  return $module;
}







sub make_uart_log {
    my ($Options) = (@_);
    return e_log->new ({
	name            => $log_module_name,
	tag             => "simulation",
	relativepath    => $relativepath,
	port_map        => {
	    "valid"	=> "~tx_ready",
	    "strobe"	=> "tx_wr_strobe",
	    "data"	=> "tx_data",
	    "log_file"	=> $log_file,
	},
    });

};

sub make_uart_tx
{ # if parity is programmable then we need 2 more bits

#if ($Options->{parity} =~ /^P$/i ) {
#  $Options->{num_status_reg_bits} = $Options->{num_status_reg_bits}+2; 
#  }
  my ($Options) = (@_);


  my $module = e_module->new ({name  => $tx_module_name});
  my $marker = e_default_module_marker->new ($module);

# calculation the text for the code
 my $parity_expr = "";
     $parity_expr = "1'b0"        if ($parity =~ /^S0$/i);
     $parity_expr = "1'b1"        if ($parity =~ /^S1$/i);
     $parity_expr = "  ^tx_data " if ($parity =~ /^E$/i );
     $parity_expr = "~(^tx_data)" if ($parity =~ /^O$/i );
     $parity_expr = "(pparity_even?(^tx_data):(pparity_odd?~(^tx_data):1'b1))" if ($parity =~ /^P$/i ); ################################### cal needs work


# calculating the size of the shift reister
  my $tx_shift_bits =
    ($stop_bits             )  +   # stop bits.
    ($parity =~ /N/i ? 0 : 1)  +   # parity bit (opt.)
    ($data_bits             )  +   # "payload"
    (1                                 )  ;   # start-bit


  if($use_tx_fifo == 0)
  {
      e_assign->add (["tx_wr_strobe_onset",  "tx_wr_strobe && begintransfer"]),  # cruben  this should be based on if you need a fifo or not
           e_signal->add(["tx_data", $data_bits]);
  }
  else
  {
   	  e_assign->add (["tx_wr_strobe_onset",  "tx_wr_strobe && tx_ready"]),  #cruben
           e_signal->add(["tx_data", $data_bits]);
  }

  my $load_val_expr = &concatenate ("\{$stop_bits \{1'b1\}\}",
                                    $parity_expr,
                                    "tx_data",
                                    "1'b0",
                                   );

  e_assign->add ({lhs => e_signal->add (["tx_load_val", $tx_shift_bits]),
                  rhs => $load_val_expr,
  });










  e_assign->add (["shift_done", "~(|tx_shift_register_contents)"]);


  e_register->add ({out => "do_load_shifter",
                     in  => "(~tx_ready) && shift_done",
                    })if  !$hw_cts;

   e_register->add ({out => "do_load_shifter",
                     in  => "(~tx_ready) && shift_done && ~cts_n",
                    })if  $hw_cts;









  e_register->add ({
    out         => e_port->add (["tx_ready", 1, "out"]),
    sync_set    => "do_load_shifter",
    set_value   => "1'b1",
    sync_reset  => "tx_wr_strobe_onset",
    async_value => "1'b1",
  });



if ( $use_status_bit_clear) {
  e_register->add ({
    out        => "tx_overrun",
    sync_set   => "(~tx_ready && tx_wr_strobe_onset)",
    sync_reset => "status_wr_strobe && writedata[4]",
  })if  !$use_tx_fifo;
} else {
  e_register->add ({
    out        => "tx_overrun",
    sync_set   => "(~tx_ready && tx_wr_strobe_onset)",
    sync_reset => "status_wr_strobe",
  })if  !$use_tx_fifo;
}
  e_register->add ({
    out         => "tx_shift_empty",
    in          => "tx_ready && shift_done",
    async_value => "1'b1",
  });













  e_register->add ({
      out        => e_signal->add({name  => "baud_rate_counter",
                                   width => $divisor_bits
                                  }),
      in         => "baud_rate_counter - 1",
      sync_set   => "baud_rate_counter_is_zero || do_load_shifter",
      set_value  => "baud_divisor",
    });

  e_assign->add(["baud_rate_counter_is_zero", "baud_rate_counter == 0"]);


  # need this value for reg module -  no need to regenerate it.
  e_register->add ({out    => "baud_clk_en",
                    in     => "baud_rate_counter_is_zero",
                   });









  e_assign->add(["do_shift", "baud_clk_en  &&
                             (~shift_done) &&
                             (~do_load_shifter)"
   ]);

  e_shift_register->add ({
    serial_out   => "tx_shift_reg_out",
    serial_in    => "1'b0",
    parallel_in  => "tx_load_val",
    parallel_out => "tx_shift_register_contents",
    shift_length => $tx_shift_bits,
    direction    => "LSB-first",
    load         => "do_load_shifter",
    shift_enable => "do_shift",
  });










  e_register->add({
    out         => "pre_txd",
    in          => "tx_shift_reg_out",
    enable      => "~shift_done",
    async_value => "1",
  })if  !$hw_cts;
  
    e_register->add({
    out         => "pre_txd",
    in          => "tx_shift_reg_out",
#    enable      => "~shift_done",
    sync_set      => "shift_done",
    set_value     => "1'b1",
    async_value => "1",
  })if  $hw_cts;

  e_assign->add(["txd_reset_or_hold", "(!reset_n || (shift_done && cts_n))"]) if  $hw_cts;


  e_register->add ({
    out         => "txd",
    in          => "pre_txd & ~do_force_break",
    sync_set    => "txd_reset_or_hold" ,
    set_value   => "1'b1",
    })if  $hw_cts;

  e_register->add ({
    out         => "txd",
    in          => "pre_txd & ~do_force_break",
    async_value => "1",
  })if  !$hw_cts;
  return $module;
}
















































sub make_uart_rx
{
  my ($Options) = (@_);






  $rx_source_module_name =
    $rx_module_name . "_stimulus_source";
  my $stim_module = &make_uart_rxd_source($Options);


  my $module = e_module->new ({name  => $rx_module_name});
  my $marker = e_default_module_marker->new ($module);

  my $depth;

  if ($sync_reg_depth) {
     $depth  = $sync_reg_depth;
  } else {
     $depth  = "2";
  }
  
  e_instance->add ({module => $stim_module});



  



   e_std_synchronizer->add({
     data_in  => "source_rxd",
     data_out => "sync_rxd",
     clock    => "clk",
     reset_n  => "reset_n",
     depth    => "$depth",
     comment  => "e_std_synchronizer",
  });




  e_edge_detector->add({
    in     => "sync_rxd",
    out    => "rxd_falling",
    edge   => "falling",
  });

  e_edge_detector->add({
    in     => "sync_rxd",
    out    => "rxd_edge",
    edge   => "any",
  });






 if($use_rx_fifo == 0)
  {
      e_assign->add (["rx_rd_strobe_onset", "rx_rd_strobe && begintransfer"]);
  }
  else
  {
   	  e_assign->add (["rx_rd_strobe_onset", "rx_rd_strobe"]);
      if($add_error_bits)
      {
          e_signal->add ({comment=>"collection of error bits for the rx fifo",name =>"rx_error_bits", width => 4,export =>1});
          e_signal->add ({name=>"is_parity_error",width=>1,never_export => 1});
          #need to latch these until the rx_rd_strobe happens then they need to be cleared so the bits only
          #show up on one character.
          e_register->add ({comment =>"This is the parity error bit for the fifo",
                          out => "rx_error_bits\[0\]",
                          in =>  "(pparity_even || pparity_odd) ? ((got_new_char && is_parity_error) ||(!got_new_char && rx_error_bits\[0\])):1'b0"});    #PE
            e_assign->adds(["is_break",         "~(|rxd_shift_reg)"  ]);                
	  if ($parity =~ /^P$/i ) {
               e_register->add ({comment =>"This is the framing error bit for the fifo",
                          out => "rx_error_bits\[1\]",
                          in => "(~(((pparity_even ||pparity_odd)?~stop_bit:~parity_bit) && ~is_break) && ~is_break) || (!got_new_char && rx_error_bits\[1\])" }); 
	  } else {                                       
               e_register->add ({comment =>"This is the framing error bit for the fifo",
                          out => "rx_error_bits\[1\]",
                          in => "(~stop_bit && ~is_break) || (!got_new_char && rx_error_bits\[1\])" });                         #FE
                          
            }              
                          
          e_register->add ({comment =>"This is the BREAK bit for the fifo",
                          out => "rx_error_bits\[2\]",
                          in => "(got_new_char && is_break) || (!got_new_char && rx_error_bits\[2\])"});           #break
          e_register->add ({comment =>"This is the Parity Error bit for the fifo",
                          out => "rx_error_bits\[3\]",
                          in => "(got_new_char && rx_char_ready) || (!got_new_char && rx_error_bits\[3\])"});      #Over run
      }
  }
























  e_signal->add (["half_bit_cell_divisor", $divisor_bits - 1]);
  e_assign->add ({
    lhs => "half_bit_cell_divisor",
    rhs => 'baud_divisor [baud_divisor.msb : 1]',
  });

  e_mux->add ({
    lhs     => e_signal->add (["baud_load_value", $divisor_bits]),
    table   => [rxd_edge => "half_bit_cell_divisor"],
    default => "baud_divisor",
  });

  e_register->add ({
    out       => e_signal->add(["baud_rate_counter",$divisor_bits]),
    in        => "baud_rate_counter - 1",
    sync_set  => "baud_rate_counter_is_zero || rxd_edge",
    set_value => "baud_load_value",
  });

  e_assign->add (["baud_rate_counter_is_zero", "baud_rate_counter == 0"]);

  e_register->add ({
    in        => "baud_rate_counter_is_zero",
    out       => "baud_clk_en",
    sync_set  => "rxd_edge",
    set_value => "0",
  });










  e_assign->add (["sample_enable", "baud_clk_en && rx_in_process"]);

  e_register->add ({
    out         => "do_start_rx",
    in          => "0",
    sync_set    => "(~rx_in_process && rxd_falling)",
    set_value   => "1",
    async_value => "0",
  });







  if ($parity =~ /^P$/i ) {
  my $rx_shift_bitsN = 
    (1                                 )  +   # stop bit.
    ($data_bits            )  +   # "payload"
    (1                                 )  ;
   e_shift_register->add ({
    parallel_out => "rxd_shift_regN",
    serial_in    => "sync_rxd",
    serial_out   => "shift_reg_start_bitN_n",
    parallel_in  => "\{$rx_shift_bitsN\{1'b1\}\}",
    shift_length => $rx_shift_bitsN,
    direction    => "LSB-first",
    load         => "do_start_rx",
    shift_enable => "sample_enable",
  });
    my $rx_shift_bitsP = 
    (1                                 )  +   # stop bit.
    (1)  +   # parity bit (opt.)
    ($data_bits             )  +   # "payload"
    (1                                 )  ;

  e_shift_register->add ({
    parallel_out => "rxd_shift_regP",
    serial_in    => "sync_rxd",
    serial_out   => "shift_reg_start_bitP_n",
    parallel_in  => "\{$rx_shift_bitsP\{1'b1\}\}",
    shift_length => $rx_shift_bitsP,
    direction    => "LSB-first",
    load         => "do_start_rx",
    shift_enable => "sample_enable",
  });
    e_signal->add (["rxd_shift_reg", $rx_shift_bitsP]);
  e_assign->add (["rxd_shift_reg",        "(pparity_even ||pparity_odd)?rxd_shift_regP: {1'b0,rxd_shift_regN}"]);
  e_assign->add (["shift_reg_start_bit_n","(pparity_even ||pparity_odd)?shift_reg_start_bitP_n:shift_reg_start_bitN_n"]);
  
} else {

  my $rx_shift_bits = 
    (1                                 )  +   # stop bit.
    ($parity =~ /N/i ? 0 : 1)  +   # parity bit (opt.)
    ($data_bits             )  +   # "payload"
    (1                                 )  ;

  e_shift_register->add ({
    parallel_out => "rxd_shift_reg",
    serial_in    => "sync_rxd",
    serial_out   => "shift_reg_start_bit_n",
    parallel_in  => "\{$rx_shift_bits\{1'b1\}\}",
    shift_length => $rx_shift_bits,
    direction    => "LSB-first",
    load         => "do_start_rx",
    shift_enable => "sample_enable",
  });
}
  e_assign->add (["rx_in_process", "shift_reg_start_bit_n"]);



  e_signal->add (["raw_data_in", $data_bits]);







  my $start_bit_sig = e_signal->add(["unused_start_bit", 1]);
  $start_bit_sig->never_export(1);

  my    @register_segments = ("stop_bit"  );
  push (@register_segments,   "parity_bit") unless $parity =~/^N$/i;
  push (@register_segments,   "raw_data_in",
                              "unused_start_bit");

  e_assign->add([&concatenate (@register_segments), "rxd_shift_reg"]);


#odd one on the recive side if you have programmable parity but no parity is selected
# then the stop bit is acctually the parity bit. 
if ($parity =~ /^P$/i ) {

  e_assign->adds(["is_break",         "~(|rxd_shift_reg)"      ],
                 ["is_framing_error", "((pparity_even ||pparity_odd)?~stop_bit:~parity_bit) && ~is_break" ]);

} else {





  e_assign->adds(["is_break",         "~(|rxd_shift_reg)"      ],
                 ["is_framing_error", "~stop_bit && ~is_break" ]);

}


  e_edge_detector->add ({
    out    => "got_new_char",
    in     => "rx_in_process",
    edge   => "falling",
  });

  e_register->add({
    in     => "raw_data_in",
    out    => e_signal->add(["rx_data", $data_bits]),
    enable => "got_new_char",
  });

  e_register->add({
    out        => "framing_error",
    sync_set   => "(got_new_char && is_framing_error)",
    sync_reset => "status_wr_strobe && writedata[1]",
  }) if ( $use_status_bit_clear) ;
  
    e_register->add({
    out        => "framing_error",
    sync_set   => "(got_new_char && is_framing_error)",
    sync_reset => "status_wr_strobe",
  }) unless ( $use_status_bit_clear) ;

  e_register->add({
    out        => "break_detect",
    sync_set   => "(got_new_char && is_break)",
    sync_reset => "status_wr_strobe && writedata[2]",
  }) if ( $use_status_bit_clear);

    e_register->add({
    out        => "break_detect",
    sync_set   => "(got_new_char && is_break)",
    sync_reset => "status_wr_strobe",
  }) unless ( $use_status_bit_clear);
  
  e_register->add({
    out        => "rx_overrun",
    sync_set   => "(got_new_char && rx_char_ready)",
    sync_reset => "status_wr_strobe && writedata[3]",
  }) if ( $use_status_bit_clear);
  
  e_register->add({
    out        => "rx_overrun",
    sync_set   => "(got_new_char && rx_char_ready)",
    sync_reset => "status_wr_strobe",
  }) unless ( $use_status_bit_clear);

  e_register->add({
    out        => e_port->add (["rx_char_ready", 1, "out"]),
    sync_set   => "got_new_char",
    sync_reset => "rx_rd_strobe_onset",
    priority   => "reset",
  });



  if ($parity =~ /^N$/i) {
    e_assign->add (["parity_error", "0"]);
  } else {
    my $correct_parity_expr = "";
    $correct_parity_expr = "0"               if $parity =~ /^S0$/i;
    $correct_parity_expr = "1"               if $parity =~ /^S1$/i;
    $correct_parity_expr = " (^raw_data_in)" if $parity =~ /^E$/i;
    $correct_parity_expr = "~(^raw_data_in)" if $parity =~ /^O$/i;
    $correct_parity_expr = "(pparity_even?(^raw_data_in):(pparity_odd?~(^raw_data_in):1'b0))" if ($parity =~ /^P$/i );

    e_assign->add (["correct_parity", $correct_parity_expr]);

    e_assign->add ({
      lhs    => "is_parity_error",
      rhs    => "(correct_parity != parity_bit) && ~is_break && (pparity_even||pparity_odd)",
    }) if ($parity =~ /^P$/i );
    
     e_assign->add ({
      lhs    => "is_parity_error",
      rhs    => "(correct_parity != parity_bit) && ~is_break",
    }) unless ($parity =~ /^P$/i );

    e_register->add ({
      out        => "parity_error",
      sync_set   => "got_new_char && is_parity_error",
      sync_reset => "status_wr_strobe && writedata[0]",
    }) if ( $use_status_bit_clear) ;
     e_register->add ({
      out        => "parity_error",
      sync_set   => "got_new_char && is_parity_error",
      sync_reset => "status_wr_strobe",
    }) unless ( $use_status_bit_clear);
  }

  return $module;
}



























sub make_uart_regs
{


  my ($Options) = (@_);


  my $module = e_module->new ({name  => $reg_module_name});
  my $marker = e_default_module_marker->new ($module);





#cruben made 32 bits

  e_register->add({
   comment => "CJR changed to 32 bits wide",
   out => e_signal->add (["readdata",           32]),
   in  => e_signal->add (["selected_read_data", 32]),
  });
  
   e_register->add({
    out    => "irq",
    in     => "qualified_irq",
  });
  
my $rx_Use_EAB = $rx_fifo_LE ? qq("OFF") : qq("ON");
my $rx_fifo_address_bits = log2($fifo_size_rx);
my $tx_fifo_address_bits = log2($fifo_size_tx);

# this section is all about the timestamp
# if it is external the add a timestamp port

if( $use_timestamp && $use_ext_timestamp && $use_rx_fifo )
{
   e_port->adds (
    ["timestamp_in",          $timestamp_width,                        "in" ]
    );

}
if ( $use_timestamp && $use_rx_fifo && !$use_ext_timestamp)
{
# $module->{comment} .= "This section is for implementation of the timestamp\n";
 e_instance->add
         ({
             module => e_module->new
                 ({
                     name => $module_name."_tsfifo",
                     contents=>
                     [
                     e_blind_instance->new
                      ({
                          tag => "normal",
                          name => 'tsfifo',
                          module => 'scfifo',
                          use_sim_models => 1,
                          in_port_map =>
                          {
                            rdreq   => 'd1_rx_fifo_rd_strobe',   #same as rx fifo
                            sclr	  => 'reset',              #same as rx fifo
                            clock   => 'clk',                    #same as rx fifo
                            wrreq	  => 'd1_rx_rd_strobe',    #same as rx fifo
                            data    => 'ts_in_data',                # this comes from the internal timestamp counter or externally
                          },
                          out_port_map =>
                          {
                              q       => 'timestamp_data',
                          },
                          parameter_map =>
                          {
                              lpm_width               => $timestamp_width,
                              lpm_numwords            => $fifo_size_rx,       #same as rx fifo
                              lpm_widthu	      => $rx_fifo_address_bits,
                              lpm_type		      => qq("scfifo"),
                              lpm_showahead	      => qq("ON"),
                              overflow_checking	      => qq("ON"),
                              underflow_checking      => qq("ON"),
                              use_eab		      => $rx_Use_EAB,
                          },
                        }), # wfifo instance
                       ], # contents
                 }), # e_module scfifo_w
         }); # e_instance wfifo


  if( $use_ext_timestamp )
  {
     e_assign->add ({
     comment => "Data from an external timestamp source to feed the fifo",
     lhs => e_signal->add(["ts_in_data", $timestamp_width]),
     rhs => 'timestamp_in',
     });

   } else {
     e_assign->add ({
       comment => "Data from the internal timestamp source to feed the fifo.  Needs to shifted by 3 to get the divide by 8",
     lhs => e_signal->add(["ts_in_data", $timestamp_width]),
     rhs => "timestamp_counter\[$timestamp_width+2:3\]",
    });

     e_register->add ({
      comment => "This counter counts baudrate/8",
      out        => e_signal->add({name  => "timestamp_counter",
                                   width => $timestamp_width+3}),
      in         => "timestamp_counter + 1 ",
      enable     => "baud_clk_en ",

     })if !$use_ext_timestamp;

     e_signal->add(["timestamp_data", $timestamp_width]);
     }

  }
#end timestamp




#changed the width to 32
  e_port->adds (
    ["address",          4,                        "in" ],
    ["writedata",       32,                        "in" ],
    ["tx_wr_strobe",     1,                        "out"],
    ["status_wr_strobe", 1,                        "out"],
    ["rx_rd_strobe",     1,                        "out"],
    ["baud_divisor",     $divisor_bits, "out"],
    );
if ($parity =~ /^P$/i ){
   e_port->adds ( 
    ["pparity_odd",     1, "out"],
    ["pparity_even",     1, "out"],
    
  )};

  
   e_assign->add(["rx_rd_strobe",      "chipselect && ~read_n  && (address == 4'd0)"])if  !$use_rx_fifo;
  e_assign->add(["rx_fifo_rd_strobe",      "chipselect && ~read_n  && (address == 4'd0) && begintransfer"])if  $use_rx_fifo;
  e_assign->add(["rx_rd_strobe",      "rx_char_ready && rx_not_full"])if  $use_rx_fifo;
  e_assign->add(["tx_wr_strobe",      "chipselect && ~write_n && (address == 4'd1)"])if  !$use_tx_fifo;
  e_assign->add(["tx_fifo_wr_strobe",      "chipselect && ~write_n && (address == 4'd1) && begintransfer"])if  $use_tx_fifo;


  e_assign->adds(
    ["status_wr_strobe",  "chipselect && ~write_n && (address == 4'd2)"],
    ["control_wr_strobe", "chipselect && ~write_n && (address == 4'd3)"],);


  e_assign->add(["tx_wr_strobe",      "tx_ready && tx_not_empty"])if  ($use_tx_fifo && !$hw_cts);
  e_assign->add(["tx_wr_strobe",      "tx_ready && tx_not_empty && ~cts_n"])if  ($use_tx_fifo && $hw_cts);

  e_assign->add([ e_signal->add (["reset",1]),"~reset_n",]) if  ($use_tx_fifo || $use_rx_fifo) ;

  e_assign->add([
     "divisor_wr_strobe", "chipselect && ~write_n  && (address == 4'd4)",
  ]) if !$fixed_baud;
  e_assign->add([
     "eop_char_wr_strobe","chipselect && ~write_n  && (address == 4'd5)",
  ]) if  $use_eop_register;
  e_assign->add(["gap_wr_strobe",      "chipselect && ~write_n && (address == 4'd8) && begintransfer"])if  $use_gap_detection;





  my $tx_data_sig = e_signal->add(["tx_data", $data_bits]);
  $tx_data_sig->export(1);
  
  e_register->add ({
    out    => e_signal->add(["gap_reg", 16 ]),
    in     => "writedata\[15 : 0\]",
    enable => "gap_wr_strobe",
    async_value => $gap_value,
    comment =>"this is the r/w register that contains the gap value",
  })if $use_gap_detection;

  e_register->add ({
    out    => $tx_data_sig,
    in     => "writedata\[tx_data.msb : 0\]",
    enable => "tx_wr_strobe",
  })if !$use_tx_fifo;  #fifo will supply if present
  e_register->add ({
    out    => $tx_data_sig,
    in     => "tx_fifo_q",
    enable => "tx_wr_strobe",
    comment =>"tx_data comming from the tx_fifo",
  })if $use_tx_fifo;  #fifo will supply if present

  e_register->add ({
    out    => e_signal->add(["control_reg", $num_control_reg_bits]),
    in     => "writedata\[control_reg.msb:0\]",
    enable => "control_wr_strobe",
  });

  e_register->add ({
    out    => e_signal->add(["eop_char_reg", $data_bits]),
    in     => "writedata\[eop_char_reg.msb:0\]",
    enable => "eop_char_wr_strobe",
  }) if $use_eop_register;

if ( $use_status_bit_clear) {
  e_register->add ({
    out        => "tx_overrun",
    sync_set   => "tx_full && tx_fifo_wr_strobe",
    sync_reset => "status_wr_strobe && writedata[4]",
  })if  $use_tx_fifo;
  } else {
    e_register->add ({
    out        => "tx_overrun",
    sync_set   => "tx_full && tx_fifo_wr_strobe",
    sync_reset => "status_wr_strobe",
  })if  $use_tx_fifo;
  }


  e_edge_detector->add ({
    tag  => "simulation",
    out  => "do_write_char",
    in   => "tx_ready",
  });

  e_process->add ({
    tag  => "simulation",
    contents => [
      e_if->new ({
      tag  => "simulation",
      condition       => "do_write_char",
      then            => [
        e_sim_write->new ({
          spec_string => '%c',
          expressions => ["tx_data"],
        })
      ],
    }),
  ]});



  e_signal->add (["divisor_constant", $divisor_bits]);
  e_assign->add ({
    tag  => $sim_true_baud ? "normal" : "synthesis",
    lhs  => "divisor_constant",
    rhs  => $baud_divisor_constant
  });
  e_assign->add ({
    tag   => "simulation",
    lhs   => "divisor_constant",
    rhs   => 4,
  }) if !$sim_true_baud;




  if ($fixed_baud) {
    e_assign->add(["baud_divisor", "divisor_constant"]);
  } else {
    e_register->add ({
      in          => "writedata\[baud_divisor.msb:0\]",
      out         => "baud_divisor",
      enable      => "divisor_wr_strobe",
      async_value => "divisor_constant",
    });
  }







  if ($use_cts_rts ) {
    e_register->add ({
      in          => "~cts_n",
      out         => "cts_status_bit",
      async_value => 1,
    });

    e_edge_detector->add ({
      in     => "cts_status_bit",
      out    => "cts_edge",
      edge   => "any",
    });

    e_register->add ({
      out         => "dcts_status_bit",
      sync_set    => "cts_edge",
      sync_reset  => "status_wr_strobe",
      async_value => 0,
    });




    e_assign->add (["rts_n", "~rts_control_bit"]);
  } else {
   if ($hw_cts ) {
    e_register->add ({
      in          => "~cts_n",
      out         => "cts_status_bit",
      async_value => 1,
    });

    e_edge_detector->add ({
      in     => "cts_status_bit",
      out    => "cts_edge",
      edge   => "any",
    });

    e_assign->adds (["dcts_status_bit", 0]);
    }
    else
    {
    e_assign->adds (["cts_status_bit",  0],
                    ["dcts_status_bit", 0]);
    }

  }







  e_signal->adds({name => "rts_control_bit", never_export => 1},
                 {name => "ie_dcts",         never_export => 1},
                 {name => "ie_eop",          never_export => 1},
                 {name => "pparity_odd",          never_export => 1},
                 {name => "pparity_even",          never_export => 1},
                 {name => "ie_gap_detection",          never_export => 1});

  my @control_reg_bits = ();

#  if ($parity =~ /^P$/i ){
  push (@control_reg_bits, "pparity_even",
			   "pparity_odd");
 #  } else {
 #  push (@control_reg_bits, "1'b0",
#			   "1'b0");
#   }
			   push (@control_reg_bits, "ie_gap_detection",
                           "ie_eop" ,
                           "rts_control_bit",
                           "ie_dcts" ,
                           "do_force_break",
                           "ie_any_error",
                           "ie_rx_char_ready",
                           "ie_tx_ready",
                           "ie_tx_shift_empty",
                           "ie_tx_overrun",
                           "ie_rx_overrun",
                           "ie_break_detect",
                           "ie_framing_error",
                           "ie_parity_error",

       );

  e_assign->add([&concatenate(@control_reg_bits), "control_reg"]);




  e_assign->add ({
    lhs    => "any_error",
    rhs    => join (" ||\n",
                             "tx_overrun",
                             "rx_overrun",
                             "parity_error",
                             "framing_error",
                             "break_detect",
                   ),
  });

  my @status_reg_bits = ();
           
  if ($use_rx_fifo) {
    push (@status_reg_bits, "rx_at_threshold");
  } else {
    push (@status_reg_bits, "1'b0");
  }
  if  ($use_gap_detection)
  {
    push (@status_reg_bits, "gap_timeout");
  } 
  else
  {
    push (@status_reg_bits, "1'b0");
  }
   push (@status_reg_bits,"eop_status_bit",
                          "cts_status_bit",
                          "dcts_status_bit",
                          "1'b0",
                          "any_error");
if  ($use_rx_fifo)
{
	 push (@status_reg_bits,
                          "rx_not_empty");
}
else
{
  push (@status_reg_bits,
                          "rx_char_ready");
}
if  ($use_tx_fifo)
{
	  push (@status_reg_bits,
                          "tx_not_full");
}
else
{
  push (@status_reg_bits,
                          "tx_ready");
}
push (@status_reg_bits,
                          "tx_shift_empty",
                          "tx_overrun",
                          "rx_overrun",
                          "break_detect",
                          "framing_error",
                          "parity_error",

       );



  e_assign->add ({
    lhs => e_signal->add(["status_reg", $num_status_reg_bits]),
    rhs => &concatenate (@status_reg_bits),
  });

# comment


  if ( $use_tx_fifo ||$use_rx_fifo)
  {
    e_register->add({
      in => "rx_not_empty",
      comment =>"Register the rx_not_empty for timing",
    })if  $use_rx_fifo;
    e_register->add({
      in => "tx_not_full",
      comment =>"Register the tx_not_full for timing",
    })if  $use_tx_fifo;
    e_register->add({
      in => "rx_rd_strobe",
      comment =>"Register the rx_rd_strobe for timing",
    })if  $use_rx_fifo;

    e_register->add({
      in => "rx_fifo_rd_strobe",
      comment =>"Register the rx_fifo_strobe for timing",
    })if  $use_rx_fifo;

    e_register->add({
      in => "tx_wr_strobe",
      comment =>"Register the tx_wr_strobe for timing",
    })if  $use_tx_fifo;

    e_assign->adds
      ([e_port->new (["dataavailable", 1, "out"]),  "d1_rx_not_empty"] )if  $use_rx_fifo;
    e_assign->adds
      ([e_port->new (["dataavailable", 1, "out"]),  "d1_rx_char_ready"] )if  !$use_rx_fifo;
    e_assign->adds
       ([e_port->new (["readyfordata",  1, "out"]),  "d1_tx_not_full" ] )if  $use_tx_fifo;
   e_assign->adds
       ([e_port->new (["readyfordata",  1, "out"]),  "d1_tx_ready" ] )if  !$use_tx_fifo;
# Cal 17 dec 08

      e_assign->adds
#       ([e_signal->new ({name => "tx_almost_empty", never_export => 1}),  "tx_used <=$tx_IRQ_Threshold" ] )if  $use_tx_fifo;
       ([e_signal->new ({name => "tx_almost_empty", never_export => 1}), "(tx_used <=$tx_IRQ_Threshold) && tx_not_full" ] )if $use_tx_fifo;
       # e_assign->adds
       #([e_signal->new ({name =>"rx_almost_full", never_export => 1}),  "rx_used > -8+ $fifo_size_rx" ] )if  $use_rx_fifo;

#end
  }
  else
  {
    e_register->add({
      in => "rx_char_ready",
    });
    e_register->add({
      in => "tx_ready",
    });

    e_assign->adds
      ([e_port->new (["dataavailable", 1, "out"]),  "d1_rx_char_ready"],
       [e_port->new (["readyfordata",  1, "out"]),  "d1_tx_ready"     ] );
  }


if ( $use_tx_fifo)
{
  my $tx_Use_EAB = $tx_fifo_LE? qq("OFF") : qq("ON");
  e_instance->add
         ({
             module => e_module->new
                 ({
                     name => $module_name."_txfifo",
                     contents=>
                     [
                     e_blind_instance->new
                      ({
                          tag => "normal",
                          name => 'txfifo',
                          module => 'scfifo',
                          use_sim_models => 1,
                          in_port_map =>
                          {
                             rdreq   => 'd1_tx_wr_strobe',  #needs to be one clock late
                             sclr	  => 'reset',
                             clock   => 'clk',
                             wrreq	  => 'tx_fifo_wr_strobe',
                             data    => "writedata\[$data_bits-1:0\]",
                          },
                          out_port_map =>
                          {
                             q       => 'tx_fifo_q',
                             usedw    => 'tx_used',
                             empty => 'tx_empty',
                             full  => 'tx_full',
                          },
                          parameter_map =>
                          {
                             lpm_width               => $data_bits,
                             lpm_numwords            => $fifo_size_tx,
			     lpm_widthu		     => $tx_fifo_address_bits,
			     lpm_type		     => qq("scfifo"),
			     lpm_showahead	     => qq("ON"),
			     overflow_checking	  => qq("ON"),
			     underflow_checking	  => qq("ON"),
			     use_eab			  => $tx_Use_EAB,
                          },
                        }), # wfifo instance
                       ], # contents
                 }), # e_module scfifo_w
         }); # e_instance wfifo

        e_signal->add(["tx_buff_used", $tx_fifo_address_bits+1]);
        e_signal->add(["tx_used", $tx_fifo_address_bits]);
        e_signal->add(["tx_fifo_q", $data_bits]);
        e_assign->add(["tx_buff_used", "\{tx_full,tx_used\}/* synthesis keep */"]);
  		  e_assign->add(["tx_not_full", "~tx_full"]);
  		  e_assign->add(["tx_not_empty", "~tx_empty"]);
  }

if ( $use_rx_fifo)
{
 my $rx_spaces = 10-$data_bits;
   e_register->add ({out => "gap_detect",
                       in  => "(gap_counter[18:3] == gap_reg || gap_detect) && !d1_rx_rd_strobe",
                    })if  $use_gap_detection;
      e_assign->add([e_signal->add(["gap_detect", 1 ]),  "1'b0"])if  !$use_gap_detection;


   # have to account for error bits if enabled.
 my $rx_data_bits =  $add_error_bits? 15 : $data_bits;

      e_assign->add([e_signal->add(["in_rx_data", $rx_data_bits ]),  "rx_data"])if  !$add_error_bits;
      e_assign->add([e_signal->add(["in_rx_data", $rx_data_bits ]),  &concatenate ("old_gap_detect","rx_error_bits", "\{$rx_spaces\{1'b0\}\}","rx_data")  ] )if  $add_error_bits;
      e_instance->add
         ({
             module => e_module->new
                 ({
                     name => $module_name."_rxfifo",
                     contents=>
                     [
                     e_blind_instance->new
                      ({
                          tag => "normal",
                          name => 'rxfifo',
                          module => 'scfifo',
                          use_sim_models => 1,
                          in_port_map =>
                          {
                              rdreq   => 'd1_rx_fifo_rd_strobe',
                              sclr	  => 'reset',
                              clock   => 'clk',
                              wrreq	  => 'd1_rx_rd_strobe',
                              data    => 'in_rx_data',
                            },
                          out_port_map =>
                          {
                              q       => 'rx_data_b',
                              usedw    => 'rx_used',
                              empty => 'rx_empty',
                              full  => 'rx_full',
                          },
                          parameter_map =>
                          {
                              lpm_width               => $rx_data_bits,
                              lpm_numwords            => $fifo_size_rx,
			      lpm_widthu			  => $rx_fifo_address_bits,
			      lpm_type				  => qq("scfifo"),
			      lpm_showahead			  => qq("ON"),
			      overflow_checking	  => qq("ON"),
			      underflow_checking	  => qq("ON"),
			      use_eab			  => $rx_Use_EAB,
                         },
                        }), # wfifo instance
                       ], # contents
                 }), # e_module scfifo_w
         }); # e_instance wfifo

  e_signal->add(["rx_buff_used", $rx_fifo_address_bits+1]);
  e_signal->add(["rx_used", $rx_fifo_address_bits]);
  e_register->add ({out => "rx_empty_reg",
                       in  => "rx_empty",
                    })if  $add_error_bits;

  e_signal->add(["rx_data_b", $rx_data_bits]);

  e_assign->add(["rx_buff_used", "\{rx_full,rx_used\}"]);
  e_assign->add(["rx_not_empty", "~rx_empty"]);
# this is new.  look to see if rx_fifo is to the rigth threashold before sending the interrupt.
  e_assign->adds
#       ([e_signal->new ({name => "rx_at_threshold", never_export => 1}),  "(rx_used >=$Options->{rx_IRQ_Threshold}) || timer_timout" ] )if  $use_rx_fifo;
       ([e_signal->new ({name => "rx_at_threshold", never_export => 1}), "(rx_used >=$rx_IRQ_Threshold) || rx_full || timer_timout" ] )if $use_rx_fifo;
  e_assign->add(["rx_not_full", "~rx_full"]);


  #gap detection logic.

if  ($use_gap_detection){
  e_register->add ({out => "gap_timeout",
#                     in  => "gap_counter[7:3] >= $Options->{gap_value}",
#                       in  => "(g_timout && !gap_timeout_r) || (gap_timeout && !status_wr_strobe)",
#                        never_export => "1"
                       in  => "(g_timout && !gap_timeout_r) || (gap_timeout && !status_wr_strobe)"
                    })  unless ( $use_status_bit_clear) ;
     e_register->add ({out => "gap_timeout",
#                     in  => "gap_counter[7:3] >= $Options->{gap_value}",
#                       in  => "(g_timout && !gap_timeout_r) || (gap_timeout && !(status_wr_strobe&&writedata[13]))",
#                        never_export => "1"
                       in  => "(g_timout && !gap_timeout_r) || (gap_timeout && !(status_wr_strobe&&writedata[13]))"
                    }) if ( $use_status_bit_clear) ;
   } else {
#   e_assign->add ({out => "gap_timeout", in => "0",never_export => "1" }) ;
   e_assign->add ({out => "gap_timeout", in => "0" }) ;
   }
   if  ( $use_gap_detection ) {
   e_assign->add(["g_timout", "(gap_counter[18:3] == gap_reg)"]);
   e_register->add ({out => "old_gap_detect",
                       in  => "(g_timout && !gap_timeout_r)  || (old_gap_detect && !rx_rd_strobe)",
                    })if  $use_gap_detection;
   e_register->add ({out => "gap_timeout_r",
                       in  => "g_timout",
                    })if  $use_gap_detection;                 

    # could use rx_char_ready  it might be better
     e_register->add ({
      out        => e_signal->add({name  => "gap_counter",
                                   width => 19}),
      in         => "gap_counter + ((baud_clk_en && !g_timout) ? 1 : 0) ",
      sync_set   => "d1_rx_rd_strobe",
      set_value  => "0",
      comment =>"gap_counter counts the number of 8 bit chars that have elapse since the last char arrived. ",
     });
     }
  # need to add a timmer so we don't orphan any chars in the buffer.
  e_assign->adds(["timer_timout","timer_counter[7:3] >= $timeout_value" ] ) if  $use_timout;
   e_assign->adds(["timer_timout","0" ] ) if  !$use_timout;

   # three differnt block need this baud_clk_enable; timeout, gap detection, internal timestamp.
   if  ( $use_timout || $use_gap_detection || ($use_timestamp && $use_ext_timestamp) ) {
       e_register->add ({
      out        => e_signal->add({name  => "baud_rate_counter",
                                   width => $divisor_bits
                                  }),
      in         => "baud_rate_counter - 1",
      sync_set   => "baud_rate_counter_is_zero ",
      set_value  => "baud_divisor",
      comment =>"count down from the uart clock to create a baud clock enable",
    });

    e_assign->add(["baud_rate_counter_is_zero", "baud_rate_counter == 0"]);


    # need this value for reg module -  no need to regenerate it.
    e_register->add ({out    => "baud_clk_en",
                    in     => "baud_rate_counter_is_zero",
                   });
   }

    if  ( $use_timout  ) {

     e_register->add ({
      out        => e_signal->add({name  => "timer_counter",
                                   width => 8}),
      in         => "timer_counter + ((baud_clk_en && !timer_timout) ? 1 : 0) ",
#      enable     => "baud_clk_en && !timer_counter_max",
      sync_set   => "rx_empty || d1_rx_rd_strobe ",
      set_value  => "0",
      comment =>"Timer counter counts the number of baudrate/8 chars that have elapsed while a char is in the fifo",
     });
#     e_assign->adds(["timer_counter_max", "timer_counter >= 248"]);

     }
}    # end if use fifo

  if ($fifo_export_used && $use_rx_fifo) {
      e_port->add(["rxused", ($rx_fifo_address_bits + 1), "out"]);
      e_assign->add(["rxused", "rx_buff_used"]);
  }
  if ($fifo_export_used && $use_tx_fifo) {
      e_port->add(["txused", ($tx_fifo_address_bits + 1), "out"]);
      e_assign->add(["txused", "tx_buff_used"]);
  }


  if ($use_eop_register) {
  if ( $use_status_bit_clear) {
     e_register->add ({
        out         => "eop_status_bit",

        sync_set    => "(rx_rd_strobe && (eop_char_reg == rx_data)) ||
                        (tx_wr_strobe &&
                          (eop_char_reg == writedata\[tx_data.msb:0\]))",
        sync_reset  => "status_wr_strobe && writedata[12]",
        async_value => 0,
     });
     } else {
         e_register->add ({
        out         => "eop_status_bit",

        sync_set    => "(rx_rd_strobe && (eop_char_reg == rx_data)) ||
                        (tx_wr_strobe &&
                          (eop_char_reg == writedata\[tx_data.msb:0\]))",
        sync_reset  => "status_wr_strobe",
        async_value => 0,
     });
     }
     e_assign->add
         ([e_port->new (["endofpacket", 1, "out"]), "eop_status_bit"]);
  } else {

     e_assign->add (["eop_status_bit", "1'b0"]);
  }

  my @read_mux_table = (
    "(address == 4'd1)" => "tx_data",
    "(address == 4'd2)" => "status_reg",
    "(address == 4'd3)" => "control_reg",
  );

  push (@read_mux_table, "(address == 4'd0)" => "rx_data")
    if !$use_rx_fifo;

  push (@read_mux_table, "(address == 4'd0)" => &concatenate ("rx_empty_reg", "rx_data_b"))
    if( $use_rx_fifo && $add_error_bits);

    push (@read_mux_table, "(address == 4'd0)" => "rx_data_b")
    if( $use_rx_fifo && !$add_error_bits);

  push (@read_mux_table, "(address == 4'd4)" => "baud_divisor")
    if !$fixed_baud;

  push (@read_mux_table, "(address == 4'd5)" => "eop_char_reg")
    if  $use_eop_register;

  push (@read_mux_table, "(address == 4'd6)" => "rx_buff_used")
    if $use_rx_fifo;

  push (@read_mux_table, "(address == 4'd7)" => "tx_buff_used")
    if $use_tx_fifo;

  push (@read_mux_table, "(address == 4'd8)" => "gap_reg")
    if $use_gap_detection;

  push (@read_mux_table, "(address == 4'd9)" => "timestamp_data")
    if $use_timestamp;

  e_mux->add ({
    lhs    => e_signal->add(["selected_read_data", 32]),
    table  => \@read_mux_table,
    type   => "and-or",
  });




  my @irq_terms = ();
  push (@irq_terms, "(ie_dcts           && dcts_status_bit )")
    if $use_cts_rts;
  push (@irq_terms, "(ie_eop            && eop_status_bit  )")
    if $use_eop_register;

  push (@irq_terms, "(ie_any_error      && any_error      )",
                    "(ie_tx_shift_empty && tx_shift_empty )",
                    "(ie_tx_overrun     && tx_overrun     )",
                    "(ie_rx_overrun     && rx_overrun     )",
                    "(ie_break_detect   && break_detect   )",
                    "(ie_framing_error  && framing_error  )",
                    "(ie_parity_error   && parity_error   )",
       );
       #cal new option here rx_at_ threshold
   push (@irq_terms,"(ie_rx_char_ready  && rx_at_threshold  )") if   $use_rx_fifo ;
   push (@irq_terms,"(ie_rx_char_ready  && rx_char_ready  )") if  !$use_rx_fifo;
   push (@irq_terms,"(ie_tx_ready       && tx_ready       )") if  !$use_tx_fifo;
   push (@irq_terms,"(ie_tx_ready       && tx_almost_empty     )") if  $use_tx_fifo;
   push (@irq_terms,"(ie_gap_detection  && gap_timeout )") if $use_gap_detection;


  e_assign->add (["qualified_irq", join (" ||\n", @irq_terms)]);

  e_assign->add(["tx_shift_not_empty", "~tx_shift_empty"])if $trans_pin ;
  e_assign->adds
       ([e_port->new (["transmitting",  1, "out"]),  "tx_shift_not_empty" ] )if $trans_pin ;
  return $module,
}




















sub make_uart_rxd_source
{
  my ($Options) = (@_);
  my $module = e_module->new ({name  => $rx_source_module_name});
  my $marker = e_default_module_marker->new ($module);






  e_port->adds(
    ["rxd",           1,                        "in"],
    ["source_rxd",    1,                       "out"],
    ["rx_char_ready", 1,                        "in"],
    ["clk",           1,                        "in"],
    ["clk_en",        1,                        "in"],
    ["reset_n",       1,                        "in"],
    ["rx_char_ready", 1,                        "in"],
    ["baud_divisor",  $divisor_bits, "in"],
  );





  e_assign->add({
   tag  => "synthesis",
   lhs  => "source_rxd",
   rhs  => "rxd",
  });








  my @dummies = e_signal->adds (
    ["unused_overrun"],
    ["unused_ready"  ],
    ["unused_empty"  ],
  );

  foreach my $dummy_sig (@dummies) {
    $dummy_sig->never_export   (1);
  }

  if (!$hw_cts) {
  e_instance->add ({
    module             => $tx_module_name,
    name               => "stimulus_transmitter",
    tag                => "simulation",
    port_map           => {
      txd                => "source_rxd",
      tx_overrun         => "unused_overrun",
      tx_ready           => "unused_ready",
      tx_shift_empty     => "unused_empty",
      do_force_break     => "1'b0",
      status_wr_strobe   => "1'b0",
      tx_data            => "d1_stim_data",
      begintransfer      => "do_send_stim_data",
      tx_wr_strobe       => "1'b1",
    },
  });
  }
  else
  {
    e_instance->add ({
    module             => $tx_module_name,
    name               => "stimulus_transmitter",
    tag                => "simulation",
    port_map           => {
      txd                => "source_rxd",
      tx_overrun         => "unused_overrun",
      tx_ready           => "unused_ready",
      tx_shift_empty     => "unused_empty",
      do_force_break     => "1'b0",
      status_wr_strobe   => "1'b0",
      tx_data            => "d1_stim_data",
      begintransfer      => "do_send_stim_data",
      tx_wr_strobe       => "1'b1",
      cts_n              => "1'b1",
    },
  });
  }



  e_signal->add ({
    tag             => "simulation",
    name            => "stim_data",
    width           => $data_bits,
  });


  e_register->add ({
    tag    => "simulation",
    in     => "stim_data",
    out    => e_signal->add(["d1_stim_data", $data_bits]),
    enable => "do_send_stim_data",
  });
















  my $size = &max ($mutex_file_size + 1, 1024);

   e_assign->add({
      tag => "simulation",
      lhs => "stim_data",
      rhs => "8'b0",   
  });





















  e_edge_detector->add ({
    tag             => "simulation",
    out             => "pickup_pulse",
    in              => "rx_char_ready",
    edge            => "falling",
  });





  e_assign->add ({
    tag             => "simulation",
    lhs             => "do_send_stim_data",
    rhs             => "(pickup_pulse || 1'b0) && 1'b0",
  });

  return $module;
}

1;
