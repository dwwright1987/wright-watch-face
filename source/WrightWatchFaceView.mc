using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Lang as Lang;
using Toybox.Math;

class WrightWatchFaceView extends Ui.WatchFace {
    const AM_HOURS_BUCKET = "AM";
    const PM_HOURS_BUCKET = "PM";
    const MAX_12_HOUR_HOURS = 12;
    const MIN_24_HOUR_HOURS = 00;
//    var timeLabelWidth;
//    var displayHour;
//    var displayMinute;
//    var displaySecond;
//    var displayHoursBucket;
    var secondsLocX;

    function initialize() {
        WatchFace.initialize();
    }

    // Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.WatchFace(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
    }

    function onPartialUpdate(dc) {
//        // Get and show the current time
//        var clockTime = Sys.getClockTime();
//        var is24Hour = Sys.getDeviceSettings().is24Hour;
//
//        var hour = clockTime.hour;
//        var hoursBucket = "";
//        if (!is24Hour) {
//            if (hour == MAX_12_HOUR_HOURS) {
//                hoursBucket = PM_HOURS_BUCKET;
//            } else if (hour > MAX_12_HOUR_HOURS) {
//                hour = hour - MAX_12_HOUR_HOURS;
//                hoursBucket = PM_HOURS_BUCKET;
//            } else if (hour == MIN_24_HOUR_HOURS) {
//                hour = MAX_12_HOUR_HOURS;
//                hoursBucket = AM_HOURS_BUCKET;
//            } else {
//                hoursBucket = AM_HOURS_BUCKET;
//            }
//        }
//
//        var minute = clockTime.min.format("%02d");
//        var second = clockTime.sec.format("%02d");
//
//        var timeString = Lang.format("$1$:$2$:$3$", [hour, minute, second]);
//        if (!is24Hour) {
//            timeString = Lang.format("$1$ $2$", [timeString, hoursBucket]);
//        }
//
//        var view = View.findDrawableById("TimeLabel");
//        view.setText(timeString);
//
//        // Call the parent onUpdate function to redraw the layout
//        View.onUpdate(dc);

//        displaySecond = Sys.getClockTime().sec.format("%02d");
//
//        updateTimeLabel();

//        dc.setClip(sectRect[0], sectRect[1], sectRect[2], sectRect[3]);
//        dc.setColor(color, Gfx.COLOR_TRANSPARENT);
//        dc.drawText(_x,  y, font, value, justification);
//        dc.drawText(_xf, y, fontFraction,    fract, justification);

        updateSeconds(dc);
    }

    // Update the view
    function onUpdate(dc) {
////        // Get and show the current time
////        var clockTime = Sys.getClockTime();
////
////        var timeString = Lang.format("$1$:$2$:$3$", [clockTime.hour, clockTime.min.format("%02d"), clockTime.sec]);
////
////        var view = View.findDrawableById("TimeLabel");
////        view.setText(timeString);
////
////        // Call the parent onUpdate function to redraw the layout
////        View.onUpdate(dc);
//
//        var clockTime = Sys.getClockTime();

        dc.clearClip();

        var clockTime = Sys.getClockTime();
        var is24Hour = Sys.getDeviceSettings().is24Hour;

        var hour = clockTime.hour;
        var hoursBucket = "";
        if (!Sys.getDeviceSettings().is24Hour) {
            if (hour == MAX_12_HOUR_HOURS) {
                hoursBucket = PM_HOURS_BUCKET;
            } else if (hour > MAX_12_HOUR_HOURS) {
                hour = hour - MAX_12_HOUR_HOURS;
                hoursBucket = PM_HOURS_BUCKET;
            } else if (hour == MIN_24_HOUR_HOURS) {
                hour = MAX_12_HOUR_HOURS;
                hoursBucket = AM_HOURS_BUCKET;
            } else {
                hoursBucket = AM_HOURS_BUCKET;
            }
        }

        var minute = clockTime.min.format("%02d");
        var seconds = clockTime.sec.format("%02d");

        var timeString = Lang.format("$1$:$2$:$3$", [hour, minute, seconds]);
        if (!is24Hour) {
            timeString = Lang.format("$1$ $2$", [timeString, hoursBucket]);
        }

        var timeLabelDrawable = View.findDrawableById("TimeLabel");
        timeLabelDrawable.setText(timeString);

        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);

//        secondsLocX = timeLabelDrawable.locX + Math.round(timeLabelDrawable.width / 2.0) - 70;
        secondsLocX = timeLabelDrawable.locX + Math.round(timeLabelDrawable.width / 2.0);
        if (hoursBucket == PM_HOURS_BUCKET) {
            secondsLocX -= 70;
        } else {
            secondsLocX -= 72;
        }

//        timeLabelWidth = timeLabelDrawable.width;

//        Sys.println("timeLabelWidth = " + timeLabelWidth);
//        Sys.println("timeLabelDrawable x loc = " + timeLabelDrawable.locX);

//        updateTimeLabel();
    }

    function updateSeconds(dc) {
//        var textLocationX = calculateSecondsLocationX();
        var textLocationX = secondsLocX;
        var textLocationY = 101;

//        Sys.println("textLocationX = " + textLocationX);

        var clipHeight = 35;
        var clipWidth = 35;
        var clipX = textLocationX - 16;
        var clipY = textLocationY;

        dc.setClip(clipX, clipY, clipWidth, clipHeight);
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_BLACK);

        var second = Sys.getClockTime().sec.format("%02d");
        dc.drawText(textLocationX, textLocationY, Gfx.FONT_NUMBER_MILD, second, Gfx.TEXT_JUSTIFY_CENTER);
    }

    function calculateSecondsLocationX() {
//        var textLocationX;
//
//        switch (currentHour) {
//            case 1:
//                textLocationX = 126;
//                break;
//            case 2:
//                textLocationX = 126;
//                break;
//            case 3:
//                textLocationX = 126;
//                break;
//            case 4:
//                textLocationX = 126;
//                break;
//            case 5:
//                textLocationX = 126;
//                break;
//            case 6:
//                textLocationX = 126;
//                break;
//            case 7:
//                textLocationX = 127;
//                break;
//            case 8:
//                textLocationX = 127;
//                break;
//            case 9:
//                textLocationX = 127;
//                break;
//            case 10:
//                textLocationX = 127;
//                break;
//            case 11:
//                textLocationX = 127;
//                break;
//            default:
//                textLocationX = 127;
//                break;
//        }
//
//        return textLocationX;
        return timeLabelWidth - 27;
    }

//    function updateTimeLabel() {
//        var timeString = Lang.format("$1$:$2$:$3$", [hour, minute, second]);
//        if (!is24Hour) {
//            timeString = Lang.format("$1$ $2$", [timeString, hoursBucket]);
//        }
//
//        var view = View.findDrawableById("TimeLabel");
//        view.setText(timeString);
//
//        // Call the parent onUpdate function to redraw the layout
//        View.onUpdate(dc);
//    }

//    // Called when this View is removed from the screen. Save the
//    // state of this View here. This includes freeing resources from
//    // memory.
//    function onHide() {
//    }
//
//    // The user has just looked at their watch. Timers and animations may be started here.
//    function onExitSleep() {
//    }
//
//    // Terminate any active timers and prepare for slow updates.
//    function onEnterSleep() {
//    }
}
