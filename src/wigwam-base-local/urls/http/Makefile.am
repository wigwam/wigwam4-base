httpdir=@prefix@/libexec/urls/http

generatedhttp =						\
  		uwget

nongeneratedhttp =					\
  		get

http_SCRIPTS = 						\
  		$(generatedhttp)			\
		$(nongeneratedhttp)

EXTRA_DIST = 						\
		$(patsubst %, %.in, $(generatedhttp))	\
		$(nongeneratedhttp)
