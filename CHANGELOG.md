## 1.1.16

- fix: exclude MadhabExtensions from exporting. **madhab.getShadowLength()** should not accessible outside.

## 1.1.15

- feat: added support for maghribAngle. PR#13

## 1.1.14

- docs: added Documentation for SunnahTimes and Qibla.
- docs: API Docs.

## 1.1.13

- feat: added Turkey Method.

## 1.1.12

- feat: added Coordinates Validation Support [Optional].

## 1.1.11

- test: 100% test coverage!
- docs: Readme Fixes.

## 1.1.10

- fix: Umma Al Qura and Qatar Method Params Bug Fixes.
- test: Test Prayer Times in Wide Range Locations From JSON Data.

## 1.1.9

- Example updates

## 1.1.8

- added PrayerTimes.today helper factory, so you don't have to manage `DateComponents` for Today's Times.
- added adhan bin, so you can run `pub run adhan` in cli to test quickly.
- docs and readme updates.

## 1.1.7

- added Flutter Example in /example folder.
- added utc and utcOffset quick helper factory in PrayerTimes.

## 1.1.6

- added Sunnah Times and Qibla.
- Code Improvements.

## 1.1.5

- added Docs/Modified(as Dart Standard) in Codes for Public APIs.

## 1.1.4

- made lightweight to use. removed external dependencies, so it has lower method overhead.

## 1.1.3

- update readme

## 1.1.2

- update package description
- format all files via dartfmt -w bin lib test

## 1.1.1

- Timezone Problem Fixes, Now PrayerTimes values will be default in Local time, to get a different timezone than Local you can set utcOffset named optional params.
- Bug Fixes

## 1.0.1

- Readme update

## 1.0.0

- Initial version, created by Riajul
