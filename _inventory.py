#!/usr/local/bin/python3
server='http://10.0.7.1:5000'
import requests,json,sys

err = None
for i in range(0,5):
  try:
    if len(sys.argv)==2 and sys.argv[1]=='--list':
      r = requests.get(server+'/ansible/list', timeout=2)
      if r.status_code!=200:
        raise Exception('api broken')
      print(json.dumps(r.json()))
      sys.exit(0)
    elif len(sys.argv)==3 and sys.argv[1]=='--host':
      r = requests.get(server+'/ansible/host/'+sys.argv[2], timeout=2)
      if r.status_code!=200:
        raise Exception('no such host')
      print(json.dumps(r.json()))
      sys.exit(0)
    else:
      raise Exception('wrong syntax')
  except Exception as e:
    err=e
    pass
print('{"error":"'+str(err)+'"}')
