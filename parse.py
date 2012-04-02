#!/usr/bin/python


from elementtree import ElementTree
import string
config = []
data = open('speedtest.xml')

eliterator = ElementTree.iterparse(data,events=('start','end'))
counter = 0
commits = 0
for event,element in eliterator:
    ns_tag = None
    tag = element.tag
    if tag[0] == '{':
        # cut ns
        ns_tag = tag
        tag = tag.split('}')[1]
#    print "=== LOAD",event,tag,ns_tag
    if event == 'end':
        country = element.attrib.get('countrycode')
        city = element.attrib.get('name')
        isp = element.attrib.get('sponsor') 
        url = element.attrib.get('url')
        counter += 1
        if (country == 'RU') or \
           (country == 'DE') or \
           (country == 'BG') or \
           (country == 'DE') or \
           (country == 'PL') or \
           (country == 'FR') or \
           (country == 'NL') or \
           (country == 'PL') or \
           (country == 'IT') or \
           (country == 'ES') or \
           (country == 'GR') or \
           (country == 'AU'):
            isp = string.replace(isp,' ','_')
            city = string.replace(city,' ','_')
            urls = url.split('/',3)
            host = urls[2]
            file0 = urls[3].replace('upload.php','random2000x2000.jpg')
#            print city,"\t",isp,"\t",host,"\t",file0
            config.append((city,isp,host,file0))
#            print city,"\t",isp

config=sorted(config, key=lambda temp: temp[0])

hosts = open("./hosts","w")

for st in config:
    hosts.write("%s\t%s\t%s\t%s\n"%(st[0],st[1],st[2],st[3]))
#    print st
hosts.close()
