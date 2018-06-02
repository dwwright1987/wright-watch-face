using Toybox.Graphics;
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
    var bluetoothConnectedDrawable;
    var bluetoothDisconnectedDrawable;
    var currentBluetoothDrawable;
    var hoursBucket;
    var messageDrawable;
    var messageDrawableDrawn = false;
    var secondsLocX;
    var timeLabelLocY = 101;

    function initialize() {
        WatchFace.initialize();
    }

    function onLayout(dc) {
        bluetoothDisconnectedDrawable = WatchUi.loadResource(Rez.Drawables.BluetoothDisconnected);
        bluetoothConnectedDrawable = WatchUi.loadResource(Rez.Drawables.BluetoothConnected);
        messageDrawable = WatchUi.loadResource(Rez.Drawables.Message);

        setLayout(Rez.Layouts.WatchFace(dc));
    }

    function onPartialUpdate(dc) {
        updateSeconds(dc);
        updateBluetoothDrawable(dc, false);
        updateMessageDrawable(dc, false);
    }

    function onUpdate(dc) {
        dc.clearClip();

        updateDate();
        updateBatteryPercentage();

        View.onUpdate(dc);

        var timeLabel = buildTimeLabel();
        var timeLabelDrawable = updateTimeLabelDrawable(dc, timeLabel);

        updateBluetoothDrawable(dc, true);
        updateMessageDrawable(dc, true);

        secondsLocX = calculateSecondsLocationX(timeLabelDrawable, hoursBucket);
    }

    function buildTimeLabel() {
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

        var timeLabel = Lang.format("$1$:$2$:$3$", [hour, minute, seconds]);
        if (!is24Hour) {
            timeLabel = Lang.format("$1$ $2$", [timeLabel, hoursBucket]);
        }

        return timeLabel;
    }

    function updateTimeLabelDrawable(dc, timeLabel) {
        var timeLabelDrawable = new WatchUi.Text({
            :text=>timeLabel,
            :color=>Graphics.COLOR_WHITE,
            :font=>Graphics.FONT_NUMBER_MILD,
            :justification=>Graphics.TEXT_JUSTIFY_CENTER,
            :locX=>dc.getWidth() / 2,
            :locY=>timeLabelLocY,
            :identifier=>"TimeLabel"
        });
        timeLabelDrawable.draw(dc);

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
            batteryPercentageDrawable.setColor(Graphics.COLOR_RED);
        } else if (battery <= 30) {
            batteryPercentageDrawable.setColor(Graphics.COLOR_YELLOW);
        } else {
            batteryPercentageDrawable.setColor(Graphics.COLOR_GREEN);
        }
    }

    function updateBluetoothDrawable(dc, forceDraw) {
        var bluetoothDrawable;
        if (System.getDeviceSettings().phoneConnected) {
            bluetoothDrawable = bluetoothConnectedDrawable;
        } else {
            bluetoothDrawable = bluetoothDisconnectedDrawable;
        }

        if (bluetoothDrawable != currentBluetoothDrawable || forceDraw) {
            dc.clearClip();
            dc.drawBitmap(112, 180, bluetoothDrawable);

            currentBluetoothDrawable = bluetoothDrawable;
        }
    }

    function updateMessageDrawable(dc, forceDraw) {
        var locX = 150;
        var locY = 180;

        if (System.getDeviceSettings().notificationCount > 0 && (!messageDrawableDrawn || forceDraw)) {
            dc.clearClip();
            dc.drawBitmap(locX, locY, messageDrawable);

            messageDrawableDrawn = true;
        } else if (System.getDeviceSettings().notificationCount == 0 && messageDrawableDrawn) {
            dc.clearClip();
            dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
            dc.fillRectangle(locX, locY, messageDrawable.getWidth(), messageDrawable.getHeight());

            messageDrawableDrawn = false;
        }
    }

    function updateSeconds(dc) {
        var textLocationX = secondsLocX;
        var textLocationY = timeLabelLocY;

        var clipHeight = 35;
        var clipWidth = 35;
        var clipX = textLocationX - 16;
        var clipY = textLocationY;

        dc.setClip(clipX, clipY, clipWidth, clipHeight);
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);

        var second = System.getClockTime().sec.format("%02d");
        dc.drawText(textLocationX, textLocationY, Graphics.FONT_NUMBER_MILD, second, Graphics.TEXT_JUSTIFY_CENTER);
    }
}
