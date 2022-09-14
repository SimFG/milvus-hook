SCRIPTS_DIR=$(dirname "$0")

PROTO_DIR=$SCRIPTS_DIR/../milvus-proto/proto/
GOOGLE_PROTO_DIR=$SCRIPTS_DIR/../thirdparty/protobuf/protobuf-src/src/
PROTOC=$SCRIPTS_DIR/../thirdparty/protobuf/protobuf-build/protoc

PROGRAM=$(basename "$0")
GOPATH=$(go env GOPATH)

if [ -z $GOPATH ]; then
    printf "Error: the environment variable GOPATH is not set, please set it before running %s\n" $PROGRAM > /dev/stderr
    exit 1
fi

export PATH=${GOPATH}/bin:$PATH
echo `which protoc-gen-go`

# official go code ship with the crate, so we need to generate it manually.
pushd ${PROTO_DIR}

mkdir -p ../../pb/commonpb
mkdir -p ../../pb/schemapb
mkdir -p ../../pb/milvuspb

${PROTOC} --proto_path="${GOOGLE_PROTO_DIR}" --proto_path=. \
    --go_opt="Mmilvus.proto=github.com/SimFG/milvus-hook/pb/milvuspb;milvuspb" \
    --go_opt=Mcommon.proto=github.com/SimFG/milvus-hook/pb/commonpb \
    --go_opt=Mschema.proto=github.com/SimFG/milvus-hook/pb/schemapb \
    --go_out=plugins=grpc,paths=source_relative:../../pb/milvuspb milvus.proto
${PROTOC} --proto_path="${GOOGLE_PROTO_DIR}" --proto_path=. \
    --go_opt=Mmilvus.proto=github.com/SimFG/milvus-hook/pb/milvuspb \
    --go_opt=Mcommon.proto=github.com/SimFG/milvus-hook/pb/commonpb \
    --go_opt="Mschema.proto=github.com/SimFG/milvus-hook/pb/schemapb;schemapb" \
    --go_out=plugins=grpc,paths=source_relative:../../pb/schemapb schema.proto
${PROTOC} --proto_path="${GOOGLE_PROTO_DIR}" --proto_path=. \
    --go_opt=Mmilvus.proto=github.com/SimFG/milvus-hook/pb/milvuspb \
    --go_opt="Mcommon.proto=github.com/SimFG/milvus-hook/pb/commonpb;commonpb" \
    --go_opt=Mschema.proto=github.com/SimFG/milvus-hook/pb/schemapb \
    --go_out=plugins=grpc,paths=source_relative:../../pb/commonpb common.proto

popd