bootstrapgenerated=		\
	bootstrap-functions 	\
	bootstrap-head

bootstrapnongenerated=		\
	bootstrap-args 		\
	bootstrap-checks	\
	bootstrap-tail

wigwam-bootstrap.actual: $(bootstrapgenerated) $(bootstrapnongenerated) setup-env unsetup-env autogen.sh
	cd .. && $(MAKE) dist
	cat bootstrap-head >$@
	cat bootstrap-checks >>$@
	cat bootstrap-functions >>$@
	echo >>$@
	echo 'spew_wigwam_base()' >>$@
	echo '{' >>$@
	echo "( perl -pe 's/^#//' | perl -e 'undef $$/; print unpack (\"u\", <>)'; ) <<'XYZZY_WIGWAM_BASE_XYZZY'" >>$@
	cat ../wigwam-base-@VERSION@.tar.gz			\
		| perl -e 'undef $$/; print pack ("u", <>)' 	\
		| perl -pe 's/^/#/;' >> $@
	echo 'XYZZY_WIGWAM_BASE_XYZZY' >>$@
	echo '}' >>$@
	echo >>$@
	echo 'spew_autogen_sh()' >>$@
	echo '{' >>$@
	echo "perl -pe 's/^#//' <<'XYZZY_SETUP_ENV_XYZZY'" >>$@
	cat autogen.sh | perl -pe 's/^/#/;' >> $@
	echo 'XYZZY_SETUP_ENV_XYZZY' >>$@
	echo '}' >>$@
	echo 'spew_setup_env()' >>$@
	echo '{' >>$@
	echo "perl -pe 's/^#//' <<'XYZZY_SETUP_ENV_XYZZY'" >>$@
	cat setup-env | perl -pe 's/^/#/;' >> $@
	echo 'XYZZY_SETUP_ENV_XYZZY' >>$@
	echo '}' >>$@
	echo 'spew_unsetup_env()' >>$@
	echo '{' >>$@
	echo "perl -pe 's/^#//' <<'XYZZY_SETUP_ENV_XYZZY'" >>$@
	cat unsetup-env | perl -pe 's/^/#/;' >> $@
	echo 'XYZZY_SETUP_ENV_XYZZY' >>$@
	echo '}' >>$@
	cat bootstrap-args >>$@
	cat bootstrap-tail >>$@
	chmod 755 $@

%: %.actual
	( cat $*.actual ;				\
	  echo "# DO NOT EDIT BELOW THIS LINE";		\
	  echo "# WIGWAM_VERSION: @VERSION@-1" ;	\
	  printf "# SIGNATURE: " ;			\
	  ../src/ww-md5 $*.actual ; 			\
	) > $@
	-test -x $*.actual && chmod +x $*

if BUILD_BOOTSTRAP
noinst_SCRIPTS = wigwam-bootstrap setup-env unsetup-env autogen.sh
else
noinst_SCRIPTS = setup-env unsetup-env autogen.sh
endif

CLEANFILES=			\
	wigwam-bootstrap.actual	\
	wigwam-bootstrap	\
	setup-env		\
	unsetup-env		\
	$(bootstrapgenerated)

EXTRA_DIST=						\
	$(patsubst %, %.in, $(bootstrapgenerated))	\
	autogen.sh.actual				\
	setup-env.actual				\
	unsetup-env.actual				\
	$(bootstrapnongenerated)
