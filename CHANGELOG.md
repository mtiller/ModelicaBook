This file collects the significant changes to the book since its initial public release.

### Version 0.3.5

#### Enhancements

  * Incorporated [a](https://github.com/xogeny/ModelicaBook/pull/196)
    [number](https://github.com/xogeny/ModelicaBook/pull/198)
    [of](https://github.com/xogeny/ModelicaBook/pull/199)
    [nice](https://github.com/xogeny/ModelicaBook/pull/200)
    [pull](https://github.com/xogeny/ModelicaBook/pull/201)
    [requests](https://github.com/xogeny/ModelicaBook/pull/202) from
    Thomas Beutlich (@tbeu) that improved the quality of the text,
    images and the models.

  * Added a note about non-linear and time-variant models to the
    discussions in the section on state space representations.  This,
    again, the result of a
    [discussion](https://github.com/xogeny/ModelicaBook/issues/135)
    with Thomas Beutlich @tbeu.

  * At @dietmarw's request, I added a few more examples to the
    discussion of array related functions.

#### Bug Fixes

  * Added missing figure in discussion on one-dimensional heat
    transfer using arrays.

### Version 0.3.4

#### Enhancements

  * Greatly improved structure for PDF.  This is all thanks to Dietmar Winkler
    (@dietmarw) who restructured many things to give the PDF version a more
	proper structure that includes parts, chapters and sections.

### Version 0.3.3

#### Enhancements

  * Made the first few plots in the discussion of state events NOT
    interactive.  This is because they are showing results of problematic
    simulations that don't run well in the browser.

  * Clarification of heater output plot in discussion of hysteresis.

  * Emphasized the use of equations over algorithms in discussion on
    hysteresis.

  * Added padding and the end of the HTML body so page doesn't end abruptly

  * Added discussion of the ``smooth`` operator (issue
    [#188](https://github.com/xogeny/ModelicaBook/pull/188))

#### Bug Fixes

  * Completed discussion of synchronous clock features in section on Sampling.

  * Completed table that discusses the relationship between events and
    various functions/operators (issue
    [#187](https://github.com/xogeny/ModelicaBook/pull/187))

  * Used a consistent heat transfer formulation throughout the book (issue
    [#150](https://github.com/xogeny/ModelicaBook/pull/150))

  * Added review of missing clock related functions
  
### Version 0.3.2

#### Enhancements

  * Improved discussion of initial conditions to mention the `fixed`
    attribute (issue
    [#133](https://github.com/xogeny/ModelicaBook/pull/133))

#### Bug Fixes

  * Added missing explanation of annotation structure
  * Added an explanation of `record` constructors (issue
    [#60](https://github.com/xogeny/ModelicaBook/pull/60), opened by
    @casella)
	
### Version 0.3.1

#### Enhancements

  * Improved visibility for search engines
  * Simplified README (issue [#151](https://github.com/xogeny/ModelicaBook/pull/151))
  * Improved highlighting (thanks to [@dietmarw](https://github.com/dietmarw) and the
    newest version of Pygments)

#### Bug Fixes

  * Fixed non-standard annotation (issue [#155](https://github.com/xogeny/ModelicaBook/pull/155))
  * Fixed sponsor links (issue [#160](https://github.com/xogeny/ModelicaBook/pull/160))

### Version 0.3.0

#### Enhancements

  * Moved the site to [book.xogeny.com](http://book.xogeny.com) with redirects
    from beta site.
  * Lots of cleanup of annotations by [@tbeu](https://github.com/tbeu) and
    [@dietmarw](https://github.com/dietmarw)
  * Switched back to using MathJax (looks nicer, but requires JS)
  * Updated the README to help orient people who want to contribute.
  * Incorporated a bunch of excellent fixes and improvements from
    @mrtiller related to
    [#42](https://github.com/xogeny/ModelicaBook/pull/42/files).

#### Bug Fixes

  * Merged a the following pull requests from [@tbeu](https://github.com/tbeu):
	[#143](https://github.com/xogeny/ModelicaBook/issues/143),
	[#142](https://github.com/xogeny/ModelicaBook/issues/142),
	[#141](https://github.com/xogeny/ModelicaBook/issues/141),
	[#139](https://github.com/xogeny/ModelicaBook/issues/139),
	[#137](https://github.com/xogeny/ModelicaBook/issues/137),
	[#117](https://github.com/xogeny/ModelicaBook/issues/117) and
	[#93](https://github.com/xogeny/ModelicaBook/issues/93)
  * Merged a change from [@tbeu](https://github.com/tbeu) regarding a heat
    transfer example in the discussion on packages.
  * Merged a bunch of changes from [@tbeu](https://github.com/tbeu) that improve
    the external function examples and clean up a few other things.
  * Fixed an error in the source code for the 1D heat conduction
    equation examples and fixed a recurring error (see issue
    [#53](https://github.com/xogeny/ModelicaBook/issues/53)) in the
    equations presented along with the source code.
  * Fixed issue
    [#61](https://github.com/xogeny/ModelicaBook/issues/61) which
    involved a misplaced annotation.
  * Fixed an error in one of the Lotka-Volterra equations raised
    in issue [#50](https://github.com/xogeny/ModelicaBook/issues/50).
  * Corrected the explanation on the `unit` attribute raised in
    [#59](https://github.com/xogeny/ModelicaBook/issues/59)


### Version 0.2.0

  * Early access release, first official public version.

