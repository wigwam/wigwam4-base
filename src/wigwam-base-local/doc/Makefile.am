HTML_STYLE=../../../ext/share/sgml/docbook-dsssl/html/docbook-dsssl-1.78-2.ldp.dsl\#html
XML_DCL=../../../ext/share/sgml/docbook-dsssl/dtds/decls/xml.dcl

.%.html: $(wildcard *.xml)
	openjade -t xml -d "${HTML_STYLE}" "${XML_DCL}" $*.xml
	touch .$*.html

CLEANFILES = $(wildcard *.html) $(wildcard .*.html)
