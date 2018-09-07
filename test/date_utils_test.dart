import 'package:date_utils/date_utils.dart';
import 'package:test/test.dart';

void main() {
  group('Utils Tests', () {
    test('lastDayInMonth', () {
      var date = new DateTime(2017, 3);
      var lastDay = Utils.lastDayOfMonth(date);
      var expected = new DateTime(2017, 3, 31);
      expect(lastDay, expected);
    });

    test('formatMonthWorksCorrectly', () {
      var dateString = Utils.formatMonth(new DateTime(2017, 3));
      var expected = "March 2017";
      expect(dateString, expected);
    });

    test('formatMonthLocalizedWorksCorrectly', () async {
      //For example Dutch language
      await Utils.setLocale('nl_BE');
      var dateString = Utils.formatMonth(new DateTime(2017, 3));
      var expected = "maart 2017";
      expect(dateString, expected);
    });

    test('daysInMonth', () {
      var date = new DateTime(2017, 3);
      var days = Utils.daysInMonth(date);
      expect(days, hasLength(35));
    });

    test('daysInMonthWithTimeChangeFallBack', () {
      var date = new DateTime(2017, 11);
      var days = Utils.daysInMonth(date);
      expect(days, hasLength(35));
    });

    test('daysInMonthWithTimeChangeSpringForward', () {
      var date = new DateTime(2018, 4);
      var days = Utils.daysInMonth(date);
      expect(days, hasLength(42));
    });

    test('isSameWeek', () {
      expect(
          Utils.isSameWeek(new DateTime(2017, 3, 4), new DateTime(2017, 3, 5)),
          false);
      expect(
          Utils.isSameWeek(new DateTime(2017, 3, 5), new DateTime(2017, 3, 6)),
          true);
      expect(
          Utils.isSameWeek(new DateTime(2017, 2, 26), new DateTime(2017, 3, 4)),
          true);
      expect(
          Utils.isSameWeek(new DateTime(2017, 3, 4), new DateTime(2017, 3, 10)),
          false);
      expect(
          Utils.isSameWeek(new DateTime(2017, 3, 3), new DateTime(2017, 3, 10)),
          false);
      expect(
          Utils.isSameWeek(
              new DateTime(2017, 3, 10), new DateTime(2017, 3, 10)),
          true);
      expect(
          Utils.isSameWeek(
              new DateTime(2018, 3, 29, 12), new DateTime(2018, 3, 22, 12)),
          false);
      expect(
          Utils.isSameWeek(
              new DateTime(2018, 3, 6, 12), new DateTime(2018, 3, 13, 12)),
          false);
    });

    List<DateTime> testDates = [];
    DateTime today;

    setUp(() {
      today = new DateTime.now();
      // A full Calendar Week
      testDates
        ..add(new DateTime(2018, 3, 4))
        ..add(new DateTime(2018, 3, 5))
        ..add(new DateTime(2018, 3, 6))
        ..add(new DateTime(2018, 3, 7))
        ..add(new DateTime(2018, 3, 8))
        ..add(new DateTime(2018, 3, 9))
        ..add(new DateTime(2018, 3, 10));
    });

    for (var i = 0; i < 7; i++) {
      test('Utils.firstDayOfWeek', () {
        expect(Utils.firstDayOfWeek(testDates[i]).day, testDates[0].day);
      });
    }

    for (var i = 0; i < 7; i++) {
      test('Utils.lastDayOfWeek', () {
        expect(Utils.lastDayOfWeek(testDates[i]).day,
            testDates[6].add(new Duration(days: 1)).day);
      });
    }

    // Test 100 Days for the right length
    for (var i = 0; i < 100; i++) {
      test('datesInRange()', () {
        var date = new DateTime.now();
        date.add(new Duration(days: i));

        var firstDayOfCurrentWeek = Utils.firstDayOfWeek(today);
        var lastDayOfCurrentWeek = Utils.lastDayOfWeek(today);

        expect(
            Utils.daysInRange(firstDayOfCurrentWeek, lastDayOfCurrentWeek)
                .toList()
                .length,
            7);
      });
    }
  });
}
