# export CR_PAT=

echo $CR_PAT | docker login ghcr.io -u vinisoaresr@hotmail.com --password-stdin

cd server

docker build -t backend-rinha .

docker tag backend-rinha ghcr.io/vinisoaresr/backend-rinha:latest

docker push ghcr.io/vinisoaresr/backend-rinha:latest