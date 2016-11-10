# -*- coding: utf-8 -*-
#-------------------------------------------------------------------------#
#   Copyright (C) 2011 by Christoph Thelen                                #
#   doc_bacardi@users.sourceforge.net                                     #
#                                                                         #
#   This program is free software; you can redistribute it and/or modify  #
#   it under the terms of the GNU General Public License as published by  #
#   the Free Software Foundation; either version 2 of the License, or     #
#   (at your option) any later version.                                   #
#                                                                         #
#   This program is distributed in the hope that it will be useful,       #
#   but WITHOUT ANY WARRANTY; without even the implied warranty of        #
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         #
#   GNU General Public License for more details.                          #
#                                                                         #
#   You should have received a copy of the GNU General Public License     #
#   along with this program; if not, write to the                         #
#   Free Software Foundation, Inc.,                                       #
#   59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.             #
#-------------------------------------------------------------------------#


import os.path

#----------------------------------------------------------------------------
#
# Set up the Muhkuh Build System.
#

SConscript('mbs/SConscript')
Import('atEnv')

# Create a build environment for the ARM9 based netX chips.
env_arm9 = atEnv.DEFAULT.CreateEnvironment(['gcc-arm-none-eabi-4.7', 'asciidoc', 'exoraw-2.0.7_2'])
env_arm9.CreateCompilerEnv('NETX500', ['arch=armv5te'])
env_arm9.CreateCompilerEnv('NETX56', ['arch=armv5te'])
env_arm9.CreateCompilerEnv('NETX50', ['arch=armv5te'])
env_arm9.CreateCompilerEnv('NETX10', ['arch=armv5te'])

# Create a build environment for the Cortex-R7 and Cortex-A9 based netX chips.
env_cortexR7 = atEnv.DEFAULT.CreateEnvironment(['gcc-arm-none-eabi-4.9', 'asciidoc', 'exoraw-2.0.7_2'])
env_cortexR7.CreateCompilerEnv('NETX4000_RELAXED', ['arch=armv7', 'thumb'], ['arch=armv7-r', 'thumb'])

# Create a build environment for the Cortex-M4 based netX chips.
env_cortexM4 = atEnv.DEFAULT.CreateEnvironment(['gcc-arm-none-eabi-4.9', 'asciidoc', 'exoraw-2.0.7_2'])
env_cortexM4.CreateCompilerEnv('NETX90_MPW', ['arch=armv7', 'thumb'], ['arch=armv7e-m', 'thumb'])

# Build the platform libraries.
SConscript('platform/SConscript')

import spi_flashes
spi_flashes.ApplyToEnv(atEnv.DEFAULT)
spi_flashes.ApplyToEnv(atEnv.NETX500)
spi_flashes.ApplyToEnv(atEnv.NETX56)
spi_flashes.ApplyToEnv(atEnv.NETX50)
spi_flashes.ApplyToEnv(atEnv.NETX10)
spi_flashes.ApplyToEnv(atEnv.NETX4000_RELAXED)
spi_flashes.ApplyToEnv(atEnv.NETX90_MPW)


#----------------------------------------------------------------------------
# This is the list of sources. The elements must be separated with whitespace
# (i.e. spaces, tabs, newlines). The amount of whitespace does not matter.
flasher_sources_common = """
	src/cfi_flash.c
	src/delay.c
	src/spi_flash.c
	src/exodecr.c
	src/flasher_parflash.c
	src/flasher_spi.c
	src/i2c_hifsta.c
	src/init_netx_test.S
	src/main.c
	src/progress_bar.c
	src/sfdp.c
	src/spansion.c
	src/spi_macro_player.c
	src/strata.c
	src/units.c
"""


flasher_sources_custom_netx4000 = """
	src/netx4000/board.c
	src/netx4000/flasher_header.c
	src/sha1_arm/sha1.c
	src/sha1_arm/sha1_arm.S
	src/drv_spi_hsoc_v2.c
	src/drv_sqi.c
	src/mmio.c
	src/pl353_nor.c
"""


flasher_sources_custom_netx90 = """
	src/netx90/board.c
	src/netx90/cortexm_systick.c
	src/netx90/flasher_header.c
	src/drv_spi_hsoc_v2.c
	src/drv_sqi.c
	src/mmio.c
"""


flasher_sources_custom_netx500 = """
	src/netx500/board.c
	src/netx500/flasher_header.c
	src/sha1_arm/sha1.c
	src/sha1_arm/sha1_arm.S
	src/drv_spi_hsoc_v1.c
"""


flasher_sources_custom_netx56 = """
	src/netx56/board.c
	src/netx56/flasher_header.c
	src/sha1_arm/sha1.c
	src/sha1_arm/sha1_arm.S
	src/drv_spi_hsoc_v2.c
	src/drv_sqi.c
	src/mmio.c
"""


flasher_sources_custom_netx50 = """
	src/netx50/board.c
	src/netx50/flasher_header.c
	src/sha1_arm/sha1.c
	src/sha1_arm/sha1_arm.S
	src/drv_spi_hsoc_v2.c
	src/mmio.c
"""


flasher_sources_custom_netx10 = """
	src/netx10/board.c
	src/netx10/flasher_header.c
	src/sha1_arm/sha1.c
	src/sha1_arm/sha1_arm.S
	src/drv_spi_hsoc_v2.c
	src/drv_sqi.c
	src/mmio.c
"""


src_netx4000 = flasher_sources_common + flasher_sources_custom_netx4000
src_netx500  = flasher_sources_common + flasher_sources_custom_netx500
src_netx90   = flasher_sources_common + flasher_sources_custom_netx90
src_netx56   = flasher_sources_common + flasher_sources_custom_netx56
src_netx50   = flasher_sources_common + flasher_sources_custom_netx50
src_netx10   = flasher_sources_common + flasher_sources_custom_netx10


#----------------------------------------------------------------------------
#
# Get the source code version from the VCS.
#
atEnv.DEFAULT.Version('targets/version/flasher_version.h', 'templates/flasher_version.h')
atEnv.DEFAULT.Version('targets/version/flasher_version.xsl', 'templates/flasher_version.xsl')


#----------------------------------------------------------------------------
#
# Create the compiler environments.
#
astrCommonIncludePaths = ['src', 'src/sha1_arm', '#platform/src', '#platform/src/lib', 'targets/spi_flash_types', 'targets/version']

env_netx4000_default = atEnv.NETX4000_RELAXED.Clone()
env_netx4000_default.Replace(LDFILE = File('src/netx4000/netx4000.ld'))
env_netx4000_default.Append(CPPPATH = astrCommonIncludePaths + ['src/netx4000'])
env_netx4000_default.Append(CPPDEFINES = [['CFG_INCLUDE_SHA1', '1']])

env_netx500_default = atEnv.NETX500.Clone()
env_netx500_default.Replace(LDFILE = File('src/netx500/netx500.ld'))
env_netx500_default.Append(CPPPATH = astrCommonIncludePaths + ['src/netx500'])
env_netx500_default.Append(CPPDEFINES = [['CFG_INCLUDE_SHA1', '1']])

env_netx90_default  = atEnv.NETX90_MPW.Clone()
env_netx90_default.Replace(LDFILE = File('src/netx90/netx90.ld'))
env_netx90_default.Append(CPPPATH = astrCommonIncludePaths + ['src/netx90'])
env_netx90_default.Append(CPPDEFINES = [['CFG_INCLUDE_SHA1', '0']])

env_netx56_default  = atEnv.NETX56.Clone()
env_netx56_default.Replace(LDFILE = File('src/netx56/netx56.ld'))
env_netx56_default.Append(CPPPATH = astrCommonIncludePaths + ['src/netx56'])
env_netx56_default.Append(CPPDEFINES = [['CFG_INCLUDE_SHA1', '1']])

env_netx50_default  = atEnv.NETX50.Clone()
env_netx50_default.Replace(LDFILE = File('src/netx50/netx50.ld'))
env_netx50_default.Append(CPPPATH = astrCommonIncludePaths + ['src/netx50'])
env_netx50_default.Append(CPPDEFINES = [['CFG_INCLUDE_SHA1', '1']])

env_netx10_default  = atEnv.NETX10.Clone()
env_netx10_default.Replace(LDFILE = File('src/netx10/netx10.ld'))
env_netx10_default.Append(CPPPATH = astrCommonIncludePaths + ['src/netx10'])
env_netx10_default.Append(CPPDEFINES = [['CFG_INCLUDE_SHA1', '1']])


#----------------------------------------------------------------------------
#
# Provide a function to build a flasher binary.
#
def flasher_build(strFlasherName, tEnv, strBuildPath, astrSources):
	# Get the platform library.
	tLibPlatform = tEnv['PLATFORM_LIBRARY']

	# Create the list of known SPI flashes.
	srcSpiFlashes = tEnv.SPIFlashes(os.path.join(strBuildPath, 'spi_flash_types', 'spi_flash_types.c'), 'src/spi_flash_types.xml')
	objSpiFlashes = tEnv.Object(os.path.join(strBuildPath, 'spi_flash_types', 'spi_flash_types.o'), srcSpiFlashes[0])
	# Extract the binary.
	binSpiFlashes = tEnv.ObjCopy(os.path.join(strBuildPath, 'spi_flash_types', 'spi_flash_types.bin'), objSpiFlashes)
	# Pack the binary with exomizer.
	exoSpiFlashes = tEnv.Exoraw(os.path.join(strBuildPath, 'spi_flash_types', 'spi_flash_types.exo'), binSpiFlashes)
	# Convert the packed binary to an object.
	objExoSpiFlashes = tEnv.ObjImport(os.path.join(strBuildPath, 'spi_flash_types', 'spi_flash_types_exo.o'), exoSpiFlashes)

	# Append the path to the SPI flash list.
	tEnv.Append(CPPPATH = [os.path.join(strBuildPath, 'spi_flash_types')])

	tSrcFlasher = tEnv.SetBuildPath(strBuildPath, 'src', astrSources)
	tElfFlasher = tEnv.Elf(os.path.join(strBuildPath, strFlasherName+'.elf'), tSrcFlasher + objExoSpiFlashes + [tLibPlatform])
	tBinFlasher = tEnv.ObjCopy(os.path.join(strBuildPath, strFlasherName+'.bin'), tElfFlasher)

	return tElfFlasher,tBinFlasher


#----------------------------------------------------------------------------
#
# Build the netX10 flasher with the old netX50 console io interface.
#
env_netx10_oldio_nodbg = env_netx10_default.Clone()
env_netx10_oldio_nodbg.Replace(LDFILE = File('src/netx10/netx10_oldio.ld'))
env_netx10_oldio_nodbg.Append(CPPDEFINES = [['CFG_DEBUGMSG', '0']])
elf_netx10_oldio_nodbg,bin_netx10_oldio_nodbg = flasher_build('flasher_netx10', env_netx10_oldio_nodbg, 'targets/netx10_oldio_nodbg', src_netx10)

env_netx10_oldio_dbg = env_netx10_default.Clone()
env_netx10_oldio_dbg.Replace(LDFILE = File('src/netx10/netx10_oldio.ld'))
env_netx10_oldio_dbg.Append(CPPDEFINES = [['CFG_DEBUGMSG', '1']])
elf_netx10_oldio_dbg,bin_netx10_oldio_dbg = flasher_build('flasher_netx10_debug', env_netx10_oldio_dbg, 'targets/netx10_oldio_dbg', src_netx10)


#----------------------------------------------------------------------------
#
# Build the flasher without debug messages.
#
env_netx4000_nodbg = env_netx4000_default.Clone()
env_netx4000_nodbg.Append(CPPDEFINES = [['CFG_DEBUGMSG', '0']])
elf_netx4000_relaxed_nodbg,bin_netx4000_relaxed_nodbg = flasher_build('flasher_netx4000_relaxed', env_netx4000_nodbg, 'targets/netx4000_relaxed_nodbg', src_netx4000)

env_netx500_nodbg = env_netx500_default.Clone()
env_netx500_nodbg.Append(CPPDEFINES = [['CFG_DEBUGMSG', '0']])
elf_netx500_nodbg,bin_netx500_nodbg = flasher_build('flasher_netx500', env_netx500_nodbg, 'targets/netx500_nodbg', src_netx500)

env_netx90_nodbg = env_netx90_default.Clone()
env_netx90_nodbg.Append(CPPDEFINES = [['CFG_DEBUGMSG', '0']])
elf_netx90_mpw_nodbg,bin_netx90_mpw_nodbg = flasher_build('flasher_netx90_mpw', env_netx90_nodbg, 'targets/netx90_mpw_nodbg', src_netx90)

env_netx56_nodbg = env_netx56_default.Clone()
env_netx56_nodbg.Append(CPPDEFINES = [['CFG_DEBUGMSG', '0']])
elf_netx56_nodbg,bin_netx56_nodbg = flasher_build('flasher_netx56', env_netx56_nodbg, 'targets/netx56_nodbg', src_netx56)

env_netx50_nodbg = env_netx50_default.Clone()
env_netx50_nodbg.Append(CPPDEFINES = [['CFG_DEBUGMSG', '0']])
elf_netx50_nodbg,bin_netx50_nodbg = flasher_build('flasher_netx50', env_netx50_nodbg, 'targets/netx50_nodbg', src_netx50)

env_netx10_nodbg = env_netx10_default.Clone()
env_netx10_nodbg.Append(CPPDEFINES = [['CFG_DEBUGMSG', '0']])
elf_netx10_nodbg,bin_netx10_nodbg = flasher_build('flasher_netx10', env_netx10_nodbg, 'targets/netx10_nodbg', src_netx10)


#----------------------------------------------------------------------------
#
# Build the flasher with debug messages.
#

env_netx4000_dbg = env_netx4000_default.Clone()
env_netx4000_dbg.Append(CPPDEFINES = [['CFG_DEBUGMSG', '1']])
elf_netx4000_relaxed_dbg,bin_netx4000_relaxed_dbg = flasher_build('flasher_netx4000_relaxed_debug', env_netx4000_dbg, 'targets/netx4000_relaxed_dbg', src_netx4000)

env_netx500_dbg = env_netx500_default.Clone()
env_netx500_dbg.Append(CPPDEFINES = [['CFG_DEBUGMSG', '1']])
elf_netx500_dbg,bin_netx500_dbg = flasher_build('flasher_netx500_debug', env_netx500_dbg, 'targets/netx500_dbg', src_netx500)

env_netx90_dbg = env_netx90_default.Clone()
env_netx90_dbg.Append(CPPDEFINES = [['CFG_DEBUGMSG', '1']])
elf_netx90_mpw_dbg,bin_netx90_mpw_dbg = flasher_build('flasher_netx90_mpw_debug', env_netx90_dbg, 'targets/netx90_mpw_dbg', src_netx90)

env_netx56_dbg = env_netx56_default.Clone()
env_netx56_dbg.Append(CPPDEFINES = [['CFG_DEBUGMSG', '1']])
elf_netx56_dbg,bin_netx56_dbg = flasher_build('flasher_netx56_debug', env_netx56_dbg, 'targets/netx56_dbg', src_netx56)

env_netx50_dbg = env_netx50_default.Clone()
env_netx50_dbg.Append(CPPDEFINES = [['CFG_DEBUGMSG', '1']])
elf_netx50_dbg,bin_netx50_dbg = flasher_build('flasher_netx50_debug', env_netx50_dbg, 'targets/netx50_dbg', src_netx50)

env_netx10_dbg = env_netx10_default.Clone()
env_netx10_dbg.Append(CPPDEFINES = [['CFG_DEBUGMSG', '1']])
elf_netx10_dbg,bin_netx10_dbg = flasher_build('flasher_netx10_debug', env_netx10_dbg, 'targets/netx10_dbg', src_netx10)


#----------------------------------------------------------------------------
#
# Build the BOB flasher without debug messages.
# This version runs from SDRAM starting at 0x8002000 to save the INTRAM for
# the 2ndStageLoader.
#
env_netx500_bob = env_netx500_default.Clone()
env_netx500_bob.Append(CPPDEFINES = [['CFG_DEBUGMSG', '0']])
env_netx500_bob.Replace(LDFILE = File('src/netx500/netx500_bob.ld'))
elf_netx500_bob,bin_netx500_bob = flasher_build('flasher_netx500_bob', env_netx500_bob, 'targets/netx500_bob', src_netx500)


#----------------------------------------------------------------------------
#
# Generate the LUA scripts from the template.
# This extracts symbols and enumeration values from the ELF file and inserts
# them into the LUA script.
# The netX500 ELF file is used here as a source for no special reason. All of
# the symbols and values which are used in the template are the same in every
# ELF file in this project.
#
lua_flasher = env_netx500_nodbg.GccSymbolTemplate('targets/lua/flasher.lua', elf_netx500_nodbg, GCCSYMBOLTEMPLATE_TEMPLATE='templates/flasher.lua')
tDemoShowEraseAreas = env_netx500_nodbg.GccSymbolTemplate('targets/lua/show_erase_areas.lua', elf_netx500_nodbg, GCCSYMBOLTEMPLATE_TEMPLATE='templates/show_erase_areas.lua')

#----------------------------------------------------------------------------
#
# Build the documentation.
#

tDocSpiFlashTypesHtml = atEnv.DEFAULT.XSLT('targets/doc/spi_flash_types.html', ['src/spi_flash_types.xml', 'src/spi_flash_types_html.xsl'])
tDocSpiFlashListTxt = atEnv.DEFAULT.XSLT('targets/doc/spi_flash_types.txt', ['src/spi_flash_types.xml', 'src/spi_flash_types_txt.xsl'])


# Get the default attributes.
aAttribs = atEnv.DEFAULT['ASCIIDOC_ATTRIBUTES']
# Add some custom attributes.
aAttribs.update(dict({
	# Use ASCIIMath formulas.
	'asciimath': True,

	# Embed images into the HTML file as data URIs.
	'data-uri': True,

	# Use icons instead of text for markers and callouts.
	'icons': True,

	# Use numbers in the table of contents.
	'numbered': True,
	
	# Generate a scrollable table of contents on the left of the text.
	'toc2': True,

	# Use 4 levels in the table of contents.
	'toclevels': 4
}))

doc = atEnv.DEFAULT.Asciidoc('targets/doc/flasher.html', 'doc/flasher.asciidoc', ASCIIDOC_BACKEND='html5', ASCIIDOC_ATTRIBUTES=aAttribs)


#----------------------------------------------------------------------------
#
# Build the artifact.
#

aArtifactServer = ('nexus@netx01', 'muhkuh', 'muhkuh_snapshots')
strArtifactGroup = 'tools.muhkuh.org'
strArtifactId = 'flasher'


tArcList0 = atEnv.DEFAULT.ArchiveList('zip')

tArcList0.AddFiles('netx/',
	bin_netx4000_relaxed_nodbg,
	bin_netx500_nodbg,
	bin_netx90_mpw_nodbg,
	bin_netx56_nodbg,
	bin_netx50_nodbg,
	bin_netx10_nodbg)

tArcList0.AddFiles('netx/debug/',
	bin_netx4000_relaxed_dbg,
	bin_netx500_dbg,
	bin_netx90_mpw_dbg,
	bin_netx56_dbg,
	bin_netx50_dbg,
	bin_netx10_dbg)

tArcList0.AddFiles('doc/',
	doc,
	tDocSpiFlashTypesHtml,
	tDocSpiFlashListTxt)

tArcList0.AddFiles('lua/',
	lua_flasher,
	'lua/flasher_test.lua')

tArcList0.AddFiles('demo/',
	'lua/cli_flash.lua',
	'lua/demo_getBoardInfo.lua',
	'lua/erase_complete_flash.lua',
	'lua/erase_first_flash_sector.lua',
	'lua/flash_parflash.lua',
	'lua/flash_serflash.lua',
	'lua/get_erase_areas_parflash.lua',
	'lua/identify_parflash.lua',
	'lua/identify_serflash.lua',
	'lua/is_erased_parflash.lua',
	'lua/read_bootimage.lua',
	'lua/read_complete_flash.lua',
	tDemoShowEraseAreas)

tArcList0.AddFiles('',
	'ivy/org.muhkuh.tools.flasher/install.xml')


aArtifactGroupReverse = strArtifactGroup.split('.')
aArtifactGroupReverse.reverse()

strArtifactPath = 'targets/ivy/repository/%s/%s/%s' % ('/'.join(aArtifactGroupReverse),strArtifactId,PROJECT_VERSION)
tArc = atEnv.DEFAULT.Archive(os.path.join(strArtifactPath, '%s-%s.zip' % (strArtifactId,PROJECT_VERSION)), None, ARCHIVE_CONTENTS=tArcList0)
tIvy = atEnv.DEFAULT.Version(os.path.join(strArtifactPath, 'ivy-%s.xml' % PROJECT_VERSION), 'ivy/%s.%s/ivy.xml' % ('.'.join(aArtifactGroupReverse),strArtifactId))

atEnv.DEFAULT.AddArtifact(tArc, aArtifactServer, strArtifactGroup, strArtifactId, PROJECT_VERSION, 'zip')
atEnv.DEFAULT.AddArtifact(tIvy, aArtifactServer, strArtifactGroup, strArtifactId, PROJECT_VERSION, 'ivy')

tArtifacts = atEnv.DEFAULT.Artifact('targets/artifacts_flasher.xml', None)

# Copy the artifacts to a fixed filename to allow a deploy to github.
Command('targets/ivy/%s.zip' % strArtifactId,  tArc,  Copy("$TARGET", "$SOURCE"))
Command('targets/ivy/ivy.xml', tIvy,  Copy("$TARGET", "$SOURCE"))

#----------------------------------------------------------------------------
#
# Prepare the build folders for the other artifacts.
#

Command('targets/ivy/ivysettings.xml', 'ivy/ivysettings.xml', Copy("$TARGET", "$SOURCE"))
Command('targets/ivy/flasher_cli/ivy-report.xsl', 'ivy/ivy-report.xsl', Copy("$TARGET", "$SOURCE"))

Command('targets/ivy/flasher_cli/build.xml', 'ivy/flasher_cli/build.xml', Copy("$TARGET", "$SOURCE"))
atEnv.DEFAULT.Version('targets/ivy/flasher_cli/ivy.xml', 'ivy/flasher_cli/ivy.xml')
atEnv.DEFAULT.Version('targets/artifacts_flasher_cli.xml', 'ivy/flasher_cli/artifacts_flasher_cli.xml')


#----------------------------------------------------------------------------
#
# Make a local demo installation.
#
# Copy all binaries.
Command('targets/testbench/netx/flasher_netx4000.bin', bin_netx4000_nodbg, Copy("$TARGET", "$SOURCE"))
Command('targets/testbench/netx/flasher_netx500.bin',  bin_netx500_nodbg,  Copy("$TARGET", "$SOURCE"))
Command('targets/testbench/netx/flasher_netx90_mpw.bin',  bin_netx90_mpw_nodbg,  Copy("$TARGET", "$SOURCE"))
Command('targets/testbench/netx/flasher_netx56.bin',   bin_netx56_nodbg,   Copy("$TARGET", "$SOURCE"))
Command('targets/testbench/netx/flasher_netx50.bin',   bin_netx50_nodbg,   Copy("$TARGET", "$SOURCE"))
Command('targets/testbench/netx/flasher_netx10.bin',   bin_netx10_nodbg,   Copy("$TARGET", "$SOURCE"))

# Copy all debug binaries.
Command('targets/testbench/netx/debug/flasher_netx4000_debug.bin', bin_netx4000_dbg, Copy("$TARGET", "$SOURCE"))
Command('targets/testbench/netx/debug/flasher_netx500_debug.bin',  bin_netx500_dbg,  Copy("$TARGET", "$SOURCE"))
Command('targets/testbench/netx/debug/flasher_netx90_mpw_debug.bin',  bin_netx90_mpw_dbg,   Copy("$TARGET", "$SOURCE"))
Command('targets/testbench/netx/debug/flasher_netx56_debug.bin',   bin_netx56_dbg,   Copy("$TARGET", "$SOURCE"))
Command('targets/testbench/netx/debug/flasher_netx50_debug.bin',   bin_netx50_dbg,   Copy("$TARGET", "$SOURCE"))
Command('targets/testbench/netx/debug/flasher_netx10_debug.bin',   bin_netx10_dbg,   Copy("$TARGET", "$SOURCE"))

# Copy all LUA modules.
Command('targets/testbench/lua/flasher.lua', lua_flasher, Copy("$TARGET", "$SOURCE"))

# Copy all LUA scripts.
Command('targets/testbench/cli_flash.lua',                'lua/cli_flash.lua', Copy("$TARGET", "$SOURCE"))
Command('targets/testbench/demo_getBoardInfo.lua',        'lua/demo_getBoardInfo.lua', Copy("$TARGET", "$SOURCE"))
Command('targets/testbench/erase_complete_flash.lua',     'lua/erase_complete_flash.lua', Copy("$TARGET", "$SOURCE"))
Command('targets/testbench/erase_first_flash_sector.lua', 'lua/erase_first_flash_sector.lua', Copy("$TARGET", "$SOURCE"))
Command('targets/testbench/flash_parflash.lua',           'lua/flash_parflash.lua', Copy("$TARGET", "$SOURCE"))
Command('targets/testbench/flash_serflash.lua',           'lua/flash_serflash.lua', Copy("$TARGET", "$SOURCE"))
Command('targets/testbench/flasher_test.lua',             'lua/flasher_test.lua', Copy("$TARGET", "$SOURCE"))
Command('targets/testbench/get_erase_areas_parflash.lua', 'lua/get_erase_areas_parflash.lua', Copy("$TARGET", "$SOURCE"))
Command('targets/testbench/identify_parflash.lua',        'lua/identify_parflash.lua', Copy("$TARGET", "$SOURCE"))
Command('targets/testbench/identify_serflash.lua',        'lua/identify_serflash.lua', Copy("$TARGET", "$SOURCE"))
Command('targets/testbench/is_erased_parflash.lua',       'lua/is_erased_parflash.lua', Copy("$TARGET", "$SOURCE"))
Command('targets/testbench/read_bootimage.lua',           'lua/read_bootimage.lua', Copy("$TARGET", "$SOURCE"))
Command('targets/testbench/read_complete_flash.lua',      'lua/read_complete_flash.lua', Copy("$TARGET", "$SOURCE"))
Command('targets/testbench/show_erase_areas.lua',         tDemoShowEraseAreas, Copy("$TARGET", "$SOURCE"))
