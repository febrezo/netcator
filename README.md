Netcator
========
A simple PoC of a Linux payload that gets connected to a listening netcat via Tor and lets the attacker run commands in the target machine.

License: GPLv3+
---------------

This is free software, and you are welcome to redistribute it under certain conditions.

	This program is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.

	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with this program.  If not, see <http://www.gnu.org/licenses/>.

For more details on this issue, check the [COPYING](COPYING) file.

Installation
------------

Although this software is a PoC, this can be easily run as a local plugin by copying the ruby files in their corresponding metasploit data directory.

Scenario
--------

Assuming that the victim is already running Tor, to set the environment an attacker would have to:

1. Install tor in the attacker machine. E. g., in Debian-like systems:
```
	sudo apt-get install tor
```
2. Set up a listening netcat locally in the machine.
```
	nc -v -l -p 1234 127.0.0.1
```
3. Configuring the listening netcat to be reachable via Tor by updating the torrc file:
```
	HiddenServiceDir /var/lib/tor/nc_hidden_service/
	HiddenServicePort 1234 127.0.0.1:1234
```
4. Start the Tor service in the attacker's machine and get the hostname stored in the HiddenServiceDir set before:
```
	service tor start
```
5. Prepare the payload accordingly.

Final Remarks
-------------

Note that the full scenario will imply the installation/compilation of Tor in the victim. 
Similar scenarios can be deployed using other services such as SSH or Meterpreter.
 
More detailed information can be found in the [Eleven Paths](https://www.elevenpaths.com/es/nuevo-eleven-paths-discover-netcator-shell-inversa-a-traves-de-tor/index.html).

About the Authors
-----------------

Developed as a PoC by [Yaiza Rubio](https://twitter.com/yrubiosec) and [Félix Brezo](https://twitter.com/febrezo) to show the possibilities provided by this approach.
