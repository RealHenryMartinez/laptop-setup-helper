package handlers

import (
	"encoding/json"
	"fmt"
	"os"
	"os/exec"
	"project/helpers"
	"project/models"
	"strconv"
	"strings"
)

type Laptop = models.Laptop

func LaptopJsonHandler() error {
	// Store file endpoints to read from
	files := []string{"one", "two", "three"}
	laptops_data := make([]Laptop, 0, 100)

	for _, file_number := range files {
		// Know which directory to read the json files from
		path, _ := os.Getwd()
		fmt.Println(path)

		// Get our data
		jsonFile, err := os.ReadFile("../../Documents/Laptop_number/mac_info_" + file_number + ".json")
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
	cleaned_laptops, err := helpers.ClearDuplicateLaptopsHelper(laptops_data)

	if err != nil {
		return err
	}
	// Read the json bytes to a file
	os.WriteFile("laptops.json", cleaned_laptops, 0644)

	return nil
}

func LaptopNumberInput(args []string) error {

	if v, _ := strconv.Atoi(args[0]); v >= 1 {

		// Run system_profiler command to get the serial number
		cmd := exec.Command("system_profiler", "SPHardwareDataType")
		output, err := cmd.Output()
		if err != nil {
			fmt.Println("Error:", err)
			return nil
		}

		// Process output to find the serial number
		lines := strings.Split(string(output), "\n")
		for _, line := range lines {
			if strings.Contains(line, "Serial Number") {
				// Extract the serial number
				serialNumber := strings.TrimSpace(strings.Split(line, ":")[1])
				fmt.Println("Serial Number:", serialNumber)

				jsonFile, err := os.ReadFile("./laptops.json")
				if err != nil {
					return err
				}

				// Extract json file to use to find the serial number and update its field with our laptop number
				laptop_data := make([]Laptop, 0, 150)
				stringify_json := string(jsonFile)
				file_reader := strings.NewReader(stringify_json)
				decoder := json.NewDecoder(file_reader)

				decoder.Decode(&laptop_data)
				found := false

				// Check for a serial number inside the json file to change the laptop number with our input
				for i := range laptop_data {
					if laptop_data[i].Serial_number == serialNumber {
						laptop_data[i].Laptop_number = "TXT-" + args[0]
						found = true
					}
				}

				if !found {
					return fmt.Errorf("No serial number in json file")

				}

				// Make the file of json containing the json information to make the write file read the data
				if json_bytes, e := json.Marshal(laptop_data); e != nil {
					return e
				} else {
					os.WriteFile("laptops.json", json_bytes, 0644)
				}

				break
			}
		}
	} else {
		return fmt.Errorf("Please include number")
	}

	return nil
}
