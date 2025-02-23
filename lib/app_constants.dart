// Light Theme Colours

// Dark Theme Colours
import 'dart:ui';

const themeDarkDeepBackground = Color(0xff221916); //0xFF271f1b
const themeDarkBackground = Color(0xff4c3326); //0xff3e2a21
const themeDarkForeground = Color(0xff70503d); //0xff684b38
const themeDarkDivider = Color(0x26684b38); //0x26684b38

const themeDarkPrimaryText = Color(0xFFFFFFFF);
const themeDarkSecondaryText = Color(0xBFFFFFFF);
const themeDarkDimText = Color(0x80FFFFFF);

const themeDarkAccentColourMain = Color(0xFFF7744F);
const themeDarkAccentColourFaded = Color(0xFFB98474);
const themeDarkComplementaryColourMain = Color(0xFF4FD2F7);
const themeDarkComplementaryColourFaded = Color(0xFF74A9B9);

const Map<String, Map<String, Map<String, String>>> crews = {
  'Blaze Breakers': {
    'device_1': {'lastName': "Bennett", 'status': 'Online'},
    'device_2': {'lastName': "Dalton", 'status': 'Offline'},
    'device_3': {'lastName': "Harper", 'status': 'Online'},
  },
  'Smoke Jumpers': {
    'sensor_123': {'lastName': "Griffin", 'status': 'Online'},
    'device_4': {'lastName': "Bishop", 'status': 'Online'},
  },
  'Fire Guardians': {
    'device_5': {'lastName': "Donovan", 'status': 'Offline'},
    'CI016': {'lastName': "Foster", 'status': 'Notification'},
    'CI015': {'lastName': "Reynolds", 'status': 'Online'},
    'CI021': {'lastName': "Dixon", 'status': 'Notification'},
    'CI022': {'lastName': "Anderson", 'status': 'Online'},
  },
  'Flame Fighters': {
    'CI042': {'lastName': "Caldwell", 'status': 'Online'},
    'CI038': {'lastName': "Carson", 'status': 'Offline'},
    'CI031': {'lastName': "Quinn", 'status': 'Offline'},
    'CI051': {'lastName': "Harrington", 'status': 'Online'},
    'CI019': {'lastName': "Sullivan", 'status': 'Offline'},
    'CI045': {'lastName': "Mercer", 'status': 'Notification'},
  },
};
