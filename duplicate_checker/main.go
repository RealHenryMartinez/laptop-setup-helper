package main

import (
	"fmt"
	"os"
	"project/handlers"
)

func main() {
	arguments := os.Args[1:]
	if len(arguments) > 1 {

		fmt.Println("Running Laptop Number Insertion")
		err := handlers.LaptopNumberInput(arguments)

		if err != nil {
			fmt.Println(err)
		}
	} else {
		fmt.Println("Running Laptop Json Handler")
		err := handlers.LaptopJsonHandler()

		if err != nil {
			fmt.Println(err)
		}
	}
}
