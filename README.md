# iij/mruby

## What's this?

iij/mruby is a fork of [mruby](https://github.com/mruby/mruby), 
a lightweight implementation of the [Ruby](http://www.ruby-lang.org/) language.
This fork adds a lot of features to be run on IIJ's Internet router products:
[SEIL series](http://seil.jp/) and [SA-W1](http://www.sacm.jp/#saw1).

## Features

The majority of features developed in this repository are provided as mrbgems now.
These mrbgems can be used with either
[mruby/mruby](https://github.com/mruby/mruby) or [iij/mruby](https://github.com/iij/mruby).

| Repository | Description |
|:-----------|:------------|
| [mruby-digest](https://github.com/iij/mruby-digest) | [Digest](http://www.ruby-doc.org/stdlib-2.0/libdoc/digest/rdoc/Digest.html) module |
| [mruby-dir](https://github.com/iij/mruby-dir) | [Dir](http://www.ruby-doc.org/core-2.0/Dir.html) class |
| [mruby-env](https://github.com/iij/mruby-env) | [ENV](http://www.ruby-doc.org/core-2.0/ENV.html) object |
| [mruby-errno](https://github.com/iij/mruby-errno) | [Errno](http://www.ruby-doc.org/core-2.0/Errno.html) module |
| [mruby-io](https://github.com/iij/mruby-io) | [IO](http://www.ruby-doc.org/core-2.0/IO.html) and [File](http://www.ruby-doc.org/core-2.0/File.html) classes |
| [mruby-mock](https://github.com/iij/mruby-mock) | mock framework to support method stub |
| [mruby-mtest](https://github.com/iij/mruby-mtest) | unittesting framework like MiniTest |
| [mruby-pack](https://github.com/iij/mruby-pack) | [Array#pack](http://www.ruby-doc.org/core-2.0/Array.html#pack) and [String#unpack](http://www.ruby-doc.org/core-2.0/String.html#unpack)
| [mruby-process](https://github.com/iij/mruby-process) | [Process](http://www.ruby-doc.org/core-2.0/Process.html) module |
| [mruby-regexp-pcre](https://github.com/iij/mruby-regexp-pcre) | [Regexp](http://www.ruby-doc.org/core-2.0/Regexp.html) and [MatchData](http://www.ruby-doc.org/core-2.0/Regexp.html) classes utilizing [PCRE](http://www.pcre.org/) library |
| [mruby-require](https://github.com/iij/mruby-require) | [Kernel#require](http://www.ruby-doc.org/core-2.0/Kernel.html#method-i-require) |
| [mruby-simple-random](https://github.com/iij/mruby-simple-random) | smaller alternative of mruby-random |
| [mruby-socket](https://github.com/iij/mruby-socket) | BSD socket API classes including [Socket](http://www.ruby-doc.org/stdlib-2.0/libdoc/socket/rdoc/Socket.html) |
| [mruby-syslog](https://github.com/iij/mruby-syslog) | [Syslog](http://www.ruby-doc.org/stdlib-2.0/libdoc/syslog/rdoc/Syslog.html) class |
| [mruby-tempfile](https://github.com/iij/mruby-tempfile) | [Tempfile](http://www.ruby-doc.org/stdlib-2.0/libdoc/tempfile/rdoc/Tempfile.html) class |


## Branch Policy

 * master : tracking upstream (mruby/mruby), synchronized every morning.
 * iij : main development branch
 * s1 : stable branch (#1)
 * (else) : for pull-request, etc.

## Continuous Integration

We run automated tests per commit on a variety of platforms including CentOS6/i386, FreeBSD/amd64, NetBSD/arm, etc.
Test reports are available on http://m.ruby.iijgio.com/ .
If you want to run the tests on your platform, try the following commands:

      $ rake test
      $ ./test/posix/all.sh

## License

This software is licensed under the same license terms of the original mruby.
