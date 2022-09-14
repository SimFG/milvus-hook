package main

import (
	"github.com/SimFG/milvus-hook/pb/milvuspb"
	"log"
)

func init() {
	log.Println("milvus-hook: hook plugin init...")
}

var Hook = hook{}

type hook struct{}

func (h hook) Init(params map[string]interface{}) error {
	return nil
}

func (h hook) Before(req interface{}) error {
	switch req.(type) {
	case *milvuspb.CreateCollectionRequest:
		log.Println("milvus-hook: CreateCollectionRequest")
		cr := req.(*milvuspb.CreateCollectionRequest)
		cr.CollectionName = "Hook"
	default:
		log.Println("milvus-hook: default")
	}
	log.Printf("milvus-hook: type-%T", req)
	return nil
}

func (h hook) After(result interface{}, err error) error {
	return nil
}
