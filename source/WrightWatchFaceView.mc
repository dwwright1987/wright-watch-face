using Toybox.Graphics as Gfx;
using Toybox.Math;
using Toybox.Lang;
using Toybox.System;
using Toybox.Time;
using Toybox.Time.Gregorian;
using Toybox.WatchUi;

class WrightWatchFaceView extends WatchUi.WatchFace {
    const AM_HOURS_BUCKET = "AM";
    const PM_HOURS_BUCKET = "PM";
    const MAX_12_HOUR_HOURS = 12;
    const MIN_24_HOUR_HOURS = 00;
    var garminLogo;
    var hoursBucket;
    var launcherIcon;
    var secondsLocX;

    function initialize() {
        WatchFace.initialize();
    }

    function onLayout(dc) {
        setLayout(Rez.Layouts.WatchFace(dc));

        garminLogo = WatchUi.loadResource(Rez.Drawables.GarminLogo);
        launcherIcon = WatchUi.loadResource(Rez.Drawables.LauncherIcon);
    }

    function onPartialUpdate(dc) {
        updateSeconds(dc);
    }

    function onUpdate(dc) {
        dc.clearClip();

        var timeLabelDrawable = updateTime();
        updateDate();
        updateBatteryPercentage();

//        var mySmiley = new Rez.Drawables.LauncherIcon();
//        mySmiley.draw(dc);
//        var catgif = WatchUi.loadResource(Rez.Drawables.LauncherIcon);
//        dc.drawBitmap(120, 175, launcherIcon);

        View.onUpdate(dc);

        dc.drawBitmap(90, 215, garminLogo);
//        dc.drawBitmap(90, 205, launcherIcon);

        secondsLocX = calculateSecondsLocationX(timeLabelDrawable, hoursBucket);
    }

    function updateTime() {
        var clockTime = System.getClockTime();
        var is24Hour = System.getDeviceSettings().is24Hour;

        var hour = clockTime.hour;
        hoursBucket = "";
        if (!System.getDeviceSettings().is24Hour) {
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

    function updateDate() {
        var today = Gregorian.info(Time.now(), Time.FORMAT_MEDIUM);
        var formattedDate = Lang.format("$1$ $2$, $3$", [today.month, today.day, today.year]);

        var dateLabelDrawable = View.findDrawableById("DateLabel");
        dateLabelDrawable.setText(formattedDate);
    }

    function updateBatteryPercentage() {
        var battery = System.getSystemStats().battery;
        var formmattedBattery = battery.format("%.0d");
        var batteryPercentage = Lang.format("$1$%", [formmattedBattery]);

        var batteryPercentageDrawable = View.findDrawableById("BatteryPercentage");
        batteryPercentageDrawable.setText(batteryPercentage);

        if (battery <= 15) {
            batteryPercentageDrawable.setColor(Gfx.COLOR_RED);
        } else if (battery <= 30) {
            batteryPercentageDrawable.setColor(Gfx.COLOR_YELLOW);
        } else {
            batteryPercentageDrawable.setColor(Gfx.COLOR_GREEN);
        }
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

        var second = System.getClockTime().sec.format("%02d");
        dc.drawText(textLocationX, textLocationY, Gfx.FONT_NUMBER_MILD, second, Gfx.TEXT_JUSTIFY_CENTER);
    }
}
