# Contributing to trcpproject

Thank you for contributing to **trcpproject**!

This package is developed collaboratively. The goal of this guide is to keep changes organized, make it easy for everyone to review each other's work, and avoid accidentally breaking the package.

## 1. Before you start

For anything more than a very small change:

1. Create or find a **GitHub Issue** describing the change.
2. Assign the Issue to yourself.
3. Create a branch for your work.
4. Make your changes and test them.
5. Open a **Pull Request**.
6. Ask at least one colleague to review it.
7. Merge the Pull Request after the checks pass and the reviewer approves it.

Please avoid pushing directly to `main`.

---

## 2. Create a branch

Start from the current `main` branch:

```bash
git checkout main
git pull
```

Create a new branch:

```bash
git checkout -b feature/my-new-feature
```

Use a short descriptive branch name, for example:

```text
feature/add-new-function
fix/missing-values
docs/update-readme
test/add-function-tests
```

---

## 3. Make your changes

Make the changes in your branch.

For new or modified functions, please add or update documentation as appropriate.

For changes to package behaviour, please add or update tests where practical.

If you are unsure whether something needs a test or documentation, don't worry — mention it in the Pull Request and discuss it with the reviewer.

---

## 4. Run the package checks

Before opening a Pull Request, run the relevant tests and checks locally.

For example, from R:

```r
devtools::test()
devtools::check()
```

If the package uses other automated checks, make sure these pass as well.

The GitHub Actions checks will also run automatically when a Pull Request is opened or updated.

---

## 5. Commit your changes

Use a short, descriptive commit message.

For example:

```bash
git add .
git commit -m "Add validation for missing patient IDs"
```

Then push your branch:

```bash
git push -u origin feature/my-new-feature
```

---

## 6. Open a Pull Request

Open a Pull Request from your branch into `main`.

In the Pull Request description, briefly explain:

* What you changed
* Why you changed it
* Any important implementation details
* What you tested

If the Pull Request addresses an Issue, link it. For example:

```text
Closes #17
```

This will automatically close the Issue when the Pull Request is merged.

---

## 7. Code review

At least one other team member should review changes before they are merged into `main`.

Reviewers may comment on:

* Correctness
* Readability
* Documentation
* Tests
* Potential unintended effects on existing functionality

Comments are intended to improve the package, not to criticize the person making the change.

If changes are requested, make them on the same branch and push them. The Pull Request will update automatically.

---

## 8. Merging

Once:

* the Pull Request has been reviewed,
* requested changes have been addressed, and
* the automated checks pass,

the Pull Request can be merged into `main`.

After merging, the branch can normally be deleted.

---

## 9. Small changes

For very small changes (for example, fixing a typo in the README), it may be reasonable to work more directly.

When in doubt, use the Issue → Branch → Pull Request workflow.

---

## 10. Working together

Please try to avoid having multiple people make unrelated changes to the same code at the same time.

If you are planning a larger change, especially one that affects the package structure or existing functions, discuss it with the team first and create an Issue describing the planned work.

The GitHub Project is used to keep track of ongoing work:

**Todo → In progress → Review → Done**

Please keep the Issue and Project status reasonably up to date so that everyone can see what is currently being worked on.

---

## 11. General principles

We aim for code that is:

* **Readable** — another team member should be able to understand it.
* **Reproducible** — results should not depend on undocumented local settings.
* **Tested** — important functionality should have tests where practical.
* **Documented** — exported functions should have appropriate documentation.
* **Backward-compatible where possible** — changes to existing functionality should be discussed before they are introduced.

Most importantly: **ask questions early rather than spending a long time trying to guess what the intended behaviour should be.**

Thank you for helping develop trcpproject!
