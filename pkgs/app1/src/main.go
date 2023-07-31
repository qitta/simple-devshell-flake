package main

import (
	logger "github.com/charmbracelet/log"
)

func main() {
	logger.Info("Hello world from a tool written in golang.")
	logger.Info("I exist in pkgs/app1/src/ of the heimdall dev shell")
	logger.Warn("Bye bye.")
}
