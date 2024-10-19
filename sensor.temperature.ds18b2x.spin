{
----------------------------------------------------------------------------------------------------
    Filename:       sensor.temperature.ds18b2x.spin
    Description:    Driver for the Dallas/Maxim DS18B2x-series temperature sensors
    Author:         Jesse Burt
    Started:        Jul 13, 2019
    Updated:        Oct 19, 2024
    Copyright (c) 2024 - See end of file for terms of use.
----------------------------------------------------------------------------------------------------
}

#include "sensor.temp.common.spinh"             ' use code common to all temp sensor drivers

CON

    { default I/O settings; these can be overridden in the parent object }
    OW_PIN  = 0

    ' Operating modes
    ONE     = 0
    MULTI   = 1

    SN_LSB  = 0
    SN_MSB  = 7
    SPAD_LSB= 0
    SPAD_MSB= 8


OBJ

    core:   "core.con.ds18b2x"                  ' HW-specific constants
    ow:     "com.onewire"                       ' OneWire bus engine
    crc:    "math.crc"                          ' CRC routines
    time:   "time"


VAR

    long _sel_addr[2], _lastcrc_valid
    byte _opmode


PUB null()
' This is not a top-level object


PUB start(): status
' Start using default I/O settings
    return startx(OW_PIN)


PUB startx(DQ_PIN): status
' Start the driver with custom I/O settings
'   SCL_PIN:    OneWire data, 0..31
'   Returns:
'       cog ID+1 of OW engine on success (= calling cog ID+1, if the bytecode I2C engine is used)
'       0 on failure
    if ( lookdown(DQ_PIN: 0..31) )
        if ( status := ow.init(DQ_PIN) )
            return
    ' if this point is reached, something above failed
    ' Double check I/O pin assignments, connections, power
    ' Lastly - make sure you have at least one free core/cog
    return FALSE


PUB stop()
' Stop the driver
    ow.deinit()
    longfill(@_sel_addr, 0, 3)
    _opmode := 0


PUB defaults()
' Factory default settings
    temp_adc_res(12)
    temp_scale(C)


PUB last_crc_valid(): v
' Flag indicating CRC of last data read from sensor was valid
'   Returns: TRUE (-1) or FALSE (0)
'   NOTE: CRC is calculated from entire DS18B20 scratchpad RAM
    return _lastcrc_valid


PUB opmode(mode): c
' Set operation mode
'   Valid values:
'       ONE (0): one connected device
'       MULTI (1): Multi-drop, for multiple connected devices
'   Any other value returns the current setting
    case mode
        ONE, MULTI:
            _opmode := mode
        other:
            return _opmode


PUB search(p_buff, nr_devs): n
' Search bus for devices and store their addresses into a buffer
'   NOTE: This buffer must be at least (8 * nr_devs) bytes
    return ow.search(ow.CHECK_CRC, nr_devs, p_buff)


PUB select(p_addr)
' Select device for subsequent operations
'   p_addr: pointer to buffer containing 64-bit ID
    longmove(@_sel_addr, p_addr, 2)


PUB serial_num(p_buff): i
' Read 64-bit serial number of device into buffer at ptr_buff
'   NOTE: Buffer at ptr_buff must be 8 bytes in length
'   NOTE: Includes family code (LSB) and CRC (MSB)
'   Returns: Flag indicating whether CRC is valid
    ow.reset()
    ow.wr_byte(ow.RD_ROM)
    ow.rd_addr(p_buff)
    return (crc.dallas_maxim_crc8(p_buff, 7) == byte[p_buff][SN_MSB])


PUB temp_adc_res(bits): c
' Set resolution of temperature readings, in bits
'   Valid values: 9..12
'   Any other value polls the chip and returns the current setting
    case bits
        9..12:
            bits := lookdownz(bits: 9..12) << core.R0
            poll_dev()
            ow.wr_byte(core.WR_SPAD)
            ow.wr_word($0000)                   ' skip over Th, Tl regs
            ow.wr_byte(bits)
            ow.reset()
        other:
            poll_dev()
            ow.wr_byte(core.RD_SPAD)
            ow.rd_long()                        ' skip over temperature, Th, Tl
            c := (ow.rd_byte() >> core.R0)
            return lookupz(c: 9..12)


PUB temp_data(): d | tmp[3], i
' Read temperature data
    d := 0
    poll_dev()

    ow.wr_byte(core.CONV_TEMP)
    repeat
    until ow.rd_bits(1)                  ' wait until measurement ready

    poll_dev()

    ow.wr_byte(core.RD_SPAD)
    repeat i from 0 to 8
        tmp.byte[i] := ow.rd_byte()

    d := tmp.word[0]
    _lastcrc_valid := (crc.dallas_maxim_crc8(@tmp, 8) == tmp.byte[SPAD_MSB])
    ow.reset()


PUB temp_word2deg(temp_word): t
' Convert temperature ADC word to temperature
'   Returns: temperature, in hundredths of a degree, in chosen scale
    t := ~~temp_word * 5
    case _temp_scale
        C:
            return t
        F:
            return ((t * 9) / 5) + 32_00
        other:
            return t


PRI poll_dev()
' Poll a device
    ow.reset()
    case _opmode
        ONE:                                    ' match first device that
            ow.wr_byte(ow.SKIP_ROM)             '   responds
        MULTI:
            ow.wr_byte(ow.MATCH_ROM)            ' match a specific device
            ow.wr_addr(@_sel_addr)


DAT
{
Copyright 2024 Jesse Burt

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and
associated documentation files (the "Software"), to deal in the Software without restriction,
including without limitation the rights to use, copy, modify, merge, publish, distribute,
sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or
substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT
OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
}

