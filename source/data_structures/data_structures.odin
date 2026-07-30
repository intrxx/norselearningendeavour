package data_structures

import "core:fmt"

data_structures_showcase :: proc() {
    int_stack: stack(int)
    defer delete(int_stack.items)

    stack_push(&int_stack, 5)
    stack_push(&int_stack, 4)
    stack_pop(&int_stack)
    stack_print(&int_stack)
    stack_push(&int_stack, 3)
    stack_print(&int_stack)
    fmt.println(stack_peek(&int_stack))

}

// -----------------------------------------------------------

stack :: struct($T: typeid) {
    items: [dynamic]T
} 

stack_push :: proc(s: ^stack($T), val: T) {
    append(&s.items, val)
}

stack_pop :: proc(s: ^stack($T)) -> (T, bool) {
    if stack_is_empty(s) {
        return T{}, false
    }

    return pop(&s.items), true
}

stack_peek :: proc(s: ^stack($T)) -> (T, bool) {
     if stack_is_empty(s) {
        return T{}, false
    }

    return s.items[stack_len(s) - 1], true
}

stack_is_empty :: proc(s: ^stack($T)) -> bool {
    return stack_len(s) == 0
}

stack_len :: proc(s: ^stack($T)) -> int {
    return len(s.items)
}

stack_print :: proc(s: ^stack($T)) {
    fmt.println("Printing stack: ")
    for item in s.items {
        fmt.println(item)
    }
    fmt.println("----------------------")
}

// -----------------------------------------------------------