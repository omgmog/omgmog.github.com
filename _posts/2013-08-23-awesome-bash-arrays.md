---
layout: post
title: "Awesome Bash arrays"
---
Just some examples of how to do things with Bash arrays, and their analogous examples in Javascript.

<!-- more -->

### Defining arrays

#### Javascript

{% highlight javascript linenos %}
var array = ["one","two","three","four","five"];
{% endhighlight %}

#### Bash

{% highlight bash linenos %}
array=("one" "two" "three" "four" "five")
{% endhighlight %}

### Looping through an array

#### Javascript

{% highlight javascript linenos %}
for (var i=0; i&lt;array.length; i++) {
    console.log(array[i]);
}
{% endhighlight %}

#### Bash

{% highlight bash linenos %}
for (( i=0; i&lt;${#array[@]}; i++ ));
do
    echo ${array[$i]}
done
{% endhighlight %}


### Getting the length of an array

#### Javascript

{% highlight javascript linenos %}
array.length; // output: 5
{% endhighlight %}

#### Bash

{% highlight bash linenos %}
${#array[@]} # output: 5
{% endhighlight %}

### Selecting a specific item in an array

#### Javascript

{% highlight javascript linenos %}
array[2]; // output: "three"
{% endhighlight %}

#### Bash

{% highlight bash linenos %}
${array[2]} # output: "three"
{% endhighlight %}


### Selecting a range of items in an array

It's worth noting that in the Javascript example, we specify the `start index` and `end index` as parameters, but in the Bash example we specify the `start index` and `length`.

#### Javascript

{% highlight javascript linenos %}
array.slice(1,3); // output: ["two", "three"]
{% endhighlight %}

#### Bash

{% highlight bash linenos %}
${array[@]:1:3} # output: two three four
{% endhighlight %}

### Length of a single item in the array

#### Javascript

{% highlight javascript linenos %}
array[2].length; // output: 5
{% endhighlight %}

#### Bash

{% highlight bash linenos %}
${#array[2]} # output: 5
{% endhighlight %}

### Re-assign the value of an index in the array

#### Javascript

{% highlight javascript linenos %}
array[2] = "ten";

array; // output: ["one", "ten", "three", "four", "five"]
{% endhighlight %}

#### Bash

{% highlight bash linenos %}
array[2]="ten"

${array} # output: one ten three four five
{% endhighlight %}

### Add to end of an array

#### Javascript

{% highlight javascript linenos %}
array.push("nine");

array; // output: ["one", "two", "three", "four", "five", "nine"]
{% endhighlight %}

#### Bash

{% highlight bash linenos %}
array=(${array[@]} "nine")

${array} # output: one two three four five nine

# bonus

array[${#array[@]}+1]="nine"
{% endhighlight %}

### Concatenate two arrays

#### Javascript

{% highlight javascript linenos %}
var array2 = ["apple", "orange", "banana"];

var new_array = array.concat(array2);

new_array; // output: ["one", "two", "three", "four", "five", "apple", "orange", "banana"]
{% endhighlight %}

#### Bash

{% highlight bash linenos %}
array2=("apple" "orange" "banana")

new_array=(${array[@]} ${array2[@]})

${new_array} # one two three four five apple orange banana
{% endhighlight %}
