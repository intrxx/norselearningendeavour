package main

//import "algo" this is just a regular import
import my_algo "algo" // this is named import!
import "data_structures"

main :: proc() {
    my_algo.algo_showcase()
    data_structures.data_structures_showcase();
}   