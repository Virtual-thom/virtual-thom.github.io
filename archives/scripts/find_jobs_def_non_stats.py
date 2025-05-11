#!/usr/bin/python
from lxml import etree
import pandas as pd
import sys

# loading tree
try:
  tree = etree.parse(sys.argv[1]+'.xml')
  Domain = tree.getroot()
except Exception, e:
  print >> sys.stderr, "Error: %s" % str(e)
  sys.exit(1)

# liste des jobs du referentiel
ListJobRef = [] ;

# iterate on each Environments
for Environment in Domain.findall('Environments/Environment'):
  # iterate on each Applications
  for Application in Environment.findall('Applications/Application'):
    # iterate on each Jobs
    for Job in Application.findall('Jobs/Job'):
      ListJobRef.append({'env':Environment.attrib['name'], 'app':Application.get('name'), 'job':Job.get('name'), 'amode':Application.get('mode'), 'jmode':Job.get('mode'), 'aond':Application.get('onDemand'), 'jond':Job.get('onDemand')})

dfJobRef = pd.DataFrame(ListJobRef,columns=['env','app','job','amode','jmode','aond','jond'])

try:
  dfJobStat = pd.read_csv(sys.argv[1]+'.csv',sep=";",names=["env","app","job","duration"])
except Exception, e:
  print >> sys.stderr, "Error: %s" % str(e)
  sys.exit(2)

# on merge les jobs Ref et les stats
dfCommon = dfJobRef.merge(dfJobStat,on=['env','app','job'],how='left', indicator=True)

# on ne retient que les jobs qui :
# - ne sont pas a STOP (ou app)
# - ne sont pas a la demande (ou app) 
# - ne sont pas dans les stats
try:
  dfCommon[(dfCommon['_merge']=='left_only')&(dfCommon['amode'] != "O")&(dfCommon['jmode'] != "O")&(dfCommon['aond'] != "1")&(dfCommon['jond'] != "1")].to_csv(sys.argv[1]+'_non_stat.csv')
except Exception, e:
  print >> sys.stderr, "Error: %s" % str(e)
  sys.exit(3)
