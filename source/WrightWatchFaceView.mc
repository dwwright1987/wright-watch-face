using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Lang as Lang;

class WrightWatchFaceView extends Ui.WatchFace {
    static var AM_HOURS_BUCKET = "AM";
    static var PM_HOURS_BUCKET = "PM";
    static var MAX_12_HOUR_HOURS = 12;
    static var MIN_24_HOUR_HOURS = 00;

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
        // Get and show the current time
        var clockTime = Sys.getClockTime();
        var is24Hour = Sys.getDeviceSettings().is24Hour;

        var hour = clockTime.hour;
        var hoursBucket = "";
        if (!is24Hour) {
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
        var second = clockTime.sec.format("%02d");

        var timeString = Lang.format("$1$:$2$:$3$", [hour, minute, second]);
        if (!is24Hour) {
            timeString = Lang.format("$1$ $2$", [timeString, hoursBucket]);
        }

        var view = View.findDrawableById("TimeLabel");
        view.setText(timeString);

        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
    }

    // Update the view
//    function onUpdate(dc) {
//        // Get and show the current time
//        var clockTime = Sys.getClockTime();
//
//        var timeString = Lang.format("$1$:$2$:$3$", [clockTime.hour, clockTime.min.format("%02d"), clockTime.sec]);
//
//        var view = View.findDrawableById("TimeLabel");
//        view.setText(timeString);
//
//        // Call the parent onUpdate function to redraw the layout
//        View.onUpdate(dc);
//    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() {
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() {
    }
}
