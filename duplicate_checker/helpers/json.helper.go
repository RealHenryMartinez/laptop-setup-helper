package helpers

import (
	"encoding/json"
	"fmt"
	"project/models"
	"strings"
)

type Laptop = models.Laptop

func ClearDuplicateLaptopsHelper(all_laptops []Laptop) ([]byte, error) {
	laptops_found := make([]Laptop, 0, 150)

	// Any serial numbers found and are unique, store here to compare later
	serial_numbers := make(map[string]Laptop)

	for _, laptop := range all_laptops {
		// Check if the serial number is already present
		if existingLaptop, found := serial_numbers[laptop.Serial_number]; found {
			// If the existing laptop's Laptop_number doesn't contain "TXT" but the current one does, replace it
			if !strings.Contains(existingLaptop.Laptop_number, "TXT") && strings.Contains(laptop.Laptop_number, "TXT") {
				// Replace the laptop in both the map and the slice
				serial_numbers[laptop.Serial_number] = laptop
				laptops_found = replaceLaptopInSlice(laptops_found, existingLaptop, laptop)
			}
		} else {
			// Serial number not found, add to map and laptops_found
			serial_numbers[laptop.Serial_number] = laptop
			laptops_found = append(laptops_found, laptop)
		}
	}

	// Marshal the laptops_found slice into JSON format
	jsonData, err := json.Marshal(laptops_found)
	if err != nil {
		return nil, err
	}

	return jsonData, nil
}

func replaceLaptopInSlice(slice []Laptop, oldLaptop Laptop, newLaptop Laptop) []Laptop {
	for i, laptop := range slice {
		if laptop == oldLaptop {
			slice[i] = newLaptop
			fmt.Print("Laptop: ")
			fmt.Println(slice[i])
			break
		}
	}
	return slice
}
