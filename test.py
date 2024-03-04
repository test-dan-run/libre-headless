import requests

url = 'http://localhost:8000/upload'
file = {'file': open('sample_slides.pptx', 'rb')}
resp = requests.post(url=url, files=file)

with open("test.pdf", "wb") as fw:
    fw.write(resp.content)
