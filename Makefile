PROJECT?=github.com/rumyantseva/gophercon
APP?=gophercon
PORT?=8000

RELEASE?=0.0.1
COMMIT?=$(shell git rev-parse --short HEAD)
BUILD_TIME?=$(shell date -u '+%Y-%m-%d_%H:%M:%S')

#GOOS?=linux
#GOARCH?=amd64


clean:
	rm -f ./bin/${APP}

build: clean
	#CGO_ENABLED=0 GOOS=${GOOS} GOARCH=${GOARCH}
	go build \
	-ldflags "-s -w -X ${PROJECT}/version.Release=${RELEASE} \
		-X ${PROJECT}/version.Commit=${COMMIT} \
		-X ${PROJECT}/version.BuildTime=${BUILD_TIME}" \
		-o ./bin/${APP} ${PROJECT}/cmd/gophercon 

run: build
	PORT=${PORT} ./bin/${APP}

test:
	go test -race ./...
