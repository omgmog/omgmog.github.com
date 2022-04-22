---
comments_issue: 45
title: Awesome Bash arrays
---
Just some examples of how to do things with Bash arrays, and their analogous examples in Javascript.

<!-- more -->

### Defining arrays

#### Javascript

```javascript
var array = ["one","two","three","four","five"]
```

#### Bash

```bash
array=("one" "two" "three" "four" "five")
```

### Looping through an array

#### Javascript

```javascript
for (var i=0; i<array.length; i++) {
    console.log(array[i]);
}
```

#### Bash

```bash
for (( i=0; i<${#array[@]}; i++ ));
do
    echo ${array[$i]}
done
```

### Getting the length of an array

#### Javascript

```javascript
array.length; // output: 5
```

#### Bash

```bash
${#array[@]} # output: 5
```

### Selecting a specific item in an array

#### Javascript

```javascript
array[2]; // output: "three"
```

#### Bash

```bash
${array[2]} # output: "three"
```


### Selecting a range of items in an array

It's worth noting that in the Javascript example, we specify the `start index` and `end index` as parameters, but in the Bash example we specify the `start index` and `length`.

#### Javascript

```javascript
array.slice(1,3); // output: ["two", "three"]
```

#### Bash

```bash
${array[@]:1:3} # output: two three four
```

### Length of a single item in the array

#### Javascript

```javascript
array[2].length; // output: 5
```

#### Bash

```bash
${#array[2]} # output: 5
```

### Re-assign the value of an index in the array

#### Javascript

```javascript
array[2] = "ten";

array; // output: ["one", "ten", "three", "four", "five"]
```

#### Bash

```bash
array[2]="ten"

${array} # output: one ten three four five
```

### Add to end of an array

#### Javascript

```javascript
array.push("nine");

array; // output: ["one", "two", "three", "four", "five", "nine"]
```

#### Bash

```bash
array=(${array[@]} "nine")

${array} # output: one two three four five nine

# bonus

array[${#array[@]}+1]="nine"
```

### Concatenate two arrays

#### Javascript

```javascript
var array2 = ["apple", "orange", "banana"];

var new_array = array.concat(array2);

new_array; // output: ["one", "two", "three", "four", "five", "apple", "orange", "banana"]
```

#### Bash

```bash
array2=("apple" "orange" "banana")

new_array=(${array[@]} ${array2[@]})

${new_array} # one two three four five apple orange banana
```
