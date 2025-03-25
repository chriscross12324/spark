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
  'SE 410': {
    'SE410A': {'lastName': "Bennett", 'status': 'Online'},
    'SE410B': {'lastName': "Dalton", 'status': 'Offline'},
    'SE410C': {'lastName': "Harper", 'status': 'Online'},
    'SE410D': {'lastName': "McNab", 'status': 'Online'},
  },
  'SE 430': {
    'SE430A': {'lastName': "Griffin", 'status': 'Online'},
    'SE430B': {'lastName': "Bishop", 'status': 'Online'},
    'SE430C': {'lastName': "Stevens", 'status': 'Online'},
    'SE430D': {'lastName': "Martens", 'status': 'Online'},
  },
  'Monashee A': {
    'A1': {'lastName': "Donovan", 'status': 'Offline'},
    'A2': {'lastName': "Foster", 'status': 'Notification'},
    'A3': {'lastName': "Reynolds", 'status': 'Online'},
    'A4': {'lastName': "Dixon", 'status': 'Notification'},
    'A5': {'lastName': "Anderson", 'status': 'Online'},
  },
  'Val B': {
    'B1': {'lastName': "Caldwell", 'status': 'Online'},
    'B2': {'lastName': "Carson", 'status': 'Offline'},
    'B3': {'lastName': "Quinn", 'status': 'Offline'},
    'B4': {'lastName': "Harrington", 'status': 'Online'},
    'B5': {'lastName': "Sullivan", 'status': 'Offline'},
  },
};
