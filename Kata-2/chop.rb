=begin
# Kata Two -- Karate Chop
## Goals

This Kata has three separate goals:

1. As you’re coding each algorithm, keep a note of the kinds of error you encounter. A binary search is a ripe breeding ground for "off by one" and fencepost errors. As you progress through the week, see if the frequency of these errors decreases (that is, do you learn from experience in one technique when it comes to coding with a different technique?).
2. What can you say about the relative merits of the various techniques you’ve chosen? Which is the most likely to make it in to production code? Which was the most fun to write? Which was the hardest to get working? And for all these questions, ask yourself "why?".
3. It’s fairly hard to come up with five unique approaches to a binary chop. How did you go about coming up with approaches four and five? What techniques did you use to fire those "off the wall" neurons?

## Specification

Write a binary chop method that takes an integer search target and a sorted array of integers. It should return the integer index of the target in the array, or -1 if the target is not in the array. The signature will logically be:

    chop(int, array_of_int)  -> int

You can assume that the array has less than 100,000 elements. For the purposes of this Kata, time and memory performance are not issues (assuming the chop terminates before you get bored and kill it, and that you have enough RAM to run it).
=end

def chop(target, array)
    found = -1
    cursor = 0
    finding = array
    while (0 < finding.size && 0 > found)
        pos = finding.size / 2
        if target == finding[pos]
            found = cursor + pos
        elsif target < finding[pos]
            finding = finding.take(pos)
        else
            finding.shift(pos + 1)
            cursor += pos + 1
        end
    end
    found
end
