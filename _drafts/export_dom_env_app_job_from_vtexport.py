from lxml import etree
import os as os
import copy
#import re

# loading tree
tree = etree.parse('vtexport.xml')

Domain = tree.getroot()
DomainName = Domain.attrib['name']

# mkdir with Environment name
if not os.path.exists(DomainName):
	os.mkdir(DomainName)

# write an xml /Domain without Environments
DomainWithoutEnv = copy.deepcopy(Domain)
DomainWithoutEnv.remove(DomainWithoutEnv.find('Environments'))
DomainWithoutEnv.attrib['generationDate'] = ''

# remove all status for Hosts and Links
for Host in DomainWithoutEnv.findall('Hosts/Host'):
	if 'lastStatus' in Host.attrib:
		del Host.attrib['lastStatus']
	if 'lastTimeStatus' in Host.attrib:
		del Host.attrib['lastTimeStatus']
	if 'lastTimeResolv' in Host.attrib:
		del Host.attrib['lastTimeResolv']
	if 'lastTimeCheck' in Host.attrib:
		del Host.attrib['lastTimeCheck']
	if 'lastError' in Host.attrib:
		del Host.attrib['lastError']

for Link in DomainWithoutEnv.findall('Links/Link'):
	Link.attrib['status'] = ''

f = open(DomainWithoutEnv.attrib['name'] +  ".xml","w")
f.write(etree.tostring(DomainWithoutEnv).strip())
#f.write( re.sub(r">\s+<","> <",etree.tostring(DomainWithoutEnv)) )
f.close

# iterate on each Environments
for Environment in Domain.findall('Environments/Environment'):
	
	EnvironmentName = Environment.attrib['name']
	
	# mkdir with Environment name
	if not os.path.exists(DomainName+"/"+EnvironmentName):
		os.mkdir(DomainName+"/"+EnvironmentName)
	
	# remove Applications node
	EnvironmentWithoutApp = copy.deepcopy(Environment)
	EnvironmentWithoutApp.remove(EnvironmentWithoutApp.find('Applications'))

	# remove UsedResources (because the order changes on new vtimport)
	EnvironmentWithoutApp.remove(EnvironmentWithoutApp.find('UsedResources'))
	
	# remove nodeSID from Graph/Node (because it changes on every vtimport)
	for GraphNode in EnvironmentWithoutApp.findall('Graph/Node'):
		if 'nodeSId' in GraphNode.attrib:
			del GraphNode.attrib["nodeSId"]
	
	# split all Environments into separate files xml without Applications node
	# so we see the versioning (change, del, add)
	f = open(DomainName+"/"+EnvironmentName +  ".xml","w")
	f.write(etree.tostring(EnvironmentWithoutApp).strip())
	#f.write( re.sub(r">\s+<","> <",etree.tostring(EnvironmentWithoutApp)) )
	f.close
	
	# iterate on each Applications
	for Application in Environment.findall('Applications/Application'):
		ApplicationName = Application.get('name')
		
		# mkdir with Application name
		if not os.path.exists(DomainName+"/"+EnvironmentName+"/"+ApplicationName):
			os.mkdir(DomainName+"/"+EnvironmentName+"/"+ApplicationName)
		
		# remove Jobs node
		ApplicationtWithoutApp = copy.deepcopy(Application)
		ApplicationtWithoutApp.remove(ApplicationtWithoutApp.find('Jobs'))
		
		# remove status
		ApplicationtWithoutApp.attrib['status'] = ''
		
		# remove nodeSID from Graph/Node (because it changes on every vtimport)
		for GraphNode in ApplicationtWithoutApp.findall('Graph/Node'):
			if 'nodeSId' in GraphNode.attrib:
				del GraphNode.attrib["nodeSId"]
		
		# split all Applications into separate files xml without Jobs node
		# so we see the versioning (change, del, add)
		f = open(DomainName+"/"+EnvironmentName+"/"+ApplicationName +  ".xml","w")
		f.write(etree.tostring(ApplicationtWithoutApp).strip())
		#f.write(re.sub(r">\s+<","> <",etree.tostring(ApplicationtWithoutApp)) )
		f.close
		
		# iterate on each Jobs
		for Job in Application.findall('Jobs/Job'):
			JobName = Job.get('name')
			
			# remove status
			if 'status' in Job.attrib:
				del Job.attrib["status"]
			if 'retcode' in Job.attrib:
				del Job.attrib["retcode"]
			
			f = open(DomainName+"/"+EnvironmentName+"/"+ApplicationName+"/" +JobName +  ".xml","w")
			f.write(etree.tostring(Job).strip())
			#f.write(re.sub(r">\s+<","> <",etree.tostring(Job)) )
			f.close

