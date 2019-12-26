import 'package:date_utils/date_utils.dart';
import 'package:test/test.dart';

void main() {
  group('Utils Tests', () {
    test('firstDayInMonth Sept 30 2018', () {
      var date = new DateTime(2018, 9, 30);
      var lastDay = Utils.firstDayOfMonth(date);
      var expected = new DateTime(2018, 9, 1);
      expect(lastDay, expected);
    });

    test('lastDayInMonth', () {
      var date = new DateTime(2017, 3);
      var lastDay = Utils.lastDayOfMonth(date);
      var expected = new DateTime(2017, 3, 31);
      expect(lastDay, expected);
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

    group('daysInMonth', () {
      _assertDaysInMonth(
          {DateTime date, DateTime first, DateTime last, int length}) {
        var days = Utils.daysInMonth(date);
        expect(days.first, first);
        expect(days.last, last);
        expect(days.length, length);
      }

      test('9 30 2018', () {
        _assertDaysInMonth(
          date: new DateTime(2018, 9, 30),
          first: new DateTime(2018, 8, 26),
          last: new DateTime(2018, 10, 6),
          length: 42,
        );
      });
      test('8 30 2018', () {
        _assertDaysInMonth(
          date: new DateTime(2018, 8, 8),
          first: new DateTime(2018, 7, 29),
          last: new DateTime(2018, 9, 1),
          length: 35,
        );
      });
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

  group('Locale for weekdays', () {
    setUpAll(() => Utils.setLocale('en'));

    test('locale in Default', () {
      expect(Utils.locale, 'en');
    });
    test('locale in English', () {
      Utils.setLocale('en');
      expect(Utils.locale, 'en');
    });
    test('locale in English and Weekdays in English', () {
      expect(Utils.weekdays, const ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]);
    });

    test('locale in Korean', () {
      Utils.setLocale('ko');
      expect(Utils.locale, 'ko');
    });

    test('locale in English (set) and Weekdays in English', () {
      Utils.setLocale('en');
      expect(Utils.weekdays, const ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]);
    });

    test('locale in Korean and Weekdays in Korean', () {
      Utils.setLocale('ko');
      expect(Utils.weekdays, const [ "일","월","화","수","목","금","토"]);
    });

    test('illegal locale is fallback to English', () {
      Utils.setLocale('ILLEGAL LOCALE');
      expect(Utils.locale, 'en');
      expect(Utils.weekdays, const ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]);
    });
  });
}
