# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit flag-o-matic multilib python-any-r1 toolchain-funcs

DESCRIPTION="C Driver for MongoDB"
HOMEPAGE="http://www.mongodb.org/ https://github.com/mongodb/mongo-c-driver"
SRC_URI="https://github.com/mongodb/${PN}/tarball/v${PV/_/} -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~hppa ~s390 x86"
IUSE="doc static-libs"

# tests fails to build
RESTRICT="test"

RDEPEND=""
DEPEND="${PYTHON_DEPS}
	doc? ( $(python_gen_any_dep 'dev-python/sphinx[${PYTHON_USEDEP}]') )
"

python_check_deps() {
	if use doc; then
		has_version "dev-python/sphinx[${PYTHON_USEDEP}]"
	fi
}

src_unpack() {
	unpack ${A}
	mv *-${PN}-* "${S}"
}

src_prepare() {
	# bug #510722
	sed -e 's/-O3//g' \
		-e 's/-ggdb//g' \
		-e "s/CC:=.*/CC:=$(tc-getCC)/g" \
		-i Makefile || die
}

src_compile() {
	append-cflags -D_POSIX_C_SOURCE=200112L
	emake
	use doc && make -C docs/source/sphinx html
}

src_install() {
	emake install \
		INSTALL_LIBRARY_PATH="${D}/usr/$(get_libdir)" \
		INSTALL_INCLUDE_PATH="${D}/usr/include"

	use static-libs || find "${ED}" -name '*.a' -exec rm -f {} +

	use doc && dohtml -r docs/source/sphinx/build/html/*
}
