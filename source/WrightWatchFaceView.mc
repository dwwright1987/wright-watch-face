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
    var hoursBucket;
    var secondsLocX;

    function initialize() {
        WatchFace.initialize();
    }

    function onLayout(dc) {
        setLayout(Rez.Layouts.WatchFace(dc));
    }

    function onPartialUpdate(dc) {
        updateSeconds(dc);
    }

    function onUpdate(dc) {
        dc.clearClip();

        var timeLabelDrawable = updateTime();
        updateBatteryPercentage();

        View.onUpdate(dc);

        secondsLocX = calculateSecondsLocationX(timeLabelDrawable, hoursBucket);
    }

    function updateTime() {
        var clockTime = Sys.getClockTime();
        var is24Hour = Sys.getDeviceSettings().is24Hour;

        var hour = clockTime.hour;
        hoursBucket = "";
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

        var time = Lang.format("$1$:$2$:$3$", [hour, minute, seconds]);
        if (!is24Hour) {
            time = Lang.format("$1$ $2$", [time, hoursBucket]);
        }

        var timeLabelDrawable = View.findDrawableById("TimeLabel");
        timeLabelDrawable.setText(time);

        return timeLabelDrawable;
    }

    function calculateSecondsLocationX(timeLabelDrawable, hoursBucket) {
        var secondsLococationX = timeLabelDrawable.locX + Math.round(timeLabelDrawable.width / 2.0);
        if (hoursBucket == PM_HOURS_BUCKET) {
            secondsLococationX -= 70;
        } else {
            secondsLococationX -= 72;
        }

        return secondsLococationX;
    }

    function updateBatteryPercentage() {
        var battery = System.getSystemStats().battery.format("%.0d");
        var batteryPercentage = Lang.format("$1$%", [battery]);

        var timeLabelDrawable = View.findDrawableById("BatteryPercentage");
        timeLabelDrawable.setText(batteryPercentage);
    }

    function updateSeconds(dc) {
        var textLocationX = secondsLocX;
        var textLocationY = 101;

        var clipHeight = 35;
        var clipWidth = 35;
        var clipX = textLocationX - 16;
        var clipY = textLocationY;

        dc.setClip(clipX, clipY, clipWidth, clipHeight);
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_BLACK);

        var second = Sys.getClockTime().sec.format("%02d");
        dc.drawText(textLocationX, textLocationY, Gfx.FONT_NUMBER_MILD, second, Gfx.TEXT_JUSTIFY_CENTER);
    }
}
