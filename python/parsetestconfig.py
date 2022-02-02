#!/usr/bin/python

import yaml, shutil

stream = open('/home/pi/testing/currenttestconfig.yml', 'r')
data = yaml.load(stream)

shutil.copy('/home/pi/testing/templates/testtemplate.yml', '/home/pi/testing/templates/templatebackup.yml')

# For every test value, populate the test template
for k, v in data.items():
	#print 'looking for ' +k+ ', value: ' +str(v)+ ' ... updating configuration template...\n'
	temp = open('temp', 'wb')
	with open('/home/pi/testing/templates/testtemplate.yml', 'r') as f:
    		for line in f:
			#Find content in line, append data from test config
        		if line.startswith(str(k)):
            			line = line.strip() + ' ' + str(v) + '\n'
				#print line.strip()
			temp.write(line)
			#print line
	shutil.move('temp', '/home/pi/testing/templates/testtemplate.yml')
	temp.close()

# Restore original template after moving content to filled template
shutil.move('/home/pi/testing/templates/testtemplate.yml', '/home/pi/testing/templates/testtemplatefilled.yml')
shutil.move('/home/pi/testing/templates/templatebackup.yml', '/home/pi/testing/templates/testtemplate.yml')
