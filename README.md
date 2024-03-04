# Libre Headless

This repository focus on the building of a PDF Converting service. 

1. Build the Docker Image.
```bash
docker build -t libre-headless:0.0.1 .
```

2. Start the docker container. Command should already be in `run.sh`
```bash
./run.sh
```

3. Put a test filepath (non-pdf) in `test.py`, and run.
```bash
python3 test.py
``` 
