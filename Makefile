.PHONY: setup gen check format analyze test run build

setup:
	flutter pub get
	dart run build_runner build --delete-conflicting-outputs

gen:
	dart run build_runner watch --delete-conflicting-outputs

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

run:
	flutter run

build:
	flutter build apk --release
