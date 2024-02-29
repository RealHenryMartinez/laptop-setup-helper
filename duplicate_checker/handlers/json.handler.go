package handlers

import (
	"encoding/json"
	"fmt"
	"os"
	"project/helpers"
	"project/models"
	"strings"
)

type Laptop = models.Laptop

func LaptopJsonHandler() error {
	// Store file endpoints to read from
	files := []string{"one", "two", "three", "four"}
	laptops_data := make([]Laptop, 0, 100)

	for _, file_number := range files {
		// Know which directory to read the json files from
		path, _ := os.Getwd()
		fmt.Println(path)

		// Get our data
		jsonFile, err := os.ReadFile("../../Documents/Laptop_Data_Test/mac_info_" + file_number + ".json")
		if err != nil {
			return err
		}

		//
		laptop_data := make([]Laptop, 0, 100)

		// Be able to place json information to a struct
		stringify_json := string(jsonFile)
		file_reader := strings.NewReader(stringify_json)
		decoder := json.NewDecoder(file_reader) // Be able to read the bytes to be used as a struct instance

		// Decode the JSON data into the struct
		if err := decoder.Decode(&laptop_data); err != nil {
			return err
		}

		// Create a total list to be able to filter out later on
		laptops_data = append(laptops_data, laptop_data...)
		fmt.Println("Laptop data", len(laptops_data))
	}

	// Filter out any duplicates and return the bytes turned to json readable data
	cleaned_laptops := helpers.ClearDuplicateLaptopsHelper(laptops_data)

	// Read the json bytes to a file
	os.WriteFile("laptops.json", cleaned_laptops, 0644)

	return nil
}
