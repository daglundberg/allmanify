# allmanify


[Allman style](allmanstyle.com) can improve code readability. **allmanify** converts **K&R style** code to **Allman style**.

> ⚠️ Status: **prototype**.
> 
> Should theoretically work with **Zig**, **Swift**, **JavaScript/TypeScript**, **C#** and **C++** and more.. but is currently only lightly tested with Zig and Swift.

---

## Why

* **Readability:** The structure of Allman formatted code can be easier to quickly parse for humans.
* **Lacking tooling:** Some language communities strongly favor K&R, which has led to standard formatting tools not supporting Allman.
* **Your monitor, your choice:** While a strict formatting standard can be beneficial in a team setting, code style readability is highly subjective and at the same time the *entire point* of a standard in the first place. Just remember to run that standard formatter before commiting your changes. No one has to know. 


## What it does

* Moves all line-ending `{` onto its own line with the same indentation as that line.
* Handles special cases: **} else {**, and **} else if ()** that also need extra line breaks inserted.
* Converts space indenting to tabs while re-indenting (This behavior will change).


## What it **does not** do yet

* Full parsing
* Reflowing code
* Leaving commented lines alone

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

* **Format a single file, writing to stdout**:

  ```sh
  allmanify main.zig > main.allman.zig
  ```

### Warning 

Do NOT write to the same file! This does not work yet! It will corrupt your file!
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
