package models

type Laptop struct {
	Laptop_number string `json:"laptop_number"`
	Serial_number string `json:"serial_number"`
	Model_date    string `json:"model_date"`
	Screen_size   string `json:"screen_size"`
	Chip          string `json:"chip"`
	Status        string `json:"status"`
}
