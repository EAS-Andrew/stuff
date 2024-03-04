package main

import (
    "fmt"
    "regexp"
    "strconv"
    "strings"
)

func validateMemory(memory string) (bool, error) {
    // Regex to match the memory format
    regex := regexp.MustCompile(`^(\d+)([EPTGMK]?i?|e\d+)$`)

    // Check if the memory format is valid
    if !regex.MatchString(memory) {
        return false, fmt.Errorf("invalid format")
    }

    // Extract the value and the unit
    matches := regex.FindStringSubmatch(memory)
    value, err := strconv.ParseFloat(matches[1], 64)
    if err != nil {
        return false, err
    }

    unit := matches[2]
    var bytes float64

    // Convert to bytes
    switch unit {
    case "E":
        bytes = value * 1e18
    case "P":
        bytes = value * 1e15
    case "T":
        bytes = value * 1e12
    case "G":
        bytes = value * 1e9
    case "M":
        bytes = value * 1e6
    case "K":
        bytes = value * 1e3
    case "Ei":
        bytes = value * 1024 * 1024 * 1024 * 1024 * 1024 * 1024
    case "Pi":
        bytes = value * 1024 * 1024 * 1024 * 1024 * 1024
    case "Ti":
        bytes = value * 1024 * 1024 * 1024 * 1024
    case "Gi":
        bytes = value * 1024 * 1024 * 1024
    case "Mi":
        bytes = value * 1024 * 1024
    case "Ki":
        bytes = value * 1024
    case "":
        bytes = value
    default:
        if strings.HasPrefix(unit, "e") {
            exponent, err := strconv.ParseFloat(unit[1:], 64)
            if err != nil {
                return false, err
            }
            bytes = value * math.Pow(10, exponent)
        } else {
            return false, fmt.Errorf("unknown unit")
        }
    }

    // Ensure it does not exceed 30Gi
    if bytes > 32212254720 {
        return false, fmt.Errorf("exceeds 30Gi limit")
    }

    return true, nil
}

func main() {
    memory := "29Gi" // Example input
    valid, err := validateMemory(memory)
    if err != nil {
        fmt.Println("Validation Error:", err)
    } else {
        fmt.Println("Is Valid?", valid)
    }
}
