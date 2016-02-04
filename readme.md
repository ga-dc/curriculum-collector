# Curriculum Collector

This Shell/Ruby trawls through a markdown outline and clones down all the repos referenced in it.

If the repos are already cloned, then it executes `git reset --hard origin/master` for each one.

> (It does this instead of `git pull origin master` to control for the possibility of the remote repo having been rebased or force-pushed.)

## Instructions

Create a file called `config.sh` and inside it put the following:

```
INPUT_URL="https://raw.githubusercontent.com/ga-dc/wdi8/master/scope-and-sequence.md"
TARGET_FOLDER="curriculum"
```

Then, run:

```
$ sh RUN-ME.sh
```

## What it should look like

If that `scope-and-sequence` document looks like this:

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
