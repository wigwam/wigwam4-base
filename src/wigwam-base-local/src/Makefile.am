bin_PROGRAMS = 					\
	ww-md5					\
	ww-mkdir-p				\
	ww-test-empty				\
	ww-test-x

binnongenerated=				\
  	wigdo

bingenerated=					\
  	ww-dump-db				\
  	ww-propeller				\
	ww-rename

bin_SCRIPTS =					\
  	$(bingenerated)				\
  	$(binnongenerated)

ww_md5_SOURCES = ww-md5.c

ww_mkdir_p_SOURCES = ww-mkdir-p.c

ww_test_empty_SOURCES = ww-test-empty.c

ww_test_x_SOURCES = ww-test-x.c

noinst_SCRIPTS =				\
	test-ww-md5				\
	test-ww-mkdir-p				\
	test-ww-test-empty			\
	test-ww-test-x

TESTS =						\
	test-ww-md5				\
	test-ww-mkdir-p				\
	test-ww-test-empty			\
	test-ww-test-x

perldir=@prefix@/lib/perl5/Wigwam

perl_SCRIPTS = DB.pm

.%.pm.syntax: %.pm
	rm -f Wigwam
	ln -sf . Wigwam
	PERL5LIB=".:${PERL5LIB}" perl -cw $*.pm
	touch .$*.pm.syntax
	rm -f Wigwam

if CHECK_SYNTAX
noinst_DATA = .DB.pm.syntax
endif

EXTRA_DIST = 					\
  	DB.pm.in				\
  	ww-propeller.in				\
	ww-rename.in				\
	$(noinst_SCRIPTS)			\
	$(binnongenerated)

CLEANFILES = 					\
	$(bingenerated)
