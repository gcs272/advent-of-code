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

	fmt.Printf("%#v", len(black))
}
