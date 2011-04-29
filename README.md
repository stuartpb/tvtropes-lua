# Introduction
These scripts require LuaSocket and its HTTP module.

# Posting
Posting requires a known handle that has accepted the Terms of Serice on TVTropes.

# Files

The Lua files in this repository are of two types: modules and scripts.

## Modules

### urlencode

A general module for url-encoding strings, and tables (as forms). Required for constructing TVTropes post requests.

### tvtropes

The module for reading from and posting to TV Tropes. It contains two functions for operating on TV Tropes pages: if the page name is passed with no namespace, the function will prepend "Main/".

#### get(page)

Gets the source for `page`.

#### post(page, body, handle, passphrase, reason)

Posts `body` to `page` using the given `handle` and `passphrase`, with an optional edit reason.

### tvtropes_post_known

Contains a function that posts to TV Tropes using a predefined handle and passphrase (rather than taking them as parameters). When run, the module will read from files named `handle` and `passphrase`: if either file is missing, the script will prompt for it to be entered.

It can be integrated into the main tvtropes module with something like this:

    local tvtropes = require "tvtropes"
    tvtropes.post_known = require "tvtropes_post_known"

## Scripts

The scripts are designed to be run stand-alone as the root of execution.

### setup.lua

Sets up files for handle and passphrase as used by tvtropes_post_known. Without these files, scripts that post to TVTropes using tvtropes_post_known will prompt for a handle and passphrase every time.

### test.lua

This script tests the TVTropes posting functionality by editing the WikiSandbox page with the provided handle.

### arrdev_recap.lua

A script for generating Recap pages for Arrested Development episodes.
