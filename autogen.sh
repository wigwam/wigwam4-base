#! /bin/sh

if test -r ext/.wigwam-bootstrap
  then
    . ./setup-env
    packagectl update-packages || exit 1
  else
    # see README in packages/ for comments regarding autogen.sh voodoo

    echo 'ccache' > packages/wigwam-base/dep.local
    echo 'ccache-compiler' >> packages/wigwam-base/dep.local

    cp -f packages/wigwam-base-local/provides                           \
          packages/wigwam-base-local/provides.local
    echo 'wigwam-base' >> packages/wigwam-base-local/provides.local
    echo 'automake 1.7.9-1' > packages/wigwam-base-local/dep.local
    echo 'ccache' >> packages/wigwam-base-local/dep.local
    echo 'ccache-compiler' >> packages/wigwam-base-local/dep.local
    echo '
#! /bin/sh
cd "$EXT_PKGBUILDDIR" || exit 1

set -x

aclocal || exit 1
automake --copy -a || exit 1
autoconf || exit 1
' > packages/wigwam-base-local/pre-build.local
    chmod +x packages/wigwam-base-local/pre-build.local

    # prevent wierd errors arising from changing wigwam-bootstrap
    # from underneath itself while it's being interpreted 
    # in case of wigwam-base upgrade

    cp -f bin/wigwam-bootstrap bin/wigwam-bootstrap.tmp

       ./bin/wigwam-bootstrap.tmp --from-cvs                    \
    ||                                                          \
      {
        rm -f bin/wigwam-bootstrap.tmp
        exit 1
      }

    rm -f bin/wigwam-bootstrap.tmp
  fi
# DO NOT EDIT BELOW THIS LINE
# WIGWAM_VERSION: 4.0-1
# SIGNATURE: 3b88c45bd02e1e88c2fdcda93c407b57
