# allmanify


[Allman style](allmanstyle.com) can improve code readability. **allmanify** converts **K&R style** code to **Allman style**.

> ⚠️ Status: **prototype**.
> 
> Should theoretically work with **Zig**, **Swift**, **JavaScript/TypeScript**, **C#** and **C++** and more.. but is currently only lightly tested with Zig and Swift.

---

## Why

* **Readability:** The structure of Allman formatted code can be easier to quickly parse for humans.
* **Lacking tooling:** Some language communities strongly favor K&R, which has led to standard formatting tools not supporting Allman.
* **Styling is cheap, your time is not:** While adhering to a strict formatting standard can be beneficial, code style readability is highly subjective and at the same time more important. Just remember to run that standard formatter before commiting your changes. No one will know. 


## What it does

* Moves all line-ending `{` onto its own line with the same indentation as that line.
* Handles special cases: **} else {**, and **} else if ()** that also need extra line breaks inserted.
* Converts space indenting to tabs while re-indenting (This will change later).


## What it **does not** do yet

* Full parsing
* Reflowing code
* Respecting comments

---

## Tested languages

* **Zig**
* **Swift**

> Contributions welcome!

---

## Install

### From source (Zig)

```sh
zig build
```

The built binary will be at `zig-out/bin/allmanify`.

---

## Usage

```
allmanify [OPTIONS] [PATH ...]
```

### Common examples

* **Format a single file, writing to stdout** (non-destructive):

  ```sh
  allmanify src/main.zig > src/main.allman.zig
  ```

* **In-place rewrite** (creates a backup by default):

  ```sh
  allmanify --write src/main.swift
  ```

---

## Before & After examples

**Zig (if/else):**
```zig
fn winamp() void {
    if (foo) {
        bar();
    } else {
        baz();
    }
}
```

→

```zig
fn winamp() void
{
    if (foo)
    {
        bar();
    }
    else
    {
        baz();
    }
}
```

**Swift (if/else):**

```swift
if foo {
    bar()
} else {
    baz()
}
```

→

```swift
if foo
{
    bar()
}
else
{
    baz()
}
```

**JavaScript (function):**

```js
function f(x) {
  if (x) {
    return 1;
  }
}
```

→

```js
function f(x)
{
    if (x)
    {
        return 1;
    }
}
```
---

## Roadmap

* More testing
* Editor integrations (pre-commit, `git` filter, `zig fmt`-adjacent workflows)
* Evaluate and prioritize additional features

---

## Contributing

You're more than welcome to help out. Just open an issue or create a pull request.

---

## License

**Unlicense** - No conditions, no warranties. Public domain.

See `LICENSE` file for full details.
