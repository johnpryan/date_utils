# date_utils

[![CI](https://github.com/johnpryan/date_utils/workflows/Dart%20CI/badge.svg)](https://github.com/johnpryan/date_utils/actions?query=branch%3Amaster)

A Dart library to manipulate DateTimes. Useful for creating calendar functionality.

# Example

See Packages:

[Tzolkin Web Calendar](https://pub.dartlang.org/packages/tzolkin)

[flutter_calendar](https://github.com/apptreesoftware/flutter_calendar)

# Usage

1. Add the following to your pubspec.yaml:

```yaml
dev_dependencies:
    date_utils: ^0.0.1
```

2. Run `pub install`

3. Import the package in your Dart code

```dart
import 'package:date_utils/date_utils.dart';
```

4. Use the `Utils` class.

```dart
// example
var date = new DateTime(2017, 3);
var lastDay = Utils.lastDayOfMonth(date);
print(lastDay.day);
// => 31
```

