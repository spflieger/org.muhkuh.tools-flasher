require 'muhkuh_cli_init'
require 'flasher'
local archive = require 'archive'
local argparse = require 'argparse'
local wfp_control = require 'wfp_control'


local strFlasherPrefix = 'netx/'

local atLogLevels = {
  'debug',
  'info',
  'warning',
  'error',
  'fatal'
}

local tParser = argparse('wfp', 'Flash "wonderful feelings" packages.')
tParser:argument('archive', 'The WFP file to process.')
  :target('strWfpArchiveFile')
tParser:option('-v --verbose')
  :description(string.format('Set the verbosity level to LEVEL. Possible values for LEVEL are %s.', table.concat(atLogLevels, ', ')))
  :argname('<LEVEL>')
  :default('debug')
  :target('strLogLevel')
local tArgs = tParser:parse()

local tLogWriterConsole = require 'log.writer.console'.new()
local tLogWriterFilter = require 'log.writer.filter'.new(tArgs.strLogLevel, tLogWriterConsole)
local tLogWriter = require 'log.writer.prefix'.new('[Main] ', tLogWriterFilter)
local tLog = require 'log'.new(
  'trace',
  tLogWriter,
  require 'log.formatter.format'.new()
)


local atName2Bus = {
  ['Parflash'] = flasher.BUS_Parflash,
  ['Spi']      = flasher.BUS_Spi,
  ['IFlash']   = flasher.BUS_IFlash
}

local strWfpArchiveFile = 'wfp_test.tar.xz'

-- Create the WFP controller.
local tWfpControl = wfp_control(tLogWriterFilter)

-- Read the control file from the WFP archive.
tLog.debug('Using WFP archive "%s".', tArgs.strWfpArchiveFile)
local tResult = tWfpControl:open(tArgs.strWfpArchiveFile)
if tResult==nil then
  tLog.error('Failed to open the archive "%s"!', tArgs.strWfpArchiveFile)
else
  -- Select a plugin and connect to the netX.
  local tPlugin = tester.getCommonPlugin()
  if not tPlugin then
    tLog.error('No plugin selected, nothing to do!')
  else
    local iChiptype = tPlugin:GetChiptyp()
    -- Does the WFP have an entry for the chip?
    local tTarget = tWfpControl:getTarget(iChiptype)
    if tTarget==nil then
      tLog.error('The chip type %s is not supported.', tostring(iChiptype))
    else
      -- Download the binary.
      local aAttr = flasher.download(tPlugin, strFlasherPrefix)

      -- Loop over all flashes.
      for _, tTargetFlash in ipairs(tTarget.atFlashes) do
        local strBusName = tTargetFlash.strBus
        local tBus = atName2Bus[strBusName]
        if tBus==nil then
          tLog.error('Unknown bus "%s" found in WFP control file.', strBusName)
          break
        else
          local ulUnit = tTargetFlash.ulUnit
          local ulChipSelect = tTargetFlash.ulChipSelect
          tLog.debug('Processing bus: %s, unit: %d, chip select: %d', strBusName, ulUnit, ulChipSelect)

          -- Detect the device.
          fOk = flasher.detect(tPlugin, aAttr, tBus, ulUnit, ulChipSelect)
          if fOk~=true then
            error("Failed to detect the device!")
          end

          for _, tData in ipairs(tTargetFlash.atData) do
            local strFile = tData.strFile
            local ulOffset = tData.ulOffset
            tLog.debug('Found file "%s" with offset 0x%08x.', strFile, ulOffset)

            -- Loading the file data from the archive.
            local strData = tWfpControl:getData(strFile)
            local sizData = string.len(strData)
            if strData~=nil then
              tLog.debug('Flashing %d bytes...', sizData)

              fOk, strMsg = flasher.eraseArea(tPlugin, aAttr, ulOffset, sizData)
              assert(fOk, strMsg or "Error while erasing area")

              fOk, strMsg = flasher.flashArea(tPlugin, aAttr, ulOffset, strData)
              print(strMsg)
              assert(fOk, strMsg or "Error while programming area")
            end
          end
        end
      end
    end
  end



end

if tArchive~=nil then
  tArchive:close()
end
