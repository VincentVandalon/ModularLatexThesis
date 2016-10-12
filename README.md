# ModularLatexThesis
This projects entails a structure to compile complex LaTeX documents consisting of:

1. Several self-supporting sub-documents
2. A master file consisting of these self-supporting documents.

such that it is possible to:

* Compile just 1 of the sub-documents
* Compile all of the sub-documents
* Compile the master document

with the least amount of manual effort. This project started since I needed an 
efficient way to compile my PhD thesis, while makelatex did not seem to offer the freedom I needed.

Note that this supports parallel compilation for the sub-documents, so run make -j all to
save a lot of time!
