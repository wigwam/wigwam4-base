dnl WIGWAM_CHECK_SORT_ORDER
dnl
dnl figure out ascending/descending sort orders

AC_DEFUN(WIGWAM_CHECK_SORT_ORDER, [
  AC_CACHE_CHECK([descending sort order],
                 [wigwam_cv_sort_numbers_descending],
    [
      wigwam_cv_sort_numbers_descending=
      test_sort_rn=`(echo 19; echo 25)|sort -rn`
      test_sort_rn=`echo $test_sort_rn`
      if test "$test_sort_rn" = "25 19" ; then
        wigwam_cv_sort_numbers_descending="sort -rn"
      else
        wigwam_cv_sort_numbers_descending="sort -n"
      fi
    ])

  AC_CACHE_CHECK([ascending sort order],
                 [wigwam_cv_sort_numbers_ascending],
    [
      wigwam_cv_sort_numbers_ascending=
      test_sort_rn=`(echo 19; echo 25)|sort -rn`
      test_sort_rn=`echo $test_sort_rn`
      if test "$test_sort_rn" = "25 19" ; then
        wigwam_cv_sort_numbers_ascending="sort -n"
      else
        wigwam_cv_sort_numbers_ascending="sort -rn"
      fi
    ])
])

dnl WIGWAM_CHECK_DF_KP
dnl
dnl figure out df arguments

AC_DEFUN(WIGWAM_CHECK_DF_KP, [
  AC_CACHE_CHECK([for the official wigwam df output format],
                 [wigwam_cv_df_k_P],
    [
      wigwam_cv_df_k_P=
      for tmp_df_options in "-P -k" "-k" "-P" ; do
        for df_binary in df /usr/xpg4/bin/df ; do
          case "$df_binary" in
            /*)
              df_path="$df_binary"
              ;;
            *)
              df_path=`which "$df_binary"`
              ;;
          esac
          test -r "$df_path" || continue

          tmp_line0=`$df_path $tmp_df_options . 2> /dev/null | head -n 1`
          echo "$tmp_line0" | $FGREP -q 'Filesystem' || continue
        
          # Test whether the first line, which contains a description
          # of the fields to follow.  Try and verify that the block size is 1k.
          tmp_got_kilo=0
          # FreeBSD df cvs version 1.23, GNU fileutils 4.0.
          echo "$tmp_line0" | $EGREP -iq '1k.blocks' && tmp_got_kilo=1
          # GNU fileutils 4.0l.
          echo "$tmp_line0" | $FGREP -q '1024' && tmp_got_kilo=1
          test "$tmp_got_kilo" = 1 || continue
        
          # Good, a qualifying option.
          wigwam_cv_df_k_P="$df_path $tmp_df_options"
          break 2
        done
      done

      if test "x$wigwam_cv_df_k_P" = "x" ; then
        wigwam_cv_df_k_P="true"
      fi
    ])

  if test "x$wigwam_cv_df_k_P" = "xtrue" ; then
    AC_MSG_WARN([df -P -k appears broken.])
    AC_MSG_WARN([automatic diskspace checks are disabled.])
  fi
])




dnl WIGWAM_CHECK_GNU_MAKE(ACTION-IF-FOUND,ACTION-IF-NOT-FOUND)
dnl 
dnl find GNU compatible make on system.

AC_DEFUN(WIGWAM_CHECK_GNU_MAKE, [
  AC_CACHE_CHECK([for gnu make],
                 [wigwam_cv_gnu_make],
    [
      wigwam_cv_gnu_make=
      echo '
target:
	@echo $(subst ee,EE,feet)
' > wigwam-test.makefile
      for makeprog in $MAKE make gmake gnumake; do
        feet=`$makeprog -f wigwam-test.makefile`
        test $? = 0 || continue
        test "x$feet" = "xfEEt" || continue
        wigwam_cv_gnu_make=$makeprog
        break
      done
      rm -f wigwam-test.makefile
    ])

  if test "x$wigwam_cv_gnu_make" = "x"; then
    true
    $2
  else
    true
    $1
  fi
])

dnl WIGWAM_CHECK_SANE_SHELL(ACTION-IF-FOUND,ACTION-IF-NOT-FOUND)
dnl
dnl Find shell supporting functions, unset, and arithmetic evaluation

AC_DEFUN(WIGWAM_CHECK_SANE_SHELL, [
  AC_CACHE_CHECK([for sane /bin/sh],
                 [wigwam_cv_sane_bin_sh],
    [
      wigwam_cv_sane_bin_sh=no
      echo "#! /bin/sh" > wigwam-test.sh
      cat shell-test >> wigwam-test.sh
      echo 'exit $?' >> wigwam-test.sh
      chmod +x ./wigwam-test.sh
      ./wigwam-test.sh 2>/dev/null
      rv=$?
      rm -f wigwam-test.sh
      if test $rv = 0; then
        wigwam_cv_sane_bin_sh=yes
      fi
    ])

  if test "x$wigwam_cv_sane_bin_sh" = "xno"; then
    true 
    $2
  else
    true
    $1
  fi
])

AC_DEFUN(WIGWAM_CHECK_SHELL_ARITHMETIC, [
  AC_CACHE_CHECK([if /bin/sh supports arithmetic],
                 [wigwam_cv_bin_sh_arith],
    [
      wigwam_cv_bin_sh_arith=no
      sh -c 'x=1 ; x=$(($x+1)) ; test "x$x" = "x2" ; exit $?' >/dev/null 2>&1
      if test $? = 0; then
        wigwam_cv_bin_sh_arith=yes
      fi
    ])

  if test "x$wigwam_cv_bin_sh_arith" = "xno"; then
    true 
    $2
  else
    true
    $1
  fi
])

dnl WIGWAM_CHECK_INT_SIZES()
dnl look for various sized ints

AC_DEFUN(WIGWAM_CHECK_INT_SIZES, [
  AC_CHECK_SIZEOF(char)
  AC_CHECK_SIZEOF(short)
  AC_CHECK_SIZEOF(int)
  AC_CHECK_SIZEOF(long)
  AC_CHECK_SIZEOF(long long)

  if test "x$ac_cv_sizeof_char" != "x1"; then
    AC_MSG_ERROR([extremely unexpected C compiler detected: sizeof (char) != 1])
    exit 1
  fi

  wint8="char"
  wuint8="unsigned char"

  case 2 in
  $ac_cv_sizeof_short)            wint16="short" ;;
  $ac_cv_sizeof_int)              wint16="int"   ;;
  esac

  case 4 in
  $ac_cv_sizeof_short)            wint32="short" ;;
  $ac_cv_sizeof_int)              wint32="int" ;;
  $ac_cv_sizeof_long)             wint32="long" ;;
  esac

  case 8 in 
  $ac_cv_sizeof_short)            wint64="short" ;;
  $ac_cv_sizeof_int)              wint64="int" ;;
  $ac_cv_sizeof_long)             wint64="long" ;;
  $ac_cv_sizeof_long_long)        wint64="long long" ;;
  esac

  AC_DEFINE_UNQUOTED(wint8, char, 8 bit integer type)
  AC_DEFINE_UNQUOTED(wuint8, unsigned char, 8 bit unsigned integer type)
  AC_DEFINE_UNQUOTED(wint16, $wint16, 16 bit integer type)
  AC_DEFINE_UNQUOTED(wuint16, unsigned $wint16, 16 bit unsigned integer type)
  AC_DEFINE_UNQUOTED(wint32, $wint32, 32 bit integer type)
  AC_DEFINE_UNQUOTED(wuint32, unsigned $wint32, 32 bit unsigned integer type)

  if test "x$wint64" != "x"; then
    AC_DEFINE_UNQUOTED(wint64, $wint64, 64 bit integer type)
    AC_DEFINE_UNQUOTED(wuint64, unsigned $wint64, 64 bit unsigned integer type)
  fi
])

dnl PERL_CHECK_NATIVE_MODULE()
dnl look for perl native modules, i.e., those that work with empty PERL5LIB

AC_DEFUN(PERL_CHECK_NATIVE_MODULE, [
  nice=`perl -e '$_ = shift; s/\W/_/g; print' -- "$1"`

  AC_CACHE_CHECK([for perl module $1],
                 [wigwam_cv_perl_module_$nice],
    [
      eval wigwam_cv_perl_module_$nice=no
      PERL5LIB="" perl "-M$1" -e 'exit 0' 2>/dev/null
      if test $? = 0
        then
          eval wigwam_cv_perl_module_$nice=yes
        fi
    ])

  if eval test "x\${wigwam_cv_perl_module_$nice}" = "xno"; then
    true 
    $3
  else
    true
    $2
  fi
])

dnl WIGWAM_CHECK_DATABASE_DRIVER()
dnl look for a suitable database driver
dnl the perl builtin, SDBM, has a key size limit of 1088 bytes
dnl which is not suitable for our purposes

AC_DEFUN(WIGWAM_CHECK_DATABASE_DRIVER, [
  AC_CACHE_VAL([wigwam_cv_database_driver],
    [
      PERL_CHECK_NATIVE_MODULE(BerkeleyDB, wigwam_cv_database_driver=BerkeleyDB,
        PERL_CHECK_NATIVE_MODULE(GDBM_File, wigwam_cv_database_driver=GDBM_File,
          wigwam_cv_database_driver=Wigwam::DB::Dumb))
    ])

  if test "x$wigwam_cv_database_driver" = "xWigwam::DB::Dumb"; then
    true
    $2
  else
    true
    $1
  fi
])
