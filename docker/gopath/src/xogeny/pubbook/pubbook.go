package main

import "log"

import hs "github.com/xogeny/go-hooksink"

type Builder struct {}

func (b Builder) Push(msg hs.HubMessage) {
	/* Checkout repo locally */
	/* Run make */
	/* Clean up */
	log.Printf("PUSH: %v", msg);
}

func main() {
	h := hs.NewHookSink("ssshhhh!");
	h.Add("/build", Builder{});
	h.Start();
}
