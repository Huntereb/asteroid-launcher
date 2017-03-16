/*
 * Copyright (C) 2017 Florent Revest <revestflo@gmail.com>
 * All rights reserved.
 *
 * You may use this file under the terms of BSD license as follows:
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *     * Redistributions of source code must retain the above copyright
 *       notice, this list of conditions and the following disclaimer.
 *     * Redistributions in binary form must reproduce the above copyright
 *       notice, this list of conditions and the following disclaimer in the
 *       documentation and/or other materials provided with the distribution.
 *     * Neither the name of the author nor the
 *       names of its contributors may be used to endorse or promote products
 *       derived from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR
 * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

import QtQuick 2.1

Canvas {
    id: rootitem
    contextType: "2d"
    antialiasing: true
    smooth: true

    function twoDigits(x) {
        if (x<10) return "0"+x;
        else      return x;
    }

    onPaint: {
        var ctx = getContext("2d")
        ctx.reset()
        ctx.fillStyle = "white"
        ctx.textAlign = "center"
        ctx.textBaseline = 'middle';
        ctx.shadowColor = "black"
        ctx.shadowOffsetX = 0
        ctx.shadowOffsetY = 0
        ctx.shadowBlur = 3

        var medium = "57 "
        var thin = "0 "
        var light = "25 "

        var px = "px "

        var centerX = width/2
        var centerY = height/2

        // Hour
        var text = twoDigits(wallClock.time.getHours())
        var fontSize = height*0.36
        var horizontalOffset = -width*0.15
        var verticalOffset = height*0.05
        var fontFamily = "Roboto"
        ctx.font = medium + fontSize + px + fontFamily;
        ctx.fillText(text, centerX+horizontalOffset, centerY+verticalOffset);

        // Minute
        text = twoDigits(wallClock.time.getMinutes())
        fontSize = height/7
        horizontalOffset = width/5
        verticalOffset = -width*0.03
        fontFamily = "Roboto"
        ctx.font = thin + fontSize + px + fontFamily;
        ctx.fillText(text, centerX+horizontalOffset, centerY+verticalOffset);

        // Date
        text = Qt.formatDate(wallClock.time, "d MMM")
        fontSize = height/13
        horizontalOffset = width/5
        verticalOffset = width*0.1
        fontFamily = "Raleway"
        ctx.font = light + fontSize + px + fontFamily;
        ctx.fillText(text, centerX+horizontalOffset, centerY+verticalOffset);
    }

    Connections {
        target: wallClock
        onTimeChanged: rootitem.requestPaint()
    }
}
