{
    --------------------------------------------
    Filename: DS18B2x-Demo.spin
    Author: Jesse Burt
    Description: Demo of the DS18B2x driver
    Copyright (c) 2020
    Started Jul 13, 2019
    Updated May 31, 2020
    See end of file for terms of use.
    --------------------------------------------
}

CON

    _clkmode    = cfg#_CLKMODE
    _xinfreq    = cfg#_XINFREQ

' -- User-modifiable constants
    SER_RX      = 31
    SER_TX      = 30
    SER_BAUD    = 115_200
    LED         = cfg#LED1
    OW_PIN      = 0
    SCALE       = F
' --

    C           = 0
    F           = 1

OBJ

    cfg : "core.con.boardcfg.flip"
    time: "time"
    ds  : "sensor.temperature.ds18b2x.ow"
    ser : "com.serial.terminal.ansi"
    int : "string.integer"

VAR

    byte _sn[8]

PUB Main | sn_byte, temp

    Setup
    ds.Scale(ds#SCALE_F)
    ds.ADCRes(9)

    ser.Position(0, 4)
    ser.Str(string("Temp res: "))
    ser.Dec(ds.ADCRes(-2))
    ser.Str(string("bits", ser#CR, ser#LF))

    ser.Str(string("SN: "))
    ds.SN(@_sn)
    repeat sn_byte from 0 to 7
        ser.Hex(_sn[sn_byte], 2)

    repeat
        temp := ds.Temperature
        ser.Position(0, 6)
        ser.Str(string("Temp: "))
        DispTemp(temp)

    Flash(LED, 100)

PUB DispTemp(cent_deg) | temp

    ser.Dec(cent_deg/100)
    ser.Char(".")
    ser.Str(int.DecZeroed(cent_deg//100, 2))

PUB Setup

    repeat until ser.StartRXTX (SER_RX, SER_TX, 0, SER_BAUD)
    time.MSleep(30)
    ser.Clear
    ser.Str(string("Serial terminal started", ser#CR, ser#LF))
    if ds.Start (OW_PIN)
        ser.Str (string("DS18B2x driver started (DS18B"))
        ser.Dec (ds.DeviceID)
        ser.Str(string(" found)"))
    else
        ser.Str (string("DS18B2x driver failed to start - halting", ser#CR, ser#LF))
        ds.Stop
        time.MSleep (500)
        ser.Stop
        Flash(LED, 500)

PUB Flash(pin, delay_ms)

    dira[pin] := 1
    repeat   
        !outa[pin]
        time.MSleep (delay_ms)

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

