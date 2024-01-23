Table of Contents
-----------------

  * [NAME](#name)

  * [AUTHOR](#author)

  * [VERSION](#version)

  * [TITLE](#title)

  * [SUBTITLE](#subtitle)

  * [COPYRIGHT](#copyright)

  * [Introduction](#introduction)

  * [class Gzz_readline](#class-gzz_readline) or [on raku.land class Gzz_readline](#class-gzz-readline)

NAME
====

Gzz::Prompt 

AUTHOR
======

Francis Grizzly Smit (grizzly@smit.id.au)

VERSION
=======

0.1.2

TITLE
=====

Gzz::Prompt

SUBTITLE
========

A Raku module to do basic prompting with editing and like readline but with the ability to prefill the value.

COPYRIGHT
=========

LGPL V3.0+ [LICENSE](https://github.com/grizzlysmit/Syntax-Highlighters/blob/main/LICENSE)

[Top of Document](#table-of-contents)

Introduction
============

A Raku module to do basic prompting with editing and like readline but with the ability to prefill the value.

**NB: I use the NativeCall module to get at a C library `gzz_readline.so` which is a fork of the `readline` library, I had to fork it as it doesn't normally allow you to prefill the value** [See gzzReadline](https://github.com/grizzlysmit/gzzReadline).

[NOTE: you must install gzzReadline to use this](https://github.com/grizzlysmit/gzzReadline)

class Gzz_readline
------------------

```raku
class Gzz_readline is export
```

[Top of Document](#table-of-contents)

