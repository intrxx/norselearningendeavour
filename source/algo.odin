package main

import "core:strconv"
import "core:fmt"

main :: proc() {
    fmt.println("\nHello Algo!")
    fmt.println("We do some algos in this file to learn stuff!\n")
    
    multiply_x, multiply_y := 5, 4
    multiplied := multiply(multiply_x, multiply_y)
    fmt.printf("Multiply %d and %d to produce %d\n", multiply_x, multiply_y, multiplied)
    
    divided := divide(multiplied, multiply_x)
    fmt.printf("Divide %d and %d to produce %d\n", multiplied, multiply_x, divided)

    array_to_sum_and_max := [5]int{5, 1, 8, 3, 2}
    fmt.println("\nWe're summing and maxing an array!", array_to_sum_and_max);
    fmt.printf(" Sum is: %d\n", array_sum(array_to_sum_and_max[:]))
    fmt.printf(" Max elem is: %d\n", array_max(array_to_sum_and_max[:]))

    array_to_reverse := [5]int{1, 2, 3, 4, 5}
    fmt.println("\nWe're reversing array!", array_to_reverse)
    array_reverse(array_to_reverse[:])
    fmt.println(" Reversed:", array_to_reverse)

    count_string := "hello"
    fmt.println("\nWe're counting runes in a string:\n", count_string, count_characters(count_string))

    fizz_buzz_input := 15
    fmt.println("\nWe're doing fizzbuzz:\n", fizz_buzz_input, fizz_buzz(fizz_buzz_input))

    digit_sum_input := 123456789
    fmt.println("\nWe're summing digits in:\n", digit_sum_input, sum_of_digits(digit_sum_input))

    fmt.println("\n");
}

multiply :: proc(first: int, second: int) -> int {
    return first * second;
}

divide :: proc(first: int, second: int) -> int {
    return first / second;
}

array_sum :: proc(array: []int) -> int {
    sum: int
    for elem in array {
        sum += elem;
    }
    return sum;
}

array_max :: proc(array: []int) -> int {
    new_max: int
    for elem in array {
        if elem > new_max {
            new_max = elem;
        }
    }
    return new_max;
}

array_reverse :: proc(array: []int){
    for i := 0; i < len(array) / 2; i += 1 {
        reverse_index := len(array) - 1 - i
        array[i], array[reverse_index] = array[reverse_index], array[i]
    }
}

// This is interesting but a lot worse XD
array_reverse_alt :: proc(array: []int){
    temp_arr := make([]int, len(array))
    defer delete(temp_arr)

    copy(temp_arr, array)

    index: int
    #reverse for x in temp_arr {
        array[index] = x
        index += 1
    }
}

count_characters :: proc(some_string: string) -> map[rune]int {
    return_count: map[rune]int
    for character in some_string {
        return_count[character] += 1
    }
    return return_count
}

fizz_buzz :: proc(input: int) -> []string {
    returnArray := make([]string, input)
    for i := 1; i <= input; i += 1 {
        divisableBy3 := i % 3 == 0;
        divisableBy5 := i % 5 == 0;

        switch {
            case divisableBy3 && divisableBy5:
                returnArray[i-1] = "FizzBuzz"
            case divisableBy3:
                returnArray[i-1] = "Fizz" 
            case divisableBy5:
                returnArray[i-1] = "Buzz"
            case:
                returnArray[i-1] = fmt.aprintf("%d", i)    
        }
    }
    return returnArray
}

sum_of_digits :: proc(input: int) -> int {
    sum: int
    number := input
    for number != 0 {
        sum += number % 10
        number /= 10
    }
    return sum
}