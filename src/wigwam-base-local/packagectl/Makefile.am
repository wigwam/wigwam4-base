SUBDIRS = BASE make

binnongenerated= 				\
		packagectl

bingenerated=

bin_SCRIPTS = 					\
  		$(bingenerated)			\
		$(binnongenerated)

packagectldir=@prefix@/libexec/packagectl

packagectl_DATA = 				\
		functions

packagectlnongenerated=

packagectlgenerated=				\
		compute_installed_files		\
		image				\
		invert_provides			\
		merge_conflicts                 \
		merge_dependencies              \
		merge_provides                  \
		merge_versions			\
		merge_types   			\
		plan				\
		ref_files			\
		show_conflicts			\
		show_dependencies		\
		show_provides			\
		show_versions			\
		show_types   			\
		sort_packages			\
		unref_files

packagectl_SCRIPTS = 				\
		$(packagectlgenerated)		\
		$(packagectlnongenerated)

perldir=@prefix@/lib/perl5/Packagectl

perl_SCRIPTS = Version.pm

.%.pm.syntax: %.pm
	rm -f Packagectl
	ln -sf . Packagectl
	rm -f Wigwam
	ln -sf ../src Wigwam
	PERL5LIB=".:${PERL5LIB}" perl -cw $*.pm
	touch .$*.pm.syntax
	rm -f Packagectl
	rm -f Wigwam

.%.pl.syntax: %
	rm -f Packagectl
	ln -sf . Packagectl
	rm -f Wigwam
	ln -sf ../src Wigwam
	PERL5LIB=".:${PERL5LIB}" perl -cw $*
	touch .$*.pl.syntax
	rm -f Packagectl
	rm -f Wigwam

.%.syntax: %
	ash -n $*
	touch .$*.syntax

if CHECK_SYNTAX
noinst_DATA = $(patsubst %, .%.syntax, ${perl_SCRIPTS})	\
              .functions.syntax				\
	      .packagectl.syntax			\
	      .compute_installed_files.pl.syntax	\
	      .image.pl.syntax				\
	      .invert_provides.pl.syntax		\
              .merge_conflicts.pl.syntax                \
              .merge_dependencies.pl.syntax             \
              .merge_provides.pl.syntax                 \
	      .merge_versions.pl.syntax			\
	      .merge_types.pl.syntax			\
	      .plan.pl.syntax				\
	      .ref_files.pl.syntax			\
	      .show_conflicts.pl.syntax			\
	      .show_dependencies.pl.syntax		\
	      .show_provides.pl.syntax			\
	      .show_versions.pl.syntax			\
	      .show_types.pl.syntax			\
	      .sort_packages.pl.syntax			\
	      .unref_files.pl.syntax
endif

TESTS = test-version

EXTRA_DIST = 							\
  		$(patsubst %, %.in, $(bingenerated))		\
  		$(patsubst %, %.in, $(libexecgenerated))	\
		$(packagectl_DATA)				\
		$(perl_SCRIPTS)					\
		$(packagectlnongenerated)			\
		$(binnongenerated)

CLEANFILES = 				\
		$(bingenerated)		\
		$(packagectlgenerated)	\
		$(wildcard .*.syntax)

# backwards compatibility

install-data-hook:
	rm -f "$(DESTDIR)$(prefix)/build"
	ln -sf "$(DESTDIR)$(prefix)/src" "$(DESTDIR)$(prefix)/build"
