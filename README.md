# Mini Kickstarter

A simulation of a crowd-funding application. Features support for managing projects, backers, and backings via credit cards.

Requires Ruby 2.1.5+ and Bundler.

Tested on Linux.

## Installation

Clone the `git` repo and enter the cloned directory:

```sh
$ git clone git@github.com:thirdtruck/mini-kickstarter.git
$ cd mini-kickstarter
```

Run Bundler to install the required Ruby gems:

```sh
$ bundle install
```

## Usage

```sh
$ ./bin/mini_kickstarter <command> [parameter] [...]
```

### Example

```sh
$ ./bin/mini_kickstarter list

-- John backed for $50
-- Jane backed for $50
-- Mary backed for $400
Awesome_Sauce is successful!
```
