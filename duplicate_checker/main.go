package main

import (
	"fmt"
	"project/handlers"
)

func main() {
	err := handlers.LaptopJsonHandler()

	if err != nil {
		fmt.Println(err)
	}
}
