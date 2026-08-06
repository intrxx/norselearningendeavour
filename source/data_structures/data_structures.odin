package data_structures

import "core:sys/valgrind"
import "core:fmt"

data_structures_showcase :: proc() {
    int_Stack: Stack(int)
    defer delete(int_Stack.items)

    stack_push(&int_Stack, 5)
    stack_push(&int_Stack, 4)
    stack_pop(&int_Stack)
    stack_print(&int_Stack)
    stack_push(&int_Stack, 3)
    stack_print(&int_Stack)
    fmt.println(stack_peek(&int_Stack))

    int_queue: Queue(int, 10)
    queue_enqueue(&int_queue, 10)
    if val, ok := queue_peek(&int_queue); ok {
        fmt.println("Queue peek: ", val) // 10
    }
    queue_enqueue(&int_queue, 11)
    if val, ok := queue_dequeue(&int_queue); ok {
        fmt.println("Queue peek: ", val) // 10
    }
    if val, ok := queue_peek(&int_queue); ok {
        fmt.println("Queue peek: ", val) // 11
    }
    if val, ok := queue_dequeue(&int_queue); ok {
        fmt.println("Queue peek: ", val) // 11
    }
    if val, ok := queue_dequeue(&int_queue); !ok {
        fmt.println("Queue is empty!") // Print this
    }
    queue_enqueue(&int_queue, 123)
    queue_enqueue(&int_queue, 5)
    queue_enqueue(&int_queue, 21)
    queue_enqueue(&int_queue, 1)
    queue_enqueue(&int_queue, 879)
    queue_print(&int_queue)
}

// -----------------------------------------------------------

Stack :: struct($T: typeid) {
    items: [dynamic]T
} 

stack_push :: proc(s: ^Stack($T), val: T) {
    append(&s.items, val)
}

stack_pop :: proc(s: ^Stack($T)) -> (T, bool) {
    if stack_is_empty(s) {
        return T{}, false
    }

    return pop(&s.items), true
}

stack_peek :: proc(s: ^Stack($T)) -> (T, bool) {
     if stack_is_empty(s) {
        return T{}, false
    }

    return s.items[stack_len(s) - 1], true
}

stack_is_empty :: proc(s: ^Stack($T)) -> bool {
    return stack_len(s) == 0
}

stack_len :: proc(s: ^Stack($T)) -> int {
    return len(s.items)
}

stack_print :: proc(s: ^Stack($T)) {
    fmt.println("Printing Stack: ")
    for item in s.items {
        fmt.println(item)
    }
    fmt.println("----------------------")
}

// -----------------------------------------------------------

Queue :: struct($T: typeid, $queue_size: int) {
    items: [queue_size]T,
    head: int,
    tail: int,
    count: int,
}

queue_enqueue :: proc(q: ^Queue($T, $N), val: T) -> bool {
    if queue_is_full(q) {
        return false
    }
    q.items[q.tail] = val
    q.tail = (q.tail + 1) % N
    q.count += 1
    return true
} 

queue_dequeue :: proc(q: ^Queue($T, $N)) -> (T, bool) {
    if queue_is_empty(q) {
        return T{}, false
    }
    val := q.items[q.head]
    q.head = (q.head + 1) % N
    q.count -= 1
    return val, true
} 

queue_is_empty :: proc(q: ^Queue($T, $N)) -> bool {
    return q.count == 0
}

queue_is_full :: proc(q: ^Queue($T, $N)) -> bool {
    return q.count == N
}

queue_peek :: proc(q: ^Queue($T, $N)) -> (T, bool) {
    if queue_is_empty(q) {
        return T{}, false
    }
    return q.items[q.head], true
}

queue_print :: proc(q: ^Queue($T, $N)) {
    fmt.print("Queue: ")
    for item in q.items {
        fmt.printf(" %d;", item)
    }
    fmt.println()
}

// -----------------------------------------------------------






