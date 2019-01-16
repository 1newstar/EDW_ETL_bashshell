# win
 perl -e "print \"Hello world\n\""

 -C [number/list]
The -C flag controls some of the Perl Unicode features.
As of 5.8.1, the -C can be followed either by a number or a list of option letters. The letters, their numeric values, and effects are as follows; listing the letters is equal to summing the numbers.
    I     1   STDIN is assumed to be in UTF-8
    O     2   STDOUT will be in UTF-8
    E     4   STDERR will be in UTF-8
    S     7   I + O + E
    i     8   UTF-8 is the default PerlIO layer for input streams
    o    16   UTF-8 is the default PerlIO layer for output streams
    D    24   i + o
    A    32   the @ARGV elements are expected to be strings encoded
              in UTF-8
    L    64   normally the "IOEioA" are unconditional, the L makes
              them conditional on the locale environment variables
              (the LC_ALL, LC_CTYPE, and LANG, in the order of
              decreasing precedence) -- if the variables indicate
              UTF-8, then the selected "IOEioA" are in effect
    a   256   Set ${^UTF8CACHE} to -1, to run the UTF-8 caching
              code in debugging mode.
For example, -COE and -C6 will both turn on UTF-8-ness on both STDOUT and STDERR. Repeating letters is just redundant, not cumulative nor toggling.


-e commandline
may be used to enter one line of program. If -e is given, Perl will not look for a filename in the argument list. Multiple -e commands may be given to build up a multi-line script. Make sure to use semicolons where you would in a normal program.
-E commandline
behaves just like -e, except that it implicitly enables all optional features (in the main compilation unit). See feature.

