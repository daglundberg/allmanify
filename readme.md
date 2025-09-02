# allmanify


[Allman style](allmanstyle.com) can improve code readability. **allmanify** converts **K&R style** code to **Allman style**.

> ⚠️ Status: **prototype**.
> 
> Should theoretically work with **Zig**, **Swift**, **JavaScript/TypeScript**, **C#** and **C++** and more.. but is currently only lightly tested with Zig and Swift.

---

## Why

* **Readability:** The structure of Allman formatted code can be easier to quickly parse for humans.
* **Tooling:** Some language communities strongly favor K&R, which has led to standard formatting tools not supporting Allman.
* **Your code, your choice:** While defining a standard is beneficial, code readability is subjective and more important. You can always format it back to whatever the language specific convention is before committing it to repos.


## What it does

* Moves all line-ending `{` onto its own line with the same indentation as the line it ended.
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
# Requires a reasonably recent Zig (0.12+ recommended)
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
* More 
* Editor integrations (pre-commit, `git` filter, `zig fmt`-adjacent workflows)

---

## Contributing

Prototype quality is expected. Please:

1. Open an issue with a minimal code sample that misbehaves, and describe the expected vs actual output.
2. Add tests alongside your fix if possible.
3. Keep changes small and focused.

---

## License

**Unlicense** — a permissive license that dedicates the work to the public domain.

See the `LICENSE` file for full details.
