package main

import (
	"fmt"
	"io/ioutil"
	"os"
	"strings"
)

func walk(path string, sx, sy int) (int, int) {
	if len(path) > 0 {
		if path[0] == 'w' {
			return walk(path[1:], sx-2, sy)
		} else if path[0] == 'e' {
			return walk(path[1:], sx+2, sy)
		} else if path[0:2] == "se" {
			return walk(path[2:], sx+1, sy-1)
		} else if path[0:2] == "ne" {
			return walk(path[2:], sx+1, sy+1)
		} else if path[0:2] == "sw" {
			return walk(path[2:], sx-1, sy-1)
		} else if path[0:2] == "nw" {
			return walk(path[2:], sx-1, sy+1)
		}
	}

	return sx, sy
}

func life(black map[[2]int]bool) map[[2]int]bool {
	// grab all counts of all neighbors
	neighbors := map[[2]int]int{}
	for pos, _ := range black {
		for _, d := range [][2]int{{-2, 0}, {2, 0}, {1, -1}, {1, 1}, {-1, -1}, {-1, 1}} {
			neighbors[[2]int{pos[0] + d[0], pos[1] + d[1]}]++
		}
	}

	next := map[[2]int]bool{}
	for pos, count := range neighbors {
		if count == 2 {
			next[pos] = true
		}
	}

	// flipped tiles stay if they have 1 or 2 neighbors
	for pos, _ := range black {
		filled := 0
		for _, d := range [][2]int{{-2, 0}, {2, 0}, {1, -1}, {1, 1}, {-1, -1}, {-1, 1}} {
			if _, ok := black[[2]int{pos[0] + d[0], pos[1] + d[1]}]; ok {
				filled++
			}
		}
		if filled == 1 || filled == 2 {
			next[pos] = true
		}
	}

	return next
}

func main() {
	contents, _ := ioutil.ReadAll(os.Stdin)
	black := map[[2]int]bool{}
	for _, path := range strings.Split(strings.TrimSpace(string(contents)), "\n") {
		x, y := walk(path, 0, 0)
		if _, ok := black[[2]int{x, y}]; ok {
			delete(black, [2]int{x, y})
		} else {
			black[[2]int{x, y}] = true
		}
	}

	fmt.Printf("one=%d", len(black))

	for i := 0; i < 100; i++ {
		black = life(black)
	}

	fmt.Printf("\ntwo=%d", len(black))
}
