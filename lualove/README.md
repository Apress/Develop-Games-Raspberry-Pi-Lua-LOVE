# Programming in Lua book

This contains the Docbook source for the book.

## Using these stylesheets

This has only been tested on Linux and BSD, but as long as you know Docbook, you should be able to use this with only modest changes to the GNUmakefile.
      
*Assuming you're using Linux or BSD, the required software is probably available from your software repository or ports tree.*

Requirements:

* [Docbook](http://docbook.org)
* [xmlto](https://pagure.io/xmlto)
* [xsltproc](http://xmlsoft.org/XSLT/index.html)
* [FOP 2](https://xmlgraphics.apache.org/fop/)
* [pdftk](https://www.pdflabs.com/tools/pdftk-the-pdf-toolkit/)
* [Image Magick](http://imagemagick.org/script/index.php)

### GNUmakefile

The GNUmakefile builds to HTML, plain text, PDF, and EPUB.

    $ make clean pdf
    
The output is placed into a directory called ``dist``.


## Bugs

Image paths are all over the place. You may have to adjust them.

