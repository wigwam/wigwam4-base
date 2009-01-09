SUBDIRS = wigwam-env-api-tests

configorderdir=@prefix@/etc/config-order

generatedconfigorderdata =

nongeneratedconfigorderdata =			\
  	001-wigwam-base-profile			\
  	100-project.conf.pre			\
  	350-project.defaults			\
  	400-project.conf

configorder_DATA =				\
  	$(generatedconfigorderdata)		\
  	$(nongeneratedconfigorderdata)

profiledir=@prefix@/etc/profile

generatedprofiledata = 				\
  	wigwam-base.profile

nongeneratedprofiledata =

profile_DATA = 					\
  	$(generatedprofiledata)			\
	$(nongeneratedprofiledata)

environmentdir=@prefix@/libexec/environment

nongeneratedenvironmentscripts =		\
	load-environment			\
	print-interactive-environment		\
	print-runtime-environment		\
	print-unsetup-environment		\
	print-setup-environment	

generatedenvironmentscripts = 			\
  	ww-env-diffs

environment_SCRIPTS = 				\
  	$(generatedenvironmentscripts)		\
	$(nongeneratedenvironmentscripts)

environment_DATA =				\
	functions

nongeneratedbinscripts = 

generatedbinscripts = 

bin_SCRIPTS = 				\
  	$(generatedbinscripts)		\
	$(nongeneratedbinscripts)

.%.syntax: %
	ash -n $*
	touch .$*.syntax

.%.pl.syntax: %
	PERL5LIB=".:${PERL5LIB}" perl -cw $*
	touch .$*.pl.syntax

if CHECK_SYNTAX
noinst_DATA = 								\
  	$(patsubst %, .%.syntax, $(nongeneratedenvironmentscripts))	\
  	.ww-env-diffs.pl.syntax						\
	.functions.syntax
endif

EXTRA_DIST =								\
		$(patsubst %, %.in, $(generatedbinscripts))		\
		$(patsubst %, %.in, $(generatedconfigorderdata))	\
		$(patsubst %, %.in, $(generatedenvironmentscripts))	\
		$(patsubst %, %.in, $(generatedprofiledata))		\
		$(nongeneratedbinscripts)				\
		$(nongeneratedconfigorderdata)				\
		$(nongeneratedenvironmentscripts)			\
		$(nongeneratedprofiledata)				\
		$(environment_DATA)

CLEANFILES = 					\
	$(wildcard .*.syntax) 			\
	$(generatedbinscripts)			\
	$(generatedconfigorderdata)		\
	$(generatedenvironmentscripts)		\
	$(generatedprofiledata)

install-data-hook:
	rm -f "$(DESTDIR)$(prefix)/bin/make-setup-env"
	ln -sf "$(environmentdir)/print-setup-environment" 	\
	       "$(DESTDIR)$(prefix)/bin/make-setup-env"
