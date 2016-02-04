# Curriculum Collector

This Shell/Ruby trawls through the `scope-and-sequence.md` file and clones down all the repos referenced in it.

If the repos are already cloned, then it executes `git pull origin master` for each one.

## Instructions

If desired, make tweaks to the `.config.sh` file. Then:

```
$ sh RUN-ME.sh
```

## What it should look like

If the `scope-and-sequence.md` document looks like this:

```md
# Scope and Sequence

Here's a paragraph!

## Javascript and the DOM
  - [Events and Callbacks](https://github.com/ga-wdi-lessons/js-events-callbacks)
  - [DOM Manipulation](https://github.com/ga-wdi-lessons/js-dom)
    - [HW: Pixart](https://github.com/ga-wdi-exercises/pixart_js)
```

...it'll produce a directory tree like this:

```txt
curriculum/
--- javascript-and-the-dom
    --- dom-manipulation
        --- hw-pixart
            --- .git
            --- LICENSE
            --- README.md
            --- index.html
            --- pixart.js
            --- ps_neutral.png
            --- style.css
        --- .git
        --- readme.md
    --- events-and-callbacks
        --- .git
        --- readme.md
```
