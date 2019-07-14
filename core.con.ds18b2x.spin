{
    --------------------------------------------
    Filename: core.con.ds18b2x.spin
    Author: Jesse Burt
    Description: Low-level constants
    Copyright (c) 2019
    Started Jul 13, 2019
    Updated Jul 13, 2019
    See end of file for terms of use.
    --------------------------------------------
}

CON

    FAMILY_20   = $28
    FAMILY_22   = $22

    CONV_TEMP   = $44
    COPY_SPAD   = $48
    WR_SPAD     = $4E
    RD_POWER    = $B4
    RD_EE       = $B8
    RD_SPAD     = $BE

PUB Null
' This is not a top-level object
