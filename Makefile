# Parameters to compile and run application
GOOS?=linux
GOARCH?=amd64

PROJECT?=github.com/rumyantseva/gophercon
BUILD_PATH?=cmd/gophercon
APP?=gophercon

PORT?=8000
INTERNAL_PORT?=3001

# Current version and commit
RELEASE?=0.0.2
COMMIT?=$(shell git rev-parse --short HEAD)
BUILD_TIME?=$(shell date -u '+%Y-%m-%d_%H:%M:%S')

# Parameters to push images and release app to Kubernetes or try it with Docker
REGISTRY?=gcr.io/containers-206912
NAMESPACE?=rumyantseva
CONTAINER_NAME?=${NAMESPACE}-${APP}
CONTAINER_IMAGE?=${REGISTRY}/${CONTAINER_NAME}
VALUES?=values-stable

clean:
	rm -f ./bin/${GOOS}-${GOARCH}/${APP}

build: clean
	CGO_ENABLED=0 GOOS=${GOOS} GOARCH=${GOARCH} \
	go build \
	-ldflags "-s -w -X ${PROJECT}/version.Release=${RELEASE} \
		-X ${PROJECT}/version.Commit=${COMMIT} \
		-X ${PROJECT}/version.BuildTime=${BUILD_TIME}" \
		-o ./bin/${GOOS}-${GOARCH}/${APP} ${PROJECT}/${BUILD_PATH}

container: build
	docker build -t $(CONTAINER_IMAGE):$(RELEASE) .

run: container
	docker stop $(CONTAINER_IMAGE):$(RELEASE) || true && docker rm $(CONTAINER_IMAGE):$(RELEASE) || true
	docker run --name ${APP} -p ${PORT}:${PORT} -p ${INTERNAL_PORT}:${INTERNAL_PORT} --rm \
		-e "PORT=${PORT}" -e "INTERNAL_PORT=${INTERNAL_PORT}" \
		$(CONTAINER_IMAGE):$(RELEASE)

test:
	go test -race ./...

push: container
	docker push $(CONTAINER_IMAGE):$(RELEASE)

deploy: push
	helm upgrade ${CONTAINER_NAME} -f charts/${VALUES}.yaml charts --kube-context ${KUBE_CONTEXT} --namespace ${NAMESPACE} --version=${RELEASE} -i --wait
