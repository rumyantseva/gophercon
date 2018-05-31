PROJECT?=github.com/rumyantseva/gophercon
APP?=gophercon
PORT?=8000
INTERNAL_PORT?=3001

RELEASE?=0.0.1
COMMIT?=$(shell git rev-parse --short HEAD)
BUILD_TIME?=$(shell date -u '+%Y-%m-%d_%H:%M:%S')

CONTAINER_IMAGE?=docker.io/webdeva/${APP}

GOOS?=linux
GOARCH?=amd64


clean:
	rm -f ./bin/${APP}

build: clean
	CGO_ENABLED=0 GOOS=${GOOS} GOARCH=${GOARCH} \
	go build \
	-ldflags "-s -w -X ${PROJECT}/version.Release=${RELEASE} \
		-X ${PROJECT}/version.Commit=${COMMIT} \
		-X ${PROJECT}/version.BuildTime=${BUILD_TIME}" \
		-o ./bin/${APP} ${PROJECT}/cmd/gophercon 

run: build
	PORT=${PORT} INTERNAL_PORT=${INTERNAL_PORT} ./bin/${APP}

container: build
	docker build -t $(CONTAINER_IMAGE):$(RELEASE) .


test:
	go test -race ./...
