package test

import "core:testing"
import "core:fmt"
import que "../data_structures"

@(test)
test_enqueue_dequeue_basic :: proc(t: ^testing.T) {
    q: que.Queue(int, 4)

    ok := que.queue_enqueue(&q, 10)
    testing.expect(t, ok, "enqueue should succeed on empty queue")

    val, got := que.queue_dequeue(&q)
    testing.expect(t, got, "dequeue should succeed with one item")
    testing.expect_value(t, val, 10)
}

@(test)
test_empty_dequeue_fails :: proc(t: ^testing.T) {
    q: que.Queue(int, 4)

    _, got := que.queue_dequeue(&q)
    testing.expect(t, !got, "dequeue on empty queue should fail")
}

@(test)
test_fifo_order :: proc(t: ^testing.T) {
    q: que.Queue(int, 4)

    que.queue_enqueue(&q, 1)
    que.queue_enqueue(&q, 2)
    que.queue_enqueue(&q, 3)

    v1, _ := que.queue_dequeue(&q)
    v2, _ := que.queue_dequeue(&q)
    v3, _ := que.queue_dequeue(&q)

    testing.expect_value(t, v1, 1)
    testing.expect_value(t, v2, 2)
    testing.expect_value(t, v3, 3)
}

@(test)
test_full_queue_rejects_enqueue :: proc(t: ^testing.T) {
    q: que.Queue(int, 3)

    testing.expect(t, que.queue_enqueue(&q, 1), "1st enqueue should succeed")
    testing.expect(t, que.queue_enqueue(&q, 2), "2nd enqueue should succeed")
    testing.expect(t, que.queue_enqueue(&q, 3), "3rd enqueue should succeed")

    ok := que.queue_enqueue(&q, 4)
    testing.expect(t, !ok, "enqueue on full queue should fail")
}

@(test)
test_wraparound :: proc(t: ^testing.T) {
    // Size-3 queue: force head/tail past N to prove modulo wrapping works.
    q: que.Queue(int, 3)

    que.queue_enqueue(&q, 1)
    que.queue_enqueue(&q, 2)
    que.queue_enqueue(&q, 3)

    v1, _ := que.queue_dequeue(&q)   // frees a slot, head advances past 0
    testing.expect_value(t, v1, 1)

    ok := que.queue_enqueue(&q, 4)   // tail should wrap around to index 0
    testing.expect(t, ok, "enqueue after dequeue should succeed and wrap")

    v2, _ := que.queue_dequeue(&q)
    v3, _ := que.queue_dequeue(&q)
    v4, _ := que.queue_dequeue(&q)

    testing.expect_value(t, v2, 2)
    testing.expect_value(t, v3, 3)
    testing.expect_value(t, v4, 4)  // proves the wrapped write was read correctly
}

@(test)
test_peek_does_not_advance :: proc(t: ^testing.T) {
    q: que.Queue(int, 4)
    que.queue_enqueue(&q, 42)

    v1, ok1 := que.queue_peek(&q)
    testing.expect(t, ok1, "peek should succeed on non-empty queue")
    testing.expect_value(t, v1, 42)

    // Peek again — should return the same value, since peek must not mutate head.
    v2, ok2 := que.queue_peek(&q)
    testing.expect_value(t, v2, 42)
    testing.expect(t, ok2, "second peek should still succeed")
}

@(test)
test_is_empty_and_is_full :: proc(t: ^testing.T) {
    q: que.Queue(int, 2)

    testing.expect(t, que.queue_is_empty(&q), "new queue should be empty")
    testing.expect(t, !que.queue_is_full(&q), "new queue should not be full")

    que.queue_enqueue(&q, 1)
    que.queue_enqueue(&q, 2)

    testing.expect(t, que.queue_is_full(&q), "queue should be full at capacity")
    testing.expect(t, !que.queue_is_empty(&q), "full queue should not be empty")
}