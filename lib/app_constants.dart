// Light Theme Colours

// Dark Theme Colours
import 'dart:ui';

const themeDarkDeepBackground = Color(0xFF271f1b);
const themeDarkBackground = Color(0xff3e2a21); //0xff352923
const themeDarkForeground = Color(0xff684b38); //0xff45342c
const themeDarkDivider = Color(0x26684b38);

const themeDarkPrimaryText = Color(0xFFFFFFFF);
const themeDarkSecondaryText = Color(0xBFFFFFFF);
const themeDarkDimText = Color(0x80FFFFFF);

const themeDarkAccentColourMain = Color(0xFFF7744F);
const themeDarkAccentColourFaded = Color(0xFFB98474);
const themeDarkComplementaryColourMain = Color(0xFF4FD2F7);
const themeDarkComplementaryColourFaded = Color(0xFF74A9B9);

const Map<String, Map<String, Map<String, String>>> crews = {
  'Blaze Breakers': {
    'CI001': {'lastName': "Bennett", 'status': 'Online'},
    'CI011': {'lastName': "Dalton", 'status': 'Offline'},
    'CI023': {'lastName': "Harper", 'status': 'Online'},
  },
  'Smoke Jumpers': {
    'CI043': {'lastName': "Griffin", 'status': 'Online'},
    'CI031': {'lastName': "Bishop", 'status': 'Online'},
  },
  'Fire Guardians': {
    'CI012': {'lastName': "Donovan", 'status': 'Offline'},
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
