const startTimeKey = "start_time";
const pauseTimeKey = "pause_time";
const stopTimeKey = "stop_time";

const hour = 60 * 60;
const minute = 60;

class utils {
  static String timeFormat(int count) {
    // 秒转换为 00:00:00
    var timeHour = count ~/ hour;
    var timeMinute = (count - timeHour * hour) ~/ minute;
    var timeSecond = count - timeHour * hour - timeMinute * minute;
    return "${timeHour.toString().padLeft(2, "0")}:${timeMinute.toString().padLeft(2, "0")}:${timeSecond.toString().padLeft(2, "0")}";
  }
}
