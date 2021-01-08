{
    --------------------------------------------
    Filename: sensor.temperature.ds18b2x.ow.spin
    Author: Jesse Burt
    Description: Driver for the Dallas/Maxim DS18B2x-series temperature sensors
    Copyright (c) 2021
    Started Jul 13, 2019
    Updated Jan 8, 2021
    See end of file for terms of use.
    --------------------------------------------
}

CON

    C   = 0
    F   = 1

OBJ

    core    : "core.con.ds18b2x"
    ow      : "com.onewire"

VAR

    byte _temp_scale

PUB Start(OW_PIN): okay

    if lookdown(OW_PIN: 0..31)
        if okay := ow.start(OW_PIN)
            if status{} == ow#OW_STAT_FOUND
                if lookdown(deviceid{}: 20, 22)
                    return
    return FALSE                                ' something above failed

PUB Stop

    ow.stop{}

PUB Defaults{}
' Factory default settings
    adcres(12)
    tempscale(C)

PUB ADCRes(bits): curr_res
' Set resolution of temperature readings, in bits
'   Valid values: 9..12
'   Any other value polls the chip and returns the current setting
    ow.reset{}
    ow.write(ow#SKIP_ROM)
    ow.write(core#RD_SPAD)
    repeat 4
        ow.read{}

    case bits
        9..12:
            bits := lookdownz(bits: 9..12) << 5
        other:
            curr_res := (ow.read{} >> 5)
            return lookupz(curr_res: 9..12)

    ow.reset{}
    ow.write(ow#SKIP_ROM)
    ow.write(core#WR_SPAD)
    ow.write($00)
    ow.write($00)
    ow.write(bits)
    ow.reset{}

PUB DeviceID{}: id
' Returns: 8-bit family code of device
'   Known values:
'       20: DS18B20
'       22: DS18B22
    id := 0
    ow.reset{}
    ow.write(ow#RD_ROM)
    id := ow.read{}
    ow.reset{}

    case id
        core#FAMILY_20:
            return 20
        core#FAMILY_22:
            return 22
        other:
            return id

PUB SN(ptr_buff) | tmp
' Read 64-bit serial number of device into buffer at ptr_buff
'   NOTE: Buffer at ptr_buff must be 8 bytes in length
    ow.reset{}
    ow.write(ow#RD_ROM)
    ow.read{}                                     ' dummy read (family code)
    repeat tmp from 7 to 0
        byte[ptr_buff][tmp] := ow.read{}
 
PUB Status{}: curr_stat
' Returns: One-Wire bus status
    return ow.reset{}

PUB Temperature{}: temp
' Returns: Temperature in hundredths of a degree
    temp := 0
    ow.reset{}
    ow.write(ow#SKIP_ROM)
    ow.write(core#CONV_TEMP)
    repeat
        temp := ow.rdbit{}
    until (temp == 1)
    ow.reset{}
    ow.write(ow#SKIP_ROM)
    ow.write(core#RD_SPAD)
    temp := ow.read{}
    temp |= ow.read{} << 8
    ow.reset{}

    temp := ~~temp * 5
    case _temp_scale
        F:
            if temp > 0
                temp := temp * 9 / 5 + 32_00
            else
                temp := 32_00 - (||(temp) * 9 / 5)
        other:
            return temp

PUB TempScale(temp_scale): curr_scl
' Set scale of temperature data returned by Temperature() method
'   Valid values:
'       C (0): Celsius
'       F (1): Fahrenheit
'   Any other value returns the current setting
    case temp_scale
        F, C:
            _temp_scale := temp_scale
        other:
            return _temp_scale

DAT
{
    --------------------------------------------------------------------------------------------------------
    TERMS OF USE: MIT License

    Permission is hereby granted, free of charge, to any person obtaining a copy of this software and
    associated documentation files (the "Software"), to deal in the Software without restriction, including
    without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the
    following conditions:

    The above copyright notice and this permission notice shall be included in all copies or substantial
    portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT
    LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
    IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
    WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
    SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
    --------------------------------------------------------------------------------------------------------
}

