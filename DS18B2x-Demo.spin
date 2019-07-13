CON

    _clkmode    = cfg#_CLKMODE
    _xinfreq    = cfg#_XINFREQ

    LED         = cfg#LED1

    SER_BAUD    = 115_200

    OW_PIN      = 0

OBJ

    cfg : "core.con.boardcfg.flip"
    time: "time"
    ds  : "sensor.temperature.ds18b2x.ow"
    ser : "com.serial.terminal.ansi"

VAR

    byte _ser_cog, _sn[8]

PUB Main | i

    Setup

    ser.Position(0, 3)
    ser.Str(string("SN: "))
    ds.SN(@_sn)
    repeat i from 0 to 7
        ser.Hex(_sn[i], 2)

    repeat
        ser.Position(0, 4)
        ser.Dec(ds.Temperature)
    Flash(LED, 100)

PUB Setup

    repeat until _ser_cog := ser.Start (SER_BAUD)
    time.MSleep(200)
    ser.Clear
    ser.Str(string("Serial terminal started", ser#NL, ser#LF))
    if ds.Start (OW_PIN)
        ser.Str (string("DS18B2x driver started", ser#NL, ser#LF))
    else
        ser.Str (string("DS18B2x driver failed to start - halting", ser#NL, ser#LF))
        ds.Stop
        time.MSleep (500)
        ser.Stop
        Flash(LED, 500)

PUB Flash(pin, delay_ms)

    dira[pin] := 1
    repeat   
        !outa[pin]
        time.MSleep (delay_ms)

