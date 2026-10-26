.PHONY: setup gen check format analyze test run build perf

setup:
	flutter pub get
	dart run build_runner build

gen:
	dart run build_runner watch

format:
	dart format lib test

check:
	dart format --output=none --set-exit-if-changed lib test
	flutter analyze
	flutter test

analyze:
	flutter analyze

test:
	flutter test

perf:
	flutter test test/database/performance_test.dart --dart-define=RUN_PERF=true

run:
	flutter run

build:
	flutter build apk --release
