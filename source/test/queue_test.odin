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

@(test)
test_overwrite_basic_no_overflow :: proc(t: ^testing.T) {
    // Sanity check: below capacity, overwrite variant should behave
    // exactly like normal enqueue.
    q: que.Queue(int, 4)

    que.queue_enqueue_override(&q, 1)
    que.queue_enqueue_override(&q, 2)

    testing.expect_value(t, que.queue_len(&q), 2)

    v, ok := que.queue_dequeue(&q)
    testing.expect(t, ok, "dequeue should succeed")
    testing.expect_value(t, v, 1)
}

@(test)
test_overwrite_evicts_oldest :: proc(t: ^testing.T) {
    q: que.Queue(int, 3)

    que.queue_enqueue_override(&q, 1)
    que.queue_enqueue_override(&q, 2)
    que.queue_enqueue_override(&q, 3)
    // buffer is now full: [1, 2, 3]

    que.queue_enqueue_override(&q, 4)
    // 1 should have been evicted; buffer is conceptually [2, 3, 4]

    testing.expect_value(t, que.queue_len(&q), 3)

    v1, _ := que.queue_dequeue(&q)
    v2, _ := que.queue_dequeue(&q)
    v3, _ := que.queue_dequeue(&q)

    testing.expect_value(t, v1, 2)
    testing.expect_value(t, v2, 3)
    testing.expect_value(t, v3, 4)
}

@(test)
test_overwrite_never_exceeds_capacity :: proc(t: ^testing.T) {
    q: que.Queue(int, 3)

    // Push way more than capacity — count should plateau at N, never grow past it.
    for i in 0 ..< 10 {
        que.queue_enqueue_override(&q, i)
    }

    testing.expect_value(t, que.queue_len(&q), 3)
}

@(test)
test_overwrite_keeps_most_recent_n :: proc(t: ^testing.T) {
    // After pushing 0..9 into a capacity-3 buffer, only the last 3
    // values (7, 8, 9) should remain, oldest-first.
    q: que.Queue(int, 3)

    for i in 0 ..< 10 {
        que.queue_enqueue_override(&q, i)
    }

    expected := []int{7, 8, 9}
    for exp in expected {
        v, ok := que.queue_dequeue(&q)
        testing.expect(t, ok, "dequeue should succeed while draining")
        testing.expect_value(t, v, exp)
    }

    testing.expect(t, que.queue_is_empty(&q), "queue should be empty after full drain")
}

@(test)
test_overwrite_across_multiple_wraps :: proc(t: ^testing.T) {
    // Force tail/head around the ring more than once (capacity 2, 7 pushes)
    // to catch bugs that only appear after several wraparounds, not just one.
    q: que.Queue(int, 2)

    for i in 0 ..< 7 {
        que.queue_enqueue_override(&q, i)
    }
    // Last 2 pushed were 5, 6

    v1, _ := que.queue_dequeue(&q)
    v2, _ := que.queue_dequeue(&q)

    testing.expect_value(t, v1, 5)
    testing.expect_value(t, v2, 6)
    testing.expect(t, que.queue_is_empty(&q), "queue should be empty after draining both")
}

@(test)
test_overwrite_interleaved_with_dequeue :: proc(t: ^testing.T) {
    // Mix overwrite-enqueues with normal dequeues to make sure head/tail/count
    // stay consistent when the buffer isn't purely "fill then drain."
    q: que.Queue(int, 3)

    que.queue_enqueue_override(&q, 1)
    que.queue_enqueue_override(&q, 2)

    v, _ := que.queue_dequeue(&q)
    testing.expect_value(t, v, 1)

    que.queue_enqueue_override(&q, 3)
    que.queue_enqueue_override(&q, 4)
    que.queue_enqueue_override(&q, 5)
    // buffer holds: [2, 3, 4, 5] logically, capacity 3 → 2 gets evicted → [3, 4, 5]

    testing.expect_value(t, que.queue_len(&q), 3)

    expected := []int{3, 4, 5}
    for exp in expected {
        val, ok := que.queue_dequeue(&q)
        testing.expect(t, ok, "dequeue should succeed")
        testing.expect_value(t, val, exp)
    }
}