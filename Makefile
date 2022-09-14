GO		  ?= go
PWD 	  := $(shell pwd)
GOPATH	:= $(shell $(GO) env GOPATH)

generated-proto-go: export protoc:=${PWD}/thirdparty/protobuf/protobuf-build/protoc
generated-proto-go:
	@(env bash $(PWD)/scripts/proto_gen_go.sh)