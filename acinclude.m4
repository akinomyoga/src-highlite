dnl @synopsis AC_CTAGS_FLAGS
dnl
dnl check whether it's the correct version of ctags

AC_DEFUN([AC_CTAGS_FLAGS],
[AC_CACHE_CHECK(whether ${CTAGS} accept --excmd, ac_cv_ctags_flags,
[echo 'void f(){}' > conftest.c
if test -z "`${CTAGS} --excmd=n -f conftags conftest.c 2>&1`"; then
  ac_cv_ctags_flags=yes
else
  ac_cv_ctags_flags=no
fi
rm -f conftest*
rm -f conftags*
])])

dnl @synopsis AC_COMPILE_WARNINGS
dnl
dnl Set the maximum warning verbosity according to compiler used.
dnl Currently supports g++ and gcc.
dnl This macro must be put after AC_PROG_CC and AC_PROG_CXX in
dnl configure.in
dnl
dnl @author Loic Dachary <loic@senga.org>
dnl
AC_DEFUN([AC_COMPILE_WARNINGS],
[AC_MSG_CHECKING(maximum warning verbosity option)
if test -n "$CXX"
then
  if test "$GXX" = "yes"
  then
    ac_compile_warnings_opt='-Wall'
  fi
  CXXFLAGS="$CXXFLAGS $ac_compile_warnings_opt"
  ac_compile_warnings_msg="$ac_compile_warnings_opt for C++"
fi

if test -n "$CC"
then
  if test "$GCC" = "yes"
  then
    ac_compile_warnings_opt='-Wall'
  fi
  CFLAGS="$CFLAGS $ac_compile_warnings_opt"
  ac_compile_warnings_msg="$ac_compile_warnings_msg $ac_compile_warnings_opt for C"
fi
AC_MSG_RESULT($ac_compile_warnings_msg)
unset ac_compile_warnings_msg
unset ac_compile_warnings_opt
])

dnl Copyright (C) 2001 Lorenzo Bettini <http://www.lorenzobettini.it>
dnl  
dnl This program is free software; you can redistribute it and/or modify
dnl it under the terms of the GNU General Public License as published by
dnl the Free Software Foundation; either version 2 of the License, or
dnl (at your option) any later version.

dnl @synopsis AC_NONGNU_FLAGS
dnl
dnl check if the non-GNU C compiler accepts -Aa (HP-UX)

AC_DEFUN([AC_NONGNU_FLAGS],
[
  if test -z "$GCC"; then
    AC_CC_AA_FLAG
    if test $ac_cv_cc_aa_flag = yes; then
      CFLAGS="$CFLAGS -Aa"
    fi
  fi
])

dnl @synopsis AC_CC_AA_FLAG
dnl
dnl check if the C compiler accepts -Aa (HP-UX)

AC_DEFUN([AC_CC_AA_FLAG],
[AC_CACHE_CHECK(whether ${CC-cc} accepts -Aa, ac_cv_cc_aa_flag,
[echo 'void f(){}' > conftest.c
if test -z "`${CC-cc} -Aa -c conftest.c 2>&1`"; then
  ac_cv_cc_aa_flag=yes
else
  ac_cv_cc_aa_flag=no
fi
rm -f conftest*
])])

dnl @synopsis AC_CXX_NAMESPACES
dnl
dnl If the compiler can prevent names clashes using namespaces, define
dnl HAVE_NAMESPACES.
dnl
dnl @author Luc Maisonobe
dnl
AC_DEFUN([AC_CXX_NAMESPACES],
[AC_CACHE_CHECK(whether the compiler implements namespaces,
ac_cv_cxx_namespaces,
[AC_LANG_SAVE
 AC_LANG_CPLUSPLUS
 AC_TRY_COMPILE([namespace Outer { namespace Inner { int i = 0; }}],
                [using namespace Outer::Inner; return i;],
 ac_cv_cxx_namespaces=yes, ac_cv_cxx_namespaces=no)
 AC_LANG_RESTORE
])
if test "$ac_cv_cxx_namespaces" = yes; then
  AC_DEFINE(HAVE_NAMESPACES,,[define if the compiler implements namespaces])
fi
])


dnl @synopsis AC_CXX_HAVE_STL
dnl
dnl If the compiler supports the Standard Template Library, define HAVE_STL.
dnl
dnl @author Luc Maisonobe
dnl
AC_DEFUN([AC_CXX_HAVE_STL],
[AC_CACHE_CHECK(whether the compiler supports Standard Template Library,
ac_cv_cxx_have_stl,
[AC_REQUIRE([AC_CXX_NAMESPACES])
 AC_LANG_SAVE
 AC_LANG_CPLUSPLUS
 AC_TRY_COMPILE([#include <list>
#include <deque>
#ifdef HAVE_NAMESPACES
using namespace std;
#endif],[list<int> x; x.push_back(5);
list<int>::iterator iter = x.begin(); if (iter != x.end()) ++iter; return 0;],
 ac_cv_cxx_have_stl=yes, ac_cv_cxx_have_stl=no)
 AC_LANG_RESTORE
])
if test "$ac_cv_cxx_have_stl" = yes; then
  AC_DEFINE(HAVE_STL,,[define if the compiler supports Standard Template Library])
fi
])

dnl @synopsis AC_CXX_HAVE_SSTREAM
dnl
dnl If the C++ library has a working stringstream, define HAVE_SSTREAM.
dnl
dnl @author Ben Stanley
dnl
AC_DEFUN([AC_CXX_HAVE_SSTREAM],
[AC_CACHE_CHECK(whether the compiler has stringstream,
ac_cv_cxx_have_sstream,
[AC_REQUIRE([AC_CXX_NAMESPACES])
 AC_LANG_SAVE
 AC_LANG_CPLUSPLUS
 AC_TRY_COMPILE([#include <sstream>
#ifdef HAVE_NAMESPACES
using namespace std;
#endif],[stringstream message; message << "Hello"; return 0;],
 ac_cv_cxx_have_sstream=yes, ac_cv_cxx_have_sstream=no)
 AC_LANG_RESTORE
])
if test "$ac_cv_cxx_have_sstream" = yes; then
  AC_DEFINE(HAVE_SSTREAM,,[define if the compiler has stringstream])
fi
])


dnl Check whether ios_base is defined, otherwise use ios
dnl Author, Lorenzo Bettini, http://www.lorenzobettini.it
AC_DEFUN([AC_CXX_HAVE_IOS_BASE],
[AC_CACHE_CHECK(whether the compiler has ios_base,
ac_cv_cxx_have_ios_base,
[AC_REQUIRE([AC_CXX_NAMESPACES])
 AC_LANG_SAVE
 AC_LANG_CPLUSPLUS
 AC_TRY_COMPILE([#include <fstream>
#ifdef HAVE_NAMESPACES
using namespace std;
#endif],[ifstream file ("foo", ios_base::binary); return 0;],
 ac_cv_cxx_have_ios_base=yes, ac_cv_cxx_have_ios_base=no)
 AC_LANG_RESTORE
])
if test "$ac_cv_cxx_have_sstream" = no; then
  AC_DEFINE_UNQUOTED(ios_base,ios,[Define to ios if the compiler does not provide ios_base])
fi
])

dnl @synopsis adl_NORMALIZE_PATH(VARNAME, [REFERENCE_STRING])
dnl
dnl Perform some cleanups on the value of $VARNAME (interpreted as a
dnl path):
dnl
dnl   - empty paths are changed to '.'
dnl   - trailing slashes are removed
dnl   - repeated slashes are squeezed except a leading doubled slash '//'
dnl     (which might indicate a networked disk on some OS).
dnl
dnl REFERENCE_STRING is used to turn '/' into '\' and vice-versa: if
dnl REFERENCE_STRING contains some backslashes, all slashes and
dnl backslashes are turned into backslashes, otherwise they are all
dnl turned into slashes.
dnl
dnl This makes processing of DOS filenames quite easier, because you
dnl can turn a filename to the Unix notation, make your processing, and
dnl turn it back to original notation.
dnl
dnl   filename='A:\FOO\\BAR\'
dnl   old_filename="$filename"
dnl   # Switch to the unix notation
dnl   adl_NORMALIZE_PATH([filename], ["/"])
dnl   # now we have $filename = 'A:/FOO/BAR' and we can process it as if
dnl   # it was a Unix path.  For instance let's say that you want
dnl   # to append '/subpath':
dnl   filename="$filename/subpath"
dnl   # finally switch back to the original notation
dnl   adl_NORMALIZE_PATH([filename], ["$old_filename"])
dnl   # now $filename equals to 'A:\FOO\BAR\subpath'
dnl
dnl One good reason to make all path processing with the unix
dnl convention is that backslashes have a special meaning in many
dnl cases. For instance
dnl
dnl   expr 'A:\FOO' : 'A:\Foo'
dnl
dnl will return 0 because the second argument is a regex in which
dnl backslashes have to be backslashed. In other words, to have the two
dnl strings to match you should write this instead:
dnl
dnl   expr 'A:\Foo' : 'A:\\Foo'
dnl
dnl Such behavior makes DOS filenames extremely unpleasant to work
dnl with. So temporary turn your paths to the Unix notation, and revert
dnl them to the original notation after the processing. See the macro
dnl adl_COMPUTE_RELATIVE_PATHS for a concrete example of this.
dnl
dnl REFERENCE_STRING defaults to $VARIABLE, this means that slashes
dnl will be converted to backslashes if $VARIABLE already contains some
dnl backslashes (see $thirddir below).
dnl
dnl   firstdir='/usr/local//share'
dnl   seconddir='C:\Program Files\\'
dnl   thirddir='C:\home/usr/'
dnl   adl_NORMALIZE_PATH([firstdir])
dnl   adl_NORMALIZE_PATH([seconddir])
dnl   adl_NORMALIZE_PATH([thirddir])
dnl   # $firstdir = '/usr/local/share'
dnl   # $seconddir = 'C:\Program Files'
dnl   # $thirddir = 'C:\home\usr'
dnl
dnl @category Misc
dnl @author Alexandre Duret-Lutz <duret_g@epita.fr>
dnl @version 2001-05-25
dnl @license GPLWithACException

AC_DEFUN([adl_NORMALIZE_PATH],
[case ":[$]$1:" in
# change empty paths to '.'
  ::) $1='.' ;;
# strip trailing slashes
  :*[[\\/]]:) $1=`echo "[$]$1" | sed 's,[[\\/]]*[$],,'` ;;
  :*:) ;;
esac
# squeze repeated slashes
case ifelse($2,,"[$]$1",$2) in
# if the path contains any backslashes, turn slashes into backslashes
 *\\*) $1=`echo "[$]$1" | sed 's,\(.\)[[\\/]][[\\/]]*,\1\\\\,g'` ;;
# if the path contains slashes, also turn backslashes into slashes
 *) $1=`echo "[$]$1" | sed 's,\(.\)[[\\/]][[\\/]]*,\1/,g'` ;;
esac])

dnl @synopsis adl_COMPUTE_RELATIVE_PATHS(PATH_LIST)
dnl
dnl PATH_LIST is a space-separated list of colon-separated triplets of
dnl the form 'FROM:TO:RESULT'. This function iterates over these
dnl triplets and set $RESULT to the relative path from $FROM to $TO.
dnl Note that $FROM and $TO needs to be absolute filenames for this
dnl macro to success.
dnl
dnl For instance,
dnl
dnl    first=/usr/local/bin
dnl    second=/usr/local/share
dnl    adl_COMPUTE_RELATIVE_PATHS([first:second:fs second:first:sf])
dnl    # $fs is set to ../share
dnl    # $sf is set to ../bin
dnl
dnl $FROM and $TO are both eval'ed recursively and normalized, this
dnl means that you can call this macro with autoconf's dirnames like
dnl `prefix' or `datadir'. For example:
dnl
dnl    adl_COMPUTE_RELATIVE_PATHS([bindir:datadir:bin_to_data])
dnl
dnl adl_COMPUTE_RELATIVE_PATHS should also works with DOS filenames.
dnl
dnl You may want to use this macro in order to make your package
dnl relocatable. Instead of hardcoding $datadir into your programs just
dnl encode $bin_to_data and try to determine $bindir at run-time.
dnl
dnl This macro requires adl_NORMALIZE_PATH.
dnl
dnl @category Misc
dnl @author Alexandre Duret-Lutz <duret_g@epita.fr>
dnl @version 2001-05-25
dnl @license GPLWithACException

AC_DEFUN([adl_COMPUTE_RELATIVE_PATHS],
[for _lcl_i in $1; do
  _lcl_from=\[$]`echo "[$]_lcl_i" | sed 's,:.*$,,'`
  _lcl_to=\[$]`echo "[$]_lcl_i" | sed 's,^[[^:]]*:,,' | sed 's,:[[^:]]*$,,'`
  _lcl_result_var=`echo "[$]_lcl_i" | sed 's,^.*:,,'`
  adl_RECURSIVE_EVAL([[$]_lcl_from], [_lcl_from])
  adl_RECURSIVE_EVAL([[$]_lcl_to], [_lcl_to])
  _lcl_notation="$_lcl_from$_lcl_to"
  adl_NORMALIZE_PATH([_lcl_from],['/'])
  adl_NORMALIZE_PATH([_lcl_to],['/'])
  adl_COMPUTE_RELATIVE_PATH([_lcl_from], [_lcl_to], [_lcl_result_tmp])
  adl_NORMALIZE_PATH([_lcl_result_tmp],["[$]_lcl_notation"])
  eval $_lcl_result_var='[$]_lcl_result_tmp'
done])

## Note:
## *****
## The following helper macros are too fragile to be used out
## of adl_COMPUTE_RELATIVE_PATHS (mainly because they assume that
## paths are normalized), that's why I'm keeping them in the same file.
## Still, some of them maybe worth to reuse.

dnl adl_COMPUTE_RELATIVE_PATH(FROM, TO, RESULT)
dnl ===========================================
dnl Compute the relative path to go from $FROM to $TO and set the value
dnl of $RESULT to that value.  This function work on raw filenames
dnl (for instead it will considerate /usr//local and /usr/local as
dnl two distinct paths), you should really use adl_COMPUTE_REALTIVE_PATHS
dnl instead to have the paths sanitized automatically.
dnl
dnl For instance:
dnl    first_dir=/somewhere/on/my/disk/bin
dnl    second_dir=/somewhere/on/another/disk/share
dnl    adl_COMPUTE_RELATIVE_PATH(first_dir, second_dir, first_to_second)
dnl will set $first_to_second to '../../../another/disk/share'.
AC_DEFUN([adl_COMPUTE_RELATIVE_PATH],
[adl_COMPUTE_COMMON_PATH([$1], [$2], [_lcl_common_prefix])
adl_COMPUTE_BACK_PATH([$1], [_lcl_common_prefix], [_lcl_first_rel])
adl_COMPUTE_SUFFIX_PATH([$2], [_lcl_common_prefix], [_lcl_second_suffix])
$3="[$]_lcl_first_rel[$]_lcl_second_suffix"])

dnl adl_COMPUTE_COMMON_PATH(LEFT, RIGHT, RESULT)
dnl ============================================
dnl Compute the common path to $LEFT and $RIGHT and set the result to $RESULT.
dnl
dnl For instance:
dnl    first_path=/somewhere/on/my/disk/bin
dnl    second_path=/somewhere/on/another/disk/share
dnl    adl_COMPUTE_COMMON_PATH(first_path, second_path, common_path)
dnl will set $common_path to '/somewhere/on'.
AC_DEFUN([adl_COMPUTE_COMMON_PATH],
[$3=''
_lcl_second_prefix_match=''
while test "[$]_lcl_second_prefix_match" != 0; do
  _lcl_first_prefix=`expr "x[$]$1" : "x\([$]$3/*[[^/]]*\)"`
  _lcl_second_prefix_match=`expr "x[$]$2" : "x[$]_lcl_first_prefix"`
  if test "[$]_lcl_second_prefix_match" != 0; then
    if test "[$]_lcl_first_prefix" != "[$]$3"; then
      $3="[$]_lcl_first_prefix"
    else
      _lcl_second_prefix_match=0
    fi
  fi
done])

dnl adl_COMPUTE_SUFFIX_PATH(PATH, SUBPATH, RESULT)
dnl ==============================================
dnl Substrack $SUBPATH from $PATH, and set the resulting suffix
dnl (or the empty string if $SUBPATH is not a subpath of $PATH)
dnl to $RESULT.
dnl
dnl For instace:
dnl    first_path=/somewhere/on/my/disk/bin
dnl    second_path=/somewhere/on
dnl    adl_COMPUTE_SUFFIX_PATH(first_path, second_path, common_path)
dnl will set $common_path to '/my/disk/bin'.
AC_DEFUN([adl_COMPUTE_SUFFIX_PATH],
[$3=`expr "x[$]$1" : "x[$]$2/*\(.*\)"`])

dnl adl_COMPUTE_BACK_PATH(PATH, SUBPATH, RESULT)
dnl ============================================
dnl Compute the relative path to go from $PATH to $SUBPATH, knowing that
dnl $SUBPATH is a subpath of $PATH (any other words, only repeated '../'
dnl should be needed to move from $PATH to $SUBPATH) and set the value
dnl of $RESULT to that value.  If $SUBPATH is not a subpath of PATH,
dnl set $RESULT to the empty string.
dnl
dnl For instance:
dnl    first_path=/somewhere/on/my/disk/bin
dnl    second_path=/somewhere/on
dnl    adl_COMPUTE_BACK_PATH(first_path, second_path, back_path)
dnl will set $back_path to '../../../'.
AC_DEFUN([adl_COMPUTE_BACK_PATH],
[adl_COMPUTE_SUFFIX_PATH([$1], [$2], [_lcl_first_suffix])
$3=''
_lcl_tmp='xxx'
while test "[$]_lcl_tmp" != ''; do
  _lcl_tmp=`expr "x[$]_lcl_first_suffix" : "x[[^/]]*/*\(.*\)"`
  if test "[$]_lcl_first_suffix" != ''; then
     _lcl_first_suffix="[$]_lcl_tmp"
     $3="../[$]$3"
  fi
done])


dnl adl_RECURSIVE_EVAL(VALUE, RESULT)
dnl =================================
dnl Interpolate the VALUE in loop until it doesn't change,
dnl and set the result to $RESULT.
dnl WARNING: It's easy to get an infinite loop with some unsane input.
AC_DEFUN([adl_RECURSIVE_EVAL],
[_lcl_receval="$1"
$2=`(test "x$prefix" = xNONE && prefix="$ac_default_prefix"
     test "x$exec_prefix" = xNONE && exec_prefix="${prefix}"
     _lcl_receval_old=''
     while test "[$]_lcl_receval_old" != "[$]_lcl_receval"; do
       _lcl_receval_old="[$]_lcl_receval"
       eval _lcl_receval="\"[$]_lcl_receval\""
     done
     echo "[$]_lcl_receval")`])

dnl @synopsis adl_COMPUTE_STANDARD_RELATIVE_PATHS
dnl
dnl Here is the standard hierarchy of paths, as defined by the GNU
dnl Coding Standards:
dnl
dnl    prefix
dnl   	  exec_prefix
dnl   	     bindir
dnl   	     libdir
dnl   	     libexecdir
dnl   	     sbindir
dnl   	  datadir
dnl   	  sysconfdir
dnl   	  sharestatedir
dnl   	  localstatedir
dnl   	  infodir
dnl   	  lispdir
dnl   	  includedir
dnl   	  oldincludedir
dnl   	  mandir
dnl
dnl This macro will setup a set of variables of the form
dnl 'xxx_forward_relative_path' and 'xxx_backward_relative_path' where
dnl xxx is one of the above directories. The latter variable is set to
dnl the relative path to go from xxx to its parent directory, while the
dnl former hold the other way.
dnl
dnl For instance `bindir_relative_path' will contains the value to add
dnl to $exec_prefix to reach the $bindir directory (usually 'bin'), and
dnl `bindir_backward_relative_path' the value to append to $bindir to
dnl reach the $exec_prefix directory (usually '..').
dnl
dnl This macro requires adl_COMPUTE_RELATIVE_PATHS which itself
dnl requires adl_NORMALIZE_PATH.
dnl
dnl @category Misc
dnl @author Alexandre Duret-Lutz <duret_g@epita.fr>
dnl @version 2001-05-25
dnl @license GPLWithACException

AC_DEFUN([adl_COMPUTE_STANDARD_RELATIVE_PATHS],
## These calls need to be on separate lines for aclocal to work!
[adl_COMPUTE_RELATIVE_PATHS(dnl
adl_STANDARD_RELATIVE_PATH_LIST)])

dnl adl_STANDARD_RELATIVE_PATH_LIST
dnl ===============================
dnl A list of standard paths, ready to supply to adl_COMPUTE_RELATIVE_PATHS.
AC_DEFUN([adl_STANDARD_RELATIVE_PATH_LIST],
[pushdef([TRIPLET],
[$][1:$][2:$][2_forward_relative_path $]dnl
[2:$][1:$][2_backward_relative_path])dnl
TRIPLET(prefix, exec_prefix) dnl
TRIPLET(exec_prefix, bindir) dnl
TRIPLET(exec_prefix, libdir) dnl
TRIPLET(exec_prefix, libexecdir) dnl
TRIPLET(exec_prefix, sbindir) dnl
TRIPLET(prefix, datadir) dnl
TRIPLET(prefix, sysconfdir) dnl
TRIPLET(prefix, sharestatedir) dnl
TRIPLET(prefix, localstatedir) dnl
TRIPLET(prefix, infodir) dnl
TRIPLET(prefix, lispdir) dnl
TRIPLET(prefix, includedir) dnl
TRIPLET(prefix, oldincludedir) dnl
TRIPLET(prefix, mandir) dnl
popdef([TRIPLET])])

dnl @synopsis AC_DEFINE_DIR(VARNAME, DIR [, DESCRIPTION])
dnl
dnl This macro sets VARNAME to the expansion of the DIR variable,
dnl taking care of fixing up ${prefix} and such.
dnl
dnl VARNAME is then offered as both an output variable and a C
dnl preprocessor symbol.
dnl
dnl Example:
dnl
dnl    AC_DEFINE_DIR([DATADIR], [datadir], [Where data are placed to.])
dnl
dnl @category Misc
dnl @author Stepan Kasal <kasal@ucw.cz>
dnl @author Andreas Schwab <schwab@suse.de>
dnl @author Guido Draheim <guidod@gmx.de>
dnl @author Alexandre Oliva
dnl @version 2005-07-29
dnl @license AllPermissive

AC_DEFUN([AC_DEFINE_DIR], [
  prefix_NONE=
  exec_prefix_NONE=
  test "x$prefix" = xNONE && prefix_NONE=yes && prefix=$ac_default_prefix
  test "x$exec_prefix" = xNONE && exec_prefix_NONE=yes && exec_prefix=$prefix
dnl In Autoconf 2.60, ${datadir} refers to ${datarootdir}, which in turn
dnl refers to ${prefix}.  Thus we have to use `eval' twice.
  eval ac_define_dir="\"[$]$2\""
  eval ac_define_dir="\"$ac_define_dir\""
  AC_SUBST($1, "$ac_define_dir")
  AC_DEFINE_UNQUOTED($1, "$ac_define_dir", [$3])
  test "$prefix_NONE" && prefix=NONE
  test "$exec_prefix_NONE" && exec_prefix=NONE
])

