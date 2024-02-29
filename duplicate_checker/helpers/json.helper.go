package helpers

import (
	"encoding/json"
	"project/models"
)

type Laptop = models.Laptop

func ClearDuplicateLaptopsHelper(all_laptops []Laptop) []byte {
	laptops_found := make([]Laptop, 0, 150)

	// Any serial numbers found and are unique, store here to compare later
	serial_numbers := make(map[string]struct{})

	for _, laptop := range all_laptops {
		// Using maps, we are able to check if a property exists for a serial number and whether the serial number was found
		if _, found := serial_numbers[laptop.Serial_number]; !found {
			// Serial number not found in the map, it's unique
			serial_numbers[laptop.Serial_number] = struct{}{}
			laptops_found = append(laptops_found, laptop)
		}
	}

	// Marshal the laptops_found slice into JSON format
	jsonData, err := json.Marshal(laptops_found)
	if err != nil {
		return nil
	}

	return jsonData
}
