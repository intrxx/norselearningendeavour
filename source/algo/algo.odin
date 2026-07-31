#+feature dynamic-literals
package algo

import "core:strconv"
import "core:strings"
import "core:fmt"

algo_showcase :: proc() {
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

    palindrome_input := "oko"
    fmt.println("\nWe're checking for palindrome:\n", palindrome_input, palindrome_check(palindrome_input))

    array_to_sort := [14]int{5, 62, 1, 33, 12, 2, 23, 3, 4, 2131, 322, 2, 3, 5} 
    sort_input := array_to_sort
    fmt.println("\nWe're bubble sorting:\n", sort_input)
    bubble_sort(sort_input[:])
    fmt.printf(" Sorted: %d\n", sort_input)

    sort_input = array_to_sort
    fmt.println("\nWe're insertion sorting:\n", sort_input)
    insertion_sort(sort_input[:])
    fmt.printf(" Sorted: %d\n", sort_input)

    overload_int_a, overload_int_b, overload_float_a, overload_float_b, overload_string_a, overload_string_b := 6, 9, f32(2.22), f32(3.22), "foo", "bar"
    fmt.println("\nWe're overloading functions! (sort of):")
    fmt.println("Add: ", overload_int_a, overload_int_b, add(overload_int_a, overload_int_b))
    fmt.println("Add: ", overload_float_a, overload_float_b, add(overload_float_a, overload_float_b))
    fmt.println("Add: ", overload_string_a, overload_string_b, add(overload_string_a, overload_string_b))

    binary_found := 24
    fmt.println("\nLet's found some value in sorted array:", sort_input)
    fmt.printf(" Find me: %d, found index: %d\n", binary_found, binary_search(sort_input[:], binary_found))

    count_word_text := "the quick brown Fox jumps over the lazy dog the fox runs"
    fmt.println("\nLet's count words in sentence:\n", count_word_text, world_frequency_counter(count_word_text))

    array_to_stalin := [dynamic]int{4, 1, 342, 2, 12, 21, 2, 32, 2, 1231}
    defer delete(array_to_stalin)
    fmt.println("\nWe're stalin sorting:\n", array_to_stalin)
    stalin_sort(&array_to_stalin)
    fmt.printf(" Sorted: %d\n", array_to_stalin)

    fmt.println("\n");
}

// -----------------------------------------------------------

multiply :: proc(first: int, second: int) -> int {
    return first * second;
}

divide :: proc(first: int, second: int) -> int {
    return first / second;
}

// -----------------------------------------------------------

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

// -----------------------------------------------------------

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

// -----------------------------------------------------------

count_characters :: proc(some_string: string) -> map[rune]int {
    return_count: map[rune]int
    for character in strings.to_lower(some_string) {
        return_count[character] += 1
    }
    return return_count
}

// -----------------------------------------------------------

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

// -----------------------------------------------------------

sum_of_digits :: proc(input: int) -> int {
    sum: int
    number := input
    for number != 0 {
        sum += number % 10
        number /= 10
    }
    return sum
}

// -----------------------------------------------------------

palindrome_check :: proc(input: string) -> bool {
    input_len := len(input)
    for character, index in input {
        if u8(character) != input[input_len - 1 - index] {
            return false
        }

        if index > input_len / 2 {
            break
        }
    }
    return true
}

// -----------------------------------------------------------

bubble_sort :: proc(input: []int) {
    size := len(input)
    for i := 0; i < size; i += 1 {
        swapped := false
        for j := 1; j < size - i; j += 1 {
           if input[j] < input[j - 1] {
                input[j - 1], input[j] = input[j], input[j - 1]
                swapped = true
           }
        }

        if !swapped {
            break
        }
    }
}

// -----------------------------------------------------------

insertion_sort :: proc(input: []int) {
    for i := 1; i < len(input); i += 1 {
        current_elem := input[i]
        j := i - 1
        for j >= 0 && input[j] > current_elem {
           input[j + 1] = input[j]
           j -= 1
        }
        input[j + 1] = current_elem
    }
}

// -----------------------------------------------------------

add_ints :: proc(a, b: int) -> int {
    return a + b
}

add_floats :: proc(a, b: f32) -> f32 {
    return a + b
}

add_strings :: proc(a, b: string) -> string {
    return strings.concatenate([]string{a, b})
}

add :: proc {
    add_ints,
    add_floats,
    add_strings,
}

// -----------------------------------------------------------

binary_search :: proc(input_array: []int, target_value: int) -> int {
    bottom_index := 0
    top_index := len(input_array)
    for bottom_index < top_index {
        middle_index := bottom_index + (top_index - bottom_index) / 2 
        
        elem_value := input_array[middle_index]
        if target_value == elem_value { return middle_index }

        if target_value > elem_value {
            bottom_index = middle_index + 1
        } else {
            top_index = middle_index
        }
    }
    return -1
}

// -----------------------------------------------------------

world_frequency_counter :: proc(input: string) -> map[string]int {
    return_count: map[string]int
    split_input := strings.split(strings.to_lower(input), " ")

    for word in split_input {
        return_count[word] += 1
    }

    return return_count
}

// -----------------------------------------------------------

stalin_sort :: proc(input: ^[dynamic]int) {
    i := 1
    for i < len(input) {
        if input[i] < input[i - 1] {
            ordered_remove(input, i)
        } else {
            i += 1
        }
    }
}

// -----------------------------------------------------------