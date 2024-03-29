{
    --------------------------------------------
    Filename: DS18B2x-Demo.spin
    Author: Jesse Burt
    Description: Demo of the DS18B2x driver
    Copyright (c) 2022
    Started Jul 13, 2019
    Updated Nov 18, 2022
    See end of file for terms of use.
    --------------------------------------------
}

CON

    _clkmode    = cfg#_clkmode
    _xinfreq    = cfg#_xinfreq

' -- User-modifiable constants
    LED         = cfg#LED1
    SER_BAUD    = 115_200

    OW_PIN      = 0
    SCALE       = C

    NR_DEVICES  = 1
    BITS        = 12                            ' ADC res (9..12 bits)
' --

    C           = 0
    F           = 1

OBJ

    cfg : "boardcfg.flip"
    time: "time"
    ds  : "sensor.temperature.ds18b2x"
    ser : "com.serial.terminal.ansi"

VAR

    long _devs[NR_DEVICES * 2]

PUB main{} | temp, i, nr_found, tscl

    setup{}
    ds.temp_scale(SCALE)                        ' set temperature scale
    ds.opmode(ds#MULTI)                         ' ONE (1 sensor), MULTI

    nr_found := ds.search(@_devs, NR_DEVICES)   ' how many sensors found?

    i := 0
    repeat nr_found                             ' for each sensor,
        ds.select(@_devs[i])                    '   address it and set its
        ds.temp_adc_res(BITS)                   '   ADC resolution (9..12 bits)
        i += 2

    repeat
        ser.pos_xy(0, 3)
        nr_found := ds.search(@_devs, NR_DEVICES) ' how many sensors found?

        i := 0
        repeat nr_found                         ' for each sensor,
            ds.select(@_devs[i])                '   address it
            temp := ds.temperature{}            '   read its temperature
            ser.printf3(string("(%d) %08.8x%08.8x: "), i/2, _devs[i+1], _devs[i])
            tscl := lookupz(ds.temp_scale(-2): "C", "F", "K")
            ser.printf3(string("Temp. (deg %c): %3.3d.%02.2d\n\r"), tscl, (temp / 100), {
}                                                                   ||(temp // 100))
            i += 2

PUB setup{}

    ser.start(SER_BAUD)
    time.msleep(30)
    ser.clear{}
    ser.strln(string("Serial terminal started"))
    if ds.startx(OW_PIN)
        ser.strln(string("DS18B2x driver started"))
    else
        ser.strln(string("DS18B2x driver failed to start - halting"))
        repeat

DAT
{
Copyright 2022 Jesse Burt

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

