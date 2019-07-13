CON


OBJ

    time    : "time"
    core    : "core.con.ds18b2x"
    ow      : "com.onewire"

VAR


PUB Start(OW_PIN): okay

    if lookdown(OW_PIN: 0..31)
        okay := ow.Start(OW_PIN)
        if okay
            if Status == ow#OW_STAT_FOUND
                return
    return FALSE

PUB Stop

    ow.Stop


PUB Family

    ow.Reset
    ow.Write(ow#RD_ROM)
    result := ow.Read
    ow.Reset

PUB SN(buff_addr) | tmp

    ow.Reset
    ow.Write(ow#RD_ROM)
    ow.Read                                 ' Discard first byte (family code)
    repeat tmp from 5 to 0                  ' Read only the 48-bit unique SN
        byte[buff_addr][tmp] := ow.Read
 
PUB Status

    return ow.Reset

PUB Temperature

    ow.Reset
    ow.Write(ow#SKIP_ROM)
    ow.Write(core#CONV_TEMP)
    repeat
        result := ow.RdBit
    until (result == 1)
    ow.Reset
    ow.Write(ow#SKIP_ROM)
    ow.Write(core#RD_SPAD)
    result := ow.Read
    result |= ow.Read << 8
    ow.Reset

    return ~~result * 5
