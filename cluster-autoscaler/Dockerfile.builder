FROM golang:1.15 AS build
ENV CGO_ENABLED=0
ENV GOOS=linux
ENV GOARCH=amd64
ENV GOPATH=/go
ENV GO111MODULE=off
RUN mkdir -p /go/src/k8s.io/autoscaler/cluster-autoscaler
RUN go get github.com/kubernetes/autoscaler || echo "get dependance"
COPY . /go/src/k8s.io/autoscaler/cluster-autoscaler/
WORKDIR /go/src/k8s.io/autoscaler/cluster-autoscaler
RUN go build -o cluster-autoscaler main.go

FROM alpine:3.9
RUN apk --no-cache add \
    ca-certificates \
    tzdata \
    iptables
COPY --from=build /go/src/k8s.io/autoscaler/cluster-autoscaler/cluster-autoscaler /cluster-autoscaler
CMD ["/cluster-autoscaler"]
