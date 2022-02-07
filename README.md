# hardware-test-automation
A collection of Ansible playbooks, and scripts (Bash and PowerShell) for automating network adapter configuration and switch data processing on Allied Telesis hardware and the AlliedWare Plus operating system. 

This project is under continuous development. 

--Key Points--

- Begins with running testconfig.sh
  - This accepts and records user input
  - This input populates a YAML template, and the old configuration details are backed up
- The template will be used to control conditionals in playbooks and other scripting
- End goal of the process is the configuration of equipment involved in the test chain
  - Network adapters, switch ports, and scripting to monitor Key Performance Indicators (KPIs) during tests.
- Gnuplot and other open source technologies will allow for the collected data to automatically be processed into human-readable graphs. 

--Requirements--

- ansible.netcommon
'''ansible-galaxy collection isntall ansible.netcommon'''
- ansible awplus collection
'''ansible-galaxy collection install alliedtelesis.awplus'''
