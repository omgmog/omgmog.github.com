---
layout: post
title: "Awesome Bash arrays"
---
Just some examples of how to do things with Bash arrays, and their analogous examples in Javascript.

<!-- more -->

### Defining arrays

#### Javascript

<pre><code data-language="shell">var array = ["one","two","three","four","five"];</code>
</pre>

#### Bash

<pre><code data-language="shell">array=("one" "two" "three" "four" "five")</code>
</pre>

### Looping through an array

#### Javascript

<pre><code data-language="shell">for (var i=0; i&lt;array.length; i++) {
    console.log(array[i]);
}</code>
</pre>

#### Bash

<pre><code data-language="shell">for (( i=0; i&lt;${#array[@]}; i++ ));
do
    echo ${array[$i]}
done</code>
</pre>


### Getting the length of an array

#### Javascript

<pre><code data-language="shell">array.length; // output: 5</code>
</pre>

#### Bash

<pre><code data-language="shell">${#array[@]} # output: 5</code>
</pre>

### Selecting a specific item in an array

#### Javascript

<pre><code data-language="shell">array[2]; // output: "three"</code>
</pre>

#### Bash

<pre><code data-language="shell">${array[2]} # output: "three"</code>
</pre>


### Selecting a range of items in an array

It's worth noting that in the Javascript example, we specify the `start index` and `end index` as parameters, but in the Bash example we specify the `start index` and `length`.

#### Javascript

<pre><code data-language="shell">array.slice(1,3); // output: ["two", "three"]</code>
</pre>

#### Bash

<pre><code data-language="shell">${array[@]:1:3} # output: two three four</code>
</pre>

### Length of a single item in the array

#### Javascript

<pre><code data-language="shell">array[2].length; // output: 5</code>
</pre>

#### Bash

<pre><code data-language="shell">${#array[2]} # output: 5</code>
</pre>

### Re-assign the value of an index in the array

#### Javascript

<pre><code data-language="shell">array[2] = "ten";

array; // output: ["one", "ten", "three", "four", "five"]</code>
</pre>

#### Bash

<pre><code data-language="shell">array[2]="ten"

${array} # output: one ten three four five</code>
</pre>

### Add to end of an array

#### Javascript

<pre><code data-language="shell">array.push("nine");

array; // output: ["one", "two", "three", "four", "five", "nine"]</code>
</pre>

#### Bash

<pre><code data-language="shell">array=(${array[@]} "nine")

${array} # output: one two three four five nine

# bonus

array[${#array[@]}+1]="nine"</code>
</pre>

### Concatenate two arrays

#### Javascript

<pre><code data-language="shell">var array2 = ["apple", "orange", "banana"];

var new_array = array.concat(array2);

new_array; // output: ["one", "two", "three", "four", "five", "apple", "orange", "banana"]</code>
</pre>

#### Bash

<pre><code data-language="shell">array2=("apple" "orange" "banana")

new_array=(${array[@]} ${array2[@]})

${new_array} # one two three four five apple orange banana</code>
</pre>
