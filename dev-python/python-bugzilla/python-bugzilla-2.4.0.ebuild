# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( python3_{6..9} )

inherit distutils-r1

DESCRIPTION="A python module for interacting with Bugzilla over XMLRPC"
HOMEPAGE="https://github.com/python-bugzilla/python-bugzilla"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

KEYWORDS="~amd64 ~x86"
LICENSE="GPL-2+"
SLOT="0"

RDEPEND="
	|| ( dev-python/python-magic[${PYTHON_USEDEP}] sys-apps/file[python,${PYTHON_USEDEP}] )
	dev-python/requests[${PYTHON_USEDEP}]"
BDEPEND="
	dev-python/docutils[${PYTHON_USEDEP}]"

distutils_enable_tests pytest

src_prepare() {
	sed -i -e 's:rst2man:&.py:' setup.py || die
	distutils-r1_src_prepare
}
