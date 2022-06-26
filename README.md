# John Haman's `.emacs`

This is not my actual Emacs. I made some alterations to remove private data. As a result this repo is basically frozen because I don't use it. I wanted a version to share.

## Features

- Supports R, Stan, Python, Lisp (Racket, Emacs Lisp, Common Lisp, ....), Rmarkdown, and probably some other languages I don't use.
- Supports Rmarkdown/md/TeX/Sweave/Org writing with spellchecking, grammar checking, predictive typing, and passive voice recognition.
- Google a line of text from Emacs without switching to browser (`google-this`)
- Minimal Spacemacs emulation (press <kbd>SPC</kbd> to see all key bindings)
- Local leader key is <kbd>,</kbd>
- Automatic code formatting (using electric operator and aggressive indentation)
- Various functions that improve Sly (for Common Lisp), Polymode (for Rmarkdown), and other modes
- Code completion using Company or Corfu
- Lightly modified Vim bindings
- Git integration with Magit and Forge
- A collection of templates for R and Rmd.
- Very fast startup time: I borrow a host of start-up and runtime optimizations from Doom Emacs. *The startup time is 1 sec on my 5 y/o laptop* (w/ Desktop mode disabled).
- Supports "narrowing" almost all textual inputs using Vertico/Consult.
- Configuration is well organized, but terribly documented.
- A few weird extras: A window manager (exwm), email reader (notmuch), and an RSS feed reader (elfeed).

## Dependencies

- Emacs 27.1+

## Good Stuff to have

- Git
- R
- SBCL
- Hunspell and hunspell_en_us
- Pandoc
- TexLive
- Ripgrep
- Find
- Bibtex / Biblatex
- Languagetool
- SDCV
- FiraGo font
- Fira Code or Mono font
